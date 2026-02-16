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

HA Manager 会自动维护可用设备 Skills：

| 设备类型 | Skill | 说明 |
|----------|-------|------|
| 温度湿度传感器 | ha-temp-humidity-sensor | 读取温湿度数据 |
| 空气净化器 | ha-air-purifier | 控制净化器开关、模式 |

## 工作流程

1. 接收用户指令
2. 调用 HA API 获取设备状态/执行操作
3. 返回结果给用户
