---
AIGC:
    Label: "1"
    ContentProducer: 001191440300708461136T1XGW3
    ProduceID: 4dd97f6f7e89a386dd5d6289ccc2c985_951f8a7de01611f19919525400638852
    ReservedCode1: OYVXjdly5ldCMWM4MddmyUO/cKl+n+6dECcF/IlMM7mZSJdVhU2eezc09E9l57D7WUAtI7ky22TduOT/E8OvbJu8wlqjJ8SvuZMgO7mD6rqM2PY/mx0UTAMi3Am34FdHFZy7WtgMhtJKDejZt6uiJE9kxuokyQlQxAy4ciHyP7rHEMcxSuycY5ohH/U=
    ContentPropagator: 001191440300708461136T1XGW3
    PropagateID: 4dd97f6f7e89a386dd5d6289ccc2c985_951f8a7de01611f19919525400638852
    ReservedCode2: OYVXjdly5ldCMWM4MddmyUO/cKl+n+6dECcF/IlMM7mZSJdVhU2eezc09E9l57D7WUAtI7ky22TduOT/E8OvbJu8wlqjJ8SvuZMgO7mD6rqM2PY/mx0UTAMi3Am34FdHFZy7WtgMhtJKDejZt6uiJE9kxuokyQlQxAy4ciHyP7rHEMcxSuycY5ohH/U=
---



# XJWUI v1 使用说明（启动流程 / 开关方式 / 设置页全量内置）

本轮改造目标：**加载动画、开关方式三选一、UI 设置页汉化与全部功能，全部由库本体提供**，业务脚本里不再保留任何一份实现。

仓库文件：`XJWUI_v1.lua`，内部 `Version = "v1"`。

## 一、和以前最大的区别

| 项目 | 旧版（脚本内实现） | v1 现在 |
|---|---|---|
| 加载动画 | 脚本里自己写 CreateLoading + 阶段文案 | `Library:Boot()` 一行调用，库内六阶段 |
| 开关方式三选一 | 脚本里手搓 pickerGui / BOOT 状态机 | 同上，库内面板，配色跟随主题 |
| 选择期隐藏浮窗 | 脚本自己 hideFloats + 打补丁 | 库内 `BootHiding` 开关，`SetFloatStyle` 自动让路 |
| 设置页汉化 | 脚本内挂 REV_I18N 词典 | 库内 `EnableChinese(true)`，Boot 默认开启 |
| 悬浮窗样式 / 配色 / 背景图 / 保存 / 主题 | 脚本逐个 AddDropdown 拼 | `Library:BuildSettingsTab(tab, {Window=...})` |
| 卸载对话框 | 脚本自己 AddDialog | 设置页内建「卸载」分组，走 `Library:Unload()` |

## 二、业务脚本现在只剩这么点

```lua
local Library = loadXJWUI()  -- 本地/仓库多源加载，和以前一样

local boot = Library:Boot({ Title = "XJW中心", Chinese = true, Scheme = "orange" })

local Window = Library:CreateWindow({ Title = "XJW中心", Footer = "感谢支持", CornerRadius = 10 })
local Tabs = {
    Main = Window:AddTab("示例功能", "sparkles"),
    Settings = Window:AddTab("UI设置", "settings"),
}

Tabs.Main:AddLeftGroupbox("示例", "zap"):AddToggle("Demo", { Text = "示例开关", Default = false })

Library:BuildSettingsTab(Tabs.Settings, { Window = Window, Folder = "Revenant" })

task.defer(function() boot:Ready() end)  -- 业务页建完，放开选择面板
```

## 三、`Library:Boot(opts)` 参数

| 字段 | 类型 | 默认 | 说明 |
|---|---|---|---|
| `Title` | string | 库默认标题 | 加载窗与首阶段文案 |
| `Options` | table | `{"灵动岛","悬浮窗","黑曜石悬浮窗"}` | 三选一按钮文案，顺序即按钮顺序 |
| `Chinese` | bool | `true` | 是否自动打开全量汉化 |
| `Scheme` | string | 不改 | 启动即套配色，`orange` / `default` |
| `Loading` | table | — | 覆盖加载窗参数，如 `{WindowWidth=460, WindowHeight=220}` |
| `OnFinish` | function | — | 选完后回调，入参为选中的样式名 |

返回 `boot` 句柄：

| 成员 | 说明 |
|---|---|
| `boot:Ready()` | 界面就绪，放开选择面板（必须调用，否则一直停在 90%） |
| `boot.Finish()` | 强制结束加载（不做选择时兜底） |
| `boot.styleKey` | 当前选中的样式名 |
| `boot.HideFloats()` | 手动隐藏全部浮窗 |

## 四、`Library:BuildSettingsTab(tab, opts)` 内建内容

`opts`：`{ Window = <主窗口>, Folder = "Revenant", OnUnload = function, Chinese = bool }`

页面包含（全部已汉化）：

1. **主题管理**：字体、字体颜色、主题列表、自定义主题名、背景图片、主题 JSON 导入导出、设为默认/重置、对比度检查提示。
2. **配置管理**：配置名、配置列表、创建/加载/覆盖/删除、设为自动加载、配置 JSON 导入导出。
3. **悬浮窗**：开关方式下拉（灵动岛 / 悬浮窗 / 黑曜石悬浮窗 / 隐藏）、重新选择开关方式、配色下拉（橙曜 / 默认紫）。
4. **卸载**：按钮 → 确认对话框（取消 / 卸载）→ 调 `Library:Unload()`。

## 五、接口清单

| 接口 | 说明 |
|---|---|
| `Library:Boot(opts)` | 启动流程总入口（同 `Library.StartBoot`） |
| `Library.GetBoot()` | 取当前 boot 句柄 |
| `Library:Unload()` | 卸载：断开信号、触发 OnUnload、销毁 XJW* 全部 GUI |
| `XJWUI.BootHiding` | 选择期隐藏浮窗开关，`SetFloatStyle` 期间只记状态不落地 |
| `XJWUI.BootForce` | 置 true 可打破上面的让路逻辑，立即安装浮窗 |

## 六、兼容性说明

- 旧写法 `Library:PickFloatStyle(...)`、`Library:SetFloatStyle(...)`、`Library:ApplyScheme(...)`、`Library:InstallTitleFlow(...)`、`Library:CreateLoading(...)` 全部保留，签名不变。
- `BuildSettingsTab` 的开关方式下拉默认值会优先取 `boot.styleKey`，选完即同步。
- `Library:Unload()` 会先执行库内原有清理逻辑，再补销毁 `XJW*` 前缀的 ScreenGui 与浮窗对象，重复调用安全。
*（内容由AI生成，仅供参考）*
*（内容由AI生成，仅供参考）*
