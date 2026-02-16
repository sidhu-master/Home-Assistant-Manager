# Home Assistant Manager

OpenClaw 的 HA 智能设备管理器。

## 功能

- 🎯 自动发现 HA 设备
- 🧠 智能调度设备 Skills
- 📦 设备 Skills 包管理（一键安装、分享）

## 架构

```
HA Manager (Agent Skill)
    │
    ├── 自动发现 HA 设备
    ├── 识别设备类型
    └── 调度对应 Device Skills
    
Device Skills (设备技能)
    │
    └── 每个设备一个 Skill，可分享、可复用
```

## 项目结构

```
Home-Assistant-Manager/
├── README.md              # 项目说明
├── config.example.yaml    # 配置模板
├── .gitignore
├── devices/               # 设备 Skills 仓库
│   ├── README.md         # 设备索引
│   ├── ha-manager/       # HA Manager 主技能
│   ├── temp-humidity-sensor/  # 温湿度传感器
│   └── air-purifier/     # 空气净化器
└── docs/                 # 文档
```

## 快速开始

### 1. 安装 HA Manager

将 `devices/ha-manager/SKILL.md` 内容配置为 OpenClaw Skill。

### 2. 配置 HA 连接

在环境变量或 config.yaml 中配置：
```yaml
ha:
  url: "http://192.168.56.1:8123"
  token: "your-ha-token"
```

### 3. 配置设备

在 config.yaml 中配置你的设备 entity_id：
```yaml
devices:
  temperature_sensor:
    - entity_id: "sensor.xxx"
      humidity_entity_id: "sensor.xxx"
  air_purifier:
    - switch_entity_id: "switch.xxx"
      fan_entity_id: "fan.xxx"
```

### 4. 使用

- "有哪些设备？"
- "现在温度多少？"
- "打开空气净化器"

## 设备 Skills

| 设备类型 | 目录 | 说明 |
|----------|------|------|
| 温湿度传感器 | [devices/temp-humidity-sensor](devices/temp-humidity-sensor/) | 读取温湿度、电池 |
| 空气净化器 | [devices/air-purifier](devices/air-purifier/) | 控制开关、风速、模式 |

## 添加新设备

详见 [devices/README.md](devices/README.md)

## 开发

详见 [docs/](docs/)
