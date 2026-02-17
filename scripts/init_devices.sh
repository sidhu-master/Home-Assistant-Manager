#!/bin/bash
# HA Manager 设备初始化脚本
# 自动从 HA 获取设备并下载/生成对应 Skills

CONFIG_FILE="config.yaml"
DEVICES_DIR="devices"

# 读取配置
HA_URL=$(grep 'url:' "$CONFIG_FILE" | head -1 | sed 's/.*url: *//' | tr -d '"')
HA_TOKEN=$(grep 'token:' "$CONFIG_FILE" | head -1 | sed 's/.*token: *//' | tr -d '"')

if [ -z "$HA_URL" ] || [ -z "$HA_TOKEN" ]; then
    echo "❌ 配置不完整"
    exit 1
fi

echo "🔍 扫描 HA 设备..."

# 获取实体并保存到临时文件
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states" > /tmp/ha_states.json

# 提取设备信息（按 entity_id 前缀过滤）
DEVICES=$(jq -r '[.[] | select(.entity_id | 
    startswith("sensor.") or 
    startswith("switch.") or 
    startswith("fan.") or 
    startswith("light.") or 
    startswith("binary_sensor.") or
    startswith("climate.")
    )] | unique_by(.entity_id) | .[] | @json' /tmp/ha_states.json 2>/dev/null || echo "[]")

if [ -z "$DEVICES" ]; then
    echo "⚠️ 未发现设备"
    exit 0
fi

echo "$DEVICES" | jq -r '"  - \(.attributes.friendly_name // .entity_id)"' | head -15
echo "  ... (共 $(echo "$DEVICES" | jq 'length') 个)"
echo ""

mkdir -p "$DEVICES_DIR"

TOTAL=0
EXACT=0
TEMPLATE=0
GENERATED=0

echo "$DEVICES" | while read -r device; do
    [ -z "$device" ] && continue
    
    ENTITY_ID=$(echo "$device" | jq -r '.entity_id')
    STATE=$(echo "$device" | jq -r '.state')
    FRIENDLY=$(echo "$device" | jq -r '.attributes.friendly_name // .entity_id')
    
    # 从 entity_id 推断设备信息
    case "$ENTITY_ID" in
        *miaomiaoce*t8*|*miaomiaoce*temperature*|*miaomiaoce*humidity*|*miaomiaoce*battery*)
            MAN="xiaomi"; MODEL="t8"; TYPE="temperature-sensor"
            ;;
        *temperature*)
            MAN="unknown"; MODEL="temperature"; TYPE="temperature-sensor"
            ;;
        *humidity*)
            MAN="unknown"; MODEL="humidity"; TYPE="temperature-sensor"
            ;;
        *battery*)
            MAN="unknown"; MODEL="battery"; TYPE="sensor"
            ;;
        *pm25*)
            MAN="unknown"; MODEL="pm25"; TYPE="sensor"
            ;;
        *switch*)
            MAN="unknown"; MODEL="switch"; TYPE="switch"
            ;;
        *fan*)
            MAN="unknown"; MODEL="fan"; TYPE="fan"
            ;;
        *light*)
            MAN="unknown"; MODEL="light"; TYPE="light"
            ;;
        *climate*)
            MAN="unknown"; MODEL="climate"; TYPE="climate"
            ;;
        *lock*)
            MAN="unknown"; MODEL="lock"; TYPE="lock"
            ;;
        *router*)
            MAN="xiaomi"; MODEL="router"; TYPE="router"
            ;;
        *kj410*|*airp*)
            MAN="jdjz"; MODEL="kj410"; TYPE="fan"
            ;;
        *p9*)
            MAN="dmaker"; MODEL="p9"; TYPE="fan"
            ;;
        *eh1*|*cooker*)
            MAN="chunmi"; MODEL="eh1"; TYPE="appliance"
            ;;
        *)
            continue
            ;;
    esac
    
    TOTAL=$((TOTAL + 1))
    echo "  → $FRIENDLY ($TYPE)"
    
    MAN_LOW=$(echo "$MAN" | tr '[:upper:]' '[:lower:]')
    MOD_LOW=$(echo "$MODEL" | tr '[:upper:]' '[:lower:]')
    
    # 尝试精确匹配
    if [ "$MAN" != "unknown" ] && [ "$MODEL" != "unknown" ]; then
        URL="https://raw.githubusercontent.com/sidhu-master/device-skills/main/$TYPE/${MAN_LOW}-${MOD_LOW}/SKILL.md"
        if curl -sf "$URL" > /dev/null 2>&1; then
            mkdir -p "$DEVICES_DIR/$TYPE/${MAN_LOW}-${MOD_LOW}"
            curl -s "$URL" > "$DEVICES_DIR/$TYPE/${MAN_LOW}-${MOD_LOW}/SKILL.md"
            EXACT=$((EXACT + 1))
            echo "    ✅ 精确匹配"
            continue
        fi
    fi
    
    # 尝试通用模板
    URL="https://raw.githubusercontent.com/sidhu-master/device-skills/main/$TYPE/SKILL.md"
    if curl -sf "$URL" > /dev/null 2>&1; then
        mkdir -p "$DEVICES_DIR/$TYPE/${MAN_LOW}-${MOD_LOW}"
        curl -s "$URL" > "$DEVICES_DIR/$TYPE/${MAN_LOW}-${MOD_LOW}/SKILL.md"
        TEMPLATE=$((TEMPLATE + 1))
        echo "    ✅ 通用模板"
        continue
    fi
    
    # 自动生成
    mkdir -p "$DEVICES_DIR/$TYPE/${MAN_LOW}-${MOD_LOW}"
    cat > "$DEVICES_DIR/$TYPE/${MAN_LOW}-${MOD_LOW}/SKILL.md" << EOF
---
name: ${MAN_LOW}-${MOD_LOW}-${TYPE}
description: 自动生成的 $MAN $MODEL $TYPE Skill
manufacturer: $MAN
model: $MODEL
device_type: $TYPE
---

# $MAN $MODEL $TYPE

## Quick Start

\`\`\`bash
curl -s -H "Authorization: Bearer \$HA_TOKEN" "$HA_URL/api/states/$ENTITY_ID"
\`\`\`

## Entity ID

- **实体**: \`$ENTITY_ID\`
- **状态**: $STATE
EOF
    GENERATED=$((GENERATED + 1))
    echo "    ✅ 自动生成"
    
done

echo ""
echo "🎉 初始化完成！"
echo "  精确匹配: $EXACT | 通用模板: $TEMPLATE | 自动生成: $GENERATED"
