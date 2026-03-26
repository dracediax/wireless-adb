# Wireless ADB

> Persistent wireless ADB debugging — auto-enables on boot, connect forever.

![KernelSU](https://img.shields.io/badge/KernelSU-Module-green?style=flat-square)
![Magisk](https://img.shields.io/badge/Magisk-Compatible-blue?style=flat-square)
![APatch](https://img.shields.io/badge/APatch-Compatible-purple?style=flat-square)
![Android](https://img.shields.io/badge/Android-12%2B-orange?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

---

## The Problem

Wireless ADB resets after every reboot. You have to re-enable it, find the port, and reconnect each time.

## The Fix

Flash once. After every boot, wireless ADB is ready on a fixed port. Just connect.

```
adb connect <phone-ip>:5555
```

---

## Quick Start

1. Download the latest `.zip` from [Releases](https://github.com/dracediax/wireless-adb/releases)
2. Flash via your module manager
3. Reboot
4. You'll get a notification with the connection address
5. From your computer: `adb connect <ip>:5555`

---

## WebUI

- **Live status** — green dot when active, grey when disabled
- **Connection address** — tap to copy `adb connect <ip>:<port>`
- **Enable/disable toggle** — control whether it starts on boot
- **Custom port** — default 5555, set whatever you want
- **Apply Now** — enable or disable immediately, no reboot needed

---

<details>
<summary><b>Battery Impact</b></summary>

**None.** The module runs a single script at boot that takes ~1 second, then exits. No background process, no polling, no wake locks.

The ADB daemon (`adbd`) is already running on any phone with USB debugging enabled. This module just tells it to also listen on TCP — zero additional battery cost.

</details>

<details>
<summary><b>Security</b></summary>

**Wireless ADB gives full device access to anyone who can connect.**

- Only use on **trusted, private networks** (home WiFi behind a firewall)
- **Never** enable on public WiFi, coffee shops, hotels, or guest networks
- **Never** expose the port via port forwarding
- Connections still require an authorized ADB key (RSA fingerprint prompt)
- Consider disabling via the WebUI toggle when not actively debugging

</details>

<details>
<summary><b>How It Works</b></summary>

After boot, `service.sh` runs:
```bash
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```

This switches the ADB daemon to TCP mode on your configured port. The phone's WiFi IP is auto-detected and shown in the notification and WebUI.

Config is stored at `/data/adb/wadb_config` and persists across module updates.

### Debug via ADB

```
adb shell "su -c 'cat /data/adb/modules/wireless-adb/debug.log'"
```

</details>

---

## Compatibility

| Manager | Works |
|---------|-------|
| KernelSU / KernelSU Next | Yes |
| Magisk | Yes |
| APatch | Yes |
| KsuWebUI (standalone) | Yes |

WebUI requires a manager with WebUI support or [KsuWebUI](https://github.com/adivenxnataly/KsuWebUI).

---

## License

MIT
