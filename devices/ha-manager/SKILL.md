---
name: ha-manager
description: Home Assistant 设备管理器。自动发现 HA 设备、智能调度设备 Skills、按需从远程仓库下载设备 Skill。当用户询问 HA 设备状态、控制设备、或需要设备自动化时使用此技能。
---

# Home Assistant Manager

## 功能

- 🔍 **设备发现**: 自动扫描 HA 中的所有设备，识别厂商和型号
- 🧠 **智能调度**: 理解用户意图，分发给对应设备 Skills
- 📦 **按需下载**: 根据设备型号从远程仓库动态下载对应 Skill，不需要预先 clone 整个仓库
- 🔄 **版本检查**: 检查远程仓库更新，提醒用户

## 配置

需要配置以下环境变量：
- `HA_URL`: Home Assistant 地址 (例如 http://192.168.56.1:8123)
- `HA_TOKEN`: Home Assistant Long-Lived Access Token
- `DEVICE_SKILLS_REPO`: 设备 Skills 仓库地址 (例如 https://github.com/sidhu-master/device-skills)

## 使用方法

### 查询设备状态
- "有哪些设备？"
- "空调现在是什么状态？"
- "温度传感器数据是多少？"

### 控制设备
- "打开空气净化器"
- "把空调调到 26 度"
- "关闭卧室灯"

### 设备管理
- "发现新设备"
- "列出所有传感器"
- "检查 skills 更新"

## 按需下载流程

```
1. 获取 HA 设备信息 (manufacturer + model)
2. 判断设备类型 (sensor, light, switch, climate...)
3. 请求 GitHub API:
   GET /repos/{owner}/device-skills/contents/{device_type}/{manufacturer}-{model}/SKILL.md
4. 找到 → 下载使用
5. 找不到 → 使用通用模板:
   GET /repos/{owner}/device-skills/contents/{device_type}/SKILL.md
```

### 匹配规则

目录结构:
```
device-skills/
├── temperature-sensor/      # 设备类型
│   ├── SKILL.md            # 通用模板
│   ├── mijia-t8/           # 具体型号
│   │   └── SKILL.md
│   └── aqara-t1/
│       └── SKILL.md
├── light/
├── switch/
└── ...
```

匹配优先级:
1. `{device_type}/{manufacturer}-{model}/SKILL.md` (精确匹配)
2. `{device_type}/SKILL.md` (通用模板)

## 工作流程

1. 接收用户指令
2. 从 HA 获取设备信息（厂商、型号、实体ID）
3. 按需从远程仓库下载对应 Skill
4. 调用 Skill 操作 HA API
5. 返回结果给用户

## HA API 调用示例

```bash
# 获取所有设备状态
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states"

# 获取设备详情（包含 manufacturer, model）
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/devices"

# 获取单个实体状态
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.xxx"

# 调用服务
curl -H "Authorization: Bearer $HA_TOKEN" -X POST \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.xxx"}' \
  "$HA_URL/api/services/switch/turn_on"
```

## GitHub API 调用示例

```bash
# 获取设备类型目录
curl -s https://api.github.com/repos/sidhu-master/device-skills/contents/temperature-sensor

# 下载具体型号的 SKILL
curl -s https://raw.githubusercontent.com/sidhu-master/device-skills/main/temperature-sensor/mijia-t8/SKILL.md
```
