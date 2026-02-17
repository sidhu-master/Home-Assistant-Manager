# Home Assistant Manager

[English](README-en.md) / 中文

---

OpenClaw 的 HA 智能设备管理器。

## 功能

- 🎯 **自动发现 HA 设备** — 识别厂商、型号、实体
- 🧠 **智能调度** — 理解用户意图，分发给对应设备 Skills
- ⚡ **自动初始化** — 首次配置后自动下载所有匹配的 Skills
- 🔄 **手动更新** — 用户可主动检查并更新 Skills
- 🤖 **自动安装** — 首次使用自动引导配置

## 架构

```
HA Manager (Agent Skill)
    │
    ├── 自动发现 HA 设备
    ├── 识别设备类型、厂商、型号
    ├── 首次配置后自动初始化 Skills
    ├── 手动更新 Skills (用户触发)
    └── 调度对应 Device Skills
    
Device Skills (设备技能)
    │
    └── 每个设备一个 Skill，可分享、可复用
```

## 快速开始

### 安装

发送仓库地址给 OpenClaw：

```
安装 https://github.com/sidhu-master/Home-Assistant-Manager
```

### 首次配置

OpenClaw 会自动引导：

```
1. 请提供你的 Home Assistant 地址
2. 请提供你的 HA Token
3. ✅ 配置完成，自动初始化 Skills
```

### 获取 HA Token

1. 打开 Home Assistant
2. 点击头像 → Security
3. 创建 Long-Lived Access Token
4. 复制给 OpenClaw

## 项目结构

```
Home-Assistant-Manager/
├── README.md              # 项目说明
├── README-en.md           # English documentation
├── config_example.yaml    # 配置模板
├── config.yaml            # 运行时配置 (自动生成)
├── devices/              # 本地 Skills (自动生成)
└── scripts/
    ├── init_devices.sh   # 初始化 Skills
    └── check_config.sh  # 检查配置
```

## 自动初始化流程

```
1. 用户配置 HA URL + Token
2. 验证连接
3. 自动运行 init_devices.sh
4. 扫描 HA 所有实体
5. 下载匹配的 Skills (精确匹配优先)
6. 找不到匹配的 → 使用通用模板
7. 仍没有 → 自动生成 SKILL.md
```

### 匹配优先级

1. `device-skills/{type}/{manufacturer}-{model}/SKILL.md` (精确匹配)
2. `device-skills/{type}/SKILL.md` (通用模板)

## 手动更新 Skills

用户可以主动更新 Skills：

```
"检查 Skills 更新"
"更新设备 Skills"
```

或重新运行：

```bash
./scripts/init_devices.sh
```

## 设备 Skills 仓库

使用独立的 [device-skills](https://github.com/sidhu-master/device-skills) 仓库：

| 设备类型 | 目录 | 说明 |
|----------|------|------|
| 温度湿度传感器 | [temperature-sensor/](https://github.com/sidhu-master/device-skills/tree/main/temperature-sensor) | 读取温湿度、电池 |
| 风扇/空气净化器 | [fan/](https://github.com/sidhu-master/device-skills/tree/main/fan) | 控制风速、开关 |
| 灯 | [light/](https://github.com/sidhu-master/device-skills/tree/main/light) | 控制开关、亮度 |
| 开关 | [switch/](https://github.com/sidhu-master/device-skills/tree/main/switch) | 控制开关 |
| 空调 | [climate/](https://github.com/sidhu-master/device-skills/tree/main/climate) | 控制温度、模式 |
| 传感器 | [sensor/](https://github.com/sidhu-master/device-skills/tree/main/sensor) | 通用传感器 |
| 门锁 | [lock/](https://github.com/sidhu-master/device-skills/tree/main/lock) | 门锁控制 |

## 添加新设备 Skill

在 [device-skills](https://github.com/sidhu-master/device-skills) 仓库添加：

1. 按设备类型创建目录
2. 添加通用 `SKILL.md` 模板
3. 如有具体型号，创建子目录 `厂商-型号/`

详见 [device-skills/README.md](https://github.com/sidhu-master/device-skills)

## 使用示例

- "有哪些设备？"
- "现在温度多少？"
- "空气净化器大一点"
- "检查 Skills 更新"

## 常见问题

### Q: 初始化后如何添加新设备？
A: 运行 `./scripts/init_devices.sh` 或说"发现新设备"

### Q: 如何更新 Skills？
A: 说"检查 Skills 更新"或重新运行初始化脚本

### Q: 设备没有匹配的 Skill 怎么办？
A: 会自动使用通用模板，或自动生成 SKILL.md

## 开发

详见 [docs/](docs/)
