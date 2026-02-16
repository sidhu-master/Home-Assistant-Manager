---
name: ha-temp-humidity-sensor
description: Home Assistant 温度湿度传感器技能。读取米家温湿度计的当前温度、湿度和电池电量数据。当用户询问温度、湿度、室内环境状况时使用此技能。
---

# HA Temperature & Humidity Sensor

## 功能

- 🌡️ 读取当前温度
- 💧 读取当前湿度  
- 🔋 读取电池电量

## 配置

需要配置以下环境变量或 config.yaml：

```yaml
devices:
  temperature_sensor:
    - name: "客厅温湿度计"
      entity_id: "sensor.miaomiaoce_t8_e0e5_temperature"
      humidity_entity_id: "sensor.miaomiaoce_t8_e0e5_relative_humidity"
      battery_entity_id: "sensor.miaomiaoce_t8_e0e5_battery_level"
```

## Entity IDs

默认 Entity ID（可配置）：
- **温度**: `sensor.miaomiaoce_t8_e0e5_temperature`
- **湿度**: `sensor.miaomiaoce_t8_e0e5_relative_humidity`
- **电池**: `sensor.miaomiaoce_t8_e0e5_battery_level`

## 使用示例

- "现在温度多少？"
- "湿度是多少？"
- "室内环境怎么样？"
- "电池还有多少？"

## HA API 调用

```bash
# 获取温度
curl -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/sensor.miaomiaoce_t8_e0e5_temperature"

# 获取湿度
curl -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/sensor.miaomiaoce_t8_e0e5_relative_humidity"

# 获取电池
curl -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/sensor.miaomiaoce_t8_e0e5_battery_level"
```

## 适用设备

- 米家温湿度计 (Xiaomi Miaomiaoce T8)
- 其他支持 HA 的温湿度传感器（配置对应 entity_id 即可）
