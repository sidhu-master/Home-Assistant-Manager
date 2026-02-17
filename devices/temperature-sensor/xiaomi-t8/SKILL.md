---
name: temperature-sensor
description: 通用温度湿度传感器Skill。读取HA中温度、湿度传感器数据。需要配置具体的entity_id。
---

# Temperature & Humidity Sensor Skill

## Quick Start

读取 HA API 获取传感器数据：

```bash
# 温度
curl -s -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/$ENTITY_TEMPERATURE"

# 湿度  
curl -s -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/$ENTITY_HUMIDITY"

# 电池（如有）
curl -s -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/$ENTITY_BATTERY"
```

## 配置

需要在 TOOLS.md 或环境变量中配置：
- `HA_URL`: Home Assistant 地址
- `HA_TOKEN`: Home Assistant Long-Lived Access Token
- `ENTITY_TEMPERATURE`: 温度传感器 entity_id（例如 sensor.xxx_temperature）
- `ENTITY_HUMIDITY`: 湿度传感器 entity_id
- `ENTITY_BATTERY`: 电池传感器 entity_id（可选）

## 使用示例

- "现在温度多少？"
- "湿度是多少？"
- "室内环境怎么样？"
- "电池还有多少？"

## 适配说明

此为通用模板。匹配到具体设备型号后，会自动填充具体的 entity_id。
