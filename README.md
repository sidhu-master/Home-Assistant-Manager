# Home Assistant Manager

OpenClaw 的 HA 智能设备管理器。

## 功能

- 🎯 自动发现 HA 设备（识别厂商+型号）
- 🧠 智能调度设备 Skills
-按需下载** 📦 ** — 根据设备型号从远程仓库动态下载 Skill，不需预先 clone
- 🔄 版本检查 — 检查远程仓库更新

## 架构

```
HA Manager (Agent Skill)
    │
    ├── 自动发现 HA 设备
    ├── 识别设备类型、厂商、型号
    ├── 按需从远程仓库下载 Skill
    └── 调度对应 Device Skills
    
Device Skills (设备技能)
    │
    └── 每个设备一个 Skill，可分享、可复用
```

## 项目结构

```
Home-Assistant-Manager/
├── README.md              # 项目说明
├── README-en.md           # English documentation
├── config_example.yaml    # 配置模板
├── .gitignore
└── devices/               # 本地设备 Skills (可选)
    ├── ha-manager/       # HA Manager 主技能
    ├── temp-humidity-sensor/
    └── air-purifier/
```

## 快速开始

### 1. 配置 HA Manager

将 `devices/ha-manager/SKILL.md` 内容配置为 OpenClaw Skill。

### 2. 配置环境变量

```bash
HA_URL=http://192.168.56.1:8123
HA_TOKEN=your-ha-long-lived-token
DEVICE_SKILLS_REPO=https://github.com/sidhu-master/device-skills
```

### 3. 使用

- "有哪些设备？"
- "现在温度多少？"
- "打开空气净化器"
- "检查 skills 更新"

## 按需下载流程

```
1. 用户询问设备
2. HA Manager 查询 HA 获取设备信息 (manufacturer + model)
3. 请求 GitHub API 查找匹配的 SKILL.md
4. 找到 → 下载使用；找不到 → 使用通用模板
```

### 匹配优先级

1. `device-skills/{type}/{manufacturer}-{model}/SKILL.md` (精确匹配)
2. `device-skills/{type}/SKILL.md` (通用模板)

## 设备 Skills 仓库

使用独立的 [device-skills](https://github.com/sidhu-master/device-skills) 仓库：

| 设备类型 | 目录 | 说明 |
|----------|------|------|
| 温度湿度传感器 | temperature-sensor/ | 读取温湿度、电池 |
| 灯 | light/ | 控制开关、亮度 |
| 开关 | switch/ | 控制开关 |
| 空调 | climate/ | 控制温度、模式 |
| 传感器 | sensor/ | 通用传感器 |

## 添加新设备 Skill

在 [device-skills](https://github.com/sidhu-master/device-skills) 仓库添加：

1. 按设备类型创建目录
2. 添加通用 `SKILL.md` 模板
3. 如有具体型号，创建子目录 `厂商-型号/`

详见 [device-skills/README.md](https://github.com/sidhu-master/device-skills)

## 开发

详见 [docs/](docs/)
