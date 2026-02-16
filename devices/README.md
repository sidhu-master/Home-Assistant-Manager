# 设备 Skills 索引

本项目包含以下 Home Assistant 设备 Skills：

## 可用设备

| 设备类型 | 目录 | 说明 |
|----------|------|------|
| 温度湿度传感器 | [temp-humidity-sensor](temp-humidity-sensor/) | 读取温湿度、电池数据 |
| 空气净化器 | [air-purifier](air-purifier/) | 控制开关、风速、模式 |

## 添加新设备

1. 在 `devices/` 目录下创建设备目录
2. 创建 `SKILL.md` 文件，包含：
   - 设备功能描述
   - 配置方法
   - Entity IDs
   - HA API 调用示例
3. 更新本索引文件

## 使用方法

每个设备 Skill 都是独立的，可以：
- 直接安装使用
- 复制修改适配自己的设备

配置方式：在 `config.yaml` 中配置对应的 entity_id。
