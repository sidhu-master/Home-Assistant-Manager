---
name: xiaomi-t8-temperature-sensor
description: 米家温湿度计 T8
manufacturer: xiaomi
model: t8
device_type: temperature-sensor
---

# 米家温湿度计 T8

## 设备信息

- **温度**: sensor.miaomiaoce_t8_e0e5_temperature
- **湿度**: sensor.miaomiaoce_t8_e0e5_relative_humidity
- **电池**: sensor.miaomiaoce_t8_e0e5_battery_level

## 查询命令

```bash
# 获取温度
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.miaomiaoce_t8_e0e5_temperature"

# 获取湿度
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.miaomiaoce_t8_e0e5_relative_humidity"

# 获取电池
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.miaomiaoce_t8_e0e5_battery_level"
```

## 使用示例

- "现在温度多少？"
- "湿度怎么样？"
- "温湿度计电池还有多少？"
