/**
 * /editor command - open the current message in your external editor ($EDITOR, e.g. nvim)
 *
 * Usage:
 * 1. Save this file to ~/.pi/agent/extensions/editor-command.ts
 * 2. Run /reload in pi (or restart pi)
 * 3. Type /editor to open Neovim (or whatever $EDITOR is set to)
 * 4. Write your message, save (:w), and quit (:q)
 * 5. The content appears in pi's editor ready to submit
 *
 * ── Why this is not a naive `spawn({ stdio: "inherit" })` ────────────────────
 * pi's TUI keeps the terminal in raw mode, the Kitty keyboard protocol active,
 * bracketed-paste enabled, and the cursor hidden, and it continuously reads
 * stdin to drive its own editor. Spawning nvim on top of that with shared
 * stdio makes BOTH pi and nvim read the same keystrokes and BOTH write escape
 * sequences to the same terminal → garbled display + dropped input.
 *
 * This extension temporarily hands the terminal over to the editor by:
 *   - pausing pi's stdin so it stops competing for keystrokes
 *   - switching stdin out of raw mode
 *   - popping the Kitty keyboard protocol / modifyOtherKeys
 *   - disabling bracketed paste and re-showing the cursor
 * then spawns nvim, and reverses everything on exit, forcing a full repaint.
 * This is the same protocol pi itself uses in Terminal.stop()/start().
 */

import { type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { spawn } from "node:child_process";
import { mkdtempSync, writeFileSync, readFileSync, unlinkSync, rmdirSync } from "node:fs";
import { join } from "node:path";
import { tmpdir } from "node:os";

// Kitty keyboard protocol flags pi requests: disambiguate | event-types | alternate-keys
const KITTY_FLAGS = 7;
const KITTY_ENABLE = `\x1b[>${KITTY_FLAGS}u\x1b[?u`;
const KITTY_DISABLE = "\x1b[<u";
const DISABLE_MODIFY_OTHER_KEYS = "\x1b[>4;0m";
const ENABLE_BRACKETED_PASTE = "\x1b[?2004h";
const DISABLE_BRACKETED_PASTE = "\x1b[?2004l";
const SHOW_CURSOR = "\x1b[?25h";
const HIDE_CURSOR = "\x1b[?25l";

export default function editorCommandExtension(pi: ExtensionAPI) {
	pi.registerCommand("editor", {
		description: "Open message in external editor ($EDITOR, defaults to nvim)",
		handler: async (_args, ctx) => {
			if (ctx.mode !== "tui") {
				ctx.ui.notify("/editor requires interactive mode", "error");
				return;
			}

			// Determine editor
			const editor = process.env.EDITOR || process.env.VISUAL || "nvim";

			// Pre-fill the temp file with the text already in pi's editor so the
			// user can keep editing what they started typing.
			const prefill = typeof ctx.ui.getEditorText === "function"
				? (ctx.ui.getEditorText() ?? "")
				: "";

			// Create a temp file
			const tmpDir = mkdtempSync(join(tmpdir(), "pi-editor-"));
			const tmpFile = join(tmpDir, "message.txt");

			try {
				writeFileSync(tmpFile, prefill, "utf-8");

				ctx.ui.notify(`Opening ${editor}... (terminal handed over)`, "info");

				// ── 1. Hand the terminal over to the editor ──
				// Pause pi's stdin first so its StdinBuffer stops receiving data
				// events while nvim owns the terminal.
				const stdin = process.stdin as typeof process.stdin & {
					setRawMode?: (mode: boolean) => void;
					isRaw?: boolean;
				};
				const wasRaw = stdin.isRaw ?? false;
				try {
					stdin.pause();
				} catch {
					// best-effort
				}
				if (typeof stdin.setRawMode === "function") {
					try {
						stdin.setRawMode(false);
					} catch {
						// best-effort
					}
				}
				// Pop Kitty keyboard protocol and modifyOtherKeys so nvim sees a
				// normal terminal. Keep cursor visible for nvim.
				process.stdout.write(KITTY_DISABLE);
				process.stdout.write(DISABLE_MODIFY_OTHER_KEYS);
				process.stdout.write(DISABLE_BRACKETED_PASTE);
				process.stdout.write(SHOW_CURSOR);

				// ── 2. Spawn the editor and wait for it to close ──
				let exitCode = 1;
				try {
					exitCode = await new Promise<number>((resolve, reject) => {
						const child = spawn(editor, [tmpFile], {
							stdio: "inherit",
							shell: false,
						});

						child.on("exit", (code) => resolve(code ?? 1));
						child.on("error", reject);
					});
				} finally {
					// ── 3. Always restore pi's terminal, even on error ──
					if (typeof stdin.setRawMode === "function") {
						try {
							stdin.setRawMode(wasRaw || true);
						} catch {
							// best-effort
						}
					}
					// Re-enable Kitty protocol the same way pi does at startup:
					// push flags then pop-state query. Then re-enable bracketed
					// paste and hide the cursor again for pi's TUI.
					process.stdout.write(KITTY_ENABLE);
					process.stdout.write(ENABLE_BRACKETED_PASTE);
					process.stdout.write(HIDE_CURSOR);

					// Resume pi's stdin so it can read input again.
					try {
						stdin.resume();
					} catch {
						// best-effort
					}

					// Force pi to detect size (SIGWINCH is lost while paused)
					// and repaint over anything nvim left on screen.
					try {
						if (process.platform !== "win32") {
							process.kill(process.pid, "SIGWINCH");
						}
					} catch {
						// best-effort
					}
					// Clear the screen and home the cursor so pi redraws cleanly.
					process.stdout.write("\x1b[2J\x1b[H");
				}

				if (exitCode !== 0) {
					ctx.ui.notify(`${editor} exited with code ${exitCode}`, "warning");
				}

				// ── 4. Read the result back into pi's editor ──
				const content = readFileSync(tmpFile, "utf-8");

				if (content.trim().length === 0 && prefill.trim().length === 0) {
					ctx.ui.notify("No content written, editor closed without saving.", "warning");
					return;
				}

				ctx.ui.setEditorText(content);
				ctx.ui.notify("Message loaded from editor. Submit when ready.", "info");
			} catch (err) {
				const message = err instanceof Error ? err.message : String(err);
				ctx.ui.notify(`Editor error: ${message}`, "error");
			} finally {
				// Clean up temp files
				try {
					unlinkSync(tmpFile);
					rmdirSync(tmpDir);
				} catch {
					// Best-effort cleanup
				}
			}
		},
	});
}