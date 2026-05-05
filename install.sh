#!/usr/bin/env bash
# DAC Chain Light Node + Mining — One-shot installer
# Usage:  bash install.sh
# Or:     bash <(curl -fsSL https://raw.githubusercontent.com/USER/REPO/main/install.sh)

set -euo pipefail

DAC_DIR="$HOME/dac"
DATA_DIR="$DAC_DIR/data"
BIN="$DAC_DIR/dacnode"
NODE_NAME="${NODE_NAME:-MyDACNode-$(hostname)}"
MINER_THREADS="${MINER_THREADS:-1}"

echo "==> DAC Light Node Installer"
echo "==> Dir: $DAC_DIR  Threads: $MINER_THREADS  Name: $NODE_NAME"

case "$(uname -m)" in
  x86_64)         ARCH=amd64 ;;
  aarch64|arm64)  ARCH=arm64 ;;
  *) echo "ERROR: unsupported arch $(uname -m)"; exit 1 ;;
esac

mkdir -p "$DATA_DIR"
echo "==> Downloading dacnode ($ARCH)..."
curl -fsSL -o "$BIN" "https://repo.dachain.tech/node/dev/linux/$ARCH/dacnode"
chmod +x "$BIN"
"$BIN" --help > /dev/null 2>&1 || { echo "Binary download failed"; exit 1; }

if [ -z "$(ls -A "$DATA_DIR/keystore" 2>/dev/null || true)" ]; then
  echo ""
  echo "==> No wallet found. Creating new account."
  echo "    Password set karo (yaad rakho — recovery nahi hai)"
  echo ""
  "$BIN" account new --datadir "$DATA_DIR"
fi

ADDR=$(ls "$DATA_DIR/keystore" | head -n1 | awk -F-- '{print "0x"$NF}')
echo "==> Mining rewards address: $ADDR"

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
echo " DONE. Node background me chalu hai."
echo "============================================================"
echo " Wallet:   $ADDR"
echo " Logs:     bash logs.sh"
echo " Backup:   bash backup.sh"
echo " Explorer: https://exptest.dachain.tech/address/$ADDR"
echo "============================================================"
