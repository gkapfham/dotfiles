---
description: Search past pi sessions and show results as a table
argument-hint: "<query>"
---

Search my past pi sessions for: $@

Use every session-search tool available in this session, in parallel:
- `session_search` — semantic search over the indexed session summaries
- `search_sessions` — literal substring/keyword search of the transcripts
- `session_list` — browse by project/date when the query is vague

Workflow:
1. Run a semantic search and a literal keyword search with the same
   query. Also try one or two natural synonyms (e.g. "reviewing a PR" ->
   "pull request", "checkout this PR", "PR status").
2. Merge results from all tools and deduplicate by session file path.
3. Drop clearly irrelevant hits (different meaning of the search words).

Output the results as a markdown table with exactly these columns:

| # | Date | Project | Title | Match | Notes |

Rules:
- Date: session start date as YYYY-MM-DD
- Project: the top-level project folder of the session cwd
  (e.g. gatorgrade, dotfiles, zk)
- Title: the session's first user message, truncated to ~60 characters
- Match: how the session was found — "semantic", "literal", or "both"
- Notes: one short line — message count, dominant tools, or why it is
  relevant to the query
- Sort rows by relevance, most relevant first; number them 1..N

If the query is empty or vague, use `session_list` to show the 10 most
recent sessions in the same table format instead, and say the query was
too vague.

If no sessions match, say so clearly and suggest a broader query.

After the table, ask if the user wants to read the full conversation from
any listed session (using `session_read` or `read_session`).
