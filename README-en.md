# Home Assistant Manager

[English](README-en.md) / [中文](README.md)

---

OpenClaw's HA Smart Device Manager.

## Features

- 🎯 **Auto-discover HA devices** - Identify manufacturer, model, entities
- 🧠 **Intelligent scheduling** - Understand user intent, dispatch to device Skills
- ⚡ **Auto initialization** - Automatically download all matching Skills after first config
- 🔄 **Manual update** - Users can actively check and update Skills
- 🤖 **Auto-install** - First use auto-guides configuration

## Architecture

```
HA Manager (Agent Skill)
    │
    ├── Auto-discover HA devices
    ├── Identify device type, manufacturer, model
    ├── Auto initialize Skills after first config
    ├── Manual update Skills (user triggered)
    └── Schedule corresponding Device Skills
    
Device Skills (Device Skills)
    │
    └── Each device has its own Skill, shareable and reusable
```

## Quick Start

### Installation

Send repository URL to OpenClaw:

```
Install https://github.com/sidhu-master/Home-Assistant-Manager
```

### First-time Configuration

OpenClaw will auto-guide:

```
1. Please provide your Home Assistant URL
2. Please provide your HA Token
3. ✅ Config complete, auto initialize Skills
```

### Get HA Token

1. Open Home Assistant
2. Click avatar → Security
3. Create Long-Lived Access Token
4. Copy to OpenClaw

## Project Structure

```
Home-Assistant-Manager/
├── README.md              # Project documentation (Chinese)
├── README-en.md           # English documentation
├── config_example.yaml    # Configuration template
├── config.yaml           # Runtime config (auto-generated)
├── devices/              # Local Skills (auto-generated)
└── scripts/
    ├── init_devices.sh   # Initialize Skills
    └── check_config.sh  # Check configuration
```

## Auto Initialization Flow

```
1. User configures HA URL + Token
2. Verify connection
3. Auto run init_devices.sh
4. Scan all HA entities
5. Download matching Skills (exact match first)
6. No match → use generic template
7. Still no match → auto-generate SKILL.md
```

### Matching Priority

1. `device-skills/{type}/{manufacturer}-{model}/SKILL.md` (exact match)
2. `device-skills/{type}/SKILL.md` (generic template)

## Manual Update Skills

Users can actively update Skills:

```
"Check for Skills updates"
"Update device Skills"
```

Or run:

```bash
./scripts/init_devices.sh
```

## Device Skills Repository

Use separate [device-skills](https://github.com/sidhu-master/device-skills) repository:

| Device Type | Directory | Description |
|-------------|-----------|-------------|
| Temperature/Humidity Sensor | [temperature-sensor/](https://github.com/sidhu-master/device-skills/tree/main/temperature-sensor) | Read temp, humidity, battery |
| Fan/Air Purifier | [fan/](https://github.com/sidhu-master/device-skills/tree/main/fan) | Control speed, switch |
| Light | [light/](https://github.com/sidhu-master/device-skills/tree/main/light) | Control switch, brightness |
| Switch | [switch/](https://github.com/sidhu-master/device-skills/tree/main/switch) | Control switch |
| Air Conditioner | [climate/](https://github.com/sidhu-master/device-skills/tree/main/climate) | Control temp, mode |
| Sensor | [sensor/](https://github.com/sidhu-master/device-skills/tree/main/sensor) | Generic sensor |
| Lock | [lock/](https://github.com/sidhu-master/device-skills/tree/main/lock) | Lock control |

## Adding New Device Skills

Add to [device-skills](https://github.com/sidhu-master/device-skills) repository:

1. Create directory by device type
2. Add generic `SKILL.md` template
3. For specific models, create subdirectory `manufacturer-model/`

See [device-skills/README.md](https://github.com/sidhu-master/device-skills)

## Usage Examples

- "What devices do I have?"
- "What's the temperature now?"
- "Turn up the air purifier"
- "Check for Skills updates"

## FAQ

### Q: How to add new devices after initialization?
A: Run `./scripts/init_devices.sh` or say "Discover new devices"

### Q: How to update Skills?
A: Say "Check for Skills updates" or re-run initialization script

### Q: What if device has no matching Skill?
A: Will use generic template, or auto-generate SKILL.md

## Development

See [docs/](docs/)
