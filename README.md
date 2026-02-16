# Home Assistant Manager

OpenClaw 的 HA 智能设备管理器。

## 功能

- 🎯 自动发现 HA 设备
- 🧠 智能调度设备 Skills
- 📦 设备 Skills 包管理

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

## 快速开始

1. 安装 HA Manager
2. 配置 HA 地址和 Token
3. 开始使用！

## 项目结构

```
├── skills/          # 设备 Skills
├── devices/        # 设备配置
├── docs/           # 文档
└── README.md
```

## 开发

详见 [docs/](docs/)
