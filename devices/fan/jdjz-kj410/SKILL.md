---
name: jdjz-kj410-fan
description: 智米空气净化器
manufacturer: jdjz
model: kj410
device_type: fan
---

# 智米空气净化器 (J.ZAO Humidifying Air Purifier)

## 设备信息

- **开关**: switch.jdjz_kj410_0072_switch_status
- **风扇**: fan.jdjz_kj410_0072_air_purifier
- **PM2.5**: sensor.jdjz_kj410_0072_pm25_density
- **童锁**: switch.jdjz_kj410_0072_physical_controls_locked

## 控制命令

```bash
# 开/关
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.jdjz_kj410_0072_switch_status"}' \
  "$HA_URL/api/services/switch/toggle"

# 设置风速
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "fan.jdjz_kj410_0072_air_purifier", "percentage": 50}' \
  "$HA_URL/api/services/fan/set_percentage"
```

## 查询命令

```bash
# 获取PM2.5
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.jdjz_kj410_0072_pm25_density"

# 获取净化器状态
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/fan.jdjz_kj410_0072_air_purifier"
```

## 使用示例

- "空气净化器打开"
- "净化器风速调大"
- "现在PM2.5多少？"
