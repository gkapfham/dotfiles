/**
 * Tau QR Extension
 *
 * Local override /tauqr command that displays a QR code directly in the
 * Pi terminal for the Tau mirror URL, using `qrencode` for terminal output.
 *
 * /tauqr — show QR codes for Tau (LAN + NetBird)
 * /taustart — start Tau mirror server
 * /taustop — stop Tau mirror server
 *
 * This is a LOCAL extension — tau-mirror itself is never modified,
 * so upgrades to tau-mirror won't conflict.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execSync } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";

const USER_HOME = process.env.HOME || process.env.USERPROFILE || os.homedir();
const INSTANCES_DIR = path.join(USER_HOME, ".pi", "tau-instances");

/**
 * Find the running Tau instance and get its URLs.
 */
async function getTauInfo(): Promise<{
	mirrorUrl: string;
	netbirdUrl: string | null;
	port: number;
} | null> {
	if (!fs.existsSync(INSTANCES_DIR)) return null;

	const files = fs.readdirSync(INSTANCES_DIR).filter((f) => f.endsWith(".json"));
	for (const file of files) {
		try {
			const info = JSON.parse(fs.readFileSync(path.join(INSTANCES_DIR, file), "utf8"));
			// Check if process is alive (signal 0 = test only)
			try {
				process.kill(info.pid, 0);
			} catch {
				continue;
			}

			// Query Tau's health endpoint for the resolved URLs
			const resp = await fetch(`http://localhost:${info.port}/api/health`);
			if (resp.ok) {
				const data = (await resp.json()) as { mirrorUrl: string; tailscaleUrl?: string };
				return {
					mirrorUrl: data.mirrorUrl,
					netbirdUrl: data.tailscaleUrl ?? null,
					port: info.port,
				};
			}

			return {
				mirrorUrl: `http://localhost:${info.port}`,
				netbirdUrl: null,
				port: info.port,
			};
		} catch {
			continue;
		}
	}

	return null;
}

/**
 * Generate a QR code using qrencode and return the UTF-8 string.
 * Uses -t UTF8 (no forced ANSI colors) so the QR inherits the terminal's
 * default foreground/background — matching the Pi theme naturally.
 */
function generateQR(url: string): string {
	try {
		return execSync(`qrencode -t UTF8 "${url}"`, {
			encoding: "utf8",
			timeout: 5000,
		});
	} catch (e: unknown) {
		const msg = e instanceof Error ? e.message : String(e);
		return `(qrencode failed: ${msg})`;
	}
}

// Suppress Tau's noisy console.log messages (e.g. "[Mirror] Browser client connected")
// from appearing in the Pi conversation. This runs before Tau loads since
// local extensions load before npm packages.
const origLog = console.log;
console.log = (...args: unknown[]) => {
	if (args.length > 0 && typeof args[0] === "string" && args[0].startsWith("[Mirror]")) {
		return; // suppress Tau's internal chatter
	}
	origLog(...args);
};

export default function (pi: ExtensionAPI) {
	pi.registerCommand("tauqr", {
		description: "Show QR code for Tau mirror URL in terminal",
		handler: async (_args, ctx) => {
			const tauInfo = await getTauInfo();

			if (!tauInfo) {
				ctx.ui.notify("Tau mirror server is not running. Start Pi with Tau installed, or use /taustart.", "warning");
				return;
			}

			const { mirrorUrl, netbirdUrl } = tauInfo;

			// LAN QR
			const lanQR = generateQR(mirrorUrl);
			console.log(`\n    LAN — ${mirrorUrl}`);
			console.log(lanQR);

			// NetBird QR (if different from LAN)
			if (netbirdUrl) {
				const netbirdQR = generateQR(netbirdUrl);
				console.log(`\n    NetBird — ${netbirdUrl}`);
				console.log(netbirdQR);
			}

			console.log("  Scan the QR code with your phone camera to open Tau.\n");

			// Also show URL as notification
			ctx.ui.notify(`Tau: ${mirrorUrl}`, "info");
			if (netbirdUrl) {
				ctx.ui.notify(`NetBird: ${netbirdUrl}`, "info");
			}
		},
	});
}
