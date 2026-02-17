---
name: jdjz-kj410-fan
description: J.ZAO 空气净化器 kj410 专用技能。支持4档风速调节，默认为一档一档调节。
manufacturer: jdjz
model: kj410
device_type: fan
---

# J.ZAO Air Purifier (kj410)

## 档位说明

| 档位 | 百分比 | 说明 |
|------|--------|------|
| 1档 | 25% | 最小风速 |
| 2档 | 50% | 中低风速 |
| 3档 | 75% | 中高风速 |
| 4档 | 100% | 最大风速 |

## Quick Start

### 查询当前状态

```bash
curl -s -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/fan.jdjz_kj410_0072_air_purifier"
```

### 调大风速（每次一档）

```bash
# 调大一档
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "fan.jdjz_kj410_0072_air_purifier",
    "percentage": 50
  }' \
  "$HA_URL/api/services/fan/set_percentage"
```

### 调小风速（每次一档）

```bash
# 调小一档
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "fan.jdjz_kj410_0072_air_purifier",
    "percentage": 25
  }' \
  "$HA_URL/api/services/fan/set_percentage"
```

### 调到最大/最小

```bash
# 调到最大（4档）
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "fan.jdjz_kj410_0072_air_purifier",
    "percentage": 100
  }' \
  "$HA_URL/api/services/fan/set_percentage"

# 调到最小（1档）
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "entity_id": "fan.jdjz_kj410_0072_air_purifier",
    "percentage": 25
  }' \
  "$HA_URL/api/services/fan/set_percentage"
```

### 开关空气净化器

```bash
# 开启
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "fan.jdjz_kj410_0072_air_purifier"}' \
  "$HA_URL/api/services/fan/turn_on"

# 关闭
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "fan.jdjz_kj410_0072_air_purifier"}' \
  "$HA_URL/api/services/fan/turn_off"
```

## Entity IDs

- **风扇**: `fan.jdjz_kj410_0072_air_purifier`
- **开关**: `switch.jdjz_kj410_0072_switch_status`
- **PM2.5**: `sensor.jdjz_kj410_0072_pm25_density`
- **滤芯**: `sensor.jdjz_kj410_0072_filter_life_level`
- **空气质量**: `sensor.jdjz_kj410_0072_air_quality`

## 使用示例

- "空气净化器风速大一点" → 当前档位 +1 档
- "空气净化器风速小一点" → 当前档位 -1 档
- "空气净化器调到最大" → 4档 (100%)
- "空气净化器调到最小" → 1档 (25%)
- "空气净化器开一下" → 开启
- "空气净化器关闭" → 关闭
