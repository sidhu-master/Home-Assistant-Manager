---
name: ha-manager
description: Home Assistant 设备管理器。自动发现 HA 设备、智能调度设备 Skills、按需从远程仓库下载设备 Skill。首次使用时自动引导配置，缺少参数时通过聊天窗口询问用户。
---

# Home Assistant Manager

## 功能

- 🔍 **设备发现**: 自动扫描 HA 中的所有设备，识别厂商和型号
- 🧠 **智能调度**: 理解用户意图，分发给对应设备 Skills
- 📦 **按需下载**: 根据设备型号从远程仓库动态下载 Skill
- 🔄 **版本检查**: 检查远程仓库更新，提醒用户
- 🤖 **自动安装**: 首次使用自动引导配置，缺少参数时询问用户

## 快速开始

用户只需发送：

```
"安装 https://github.com/sidhu-master/Home-Assistant-Manager"
```

或直接使用功能（首次会自动引导配置）。

## 首次使用 - 智能安装引导

当检测到未配置 HA 时，会自动进入安装模式：

```
用户: "有哪些设备？"

HA Manager: 📦 首次使用，需要配置...
          
          请提供你的 Home Assistant 地址:
          
用户: "http://192.168.1.100:8123"

HA Manager: ✅ 已保存
          
          请提供你的 HA Token (Long-Lived Access Token):
          
用户: [粘贴 token]

HA Manager: 🔄 验证连接...
          ✅ 配置完成！
          
          现在可以使用了:
          - "有哪些设备？"
          - "现在温度多少？"
```

## 配置说明

配置存储在 `config.yaml`：

```yaml
# Home Assistant 连接 (首次使用时会询问)
ha:
  url: "http://192.168.56.1:8123"
  token: "your-ha-long-lived-token"

# 设备 Skills 仓库 (可选)
device_skills_repo: "https://github.com/sidhu-master/device-skills"
```

### 获取 HA Token

1. 打开 Home Assistant
2. 点击头像 → Security
3. 创建 Long-Lived Access Token
4. 复制 Token 给 HA Manager

## 使用方法

### 查询设备状态
- "有哪些设备？"
- "空调现在是什么状态？"
- "温度传感器数据是多少？"

### 控制设备
- "打开空气净化器"
- "把空调调到 26 度"
- "关闭卧室灯"

### 设备管理
- "发现新设备"
- "列出所有传感器"
- "检查 skills 更新"

### 重新配置
- "重新配置" - 重新引导设置

## 按需下载流程

```
1. 用户询问设备
2. HA Manager 查询 HA 获取设备信息 (manufacturer + model)
3. 请求 GitHub API:
   GET /repos/{owner}/device-skills/contents/{device_type}/{manufacturer}-{model}/SKILL.md
4. 找到 → 下载使用
5. 找不到 → 使用通用模板
```

### 匹配优先级

1. `{device_type}/{manufacturer}-{model}/SKILL.md` (精确匹配)
2. `{device_type}/SKILL.md` (通用模板)

## 脚本工具

### check_config.sh
检查配置是否完整:
```bash
./scripts/check_config.sh
```

## HA API 调用示例

```bash
# 获取所有设备状态
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states"

# 获取设备详情（包含 manufacturer, model）
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/devices"

# 获取单个实体状态
curl -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states/sensor.xxx"

# 调用服务
curl -H "Authorization: Bearer $HA_TOKEN" -X POST \
  -H "Content-Type: application/json" \
  -d '{"entity_id": "switch.xxx"}' \
  "$HA_URL/api/services/switch/turn_on"
```

## 项目结构

```
Home-Assistant-Manager/
├── README.md              # 项目说明
├── config_example.yaml    # 配置模板
├── config.yaml           # 运行时配置 (自动生成)
└── devices/
    └── ha-manager/
        └── SKILL.md     # 主技能
```
