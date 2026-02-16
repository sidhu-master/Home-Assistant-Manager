---
name: ha-manager
description: Home Assistant 设备管理器。自动发现 HA 设备、智能调度设备 Skills。当用户询问 HA 设备状态、控制设备、或需要设备自动化时使用此技能。
---

# Home Assistant Manager

## 功能

- 🔍 **设备发现**: 自动扫描 HA 中的所有设备
- 🧠 **智能调度**: 理解用户意图，分发给对应设备 Skills
- 📦 **设备 Skills 管理**: 维护可用设备 Skills 列表

## 配置

需要配置以下环境变量：
- `HA_URL`: Home Assistant 地址 (例如 http://192.168.56.1:8123)
- `HA_TOKEN`: Home Assistant Long-Lived Access Token

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

## 设备 Skills

HA Manager 会根据用户指令，自动调用对应设备 Skills：

| 设备类型 | Skill | 说明 |
|----------|-------|------|
| 温度湿度传感器 | devices/temp-humidity-sensor | 读取温湿度数据 |
| 空气净化器 | devices/air-purifier | 控制净化器开关、模式 |

## 工作流程

1. 接收用户指令
2. 解析意图（查询/控制/发现）
3. 调用对应设备 Skill 或直接操作 HA API
4. 返回结果给用户

## HA API 调用示例

```bash
# 获取所有设备状态
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states"

# 获取单个实体状态
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.xxx"

# 调用服务
curl -H "Authorization: Bearer $HA_TOKEN" -X POST \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.xxx"}' \
  "$HA_URL/api/services/switch/turn_on"
```
