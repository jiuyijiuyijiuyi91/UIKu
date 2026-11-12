-- 移速修改 v1  |  UI 由 XJWUI v1 提供
-- XJWUI 加载器（黑曜石 / WindUI 同款加载形态：一个网址就是整套 UI）
local XJWUI_REPO = "jiuyijiuyijiuyi91/UIKu"
local XJWUI_BRANCH = "main"

local XJWUI_LOCAL_PATHS = { "XJWUI_v1.lua", "UIKu/XJWUI_v1.lua", "Revenant/obsidian/XJWUI_v1.lua" }
local XJWUI_URLS = {
	"https://raw.githubusercontent.com/" .. XJWUI_REPO .. "/" .. XJWUI_BRANCH .. "/XJWUI_v1.lua",
	"https://cdn.jsdelivr.net/gh/" .. XJWUI_REPO .. "@" .. XJWUI_BRANCH .. "/XJWUI_v1.lua",
}

local XJWUI
do
	for _, path in ipairs(XJWUI_LOCAL_PATHS) do
		if XJWUI then break end
		local okLocal, localLib = pcall(function()
			if type(isfile) == "function" and isfile(path) then
				return loadstring(readfile(path))()
			end
		end)
		if okLocal and type(localLib) == "table" and type(localLib.CreateWindow) == "function" then
			XJWUI = localLib
		end
	end

	if not XJWUI then
		for _, url in ipairs(XJWUI_URLS) do
			if XJWUI then break end
			local okRemote, remoteLib = pcall(function()
				return loadstring(game:HttpGet(url))()
			end)
			if okRemote and type(remoteLib) == "table" and type(remoteLib.CreateWindow) == "function" then
				XJWUI = remoteLib
			end
		end
	end
end

if type(XJWUI) ~= "table" or type(XJWUI.CreateWindow) ~= "function" then
	warn("[移速修改] XJWUI 库加载失败: " .. XJWUI_REPO .. "@" .. XJWUI_BRANCH .. "/XJWUI_v1.lua")
	return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Library = XJWUI
local ThemeManager = Library.ThemeManager
local SaveManager = Library.SaveManager

Library:InstallNotify("移速修改")
Library:EnableChinese(true)

local Window = Library:CreateWindow({
	Title = "XJW中心",
	Footer = "感谢支持",
	SidebarWidth = 176,
	TabTextOffset = 38,
	TabTextSize = 15,
})

local BACKGROUND_IMAGE = "https://raw.githubusercontent.com/jiuyijiuyijiuyi91/XJW666/refs/heads/main/XJW%E8%84%9A%E6%9C%AC%E5%A3%81%E7%BA%B8.png"

local BACKGROUND_SCALE_MODE = Enum.ScaleType.Crop

local function fixBackgroundAspect()
	local gui = Library and Library.ScreenGui
	if not gui then return end
	for _, obj in ipairs(gui:GetChildren()) do
		if obj:IsA("ImageLabel") and obj.Image ~= "" and obj.BackgroundTransparency == 1 then
			if obj:FindFirstChildOfClass("UICorner") and obj.ImageTransparency >= 0.5 then
				if obj.ScaleType ~= BACKGROUND_SCALE_MODE then
					obj.ScaleType = BACKGROUND_SCALE_MODE
				end
			end
		end
	end
end

if Library and type(Library.SetBackgroundImage) == "function" then
	pcall(function()
		Library:SetBackgroundImage(BACKGROUND_IMAGE)
	end)
end

fixBackgroundAspect()

if Library and type(Library.SetBackgroundImage) == "function" then
	local rawSetBackgroundImage = Library.SetBackgroundImage
	Library.SetBackgroundImage = function(self, image)
		local ok, res = pcall(rawSetBackgroundImage, self, image)
		task.defer(fixBackgroundAspect)
		if not ok then return nil end
		return res
	end
end

task.spawn(function()
	for _ = 1, 40 do
		fixBackgroundAspect()
		task.wait(0.5)
	end
end)

local function softenOuterBorder()
	local gui = Library and Library.ScreenGui
	if not gui then return end
	local outline = (Library.Scheme and Library.Scheme.OutlineColor) or Color3.fromRGB(70, 70, 80)
	local ok, list = pcall(function()
		return gui:GetDescendants()
	end)
	if not ok or type(list) ~= "table" then return end
	for _, obj in ipairs(list) do
		pcall(function()
			if obj:IsA("UIStroke") then
				local parent = obj.Parent
				local top = parent and parent.Parent
				if top ~= nil and top == gui then

					obj.Color = outline
					obj.Transparency = 1
				elseif obj.Thickness > 1.2 and obj.Thickness < 1.8 then
					obj.Color = outline
					obj.Thickness = 1
					if obj.Transparency < 0.7 then obj.Transparency = 0.7 end
				end
			end
		end)
	end
end

softenOuterBorder()

if type(Library.UpdateColorsUsingRegistry) == "function" then
	local rawUpdateColors = Library.UpdateColorsUsingRegistry
	Library.UpdateColorsUsingRegistry = function(self, ...)
		local res = rawUpdateColors(self, ...)
		pcall(softenOuterBorder)
		return res
	end
end

task.spawn(function()
	for _ = 1, 20 do
		pcall(softenOuterBorder)
		task.wait(0.5)
	end
end)

local CONFIG_FOLDER = "Revenant/configs"

local State = {
	Enabled = false,
	Speed = 16,
	Burst = false,
	BurstSpeed = 64,
	Jump = 50,
	Gravity = 196.2,
	HUD = false,
}

local Defaults = {
	Enabled = false,
	Speed = 16,
	BurstSpeed = 64,
	Jump = 50,
	Gravity = 196.2,
}

local Humanoid = nil
local HUDGui = nil
local HUDLabel = nil
local Syncing = false
local Connections = {}

local function optionEnabled(id, fallback)
	local t = Library.Toggles and Library.Toggles[id]
	if type(t) == "table" and t.Value ~= nil then
		return t.Value == true
	end
	return fallback
end

local function getHumanoid()
	local char = LocalPlayer.Character
	if not char then return nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then return hum end
	return nil
end

local function applySpeed(value)
	Humanoid = getHumanoid()
	if not Humanoid or Humanoid.Health <= 0 then return end
	Humanoid.WalkSpeed = value
end

local function applyJump(value)
	Humanoid = getHumanoid()
	if not Humanoid or Humanoid.Health <= 0 then return end
	if Humanoid.UseJumpPower then
		Humanoid.JumpPower = value
	else
		Humanoid.JumpHeight = value
	end
end

local function clearHUD()
	if HUDGui then
		HUDGui:Destroy()
		HUDGui = nil
		HUDLabel = nil
	end
end

local function buildHUD()
	if HUDGui then return end
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not playerGui then return end

	HUDGui = Instance.new("ScreenGui")
	HUDGui.Name = "RevenantSpeedHUD"
	HUDGui.ResetOnSpawn = false
	HUDGui.IgnoreGuiInset = true
	HUDGui.DisplayOrder = 999
	HUDGui.Parent = playerGui

	local holder = Instance.new("Frame")
	holder.Name = "Holder"
	holder.AnchorPoint = Vector2.new(0.5, 0)
	holder.Position = UDim2.new(0.5, 0, 0, 42)
	holder.Size = UDim2.fromOffset(150, 30)
	holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	holder.BackgroundTransparency = 0.2
	holder.BorderSizePixel = 0
	holder.Parent = HUDGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = holder

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 70, 70)
	stroke.Thickness = 1
	stroke.Transparency = 0.3
	stroke.Parent = holder

	HUDLabel = Instance.new("TextLabel")
	HUDLabel.BackgroundTransparency = 1
	HUDLabel.Size = UDim2.fromScale(1, 1)
	HUDLabel.Font = Enum.Font.GothamMedium
	HUDLabel.TextSize = 14
	HUDLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
	HUDLabel.Text = "速度 16"
	HUDLabel.Parent = holder
end

local SpeedToggle

local function setEnabled(value, silent)
	State.Enabled = value and true or false

	if State.Enabled then
		applySpeed(State.Speed)
	else
		applySpeed(16)
	end

	if SpeedToggle and SpeedToggle.SetValue and not silent then
		Syncing = true
		pcall(function() SpeedToggle:SetValue(State.Enabled) end)
		Syncing = false
	end

end

local Tabs = {
	Home = Window:AddTab("移速修改", "house", "首页 · 概览与快捷操作"),
	User = Window:AddTab("角色", "user", "角色相关功能"),
	Combat = Window:AddTab("战斗", "crosshair", "战斗相关功能"),
	Visuals = Window:AddTab("视觉", "eye", "视觉相关功能"),
	Commands = Window:AddTab("命令", "terminal", "命令相关功能"),
	Map = Window:AddTab("地图", "map", "地图相关功能"),
	Animations = Window:AddTab("动画", "film", "动画相关功能"),
	Disguise = Window:AddTab("伪装", "shirt", "伪装相关功能"),
	Misc = Window:AddTab("杂项", "ellipsis", "杂项功能"),
	Settings = Window:AddTab("界面设置", "settings", "更换界面主题与保存配置！"),
}
local HomeLeft = Tabs.Home:AddLeftGroupbox("概览", "sparkles")
local HomeRight = Tabs.Home:AddRightGroupbox("快捷操作", "star")

HomeLeft:AddLabel("移速修改 | Revenant UI")
local SpeedStatusLabel = HomeLeft:AddLabel("当前速度：" .. tostring(State.Speed))
HomeLeft:AddDivider()
HomeLeft:AddLabel("RightShift 可切换开关")

HomeRight:AddButton({
	Text = "应用默认速度",
	Func = function()
		State.Speed = 16
		applySpeed(16)
		Library:Notify({ Title = "移速修改", Content = "已恢复默认速度 16" })
	end,
})

HomeRight:AddButton({
	Text = "爆发速度",
	Func = function()
		State.Burst = true
		applySpeed(State.BurstSpeed)
		task.delay(3, function()
			State.Burst = false
			if not State.Enabled then
				applySpeed(16)
			else
				applySpeed(State.Speed)
			end
		end)
	end,
})

local UserTabs = Tabs.User:AddLeftTabbox()
local MovePage = UserTabs:AddTab("移动")
local CharPage = UserTabs:AddTab("角色")

local KeybindBox = Tabs.User:AddLeftGroupbox("按键", "keyboard")
local AutomationBox = Tabs.User:AddRightGroupbox("自动化", "bot")
local DashBox = Tabs.User:AddRightGroupbox("冲刺", "wind")

MovePage:AddToggle("SpeedEnabled", {
	Text = "启用移速修改",
	Default = Defaults.Enabled,
	Tooltip = "开启后持续锁定行走速度",
	Callback = function(value)
		if Syncing then
			State.Enabled = value
			return
		end
		setEnabled(value, true)
	end,
})

SpeedToggle = Library.Toggles.SpeedEnabled

MovePage:AddSlider("SpeedValue", {
	Text = "行走速度",
	Default = Defaults.Speed,
	Min = 16,
	Max = 500,
	Rounding = 0,
	Callback = function(value)
		State.Speed = value
		if State.Enabled then
			applySpeed(value)
		end
		if SpeedStatusLabel and type(SpeedStatusLabel.SetText) == "function" then
			pcall(function() SpeedStatusLabel:SetText("当前速度：" .. tostring(math.floor(value))) end)
		end
	end,
})

MovePage:AddInput("SpeedExact", {
	Text = "精确速度",
	Default = tostring(Defaults.Speed),
	Placeholder = "16 - 500",
	Numeric = true,
	Finished = true,
	Callback = function(value)
		local num = tonumber(value)
		if not num then return end
		num = math.clamp(math.floor(num), 16, 500)
		State.Speed = num
		if State.Enabled then
			applySpeed(num)
		end
	end,
})

CharPage:AddSlider("JumpValue", {
	Text = "跳跃力",
	Default = Defaults.Jump,
	Min = 50,
	Max = 500,
	Rounding = 0,
	Callback = function(value)
		State.Jump = value
		applyJump(value)
	end,
})

CharPage:AddSlider("GravityValue", {
	Text = "重力",
	Default = Defaults.Gravity,
	Min = 0,
	Max = 300,
	Rounding = 0,
	Callback = function(value)
		State.Gravity = value
		workspace.Gravity = value
	end,
})

KeybindBox:AddButton({
	Text = "切换移速开关",
	Func = function()
		setEnabled(not State.Enabled)
		Library:Notify({ Title = "移速修改", Content = State.Enabled and "已启用" or "已关闭" })
	end,
})

KeybindBox:AddLabel("移动端不支持键盘键位")

AutomationBox:AddToggle("KeepOnRespawn", {
	Text = "重生后自动恢复",
	Default = true,
	Callback = function() end,
})

AutomationBox:AddToggle("LockCharacter", {
	Text = "换角色后重新锁定",
	Default = true,
	Callback = function() end,
})

DashBox:AddSlider("BurstValue", {
	Text = "爆发速度",
	Default = Defaults.BurstSpeed,
	Min = 32,
	Max = 500,
	Rounding = 0,
	Callback = function(value)
		State.BurstSpeed = value
	end,
})

local VisualLeft = Tabs.Visuals:AddLeftGroupbox("体验优化", "sparkles")
local VisualRight = Tabs.Visuals:AddRightGroupbox("透视", "eye")

VisualLeft:AddToggle("SpeedHUD", {
	Text = "显示速度 HUD",
	Default = false,
	Callback = function(value)
		State.HUD = value
		if value then
			buildHUD()
		else
			clearHUD()
		end
	end,
})

VisualRight:AddLabel("HUD 固定显示于屏幕顶部")

local CmdBox = Tabs.Commands:AddLeftGroupbox("命令脚本", "parentheses")

CmdBox:AddInput("CmdInput", {
	Text = "命令",
	Default = "",
	Placeholder = ";speed 100 | ;reset | ;hud",
	Finished = true,
	Callback = function(value)
		local text = tostring(value or "")
		local cmd, arg = text:match("^;%s*(%a+)%s*(.-)%s*$")
		if not cmd then
			Library:Notify({ Title = "移速修改", Content = "命令需以 ; 开头" })
			return
		end
		cmd = cmd:lower()
		if cmd == "speed" then
			local num = tonumber(arg)
			if not num then
				Library:Notify({ Title = "移速修改", Content = "用法：;speed 数字" })
				return
			end
			num = math.clamp(math.floor(num), 16, 500)
			State.Speed = num
			setEnabled(true)
			Library:Notify({ Title = "移速修改", Content = "速度已设为 " .. tostring(num) })
		elseif cmd == "reset" then
			State.Speed = 16
			setEnabled(false)
			applySpeed(16)
			Library:Notify({ Title = "移速修改", Content = "已重置为默认速度" })
		elseif cmd == "hud" then
			State.HUD = not State.HUD
			if State.HUD then
				buildHUD()
			else
				clearHUD()
			end
			if Library.Toggles and Library.Toggles.SpeedHUD and Library.Toggles.SpeedHUD.SetValue then
				pcall(function() Library.Toggles.SpeedHUD:SetValue(State.HUD) end)
			end
			Library:Notify({ Title = "移速修改", Content = "HUD " .. (State.HUD and "开启" or "关闭") })
		else
			Library:Notify({ Title = "移速修改", Content = "未知命令：" .. cmd })
		end
	end,
})

local SavedCFrame = nil

local MapLeft = Tabs.Map:AddLeftGroupbox("位置", "map")
local MapRight = Tabs.Map:AddRightGroupbox("世界", "earth")

MapLeft:AddButton({
	Text = "保存当前位置",
	Func = function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			Library:Notify({ Title = "地图", Content = "找不到角色" })
			return
		end
		SavedCFrame = hrp.CFrame
		Library:Notify({ Title = "地图", Content = "位置已保存" })
	end,
})

MapLeft:AddButton({
	Text = "传回保存位置",
	Func = function()
		if not SavedCFrame then
			Library:Notify({ Title = "地图", Content = "尚未保存位置" })
			return
		end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			Library:Notify({ Title = "地图", Content = "找不到角色" })
			return
		end
		hrp.CFrame = SavedCFrame
		Library:Notify({ Title = "地图", Content = "已传回保存位置" })
	end,
})

MapRight:AddLabel("重力：" .. tostring(workspace.Gravity))

local AnimBox = Tabs.Animations:AddLeftGroupbox("R6 动画", "person-standing")

AnimBox:AddButton({
	Text = "停止当前动画",
	Func = function()
		local hum2 = getHumanoid()
		local animator = hum2 and hum2:FindFirstChildOfClass("Animator")
		if not animator then
			Library:Notify({ Title = "动画", Content = "找不到 Animator" })
			return
		end
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			pcall(function() track:Stop() end)
		end
		Library:Notify({ Title = "动画", Content = "动画已停止" })
	end,
})

local DisguiseBox = Tabs.Disguise:AddLeftGroupbox("玩家信息", "user")

DisguiseBox:AddLabel("显示名：" .. tostring(LocalPlayer.DisplayName))
DisguiseBox:AddLabel("用户名：" .. tostring(LocalPlayer.Name))
DisguiseBox:AddButton({
	Text = "复制用户名",
	Func = function()
		if type(setclipboard) ~= "function" then
			Library:Notify({ Title = "伪装", Content = "执行器不支持剪贴板" })
			return
		end
		setclipboard(LocalPlayer.Name)
		Library:Notify({ Title = "伪装", Content = "已复制用户名" })
	end,
})

local MiscLeft = Tabs.Misc:AddLeftGroupbox("其他", "star")
local MiscRight = Tabs.Misc:AddRightGroupbox("会话", "server")

MiscLeft:AddLabel("配置保存于 " .. CONFIG_FOLDER)

local function Cleanup()
	Library.Unloaded = true

	for _, conn in ipairs(Connections) do
		pcall(function() conn:Disconnect() end)
	end
	Connections = {}

	clearHUD()

	pcall(function() applySpeed(16) end)

	if Library.Unload then
		pcall(function() Library:Unload() end)
	end
end

MiscRight:AddButton({
	Text = "卸载脚本",
	Func = function()
		Window:AddDialog("RevenantUnloadConfirm", {
			Title = "卸载脚本",
			Description = "确定要卸载脚本吗？所有已启用的功能将被关闭，脚本随即终止。",
			AutoDismiss = true,
			OutsideClickDismiss = true,
			FooterButtons = {
				Cancel = { Title = "取消", Variant = "Ghost", Order = 1, Callback = function() end },
				Unload = { Title = "卸载", Variant = "Destructive", Order = 2, Callback = function() task.defer(Cleanup) end },
			},
		})
	end,
})

local function onCharacter(char)
	Humanoid = char:WaitForChild("Humanoid", 10)
	if not Humanoid then return end

	Humanoid.Died:Connect(function()
		Humanoid = nil
	end)

	if State.Enabled and optionEnabled("KeepOnRespawn", true) then
		task.delay(0.35, function()
			applySpeed(State.Speed)
		end)
	end

end

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(onCharacter))
if LocalPlayer.Character then
	task.spawn(onCharacter, LocalPlayer.Character)
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
	if State.Enabled and not State.Burst and optionEnabled("LockCharacter", true) then
		local hum = getHumanoid()
		if hum and hum.Health > 0 and math.abs(hum.WalkSpeed - State.Speed) > 0.05 then
			hum.WalkSpeed = State.Speed
		end
	end

	if State.HUD and not HUDGui then
		buildHUD()
	end

	if HUDLabel then
		local hum = getHumanoid()
		local spd = hum and math.floor(hum.WalkSpeed) or 0
		HUDLabel.Text = "速度 " .. tostring(spd)
	end
end))

if ThemeManager then
	ThemeManager:SetLibrary(Library)
	ThemeManager:SetFolder("Revenant")
	ThemeManager:ApplyToTab(Tabs.Settings)
end

if SaveManager then
	SaveManager:SetLibrary(Library)
	SaveManager:SetFolder("Revenant")
	SaveManager:BuildConfigSection(Tabs.Settings)
	SaveManager:LoadAutoloadConfig()
end

Tabs.Settings:AddLeftGroupbox("信息", "settings"):AddLabel("基于TSB无延迟UI 改造")

XJWUI:StyleSidebar()


task.defer(function()
	local ok = pcall(function()
		local tab = Tabs.Settings
		local gb = tab and tab.Groupboxes and tab.Groupboxes["Themes"]
		if not gb or type(gb.Elements) ~= "table" then return end

		local native
		for _, el in ipairs(gb.Elements) do
			local isBox = false
			pcall(function() isBox = el.Container ~= nil and el.Container:IsA("TextBox") end)
			if isBox and (el.Text == "Background Image" or el.Text == "背景图片") then
				native = el
				break
			end
		end

		if native then
			if type(native.SetVisible) == "function" then
				pcall(function() native:SetVisible(false) end)
			end
			pcall(function()
				if native.Holder then native.Holder.Visible = false end
			end)
		end

		local imgSel = BACKGROUND_IMAGE
		local presets = {
			{ "默认立绘", BACKGROUND_IMAGE },
			{ "无背景（纯主题配色）", "" },
		}

		if type(ThemeManager) == "table" and type(ThemeManager.BuiltInThemes) == "table" then
			local used = {}
			for name, theme in pairs(ThemeManager.BuiltInThemes) do
				local data = type(theme) == "table" and theme[2]
				local img = type(data) == "table" and data.BackgroundImage
				if type(img) == "string" and img ~= "" and not used[img] and type(name) == "string" then
					used[img] = true
					table.insert(presets, { "主题背景 · " .. name, img })
				end
			end
		end

		local values, map = {}, {}
		for _, p in ipairs(presets) do
			if map[p[1]] == nil then
				map[p[1]] = p[2]
				table.insert(values, p[1])
			end
		end

		local dd = gb:AddDropdown("BackgroundImagePick", {
			Text = "背景图片",
			Values = values,
			Default = values[1],
			AllowNull = false,
			Multi = false,
			Tooltip = "选择窗口背景立绘，支持主题自带背景",
			Callback = function(value)
				local img = map[value]
				if type(img) ~= "string" then return end
				imgSel = img
				if Library and type(Library.SetBackgroundImage) == "function" then
					pcall(function() Library:SetBackgroundImage(img) end)
				end
				task.defer(fixBackgroundAspect)
			end,
		})
		if not dd then return end

		if Library and type(Library.SetBackgroundImage) == "function" then
			pcall(function() Library:SetBackgroundImage(imgSel) end)
		end
		task.spawn(function()
			while true do
				local scheme = Library and Library.Scheme
				if type(scheme) == "table" and type(imgSel) == "string"
					and scheme.BackgroundImage ~= imgSel
					and type(Library.SetBackgroundImage) == "function" then
					pcall(function() Library:SetBackgroundImage(imgSel) end)
					task.defer(fixBackgroundAspect)
				end
				task.wait(0.75)
			end
		end)

		local list = {}
		for _, el in ipairs(gb.Elements) do
			if el ~= dd then table.insert(list, el) end
		end
		local idx = #list
		for i, el in ipairs(list) do
			if el == native then idx = i - 1 break end
		end
		table.insert(list, math.max(1, idx + 1), dd)
		for i, el in ipairs(list) do
			pcall(function()
				if el.Holder then el.Holder.LayoutOrder = i end
			end)
		end
		if type(gb.Resize) == "function" then pcall(function() gb:Resize() end) end
	end)
	if not ok then return end
end)
