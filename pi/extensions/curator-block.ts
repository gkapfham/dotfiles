/**
 * curator-block — Prevents the web search curator browser UI from opening.
 *
 * pi-web-access opens a local HTTP server + browser window when its
 * workflow is anything other than "none". The LLM sometimes sends
 * workflow: "summary-review" despite the user's config, and the
 * resolveWorkflow() function also defaults to "summary-review" for
 * unrecognized values.
 *
 * This extension intercepts every web_search tool call and forces
 * workflow to "none" before pi-web-access processes it. The browser
 * never opens, and results stay in the TUI.
 *
 * Requires: pi-web-access (any version)
 * To apply: /reload
 * To verify: ask pi to search something — no browser should appear.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event) => {
    if (event.toolName !== "web_search") return;

    // Force workflow to "none" — this prevents the curator/browser
    // from opening, regardless of what the LLM or config says.
    (event.input as Record<string, unknown>).workflow = "none";
  });
}
