// File: pi/extensions/agent-registry.ts
//
// Records which session each running pi process is using, so the quickshell bar
// can list the agents that are actually running.
//
// pi exports PI_SESSION_FILE and PI_SESSION_ID, but only to the shell commands
// it spawns -- the values are resolved per command, so they are not in pi's own
// environment and a sibling process cannot read them. pi also keeps no
// pid -> session registry. Nothing outside the process can therefore work out
// which session a running `pi` belongs to, and the bar is left guessing from
// the project's newest session. This extension writes that mapping itself, one
// file per process:
//
//     ~/.pi/agent/agent-registry/<pid>.json
//
//     {
//       "pid": 1234,
//       "sessionFile": "/home/you/.pi/agent/sessions/.../2026-....jsonl",
//       "sessionId": "01a14c38-...",
//       "cwd": "/home/you/configure/dotfiles",
//       "mode": "tui",
//       "state": "working",
//       "updatedAt": "2026-10-18T11:02:33.412Z"
//     }
//
// The file is deleted on session_shutdown, so the directory is normally exactly
// the set of running agents. A record left behind by a killed process is caught
// by the reader, which ignores records whose pid is no longer alive.
//
// `state` answers "is this agent doing anything" directly: working while a run
// is in progress, idle once it has settled and is waiting for input. That is
// more truthful than the reader guessing from the session file's mtime, which
// cannot tell an agent that is thinking from one that has been abandoned.
//
// Kept dependency-free and beside the other user extensions.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const registryDir = path.join(os.homedir(), ".pi", "agent", "agent-registry");
const recordPath = path.join(registryDir, `${process.pid}.json`);

// The session file and id live on the session manager. Both are read
// defensively: a future pi may not have them, and a missing value should cost
// the bar one field rather than break the session.
function sessionRef(ctx) {
    const ref = { sessionFile: null, sessionId: null };

    try {
        const file = ctx?.sessionManager?.getSessionFile?.();
        if (typeof file === "string" && path.isAbsolute(file)) {
            ref.sessionFile = file;
        }
    } catch {
        // Leave it null.
    }

    try {
        const id = ctx?.sessionManager?.getSessionId?.();
        if (typeof id === "string" && id.length > 0) {
            ref.sessionId = id;
        }
    } catch {
        // Leave it null.
    }

    return ref;
}

function write(state, ctx) {
    try {
        fs.mkdirSync(registryDir, { recursive: true });

        const record = {
            pid: process.pid,
            ...sessionRef(ctx),
            cwd: process.cwd(),
            mode: ctx?.mode ?? null,
            state,
            updatedAt: new Date().toISOString(),
        };

        fs.writeFileSync(recordPath, `${JSON.stringify(record)}\n`);
    } catch {
        // The bar is a convenience. Never let a failed write disturb a session.
    }
}

function remove() {
    try {
        fs.rmSync(recordPath, { force: true });
    } catch {
        // Same reasoning: nothing here is worth surfacing to the user.
    }
}

// Nothing is started in the factory: some invocations load extensions without
// starting a session at all.
export default function (pi) {
    pi.on("session_start", (_event, ctx) => {
        // A reload can replace this extension in the middle of a run, in which
        // case there will be no agent_start to wait for.
        write(ctx?.isIdle?.() === false ? "working" : "idle", ctx);
    });

    pi.on("agent_start", (_event, ctx) => {
        write("working", ctx);
    });

    pi.on("agent_settled", (_event, ctx) => {
        // Only the settled state is idle; agent_end can still be followed by
        // retries, compaction, or queued work.
        if (ctx?.isIdle?.() === true) {
            write("idle", ctx);
        }
    });

    pi.on("session_shutdown", () => {
        remove();
    });
}
