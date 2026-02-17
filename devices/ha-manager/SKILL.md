---
name: ha-manager
description: Home Assistant 设备管理器。自动发现 HA 设备、智能调度设备 Skills、按需从远程仓库下载设备 Skill。当用户询问 HA 设备状态、控制设备、或需要设备自动化时使用此技能。
---

# Home Assistant Manager

## 功能

- 🔍 **设备发现**: 自动扫描 HA 中的所有设备，识别厂商和型号
- 🧠 **智能调度**: 理解用户意图，分发给对应设备 Skills
- 📦 **按需下载**: 根据设备型号从远程仓库动态下载对应 Skill
- 🔄 **版本检查**: 检查远程仓库更新，提醒用户

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/sidhu-master/Home-Assistant-Manager.git
cd Home-Assistant-Manager
```

### 2. 配置

```bash
cp config.example.yaml config.yaml
# 编辑 config.yaml，填入你的 HA 地址和 Token
```

### 3. 检查配置

```bash
./scripts/check_config.sh
```

### 4. 使用

将 `devices/ha-manager/SKILL.md` 内容配置为 OpenClaw Skill。

## 配置说明

在 `config.yaml` 中配置：

```yaml
# Home Assistant 连接 (必填)
ha:
  url: "http://192.168.56.1:8123"
  token: "your-ha-long-lived-token"

# 设备 Skills 仓库 (可选，默认 sidhu-master/device-skills)
device_skills_repo: "https://github.com/sidhu-master/device-skills"

# 本地设备配置 (可选)
devices: {}
```

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
1. 用户询问设备
2. HA Manager 查询 HA 获取设备信息 (manufacturer + model)
3. 请求 GitHub API:
   GET /repos/{owner}/device-skills/contents/{device_type}/{manufacturer}-{model}/SKILL.md
4. 找到 → 下载使用
5. 找不到 → 使用通用模板:
   GET /repos/{owner}/device-skills/contents/{device_type}/SKILL.md
```

### 匹配优先级

1. `{device_type}/{manufacturer}-{model}/SKILL.md` (精确匹配)
2. `{device_type}/SKILL.md` (通用模板)

## 脚本工具

### check_config.sh
检查配置是否完整:
```bash
./scripts/check_config.sh
```

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
