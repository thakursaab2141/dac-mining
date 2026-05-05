# DAC Chain Light Node + Mining

Free me **DAC testnet light node + miner** chalane ke liye 3 simple scripts. Linux VPS pe kaam karta hai (Ubuntu/Debian recommended).

## Requirements

- Linux VPS — x86_64 ya ARM64
- ~5 GB free disk
- 1 GB+ RAM
- `sudo` access
- Python 3 (pre-installed on most Ubuntu)

## Quick Start (3 Commands Only)

### 1. Install + Mining Start (one-time)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/install.sh)
```
Wallet password puchega. Set karo, yaad rakho. Mining background me chalu ho jayegi, VPS reboot pe bhi auto-restart.

### 2. Wallet Backup (jab chahe)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/thakursaab2141/dac-mining/main/backup.sh)
```
Address + keystore JSON + private key — sab terminal me dikhega. Password puchega decrypt karne ke liye. PC pe safe jagah save kar.

### 3. Logs + Status (kabhi bhi check)
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
1. `wallet.json` ko `~/dac/data/keystore/` me daal
2. `install.sh` chala — same wallet detect karega, naya nahi banayega

Ya MetaMask me JSON import → password.

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

## License

MIT
