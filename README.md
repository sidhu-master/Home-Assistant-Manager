# Home Assistant Manager

[English](README-en.md) / 中文

---

OpenClaw 的 HA 智能设备管理器。

## 功能

- 🎯 自动发现 HA 设备（识别厂商+型号）
- 🧠 智能调度设备 Skills
- 📦 **按需下载** — 根据设备型号从远程仓库动态下载 Skill
- 🔄 版本检查 — 检查远程仓库更新
- 🤖 **自动安装** — 首次使用自动引导配置，缺少参数时询问用户

## 架构

```
HA Manager (Agent Skill)
    │
    ├── 自动发现 HA 设备
    ├── 识别设备类型、厂商、型号
    ├── 按需从远程仓库下载 Skill
    ├── 自动引导配置 (首次使用)
    └── 调度对应 Device Skills
    
Device Skills (设备技能)
    │
    └── 每个设备一个 Skill，可分享、可复用
```

## 快速开始

### 方式一：发送仓库地址安装

```
用户: "安装 https://github.com/sidhu-master/Home-Assistant-Manager"
```

### 方式二：直接使用（首次自动引导）

```
用户: "有哪些设备？"

HA Manager: 📦 首次使用，需要配置...
          请提供你的 Home Assistant 地址:
```

## 首次使用 - 智能安装引导

当检测到未配置 HA 时，自动进入安装模式：

```
1. 用户发送任何指令
2. HA Manager 检测未配置
3. 询问: "请提供你的 Home Assistant 地址"
4. 用户回复地址
5. 询问: "请提供你的 HA Token"
6. 用户回复 token
7. ✅ 配置完成，开始使用
```

### 获取 HA Token

1. 打开 Home Assistant
2. 点击头像 → Security
3. 创建 Long-Lived Access Token
4. 复制 Token 给 HA Manager

## 项目结构

```
Home-Assistant-Manager/
├── README.md              # 项目说明
├── README-en.md           # English documentation
├── config_example.yaml    # 配置模板
├── config.yaml            # 运行时配置 (自动生成)
├── .gitignore
└── devices/
    └── ha-manager/
        └── SKILL.md     # 主技能 (包含安装引导)
```

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
