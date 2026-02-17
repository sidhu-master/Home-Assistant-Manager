# Home Assistant Manager

OpenClaw's HA Smart Device Manager.

## Features

- 🎯 Auto-discover HA devices (identify manufacturer + model)
- 🧠 Intelligent device Skills scheduling
- 📦 **On-demand download** — Dynamically download Skills based on device model from remote repository
- 🔄 Version check — Check for remote repository updates

## Architecture

```
HA Manager (Agent Skill)
    │
    ├── Auto-discover HA devices
    ├── Identify device type, manufacturer, model
    ├── On-demand download from remote repository
    └── Schedule corresponding Device Skills
    
Device Skills (Device Skills)
    │
    └── Each device has its own Skill, shareable and reusable
```

## Project Structure

```
Home-Assistant-Manager/
├── README.md              # Project documentation (Chinese)
├── README-en.md           # English documentation
├── config_example.yaml    # Configuration template
├── .gitignore
└── devices/               # Local device Skills (optional)
    ├── ha-manager/       # HA Manager main skill
    ├── temp-humidity-sensor/
    └── air-purifier/
```

## Quick Start

### 1. Configure HA Manager

Configure `devices/ha-manager/SKILL.md` content as an OpenClaw Skill.

### 2. Configure Environment Variables

```bash
HA_URL=http://192.168.56.1:8123
HA_TOKEN=your-ha-long-lived-token
DEVICE_SKILLS_REPO=https://github.com/sidhu-master/device-skills
```

### 3. Usage

- "有哪些设备？" / "What devices do I have?"
- "现在温度多少？" / "What's the temperature now?"
- "打开空气净化器" / "Turn on the air purifier"
- "检查 skills 更新" / "Check for skills updates"

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
