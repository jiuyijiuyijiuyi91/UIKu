---
AIGC:
    Label: "1"
    ContentProducer: 001191440300708461136T1XGW3
    ProduceID: 4dd97f6f7e89a386dd5d6289ccc2c985_be0e5696e27b11f19919525400638852
    ReservedCode1: m6n1xZQbW9bwMizMAlm+mpC8musaQ5ZBE9WDzQ+vNVbUwKi+rcnyVIGGW4aU53+tbRA1WJIqvvXOGRIrqdSdKlUIW4Ete+PmikNnG5DC7+ptT3z88tGxtCOO09e+3k3AhoA3IdnOTQ4KUF/NUIU8k1I7a3m4jp/YOcmhS8T6x4CBVZaV0ioLTUeiLfI=
    ContentPropagator: 001191440300708461136T1XGW3
    PropagateID: 4dd97f6f7e89a386dd5d6289ccc2c985_be0e5696e27b11f19919525400638852
    ReservedCode2: m6n1xZQbW9bwMizMAlm+mpC8musaQ5ZBE9WDzQ+vNVbUwKi+rcnyVIGGW4aU53+tbRA1WJIqvvXOGRIrqdSdKlUIW4Ete+PmikNnG5DC7+ptT3z88tGxtCOO09e+3k3AhoA3IdnOTQ4KUF/NUIU8k1I7a3m4jp/YOcmhS8T6x4CBVZaV0ioLTUeiLfI=
---

# XJWUI 使用说明（v1）

> 对应库文件：`XJWUI_v1.lua`（821 KB / `Version = ""`）
> 上传仓库时请重命名为 `XJWUI_v1.lua`，业务脚本的远程地址仍指向 `XJWUI_v1.lua`。

---

## 一、加载库

脚本头部多源加载（本地优先，失败再走仓库）：

```lua
local XJWUI_REPO = "https://raw.githubusercontent.com/jiuyijiuyijiuyi91/UIKu/main/"
local XJWUI_CDN  = "https://cdn.jsdelivr.net/gh/jiuyijiuyijiuyi91/UIKu@main/"
local XJWUI_NAME = "XJWUI_v1.lua"

local function loadXJWUI()
    local lib
    for _, path in ipairs({ "XJWUI_v1.lua", "UIKu/XJWUI_v1.lua" }) do
        if lib then break end
        local ok, res = pcall(function()
            if isfile and isfile(path) then return loadstring(readfile(path))() end
        end)
        if ok and type(res) == "table" and type(res.CreateWindow) == "function" then lib = res end
    end
    for _, root in ipairs({ XJWUI_REPO, XJWUI_CDN }) do
        if lib then break end
        local ok, res = pcall(function() return loadstring(game:HttpGet(root .. XJWUI_NAME))() end)
        if ok and type(res) == "table" and type(res.CreateWindow) == "function" then lib = res end
    end
    return lib
end

local Library = loadXJWUI()
```

库执行完 `return Library`，同时把同一张表挂到 `getgenv().XJWUI`，两种取用方式都行。

---

## 二、最小接入骨架

```lua
local boot = Library:Boot({ Chinese = true, Scheme = "default" })

local Window = Library:CreateWindow({
    Title = "XJW中心",
    Footer = "感谢支持",
    CornerRadius = 10,
})

local Tabs = {
    Main     = Window:AddTab("示例功能", "sparkles"),
    Settings = Window:AddTab("UI设置", "settings"),
}

-- 业务页
Tabs.Main:AddLeftGroupbox("示例", "zap")
    :AddToggle("Demo", { Text = "示例开关", Default = false })

-- 设置页整页交给库（主题 / 配置 / 悬浮窗 / 卸载）
Library:BuildSettingsTab(Tabs.Settings, { Window = Window, Folder = "Revenant" })

-- 业务页建完后放开选择面板（不调用会一直停住）
task.defer(function() boot:Ready() end)
```

---

## 三、`Library:Boot(opts)`

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `Chinese` | bool | 默认 `true`，界面文案已是内置中文，该开关仅为兼容保留 |
| `Scheme` | string | `"default"`（紫）/ `"orange"`（橙），启动即套配色 |
| `Options` | table | 选择面板按钮文案列表，默认 `{ "黑曜石悬浮窗" }` |
| `OnFinish` | function | 选择完成回调，入参为选中项文案 |

返回 `boot` 句柄：

| 成员 | 说明 |
| --- | --- |
| `boot:Ready()` | 界面就绪，放开选择面板（**必须调用**） |
| `boot:Picked()` / `boot.picked` | 是否已选 |
| `boot:Pick(label)` | 程序化选中某个样式 |
| `boot:Finish()` | 强制结束启动 |
| `boot:HideFloats()` | 临时隐藏全部浮窗 |
| `boot.styleKey` | 当前样式名 |
| `boot.OnApply` | 可赋值函数，结束时回调 |

---

## 四、`Library:CreateWindow(opts)`

| 字段 | 默认 | 说明 |
| --- | --- | --- |
| `Title` / `Footer` | 库默认 | 标题与页脚 |
| `Icon` | 无 | 窗口图标（lucide 名 / 图片 URL / assetId） |
| `CornerRadius` | `10` | 圆角 |
| `MinSidebarWidth` | `168` | 侧边栏最小宽度 |
| `SidebarWidth` | 库默认 | 侧边栏宽度 |
| `TabTextOffset` / `TabTextSize` | 库默认 | 标签文字偏移与字号 |
| `BackgroundImage` | 库默认壁纸 | 传 URL 换背景，传 `false` 关闭自动背景 |
| `TitleFlow` | `true` | 标题流光动效，传 `false` 关闭 |
| `Animations` | 见库 | 逐项开关 `TabSwitch` / `Groupbox` / `Dropdown` / `KeyPicker` |

原生 `Library:CreateWindow(...)` 的参数仍全部可用，两个入口等价。

---

## 五、`Library:BuildSettingsTab(tab, opts)`

| 字段 | 说明 |
| --- | --- |
| `Folder` | 配置与主题根目录，默认 `Revenant` |
| `Window` | 主窗口对象，卸载确认框挂在它上面 |
| `OnUnload` | 自定义卸载回调；不传则执行 `Library:Unload()` |

页面内容：

1. **主题**：字体、五项配色（字体/主色/强调/背景/描边）、主题列表（中文名）、自定义主题名、**背景图片下拉 + 预览**、主题 JSON 导入导出、设为默认。
2. **配置**：配置名、配置列表、创建/加载/覆盖/删除、设为自动加载、配置 JSON 导入导出。
3. **悬浮窗**：开关方式下拉（当前仅「黑曜石悬浮窗」）。
4. **卸载**：「卸载脚本」按钮 → 确认框（取消 / 卸载）。

---

## 六、背景图片机制

- 预设四项：**默认立绘 / 茉莉路 / 群友分享 / 群友分享(2)**，另有「无背景（纯主题配色）」。
- 进设置页默认选中并立即生效「默认立绘」，不留空背景。
- 图片经 5 条 CDN 依次尝试（jsdelivr ×4 域名 + raw.githubusercontent.com），全部失败回退 `XJWUI.Defaults.BackgroundImage`。
- 选中后：设置页显示 120px 实时预览，并在 `Library.Scheme.BackgroundImage` 上挂 1 秒守护循环，主题切换后不会被回写覆盖。
- 单独调用：

```lua
Library:ApplyBackgroundImage("https://.../xxx.png")  -- 应用
Library:SetBackgroundImage("")                       -- 清空为纯主题配色
Library:GetBackgroundImage()                         -- 取当前值
Library:InstallBackgroundDropdown(tab)               -- 手动挂背景下拉（设置页已内置，通常不用）
```

---

## 七、悬浮窗

- 只有一种形态：**黑曜石原生浮标**，96 × 38 长胶囊，横排不重叠，可拖动，点击切换窗口显示。
- 旧样式名（`灵动岛` / `悬浮窗` / `island` / `bar` / `orb`）全部映射到 `obsidian`，`隐藏` / `off` 为关闭。

```lua
Library:SetFloatStyle("obsidian")   -- 安装/切换
Library:SetFloatStyle("off")        -- 隐藏
Library:GetFloatStyle()             -- 取当前名
Library:PickFloatStyle({ Callback = function(name) end })  -- 兼容旧写法，直接回落黑曜石
```

---

## 八、其它常用接口

| 接口 | 说明 |
| --- | --- |
| `Library:Notify(text, title)` | 通知，带音效与标题 |
| `Library:ApplyScheme("default" \| "orange")` | 整体换配色 |
| `Library:Unload()` | 卸载：清连接、销毁所有 `XJW*` ScreenGui，重复调用安全 |
| `Library:Translate(s)` / `Library:EnableChinese(bool)` | 兼容旧代码，现为空实现（文案已直改中文） |
| `Library:StyleSidebar(w, offset, size)` | 调整侧边栏尺寸与标签字号 |
| `Library:SoftenOuterBorder()` | 柔化窗口外描边 |
| `Library:InstallTitleFlow(win, { Title = ... })` | 手动挂标题流光 |
| `Library.ThemeManager` / `Library.SaveManager` | 主题与配置管理器本体 |

---

## 九、组件速查

```lua
Window:AddTab(name, icon)                 -- 标签页
Tab:AddLeftGroupbox(name, icon)           -- 左列分组（另有 AddRightGroupbox）
Group:AddToggle(idx, { Text, Default })   -- 开关
Group:AddSlider(idx, { Text, Min, Max, Default, Rounding })
Group:AddDropdown(idx, { Text, Values, Default, Multi, AllowNull, Callback })
Group:AddKeyPicker(idx, { Text, Default, Mode })
Group:AddButton({ Text, Func })
Group:AddInput(idx, { Text, Default })
Group:AddColorPicker(idx, { Default })
Group:AddLabel(text)                      -- 可链式接 AddColorPicker
Group:AddDivider() / Group:AddImage(idx, {...})
Window:AddDialog(idx, { Title, Description, AutoDismiss, FooterButtons = { ... } })
Dropdown:SetValue(v) / Dropdown:SetValues(list) / Dropdown.Values
```

---

## 十、踩坑提醒（本版已修，勿回退）

1. **`Options.BackgroundImage` 不存在**：背景下拉的注册名是 `BackgroundImagePick`，`BackgroundImage` 只是主题数据里的字段名。旧写法在保存主题时会抛 `attempt to index nil with 'Value'`（v17 已修）。
2. **不要给 `SetBackgroundImage` 传文字名**：传「默认立绘」这类显示名会被图标兜底逻辑画成问号。显示名只走下拉的 `SetValue`，由下拉解析 CDN。
3. **不要叠加第二个背景下拉**：`InstallBackgroundDropdown` 检测到设置页已有「背景图片」下拉会直接返回，自己另建会重复。
4. **卸载确认不要绕过**：走设置页按钮 → `XJWUnloadConfirm` 对话框（取消 / 卸载）；对话框创建失败时才退回「5 秒内再点一次」。
5. **`Version` 留空**：交付文件里不写版本号，靠文件名区分；仓库固定 `XJWUI_v1.lua`。
*（内容由AI生成，仅供参考）*
