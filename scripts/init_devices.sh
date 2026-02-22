#!/bin/bash
# HA Manager 设备初始化脚本
# 自动从 HA 获取设备并下载/生成对应 Skills

CONFIG_FILE="config.yaml"
DEVICES_DIR="devices"

# 读取配置 (跳过注释行，去除尾部斜杠)
HA_URL=$(grep '^\s*url:' "$CONFIG_FILE" | head -1 | sed 's/.*url: *//' | tr -d '"' | sed 's:/*$::')
HA_TOKEN=$(grep '^\s*token:' "$CONFIG_FILE" | head -1 | sed 's/.*token: *//' | tr -d '"')

if [ -z "$HA_URL" ] || [ -z "$HA_TOKEN" ]; then
    echo "❌ 配置不完整"
    exit 1
fi

echo "🔍 扫描 HA 设备..."

# 获取实体并保存到临时文件
curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states" > /tmp/ha_states.json

# 提取设备信息（按 entity_id 前缀过滤）
DEVICE_COUNT=$(jq '[.[] | select(.entity_id | 
    startswith("sensor.") or 
    startswith("switch.") or 
    startswith("fan.") or 
    startswith("light.") or 
    startswith("binary_sensor.") or
    startswith("climate.") or
    startswith("lock.")
    )] | length' /tmp/ha_states.json 2>/dev/null || echo "0")

if [ "$DEVICE_COUNT" = "0" ] || [ -z "$DEVICE_COUNT" ]; then
    echo "⚠️ 未发现设备"
    exit 0
fi

echo "🔍 发现 $DEVICE_COUNT 个设备"
echo ""

# 列出设备（不使用管道，避免子shell问题）
jq -r '.[] | select(.entity_id | 
    startswith("sensor.") or 
    startswith("switch.") or 
    startswith("fan.") or 
    startswith("light.") or 
    startswith("binary_sensor.") or
    startswith("climate.") or
    startswith("lock.")
    ) | "  - \(.attributes.friendly_name // .entity_id)"' /tmp/ha_states.json | head -15
echo ""

mkdir -p "$DEVICES_DIR"

TOTAL=0
EXACT=0
TEMPLATE=0
GENERATED=0

# 使用进程替换，避免管道子shell问题
while read -r device; do
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
            MAN="chunmi"; MODEL="eh1"; TYPE="switch"
            ;;
        *lumi*lock*|*bmcn03*)
            MAN="lumi"; MODEL="bmcn03"; TYPE="lock"
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
    
done < <(jq -r '.[] | select(.entity_id | 
    startswith("sensor.") or 
    startswith("switch.") or 
    startswith("fan.") or 
    startswith("light.") or 
    startswith("binary_sensor.") or
    startswith("climate.") or
    startswith("lock.")
    ) | @json' /tmp/ha_states.json 2>/dev/null)

echo ""
echo "🎉 初始化完成！"
echo "  精确匹配: $EXACT | 通用模板: $TEMPLATE | 自动生成: $GENERATED"
