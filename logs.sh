#!/usr/bin/env bash
# DAC Node — Live Logs + Mining Status + Balance Check
# Made by @kittu2141  |  Telegram: https://t.me/gujjucryptto
# Usage:  bash logs.sh           (status snapshot + tail logs)
#         bash logs.sh status    (status only, no tail)

set -e

DATA_DIR="$HOME/dac/data"
BIN="$HOME/dac/dacnode"
IPC="$DATA_DIR/dacnode.ipc"

echo ""
echo "════════════════════ DAC NODE STATUS ════════════════════"
echo "    @kittu2141  |  t.me/gujjucryptto"
echo "═════════════════════════════════════════════════════════"
echo ""

# Service status
echo ">>> SYSTEMD SERVICE"
sudo systemctl is-active dacnode > /dev/null 2>&1 && echo "  Status: ACTIVE (running)" || echo "  Status: NOT RUNNING — chala: sudo systemctl start dacnode"
echo ""

# IPC must exist
if [ ! -S "$IPC" ]; then
  echo "ERROR: IPC socket not found at $IPC"
  echo "Node abhi sync nahi hua, ya chal nahi raha."
  echo "Logs dekho: sudo journalctl -u dacnode -n 50"
  exit 1
fi

# Live mining + chain stats via JS console
echo ">>> CHAIN + MINING STATUS"
"$BIN" attach "$IPC" --exec '
JSON.stringify({
  mining: eth.mining,
  hashrate: eth.hashrate,
  blockNumber: eth.blockNumber,
  peerCount: net.peerCount,
  syncing: eth.syncing,
  coinbase: eth.coinbase,
  balanceDACC: web3.fromWei(eth.getBalance(eth.coinbase), "ether")
}, null, 2)' 2>/dev/null

echo ""
echo ">>> EXPLORER"
ADDR=$("$BIN" attach "$IPC" --exec 'eth.coinbase' 2>/dev/null | tr -d '"')
echo "  https://exptest.dachain.tech/address/$ADDR"
echo ""
echo ">>> JOIN FOR UPDATES"
echo "  Telegram: https://t.me/gujjucryptto  (@kittu2141)"
echo "═════════════════════════════════════════════════════════"

# Tail logs unless "status" arg passed
if [ "${1:-}" != "status" ]; then
  echo ""
  echo ">>> LIVE LOGS (Ctrl+C exit)"
  echo ""
  sudo journalctl -u dacnode -f -n 20
fi
