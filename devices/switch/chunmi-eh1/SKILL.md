---
name: chunmi-eh1-switch
description: 米家智能电饭煲
manufacturer: chunmi
model: eh1
device_type: switch
---

# 米家智能电饭煲

## 设备信息

- **温度**: sensor.chunmi_eh1_db31_temperature
- **自动保温**: switch.chunmi_eh1_db31_auto_keep_warm

## 控制命令

```bash
# 开关自动保温
curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.chunmi_eh1_db31_auto_keep_warm"}' \
  "$HA_URL/api/services/switch/toggle"
```

## 查询命令

```bash
# 获取温度
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.chunmi_eh1_db31_temperature"
```

## 使用示例

- "电饭煲保温打开"
- "现在电饭煲温度多少？"
