#!/bin/bash
# HA Manager 配置检查脚本
# 使用: ./scripts/check_config.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 检查 HA Manager 配置..."
echo ""

ERRORS=0

# 检查 config.yaml 是否存在
if [ ! -f "config.yaml" ]; then
    echo -e "${YELLOW}⚠️  config.yaml 不存在${NC}"
    echo "   复制 config.example.yaml 并编辑:"
    echo "   cp config.example.yaml config.yaml"
    ERRORS=$((ERRORS + 1))
    exit 1
fi

# 检查 HA 配置
if grep -q 'url: ""' config.yaml || ! grep -q 'url:' config.yaml; then
    echo -e "${RED}❌ HA URL 未配置${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ HA URL 已配置${NC}"
fi

if grep -q 'token: ""' config.yaml || ! grep -q 'token:' config.yaml; then
    echo -e "${RED}❌ HA Token 未配置${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ HA Token 已配置${NC}"
fi

# 检查 DEVICE_SKILLS_REPO
if ! grep -q 'DEVICE_SKILLS_REPO:' config.yaml; then
    echo -e "${YELLOW}⚠️  DEVICE_SKILLS_REPO 未配置 (可选)${NC}"
    echo "   将使用默认: https://github.com/sidhu-master/device-skills"
fi

echo ""

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}🎉 配置检查通过！${NC}"
    exit 0
else
    echo -e "${RED}❌ 请修复以上 $ERRORS 个问题${NC}"
    exit 1
fi
