# Wireless ADB

> Persistent wireless ADB debugging — auto-enables on boot, no setup needed every time.

![KernelSU](https://img.shields.io/badge/KernelSU-Module-green?style=flat-square)
![Magisk](https://img.shields.io/badge/Magisk-Compatible-blue?style=flat-square)
![APatch](https://img.shields.io/badge/APatch-Compatible-purple?style=flat-square)
![Android](https://img.shields.io/badge/Android-12%2B-orange?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

---

## The Problem

Wireless ADB resets after every reboot. You have to re-enable it, find the port, and reconnect from your computer each time.

## The Fix

This module automatically enables wireless ADB on a fixed port after every boot. Flash it once, connect forever.

---

## Quick Start

1. Download the latest `.zip` from [Releases](https://github.com/dracediax/wireless-adb/releases)
2. Flash via your module manager
3. Reboot
4. Connect from your computer:
   ```
   adb connect <phone-ip>:5555
   ```
5. That's it. It will auto-enable on every boot.

---

## WebUI

- **Status indicator** — green dot when active, shows connection address
- **Tap to copy** — tap the connection address to copy it
- **Enable/disable toggle** — turn boot auto-enable on or off
- **Custom port** — change from default 5555
- **Apply Now** — enable/disable immediately without rebooting
- **Boot notification** — get notified with the connection address after reboot

---

## Security

**Wireless ADB gives full device access to anyone who can connect.**

- Only use on **trusted, private networks** (home WiFi behind a firewall)
- **Never** enable on public WiFi, coffee shops, hotels, or guest networks
- **Never** expose the port via port forwarding
- Anyone on the same network who knows your IP can connect if they have an authorized ADB key
- Consider disabling when not actively debugging

---

<details>
<summary><b>How It Works</b></summary>

After boot, `service.sh` runs:
```bash
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```

This enables the ADB daemon in TCP mode on port 5555 (or your custom port). The config is read from `/data/adb/wadb_config` which persists across module updates.

### Data Files

| File | Purpose |
|------|---------|
| `/data/adb/wadb_config` | Settings: enabled, port, debug toggle |
| `debug.log` | Boot log and debug info (in module dir) |

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

---

## License

MIT
