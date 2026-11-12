---
AIGC:
    Label: "1"
    ContentProducer: 001191440300708461136T1XGW3
    ProduceID: 4dd97f6f7e89a386dd5d6289ccc2c985_9b3c51e7debe11f1997d52540024e231
    ReservedCode1: Uj60egshADUUqOm8WVG8hbRZXqkKJK6O39JSRHqP3e2zjRPvHwudv9twBsl2AZupj4DaYPJl99/yyuTdc7E13ZZ2eDccWxb4qnp4msd9uWHpecNQTj0bxl817UtEIo3VAk3UkdpKz34gfmMVUdp7lVScknCm9aVRzmcKd3kbqZ6hZTDVE2rjBbQXzpw=
    ContentPropagator: 001191440300708461136T1XGW3
    PropagateID: 4dd97f6f7e89a386dd5d6289ccc2c985_9b3c51e7debe11f1997d52540024e231
    ReservedCode2: Uj60egshADUUqOm8WVG8hbRZXqkKJK6O39JSRHqP3e2zjRPvHwudv9twBsl2AZupj4DaYPJl99/yyuTdc7E13ZZ2eDccWxb4qnp4msd9uWHpecNQTj0bxl817UtEIo3VAk3UkdpKz34gfmMVUdp7lVScknCm9aVRzmcKd3kbqZ6hZTDVE2rjBbQXzpw=
---





# XJWUI v1 使用说明

## 一句话

`XJWUI_v1.lua` 是**自包含 UI 库**：内核 Library + ThemeManager + SaveManager 全部内嵌在同一个文件里。
加载这一个网址，拿到的就是完整窗口 UI（与 WindUI / 黑曜石 `loadstring(game:HttpGet(...))()` 的用法一致）。

## 1. 上传（只需做一次）

把 `XJWUI_v1.lua` 上传到仓库根目录：

```
https://github.com/jiuyijiuyijiuyi91/UIKu
分支：main
路径：XJWUI_v1.lua
```

上传后以下两个地址即可直接加载：

```
https://raw.githubusercontent.com/jiuyijiuyijiuyi91/UIKu/main/XJWUI_v1.lua
https://cdn.jsdelivr.net/gh/jiuyijiuyijiuyi91/UIKu@main/XJWUI_v1.lua
```

## 2. 最简加载（一个网址 = 一个 UI）

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jiuyijiuyijiuyi91/UIKu/main/XJWUI_v1.lua"))()

local Window = Library:CreateWindow({
	Title = "XJW中心",
	Footer = "感谢支持",
})
```

`Library` 就是原生黑曜石库表（`CreateWindow / Notify / Unload / Toggles / ScreenGui / Scheme / SetBackgroundImage …` 全部可用），
本库扩展接口直接挂在这张表上，不需要 `.Library` 再加一层。

## 3. 扩展接口

| 接口 | 作用 |
| --- | --- |
| `Library:CreateWindow(opts)` | 原生 CreateWindow 的默认参数合并版，`Title / Footer / SidebarWidth / TabTextOffset / TabTextSize / CornerRadius / MinSidebarWidth` 可只传部分 |
| `Library:StyleSidebar(w, offset, size)` | 侧栏中文文字强制显示（默认 176 / 38 / 15） |
| `Library:EnableChinese(bool)` | 设置页（主题 / 配置 / 弹窗 / 搜索框）汉化 |
| `Library:Translate(str)` | 单条文案翻译 |
| `Library:InstallNotify(title)` | 统一通知标题，并翻译通知正文 |
| `Library.NotifyText(content, title)` | 快捷通知 |
| `Library.ThemeManager / Library.SaveManager` | 主题、配置管理器（可直接 `SetLibrary(Library)`） |
| `Library.__XJWCreateWindowRaw(opts)` | 原生 CreateWindow（不走默认值合并） |

## 4. 控件写法（与黑曜石一致）

```lua
local Window = Library:CreateWindow({ Title = "XJW中心" })
local Tab = Window:AddTab("主页")
local Group = Tab:AddLeftGroupbox("基础")

Group:AddToggle("FlagId", { Text = "开关", Default = false, Callback = function(v) end })
Group:AddSlider("SliderId", { Text = "滑块", Min = 1, Max = 100, Default = 50, Rounding = 0 })
Group:AddButton("BtnId", { Text = "按钮", Func = function() end })
Group:AddLabel("说明文字")
```

## 5. 文件清单

| 文件 | 说明 |
| --- | --- |
| `XJWUI_v1.lua` | 自包含 UI 库（唯一需要上传到仓库的文件，约 640KB） |
| `XJWUI_示例_v1.lua` | v1 示例：远程加载 + 窗口 / 控件 / 主题配置 / 通知的完整示例 |
| `移速修改_v1.lua` | 业务脚本：加载 XJWUI 后建窗口，只含功能逻辑，可独立更新 |

## 6. 本地加载（不走网络）

执行器支持文件时，把 `XJWUI_v1.lua` 放到 workspace，然后：

```lua
local Library = loadstring(readfile("XJWUI_v1.lua"))()
```

## 7. 注意

- 库内不写死背景立绘，`SetBackgroundImage` 由业务脚本控制，避免覆盖你的默认立绘逻辑。
- `Library.ForceCheckbox = true` 已内置，开关走勾选框样式，与之前版本外观一致。
- 若 `SaveManager` 因执行器缺少 `writefile/isfolder` 而初始化失败，库会降级跳过它，界面仍正常显示。
*（内容由AI生成，仅供参考）*
*（内容由AI生成，仅供参考）*
*（内容由AI生成，仅供参考）*
