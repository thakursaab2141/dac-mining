#!/usr/bin/env bash
# DAC Wallet Full Backup — Address + Keystore JSON + Private Key
# Made by @kittu2141  |  Telegram: https://t.me/gujjucryptto
# Usage:  bash backup.sh

set -e

KEYSTORE_DIR="$HOME/dac/data/keystore"

if [ ! -d "$KEYSTORE_DIR" ] || [ -z "$(ls -A "$KEYSTORE_DIR" 2>/dev/null)" ]; then
  echo "ERROR: keystore nahi mili at $KEYSTORE_DIR"
  echo "Pehle install.sh chala wallet banane ke liye."
  exit 1
fi

# Ensure eth-account is installed
if ! python3 -c "import eth_account" 2>/dev/null; then
  echo "==> eth-account install ho raha (one-time, 5-10 sec)..."
  pip3 install --user --break-system-packages -q eth-account 2>/dev/null \
    || pip3 install --user -q eth-account 2>/dev/null \
    || { echo "ERROR: pip3 install fail. Manually chala: pip3 install --user --break-system-packages eth-account"; exit 1; }
fi

KS_PATH=$(ls "$KEYSTORE_DIR" | head -1)
export KS_FULL_PATH="$KEYSTORE_DIR/$KS_PATH"

python3 << 'PYEOF'
import json, os, getpass, sys
from eth_account import Account

ks_path = os.environ['KS_FULL_PATH']
ks_raw = open(ks_path).read()
ks = json.loads(ks_raw)

print()
print("════════════════════ WALLET FULL BACKUP ════════════════════")
print("           @kittu2141  |  t.me/gujjucryptto")
print("════════════════════════════════════════════════════════════")
print()
print(">>> 1. ADDRESS")
print("0x" + ks['address'])
print()
print(">>> 2. KEYSTORE FILENAME")
print(ks_path.split('/')[-1])
print()
print(">>> 3. KEYSTORE JSON (PC pe wallet.json me save karo)")
print(ks_raw)
print()
pw = getpass.getpass(">>> Password daal (typing chhupi rahegi): ")
print()
try:
    pk = Account.decrypt(ks, pw)
    print(">>> 4. PRIVATE KEY (sabse important — alag note me save)")
    print("0x" + pk.hex())
    print()
    print("════════════════════════════════════════════════════════════")
    print(" Save kar PC pe SAFE place pe. Network me NEVER share kar.")
    print("════════════════════════════════════════════════════════════")
    print()
    print(" Updates + new scripts ke liye join:")
    print("   Telegram: https://t.me/gujjucryptto  (@kittu2141)")
    print("════════════════════════════════════════════════════════════")
except Exception as e:
    print("ERROR: GALAT PASSWORD")
    print(f"  detail: {e}")
    sys.exit(1)
PYEOF
