#!/usr/bin/env bash
# DAC Wallet Restore + Mining Start
# Purani private key daalo, same wallet se mining chalu kar do.
# Usage:  bash restore.sh

set -euo pipefail

DAC_DIR="$HOME/dac"
DATA_DIR="$DAC_DIR/data"
KEYSTORE_DIR="$DATA_DIR/keystore"
BIN="$DAC_DIR/dacnode"
NODE_NAME="${NODE_NAME:-MyDACNode-$(hostname)}"
MINER_THREADS="${MINER_THREADS:-1}"

echo "==> DAC Wallet Restore + Mining"
echo "==> Dir: $DAC_DIR  Threads: $MINER_THREADS"
echo ""

# 1. Detect arch + download binary if missing
case "$(uname -m)" in
  x86_64)         ARCH=amd64 ;;
  aarch64|arm64)  ARCH=arm64 ;;
  *) echo "ERROR: unsupported arch $(uname -m)"; exit 1 ;;
esac

mkdir -p "$DATA_DIR" "$KEYSTORE_DIR"

if [ ! -x "$BIN" ]; then
  echo "==> Downloading dacnode ($ARCH)..."
  curl -fsSL -o "$BIN" "https://repo.dachain.tech/node/dev/linux/$ARCH/dacnode"
  chmod +x "$BIN"
fi

# 2. Existing wallet check
if [ -n "$(ls -A "$KEYSTORE_DIR" 2>/dev/null || true)" ]; then
  echo ""
  echo "WARNING: Wallet already exists at $KEYSTORE_DIR"
  ls -la "$KEYSTORE_DIR"
  echo ""
  read -p "Purani wallet hata ke nayi import karein? (yes/no): " CONFIRM
  if [ "$CONFIRM" != "yes" ]; then
    echo "Cancelled. Kuch nahi badla."
    exit 0
  fi
  BACKUP_DIR="$DATA_DIR/keystore-backup-$(date +%s)"
  mv "$KEYSTORE_DIR" "$BACKUP_DIR"
  mkdir -p "$KEYSTORE_DIR"
  echo "Old keystore backup at: $BACKUP_DIR"
fi

# 3. Get private key (silent input)
echo ""
echo "==> Private key daalo (0x prefix optional, 64 hex chars)"
echo "    Typing chhupi rahegi — paste karke Enter daba"
read -s -p "Private Key: " PK_INPUT
echo ""

# Strip 0x if present, lowercase, validate
PK=$(echo "$PK_INPUT" | sed 's/^0x//' | tr 'A-Z' 'a-z')
if ! [[ "$PK" =~ ^[0-9a-f]{64}$ ]]; then
  echo "ERROR: Invalid private key. 64 hex characters chahiye (with or without 0x prefix)"
  exit 1
fi

# 4. Get new password (twice for confirmation)
echo ""
echo "==> Naya password set karo (yaad rakho — recovery nahi hai)"
read -s -p "Password: " PW1
echo ""
read -s -p "Password again: " PW2
echo ""
if [ "$PW1" != "$PW2" ]; then
  echo "ERROR: Passwords match nahi ho rahe"
  exit 1
fi
if [ -z "$PW1" ]; then
  echo "ERROR: Password empty nahi ho sakta"
  exit 1
fi

# 5. Write key + password to temp files (chmod 600)
TMP_KEY=$(mktemp)
TMP_PW=$(mktemp)
chmod 600 "$TMP_KEY" "$TMP_PW"
trap 'shred -u "$TMP_KEY" "$TMP_PW" 2>/dev/null || rm -f "$TMP_KEY" "$TMP_PW"' EXIT

echo "$PK" > "$TMP_KEY"
echo "$PW1" > "$TMP_PW"
unset PK PK_INPUT PW1 PW2

# 6. Import via dacnode
echo ""
echo "==> Importing wallet..."
"$BIN" account import \
  --datadir "$DATA_DIR" \
  --password "$TMP_PW" \
  "$TMP_KEY"

# 7. Get address
ADDR=$(ls "$KEYSTORE_DIR" | head -n1 | awk -F-- '{print "0x"$NF}')
echo "==> Restored wallet: $ADDR"

# 8. Stop existing service if running
if systemctl list-unit-files 2>/dev/null | grep -q '^dacnode.service'; then
  sudo systemctl stop dacnode 2>/dev/null || true
fi

# 9. Install/update systemd service
SERVICE="/etc/systemd/system/dacnode.service"
echo "==> Installing systemd service (sudo required)"
sudo tee "$SERVICE" > /dev/null <<EOF
[Unit]
Description=DAC Chain Light Node + Miner
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$DAC_DIR
ExecStart=$BIN --testnet \\
  --datadir $DATA_DIR \\
  --identity "$NODE_NAME" \\
  --mine \\
  --miner.threads $MINER_THREADS \\
  --miner.etherbase $ADDR
Restart=always
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable dacnode
sudo systemctl restart dacnode

sleep 3
echo ""
echo "============================================================"
echo " DONE. Old wallet restored + mining chalu."
echo "============================================================"
echo " Wallet:   $ADDR"
echo " Logs:     bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/logs.sh)"
echo " Backup:   bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/backup.sh)"
echo " Explorer: https://exptest.dachain.tech/address/$ADDR"
echo "============================================================"
