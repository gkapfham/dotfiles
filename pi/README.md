# pi configuration (portable)

Your pi coding agent configuration, portable across machines:

| Path in this repo | Installs to (on a new machine) |
|---|---|
| `extensions/*.ts` (+ `pi-tracker/`) | `~/.pi/agent/extensions/` |
| `skills/*` | `~/.pi/agent/skills/` |
| `settings.json` | `~/.pi/agent/settings.json` (template — edit after copy) |
| `repos.json` | `~/.config/pi/repos.json` |
| `pi-msg/` | see `pi-msg/README.md` (XMPP bridge + server setup) |

## On a new machine (or restoring this one)

The repo is the **seed**: apply it to the live install, then pi auto-installs
any plugins listed in `settings.json` on its next startup.

```bash
bash pi/apply-config.sh          # copies settings.json, extensions/, skills/ -> ~/.pi/agent
cd ~/.pi/agent/skills/google-workspace && npm install   # only for the google-workspace skill
cp pi/repos.json ~/.config/pi/repos.json                # pi's repo list
cd pi/pi-msg && cp config.env.example config.env && bash scripts/setup.sh   # XMPP bridge
```

## What's tracked here vs. what's ephemeral

This directory version-controls **your** pi configuration — not plugin
content. The boundary:

| Tracked in this repo | Lives on the machine (NOT tracked) |
|---|---|
| `settings.json` (the plugin **manifest**) | `~/.pi/agent/npm/` — installed plugin packages; pi installs them automatically from the manifest in `settings.json` |
| `extensions/*.ts` (hand-written) | `~/.pi/agent/sessions/`, `tau-instances/` — session/state data |
| `skills/*` | `~/.pi/agent/auth.json`, `analytics/`, logs — credentials + ephemeral state |
| `repos.json` | `~/.config/pi/web-search-cache/` — plugin cache |
| `pi-msg/` (the XMPP kit) | `~/.config/pi-msg/` — generated config, secrets, certs |

**Rules that keep this safe:**

- `make` never deletes pi directories (`create-pi` only does `mkdir -p`;
  `stow-pi` links only `repos.json` via `.stow-local-ignore`).
- Nothing under `~/.pi/agent` is symlinked from the repo, because pi and
  plugins rewrite it (`pi install` updates `settings.json`; plugins add
  `.disabled` files; packages land in `npm/`). Symlinking would couple
  plugin installs to your git repo.
- On a new machine: copy `settings.json`, `extensions/`, `skills/` into
  `~/.pi/agent/` (see commands above) — pi auto-installs every package
  listed in `settings.json` on first run.

## The workflow — two directions, two commands

Your pi config lives in two places, and nothing syncs automatically:

| Direction | Command | When to use it |
|---|---|---|
| **Live → repo** (snapshot) | `bash pi/sync-config.sh` | after you change/install things on this machine — before committing |
| **Repo → live** (apply/seed/restore) | `bash pi/apply-config.sh` | on a new machine after cloning, or to restore this laptop from a commit |

**Save changes (this laptop):**

```bash
# 1. Make your changes (pi install npm:some-plugin, edit an extension, add a skill).
#    The LIVE files under ~/.pi/agent/ are what pi actually uses.

# 2. Snapshot the live config INTO the repo:
bash pi/sync-config.sh

# 3. Review and commit:
cd ~/configure/dotfiles
git add pi/
git diff --cached --stat     # sanity check: should only be pi/* files
git commit -m "Update pi config"
```

**Apply the repo (another machine / restore):**

```bash
bash pi/apply-config.sh      # copies repo -> ~/.pi/agent (settings.json, extensions, skills)
```

Notes:

- Run `sync-config.sh` **after** installing/removing plugins — `pi install`
  rewrites `settings.json` (the manifest) and you want that captured.
- Never edit the repo copy directly and expect it to apply — pi only reads
  `~/.pi/agent/settings.json`.
- `apply-config.sh` overwrites the live files with the repo versions and asks
  for confirmation first (`--yes` skips the prompt).
- `make` is NOT involved: it only links `repos.json` and never touches
  `~/.pi/agent` (by design — see below).
- If you create `pi/pi-msg/config.env` locally, it is gitignored (see
  `pi-msg/.gitignore`); real secrets live in `~/.config/pi-msg/`.

## Never commit

Anything containing secrets stays out of git:

- `~/.config/pi-msg/` (config.json, passwords, env, certs/)
- `~/.pi/agent/auth.json`, `sessions/`, `tau-instances/`, `*.sqlite*`
- `config.env` (if you created it here) — the `.gitignore` in `pi-msg/` protects the subdir; keep runtime secrets under `~/.config/pi-msg/`.
