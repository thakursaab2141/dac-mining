<div align="center">

# DAC Chain Mining Node

### Free DAC Testnet Light Node + Miner — One-Command Setup

[![Telegram](https://img.shields.io/badge/TELEGRAM-@gujjucryptto-26A5E4?style=for-the-badge&logo=telegram&logoColor=white&labelColor=000000)](https://t.me/gujjucryptto)
[![Made By](https://img.shields.io/badge/MADE_BY-@kittu2141-FF4081?style=for-the-badge&logo=github&logoColor=white&labelColor=000000)](https://github.com/thakursaab2141)
[![License](https://img.shields.io/badge/LICENSE-MIT-FFC107?style=for-the-badge&logoColor=white&labelColor=000000)](LICENSE)

[![Chain](https://img.shields.io/badge/CHAIN-DAC_TESTNET-7B61FF?style=for-the-badge&logoColor=white&labelColor=000000)](https://docs.dachain.tech)
[![Status](https://img.shields.io/badge/STATUS-LIVE-00C853?style=for-the-badge&logoColor=white&labelColor=000000)](https://exptest.dachain.tech)
[![Setup](https://img.shields.io/badge/SETUP-1_COMMAND-FF6D00?style=for-the-badge&logoColor=white&labelColor=000000)](#quick-start)

[![Linux](https://img.shields.io/badge/LINUX-UBUNTU-E95420?style=for-the-badge&logo=ubuntu&logoColor=white&labelColor=000000)](#requirements)
[![Bash](https://img.shields.io/badge/SHELL-BASH-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white&labelColor=000000)](#)
[![Architecture](https://img.shields.io/badge/ARCH-AMD64_|_ARM64-blue?style=for-the-badge&logoColor=white&labelColor=000000)](#)

</div>

---

## Requirements

| Need | Spec |
|------|------|
| OS | Linux VPS (Ubuntu/Debian) |
| Arch | x86_64 / ARM64 |
| Disk | ~5 GB free |
| RAM | 1 GB+ |
| Access | sudo |
| Python | 3.x (pre-installed on Ubuntu) |

---

## Quick Start

> **4 commands only — copy-paste karo, ho gaya kaam.**

### `1.` Install + Mining Start (one-time)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/install.sh)
```
Wallet password puchega. Set karo, yaad rakho. Mining background me chalu ho jayegi, VPS reboot pe bhi auto-restart.

### `2.` Wallet Backup (jab chahe)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/backup.sh)
```
Address + keystore JSON + private key — sab terminal me dikhega. Password puchega decrypt karne ke liye. PC pe safe jagah save kar.

### `3.` Restore Old Wallet (purani private key se mining)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/restore.sh)
```
Naye VPS pe ya jab purani wallet wapas chahiye — private key + naya password daal, same address se mining chalu ho jayegi. Pehle se koi wallet mili to confirm puchega before overwrite.

### `4.` Logs + Status (kabhi bhi check)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/logs.sh)
```
Mining status, hashrate, peers, balance, block number — sab dikh jayega. Plus live logs (Ctrl+C exit).

Sirf status chahiye, logs nahi:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/logs.sh) status
```

---

## Customization

### Mining threads badhao (default 1)
```bash
MINER_THREADS=4 bash install.sh
```

### Custom node name
```bash
NODE_NAME="Mera-Node" bash install.sh
```

---

## Manual Commands (Reference)

| Kaam | Command |
|------|---------|
| Stop node | `sudo systemctl stop dacnode` |
| Start node | `sudo systemctl start dacnode` |
| Restart | `sudo systemctl restart dacnode` |
| Status only | `sudo systemctl status dacnode` |
| Live logs | `sudo journalctl -u dacnode -f` |
| Last 100 logs | `sudo journalctl -u dacnode -n 100` |
| Open JS console | `~/dac/dacnode attach ~/dac/data/dacnode.ipc` |

### Console JS Commands
```js
eth.mining              // true/false
eth.hashrate            // current hashrate
eth.blockNumber         // current block
net.peerCount           // connected peers
eth.coinbase            // mining address
web3.fromWei(eth.getBalance(eth.coinbase), 'ether')   // balance in DACC
```

---

## DAC Testnet Info

| Field | Value |
|-------|-------|
| RPC URL | `https://rpctest.dachain.tech` |
| Chain ID | `21894` |
| Currency | DACC |
| Explorer | `https://exptest.dachain.tech` |
| Faucet | `https://faucet.dachain.tech` |
| Block time | ~5 sec |

### MetaMask Setup
1. Add Network → Manual
2. Fill the table above
3. Import account → JSON file → upload `wallet.json` → password
4. Switch to DAC Testnet network

---

## Wallet Recovery

Naye VPS pe ya kahin bhi wallet wapas chahiye:
- **Easy way** → `restore.sh` chala, private key paste kar, ho gaya
- **Manual way** → `wallet.json` ko `~/dac/data/keystore/` me daal, `install.sh` chala (same wallet detect karega)

---

## Security

- Private key + password kabhi kisi ko mat de
- Private key chat / email / cloud me plain me mat daal
- Backup ke liye: encrypted password manager (Bitwarden free) recommended
- Multiple backups rakho — USB drive, password manager, paper

---

## Disclaimer

- Ye **testnet** hai — DACC abhi real money nahi
- Mainnet launch / airdrop ka koi guarantee nahi
- Apna VPS provider ka ToS check karo (kuch crypto mining ban karte hain)
- Use at your own risk

---

<div align="center">

## Connect & Updates

[![Join Telegram](https://img.shields.io/badge/JOIN_TELEGRAM-@gujjucryptto-26A5E4?style=for-the-badge&logo=telegram&logoColor=white&labelColor=000000)](https://t.me/gujjucryptto)

**Crypto airdrops, testnet farming, mining tips — sab updates yahan milte hain**

---

### Made with care by [@kittu2141](https://t.me/gujjucryptto)

[![Telegram](https://img.shields.io/badge/-Telegram-26A5E4?style=flat-square&logo=telegram&logoColor=white)](https://t.me/gujjucryptto)
[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/thakursaab2141)

`MIT License` — Free to use, modify, share

</div>
