# Home Assistant Manager

[English](README-en.md) / [中文](README.md)

---

OpenClaw's HA Smart Device Manager.

## Features

- 🎯 Auto-discover HA devices (identify manufacturer + model)
- 🧠 Intelligent device Skills scheduling
- 📦 **On-demand download** — Dynamically download Skills based on device model
- 🔄 Version check — Check for remote repository updates
- 🤖 **Auto-install** — First use auto-guides configuration, asks user for missing params

## Architecture

```
HA Manager (Agent Skill)
    │
    ├── Auto-discover HA devices
    ├── Identify device type, manufacturer, model
    ├── On-demand download from remote repository
    ├── Auto-guide configuration (first use)
    └── Schedule corresponding Device Skills
    
Device Skills (Device Skills)
    │
    └── Each device has its own Skill, shareable and reusable
```

## Quick Start

### Option 1: Install via repo URL

```
User: "Install https://github.com/sidhu-master/Home-Assistant-Manager"
```

### Option 2: Direct usage (auto-guides first time)

```
User: "What devices do I have?"

HA Manager: 📦 First time setup needed...
          Please provide your Home Assistant URL:
```

## First Use - Smart Install Guide

When HA is not configured, automatically enters install mode:

```
1. User sends any command
2. HA Manager detects not configured
3. Asks: "Please provide your Home Assistant URL"
4. User replies with URL
5. Asks: "Please provide your HA Token"
6. User replies with token
7. ✅ Setup complete, ready to use
```

### Get HA Token

1. Open Home Assistant
2. Click avatar → Security
3. Create Long-Lived Access Token
4. Copy Token to HA Manager

## Project Structure

```
Home-Assistant-Manager/
├── README.md              # Project documentation (Chinese)
├── README-en.md           # English documentation
├── config_example.yaml    # Configuration template
├── config.yaml            # Runtime config (auto-generated)
├── .gitignore
└── devices/
    └── ha-manager/
        └── SKILL.md     # Main skill (includes install guide)
```

## On-Demand Download Flow

```
1. User asks about a device
2. HA Manager queries HA for device info (manufacturer + model)
3. Request GitHub API to find matching SKILL.md
4. Found → download and use; not found → use generic template
```

### Matching Priority

1. `device-skills/{type}/{manufacturer}-{model}/SKILL.md` (exact match)
2. `device-skills/{type}/SKILL.md` (generic template)

## Device Skills Repository

Use separate [device-skills](https://github.com/sidhu-master/device-skills) repository:

| Device Type | Directory | Description |
|-------------|-----------|-------------|
| Temperature/Humidity Sensor | temperature-sensor/ | Read temp, humidity, battery |
| Light | light/ | Control switch, brightness |
| Switch | switch/ | Control switch |
| Air Conditioner | climate/ | Control temperature, mode |
| Sensor | sensor/ | Generic sensor |

## Adding New Device Skills

Add to [device-skills](https://github.com/sidhu-master/device-skills) repository:

1. Create directory by device type
2. Add generic `SKILL.md` template
3. For specific models, create subdirectory `manufacturer-model/`

See [device-skills/README.md](https://github.com/sidhu-master/device-skills)

## Development

See [docs/](docs/)
