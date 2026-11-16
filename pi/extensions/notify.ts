/**
 * Desktop Notification Extension
 *
 * Sends a native desktop notification when the agent finishes and is waiting for input.
 * Uses OSC 777 escape sequence, so the notification itself needs no external tools.
 *
 * The workspace highlight also needs xdotool and wmctrl; without them the
 * notification still works and the bar simply stays quiet.
 *
 * Supported terminals: Ghostty, iTerm2, WezTerm, rxvt-unicode
 * Not supported: Kitty (uses OSC 99), Terminal.app, Windows Terminal, Alacritty
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Markdown, type MarkdownTheme } from "@earendil-works/pi-tui";
import { execFile } from "node:child_process";
import { promisify } from "node:util";

const exec = promisify(execFile);

// An attention request is a courtesy, never a dependency of the turn, so every
// external call gets a hard timeout and every failure is swallowed.
const execOptions = { timeout: 2000 } as const;

/**
 * Ask the window manager for attention on the terminal window this agent runs in.
 *
 * OSC 777 makes a desktop notification, and a desktop notification does not touch
 * the source window's urgency hint. So under i3 nothing marks the workspace as
 * urgent, and the bar's workspace label stays its normal colour -- a finished
 * agent is easy to miss unless you happen to be watching the notification pop up.
 *
 * Asking for attention closes that gap: i3 marks the workspace urgent, and the
 * bar draws it as the purple label-urgent pill it already implements. Focusing
 * the window clears it again, which is exactly the behaviour wanted -- the
 * highlight survives until the workspace has been looked at.
 *
 * WINDOWID is exported by the X11 terminal for its child shell, so pi inherits it.
 * That only holds while the window that exported it is still the window the shell
 * is drawn in. Inside zellij the pane inherits the environment of the zellij
 * *server*, so WINDOWID names the terminal the session was originally created
 * in -- not the terminal displaying the pane now. Attaching a session somewhere
 * else then makes the bar mark the wrong workspace urgent (or nothing at all,
 * once the original terminal is gone), so under zellij the window is looked up
 * by session name instead. See zellijWindows() below.
 *
 * Everything here is best effort: a missing xdotool or wmctrl, a missing
 * WINDOWID or a non-X11 session must never break the notification itself.
 */

/** Escape a literal string so it can be embedded in a POSIX extended regex. */
const escapeForRegex = (text: string): string => text.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

/**
 * Ids of the X windows that are displaying the given zellij session right now.
 *
 * zellij titles each terminal it is attached to "<session> | <pane title>",
 * e.g. "Web-Gregory-Kapfhammer | Downloads". Anchoring the match on the whole
 * session name followed by zellij's separator is what stops a session called
 * "Web" from also matching "Web-Security-Synapse | Pi": a dash is part of a
 * name, so only whitespace-then-bar (or the bare name) is accepted after it.
 * Asking for every match keeps the one case that matters correct when the same
 * session is attached in more than one terminal: all of them show the agent, so
 * all of them should ask for attention.
 */
const zellijWindows = async (session: string): Promise<string[]> => {
	const pattern = `^${escapeForRegex(session)}([[:space:]]*[|]|$)`;

	try {
		const { stdout } = await exec("xdotool", ["search", "--name", pattern], execOptions);
		return stdout
			.split("\n")
			.map((line) => line.trim())
			.filter((line) => /^\d+$/.test(line));
	} catch {
		// xdotool exits non-zero when nothing matches, which is a normal outcome
		// here: a detached session has no terminal to highlight.
		return [];
	}
};

/**
 * Whether the window still exists. WINDOWID outlives the window it names, and X
 * recycles ids, so a stale value can point at an unrelated window; asking for
 * the window's name first keeps the request off a stranger's window.
 */
const windowExists = async (id: string): Promise<boolean> => {
	try {
		await exec("xdotool", ["getwindowname", id], execOptions);
		return true;
	} catch {
		return false;
	}
};

/** Raise the urgency hint on each window, which is what marks its workspace urgent. */
const demandAttention = (ids: string[]): void => {
	for (const id of ids) {
		try {
			execFile("wmctrl", ["-i", "-r", id, "-b", "add,demands_attention"], execOptions, () => {
				// Ignored on purpose: see above.
			});
		} catch {
			// Ignored on purpose: see above.
		}
	}
};

const requestAttention = async (): Promise<void> => {
	const session = process.env.ZELLIJ_SESSION_NAME;

	if (session) {
		const windows = await zellijWindows(session);

		// Deliberately no WINDOWID fallback here. Inside zellij that value names
		// the session's original terminal, so using it when the session cannot be
		// found would highlight an unrelated workspace -- the bug this lookup
		// exists to avoid. A session that no terminal is displaying has nowhere
		// to ask, and the OSC 777 notification has already covered it.
		if (windows.length > 0) {
			demandAttention(windows);
		}

		return;
	}

	// Not in zellij: the terminal that started pi is genuinely the window this
	// agent runs in, so WINDOWID is the right answer once it is shown to still
	// name a live window.
	const id = process.env.WINDOWID;
	if (!id || !/^\d+$/.test(id)) {
		return;
	}

	if (await windowExists(id)) {
		demandAttention([id]);
	}
};

/**
 * Send a desktop notification via OSC 777 escape sequence.
 */
const notify = (title: string, body: string): void => {
	// OSC 777 format: ESC ] 777 ; notify ; title ; body BEL
	process.stdout.write(`\x1b]777;notify;${title};${body}\x07`);
	void requestAttention();
};

const isTextPart = (part: unknown): part is { type: "text"; text: string } =>
	Boolean(part && typeof part === "object" && "type" in part && part.type === "text" && "text" in part);

const extractLastAssistantText = (messages: Array<{ role?: string; content?: unknown }>): string | null => {
	for (let i = messages.length - 1; i >= 0; i--) {
		const message = messages[i];
		if (message?.role !== "assistant") {
			continue;
		}

		const content = message.content;
		if (typeof content === "string") {
			return content.trim() || null;
		}

		if (Array.isArray(content)) {
			const text = content.filter(isTextPart).map((part) => part.text).join("\n").trim();
			return text || null;
		}

		return null;
	}

	return null;
};

const plainMarkdownTheme: MarkdownTheme = {
	heading: (text) => text,
	link: (text) => text,
	linkUrl: () => "",
	code: (text) => text,
	codeBlock: (text) => text,
	codeBlockBorder: () => "",
	quote: (text) => text,
	quoteBorder: () => "",
	hr: () => "",
	listBullet: () => "",
	bold: (text) => text,
	italic: (text) => text,
	strikethrough: (text) => text,
	underline: (text) => text,
};

const simpleMarkdown = (text: string, width = 80): string => {
	const markdown = new Markdown(text, 0, 0, plainMarkdownTheme);
	return markdown.render(width).join("\n");
};

const formatNotification = (text: string | null): { title: string; body: string } => {
	const simplified = text ? simpleMarkdown(text) : "";
	const normalized = simplified.replace(/\s+/g, " ").trim();
	if (!normalized) {
		return { title: "Ready for input", body: "" };
	}

	const maxBody = 200;
	const body = normalized.length > maxBody ? `${normalized.slice(0, maxBody - 1)}…` : normalized;
	return { title: "π", body };
};

export default function (pi: ExtensionAPI) {
	pi.on("agent_end", async (event) => {
		const lastText = extractLastAssistantText(event.messages ?? []);
		const { title, body } = formatNotification(lastText);
		notify(title, body);
	});
}
