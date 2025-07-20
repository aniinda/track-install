# 🛠️ track-install

A lightweight server installation tracker that wraps your package installs with **timestamped logs**, **custom labels**, and **queryable history** — perfect for multi-purpose or long-lived Linux servers.

---

## 🚀 Features

- ✅ Tracks successful installations via `apt` with `sudo` privileges
- ✅ Auto-updates package lists before installation
- ✅ Supports **custom labels** per install (`TRACK_LABEL`)
- ✅ Allows **multi-label tagging** (e.g., `db,infra,t1brain`)
- ✅ Stores install logs in `~/.server-installs.log`
- ✅ Includes commands to **query installs by label**
- ✅ Compatible with any Debian/Ubuntu-based server

---

## 📦 Installation

```bash
curl -fsSL https://raw.githubusercontent.com/aniinda/track-install/main/track-install.sh | bash
```

---

## 🎯 Usage

### Basic Installation
```bash
# Install with default label "server-tools"
track-install nginx postgresql

# Install with custom label
TRACK_LABEL="web-stack" track-install apache2 php
```

### Multi-Label Installation
```bash
# Tag with multiple labels
TRACK_LABEL="db,core,production" track-install mysql-server
```

### Query Installations
```bash
# Show specific label
track-install show web-stack

# Show default label
track-install show

# Show all installations
track-install show all
```

### Available Aliases
```bash
ti nginx              # short for track-install
ts web-stack         # short for track-install show
ts                   # show default label
```

---

## 📋 Example Output

```
=== Installations under label: web-stack ===
nginx                ✓ installed
apache2              ✓ installed
php                  ✗ not found
```

---

## 📝 Log Format

Installations are logged to `~/.server-installs.log`:
```
2024-07-20 14:30:22 | web-stack | nginx | username
2024-07-20 14:35:15 | database | mysql-server | username
```
