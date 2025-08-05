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

# Show all labels you've created
track-install show labels
```

---

## 📖 Complete Command Reference

### Installation Commands
```bash
# Basic installation (default label: "server-tools")
track-install nginx postgresql mysql-server

# Custom single label
TRACK_LABEL="web-stack" track-install apache2 php

# Multiple labels (comma-separated)
TRACK_LABEL="db,core,production" track-install redis-server

# Using alias
ti docker.io git nodejs
```

### Query Commands
```bash
# Show specific label
track-install show web-stack

# Show default label (server-tools)
track-install show

# Show all installations
track-install show all

# Show all labels you've created
track-install show labels
```

### Alias Commands
```bash
ti nginx mysql-server     # Short for track-install
ts                       # Show default label
ts web-stack            # Show specific label  
ts all                  # Show everything
ts labels               # Show all your labels
```

---

## 📋 Example Output

**Package status by label:**
```
=== Installations under label: web-stack ===
nginx                ✓ installed
apache2              ✓ installed
php                  ✗ not found
```

**All your labels:**
```
=== All Created Labels ===
web-stack (3 packages)
database (2 packages)
server-tools (5 packages)
development (4 packages)
```

---

## 📝 Log Format

Installations are logged to `~/.server-installs.log`:
```
2024-07-20 14:30:22 | web-stack | nginx | username
2024-07-20 14:35:15 | database | mysql-server | username
```
