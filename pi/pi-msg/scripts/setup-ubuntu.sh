#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# One-command setup for pi-msg (+ optional XMPP server) on Debian/Ubuntu.
#
#   cd pi-msg        # this directory (inside the dotfiles checkout)
#   cp config.env.example config.env
#   # edit config.env  (domain, accounts, passwords, model, workdir)
#   bash scripts/setup-ubuntu.sh
#
# What it does:
#   1. (optional) installs ejabberd + mkcert, generates the TLS certificate,
#      writes /etc/ejabberd/ejabberd.yml, starts the server, registers accounts
#   2. builds pi-msg (installs a private Go 1.26+ only if needed)
#   3. installs a stable `pi` launcher into ~/.local/bin
#   4. writes the pi-msg config + environment (secrets stay OUT of this repo,
#      under ~/.config/pi-msg)
#   5. installs + starts the pi-msg systemd user service
#
# NixOS? This machine's NixOS config already handles it (see README).
# ---------------------------------------------------------------------------
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

if [ ! -f config.env ]; then
  echo "ERROR: config.env not found."
  echo "  cp config.env.example config.env   # then edit it"
  exit 1
fi
# shellcheck disable=SC1090
source config.env

# --- OS detection -----------------------------------------------------------
OS_ID="$(grep -E '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || echo unknown)"
if [ "$OS_ID" = "nixos" ]; then
  echo "This is NixOS — use the existing configuration.nix setup instead (see README)."
  echo "This script targets Debian/Ubuntu."
  exit 1
fi

CONFIG_DIR="$HOME/.config/pi-msg"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$CONFIG_DIR/certs" "$BIN_DIR"

# --- defaults ---------------------------------------------------------------
[ -z "${SERVICE:-}" ] && SERVICE=$([ "${ENABLE_SERVER:-yes}" = "no" ] && echo "$DOMAIN:5222" || echo "127.0.0.1:5222")
[ -z "${PI_PASSWORD:-}" ] && PI_PASSWORD="$(openssl rand -base64 12 | tr '+/' '-_' | tr -d '=')"
[ -z "${OWNER_PASSWORD:-}" ] && OWNER_PASSWORD="$(openssl rand -base64 12 | tr '+/' '-_' | tr -d '=')"
CAROOT="$(mkcert -CAROOT 2>/dev/null || echo "$HOME/.local/share/mkcert")"

# --- 1. XMPP server (optional) ------------------------------------------------
if [ "${ENABLE_SERVER:-yes}" = "yes" ]; then
  echo "[1/5] Installing ejabberd + mkcert (sudo required)"
  sudo apt-get update -qq
  sudo apt-get install -y -qq ejabberd mkcert libnss3-tools 2>/dev/null \
    || sudo apt-get install -y -qq ejabberd

  EV="$(sudo -u ejabberd ejabberdctl version 2>/dev/null | head -1 || true)"
  echo "    ejabberd version: ${EV:-unknown}"
  case "${EV:-}" in
    2[0-2].*) echo "    WARNING: ejabberd is old; the shipped config needs 23.10+."
             echo "    If startup fails, install the latest from https://docs.ejabberd.im/admin/install/" ;;
  esac

  echo "[2/5] Generating the TLS certificate (mkcert)"
  mkcert -cert-file "$CONFIG_DIR/certs/leaf.pem" -key-file "$CONFIG_DIR/certs/key.pem" \
    $CERT_HOSTS >/dev/null 2>&1 || { echo "ERROR: mkcert failed for hosts: $CERT_HOSTS"; exit 1; }
  # One combined PEM (key + cert + CA) so ejabberd can't mis-pair them.
  cat "$CONFIG_DIR/certs/key.pem" "$CONFIG_DIR/certs/leaf.pem" "$CAROOT/rootCA.pem" \
    > "$CONFIG_DIR/certs/cert.pem"
  chmod 600 "$CONFIG_DIR/certs/cert.pem"

  echo "[3/5] Configuring and starting ejabberd"
  sed "s/__DOMAIN__/$DOMAIN/g" ejabberd.yml.template | sudo tee /etc/ejabberd/ejabberd.yml >/dev/null
  sudo chown ejabberd:ejabberd /etc/ejabberd/ejabberd.yml
  sudo install -d -o ejabberd -g ejabberd -m 700 /etc/ejabberd/certs
  sudo install -o ejabberd -g ejabberd -m 600 "$CONFIG_DIR/certs/cert.pem" /etc/ejabberd/certs/cert.pem
  sudo systemctl enable --now ejabberd
  sudo systemctl restart ejabberd

  ready=""
  for i in $(seq 1 60); do
    if sudo -u ejabberd ejabberdctl status >/dev/null 2>&1; then ready=1; break; fi
    sleep 2
  done
  [ -n "$ready" ] || { echo "ERROR: ejabberd did not become ready (sudo systemctl status ejabberd)"; exit 1; }

  echo "    Registering $PI_USER@$DOMAIN and $OWNER_USER@$DOMAIN"
  sudo -u ejabberd ejabberdctl register "$PI_USER" "$DOMAIN" "$PI_PASSWORD"
  sudo -u ejabberd ejabberdctl register "$OWNER_USER" "$DOMAIN" "$OWNER_PASSWORD"
else
  echo "[1/5] Skipping server install (ENABLE_SERVER=no; connecting to $SERVICE)"
fi

# --- 2. Build pi-msg (Go 1.26+) ------------------------------------------------
echo "[2/5 or 4/5] Building pi-msg"
GO="$(command -v go || true)"
if [ -n "$GO" ] && [ "$("$GO" version | sed -E 's/.*go([0-9]+)\.([0-9]+).*/\1\2/')" -ge 126 ]; then
  : # existing Go is fine
elif [ -x "$HOME/go-sdk/go/bin/go" ]; then
  GO="$HOME/go-sdk/go/bin/go"
else
  GO_VER="1.26.4"
  echo "    Installing Go $GO_VER to ~/go-sdk (used only for this build)"
  curl -fsSL "https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz" -o /tmp/go.tgz
  mkdir -p "$HOME/go-sdk" && tar -C "$HOME/go-sdk" -xzf /tmp/go.tgz
  GO="$HOME/go-sdk/go/bin/go"
fi
[ -d "$HOME/src/pi-msg" ] || git clone --depth 1 https://github.com/zachpmanson/pi-msg.git "$HOME/src/pi-msg"
( cd "$HOME/src/pi-msg" && CGO_ENABLED=0 "$GO" build -o "$BIN_DIR/pi-msg" . )

# --- 3. Stable `pi` launcher ----------------------------------------------------
echo "    Installing the pi launcher"
install -m 755 scripts/pi "$BIN_DIR/pi"

# --- 4. pi-msg config + environment (no secrets in this repo) --------------------
echo "    Writing pi-msg config (~/.config/pi-msg)"
python3 - "$CONFIG_DIR/config.json" "$PI_USER" "$DOMAIN" "$PI_PASSWORD" "$OWNER_USER" "$MODEL" "$WORKDIR" "$SERVICE" <<'PYEOF'
import json, os, sys
out, pi_user, domain, pi_pw, owner_user, model, workdir, service = sys.argv[1:]
cfg = {"accounts": {"default": {
    "jid": f"{pi_user}@{domain}",
    "password": pi_pw,
    "owner": f"{owner_user}@{domain}",
    "model": model,
    "workdir": os.path.expandvars(workdir),
    "service": service,
}}}
with open(out, "w") as f:
    json.dump(cfg, f, indent=2)
os.chmod(out, 0o600)
PYEOF

{
  echo "PI_PROVIDER=${PI_PROVIDER:-}"
  echo "PI_MODEL=${PI_MODEL:-}"
  echo "OPENCODE_GO_API_KEY=${OPENCODE_GO_API_KEY:-}"
  echo "SSL_CERT_FILE=$CONFIG_DIR/certs/ca-bundle.pem"
} > "$CONFIG_DIR/env"
chmod 600 "$CONFIG_DIR/env"

# Trust bundle for the bridge: system CAs + the mkcert root CA.
cat /etc/ssl/certs/ca-certificates.crt "$CAROOT/rootCA.pem" \
  > "$CONFIG_DIR/certs/ca-bundle.pem" 2>/dev/null || true

if [ -z "${OPENCODE_GO_API_KEY:-}" ]; then
  echo "    NOTE: OPENCODE_GO_API_KEY is not set in this shell."
  echo "    Make sure pi is logged in on this machine before chatting (pi auth check --provider opencode-go)."
fi

# --- 5. systemd user service ------------------------------------------------------
echo "[5/5] Installing + starting the pi-msg service"
mkdir -p "$HOME/.config/systemd/user"
sed "s|__PATH__|$BIN_DIR:/usr/local/bin:/usr/bin:/bin|" pi-msg.service \
  > "$HOME/.config/systemd/user/pi-msg.service"
systemctl --user daemon-reload
sudo loginctl enable-linger "$USER" 2>/dev/null || true
systemctl --user enable --now pi-msg
sleep 5

# --- summary -----------------------------------------------------------------------
echo
echo "Done!"
echo "  pi-msg service: $(systemctl --user is-active pi-msg)"
echo
echo "XMPP accounts:"
echo "  bot : $PI_USER@$DOMAIN      password: $PI_PASSWORD"
echo "  owner : $OWNER_USER@$DOMAIN   password: $OWNER_PASSWORD"
echo
echo "Save these (also in $CONFIG_DIR/passwords.txt? no - printed once here;"
echo "the bot password is in $CONFIG_DIR/config.json, mode 600)."
echo
echo "Next steps:"
echo "  1. On the phone (Conversations): add account $OWNER_USER / $DOMAIN / password above"
echo "  2. Add contact $PI_USER@$DOMAIN and send a message"
echo "  3. Pick which pi session the bot works in: bash scripts/pick-session.sh"
