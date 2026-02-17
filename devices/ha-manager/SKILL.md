---
name: ha-manager
description: Home Assistant 设备管理器。自动发现 HA 设备、智能调度设备 Skills、首次配置后自动初始化所有设备 Skills。缺少参数时通过聊天窗口询问用户。
---

# Home Assistant Manager

## 功能

- 🔍 **设备发现**: 自动扫描 HA 中的所有设备，识别厂商和型号
- 🧠 **智能调度**: 理解用户意图，分发给对应设备 Skills
- ⚡ **自动初始化**: 配置完成后自动下载/生成所有设备 Skills
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
          
          🔍 正在初始化设备 Skills...
          - 发现设备: 米家温湿度计 T8
            → 下载 temperature-sensor/mijia-t8
          - 发现设备: 空气净化器
            → 使用通用模板 climate
          
          ✅ 初始化完成！共 2 个设备
```

## 自动初始化流程

配置完成 Token 后自动执行：

```
1. 读取 HA 所有实体 (api/states)
2. 识别每个设备的:
   - device_type (sensor, light, switch, climate...)
   - manufacturer (厂商)
   - model (型号)
3. 对每个设备:
   a. 请求 GitHub API 精确匹配:
      GET /repos/{owner}/device-skills/contents/{type}/{manufacturer}-{model}/SKILL.md
   b. 找不到 → 下载通用模板:
      GET /repos/{owner}/device-skills/contents/{type}/SKILL.md
   c. 下载失败 → 自动生成 SKILL.md
4. 保存到 devices/ 目录
5. 返回初始化结果
```

### 设备识别规则

从 HA 实体 attributes 中提取:
- `device_class` → 设备类型
- `manufacturer` → 厂商
- `model` 或 `model_id` → 型号

### 匹配优先级

1. `{device_type}/{manufacturer}-{model}/SKILL.md` (精确匹配)
2. `{device_type}/SKILL.md` (通用模板)

### 自动生成规则

找不到匹配时，根据 entity_id 智能生成:

```yaml
---
name: {manufacturer}-{model}-sensor
description: 自动生成的 {manufacturer} {model} 传感器 Skill
---
# 根据 entity_id pattern 生成 API 调用
# 例如: sensor.xxx_temperature → 温度传感器
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
- "发现新设备" - 重新扫描
- "列出所有传感器"
- "检查 skills 更新"

### 重新配置
- "重新配置" - 重新引导设置

## 脚本工具

### init_devices.sh
自动初始化设备 Skills:
```bash
./scripts/init_devices.sh
```

### check_config.sh
检查配置是否完整:
```bash
./scripts/check_config.sh
```

## 项目结构

```
Home-Assistant-Manager/
├── README.md              # 项目说明
├── config_example.yaml    # 配置模板
├── config.yaml           # 运行时配置 (自动生成)
├── devices/              # 设备 Skills (自动生成)
│   ├── temperature-sensor/
│   │   └── mijia-t8/
│   └── ...
└── scripts/
    ├── init_devices.sh   # 初始化脚本
    └── check_config.sh  # 配置检查
```
