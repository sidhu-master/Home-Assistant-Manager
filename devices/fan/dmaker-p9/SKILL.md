---
name: dmaker-p9-fan
description: 米家直流变频风扇
manufacturer: dmaker
model: p9
device_type: fan
---

# 米家直流变频风扇

## 设备信息

- **风扇**: fan.dmaker_p9_cd5c_fan
- **摇头开关**: switch.dmaker_p9_cd5c_horizontal_swing
- **提示音**: switch.dmaker_p9_cd5c_alarm
- **物理控制锁**: switch.dmaker_p9_cd5c_physical_control_locked

## 控制命令

```bash
# 开/关
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "fan.dmaker_p9_cd5c_fan"}' \
  "$HA_URL/api/services/fan/toggle"

# 设置风速
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "fan.dmaker_p9_cd5c_fan", "percentage": 60}' \
  "$HA_URL/api/services/fan/set_percentage"
```

## 使用示例

- "风扇打开"
- "风速调大"
- "风扇摇头"
