#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# pi-msg setup for NixOS: bake the ejabberd config into the system, install
# the TLS certificate, set the account passwords, and start the bridge.
#
# Prerequisite: the NixOS configuration must already enable ejabberd
# (services.ejabberd with configFile = ./ejabberd.yml — see the nixos repo).
#
#   cd pi/pi-msg
#   cp config.env.example config.env   # optional: set DOMAIN, accounts, CERT_HOSTS
#   bash scripts/setup-nixos.sh
#
# This is the NixOS counterpart of scripts/setup-ubuntu.sh (Debian/Ubuntu).
# ---------------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$HOME/.config/pi-msg"
NIXOS_DIR="${NIXOS_DIR:-$HOME/configure/nixos}"
EJABBERDCTL="/run/current-system/sw/bin/ejabberdctl"
CAROOT="$(mkcert -CAROOT 2>/dev/null || echo "$HOME/.local/share/mkcert")"

# Defaults (overridable via config.env)
DOMAIN="diameno.netbird.cloud"
PI_USER="pi"
OWNER_USER="gkapfham"
CERT_HOSTS="$DOMAIN localhost 127.0.0.1"
MODEL="opencode-go/deepseek-v4-flash"
WORKDIR="$HOME"

if [ -f "$SCRIPT_DIR/config.env" ]; then
  # shellcheck disable=SC1090
  source "$SCRIPT_DIR/config.env"
fi

mkdir -p "$CONFIG_DIR/certs"

# Passwords: from config.env, else from a previous run, else generated.
if [ -f "$CONFIG_DIR/passwords.txt" ]; then
  # shellcheck disable=SC1090
  source "$CONFIG_DIR/passwords.txt"
fi
[ -z "${PI_PASSWORD:-}" ] && PI_PASSWORD="$(openssl rand -base64 12 | tr '+/' '-_' | tr -d '=')"
[ -z "${OWNER_PASSWORD:-}" ] && OWNER_PASSWORD="$(openssl rand -base64 12 | tr '+/' '-_' | tr -d '=')"

# Run ejabberdctl the same way the NixOS service does.
run_ctl() {
  sudo -u ejabberd env \
    ERL_EPMD_ADDRESS=127.0.0.1 \
    EJABBERD_SPOOL_DIR=/var/lib/ejabberd \
    EJABBERD_LOGS_DIR=/var/log/ejabberd \
    "$EJABBERDCTL" "$@"
}

echo "==> pi-msg setup for NixOS"

echo "[1/4] Generating and installing the TLS certificate (mkcert)"
mkcert -cert-file "$CONFIG_DIR/certs/leaf.pem" -key-file "$CONFIG_DIR/certs/key.pem" \
  $CERT_HOSTS >/dev/null 2>&1 || { echo "ERROR: mkcert failed for hosts: $CERT_HOSTS"; exit 1; }
cat "$CONFIG_DIR/certs/key.pem" "$CONFIG_DIR/certs/leaf.pem" "$CAROOT/rootCA.pem" \
  > "$CONFIG_DIR/certs/cert.pem"
chmod 600 "$CONFIG_DIR/certs/cert.pem"
sudo install -d -o ejabberd -g ejabberd -m 700 /etc/ejabberd/certs
sudo install -o ejabberd -g ejabberd -m 600 "$CONFIG_DIR/certs/cert.pem" /etc/ejabberd/certs/cert.pem
sudo rm -f /etc/ejabberd/certs/key.pem

echo "[2/4] Rebuilding NixOS so the ejabberd config is baked in (~5-15 min)"
cd "$NIXOS_DIR"
nh os switch -f '<nixpkgs/nixos>' -- -I nixos-config="$NIXOS_DIR/configuration.nix"

echo "[3/4] Registering accounts and writing the bridge config"
ready=""
for i in $(seq 1 60); do
  if run_ctl status >/dev/null 2>&1; then ready=1; break; fi
  sleep 2
done
[ -n "$ready" ] || { echo "ERROR: ejabberd did not become ready (sudo systemctl status ejabberd)"; exit 1; }

run_ctl register "$PI_USER" "$DOMAIN" "$PI_PASSWORD" 2>/dev/null || \
  run_ctl change_password "$PI_USER" "$DOMAIN" "$PI_PASSWORD"
run_ctl register "$OWNER_USER" "$DOMAIN" "$OWNER_PASSWORD" 2>/dev/null || \
  run_ctl change_password "$OWNER_USER" "$DOMAIN" "$OWNER_PASSWORD"

python3 - "$CONFIG_DIR/config.json" "$PI_USER" "$DOMAIN" "$PI_PASSWORD" "$OWNER_USER" "$MODEL" "$WORKDIR" <<'PYEOF'
import json, os, sys
out, pi_user, domain, pi_pw, owner_user, model, workdir = sys.argv[1:]
cfg = {"accounts": {"default": {
    "jid": f"{pi_user}@{domain}",
    "password": pi_pw,
    "owner": f"{owner_user}@{domain}",
    "model": model,
    "workdir": os.path.expandvars(workdir),
    "service": "127.0.0.1:5222",
}}}
with open(out, "w") as f:
    json.dump(cfg, f, indent=2)
os.chmod(out, 0o600)
PYEOF

printf 'PI_PASSWORD=%s\nOWNER_PASSWORD=%s\n' "$PI_PASSWORD" "$OWNER_PASSWORD" \
  > "$CONFIG_DIR/passwords.txt"
chmod 600 "$CONFIG_DIR/passwords.txt"

{
  echo "PI_PROVIDER=${PI_PROVIDER:-}"
  echo "PI_MODEL=${PI_MODEL:-}"
  echo "OPENCODE_GO_API_KEY=${OPENCODE_GO_API_KEY:-}"
  echo "SSL_CERT_FILE=$CONFIG_DIR/certs/ca-bundle.pem"
} > "$CONFIG_DIR/env"
chmod 600 "$CONFIG_DIR/env"
cat /etc/ssl/certs/ca-certificates.crt "$CAROOT/rootCA.pem" \
  > "$CONFIG_DIR/certs/ca-bundle.pem" 2>/dev/null || true

echo "[4/4] Installing and starting the pi-msg service"
mkdir -p "$HOME/.config/systemd/user"
sed "s|__PATH__|$HOME/.local/bin:/run/current-system/sw/bin|" \
  "$SCRIPT_DIR/pi-msg.service" > "$HOME/.config/systemd/user/pi-msg.service"
systemctl --user daemon-reload
sudo loginctl enable-linger "$USER" 2>/dev/null || true
systemctl --user enable --now pi-msg
sleep 5

echo
echo "Done! pi-msg service: $(systemctl --user is-active pi-msg)"
echo "  bot : $PI_USER@$DOMAIN        password: $PI_PASSWORD"
echo "  you : $OWNER_USER@$DOMAIN  password: $OWNER_PASSWORD"
echo
echo "Connect Conversations on the phone:"
echo "  1. NetBird must be connected on the phone"
echo "  2. Add account (NOT 'register'): username $OWNER_USER, domain $DOMAIN,"
echo "     password above — on the certificate warning tap Trust (once)"
echo "  3. If it cannot connect, set the server host to the machine's VPN/LAN IP"
echo "  4. Add contact $PI_USER@$DOMAIN and send a message"
