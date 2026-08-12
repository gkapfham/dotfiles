# Global pi Conventions

## Nerd Font Icons (No Emojis)

Use **Nerd Font icons** (NF set, e.g.,               󰄶                    󱥸    etc.) in all output — status indicators, TODO lists, file trees, notifications, and any UI elements.

Do **not** use Unicode emoji characters (✅ ❌ 🚀 🎉 🔧 📝 etc.) anywhere. Nerd Font alternatives should be used instead.

This applies globally across every project, session, and task context.

## Mobile / XMPP Interaction (Conversations App on Android)

When the user is chatting through XMPP (the Conversations app on their
Android phone), the terminal-oriented Nerd Font conventions do not apply:

- **Use emojis, not Nerd Font icons.** Nerd Font glyphs do not render on the
  phone and show up as blank boxes. The user explicitly requested emojis
  (✅ 🚀 📎 etc.) for phone conversations.
- **Send links as bare, single-line URLs with no markdown formatting.**
  Bold (`**...**`), inline code (backticks), and surrounding emoji or text
  break link detection in the Conversations app. Put the full URL alone on
  its own line so it is tappable.
- Keep messages concise; the phone renders long blocks poorly.

## File Reading and Editing

Use the **`read`** tool for reading files. It handles both text and images
without extra ceremony. The `hashline_read` / `hashline_edit` workflow is
only needed when you cannot match a unique `oldText` anchor for the `edit`
tool (e.g., editing generated/boilerplate code with many identical lines).
In practice, `read` + `edit` with `oldText`/`newText` covers nearly every
situation — prefer that combination as the default.

## Zellij Notification Instructions

When notifying the user within a Zellij session, use `zjstatus::notify` to display
messages in the status bar. Notifications must auto-clear after a brief delay
— they should not persist until the user switches panes.

The correct two-step pattern is:

```bash
# Step 1: Send the notification
timeout 2 zellij pipe -- "zjstatus::notify::󰵰 <message>." 2>/dev/null

# Step 2: Wait for the show_interval to expire, then trigger a re-render
# via zjstatus::pipe::clear which mutates plugin state and forces a visual refresh.
timeout 8 bash -c "sleep 6 && zellij pipe -- 'zjstatus::pipe::clear:: '" 2>/dev/null || true
```

The two steps must be **separate bash tool calls** — do not chain them with `&&`
in a single call. The \`sleep\` in Step 2 blocks that call while the agent
finishes its other completion work (notify-send, final report, etc.).

**How it works:**
1. The `notify` command stores the message and sets `received_at = now` in
   the notification widget.
2. After `show_interval + 1` seconds (config is `notification_show_interval "1"`
   in `config.kdl`; add 1s buffer for the strict less-than timestamp check),
   Step 2 sends `zjstatus::pipe::clear:: ` which inserts into `state.pipe_results`
   — a guaranteed state mutation — and sets `should_render = true`.
3. Zellij re-renders the plugin. The notification widget checks
   `received_at + show_interval < now`, finds the interval has expired, and
   switches to the empty "no notifications" format.

**Why this approach:**
- `zjstatus::notify::` has no `clear` or `dismiss` sub-command in the pipe
  protocol. There is no native Zellij action to clear plugin notifications.
- `zjstatus::rerun::dummy` with a non-existent command returns early without
  mutating state — Zellij may skip the visual re-render when no state changed.
- `zjstatus::pipe::<name>::<data>` always inserts into `state.pipe_results`
  (real state mutation), reliably forcing a re-render.

**Important notes:**
- Do NOT use `nohup` or background processes (`&`) for the clear step —
  backgrounded processes don't survive the agent's bash tool execution.
- The \`sleep\` duration should be at least `show_interval + 1` seconds. With
  the current config value of `"1"`, use `sleep 2`. The `sleep 6` above is
  conservative and works regardless of whether the session has been restarted
  to pick up config changes.
- If zjstatus is not available (not in a Zellij session), both commands will
  silently fail due to `2>/dev/null`.
- The fallback (no auto-clear) is:
  `timeout 2 zellij pipe -- "zjstatus::notify::󰵰 <message>. "`
