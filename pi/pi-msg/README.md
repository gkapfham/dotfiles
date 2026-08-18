# pi-msg + XMPP — portable setup

Drive the [pi coding agent](https://pi.dev) from a phone via XMPP.
This directory contains everything needed to set up:

- **an XMPP server** (`ejabberd`) with TLS,
- **pi-msg** (the bridge that runs `pi --mode rpc` and relays it to chat),
- a **systemd service** that keeps it running,
- **Conversations** (Android) or any XMPP client as the remote control.

It is tested on NixOS (this laptop) and targets Debian/Ubuntu for other
machines. Everything is template-based: **one file is edited** (`config.env`).

## What's in here

| File | Purpose |
|---|---|
| `config.env.example` | the single config to edit (domain, accounts, passwords, model, workdir) |
| `ejabberd.yml.template` | server config; `__DOMAIN__` is substituted by setup |
| `pi-msg.service` | systemd user unit (portable, uses `%h`) |
| `scripts/setup-ubuntu.sh` | one-command setup on Debian/Ubuntu |
| `scripts/setup-nixos.sh` | one-command setup on NixOS |
| `scripts/pick-session.sh` | choose which pi session the bot works in |
| `scripts/pi` | stable launcher for `pi` (npx cache → system) |
| `.gitignore` | keeps secrets out of git |

**No secrets live in this directory.** Passwords, API keys, and the TLS
private key are generated into `~/.config/pi-msg/` (mode 600) at setup time.
Commit this directory as-is; never commit `config.env`, `certs/`, or
anything from `~/.config/pi-msg`.

## Setup on Ubuntu (or any Debian-like machine)

```bash
# 0. Prerequisites: pi must be installed and logged in (npx @earendil-works/pi-coding-agent)
#    and the phone must be able to reach this machine (same LAN or a VPN like NetBird).

# 1. Clone the dotfiles repo, then:
cd pi/pi-msg
cp config.env.example config.env
# 2. Edit config.env — set DOMAIN (e.g., the VPN hostname), accounts, MODEL, WORKDIR
#    (passwords can stay empty: they are auto-generated)
bash scripts/setup-ubuntu.sh
```

The script installs ejabberd + mkcert (sudo), generates the TLS certificate,
writes `/etc/ejabberd/ejabberd.yml`, registers the two accounts, builds
pi-msg (a private Go 1.26+ is installed only if needed), and starts the
bridge as a user service.

> **Re-running setup is safe.** Account registration is idempotent (new
> accounts are created, existing ones updated), and passwords are saved to
> `~/.config/pi-msg/passwords.txt` and reused on re-runs — no purge needed.

> Bridge-only mode: set `ENABLE_SERVER="no"` and `SERVICE="<server>:5222"`
> to attach another machine's pi to an existing XMPP server — no root needed.

## Setup on NixOS

1. Add the server to the NixOS config: `services.ejabberd = { enable = true; configFile = ./ejabberd.yml; }`
   with `ejabberd.yml` from this directory (see the laptop's `~/configure/nixos/` repo).
1. Then run the NixOS setup script (it installs the cert, rebuilds with
   `nh os switch`, registers the accounts, and starts the bridge):

```bash
bash scripts/setup-nixos.sh
```

## Phone (Conversations)

1. **Add account** (not "register" — accounts are pre-created):
   `username / domain / password` from the setup output.
1. On the certificate warning tap **Trust** (one time).
1. If the domain doesn't resolve on the phone, set the **server host** to
   the machine's VPN/LAN IP (the certificate covers both).
1. **Add contact** `pi@<DOMAIN>` and send a message. The bot shows
   `listening` / `thinking…` / `dnd` while working.

## Chat commands

| Message | Becomes |
|---|---|
| plain text | a prompt to the agent |
| `/new` | fresh session (resets context) |
| `/compact` | compact context |
| `/model <pattern>` | switch model |
| `/think <level>` | set thinking level |
| `/abort` / `/stop` | stop the current run |
| `/dump` | send the session transcript |
| `/quit` | stop the bridge |

## Session picking

The bot always continues **one** pi session (stored in
`~/.config/pi-msg/default.session`, updated automatically). To point it at a
different session — e.g. a conversation had in a terminal — run:

```bash
bash scripts/pick-session.sh
```

Only pick sessions that are not open in a terminal right now (one writer at
a time).

## Changing the passwords

Run `bash scripts/change-password.sh` — it updates the ejabberd accounts, the
bridge config, the saved copy (`~/.config/pi-msg/passwords.txt`), and restarts
the service in one step, so the bot stays reachable. Manual recipe: `sudo -u
ejabberd ejabberdctl change_password <user> <DOMAIN> <new>`, then update
`accounts.default.password` in `~/.config/pi-msg/config.json`, then
`systemctl --user restart pi-msg`.

## Troubleshooting

- `systemctl --user status pi-msg` and `journalctl --user -u pi-msg -f`
- `sudo systemctl status ejabberd`
- Certificate problems: `echo | openssl s_client -connect 127.0.0.1:5222 -starttls xmpp -CAfile ~/.config/pi-msg/certs/ca-bundle.pem`
  should end with `Verify return code: 0 (ok)`.
- "Registration is not supported by server" on the phone is **normal** —
  in-band registration is off by design; log in with the existing account.
- **Messages to the bot fail (red "!" in Conversations)** — usually the
  bridge's stored bot password no longer matches the server (e.g. after
  `change_password`). Verify with `sudo -u ejabberd ejabberdctl check_account
  pi <DOMAIN>; echo $?` (the result is the **exit code**: 0 = account exists,
  1 = not found) and `check_password pi <DOMAIN> '<pw in config.json>'`; if
  they disagree, run `bash scripts/change-password.sh`.
- **Phone can't resolve the domain** — if `netbird status` shows
  `Nameservers: 0/0`, NetBird DNS is off; set the account's server host to
  the machine's NetBird IP **and** add that IP to `CERT_HOSTS` in
  `config.env` so the certificate covers it.
