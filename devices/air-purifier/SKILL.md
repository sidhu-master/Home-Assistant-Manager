---
name: ha-air-purifier
description: Home Assistant 空气净化器技能。控制空气净化器的开关、风速、模式等。当用户要求打开/关闭空气净化器、调节风速时使用此技能。
---

# HA Air Purifier

## 功能

- 🌀 **开关控制**: 打开/关闭空气净化器
- 🌬️ **风速调节**: 调节风速级别
- 🔄 **模式切换**: 自动、睡眠、普通模式
- 📊 **状态查询**: 查看当前运行状态、PM2.5、滤芯寿命

## 配置

需要配置以下环境变量或 config.yaml：

```yaml
devices:
  air_purifier:
    - name: "客厅空气净化器"
      switch_entity_id: "switch.jdjz_kj410_0072_switch_status"
      fan_entity_id: "fan.jdjz_kj410_0072_air_purifier"
      pm25_entity_id: "sensor.jdjz_kj410_0072_pm25_density"
      filter_entity_id: "sensor.jdjz_kj410_0072_filter_life_level"
```

## Entity IDs

默认 Entity ID（可配置）：
- **开关**: `switch.jdjz_kj410_0072_switch_status`
- **风扇**: `fan.jdjz_kj410_0072_air_purifier`
- **PM2.5**: `sensor.jdjz_kj410_0072_pm25_density`
- **滤芯**: `sensor.jdjz_kj410_0072_filter_life_level`

## 使用示例

- "打开空气净化器"
- "关闭净化器"
- "把风速调大"
- "切换到睡眠模式"
- "现在 PM2.5 多少？"
- "滤芯还有多少？"

## HA API 调用

```bash
# 打开净化器
curl -H "Authorization: Bearer $HA_TOKEN" -X POST \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.jdjz_kj410_0072_switch_status"}' \
  "$HA_URL/api/services/switch/turn_on"

# 关闭净化器
curl -H "Authorization: Bearer $HA_TOKEN" -X POST \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.jdjz_kj410_0072_switch_status"}' \
  "$HA_URL/api/services/switch/turn_off"

# 设置风速
curl -H "Authorization: Bearer $HA_TOKEN" -X POST \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "fan.jdjz_kj410_0072_air_purifier", "percentage": 50}' \
  "$HA_URL/api/services/fan/set_percentage"
```

## 适用设备

- J.ZAO 空气净化器 (jdjz.kj410)
- 米家空气净化器（配置对应 entity_id 即可）
- 其他支持 HA 的空气净化器
