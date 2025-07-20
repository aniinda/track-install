# 🛠️ track-install

A lightweight server installation tracker that wraps your package installs with **timestamped logs**, **custom labels**, and **queryable history** — perfect for multi-purpose or long-lived Linux servers.

---

## 🚀 Features

- ✅ Tracks successful installations via `apt`
- ✅ Supports **custom labels** per install (`TRACK_LABEL`)
- ✅ Allows **multi-label tagging** (e.g., `db,infra,t1brain`)
- ✅ Stores install logs in `~/.server-installs.log`
- ✅ Includes commands to **query installs by label**
- ✅ Compatible with any Debian/Ubuntu-based server

---

## 📦 Installation

```bash
curl -fsSL https://raw.githubusercontent.com/aniinda/track-install/main/track-install.sh | bash
