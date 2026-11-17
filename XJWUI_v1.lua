






















XJWUI = {Version = "", Defaults = {
	Title = "XJW中心",
	Footer = "感谢支持",
	SidebarWidth = 176,
	TabTextOffset = 38,
	TabTextSize = 15,
	NotifyTitle = "提示",
	NotifySoundId = 106145041472451,
	CornerRadius = 10,
	MinSidebarWidth = 168,
	ConfigFolder = "Revenant",
	BackgroundImage = "https://raw.githubusercontent.com/jiuyijiuyijiuyi91/XJW666/refs/heads/main/XJW%E8%84%9A%E6%9C%AC%E5%A3%81%E7%BA%B8.png",
	I18n = false,
}}

Players = game:GetService("Players")
RunService = game:GetService("RunService")
UIS = game:GetService("UserInputService")
HttpService = game:GetService("HttpService")
LocalPlayer = Players.LocalPlayer

DIR = "Revenant"
REPO = "https://raw.githubusercontent.com/jiuyijiuyijiuyi91/UIKu/main/" -- 你自己的仓库地址，保留


local LIBRARY_SOURCE = [====[
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService: GuiService = cloneref(game:GetService("GuiService"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

-- [内联版] 原第三方远程 BaseURL 已移除：Obsidian 资源改用 Roblox 官方资产 ID，无任何远程下载





local GuiNameOptions = {
    "ControlFrame", "TopBarApp", "MenuApp", "ChatMain", "PlayerListApp",
    "BubbleChat", "PurchasePromptApp", "BackpackApp", "EmotesMenuApp",
    "GameSettingsMenu", "RobloxPromptGui", "DevConsoleMaster", "VoiceChatApp",
}
local function RandomGuiName()
    return GuiNameOptions[math.random(1, #GuiNameOptions)]
end
local CustomImageManager = {}
local CustomImageManagerAssets = {
    TransparencyTexture = {
        RobloxId = 139785960036434,
        Path = "Obsidian/assets/TransparencyTexture.png",
        URL = nil, -- [内联版] 不再远程下载

        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "Obsidian/assets/SaturationMap.png",
        URL = nil, -- [内联版] 不再远程下载

        Id = nil,
    },

    LoadingIcon = {
        RobloxId = 97544096941083,
        Path = "Obsidian/assets/LoadingIcon.png",
        URL = nil, -- [内联版] 不再远程下载

        Id = nil,
    },

    CheckIcon = {
        RobloxId = 97682394690683,
        Path = "Obsidian/assets/CheckIcon.png",
        URL = nil, -- [内联版] 不再远程下载

        Id = nil,
    },
}
do
    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
        if not isfolder or not makefolder then
            return
        end

        local Segments = Path:split("/")
        local TraversedPath = ""

        if IsFile then
            table.remove(Segments, #Segments)
        end

        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath .. Segment) then
                makefolder(TraversedPath .. Segment)
            end

            TraversedPath = TraversedPath .. Segment .. "/"
        end

        return TraversedPath
    end

    function CustomImageManager.AddAsset(
        AssetName: string,
        RobloxAssetId: number,
        URL: string,
        ForceRedownload: boolean?
    )
        if CustomImageManagerAssets[AssetName] ~= nil then
            error(string.format("Asset %q already exists", AssetName))
        end

        assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

        CustomImageManagerAssets[AssetName] = {
            RobloxId = RobloxAssetId,
            Path = string.format("Obsidian/custom_assets/%s", AssetName),
            URL = URL,

            Id = nil,
        }

        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
    end

    function CustomImageManager.GetAsset(AssetName: string)
        if not CustomImageManagerAssets[AssetName] then
            return nil
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then
            return AssetData.Id
        end

        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)

            if Success and NewID then
                AssetID = NewID
            end
        end

        AssetData.Id = AssetID
        return AssetID
    end

    function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
        if not getcustomasset or not writefile or not isfile then
            return false, "missing functions"
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if not AssetData or not AssetData.URL then
            return false, "embedded-assets-only: 无远程 URL"
        end

        RecursiveCreatePath(AssetData.Path, true)

        if ForceRedownload ~= true and isfile(AssetData.Path) then
            return true, nil
        end

        local success, errorMessage = pcall(function()
            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
        end)

        return success, errorMessage
    end

    for AssetName, _ in CustomImageManagerAssets do
        CustomImageManager.DownloadAsset(AssetName)
    end
end

local Library = {
    LocalPlayer = LocalPlayer,
    IsRobloxFocused = true,

    
    DevicePlatform = nil,
    IsMobile = false,

    
    ScreenGui = nil,
    Floats = nil,
    Overlay = nil,

    Window = nil,
    WindowContainer = nil,

    
    SearchText = "",
    Searching = false,
    GlobalSearch = false,
    LastSearchTab = nil,

    
    ActiveTab = nil,
    PreviousTab = nil,
    Tabs = {},
    TabButtons = {},

    
    DependencyBoxes = {},

    
    KeybindFrame = nil,
    KeybindContainer = nil,
    KeybindToggles = {},
    KeybindMenu = nil,

    
    Notifications = {},
    NotifySide = "Right",
    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    
    Dialogues = {},
    ActiveDialog = nil,

    
    ActiveLoading = nil,

    
    ContextMenus = {}, 

    
    Corners = {},
    SpecificCorners = {},

    
    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TabSwipeOffset = 26,
    TabSwipeFrom = "bottom",

    WindowAnimationInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
        Dropdown = false,
        KeyPicker = false
    },

    
    Toggled = false,
    Unloaded = false,

    
    Labels = Labels,
    Buttons = Buttons,
    Toggles = Toggles,
    Options = Options,

    
    ToggleKeybind = Enum.KeyCode.RightControl,
    ShowToggleFrameInKeybinds = true,

    NotifyOnError = false,
    ShowCustomCursor = true,
    ForceCheckbox = false,

    CantDragForced = false,
    DraggableElements = {},

    
    PopOutSnapDistance = 80,
    PopOutDragThreshold = 8,
    PopOutHoldTime = 0.15,

    
    Signals = {},
    UnloadSignals = {},

    OriginalMinSize = Vector2.new(480, 360),
    MinSize = Vector2.new(480, 360),
    DPIScale = 1,
    CornerRadius = 4,

    
    IsLightTheme = false,
    Scheme = {
        BackgroundColor = Color3.fromRGB(16, 12, 8),
        MainColor = Color3.fromRGB(30, 22, 14),
        AccentColor = Color3.fromRGB(255, 146, 44),
        OutlineColor = Color3.fromRGB(76, 54, 26),
        FontColor = Color3.new(1, 1, 1),
        Font = Font.fromEnum(Enum.Font.Code),

        RedColor = Color3.fromRGB(255, 50, 50),
        DestructiveColor = Color3.fromRGB(220, 38, 38),
        DarkColor = Color3.new(0, 0, 0),
        WhiteColor = Color3.new(1, 1, 1),

        BackgroundImage = ""
    },

    
    Registry = {},
    Scales = {},
    ScalesOffset = {},

    
    OriginalMouseIconEnabled = UserInputService.MouseIconEnabled,
    ShowCursorBinding = string.sub(tostring({}), 10),

    
    ImageManager = CustomImageManager,

    
    Notify = nil, Toggle = nil 
}

if RunService:IsStudio() then
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        Library.IsMobile = true
        Library.OriginalMinSize = Vector2.new(480, 240)
    else
        Library.IsMobile = false
        Library.OriginalMinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        Library.DevicePlatform = UserInputService:GetPlatform()
    end)

    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

local Templates = {
    
    Frame = {
        BorderSizePixel = 0,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    },
    ImageButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
    },
    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        PlaceholderColor3 = function()
            local H, S, V = Library.Scheme.FontColor:ToHSV()
            return Color3.fromHSV(H, S, V / 2)
        end,
        Text = "",
        TextColor3 = "FontColor",
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder,
    },
    UIStroke = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    },

    
    Window = {
        Title = "无标题",
        Footer = "No Footer",

        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(720, 600),
        IconSize = UDim2.fromOffset(30, 30),

        AutoShow = true,
        Center = true,
        Resizable = true,
        AlwaysOnTop = false,

        
        Snapping = false,
        SnapDistance = 28,
        SnapMargin = 8,
        SnapAvoidCoreGui = true,

        SearchbarSize = UDim2.fromScale(1, 1),
        GlobalSearch = false,

        CornerRadius = 4,
        NotifySide = "Right",
        ShowCustomCursor = true,

        Font = Enum.Font.Code,
        ToggleKeybind = Enum.KeyCode.RightControl,

        ShowMobileButtons = true,
        MobileButtonsSide = "Left",

        UnlockMouseWhileOpen = true,

        EnableSidebarResize = false,
        EnableCompacting = true,
        DisableCompactingSnap = false,
        SidebarCompacted = false,
        MinContainerWidth = 256,

        
        MinSidebarWidth = 128,
        SidebarCompactWidth = 48,
        SidebarCollapseThreshold = 0.5,

        
        CompactWidthActivation = 128,

        
        BackgroundImage = "",

        
        Animations = {
            ToggleWindow = false,
            TabSwitch = false,
            Groupbox = false,
            Dropdown = false,
            KeyPicker = false,
        },

        TabTransitionTime = 0.22,
        TabSwipeOffset = 26,
        TabSwipeFrom = "bottom",
        TabButtonsStyle = {
            Gap = 0,
            Padding = 0,
            CornerRadius = 0,
            Indicator = false,
            IndicatorWidth = 2,
            IndicatorHeight = 20,
        },
    },
    Groupbox = {
        Side = 1,
        Name = "Groupbox",
        IconName = nil,
        Description = nil,
        Visible = true,
        Collapsed = false,
        DisableCollapsing = false,
        MaxHeight = nil,
        PopOut = true,
        MaxPopOutHeight = nil,
        PopOutWidth = nil,
    },
    Tabbox = {
        Side = 1,
        Name = nil,
        MaxHeight = nil,
        PopOut = true,
        MaxPopOutHeight = nil,
        PopOutWidth = nil,
    },
    Settings = {
        Width = nil,
    },
    Dialog = {
        Title = "提示",
        Description = "描述",
        AutoDismiss = true,
        OutsideClickDismiss = true,
        FooterButtons = {}
    },
    Loading = {
        Title = "加载中",
        Icon = 95816097006870,
        IconSize = UDim2.fromOffset(30, 30),

        LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
        LoadingIconColor = nil,
        LoadingIconTweenTime = 1,

        CurrentStep = 0,
        TotalSteps = 10,

        ShowSidebar = false,
        AutoResizeHeight = false,
        AlwaysOnTop = true,

        WindowWidth = 450,
        WindowHeight = 275,

        ContentWidth = 450,
        SidebarWidth = 250,
    },
    Toggle = {
        Text = "开关",
        Default = false,

        Callback = function() end,
        Changed = function() end,

        Risky = false,
        Disabled = false,
        Visible = true,
    },
    Input = {
        Text = "输入框",
        Default = "",
        Finished = false,
        Numeric = false,
        ClearTextOnFocus = true,
        ClearTextOnBlur = false,
        Placeholder = "",
        AllowEmpty = true,
        EmptyReset = "---",

        Callback = function() end,
        Changed = function() end,
        VerifyValue = nil,

        Disabled = false,
        Visible = true,
    },
    Slider = {
        Text = "滑块",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,

        Prefix = "",
        Suffix = "",

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,

        AllowRightClickInput = true
    },
    Dropdown = {
        Values = {},
        DisabledValues = {},
        ValueImages = {},

        Multi = false,
        DragSelect = false,
        MaxVisibleDropdownItems = 8,
        KeepDisabledValuePosition = false,
        AutoWidth = false,

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,
    },
    Viewport = {
        Object = nil,
        Camera = nil,
        Clone = true,
        AutoFocus = true,
        Interactive = false,
        Height = 200,
        Visible = true,
    },
    Image = {
        Image = "",
        Transparency = 0,
        BackgroundTransparency = 0,
        Color = Color3.new(1, 1, 1),
        RectOffset = Vector2.zero,
        RectSize = Vector2.zero,
        ScaleType = Enum.ScaleType.Fit,
        Height = 200,
        Visible = true,
    },
    Video = {
        Video = "",
        Looped = false,
        Playing = false,
        Volume = 1,
        Height = 200,
        Visible = true,
    },
    UIPassthrough = {
        Instance = nil,
        Height = 24,
        Visible = true,
    },

    
    KeyPicker = {
        Text = "按键选择",

        Default = "None",
        DefaultModifiers = {},

        Blacklisted = {},
        BlacklistedModifiers = {},
        Whitelisted = {},
        WhitelistedModifiers = {},

        Mode = "Toggle",
        Modes = { "Always", "Toggle", "Hold" },
        SyncToggleState = false,

        Callback = function() end,
        ChangedCallback = function() end,
        Changed = function() end,
        Clicked = function() end,
    },
    ColorPicker = {
        Default = Color3.new(1, 1, 1),

        Resizable = true,

        Callback = function() end,
        Changed = function() end,
    },
}

local Places = {
    Bottom = { 0, 1 },
    Right = { 1, 0 },
}
local Sizes = {
    Left = { 0.5, 1 },
    Right = { 0.5, 1 },
}
local SideIndex = {
    left = 1,
    right = 2,
}


local SchemeReplaceAlias = {
    RedColor = "Red",
    WhiteColor = "White",
    DarkColor = "Dark"
}

local SchemeAlias = {
    Red = "RedColor",
    White = "WhiteColor",
    Dark = "DarkColor"
}

local function GetSchemeValue(Index)
    if not Index then
        return nil
    end

    local ReplaceAliasIndex = SchemeReplaceAlias[Index]
    if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
        Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
        Library.Scheme[ReplaceAliasIndex] = nil

        return Library.Scheme[Index]
    end

    local AliasIndex = SchemeAlias[Index]
    if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
        warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
        return Library.Scheme[AliasIndex]
    end

    return Library.Scheme[Index]
end

local function GetTextStrokeColor(): Color3
    local Color = Library.Scheme.FontColor
    return (Color.R * 0.299 + Color.G * 0.587 + Color.B * 0.114) > 0.5 and Library.Scheme.DarkColor or Library.Scheme.WhiteColor
end


local function WaitForEvent(Event, Timeout, Condition)
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition) == "function" and Condition(...) then
            Bindable:Fire(true)
        else
            Bindable:Fire(false)
        end
    end)
    task.delay(Timeout, function()
        Connection:Disconnect()
        Bindable:Fire(false)
    end)

    local Result = Bindable.Event:Wait()
    Bindable:Destroy()

    return Result
end

local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
        or Input.UserInputType == Enum.UserInputType.Touch
end
local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and Input.UserInputState == Enum.UserInputState.Begin
        and Library.IsRobloxFocused
end
local function IsHoverInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Input.UserInputState == Enum.UserInputState.Change
end
local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
        and Library.IsRobloxFocused
end
local function IsMouseClickInput(Input: InputObject)
    return Input.UserInputType == Enum.UserInputType.MouseButton1 or
        Input.UserInputType == Enum.UserInputType.MouseButton2 or
        Input.UserInputType == Enum.UserInputType.MouseButton3
end
local function IsMovementInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Library.IsRobloxFocused
end

local function GetTableSize(Table: { [any]: any })
    local Size = 0

    for _, _ in Table do
        Size += 1
    end

    return Size
end
local function IsSequentialArray(Table: { [any]: any })
    for Key in Table do
        if typeof(Key) ~= "number" or Key < 1 or Key % 1 ~= 0 then
            return false
        end
    end

    return true
end

local function IsDropdownDivider(Value: any): boolean
    return typeof(Value) == "table" and Value.DropdownDivider == true
end

local function EscapeRichText(Text: string): string
    return (tostring(Text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

function Library:DropdownDivider(Title: string?)
    return { DropdownDivider = true, Title = Title }
end

local function StopTween(Tween: TweenBase, Destroy: boolean?)
    if not Tween then
        return
    end

    if Tween.PlaybackState == Enum.PlaybackState.Playing then
        Tween:Cancel()
    end

    if Destroy == true then
        pcall(Tween.Destroy, Tween)
    end
end

local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end
local function Round(Value, Rounding)
    assert(Rounding >= 0, "Invalid rounding number.")

    if Rounding == 0 then
        return math.floor(Value)
    end

    return tonumber(string.format("%." .. Rounding .. "f", Value))
end


local function LowerText(Text: string): string
    return (Text:lower():gsub("[\195\206\208][\128-\191]", function(Char)
        local Code = utf8.codepoint(Char)
        if (Code >= 0xC0 and Code <= 0xDE and Code ~= 0xD7) or (Code >= 0x391 and Code <= 0x3AB) or (Code >= 0x410 and Code <= 0x42F) then
            return utf8.char(Code + 32)
        elseif Code >= 0x400 and Code <= 0x40F then
            return utf8.char(Code + 80)
        end

        return Char
    end))
end

local function FuzzyScore(Text: string, Search: string): (boolean, number)
    if Search == "" then
        return true, 0
    end
    if Text == "" then
        return false, 0
    end

    
    local ExactIdx = Text:find(Search, 1, true)
    if ExactIdx then
        local PrevChar = ExactIdx > 1 and Text:sub(ExactIdx - 1, ExactIdx - 1) or ""
        local AtBoundary = ExactIdx == 1 or PrevChar:match("[%s%p_]") ~= nil

        return true, 1e5 - ExactIdx + (AtBoundary and 500 or 0) + (Search:len() * 5)
    end

    
    local TextChars, SearchChars = {}, {}
    for Char in Text:gmatch(utf8.charpattern) do table.insert(TextChars, Char) end
    for Char in Search:gmatch(utf8.charpattern) do table.insert(SearchChars, Char) end

    local TextLen, SearchLen = #TextChars, #SearchChars
    if SearchLen > TextLen then
        return false, 0
    end

    local SearchIdx = 1
    local Score = 0
    local RunLength = 0
    local LastMatchIdx = 0

    for TextIdx = 1, TextLen do
        if SearchIdx > SearchLen then
            break
        end

        if TextChars[TextIdx] == SearchChars[SearchIdx] then
            local PrevChar = TextIdx > 1 and TextChars[TextIdx - 1] or ""
            local AtBoundary = TextIdx == 1 or PrevChar:match("[%s%p_]") ~= nil

            RunLength = (LastMatchIdx == TextIdx - 1) and (RunLength + 1) or 1
            Score += 1 + (AtBoundary and 6 or 0) + math.min(RunLength - 1, 5) * 3

            LastMatchIdx = TextIdx
            SearchIdx += 1
        end
    end

    if SearchIdx <= SearchLen then
        return false, 0 
    end

    Score -= (LastMatchIdx - SearchLen) * 0.05 
    return true, Score
end

local function NormalizeSearch(Search: string): string
    return (Search:gsub("%s+", ""))
end

local function TryFuzzyMatch(Text: any, Search: string): (boolean, number)
    if typeof(Text) ~= "string" or Text == "" then
        return false, 0
    end

    return FuzzyScore(LowerText(Text), Search)
end

local function FuzzyMatchScore(Text: any, Search: string): number
    if typeof(Text) ~= "string" or Text == "" then
        return 0
    end

    local Normalized = NormalizeSearch(LowerText(Text))
    local Matched, Score = FuzzyScore(Normalized, Search)
    if not Matched then
        return 0
    end

    if Normalized == Search then
        Score += 1000
    end

    return Score
end

local function MatchesSearch(ElementInfo, Search: string, ForceMatch: boolean?): boolean
    if not ElementInfo then
        return false
    end
    if ForceMatch then
        return true
    end

    if TryFuzzyMatch(ElementInfo.Text, Search) then
        return true
    end
    if TryFuzzyMatch(ElementInfo.Tooltip, Search) then
        return true
    end
    if TryFuzzyMatch(ElementInfo.DisabledTooltip, Search) then
        return true
    end

    
    if typeof(ElementInfo.Values) == "table" then
        local Checked = 0
        for Key, Value in ElementInfo.Values do
            Checked += 1
            if Checked > 200 then
                break
            end

            if IsDropdownDivider(Value) then
                continue
            end

            if TryFuzzyMatch(Value, Search) or (typeof(Value) ~= "string" and TryFuzzyMatch(tostring(Value), Search)) then
                return true
            end
            if typeof(Key) == "string" and TryFuzzyMatch(Key, Search) then
                return true
            end
        end
    end

    return false
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
    local PlayerList = Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)
        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    return PlayerList
end
local function GetTeams()
    local TeamList = Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
    end)

    return TeamList
end

function Library:UpdateDependencyBoxes()
    for _, Depbox in Library.DependencyBoxes do
        Depbox:Update(true)
    end

    if Library.Searching then
        Library:UpdateSearch(Library.SearchText)
    end
end

function Library:UpdateAddons(Parent)
    if not Parent or not Parent.Addons then
        return
    end

    for _, Addon in Parent.Addons do
        Addon:Update()
    end
end

local function CheckDepbox(Box, Search, ForceVisible: boolean?)
    local VisibleElements = 0
    local BestScore = 0

    for _, ElementInfo in Box.Elements do
        if ElementInfo.Type == "Divider" then
            ElementInfo.Holder.Visible = false
            continue
        elseif ElementInfo.SubButton then
            
            local Visible = false

            
            if MatchesSearch(ElementInfo, Search, ForceVisible) and ElementInfo.Visible then
                Visible = true
                BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
            else
                ElementInfo.Base.Visible = false
            end
            if MatchesSearch(ElementInfo.SubButton, Search, ForceVisible) and ElementInfo.SubButton.Visible then
                Visible = true
                BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.SubButton.Text, Search))
            else
                ElementInfo.SubButton.Base.Visible = false
            end
            ElementInfo.Holder.Visible = Visible
            if Visible then
                VisibleElements += 1
            end

            continue
        end

        
        if ElementInfo.Text and MatchesSearch(ElementInfo, Search, ForceVisible) and ElementInfo.Visible then
            ElementInfo.Holder.Visible = true
            VisibleElements += 1
            BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
        else
            ElementInfo.Holder.Visible = false
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        if not Depbox.Visible then
            continue
        end

        local DepVisible, DepScore = CheckDepbox(Depbox, Search, ForceVisible)
        VisibleElements += DepVisible
        if DepScore > BestScore then
            BestScore = DepScore
        end
    end

    Box.Holder.Visible = VisibleElements > 0
    return VisibleElements, BestScore
end
local function RestoreDepbox(Box)
    for _, ElementInfo in Box.Elements do
        ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

        if ElementInfo.SubButton then
            ElementInfo.Base.Visible = ElementInfo.Visible
            ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
        end
    end

    for _, Depbox in Box.DependencyBoxes do
        RestoreDepbox(Depbox)
    end

    Box.Holder.Visible = Box.Visible
    if Box.Visible then
        Box:Resize()
    end
end


function SyncPopOutVisibility(Box: any)
    if not Box.PopOutFloat then
        return
    end

    Box.PopOutFloat.Visible = Box.BoxHolder.Visible ~= false and Box.Visible ~= false
end

local function RegisterPopOutClone(Source: Instance, Clone: Instance)
    local SourceProps = Library.Registry[Source]
    if SourceProps then
        local CloneProps = {}
        for Property, Index in SourceProps do
            if Property ~= "FontFace" then
                CloneProps[Property] = Index
            end
        end
        if next(CloneProps) then
            Library.Registry[Clone] = CloneProps
        end
    end

    local SourceChildren = Source:GetChildren()
    local CloneChildren = Clone:GetChildren()
    for Index = 1, math.min(#SourceChildren, #CloneChildren) do
        RegisterPopOutClone(SourceChildren[Index], CloneChildren[Index])
    end
end

local function DimPopOutClone(Root: GuiObject)
    for _, Descendant in Root:QueryDescendants("TextLabel, TextButton, TextBox") do
        Descendant.TextTransparency = math.max(Descendant.TextTransparency, 0.45)
    end

    for _, Descendant in Root:QueryDescendants("ImageLabel, ImageButton") do
        Descendant.ImageTransparency = math.max(Descendant.ImageTransparency, 0.45)
    end

    for _, Descendant in Root:QueryDescendants("GuiButton") do
        Descendant.Active = false
        Descendant.AutoButtonColor = false
    end
end

local function IsScreenPointOutsideMain(Point: Vector2): boolean
    local MainFrame = Library.Window and Library.Window.MainFrame
    if not MainFrame or not Library.Toggled or not MainFrame.Visible then
        return true
    end

    return not Library:MouseIsOverFrame(MainFrame, Point)
end

local function GetTopFloatAt(Point: Vector2): GuiObject?
    local Best: GuiObject? = nil
    local BestOrder = -math.huge
    local Floats = Library.Floats

    for _, Surface in Library.DraggableElements do
        if not Surface or not Surface.Parent or not Surface.Visible then
            continue
        end
        if Floats and Surface.Parent ~= Floats then
            continue
        end
        if not Library:MouseIsOverFrame(Surface, Point) then
            continue
        end

        local SiblingIndex = tonumber(select(2, pcall(function() return Surface:GetSiblingIndex() end))) or 0
        local Order = Surface.ZIndex * 100000 + SiblingIndex
        if Order >= BestOrder then
            BestOrder = Order
            Best = Surface
        end
    end

    return Best
end

local function GetPopOutBodyMaxHeight(Box: any, Reserved: number): number
    local Float = Box.PopOutFloat
    local ScreenGui = Library.ScreenGui
    if not Float or not ScreenGui then
        return math.huge
    end

    local Gap = 12 * Library.DPIScale
    local MaxBottom = ScreenGui.AbsolutePosition.Y + ScreenGui.AbsoluteSize.Y - Gap
    local Available = math.min(MaxBottom - Float.AbsolutePosition.Y, ScreenGui.AbsoluteSize.Y * 0.9)
    local ScreenMax = math.max(0, Available / Library.DPIScale - Reserved)

    local CustomMax = Box.PopOutMaxHeight
    if typeof(CustomMax) == "number" then
        return math.min(ScreenMax, math.max(0, CustomMax))
    end

    return ScreenMax
end


local function ApplySearchToTab(Tab, Search)
    if not Tab then
        return false, 0
    end

    local HasVisible = false
    local BestScore = 0

    
    local TabMatches = TryFuzzyMatch(Tab.Name, Search) or TryFuzzyMatch(Tab.Description, Search)
    BestScore = math.max(BestScore, FuzzyMatchScore(Tab.Name, Search), FuzzyMatchScore(Tab.Description, Search))

    for _, Groupbox in Tab.Groupboxes do
        if Groupbox.Visible == false then
            continue
        end

        
        local GroupboxMatches = TabMatches or (TryFuzzyMatch(Groupbox.Name, Search) or TryFuzzyMatch(Groupbox.Description, Search))
        BestScore = math.max(BestScore, FuzzyMatchScore(Groupbox.Name, Search), FuzzyMatchScore(Groupbox.Description, Search))

        local VisibleElements = 0
        for _, ElementInfo in Groupbox.Elements do
            if ElementInfo.Type == "Divider" then
                ElementInfo.Holder.Visible = false
                continue
            elseif ElementInfo.SubButton then
                
                local Visible = false
                if MatchesSearch(ElementInfo, Search, GroupboxMatches) and ElementInfo.Visible then
                    Visible = true
                    BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
                else
                    ElementInfo.Base.Visible = false
                end

                if MatchesSearch(ElementInfo.SubButton, Search, GroupboxMatches) and ElementInfo.SubButton.Visible then
                    Visible = true
                    BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.SubButton.Text, Search))
                else
                    ElementInfo.SubButton.Base.Visible = false
                end

                ElementInfo.Holder.Visible = Visible
                if Visible then
                    VisibleElements += 1
                end

                continue
            end

            
            if ElementInfo.Text and MatchesSearch(ElementInfo, Search, GroupboxMatches) and ElementInfo.Visible then
                ElementInfo.Holder.Visible = true
                VisibleElements += 1
                BestScore = math.max(BestScore, FuzzyMatchScore(ElementInfo.Text, Search))
            else
                ElementInfo.Holder.Visible = false
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            if not Depbox.Visible then
                continue
            end

            local DepVisible, DepScore = CheckDepbox(Depbox, Search, GroupboxMatches)
            VisibleElements += DepVisible
            if DepScore > BestScore then
                BestScore = DepScore
            end
        end

        
        if VisibleElements > 0 then
            Groupbox:Resize()
            HasVisible = true
        end
        Groupbox.BoxHolder.Visible = VisibleElements > 0
        SyncPopOutVisibility(Groupbox)
    end

    for _, Tabbox in Tab.Tabboxes do
        local VisibleTabs = 0
        local VisibleElements = {}
        local SubTabScores = {}

        for _, SubTab in Tabbox.Tabs do
            VisibleElements[SubTab] = 0

            
            local SubTabMatches = TabMatches or TryFuzzyMatch(SubTab.Name, Search)
            local SubScore = FuzzyMatchScore(SubTab.Name, Search)
            BestScore = math.max(BestScore, SubScore)

            for _, ElementInfo in SubTab.Elements do
                if ElementInfo.Type == "Divider" then
                    ElementInfo.Holder.Visible = false
                    continue
                elseif ElementInfo.SubButton then
                    
                    local Visible = false
                    if MatchesSearch(ElementInfo, Search, SubTabMatches) and ElementInfo.Visible then
                        Visible = true
                        local ElementScore = FuzzyMatchScore(ElementInfo.Text, Search)
                        SubScore = math.max(SubScore, ElementScore)
                        BestScore = math.max(BestScore, ElementScore)
                    else
                        ElementInfo.Base.Visible = false
                    end

                    if MatchesSearch(ElementInfo.SubButton, Search, SubTabMatches) and ElementInfo.SubButton.Visible then
                        Visible = true
                        local ElementScore = FuzzyMatchScore(ElementInfo.SubButton.Text, Search)
                        SubScore = math.max(SubScore, ElementScore)
                        BestScore = math.max(BestScore, ElementScore)
                    else
                        ElementInfo.SubButton.Base.Visible = false
                    end

                    ElementInfo.Holder.Visible = Visible
                    if Visible then
                        VisibleElements[SubTab] += 1
                    end

                    continue
                end

                
                if ElementInfo.Text and MatchesSearch(ElementInfo, Search, SubTabMatches) and ElementInfo.Visible then
                    ElementInfo.Holder.Visible = true
                    VisibleElements[SubTab] += 1
                    local ElementScore = FuzzyMatchScore(ElementInfo.Text, Search)
                    SubScore = math.max(SubScore, ElementScore)
                    BestScore = math.max(BestScore, ElementScore)
                else
                    ElementInfo.Holder.Visible = false
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                if not Depbox.Visible then
                    continue
                end

                local DepVisible, DepScore = CheckDepbox(Depbox, Search, SubTabMatches)
                VisibleElements[SubTab] += DepVisible
                SubScore = math.max(SubScore, DepScore)
                BestScore = math.max(BestScore, DepScore)
            end

            SubTabScores[SubTab] = SubScore
        end

        local BestSubTab = nil
        local BestSubScore = -1

        for SubTab, Visible in VisibleElements do
            SubTab.ButtonHolder.Visible = Visible > 0
            if Visible > 0 then
                VisibleTabs += 1
                HasVisible = true

                local SubScore = SubTabScores[SubTab] or 0
                if SubScore > BestSubScore then
                    BestSubScore = SubScore
                    BestSubTab = SubTab
                end
            end
        end

        local ActiveSubTab = Tabbox.ActiveTab
        local ActiveSubVisible = ActiveSubTab and (VisibleElements[ActiveSubTab] or 0) > 0
        local ActiveSubScore = ActiveSubTab and (SubTabScores[ActiveSubTab] or -1) or -1

        if ActiveSubVisible and ActiveSubScore >= BestSubScore then
            ActiveSubTab:Resize()
        elseif BestSubTab then
            BestSubTab:Show()
        end

        
        Tabbox.BoxHolder.Visible = VisibleTabs > 0
        SyncPopOutVisibility(Tabbox)
    end

    return HasVisible, BestScore
end

local function ResetTab(Tab)
    if not Tab then
        return
    end

    for _, Groupbox in Tab.Groupboxes do
        for _, ElementInfo in Groupbox.Elements do
            ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

            if ElementInfo.SubButton then
                ElementInfo.Base.Visible = ElementInfo.Visible
                ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
            end
        end

        for _, Depbox in Groupbox.DependencyBoxes do
            RestoreDepbox(Depbox)
        end

        Groupbox:Resize()
        Groupbox.BoxHolder.Visible = Groupbox.Visible ~= false
        SyncPopOutVisibility(Groupbox)
    end

    for _, Tabbox in Tab.Tabboxes do
        for _, SubTab in Tabbox.Tabs do
            for _, ElementInfo in SubTab.Elements do
                ElementInfo.Holder.Visible = ElementInfo.Visible ~= false

                if ElementInfo.SubButton then
                    ElementInfo.Base.Visible = ElementInfo.Visible
                    ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                end
            end

            for _, Depbox in SubTab.DependencyBoxes do
                RestoreDepbox(Depbox)
            end

            SubTab.ButtonHolder.Visible = true
        end

        if Tabbox.ActiveTab then
            Tabbox.ActiveTab:Resize()
        end
        Tabbox.BoxHolder.Visible = true
        SyncPopOutVisibility(Tabbox)
    end
end

function Library:UpdateSearch(SearchText)
    Library.SearchText = SearchText

    local TabsToSearch = {}
    for _, Tab in Library.Tabs do
        if typeof(Tab) == "table" and not Tab.IsKeyTab and not Tab.IsCustomTab and not Tab.HasSubTabs then
            table.insert(TabsToSearch, Tab)
        end
    end

    for _, Tab in TabsToSearch do
        ResetTab(Tab)
    end

    local Search = NormalizeSearch(LowerText(SearchText))
    if Trim(Search) == "" then
        Library.Searching = false
        Library.LastSearchTab = nil
        return
    end
    if not Library.GlobalSearch and Library.ActiveTab and Library.ActiveTab.IsKeyTab then
        Library.Searching = false
        Library.LastSearchTab = nil
        return
    end

    Library.Searching = true

    local BestTab = nil
    local BestScore = -1
    local ActiveScore = -1
    local ActiveHasVisible = false
    local CurrentTab = Library.ActiveTab and (Library.ActiveTab.ActiveSubTab or Library.ActiveTab)

    for _, Tab in TabsToSearch do
        local HasVisible, Score = ApplySearchToTab(Tab, Search)
        if not HasVisible then
            continue
        end

        if Tab == CurrentTab then
            ActiveHasVisible = true
            ActiveScore = Score
        end
        if Score > BestScore then
            BestScore = Score
            BestTab = Tab
        end
    end

    if not Library.GlobalSearch then
        for _, Tab in TabsToSearch do
            if Tab ~= BestTab then
                ResetTab(Tab)
            end
        end
    end

    local StayOnActive = ActiveHasVisible and ActiveScore >= BestScore
    if StayOnActive and Library.ActiveTab then
        Library.ActiveTab:RefreshSides()
    elseif BestTab then
        local SearchMarker = SearchText
        task.defer(function()
            if Library.SearchText ~= SearchMarker then
                return
            end

            local Current = Library.ActiveTab and (Library.ActiveTab.ActiveSubTab or Library.ActiveTab)
            if Current ~= BestTab then
                BestTab:Show()
            elseif Library.ActiveTab then
                Library.ActiveTab:RefreshSides()
            end
        end)
    end

    Library.LastSearchTab = nil
end

function Library:AddToRegistry(Instance, Properties)
    Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
    Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
    for Instance, Properties in Library.Registry do
        for Property, Index in Properties do
            local SchemeValue = GetSchemeValue(Index)

            if SchemeValue or typeof(Index) == "function" then
                Instance[Property] = SchemeValue or Index()
            end
        end
    end
end

function Library:SetDPIScale(DPIScale: number)
    Library.DPIScale = DPIScale / 100
    Library.MinSize = Library.OriginalMinSize * Library.DPIScale

    for _, UIScale in Library.Scales do
        UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
    end

    for _, Option in Options do
        if Option.Type == "Dropdown" then
            Option:RecalculateListSize()
            Option:RefreshPool()
        end
    end

    for _, Notification in Library.Notifications do
        Notification:Resize()
    end
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
    local ConnectionType = typeof(Connection)
    if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
        table.insert(Library.Signals, Connection)
    end

    return Connection
end

function IsValidCustomIcon(Icon: string)
    return typeof(Icon) == "string" and (Icon:match("^rbxasset://textures/") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
end

local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
    return typeof(Icon) == "string" and (Icon:match("^content://") or (Icon:match("^rbxasset://%x+/") or Icon:match("^rbxasset://[^/]+/")) or (IncludeAssetId == true and Icon:match("^rbxassetid://")))
end

type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
    FontFace: Font?,
    Text: string?,
    Custom: boolean?,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
}

-- [图案版·内置] lucide 图案数据直接内联在库内：
-- 图集使用 Roblox 官方 assetid（136111683851629 / 135883070486325），
-- 全程零网络请求、零写盘，图标是真实矢量图案而非 Unicode 符号。
-- [内联版] 图标改为库内自带 lucide 图案数据，零联网、零外部模块
local function IsIconModule(Module): boolean
    return typeof(Module) == "table" and typeof(Module.GetAsset) == "function"
end

local function BuildBuiltinIconModule(): IconModule
local Lucide = {}

--// Helpers \\--
local function Check(...)
	for index = 1, select("#", ...) do
		if typeof((select(index, ...))) ~= "function" then return false end
	end
	return true
end

local function SafeMerge(original: { any }, additional: { any })
	for key, value in additional do
		if original[key] then
			continue
		end

		original[key] = value
	end

	return original
end

local AssetManager = {}
do
	local BASE_PATH = "lucide-icons"

	AssetManager.Supported = false -- [内联改造] 强制走官方 assetid 图集，禁止下载/写盘/联网
	AssetManager.CanDelete = AssetManager.Supported and Check(listfiles, delfolder)

	function AssetManager.Path(relative: string?): string
		return if relative then `{BASE_PATH}/{relative}` else BASE_PATH
	end

	function AssetManager.EnsureFolder(relative: string?)
		local current = ""
		for _, part in string.split(AssetManager.Path(relative), "/") do
			current = if current == "" then part else `{current}/{part}`
			if not isfolder(current) then
				makefolder(current)
			end
		end
	end

	function AssetManager.IsFile(relative: string): boolean
		local success, result = pcall(isfile, AssetManager.Path(relative))
		return success and result == true
	end

	function AssetManager.IsFolder(relative: string): boolean
		local success, result = pcall(isfolder, AssetManager.Path(relative))
		return success and result == true
	end

	function AssetManager.Read(relative: string): string?
		return if AssetManager.IsFile(relative) then readfile(AssetManager.Path(relative)) else nil
	end

	function AssetManager.Write(relative: string, data: string)
		writefile(AssetManager.Path(relative), data)
	end

	function AssetManager.Download(relative: string, url: string, validate: ((string) -> boolean)?)
		if AssetManager.IsFile(relative) then return end

		local data = game:HttpGet(url)
		assert(not validate or validate(data), `Invalid download for {relative}`)
		AssetManager.Write(relative, data)
	end

	function AssetManager.ListNames(): { string }
		local names = {}
		for _, entry in listfiles(BASE_PATH) do
			local name = entry:gsub("\\", "/"):gsub("/$", ""):match("([^/]+)$")
			if name then
				table.insert(names, name)
			end
		end
		return names
	end

	function AssetManager.DeleteFolder(relative: string)
		if AssetManager.CanDelete and AssetManager.IsFolder(relative) then
			pcall(delfolder, AssetManager.Path(relative))
		end
	end

	function AssetManager.GetAsset(relative: string): string
		return getcustomasset(AssetManager.Path(relative))
	end
end

local CACHE_FOLDER_PATTERNS = {
	"^" .. string.rep("%x", 64) .. "$",

	-- Layouts from older builds
	"^font%-" .. string.rep("%x", 64) .. "$",
	"^sprites%-%d%d%d%d%-%d%d%-%d%dT%d+Z?$",
}

local function IsCacheFolder(name: string): boolean
	for _, pattern in CACHE_FOLDER_PATTERNS do
		if name:match(pattern) then return true end
	end
	return false
end

local function PruneCache(currentFolder: string)
	if not AssetManager.CanDelete then return end

	local markerFile = "cache.txt"
	local current = AssetManager.Path(currentFolder)
	local lines = string.split(AssetManager.Read(markerFile) or "", "\n")
	local previous = if lines[1] == current then lines[2] else lines[1]

	for _, name in AssetManager.ListNames() do
		local path = AssetManager.Path(name)
		if
			IsCacheFolder(name) and
			path ~= current and
			path ~= previous and
			not AssetManager.IsFile(path)
		then
			AssetManager.DeleteFolder(name)
		end
	end

	AssetManager.Write(markerFile, current .. "\n" .. (previous or ""))
end

--// Constants \\--
local ASSET_BASE_URL = "https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/d64d9e669ba2b9aad9491dbbf6a8443b3ffd173d/"
local ASSET_FOLDER = "0d0438b2b95b5b535f5727460999f674aeab313d8a5114052ed96deb2f8b7acd"

--// Sprites \\--
local USE_CUSTOM_SPRITES = false
if AssetManager.Supported then
	USE_CUSTOM_SPRITES = pcall(function()
		AssetManager.EnsureFolder(ASSET_FOLDER)
		for spritesheet = 1, 2 do
			AssetManager.Download(`{ASSET_FOLDER}/{spritesheet}.png`, `{ASSET_BASE_URL}spritesheets/{spritesheet}.png`, function(data)
				return data:sub(1, 8) == "\137PNG\r\n\26\n" -- PNG header
			end)
		end
		AssetManager.GetAsset(`{ASSET_FOLDER}/1.png`)
	end)
	if USE_CUSTOM_SPRITES then
		pcall(PruneCache, ASSET_FOLDER)
	end
end

local icons = {{"align-vertical-distribute-center","chevron-down","list-restart","table-cells-split","gavel","dna-off","refresh-ccw-dot","venus","bean","circle-question-mark","folder-code","bolt","heater","feather","align-horizontal-distribute-center","grip-vertical","pill-bottle","person-standing","badge-swiss-franc","between-horizontal-end","file-braces-corner","rotate-cw","house-plus","bus-front","shield-ellipsis","between-vertical-end","globe-lock","tags","concierge-bell","bookmark-minus","plant-pot","file-down","picture-in-picture","messages-square","scissors","file-check-corner","phone-call","anchor","hand-helping","text-wrap","birdhouse","wifi-off","cloud-alert","message-square","cloud-download","folder-plus","cctv-off","notebook-dot","mirror-round","user-round","pointer","between-horizontal-start","chevrons-up-down","brush","message-circle-more","parentheses","book-up-2","flame","chevrons-up","square-dashed","square-mouse-pointer","superscript","signal","wifi-cog","hexagon","navigation-2-off","eye-off","arrows-up-from-line","file-code-corner","square-centerline-dashed-horizontal","panels-right-bottom","scaling","hash","arrow-left-from-line","ship","ticket-percent","calendar-clock","x","non-binary","voicemail","presentation","tree-palm","badge","captions-off","align-vertical-justify-center","download","mouse-right","text-align-justify-start","lens-convex","shrimp-off","focus","diamond-percent","arrow-big-up","volume-x","mouse-pointer-click","face-slightly-smiling-plus","hard-drive","grid-2x2-x","package-minus","cloud","pipette","corner-left-down","badge-cent","cloud-lightning","user-round-pen","arrow-left-to-line","book-open-text","monitor-cloud","parking-meter","cat","heart-handshake","dam","trees","ham","circle-pause","chess-king","bean-off","clef-alto","separator-horizontal","ambulance","globe-code","citrus","phone-missed","calendar-off","chart-column","battery-medium","square-minus","star-check","decimals-arrow-left","folder-output","menu","bangladeshi-taka","image-down","terminal","building-complex-plus","circle-dot-dashed","medal","cake-slice","git-graph","armchair","tickets","qr-code","copy","goal","book-bookmark","trending-down","creative-commons","layers-arrow-down","ev-charger","user-star","road","nfc","align-center-horizontal","text-align-justify-end","car","notebook-tabs","ear","videotape","sun-moon","chart-scatter","podium","toolbox","calendar","calendar-cog","gallery-horizontal","clipboard-x","list-sort-ascending","book-open","circle-pile","rectangle-ellipsis","badge-plus","badge-info","file-headphone","bow-arrow","clipboard-pen-line","user-round-key","folder-search","utensils-crossed","arrow-up","arrow-up-from-dot","align-vertical-justify-start","layers-minus","pause","shrub","flag","biceps-flexed","align-horizontal-distribute-end","donut","calendar-plus-2","move-vertical","file-pen-line","badge-russian-ruble","radius","pilcrow","corner-left-up","georgian-lari","cable","book-user","square-arrow-down","circle-plus","view","cctv","circle-arrow-left","square-off","octagon-alert","panel-bottom-dashed","book-a","align-end-vertical","thumbs-up","globe","rabbit","layers-plus","door-stairwell","banknote-arrow-down","message-square-off","dice-4","message-circle-x","folder-x","message-circle-warning","map","move","zoom-out","zoom-in","arrow-up-left","award","zodiac-virgo","layout-panel-top","file-check","list-music","arrow-down-wide-narrow","unfold-horizontal","lens-concave","zodiac-pisces","stone","motorbike","music-4","wind-arrow-up","shield-x","file-volume","disc-3","file-signal","columns-4","archive-x","zodiac-libra","square-dashed-kanban","mouse-pointer-2","clock-arrow-up","clock-fading","pencil-sparkles","zodiac-leo","vegan","star-plus","zodiac-gemini","clef-bass","message-circle-plus","popsicle","credit-card-plus","square-chevron-left","fast-forward","user-pen","chess-knight","wifi-pen","files","send-to-back","alarm-clock","zodiac-aries","zodiac-aquarius","receipt","wifi","shopping-basket","send","x-line-top","solar-panel","shelving-unit","worm","workflow","wine-off","germ-off","brush-cleaning","skip-back","wine","book-audio","wind-arrow-down","file-scan","cupcake","midi-port","message-square-dashed","tic-tac-toe","euro","chevrons-left","wifi-sync","umbrella","skip-forward","clipboard-copy","map-pin-off","arrow-up-from-line","circle-chevron-up","magnet","wifi-high","circle-small","align-vertical-space-between","lamp-desk","circle-arrow-up","zap","beaker","sun-dim","whistle","wheat-off","paintbrush","wheat","broccoli","weight-tilde","weight","chevron-up","send-horizontal","flask-conical-off","pen-tool","database-check","webcam-off","form","pencil-ruler","dna","arrow-big-down-dash","chart-area","bug-off","webcam","waypoints","card-sim","waves-vertical","waves-ladder","map-pin-search","waves-horizontal","eye-dashed","save","ellipse","spell-check","waves-arrow-down","watch","popcorn","blocks","washing-machine","layer-arrow-up","microchip","heart","badge-minus","cloud-sun","circle","shield-alert","wand-sparkles","utensils","map-minus","wallpaper","wallet-minimal","separator-vertical","wallet-cards","wallet","scan-square","ampersands","vote","user-search","volume-off","fence","rows-3","square-user-round","volume-1","volume","sunrise","strikethrough","calendar-days","folder-bookmark","volleyball","banknote-arrow-up","layout-arrow-right","clock-arrow-right","dollar-sign","message-square-quote","virus","tag","video","list-minus","cloud-hail","package-plus","eye-closed","app-window-mac","vibrate","ellipsis","copy-check","venus-and-mars","satellite","bookmark-plus","pentagon","folder-key","coffee","circle-power","logs","hourglass","tickets-plane","folder-git","vector-polygon","bomb","layers-2","battery-full","vault","line-dot-bottom-vertical","chart-gantt","folder-tree","command","badge-dollar-sign","align-start-vertical","briefcase-conveyor-belt","message-circle-question-mark","badge-x","bluetooth-off","van","square-square","cannabis","equal-approximately-not","book","grip-horizontal","circle-minus","audio-waveform","moon-star","arrow-down-narrow-wide","maximize-2","database-backup","wand","receipt-turkish-lira","users-round","calendar-minus-2","copy-minus","users","folder-input","book-image","user-x","mouse-left","tag-plus","shirt","percent","server-off","move-up","user-round-x","user-round-search","plug-2","crosshair","chess-rook","brackets","calendar-heart","list-ordered","image-plus","star-x","mic-off","user-round-group","arrow-big-left","square-split-horizontal","user-round-cog","user-round-check","clover","sun-snow","sofa","user-round-arrow-left","computer","funnel-x","user-minus","clock-2","calendar-fold","fish-off","baby","database-x","fold-vertical","user-lock","hop","face-angry","user-key","cigarette","calendar-chevrons-right","user-group","user-cog","diamond-plus","server-cog","file-chart-column","triangle-dashed","git-pull-request-closed","badge-check","user","usb-c-port","layers-arrow-up","plug-zap","heading-4","chess-queen","graduation-cap","grid-3x2","zodiac-sagittarius","square-dashed-x-corner","square-dashed-bottom-code","clock-7","ethernet-port","scan-text","upload","shower-head","equal-not","unplug","move-down","clock-arrow-down","ticket-slash","ruler","locate","unlink","circle-user-round","university","ungroup","list-filter","map-pin-check","egg-off","unfold-vertical","cog","dog","ice-cream-bowl","swords","spotlight","panel-right-dashed","undo-2","paper-bag","truck-electric","undo","check-line","underline","bubbles","bot","chart-bar-increasing","umbrella-off","playing-card","air-vent","type-outline","dot","flask-round","mouth","armenian-dram","clipboard-paste","chevron-last","book-heart","paperclip","circle-parking","globe-check","cloud-check","panel-left","circle-chevron-right","case-lower","fan","squares-unite","arrow-down-up","git-fork","forward","brain-circuit","between-vertical-start","database","panel-right","fingerprint-pattern","turntable","turkish-lira","log-out","git-branch-plus","clipboard-minus","file-text","tube-lotion","truck","trophy","table-rows-split","milk-off","tv-minimal","cloud-upload","banknote","triangles-centerline-dashed-horizontal","message-circle-dashed-check","drumstick","folder-closed","calendar-search","triangle-alert","line-dot-top-vertical","bell-ring","circle-chevron-left","triangle","arrow-down","arrow-up-down","folder-dot","tree-deciduous","trending-up","whole-word","monitor","disc-2","trending-up-down","square-asterisk","user-shield","transgender","tv-minimal-play","circle-stop","align-vertical-space-around","chess-bishop","train-front-tunnel","train-front","arrow-big-down","circle-parking-off","calendar-x-2","user-plus","move-diagonal-2","bandage","gallery-horizontal-end","panel-top-dashed","traffic-cone","tractor","tram-front","tower-control","plug","touchpad-off","audio-lines","touchpad","torus","tornado","toothbrush-sparkles","rocket","toothbrush","ear-off","tool-case","save-check","toilet","squares-exclude","printer","megaphone-off","toggle-left","arrow-big-right","section","file-clock","timer-reset","toy-brick","square-chevron-down","dice-1","drill","app-window","robot-vacuum","hand-metal","timer","spell-check-2","timeline","ticket-x","list-plus","sport-shoe","rotate-ccw-key","ticket-minus","chart-pie","replace","message-circle-off","copy-slash","wind","move-down-left","layout-panel-left","thermometer-sun","circle-percent","thermometer-snowflake","circle-arrow-out-down-right","square-x","italic","chart-column-increasing","thermometer","step-forward","theater","a-arrow-down","broom-sparkles","sticker","lock-keyhole-open","text-quote","newspaper","text-cursor-input","text-cursor","heart-pulse","import","badge-turkish-lira","square-terminal","file-music","text-align-justify-center","beef","faucet","file-user","text-align-justify","square-radical","text-align-end","image-upscale","book-type","text-align-center","signpost-big","test-tubes","cloudy","test-tube-diagonal","rugby-ball","brick-wall-fire","navigation-off","arrow-left","car-taxi-front","square-scissors","mouth-off","chevrons-right-left","tent","telescope","house-wifi","tangent","saudi-riyal","leaf","square-dimensions","face-slightly-smiling","align-end-horizontal","layer-arrow-down","equal","megaphone","calendar-x","tally-3","table-of-contents","egg","tally-1","rotate-cw-clock","ship-cargo","circle-pound-sterling","video-off","japanese-yen","tablets","tablet-smartphone","refresh-cw-off","library","file-terminal","circle-chevron-down","accessibility","table-properties","square-library","amphora","hourglass-cog","tally-2","table-columns-split","table-cells-merge","building-complex","table-2","sheet","circle-check-big","table","syringe","map-pinned","corner-down-left","circuit-board","power-off","switch-camera","swiss-franc","shield-lock","folder-open-dot","book-dashed","sunset","sun-medium","bluetooth","tree-pine","receipt-indian-rupee","rotate-ccw-clock","mic-audio-lines","subscript","stretch-vertical","stretch-horizontal","can-soda","flask-conical","hotel","funnel","square-star","folder-sync","monitor-pc","zodiac-ophiuchus","headset","sticky-note-x","arrow-up-narrow-wide","fishing-hook","chart-no-axes-column-increasing","equal-approximately","gap-horizontal","frame","calendar-arrow-down","clock-12","star-minus","sticky-note-check","sticky-note","images","lollipop","book-text","stethoscope","lamp-floor","file-plus-corner","image","step-back","badge-euro","bike","angle","star-off","refrigerator","star","stamp","squirrel","file-video-camera","option","banknote-check","scroll-text","server-plus","squircle","search-alert","repeat","toggle-right","square-user","ferris-wheel","camera-off","square-text","case-sensitive","square-stack","square-split-vertical","soap-dispenser-droplet","group","square-slash","battery","rewind","tent-tree","square-round-corner","rectangle-horizontal","iv-bag","square-plus","square-play","bitcoin","square-pilcrow","battery-plus","database-search","square-pi","file-diff","square-percent","message-square-lock","square-pause","spline-pointer","ligature","axis-3d","square-parking","piano","binoculars","square-m","square-kanban","square-function","rose","land-plot","mail-minus","square-equal","square-dot","square-divide","nut-off","clipboard-pen","bottle-wine","alarm-clock-off","shield-question-mark","list","monitor-pause","square-arrow-right","dome","badge-pound-sterling","bookmark-check","sliders-horizontal","wrench-off","square-dashed-bottom","a-arrow-up","clock-check","square-code","square-chevron-up","vibrate-off","face-grinning","zodiac-cancer","ratio","file-code","sliders-vertical","carton-off","credit-card-reader","square-chart-gantt","cassette-tape","battery-low","square-centerline-dashed-vertical","square-bottom-dashed-scissors","signpost","square-bookmark","calendar-arrow-up","landmark","fish-symbol","trash-off","loader","bold","dice-2","file-type","clipboard-clock","beer","lectern","square-arrow-up-right","router","phone-incoming","binary","move-diagonal","square-arrow-right-exit","door-closed","square-arrow-right-enter","layout-template","square-arrow-out-up-right","square-arrow-out-up-left","monitor-off","bookmark-off","hand-heart","square-arrow-out-down-left","scan-qr-code","message-square-check","search-x","square-arrow-down-right","gamepad-directional","brain","monitor-up","square","sprout","key","clock-11","spray-can","ticket-plus","arrow-up-0-1","bell-electric","shield-keyhole","heading","book-open-check","panel-top-close","lasso-select","screen-share-off","caravan","speech","speaker","bus","sparkles","audio-lines-x","chart-no-axes-gantt","file-spreadsheet","sparkle","clipboard-list","spade","contact-round","file-play","keyboard-off","soup","file-badge","battery-warning","mail-question-mark","arrow-down-from-line","briefcase","biohazard","rectangle-circle","braces","scale-3d","panel-top-bottom-dashed","mail-x","square-dashed-mouse-pointer","square-sparkles","lock-open","snowflake","pizza","list-indent-decrease","arrow-up-wide-narrow","snail","clock-5","smartphone-nfc","rotate-ccw","align-horizontal-justify-center","chevrons-down","antenna","memory-stick","scan-eye","smartphone","square-check","heart-plus","door-closed-cog","map-pin-minus-inside","git-merge","gallery-vertical-end","square-dashed-plus","hand-coins","zodiac-capricorn","wifi-low","skull","clock","file-pen","git-compare-arrows","cloud-sun-rain","align-horizontal-justify-start","siren","signature","signal-zero","calendar-plus","signal-medium","arrow-down-z-a","bath","signal-low","unlink-2","sigma","shopping-cart-minus","folder-check","shuffle","book-key","ribbon","microwave","shrink","gallery-vertical","shrimp","hard-drive-download","square-dashed-text","map-pin-pen","move-up-left","shopping-cart-plus","folder-heart","orbit","shopping-bag","ship-wheel","arrow-up-a-z","shield-user","square-dashed-top-solid","shield-plus","shield-off","git-pull-request-create","swatch-book","receipt-cent","spool","folder-archive","folder-symlink","can","ban","message-square-x","paint-roller","shield-half","archive","shield-cog-corner","shield-cog","shield-check","circle-slash-2","shield-ban","cake","cloud-rain","chart-bar","shield","wrench","shell","gamepad","share","flag-triangle-right","shapes","settings-2","bell","settings","server-crash","music-3","chart-bar-big","user-check","proportions","server","plane","webhook-off","carrot","square-arrow-left","file-cog","circle-dashed","search-slash","search-code","dices","germ","squares-subtract","search","scroll","split","list-sort-descending","screen-share","forklift","lightbulb","alarm-clock-minus","heart-x","eraser","square-sigma","school","bluetooth-connected","rotate-ccw-square","chart-no-axes-column","cannabis-off","folder-kanban","scan-search","mars-stroke","phone-off","messages-circle","scan-face","file-box","scan-box","paint-bucket","glass-water","scan-barcode","glasses","piggy-bank","scan","cuboid","cloud-off","check-check","activity","axe","plane-takeoff","pin-off","cloud-rain-wind","save-plus","gem","copy-x","file-axis-3d","radical","chart-column-decreasing","save-off","bug-play","align-vertical-distribute-start","file-braces","waves-arrow-up","tally-5","satellite-dish","sandwich","salad","circle-divide","sailboat","rows-2","ruler-dimension-line","life-buoy","external-link","rows-4","volume-2","battery-charging","russian-ruble","square-arrow-up-left","brick-wall-shield","footprints","route-off","building","route","fire-extinguisher","rotate-cw-fading-clock","tag-x","book-alert","link-2","astroid","bell-minus","image-up","closed-caption","drum","arrow-up-z-a","sun","rotate-3d","roller-coaster","file-key","database-arrow-down","robot-arm","scissors-line-dashed","layers","reply","replace-all","ticket-check","combine","repeat-off","repeat-2","mountain","mars","picture-in-picture-2","radio-off","flower-2","repeat-1","squares-intersect","remove-formatting","regex","keyboard-music","star-half","playing-cards-fan","code-xml","pencil-line","mails","brain-cog","tablet","refresh-cw","pi","trash","book-down","hdmi-port","trailer","case-upper","circle-fading-arrow-up","pilcrow-left","croissant","redo","circle-arrow-right","barcode","rectangle-vertical","rectangle-goggles","bed","git-merge-conflict","divide","grape","receipt-swiss-franc","party-popper","file-chart-pie","receipt-russian-ruble","list-indent-increase","dice-6","receipt-japanese-yen","blender","receipt-euro","zap-off","square-check-big","rat","rainbow","octagon-pause","laptop-minimal","radio-receiver","radio","map-pin-minus","radiation","chart-spline","message-square-more","radar","chart-candlestick","quote","arrow-down-a-z","pyramid","puzzle","move-horizontal","file-sliders","projector","square-exclamation-point","cup-soda","printer-check","map-pin-plus","sword","power","pound-sterling","earth","slice","dice-3","milk","mouse-pointer-ban","crown","circle-slash","circle-star","rotate-cw-square","atom","package-x","bed-double","layout-dashboard","circle-dot","file-exclamation-point","hand-fist","message-circle-code","folder-git-2","message-square-code","plus","towel-rack","playing-cards","arrow-big-left-dash","play-off","dumbbell","play","plane-landing","houses","scale","pin","flashlight","panel-top-open","pill","mailbox","notebook","redo-2","pickaxe","square-menu","chevrons-left-right","monitor-smartphone","laptop","scan-line","clock-4","square-arrow-up","book-minus","file-question-mark","phone-forwarded","phone","save-pen","arrow-down-to-line","phi","refresh-ccw","venetian-mask","calendar-check-2","pencil-off","spline","banknote-x","git-pull-request-create-arrow","pen-off","circle-check","pen-line","hand","pc-case","paw-print","bed-single","parasol","timer-off","arrow-big-right-dash","calendar-minus","panels-left-bottom","panel-top","backpack","panel-right-open","panel-right-close","panel-left-right-dashed","panel-left-open","mic-signal","arrow-down-right","panel-left-dashed","letters","wifi-zero","eject","panel-bottom-close","panel-bottom","layout-grid-circles","image-off","panda","move-right","paintbrush-vertical","package-search","square-chevron-right","mail-search","package-open","bone-fracture","crop","package-2","package","origami","lambda","ampersand","ad","shopping-cart","align-vertical-justify-end","omega","alarm-smoke","dock","file-input","clock-8","hand-grab","cloud-cog","blend","hd","radio-tower","list-tree","droplet","octagon-minus","eye","cloud-sync","square-dashed-x","banana","gpu","nut","notepad-text-dashed","circle-equal","face-slightly-frowning","notepad-text","library-big","file-chart-column-increasing","text-initial","arrow-up-right","network","leafy-green","message-square-dot","file-chart-line","columns-3-cog","nepali-rupee","navigation-2","minimize-2","navigation","music-2","cone","engine","file-image","move-up-right","palette","barrel","gallery-thumbnails","move-left","cpu","move-down-right","thumbs-down","merge","hamburger","move-3d","hat-glasses","code","mail","mouse-pointer","mouse-off","list-clock","carton","circle-arrow-out-down-left","kanban","bone","apple","rocking-chair","bot-off","flower","mop","moon","circle-arrow-out-up-left","message-square-plus","cable-car","arrow-down-left","square-activity","monitor-stop","cigarette-off","monitor-speaker","message-circle","circle-arrow-out-up-right","car-battery","monitor-play","fold-horizontal","shovel","calendar-1","cloud-moon","square-arrow-out-down-right","lock-keyhole","clock-plus","circle-euro","cloud-snow","anvil","arrow-big-up-dash","monitor-dot","monitor-cog","monitor-check","link-2-off","minus","list-chevrons-up-down","chevrons-down-up","clipboard-plus","circle-x","list-end","milestone","microscope","chevrons-right","audio-lines-off","message-square-reply","corner-down-right","mic-vocal","summary","lamp-wall-down","mic","layout-arrow-down","ellipsis-vertical","globe-off","square-stop","arrow-up-1-0","align-horizontal-justify-end","scan-heart","align-vertical-distribute-end","heart-crack","airplay","message-square-warning","message-square-text","message-square-share","monitor-x","bell-check","database-minus","square-pen","message-square-heart","message-square-diff","dice-5","octagon","ticket","message-circle-heart","message-circle-dashed","briefcase-plus","bookmark","message-circle-check","utility-pole","maximize","chart-bar-decreasing","database-plus","calendar-sync","funnel-plus","store","circle-arrow-down","notebook-pen","egg-fried","map-pin-x-inside","map-pin-x","corner-right-up","hand-platter","printer-3d","user-round-plus","panel-left-close","map-pin","pilcrow-right","user-round-minus","bell-off","mail-pen","mail-plus","mail-clock","mail-check","mail-badge","mouse-pointer-2-off","drone","slash","credit-card-x","aperture","arrow-right-left","circle-alert","vector-square","circle-gauge","log-in","check","text-search","arrow-down-to-dot","monitor-down","lock","chef-hat","calculator","locate-fixed","file-archive","signal-high","inbox","loader-pinwheel","loader-circle","image-play","align-horizontal-space-between","corner-right-down","calendar-check","database-zap","droplets","list-video","broom","bird","layout-list","file-search","lamp-ceiling","alarm-clock-plus","circle-dollar-sign","usb","house","receipt-pound-sterling","house-plug","list-collapse","id-card","mouse","minimize","list-chevrons-down-up","list-checks","galaxy","list-check","book-x","mirror-rectangular","link","line-style","line-squiggle","headphone-off","asterisk","line-dot-right-horizontal","octagon-x","languages","lighthouse","alarm-clock-check","guitar","calendar-range","beer-off","scooter","square-parking-off","notebook-text","arrow-right-to-line","clef-treble","tally-4","zodiac-taurus","layout-grid","door-open","flag-triangle-left","grid-3x3","file","layout-freeform","pocket-knife","book-copy","castle","car-front","clock-alert","reply-all","cloud-moon-rain","clipboard-type","lasso","list-todo","printer-x","lamp-wall-up","list-start","lamp","a-large-small","keyboard","key-square","map-plus","kazakh-tenge","kayak","joystick","database-arrow-up","arrow-right-from-line","flame-kindling","square-power","iteration-cw","bring-to-front","iteration-ccw","inspection-panel","bell-plus","info","infinity","indian-rupee","folders","mail-warning","image-minus","id-card-lanyard","ice-cream-cone","bridge","chart-line","file-lock","cast","circle-fading-plus","clock-10","undo-dot","target","list-filter-plus","house-heart","drama","compass","baseline","martini","contrast","hospital","candy-off","heart-minus","book-check","highlighter","book-lock","helicopter","briefcase-medical","calendars","text-align-start","heart-off","hop-off","warehouse","sticky-notes","drafting-compass","save-all","heading-6","heading-5","heading-3","heading-2","heading-1","fishing-rod","book-headphones","credit-card","haze","hard-hat","hard-drive-upload","shredder","panel-bottom-open","door-closed-package","handbag","credit-card-check","balloon","map-pin-plus-inside","bookmark-x","badge-question-mark","pen","hammer","candy-cane","grip","file-symlink","gamepad-2","grid-2x2-check","grid-2x2","globe-x","git-pull-request-draft","shield-minus","circle-off","dessert","eclipse","church","columns-3","cylinder","badge-japanese-yen","file-x","receipt-text","git-compare","git-commit-vertical","git-commit-horizontal","circle-ellipsis","file-output","disc-album","git-branch","arrow-down-0-1","captions","gift","ghost","philippine-peso","badge-alert","gauge","folder-pen","cross","gap-vertical","chevron-right","sticky-note-minus","square-arrow-down-left","share-2","fullscreen","fuel","folder-up","folder-search-2","folder-root","folder-open","chess-pawn","folder-minus","briefcase-business","folder-lock","message-circle-reply","folder-cog","triangle-right","folder-clock","folder","mop-sparkles","type","webhook","flashlight-off","align-horizontal-distribute-start","flag-off","fish","pointer-off","turtle","camera","film","file-x-corner","git-pull-request","bluetooth-searching","arrow-up-to-line","squircle-dashed","clock-3","badge-percent","face-expressionless","file-up","file-type-corner","grid-2x2-plus","file-stack","box","file-search-corner","clock-1","file-heart","house-cog","space","file-minus-corner","file-minus","file-digit","corner-up-left","clock-6","zodiac-scorpio","key-round","headphones","tv","factory","face-neutral","rss","expand","at-sign","map-pin-check-inside","sticky-note-off","music","handshake","earth-lock","circle-user","copy-plus","droplet-off","virus-off","line-dot-left-horizontal","disc","diff","search-check","clipboard-check","columns-2","diamond-minus","clipboard","align-center-vertical","diameter","delete","club","cloud-fog","mosque","currency","map-pin-house","package-check","chevron-first","pencil","boxes","list-x","copyright","copyleft","corner-up-right","cookie","clock-arrow-left","container","contact","badge-indian-rupee","construction","redo-dot","component","align-start-horizontal","chart-column-stacked","file-plus","git-pull-request-arrow","coins","decimals-arrow-right","bell-dot","folder-down","cloud-drizzle","cloud-backup","align-horizontal-space-around","door-closed-locked","clock-9","diamond","blinds","clapperboard","circle-play","book-search","git-branch-minus","circle-dashed-check","recycle","mountain-snow","luggage","chevrons-left-right-ellipsis","bot-message-square","phone-outgoing","smartphone-charging","chevron-left","train-track","cherry","chart-bar-stacked","sticky-note-plus","chart-no-axes-column-decreasing","chart-network","chart-column-big","chart-no-axes-combined","metronome","triangles-centerline-dashed-vertical","arrow-down-1-0","credit-card-minus","candy","arrow-left-right","lightbulb-off","panels-top-left","beef-off","locate-off","bug","test-tube","brick-wall","cooking-pot","boom-box","book-up","book-plus","laptop-minimal-check","mail-open","park","baggage-claim","variable","arrow-right","archive-restore"},{if USE_CUSTOM_SPRITES then AssetManager.GetAsset(ASSET_FOLDER .. "/1.png") else "rbxassetid://136111683851629",if USE_CUSTOM_SPRITES then AssetManager.GetAsset(ASSET_FOLDER .. "/2.png") else "rbxassetid://135883070486325"},{[48]={{1,{24,24},{175,0}},{1,{24,24},{625,25}},{1,{24,24},{750,350}},{2,{24,24},{25,125}},{1,{24,24},{200,750}},{1,{24,24},{575,250}},{1,{24,24},{475,900}},{2,{24,24},{25,425}},{1,{24,24},{25,375}},{1,{24,24},{650,50}},{1,{24,24},{450,475}},{1,{24,24},{25,425}},{1,{24,24},{25,975}},{1,{24,24},{775,100}},{1,{24,24},{50,75}},{1,{24,24},{125,850}},{1,{24,24},{950,375}},{1,{24,24},{750,550}},{1,{24,24},{300,75}},{1,{24,24},{75,350}},{1,{24,24},{600,275}},{1,{24,24},{850,575}},{1,{24,24},{675,350}},{1,{24,24},{400,150}},{1,{24,24},{525,975}},{1,{24,24},{25,400}},{1,{24,24},{500,475}},{2,{24,24},{150,50}},{1,{24,24},{0,750}},{1,{24,24},{275,225}},{1,{24,24},{725,600}},{1,{24,24},{250,625}},{1,{24,24},{400,900}},{1,{24,24},{850,325}},{1,{24,24},{925,550}},{1,{24,24},{450,425}},{1,{24,24},{675,625}},{1,{24,24},{100,100}},{1,{24,24},{850,150}},{2,{24,24},{0,250}},{1,{24,24},{300,150}},{2,{24,24},{375,150}},{1,{24,24},{150,575}},{1,{24,24},{900,275}},{1,{24,24},{50,675}},{1,{24,24},{50,875}},{1,{24,24},{200,400}},{1,{24,24},{425,800}},{1,{24,24},{400,775}},{2,{24,24},{25,400}},{1,{24,24},{400,925}},{1,{24,24},{50,375}},{1,{24,24},{300,350}},{1,{24,24},{25,500}},{1,{24,24},{675,475}},{1,{24,24},{500,775}},{1,{24,24},{425,75}},{1,{24,24},{850,75}},{1,{24,24},{275,375}},{1,{24,24},{950,750}},{1,{24,24},{925,800}},{2,{24,24},{75,50}},{1,{24,24},{625,925}},{2,{24,24},{450,75}},{1,{24,24},{950,75}},{1,{24,24},{650,575}},{1,{24,24},{200,650}},{1,{24,24},{225,100}},{1,{24,24},{375,500}},{1,{24,24},{800,850}},{1,{24,24},{625,650}},{1,{24,24},{750,700}},{1,{24,24},{600,400}},{1,{24,24},{75,200}},{1,{24,24},{675,850}},{2,{24,24},{50,225}},{1,{24,24},{75,475}},{2,{24,24},{450,100}},{1,{24,24},{450,775}},{2,{24,24},{300,175}},{1,{24,24},{900,450}},{2,{24,24},{200,150}},{1,{24,24},{225,150}},{1,{24,24},{25,550}},{1,{24,24},{100,75}},{1,{24,24},{225,600}},{1,{24,24},{425,775}},{2,{24,24},{200,50}},{1,{24,24},{675,400}},{1,{24,24},{875,675}},{1,{24,24},{650,275}},{1,{24,24},{125,675}},{1,{24,24},{125,125}},{2,{24,24},{175,300}},{1,{24,24},{475,725}},{1,{24,24},{25,825}},{1,{24,24},{650,350}},{1,{24,24},{250,725}},{1,{24,24},{675,575}},{1,{24,24},{450,300}},{1,{24,24},{850,475}},{1,{24,24},{325,450}},{1,{24,24},{225,125}},{1,{24,24},{725,25}},{2,{24,24},{125,300}},{1,{24,24},{25,250}},{1,{24,24},{50,425}},{1,{24,24},{350,825}},{1,{24,24},{450,825}},{1,{24,24},{225,375}},{1,{24,24},{200,800}},{1,{24,24},{550,250}},{2,{24,24},{150,200}},{1,{24,24},{25,950}},{1,{24,24},{100,575}},{1,{24,24},{75,550}},{1,{24,24},{50,350}},{1,{24,24},{325,375}},{1,{24,24},{525,950}},{1,{24,24},{200,0}},{1,{24,24},{525,450}},{1,{24,24},{375,325}},{1,{24,24},{600,700}},{1,{24,24},{500,75}},{1,{24,24},{525,100}},{1,{24,24},{175,225}},{1,{24,24},{950,775}},{1,{24,24},{975,875}},{1,{24,24},{275,525}},{1,{24,24},{100,825}},{1,{24,24},{850,300}},{1,{24,24},{75,300}},{1,{24,24},{475,550}},{2,{24,24},{125,100}},{1,{24,24},{475,75}},{1,{24,24},{400,275}},{1,{24,24},{950,200}},{1,{24,24},{300,250}},{1,{24,24},{825,150}},{1,{24,24},{75,150}},{2,{24,24},{225,75}},{1,{24,24},{675,675}},{1,{24,24},{450,325}},{1,{24,24},{400,575}},{1,{24,24},{350,125}},{2,{24,24},{125,225}},{1,{24,24},{150,625}},{1,{24,24},{225,825}},{1,{24,24},{325,525}},{2,{24,24},{425,25}},{1,{24,24},{650,750}},{1,{24,24},{475,750}},{1,{24,24},{0,100}},{2,{24,24},{225,25}},{1,{24,24},{525,75}},{1,{24,24},{375,850}},{1,{24,24},{800,50}},{2,{24,24},{400,75}},{2,{24,24},{50,50}},{1,{24,24},{275,350}},{1,{24,24},{450,875}},{2,{24,24},{0,300}},{1,{24,24},{300,275}},{1,{24,24},{50,500}},{1,{24,24},{450,500}},{1,{24,24},{0,700}},{1,{24,24},{725,375}},{1,{24,24},{25,450}},{1,{24,24},{50,625}},{1,{24,24},{675,700}},{1,{24,24},{0,350}},{1,{24,24},{100,250}},{1,{24,24},{200,675}},{1,{24,24},{25,475}},{1,{24,24},{100,600}},{2,{24,24},{175,250}},{1,{24,24},{950,0}},{2,{24,24},{300,150}},{1,{24,24},{250,75}},{1,{24,24},{100,200}},{1,{24,24},{50,125}},{1,{24,24},{175,875}},{1,{24,24},{400,875}},{1,{24,24},{800,750}},{1,{24,24},{900,25}},{1,{24,24},{450,0}},{1,{24,24},{25,100}},{1,{24,24},{425,400}},{1,{24,24},{475,100}},{1,{24,24},{800,425}},{1,{24,24},{875,25}},{1,{24,24},{325,50}},{1,{24,24},{425,925}},{1,{24,24},{975,350}},{1,{24,24},{300,475}},{1,{24,24},{150,800}},{1,{24,24},{325,225}},{1,{24,24},{375,125}},{1,{24,24},{825,800}},{1,{24,24},{0,675}},{2,{24,24},{375,100}},{1,{24,24},{175,425}},{1,{24,24},{125,525}},{1,{24,24},{900,825}},{1,{24,24},{950,300}},{1,{24,24},{350,900}},{1,{24,24},{425,50}},{1,{24,24},{75,50}},{2,{24,24},{150,125}},{1,{24,24},{425,550}},{1,{24,24},{625,725}},{1,{24,24},{150,900}},{1,{24,24},{275,550}},{1,{24,24},{50,325}},{1,{24,24},{275,875}},{1,{24,24},{825,0}},{1,{24,24},{525,625}},{1,{24,24},{825,125}},{1,{24,24},{550,600}},{1,{24,24},{250,875}},{1,{24,24},{775,450}},{2,{24,24},{450,125}},{2,{24,24},{475,100}},{1,{24,24},{50,250}},{1,{24,24},{0,325}},{2,{24,24},{75,475}},{1,{24,24},{825,250}},{1,{24,24},{425,450}},{1,{24,24},{825,275}},{1,{24,24},{150,125}},{2,{24,24},{275,125}},{1,{24,24},{700,375}},{2,{24,24},{175,375}},{2,{24,24},{50,0}},{1,{24,24},{675,525}},{1,{24,24},{700,525}},{2,{24,24},{225,300}},{1,{24,24},{775,750}},{1,{24,24},{350,550}},{1,{24,24},{675,150}},{1,{24,24},{650,250}},{1,{24,24},{150,600}},{1,{24,24},{125,100}},{2,{24,24},{225,325}},{1,{24,24},{825,850}},{1,{24,24},{525,675}},{1,{24,24},{300,425}},{1,{24,24},{250,475}},{1,{24,24},{850,450}},{2,{24,24},{250,300}},{2,{24,24},{100,350}},{1,{24,24},{875,975}},{2,{24,24},{275,275}},{1,{24,24},{300,400}},{1,{24,24},{625,525}},{1,{24,24},{350,975}},{1,{24,24},{75,700}},{1,{24,24},{975,700}},{1,{24,24},{825,50}},{2,{24,24},{325,100}},{1,{24,24},{50,575}},{2,{24,24},{350,175}},{1,{24,24},{250,650}},{1,{24,24},{575,900}},{1,{24,24},{50,50}},{2,{24,24},{350,200}},{2,{24,24},{375,175}},{1,{24,24},{725,650}},{2,{24,24},{275,250}},{1,{24,24},{600,925}},{1,{24,24},{550,925}},{2,{24,24},{475,75}},{1,{24,24},{975,625}},{1,{24,24},{675,825}},{2,{24,24},{100,425}},{2,{24,24},{125,400}},{2,{24,24},{175,350}},{1,{24,24},{125,825}},{1,{24,24},{50,475}},{1,{24,24},{925,650}},{2,{24,24},{150,375}},{1,{24,24},{375,100}},{2,{24,24},{250,275}},{1,{24,24},{725,175}},{1,{24,24},{625,175}},{1,{24,24},{600,575}},{1,{24,24},{425,725}},{2,{24,24},{125,150}},{1,{24,24},{350,500}},{1,{24,24},{375,275}},{2,{24,24},{325,200}},{2,{24,24},{400,0}},{1,{24,24},{900,675}},{1,{24,24},{200,500}},{1,{24,24},{500,625}},{1,{24,24},{75,225}},{1,{24,24},{525,150}},{1,{24,24},{150,950}},{2,{24,24},{425,100}},{1,{24,24},{575,125}},{1,{24,24},{0,175}},{1,{24,24},{625,425}},{1,{24,24},{675,0}},{2,{24,24},{400,150}},{1,{24,24},{75,325}},{2,{24,24},{100,0}},{2,{24,24},{25,475}},{2,{24,24},{75,425}},{1,{24,24},{450,800}},{2,{24,24},{50,450}},{1,{24,24},{125,400}},{2,{24,24},{125,375}},{2,{24,24},{100,400}},{1,{24,24},{500,150}},{1,{24,24},{600,875}},{1,{24,24},{775,150}},{1,{24,24},{975,325}},{1,{24,24},{450,350}},{2,{24,24},{225,275}},{1,{24,24},{700,250}},{1,{24,24},{875,425}},{1,{24,24},{550,275}},{1,{24,24},{25,200}},{1,{24,24},{150,450}},{1,{24,24},{550,0}},{2,{24,24},{200,300}},{2,{24,24},{250,250}},{1,{24,24},{475,125}},{2,{24,24},{275,225}},{2,{24,24},{300,200}},{1,{24,24},{400,725}},{2,{24,24},{325,175}},{1,{24,24},{225,625}},{1,{24,24},{825,625}},{1,{24,24},{600,250}},{1,{24,24},{750,850}},{2,{24,24},{375,125}},{2,{24,24},{400,100}},{1,{24,24},{375,950}},{1,{24,24},{175,275}},{2,{24,24},{425,75}},{1,{24,24},{275,775}},{1,{24,24},{675,500}},{1,{24,24},{50,950}},{1,{24,24},{50,300}},{1,{24,24},{525,225}},{1,{24,24},{425,275}},{1,{24,24},{650,850}},{2,{24,24},{0,475}},{2,{24,24},{275,175}},{1,{24,24},{650,475}},{2,{24,24},{25,450}},{2,{24,24},{75,400}},{1,{24,24},{500,975}},{2,{24,24},{100,375}},{2,{24,24},{50,425}},{1,{24,24},{525,925}},{1,{24,24},{150,50}},{2,{24,24},{125,350}},{2,{24,24},{0,425}},{2,{24,24},{200,275}},{1,{24,24},{750,125}},{1,{24,24},{725,700}},{1,{24,24},{950,850}},{2,{24,24},{250,225}},{2,{24,24},{150,325}},{2,{24,24},{125,0}},{2,{24,24},{50,25}},{1,{24,24},{25,525}},{1,{24,24},{550,375}},{2,{24,24},{275,200}},{1,{24,24},{25,350}},{1,{24,24},{75,975}},{1,{24,24},{325,400}},{1,{24,24},{475,350}},{1,{24,24},{225,925}},{2,{24,24},{325,150}},{2,{24,24},{175,25}},{2,{24,24},{425,50}},{1,{24,24},{850,250}},{1,{24,24},{750,0}},{1,{24,24},{625,625}},{1,{24,24},{250,600}},{1,{24,24},{225,0}},{2,{24,24},{475,0}},{1,{24,24},{550,300}},{1,{24,24},{575,200}},{2,{24,24},{50,400}},{1,{24,24},{450,975}},{1,{24,24},{225,275}},{1,{24,24},{800,500}},{1,{24,24},{225,700}},{1,{24,24},{300,450}},{1,{24,24},{675,25}},{1,{24,24},{225,875}},{1,{24,24},{775,250}},{2,{24,24},{250,50}},{1,{24,24},{325,600}},{2,{24,24},{150,300}},{1,{24,24},{0,450}},{1,{24,24},{250,800}},{1,{24,24},{225,175}},{2,{24,24},{175,275}},{1,{24,24},{450,625}},{1,{24,24},{500,125}},{1,{24,24},{875,75}},{1,{24,24},{100,650}},{1,{24,24},{175,175}},{1,{24,24},{0,150}},{1,{24,24},{250,275}},{1,{24,24},{600,550}},{1,{24,24},{250,125}},{1,{24,24},{125,325}},{2,{24,24},{225,225}},{1,{24,24},{900,875}},{1,{24,24},{50,525}},{1,{24,24},{500,350}},{1,{24,24},{325,175}},{1,{24,24},{150,825}},{1,{24,24},{200,475}},{1,{24,24},{25,300}},{1,{24,24},{800,400}},{1,{24,24},{275,0}},{1,{24,24},{150,975}},{1,{24,24},{475,325}},{2,{24,24},{475,25}},{1,{24,24},{750,625}},{2,{24,24},{350,100}},{1,{24,24},{550,25}},{1,{24,24},{550,225}},{2,{24,24},{325,125}},{1,{24,24},{275,650}},{1,{24,24},{175,300}},{2,{24,24},{400,50}},{1,{24,24},{600,600}},{2,{24,24},{0,175}},{1,{24,24},{650,875}},{1,{24,24},{775,525}},{1,{24,24},{925,575}},{1,{24,24},{825,400}},{2,{24,24},{50,375}},{2,{24,24},{75,350}},{1,{24,24},{575,750}},{1,{24,24},{725,75}},{1,{24,24},{650,0}},{1,{24,24},{475,50}},{1,{24,24},{575,0}},{1,{24,24},{800,300}},{1,{24,24},{375,650}},{1,{24,24},{975,900}},{1,{24,24},{775,400}},{2,{24,24},{200,225}},{1,{24,24},{225,25}},{1,{24,24},{950,825}},{2,{24,24},{225,200}},{2,{24,24},{250,175}},{1,{24,24},{400,350}},{2,{24,24},{25,75}},{1,{24,24},{600,975}},{2,{24,24},{275,150}},{1,{24,24},{25,725}},{1,{24,24},{550,400}},{2,{24,24},{350,75}},{1,{24,24},{600,125}},{1,{24,24},{0,550}},{1,{24,24},{150,750}},{1,{24,24},{300,50}},{1,{24,24},{350,450}},{1,{24,24},{600,325}},{2,{24,24},{375,50}},{1,{24,24},{875,150}},{1,{24,24},{150,700}},{2,{24,24},{400,25}},{1,{24,24},{200,450}},{1,{24,24},{100,450}},{2,{24,24},{425,0}},{2,{24,24},{0,400}},{1,{24,24},{100,700}},{1,{24,24},{975,525}},{1,{24,24},{525,350}},{2,{24,24},{25,325}},{1,{24,24},{725,250}},{1,{24,24},{200,150}},{2,{24,24},{375,75}},{2,{24,24},{75,325}},{1,{24,24},{200,850}},{1,{24,24},{550,775}},{1,{24,24},{400,600}},{1,{24,24},{0,625}},{1,{24,24},{350,625}},{1,{24,24},{200,775}},{2,{24,24},{150,400}},{1,{24,24},{700,975}},{1,{24,24},{875,800}},{1,{24,24},{475,250}},{1,{24,24},{375,475}},{1,{24,24},{500,950}},{2,{24,24},{100,300}},{1,{24,24},{925,625}},{1,{24,24},{450,400}},{2,{24,24},{125,275}},{1,{24,24},{975,250}},{1,{24,24},{375,350}},{2,{24,24},{0,275}},{1,{24,24},{600,825}},{1,{24,24},{400,700}},{2,{24,24},{150,250}},{1,{24,24},{500,200}},{2,{24,24},{200,200}},{2,{24,24},{225,175}},{1,{24,24},{925,175}},{1,{24,24},{600,525}},{1,{24,24},{675,175}},{2,{24,24},{250,150}},{1,{24,24},{275,475}},{1,{24,24},{500,325}},{1,{24,24},{575,450}},{2,{24,24},{125,25}},{1,{24,24},{975,650}},{1,{24,24},{850,425}},{2,{24,24},{350,50}},{1,{24,24},{575,700}},{2,{24,24},{275,100}},{2,{24,24},{300,100}},{1,{24,24},{200,425}},{2,{24,24},{375,25}},{1,{24,24},{0,525}},{1,{24,24},{75,425}},{1,{24,24},{75,525}},{2,{24,24},{0,375}},{1,{24,24},{650,675}},{1,{24,24},{75,0}},{2,{24,24},{50,325}},{1,{24,24},{250,575}},{1,{24,24},{725,200}},{1,{24,24},{350,850}},{1,{24,24},{50,175}},{1,{24,24},{125,575}},{1,{24,24},{575,75}},{1,{24,24},{200,275}},{1,{24,24},{550,725}},{1,{24,24},{125,550}},{1,{24,24},{550,425}},{1,{24,24},{100,625}},{1,{24,24},{900,375}},{1,{24,24},{550,125}},{1,{24,24},{375,225}},{1,{24,24},{850,25}},{1,{24,24},{950,875}},{1,{24,24},{175,100}},{1,{24,24},{850,125}},{1,{24,24},{675,275}},{1,{24,24},{450,75}},{1,{24,24},{0,425}},{1,{24,24},{300,500}},{1,{24,24},{800,475}},{1,{24,24},{200,700}},{2,{24,24},{175,200}},{2,{24,24},{200,175}},{1,{24,24},{250,850}},{1,{24,24},{0,950}},{1,{24,24},{150,550}},{1,{24,24},{500,400}},{2,{24,24},{225,150}},{2,{24,24},{250,125}},{2,{24,24},{300,75}},{2,{24,24},{125,50}},{1,{24,24},{550,625}},{2,{24,24},{100,275}},{1,{24,24},{475,275}},{1,{24,24},{375,25}},{2,{24,24},{350,25}},{1,{24,24},{750,400}},{1,{24,24},{0,825}},{1,{24,24},{475,450}},{1,{24,24},{400,175}},{2,{24,24},{50,300}},{1,{24,24},{375,700}},{1,{24,24},{125,300}},{1,{24,24},{575,100}},{2,{24,24},{375,0}},{1,{24,24},{100,175}},{1,{24,24},{125,175}},{1,{24,24},{400,525}},{2,{24,24},{225,125}},{2,{24,24},{75,275}},{2,{24,24},{475,50}},{1,{24,24},{825,375}},{1,{24,24},{700,125}},{2,{24,24},{100,250}},{1,{24,24},{875,775}},{2,{24,24},{450,0}},{2,{24,24},{300,50}},{2,{24,24},{125,250}},{1,{24,24},{525,175}},{1,{24,24},{25,150}},{1,{24,24},{100,525}},{2,{24,24},{25,300}},{2,{24,24},{0,325}},{1,{24,24},{0,225}},{1,{24,24},{150,525}},{1,{24,24},{350,225}},{2,{24,24},{300,125}},{1,{24,24},{300,900}},{1,{24,24},{100,275}},{1,{24,24},{475,475}},{1,{24,24},{725,550}},{2,{24,24},{75,250}},{2,{24,24},{100,225}},{2,{24,24},{325,25}},{2,{24,24},{150,175}},{1,{24,24},{525,800}},{2,{24,24},{225,100}},{1,{24,24},{50,275}},{2,{24,24},{200,125}},{2,{24,24},{250,75}},{2,{24,24},{275,50}},{2,{24,24},{325,0}},{1,{24,24},{575,825}},{2,{24,24},{300,25}},{1,{24,24},{825,25}},{2,{24,24},{25,275}},{1,{24,24},{925,525}},{2,{24,24},{50,250}},{1,{24,24},{850,950}},{1,{24,24},{800,550}},{1,{24,24},{925,225}},{2,{24,24},{100,200}},{1,{24,24},{175,75}},{1,{24,24},{625,850}},{1,{24,24},{400,475}},{2,{24,24},{150,150}},{2,{24,24},{125,200}},{1,{24,24},{675,975}},{1,{24,24},{50,750}},{1,{24,24},{150,675}},{1,{24,24},{200,25}},{1,{24,24},{600,800}},{1,{24,24},{825,175}},{2,{24,24},{125,175}},{1,{24,24},{775,825}},{2,{24,24},{200,100}},{2,{24,24},{300,0}},{1,{24,24},{775,325}},{1,{24,24},{625,975}},{1,{24,24},{425,975}},{2,{24,24},{75,200}},{1,{24,24},{300,325}},{1,{24,24},{775,625}},{1,{24,24},{650,500}},{1,{24,24},{500,275}},{2,{24,24},{200,325}},{1,{24,24},{250,950}},{1,{24,24},{850,225}},{2,{24,24},{225,50}},{1,{24,24},{75,600}},{2,{24,24},{250,25}},{1,{24,24},{75,575}},{1,{24,24},{900,900}},{1,{24,24},{100,925}},{1,{24,24},{575,50}},{2,{24,24},{200,75}},{1,{24,24},{900,975}},{2,{24,24},{275,0}},{1,{24,24},{0,0}},{1,{24,24},{100,425}},{1,{24,24},{950,950}},{1,{24,24},{375,725}},{2,{24,24},{50,200}},{1,{24,24},{500,725}},{2,{24,24},{125,125}},{2,{24,24},{100,150}},{1,{24,24},{100,900}},{1,{24,24},{250,775}},{1,{24,24},{275,100}},{1,{24,24},{800,975}},{1,{24,24},{0,875}},{2,{24,24},{250,0}},{1,{24,24},{350,75}},{1,{24,24},{800,75}},{1,{24,24},{400,500}},{2,{24,24},{175,75}},{1,{24,24},{875,875}},{2,{24,24},{0,225}},{1,{24,24},{325,700}},{1,{24,24},{450,50}},{2,{24,24},{25,200}},{1,{24,24},{575,975}},{2,{24,24},{50,175}},{1,{24,24},{425,325}},{2,{24,24},{100,125}},{1,{24,24},{650,775}},{1,{24,24},{375,150}},{1,{24,24},{600,625}},{1,{24,24},{0,275}},{1,{24,24},{550,50}},{1,{24,24},{825,925}},{1,{24,24},{375,825}},{1,{24,24},{350,300}},{2,{24,24},{150,75}},{2,{24,24},{200,25}},{1,{24,24},{650,375}},{2,{24,24},{0,200}},{1,{24,24},{975,475}},{1,{24,24},{775,300}},{1,{24,24},{925,775}},{1,{24,24},{0,850}},{1,{24,24},{100,25}},{1,{24,24},{300,750}},{1,{24,24},{425,425}},{1,{24,24},{900,250}},{1,{24,24},{325,250}},{2,{24,24},{75,125}},{2,{24,24},{175,0}},{1,{24,24},{650,200}},{2,{24,24},{125,75}},{1,{24,24},{925,500}},{1,{24,24},{725,800}},{1,{24,24},{700,0}},{2,{24,24},{450,25}},{1,{24,24},{950,100}},{2,{24,24},{25,150}},{2,{24,24},{75,100}},{1,{24,24},{425,950}},{1,{24,24},{600,475}},{1,{24,24},{525,375}},{1,{24,24},{600,75}},{1,{24,24},{50,0}},{2,{24,24},{150,25}},{1,{24,24},{750,950}},{1,{24,24},{125,75}},{1,{24,24},{800,225}},{2,{24,24},{100,100}},{2,{24,24},{0,150}},{2,{24,24},{50,100}},{1,{24,24},{450,100}},{2,{24,24},{75,75}},{1,{24,24},{725,775}},{1,{24,24},{650,25}},{2,{24,24},{100,75}},{2,{24,24},{100,50}},{1,{24,24},{300,825}},{1,{24,24},{375,400}},{1,{24,24},{400,300}},{1,{24,24},{950,400}},{2,{24,24},{0,125}},{2,{24,24},{25,100}},{1,{24,24},{925,600}},{1,{24,24},{150,775}},{1,{24,24},{275,200}},{2,{24,24},{100,25}},{2,{24,24},{75,25}},{1,{24,24},{75,375}},{2,{24,24},{175,175}},{1,{24,24},{900,475}},{1,{24,24},{450,950}},{1,{24,24},{800,375}},{2,{24,24},{25,50}},{2,{24,24},{75,0}},{2,{24,24},{0,50}},{1,{24,24},{200,375}},{1,{24,24},{750,175}},{1,{24,24},{825,200}},{1,{24,24},{525,425}},{1,{24,24},{850,925}},{1,{24,24},{900,50}},{1,{24,24},{200,975}},{2,{24,24},{200,350}},{1,{24,24},{250,750}},{2,{24,24},{0,0}},{1,{24,24},{25,275}},{1,{24,24},{75,825}},{1,{24,24},{400,225}},{1,{24,24},{475,375}},{1,{24,24},{275,675}},{1,{24,24},{650,300}},{1,{24,24},{200,350}},{1,{24,24},{625,100}},{1,{24,24},{925,925}},{1,{24,24},{925,975}},{2,{24,24},{25,0}},{1,{24,24},{275,750}},{1,{24,24},{200,900}},{1,{24,24},{475,25}},{1,{24,24},{975,925}},{1,{24,24},{600,450}},{1,{24,24},{800,100}},{1,{24,24},{300,725}},{1,{24,24},{925,950}},{1,{24,24},{150,200}},{1,{24,24},{425,25}},{1,{24,24},{75,125}},{1,{24,24},{900,950}},{1,{24,24},{975,425}},{1,{24,24},{950,925}},{1,{24,24},{850,975}},{1,{24,24},{875,950}},{1,{24,24},{375,525}},{1,{24,24},{800,450}},{1,{24,24},{0,375}},{1,{24,24},{825,650}},{1,{24,24},{900,600}},{1,{24,24},{900,925}},{1,{24,24},{775,700}},{1,{24,24},{825,575}},{2,{24,24},{75,225}},{1,{24,24},{925,875}},{1,{24,24},{725,150}},{1,{24,24},{250,325}},{1,{24,24},{975,825}},{1,{24,24},{350,250}},{1,{24,24},{875,900}},{1,{24,24},{925,850}},{1,{24,24},{625,950}},{1,{24,24},{75,900}},{1,{24,24},{775,975}},{1,{24,24},{100,300}},{1,{24,24},{700,700}},{2,{24,24},{175,50}},{1,{24,24},{850,900}},{1,{24,24},{625,750}},{1,{24,24},{975,75}},{1,{24,24},{925,825}},{1,{24,24},{950,800}},{1,{24,24},{275,175}},{1,{24,24},{975,775}},{1,{24,24},{150,250}},{1,{24,24},{375,425}},{1,{24,24},{750,975}},{1,{24,24},{300,575}},{1,{24,24},{775,950}},{1,{24,24},{325,825}},{1,{24,24},{825,900}},{1,{24,24},{725,875}},{1,{24,24},{550,525}},{1,{24,24},{325,25}},{1,{24,24},{850,875}},{1,{24,24},{475,825}},{1,{24,24},{375,75}},{1,{24,24},{725,975}},{1,{24,24},{775,925}},{1,{24,24},{800,900}},{1,{24,24},{500,900}},{1,{24,24},{500,550}},{1,{24,24},{925,200}},{1,{24,24},{850,850}},{1,{24,24},{875,825}},{1,{24,24},{900,800}},{1,{24,24},{250,975}},{1,{24,24},{75,625}},{1,{24,24},{50,450}},{1,{24,24},{100,0}},{1,{24,24},{825,700}},{1,{24,24},{550,550}},{1,{24,24},{225,950}},{1,{24,24},{975,675}},{1,{24,24},{450,375}},{1,{24,24},{375,0}},{1,{24,24},{300,200}},{1,{24,24},{800,775}},{2,{24,24},{75,450}},{1,{24,24},{850,825}},{1,{24,24},{25,0}},{1,{24,24},{275,450}},{1,{24,24},{900,775}},{1,{24,24},{925,750}},{2,{24,24},{0,450}},{1,{24,24},{100,750}},{2,{24,24},{325,225}},{1,{24,24},{975,400}},{1,{24,24},{350,525}},{1,{24,24},{775,800}},{1,{24,24},{425,175}},{1,{24,24},{50,725}},{1,{24,24},{750,900}},{1,{24,24},{300,300}},{1,{24,24},{200,200}},{1,{24,24},{775,875}},{1,{24,24},{825,825}},{1,{24,24},{975,600}},{1,{24,24},{850,800}},{1,{24,24},{175,375}},{1,{24,24},{475,575}},{1,{24,24},{125,775}},{2,{24,24},{275,75}},{1,{24,24},{475,625}},{1,{24,24},{50,400}},{1,{24,24},{25,775}},{1,{24,24},{450,450}},{1,{24,24},{225,475}},{1,{24,24},{300,125}},{1,{24,24},{725,350}},{1,{24,24},{925,725}},{1,{24,24},{775,650}},{1,{24,24},{625,675}},{1,{24,24},{400,50}},{1,{24,24},{275,925}},{1,{24,24},{650,975}},{1,{24,24},{325,500}},{1,{24,24},{675,950}},{1,{24,24},{800,275}},{1,{24,24},{700,925}},{1,{24,24},{725,900}},{1,{24,24},{250,925}},{1,{24,24},{250,250}},{1,{24,24},{875,125}},{1,{24,24},{775,850}},{1,{24,24},{575,875}},{1,{24,24},{475,675}},{1,{24,24},{675,800}},{1,{24,24},{850,775}},{1,{24,24},{325,625}},{1,{24,24},{400,125}},{1,{24,24},{875,325}},{1,{24,24},{875,925}},{1,{24,24},{925,700}},{1,{24,24},{775,275}},{1,{24,24},{650,75}},{1,{24,24},{950,675}},{2,{24,24},{25,250}},{1,{24,24},{200,100}},{1,{24,24},{225,200}},{1,{24,24},{950,575}},{1,{24,24},{325,675}},{1,{24,24},{75,400}},{1,{24,24},{750,525}},{1,{24,24},{350,700}},{1,{24,24},{875,600}},{1,{24,24},{500,100}},{1,{24,24},{800,800}},{1,{24,24},{825,775}},{1,{24,24},{375,175}},{1,{24,24},{850,750}},{1,{24,24},{75,250}},{1,{24,24},{325,300}},{1,{24,24},{600,300}},{1,{24,24},{875,725}},{1,{24,24},{175,525}},{1,{24,24},{900,700}},{1,{24,24},{725,50}},{1,{24,24},{825,75}},{1,{24,24},{725,325}},{1,{24,24},{950,650}},{1,{24,24},{650,225}},{1,{24,24},{125,275}},{1,{24,24},{825,300}},{1,{24,24},{25,225}},{1,{24,24},{175,350}},{1,{24,24},{350,100}},{1,{24,24},{700,675}},{1,{24,24},{500,25}},{1,{24,24},{800,650}},{1,{24,24},{775,500}},{1,{24,24},{750,375}},{1,{24,24},{800,875}},{1,{24,24},{975,800}},{1,{24,24},{325,775}},{1,{24,24},{650,925}},{1,{24,24},{825,500}},{1,{24,24},{900,200}},{1,{24,24},{300,25}},{1,{24,24},{675,900}},{1,{24,24},{525,200}},{1,{24,24},{725,850}},{1,{24,24},{950,475}},{1,{24,24},{150,0}},{1,{24,24},{450,200}},{1,{24,24},{50,150}},{1,{24,24},{875,275}},{1,{24,24},{675,775}},{1,{24,24},{700,875}},{1,{24,24},{700,950}},{1,{24,24},{125,875}},{1,{24,24},{400,425}},{1,{24,24},{550,575}},{1,{24,24},{775,200}},{1,{24,24},{400,550}},{1,{24,24},{775,900}},{1,{24,24},{950,50}},{2,{24,24},{300,250}},{2,{24,24},{400,125}},{1,{24,24},{875,700}},{1,{24,24},{200,525}},{1,{24,24},{850,50}},{1,{24,24},{900,75}},{1,{24,24},{550,200}},{1,{24,24},{100,50}},{1,{24,24},{950,625}},{1,{24,24},{600,950}},{1,{24,24},{650,900}},{1,{24,24},{450,125}},{1,{24,24},{675,875}},{1,{24,24},{125,150}},{1,{24,24},{275,125}},{1,{24,24},{700,850}},{2,{24,24},{175,225}},{1,{24,24},{750,800}},{1,{24,24},{575,950}},{1,{24,24},{525,400}},{1,{24,24},{775,775}},{1,{24,24},{150,325}},{1,{24,24},{675,725}},{1,{24,24},{625,550}},{1,{24,24},{825,725}},{1,{24,24},{375,575}},{1,{24,24},{850,700}},{1,{24,24},{700,300}},{1,{24,24},{750,925}},{1,{24,24},{475,650}},{1,{24,24},{875,350}},{1,{24,24},{550,975}},{1,{24,24},{300,625}},{1,{24,24},{775,475}},{1,{24,24},{625,900}},{1,{24,24},{700,825}},{1,{24,24},{150,150}},{1,{24,24},{800,725}},{1,{24,24},{725,950}},{1,{24,24},{850,675}},{1,{24,24},{875,650}},{1,{24,24},{675,300}},{2,{24,24},{50,75}},{1,{24,24},{950,425}},{1,{24,24},{650,950}},{1,{24,24},{575,350}},{1,{24,24},{925,25}},{1,{24,24},{175,400}},{1,{24,24},{150,225}},{1,{24,24},{925,250}},{1,{24,24},{500,750}},{1,{24,24},{975,550}},{1,{24,24},{100,125}},{1,{24,24},{575,925}},{1,{24,24},{550,950}},{1,{24,24},{600,900}},{1,{24,24},{625,75}},{1,{24,24},{625,875}},{1,{24,24},{275,275}},{1,{24,24},{600,150}},{1,{24,24},{25,575}},{1,{24,24},{750,775}},{2,{24,24},{50,475}},{1,{24,24},{700,800}},{1,{24,24},{300,650}},{1,{24,24},{750,750}},{1,{24,24},{925,0}},{1,{24,24},{800,700}},{1,{24,24},{850,650}},{1,{24,24},{100,325}},{1,{24,24},{825,675}},{1,{24,24},{950,550}},{1,{24,24},{725,500}},{1,{24,24},{125,475}},{2,{24,24},{25,375}},{1,{24,24},{750,600}},{1,{24,24},{875,625}},{1,{24,24},{750,575}},{2,{24,24},{175,325}},{1,{24,24},{450,150}},{1,{24,24},{800,825}},{1,{24,24},{325,550}},{1,{24,24},{475,200}},{1,{24,24},{700,775}},{1,{24,24},{725,750}},{1,{24,24},{750,75}},{1,{24,24},{100,850}},{1,{24,24},{975,850}},{1,{24,24},{650,825}},{1,{24,24},{800,675}},{1,{24,24},{675,925}},{1,{24,24},{700,400}},{1,{24,24},{850,625}},{1,{24,24},{725,225}},{1,{24,24},{500,575}},{1,{24,24},{0,75}},{1,{24,24},{75,925}},{1,{24,24},{400,450}},{1,{24,24},{800,950}},{1,{24,24},{975,500}},{1,{24,24},{150,300}},{1,{24,24},{975,450}},{1,{24,24},{375,250}},{1,{24,24},{75,500}},{1,{24,24},{250,675}},{1,{24,24},{550,900}},{1,{24,24},{225,900}},{1,{24,24},{575,725}},{1,{24,24},{875,300}},{1,{24,24},{650,800}},{1,{24,24},{625,250}},{1,{24,24},{700,750}},{1,{24,24},{525,725}},{1,{24,24},{600,375}},{1,{24,24},{725,725}},{1,{24,24},{575,400}},{1,{24,24},{375,925}},{1,{24,24},{475,975}},{1,{24,24},{675,125}},{1,{24,24},{650,100}},{1,{24,24},{225,400}},{1,{24,24},{25,25}},{1,{24,24},{350,0}},{1,{24,24},{775,550}},{1,{24,24},{900,425}},{1,{24,24},{625,125}},{1,{24,24},{850,600}},{1,{24,24},{175,775}},{1,{24,24},{475,300}},{1,{24,24},{675,200}},{1,{24,24},{550,800}},{1,{24,24},{600,25}},{1,{24,24},{900,550}},{1,{24,24},{525,25}},{1,{24,24},{125,50}},{1,{24,24},{575,300}},{2,{24,24},{350,150}},{2,{24,24},{25,175}},{1,{24,24},{475,950}},{1,{24,24},{500,925}},{1,{24,24},{525,900}},{1,{24,24},{450,225}},{1,{24,24},{550,875}},{1,{24,24},{750,675}},{1,{24,24},{625,800}},{1,{24,24},{575,500}},{1,{24,24},{275,575}},{1,{24,24},{700,725}},{2,{24,24},{225,250}},{1,{24,24},{250,150}},{1,{24,24},{575,850}},{1,{24,24},{950,700}},{1,{24,24},{350,175}},{1,{24,24},{750,200}},{1,{24,24},{825,600}},{1,{24,24},{425,125}},{1,{24,24},{800,625}},{1,{24,24},{175,725}},{1,{24,24},{900,525}},{2,{24,24},{200,0}},{1,{24,24},{400,75}},{1,{24,24},{275,800}},{1,{24,24},{175,150}},{1,{24,24},{200,225}},{1,{24,24},{350,675}},{1,{24,24},{175,550}},{1,{24,24},{25,800}},{1,{24,24},{275,50}},{2,{24,24},{0,100}},{1,{24,24},{475,925}},{1,{24,24},{525,875}},{1,{24,24},{100,775}},{1,{24,24},{525,275}},{1,{24,24},{625,775}},{1,{24,24},{950,525}},{1,{24,24},{125,925}},{1,{24,24},{725,675}},{1,{24,24},{800,600}},{2,{24,24},{100,175}},{1,{24,24},{125,625}},{1,{24,24},{850,550}},{1,{24,24},{875,525}},{1,{24,24},{625,575}},{1,{24,24},{200,925}},{1,{24,24},{425,875}},{1,{24,24},{525,825}},{1,{24,24},{700,225}},{1,{24,24},{900,500}},{1,{24,24},{825,975}},{1,{24,24},{925,475}},{1,{24,24},{950,450}},{1,{24,24},{750,300}},{1,{24,24},{950,900}},{1,{24,24},{625,700}},{1,{24,24},{350,400}},{1,{24,24},{925,375}},{1,{24,24},{675,450}},{1,{24,24},{425,100}},{2,{24,24},{50,125}},{1,{24,24},{400,975}},{1,{24,24},{500,800}},{2,{24,24},{250,100}},{1,{24,24},{250,225}},{1,{24,24},{500,500}},{2,{24,24},{50,275}},{1,{24,24},{325,275}},{1,{24,24},{275,400}},{1,{24,24},{350,950}},{1,{24,24},{800,0}},{1,{24,24},{500,875}},{1,{24,24},{0,650}},{1,{24,24},{350,50}},{1,{24,24},{600,775}},{1,{24,24},{650,725}},{1,{24,24},{400,25}},{1,{24,24},{800,175}},{1,{24,24},{600,225}},{1,{24,24},{325,650}},{1,{24,24},{800,575}},{1,{24,24},{425,850}},{1,{24,24},{475,400}},{1,{24,24},{825,550}},{1,{24,24},{875,225}},{1,{24,24},{775,50}},{1,{24,24},{875,500}},{1,{24,24},{225,225}},{1,{24,24},{925,450}},{2,{24,24},{425,125}},{1,{24,24},{725,925}},{1,{24,24},{375,975}},{1,{24,24},{400,950}},{1,{24,24},{900,350}},{1,{24,24},{400,650}},{1,{24,24},{500,850}},{1,{24,24},{450,900}},{1,{24,24},{525,600}},{1,{24,24},{575,775}},{1,{24,24},{250,375}},{1,{24,24},{300,850}},{1,{24,24},{600,750}},{1,{24,24},{0,600}},{1,{24,24},{650,700}},{1,{24,24},{50,200}},{1,{24,24},{700,650}},{1,{24,24},{725,625}},{1,{24,24},{950,275}},{1,{24,24},{625,275}},{1,{24,24},{775,575}},{1,{24,24},{825,875}},{1,{24,24},{650,150}},{1,{24,24},{850,500}},{1,{24,24},{425,700}},{2,{24,24},{150,0}},{1,{24,24},{925,425}},{1,{24,24},{975,375}},{1,{24,24},{750,100}},{1,{24,24},{825,750}},{1,{24,24},{0,800}},{1,{24,24},{525,650}},{1,{24,24},{500,700}},{1,{24,24},{700,100}},{1,{24,24},{600,100}},{1,{24,24},{550,150}},{1,{24,24},{875,550}},{1,{24,24},{125,200}},{1,{24,24},{575,675}},{1,{24,24},{0,400}},{1,{24,24},{975,100}},{1,{24,24},{375,300}},{1,{24,24},{225,650}},{1,{24,24},{925,75}},{1,{24,24},{775,375}},{1,{24,24},{350,575}},{1,{24,24},{450,700}},{1,{24,24},{500,825}},{2,{24,24},{175,150}},{1,{24,24},{600,725}},{1,{24,24},{250,0}},{1,{24,24},{700,625}},{1,{24,24},{850,0}},{1,{24,24},{675,650}},{1,{24,24},{800,525}},{1,{24,24},{600,425}},{1,{24,24},{775,675}},{1,{24,24},{875,450}},{1,{24,24},{800,125}},{1,{24,24},{700,575}},{1,{24,24},{925,400}},{1,{24,24},{700,425}},{1,{24,24},{325,900}},{1,{24,24},{550,825}},{1,{24,24},{450,850}},{1,{24,24},{975,750}},{1,{24,24},{400,250}},{1,{24,24},{950,250}},{1,{24,24},{375,675}},{1,{24,24},{600,850}},{1,{24,24},{550,175}},{1,{24,24},{900,750}},{1,{24,24},{100,375}},{1,{24,24},{750,150}},{1,{24,24},{650,650}},{1,{24,24},{525,775}},{1,{24,24},{875,575}},{1,{24,24},{200,75}},{1,{24,24},{725,575}},{1,{24,24},{450,925}},{2,{24,24},{75,375}},{1,{24,24},{150,400}},{1,{24,24},{900,400}},{1,{24,24},{700,900}},{1,{24,24},{400,0}},{1,{24,24},{700,275}},{1,{24,24},{300,975}},{1,{24,24},{625,50}},{1,{24,24},{325,950}},{1,{24,24},{775,225}},{1,{24,24},{350,925}},{1,{24,24},{375,900}},{1,{24,24},{425,0}},{1,{24,24},{525,750}},{2,{24,24},{175,125}},{1,{24,24},{200,50}},{1,{24,24},{525,50}},{1,{24,24},{650,625}},{1,{24,24},{675,600}},{1,{24,24},{275,75}},{1,{24,24},{825,450}},{1,{24,24},{875,400}},{1,{24,24},{925,350}},{1,{24,24},{950,325}},{1,{24,24},{750,425}},{1,{24,24},{250,25}},{1,{24,24},{975,300}},{1,{24,24},{650,425}},{2,{24,24},{300,225}},{1,{24,24},{625,225}},{1,{24,24},{375,875}},{1,{24,24},{300,950}},{1,{24,24},{925,150}},{1,{24,24},{425,600}},{1,{24,24},{400,850}},{1,{24,24},{900,325}},{1,{24,24},{475,775}},{1,{24,24},{600,650}},{1,{24,24},{950,725}},{1,{24,24},{800,325}},{1,{24,24},{650,600}},{1,{24,24},{475,0}},{1,{24,24},{775,25}},{1,{24,24},{725,525}},{1,{24,24},{550,700}},{1,{24,24},{750,500}},{1,{24,24},{675,375}},{1,{24,24},{175,25}},{1,{24,24},{0,50}},{1,{24,24},{975,575}},{1,{24,24},{75,100}},{1,{24,24},{825,425}},{1,{24,24},{25,75}},{1,{24,24},{525,300}},{1,{24,24},{125,750}},{1,{24,24},{450,275}},{1,{24,24},{900,100}},{1,{24,24},{75,650}},{1,{24,24},{250,200}},{1,{24,24},{525,475}},{1,{24,24},{475,875}},{1,{24,24},{625,475}},{1,{24,24},{75,750}},{1,{24,24},{925,325}},{1,{24,24},{175,675}},{1,{24,24},{500,250}},{1,{24,24},{975,725}},{1,{24,24},{125,250}},{1,{24,24},{375,600}},{1,{24,24},{975,275}},{1,{24,24},{300,925}},{1,{24,24},{325,350}},{1,{24,24},{50,800}},{1,{24,24},{275,950}},{1,{24,24},{625,450}},{1,{24,24},{550,325}},{2,{24,24},{75,175}},{1,{24,24},{0,300}},{1,{24,24},{525,700}},{1,{24,24},{750,325}},{1,{24,24},{375,775}},{1,{24,24},{500,375}},{1,{24,24},{200,550}},{1,{24,24},{550,675}},{1,{24,24},{625,600}},{1,{24,24},{500,675}},{1,{24,24},{575,650}},{1,{24,24},{750,475}},{1,{24,24},{775,0}},{1,{24,24},{525,325}},{1,{24,24},{150,725}},{1,{24,24},{850,375}},{1,{24,24},{425,825}},{1,{24,24},{325,75}},{1,{24,24},{425,525}},{1,{24,24},{925,300}},{1,{24,24},{175,600}},{1,{24,24},{225,975}},{2,{24,24},{175,100}},{1,{24,24},{825,325}},{1,{24,24},{0,975}},{1,{24,24},{325,875}},{1,{24,24},{575,425}},{1,{24,24},{325,425}},{1,{24,24},{725,400}},{1,{24,24},{450,750}},{1,{24,24},{575,625}},{1,{24,24},{125,950}},{1,{24,24},{400,200}},{1,{24,24},{100,550}},{1,{24,24},{900,150}},{1,{24,24},{450,25}},{1,{24,24},{175,50}},{1,{24,24},{550,850}},{1,{24,24},{100,400}},{1,{24,24},{675,250}},{1,{24,24},{725,475}},{1,{24,24},{775,425}},{1,{24,24},{50,600}},{1,{24,24},{250,900}},{1,{24,24},{350,200}},{1,{24,24},{0,250}},{1,{24,24},{900,725}},{1,{24,24},{900,300}},{1,{24,24},{225,425}},{1,{24,24},{925,275}},{1,{24,24},{500,650}},{1,{24,24},{25,625}},{1,{24,24},{600,0}},{1,{24,24},{975,225}},{1,{24,24},{625,300}},{1,{24,24},{950,600}},{1,{24,24},{225,325}},{1,{24,24},{675,75}},{1,{24,24},{750,875}},{1,{24,24},{350,750}},{1,{24,24},{225,500}},{1,{24,24},{300,375}},{1,{24,24},{575,175}},{1,{24,24},{25,175}},{1,{24,24},{150,100}},{1,{24,24},{300,875}},{1,{24,24},{325,850}},{1,{24,24},{375,800}},{1,{24,24},{300,775}},{1,{24,24},{450,725}},{1,{24,24},{150,925}},{1,{24,24},{475,175}},{1,{24,24},{50,650}},{1,{24,24},{450,250}},{1,{24,24},{975,125}},{1,{24,24},{575,600}},{1,{24,24},{650,525}},{1,{24,24},{325,325}},{1,{24,24},{100,225}},{1,{24,24},{200,950}},{1,{24,24},{350,425}},{1,{24,24},{725,450}},{2,{24,24},{0,75}},{1,{24,24},{575,475}},{1,{24,24},{700,475}},{1,{24,24},{100,950}},{1,{24,24},{575,275}},{1,{24,24},{475,500}},{1,{24,24},{825,950}},{1,{24,24},{175,125}},{1,{24,24},{125,25}},{1,{24,24},{625,825}},{1,{24,24},{150,25}},{1,{24,24},{225,775}},{1,{24,24},{50,25}},{1,{24,24},{950,225}},{1,{24,24},{975,200}},{1,{24,24},{175,975}},{1,{24,24},{850,350}},{1,{24,24},{275,150}},{1,{24,24},{425,375}},{1,{24,24},{800,925}},{1,{24,24},{350,800}},{1,{24,24},{400,750}},{1,{24,24},{800,25}},{1,{24,24},{850,400}},{2,{24,24},{275,25}},{1,{24,24},{700,450}},{1,{24,24},{725,425}},{1,{24,24},{200,325}},{1,{24,24},{175,325}},{1,{24,24},{800,350}},{2,{24,24},{250,200}},{1,{24,24},{975,175}},{1,{24,24},{100,500}},{1,{24,24},{400,400}},{1,{24,24},{375,200}},{1,{24,24},{575,375}},{2,{24,24},{25,25}},{1,{24,24},{150,500}},{1,{24,24},{400,825}},{1,{24,24},{700,150}},{1,{24,24},{375,750}},{1,{24,24},{350,775}},{1,{24,24},{250,525}},{1,{24,24},{800,200}},{1,{24,24},{875,475}},{2,{24,24},{100,325}},{1,{24,24},{275,975}},{1,{24,24},{325,800}},{1,{24,24},{325,975}},{2,{24,24},{150,275}},{1,{24,24},{175,250}},{1,{24,24},{875,250}},{1,{24,24},{850,275}},{1,{24,24},{950,175}},{1,{24,24},{975,150}},{1,{24,24},{125,975}},{1,{24,24},{550,650}},{1,{24,24},{125,700}},{1,{24,24},{850,725}},{1,{24,24},{25,750}},{1,{24,24},{0,200}},{1,{24,24},{275,25}},{1,{24,24},{175,475}},{2,{24,24},{125,325}},{1,{24,24},{225,450}},{1,{24,24},{275,825}},{1,{24,24},{175,450}},{2,{24,24},{25,225}},{1,{24,24},{225,50}},{1,{24,24},{275,900}},{1,{24,24},{300,800}},{1,{24,24},{150,475}},{1,{24,24},{250,300}},{1,{24,24},{450,650}},{1,{24,24},{700,175}},{1,{24,24},{725,825}},{1,{24,24},{225,800}},{1,{24,24},{500,600}},{1,{24,24},{525,575}},{1,{24,24},{400,625}},{1,{24,24},{50,100}},{1,{24,24},{275,500}},{1,{24,24},{125,425}},{1,{24,24},{325,475}},{1,{24,24},{50,775}},{1,{24,24},{600,500}},{1,{24,24},{75,450}},{1,{24,24},{325,125}},{1,{24,24},{875,200}},{1,{24,24},{675,225}},{1,{24,24},{650,400}},{1,{24,24},{75,25}},{1,{24,24},{425,250}},{2,{24,24},{50,350}},{1,{24,24},{625,400}},{1,{24,24},{850,525}},{1,{24,24},{700,325}},{1,{24,24},{100,975}},{1,{24,24},{500,525}},{1,{24,24},{400,800}},{1,{24,24},{475,700}},{1,{24,24},{175,900}},{1,{24,24},{200,875}},{1,{24,24},{500,450}},{1,{24,24},{225,850}},{1,{24,24},{350,150}},{1,{24,24},{425,750}},{1,{24,24},{250,825}},{1,{24,24},{325,750}},{1,{24,24},{350,725}},{1,{24,24},{300,700}},{1,{24,24},{200,125}},{1,{24,24},{400,675}},{1,{24,24},{875,375}},{1,{24,24},{450,600}},{1,{24,24},{475,600}},{1,{24,24},{25,50}},{1,{24,24},{50,925}},{1,{24,24},{425,150}},{1,{24,24},{325,100}},{1,{24,24},{900,575}},{1,{24,24},{875,850}},{1,{24,24},{350,875}},{1,{24,24},{250,50}},{1,{24,24},{275,425}},{2,{24,24},{50,150}},{2,{24,24},{100,450}},{1,{24,24},{900,175}},{1,{24,24},{300,525}},{1,{24,24},{0,900}},{1,{24,24},{175,800}},{1,{24,24},{275,625}},{1,{24,24},{950,125}},{1,{24,24},{475,850}},{1,{24,24},{300,175}},{1,{24,24},{250,350}},{1,{24,24},{575,25}},{1,{24,24},{400,325}},{1,{24,24},{750,650}},{1,{24,24},{700,50}},{1,{24,24},{25,675}},{1,{24,24},{325,725}},{1,{24,24},{650,450}},{1,{24,24},{825,525}},{1,{24,24},{550,500}},{1,{24,24},{675,425}},{1,{24,24},{525,525}},{1,{24,24},{0,25}},{1,{24,24},{700,350}},{1,{24,24},{800,250}},{1,{24,24},{275,850}},{1,{24,24},{850,200}},{1,{24,24},{875,175}},{1,{24,24},{925,125}},{1,{24,24},{500,300}},{1,{24,24},{300,0}},{1,{24,24},{875,50}},{1,{24,24},{900,850}},{1,{24,24},{50,975}},{1,{24,24},{150,375}},{1,{24,24},{75,950}},{1,{24,24},{125,900}},{1,{24,24},{150,275}},{1,{24,24},{150,875}},{1,{24,24},{175,850}},{1,{24,24},{200,825}},{1,{24,24},{775,175}},{1,{24,24},{775,350}},{1,{24,24},{450,575}},{1,{24,24},{525,500}},{1,{24,24},{550,475}},{1,{24,24},{300,225}},{1,{24,24},{475,150}},{1,{24,24},{75,800}},{1,{24,24},{275,325}},{1,{24,24},{250,425}},{1,{24,24},{675,50}},{2,{24,24},{325,75}},{2,{24,24},{225,0}},{1,{24,24},{950,150}},{1,{24,24},{725,300}},{1,{24,24},{175,650}},{1,{24,24},{75,675}},{1,{24,24},{300,100}},{1,{24,24},{175,950}},{1,{24,24},{650,125}},{1,{24,24},{850,175}},{1,{24,24},{125,450}},{1,{24,24},{175,825}},{1,{24,24},{325,150}},{1,{24,24},{925,100}},{1,{24,24},{125,350}},{1,{24,24},{975,50}},{1,{24,24},{225,300}},{1,{24,24},{275,300}},{2,{24,24},{150,100}},{1,{24,24},{150,850}},{1,{24,24},{900,125}},{2,{24,24},{450,50}},{2,{24,24},{0,25}},{1,{24,24},{200,625}},{1,{24,24},{950,500}},{1,{24,24},{350,650}},{1,{24,24},{375,625}},{1,{24,24},{425,575}},{1,{24,24},{450,550}},{1,{24,24},{475,525}},{1,{24,24},{50,850}},{1,{24,24},{225,250}},{1,{24,24},{0,775}},{1,{24,24},{550,450}},{1,{24,24},{625,375}},{1,{24,24},{675,325}},{1,{24,24},{900,650}},{1,{24,24},{325,925}},{1,{24,24},{350,475}},{1,{24,24},{750,250}},{1,{24,24},{125,650}},{1,{24,24},{175,200}},{1,{24,24},{450,675}},{1,{24,24},{200,300}},{1,{24,24},{350,25}},{1,{24,24},{950,350}},{1,{24,24},{975,25}},{1,{24,24},{150,425}},{1,{24,24},{100,875}},{1,{24,24},{550,350}},{1,{24,24},{350,600}},{1,{24,24},{300,675}},{1,{24,24},{225,750}},{1,{24,24},{450,525}},{1,{24,24},{650,325}},{1,{24,24},{900,625}},{1,{24,24},{175,500}},{1,{24,24},{200,600}},{1,{24,24},{725,125}},{1,{24,24},{250,400}},{1,{24,24},{175,575}},{1,{24,24},{575,225}},{1,{24,24},{75,275}},{1,{24,24},{300,600}},{1,{24,24},{775,600}},{1,{24,24},{875,100}},{1,{24,24},{925,50}},{1,{24,24},{950,25}},{1,{24,24},{350,325}},{1,{24,24},{900,0}},{1,{24,24},{650,175}},{1,{24,24},{975,0}},{1,{24,24},{100,150}},{1,{24,24},{0,575}},{1,{24,24},{50,900}},{1,{24,24},{75,875}},{1,{24,24},{700,600}},{1,{24,24},{250,100}},{1,{24,24},{225,725}},{1,{24,24},{75,850}},{1,{24,24},{750,50}},{1,{24,24},{250,700}},{1,{24,24},{525,125}},{1,{24,24},{975,950}},{1,{24,24},{875,750}},{1,{24,24},{775,725}},{1,{24,24},{600,350}},{1,{24,24},{625,325}},{1,{24,24},{850,100}},{1,{24,24},{0,925}},{1,{24,24},{25,900}},{1,{24,24},{125,800}},{1,{24,24},{25,600}},{1,{24,24},{175,750}},{1,{24,24},{275,250}},{1,{24,24},{200,725}},{1,{24,24},{575,575}},{1,{24,24},{425,500}},{2,{24,24},{0,350}},{1,{24,24},{500,425}},{1,{24,24},{800,150}},{1,{24,24},{750,450}},{2,{24,24},{25,350}},{2,{24,24},{150,350}},{1,{24,24},{825,100}},{1,{24,24},{0,125}},{1,{24,24},{25,875}},{1,{24,24},{100,800}},{1,{24,24},{425,900}},{2,{24,24},{150,225}},{1,{24,24},{225,350}},{1,{24,24},{225,675}},{1,{24,24},{325,575}},{1,{24,24},{625,350}},{1,{24,24},{100,350}},{1,{24,24},{325,0}},{1,{24,24},{925,900}},{1,{24,24},{575,150}},{1,{24,24},{25,325}},{1,{24,24},{125,725}},{1,{24,24},{425,475}},{1,{24,24},{475,425}},{1,{24,24},{275,700}},{1,{24,24},{575,325}},{1,{24,24},{0,500}},{1,{24,24},{700,200}},{1,{24,24},{700,25}},{1,{24,24},{175,700}},{1,{24,24},{750,275}},{1,{24,24},{925,675}},{1,{24,24},{50,825}},{1,{24,24},{25,850}},{1,{24,24},{275,600}},{1,{24,24},{225,550}},{1,{24,24},{500,225}},{2,{24,24},{125,425}},{1,{24,24},{825,225}},{1,{24,24},{275,725}},{2,{24,24},{75,300}},{1,{24,24},{875,0}},{1,{24,24},{75,775}},{1,{24,24},{675,750}},{1,{24,24},{300,550}},{1,{24,24},{150,175}},{1,{24,24},{625,500}},{1,{24,24},{950,975}},{1,{24,24},{675,550}},{1,{24,24},{725,275}},{1,{24,24},{775,75}},{1,{24,24},{475,225}},{1,{24,24},{525,250}},{1,{24,24},{100,725}},{2,{24,24},{350,125}},{1,{24,24},{425,650}},{1,{24,24},{625,200}},{1,{24,24},{725,100}},{1,{24,24},{750,725}},{1,{24,24},{250,450}},{1,{24,24},{225,525}},{1,{24,24},{150,650}},{1,{24,24},{725,0}},{1,{24,24},{125,0}},{1,{24,24},{175,625}},{1,{24,24},{225,575}},{1,{24,24},{375,375}},{1,{24,24},{0,725}},{1,{24,24},{700,500}},{1,{24,24},{600,200}},{1,{24,24},{575,550}},{1,{24,24},{700,550}},{1,{24,24},{600,50}},{1,{24,24},{825,475}},{1,{24,24},{525,0}},{1,{24,24},{575,525}},{1,{24,24},{400,375}},{1,{24,24},{425,350}},{1,{24,24},{200,575}},{1,{24,24},{625,150}},{1,{24,24},{350,375}},{1,{24,24},{675,100}},{1,{24,24},{700,75}},{1,{24,24},{125,225}},{1,{24,24},{750,25}},{1,{24,24},{525,850}},{1,{24,24},{50,700}},{1,{24,24},{25,125}},{1,{24,24},{550,75}},{1,{24,24},{775,125}},{1,{24,24},{750,225}},{1,{24,24},{250,500}},{1,{24,24},{250,550}},{1,{24,24},{250,175}},{1,{24,24},{375,550}},{1,{24,24},{25,700}},{1,{24,24},{125,600}},{1,{24,24},{75,75}},{1,{24,24},{375,450}},{1,{24,24},{425,300}},{1,{24,24},{75,725}},{1,{24,24},{200,250}},{1,{24,24},{350,350}},{1,{24,24},{25,650}},{1,{24,24},{500,0}},{1,{24,24},{25,925}},{1,{24,24},{500,175}},{1,{24,24},{575,800}},{1,{24,24},{650,550}},{1,{24,24},{175,925}},{1,{24,24},{425,225}},{1,{24,24},{125,375}},{1,{24,24},{550,750}},{1,{24,24},{750,825}},{1,{24,24},{550,100}},{2,{24,24},{350,0}},{1,{24,24},{125,500}},{1,{24,24},{50,550}},{1,{24,24},{975,975}},{1,{24,24},{425,200}},{1,{24,24},{450,175}},{1,{24,24},{625,0}},{1,{24,24},{350,275}},{1,{24,24},{825,350}},{2,{24,24},{325,50}},{1,{24,24},{75,175}},{1,{24,24},{100,675}},{1,{24,24},{100,475}},{1,{24,24},{50,225}},{1,{24,24},{525,550}},{1,{24,24},{600,675}},{1,{24,24},{375,50}},{1,{24,24},{425,675}},{1,{24,24},{500,50}},{2,{24,24},{75,150}},{1,{24,24},{325,200}},{1,{24,24},{600,175}},{1,{24,24},{150,350}},{1,{24,24},{400,100}},{1,{24,24},{0,475}},{1,{24,24},{425,625}},{1,{24,24},{900,225}},{1,{24,24},{475,800}},{1,{24,24},{200,175}},{2,{24,24},{200,250}},{1,{24,24},{225,75}},{1,{24,24},{150,75}}}}}
local iconIndices: { string } = icons[1]
local idIndices: { string } = icons[2]
local iconRegistry: { [number]: { number | { number } } } = icons[3]

local fontCodepoints = {["align-vertical-distribute-center"]=57372,["chevron-down"]=57695,["list-restart"]=58320,["table-cells-split"]=58966,gavel=58113,["dna-off"]=57915,["refresh-ccw-dot"]=58661,venus=59123,bean=57493,["circle-question-mark"]=57752,["folder-code"]=58065,bolt=57531,heater=58200,feather=57976,["align-horizontal-distribute-center"]=57362,["grip-vertical"]=58157,["pill-bottle"]=58591,["person-standing"]=58571,["badge-swiss-franc"]=57467,["between-horizontal-end"]=57510,["file-braces-corner"]=57985,["rotate-cw"]=58689,["house-plus"]=58214,["bus-front"]=57603,["shield-ellipsis"]=58768,["between-vertical-end"]=57512,["globe-lock"]=58142,tags=58977,["concierge-bell"]=57838,["bookmark-minus"]=57563,["plant-pot"]=58599,["file-down"]=57998,["picture-in-picture"]=58584,["messages-square"]=58417,scissors=58730,["file-check-corner"]=57991,["phone-call"]=58575,anchor=57384,["hand-helping"]=58168,["text-wrap"]=59001,birdhouse=57520,["wifi-off"]=59170,["cloud-alert"]=57802,["message-square"]=58399,["cloud-download"]=57806,["folder-plus"]=58081,["cctv-off"]=57660,["notebook-dot"]=58498,["mirror-round"]=58435,["user-round"]=59096,pointer=58611,["between-horizontal-start"]=57511,["chevrons-up-down"]=57709,brush=57593,["message-circle-more"]=58392,parentheses=58553,["book-up-2"]=57558,flame=58047,["chevrons-up"]=57708,["square-dashed"]=58866,["square-mouse-pointer"]=58887,superscript=58956,signal=58796,["wifi-cog"]=59167,hexagon=58202,["navigation-2-off"]=58490,["eye-off"]=57964,["arrows-up-from-line"]=57438,["file-code-corner"]=57994,["square-centerline-dashed-horizontal"]=58856,["panels-right-bottom"]=58548,scaling=58717,hash=58177,["arrow-left-from-line"]=57418,ship=58778,["ticket-percent"]=59012,["calendar-clock"]=57616,x=59182,["non-binary"]=58496,voicemail=59133,presentation=58618,["tree-palm"]=59047,badge=57452,["captions-off"]=57642,["align-vertical-justify-center"]=57375,download=57927,["mouse-right"]=58467,["text-align-justify-start"]=59208,["lens-convex"]=58286,["shrimp-off"]=58791,focus=58056,["diamond-percent"]=57899,["arrow-big-up"]=57402,["volume-x"]=59139,["mouse-pointer-click"]=58466,["face-slightly-smiling-plus"]=57971,["hard-drive"]=58173,["grid-2x2-x"]=58152,["package-minus"]=58518,cloud=57801,pipette=58594,["corner-left-down"]=57857,["badge-cent"]=57454,["cloud-lightning"]=57810,["user-round-pen"]=59103,["arrow-left-to-line"]=57420,["book-open-text"]=57552,["monitor-cloud"]=58438,["parking-meter"]=58555,cat=57658,["heart-handshake"]=58194,dam=57881,trees=59049,ham=58160,["circle-pause"]=57745,["chess-king"]=57690,["bean-off"]=57494,["clef-alto"]=57764,["separator-horizontal"]=58747,ambulance=57380,["globe-code"]=58141,citrus=57762,["phone-missed"]=58578,["calendar-off"]=57623,["chart-column"]=57668,["battery-medium"]=57489,["square-minus"]=58886,["star-check"]=58925,["decimals-arrow-left"]=57892,["folder-output"]=58079,menu=58384,["bangladeshi-taka"]=57475,["image-down"]=58222,terminal=58988,["building-complex-plus"]=57601,["circle-dot-dashed"]=57734,medal=58380,["cake-slice"]=57607,["git-graph"]=58128,armchair=57395,tickets=59016,["qr-code"]=58627,copy=57847,goal=58145,["book-bookmark"]=57539,["trending-down"]=59050,["creative-commons"]=57864,["layers-arrow-down"]=58269,["ev-charger"]=57958,["user-star"]=59109,road=58677,nfc=58495,["align-center-horizontal"]=57358,["text-align-justify-end"]=59207,car=57643,["notebook-tabs"]=58500,ear=57938,videotape=59129,["sun-moon"]=58952,["chart-scatter"]=57682,podium=58610,toolbox=59026,calendar=57609,["calendar-cog"]=57617,["gallery-horizontal"]=58102,["clipboard-x"]=57778,["list-sort-ascending"]=58321,["book-open"]=57550,["circle-pile"]=57747,["rectangle-ellipsis"]=58652,["badge-plus"]=57463,["badge-info"]=57459,["file-headphone"]=58000,["bow-arrow"]=57572,["clipboard-pen-line"]=57775,["user-round-key"]=59101,["folder-search"]=58083,["utensils-crossed"]=59114,["arrow-up"]=57425,["arrow-up-from-dot"]=57430,["align-vertical-justify-start"]=57377,["layers-minus"]=58271,pause=58557,shrub=58793,flag=58043,["biceps-flexed"]=57514,["align-horizontal-distribute-end"]=57363,donut=57920,["calendar-plus-2"]=57625,["move-vertical"]=58483,["file-pen-line"]=58011,["badge-russian-ruble"]=57466,radius=58637,pilcrow=58587,["corner-left-up"]=57858,["georgian-lari"]=58115,cable=57604,["book-user"]=57559,["square-arrow-down"]=58839,["circle-plus"]=57749,view=59130,cctv=57659,["circle-arrow-left"]=57716,["square-off"]=58888,["octagon-alert"]=58507,["panel-bottom-dashed"]=58531,["book-a"]=57536,["align-end-vertical"]=57361,["thumbs-up"]=59007,globe=58139,rabbit=58629,["layers-plus"]=58272,["door-stairwell"]=57925,["banknote-arrow-down"]=57477,["message-square-off"]=58408,["dice-4"]=57904,["message-circle-x"]=58398,["folder-x"]=58089,["message-circle-warning"]=58397,map=58358,move=58470,["zoom-out"]=59200,["zoom-in"]=59199,["arrow-up-left"]=57432,award=57447,["zodiac-virgo"]=59198,["layout-panel-top"]=58280,["file-check"]=57990,["list-music"]=58317,["arrow-down-wide-narrow"]=57415,["unfold-horizontal"]=59077,["lens-concave"]=58285,["zodiac-pisces"]=59194,stone=58942,motorbike=58456,["music-4"]=58487,["wind-arrow-up"]=59209,["shield-x"]=58777,["file-volume"]=58031,["disc-3"]=57911,["file-signal"]=58019,["columns-4"]=57832,["archive-x"]=57394,["zodiac-libra"]=59192,["square-dashed-kanban"]=58869,["mouse-pointer-2"]=58463,["clock-arrow-up"]=57796,["clock-fading"]=57798,["pencil-sparkles"]=58568,["zodiac-leo"]=59191,vegan=59121,["star-plus"]=58929,["zodiac-gemini"]=59190,["clef-bass"]=57765,["message-circle-plus"]=58394,popsicle=58614,["credit-card-plus"]=57868,["square-chevron-left"]=58862,["fast-forward"]=57974,["user-pen"]=59094,["chess-knight"]=57691,["wifi-pen"]=59171,files=58034,["send-to-back"]=58746,["alarm-clock"]=57352,["zodiac-aries"]=59187,["zodiac-aquarius"]=59186,receipt=58641,wifi=59166,["shopping-basket"]=58783,send=58744,["x-line-top"]=59183,["solar-panel"]=58819,["shelving-unit"]=58761,worm=59179,workflow=59178,["wine-off"]=59177,["germ-off"]=58117,["brush-cleaning"]=57594,["skip-back"]=58805,wine=59176,["book-audio"]=57538,["wind-arrow-down"]=59175,["file-scan"]=58016,cupcake=57878,["midi-port"]=58427,["message-square-dashed"]=58402,["tic-tac-toe"]=59008,euro=57957,["chevrons-left"]=57703,["wifi-sync"]=59172,umbrella=59071,["skip-forward"]=58806,["clipboard-copy"]=57770,["map-pin-off"]=58366,["arrow-up-from-line"]=57431,["circle-chevron-up"]=57728,magnet=58343,["wifi-high"]=59168,["circle-small"]=57755,["align-vertical-space-between"]=57379,["lamp-desk"]=58253,["circle-arrow-up"]=57722,zap=59184,beaker=57492,["sun-dim"]=58950,whistle=59164,["wheat-off"]=59163,paintbrush=58525,wheat=59162,broccoli=57590,["weight-tilde"]=59161,weight=59160,["chevron-up"]=57700,["send-horizontal"]=58745,["flask-conical-off"]=58052,["pen-tool"]=58563,["database-check"]=57886,["webcam-off"]=59157,form=58093,["pencil-ruler"]=58567,dna=57914,["arrow-big-down-dash"]=57397,["chart-area"]=57661,["bug-off"]=57597,webcam=59156,waypoints=59155,["card-sim"]=57648,["waves-vertical"]=59154,["waves-ladder"]=59153,["map-pin-search"]=58370,["waves-horizontal"]=59152,["eye-dashed"]=57963,save=58709,ellipse=57947,["spell-check"]=58827,["waves-arrow-down"]=59150,watch=59149,popcorn=58613,blocks=57525,["washing-machine"]=59148,["layer-arrow-up"]=58266,microchip=58424,heart=58192,["badge-minus"]=57461,["cloud-sun"]=57817,circle=57713,["shield-alert"]=58763,["wand-sparkles"]=59146,utensils=59113,["map-minus"]=58359,wallpaper=59144,["wallet-minimal"]=59143,["separator-vertical"]=58748,["wallet-cards"]=59142,wallet=59141,["scan-square"]=58727,ampersands=57382,vote=59140,["user-search"]=59107,["volume-off"]=59138,fence=57977,["rows-3"]=58697,["square-user-round"]=58914,["volume-1"]=59136,volume=59135,sunrise=58954,strikethrough=58946,["calendar-days"]=57618,["folder-bookmark"]=58061,volleyball=59134,["banknote-arrow-up"]=57478,["layout-arrow-right"]=58274,["clock-arrow-right"]=57795,["dollar-sign"]=57918,["message-square-quote"]=58410,virus=59131,tag=58974,video=59127,["list-minus"]=58316,["cloud-hail"]=57809,["package-plus"]=58520,["eye-closed"]=57962,["app-window-mac"]=57390,vibrate=59125,ellipsis=57948,["copy-check"]=57848,["venus-and-mars"]=59124,satellite=58706,["bookmark-plus"]=57565,pentagon=58569,["folder-key"]=58074,coffee=57826,["circle-power"]=57751,logs=58340,hourglass=58208,["tickets-plane"]=59017,["folder-git"]=58069,["vector-polygon"]=59119,bomb=57532,["layers-2"]=58268,["battery-full"]=57487,vault=59118,["line-dot-bottom-vertical"]=58295,["chart-gantt"]=57673,["folder-tree"]=58087,command=57834,["badge-dollar-sign"]=57456,["align-start-vertical"]=57371,["briefcase-conveyor-belt"]=57586,["message-circle-question-mark"]=58395,["badge-x"]=57469,["bluetooth-off"]=57528,van=59116,["square-square"]=58907,cannabis=57639,["equal-approximately-not"]=57953,book=57535,["grip-horizontal"]=58156,["circle-minus"]=57741,["audio-waveform"]=57446,["moon-star"]=58452,["arrow-down-narrow-wide"]=57410,["maximize-2"]=58379,["database-backup"]=57885,wand=59145,["receipt-turkish-lira"]=58650,["users-round"]=59112,["calendar-minus-2"]=57622,["copy-minus"]=57849,users=59111,["folder-input"]=58072,["book-image"]=57546,["user-x"]=59110,["mouse-left"]=58460,["tag-plus"]=58975,shirt=58781,percent=58570,["server-off"]=58752,["move-up"]=58480,["user-round-x"]=59106,["user-round-search"]=59105,["plug-2"]=58606,crosshair=57874,["chess-rook"]=57694,brackets=57576,["calendar-heart"]=57620,["list-ordered"]=58318,["image-plus"]=58226,["star-x"]=58930,["mic-off"]=58421,["user-round-group"]=59100,["arrow-big-left"]=57398,["square-split-horizontal"]=58905,["user-round-cog"]=59099,["user-round-check"]=59098,clover=57822,["sun-snow"]=58953,sofa=58818,["user-round-arrow-left"]=59097,computer=57837,["funnel-x"]=58100,["user-minus"]=59093,["clock-2"]=57784,["calendar-fold"]=57619,["fish-off"]=58039,baby=57450,["database-x"]=57890,["fold-vertical"]=58058,["user-lock"]=59092,hop=58204,["face-angry"]=57965,["user-key"]=59091,cigarette=57711,["calendar-chevrons-right"]=57615,["user-group"]=59090,["user-cog"]=59089,["diamond-plus"]=57900,["server-cog"]=58750,["file-chart-column"]=57986,["triangle-dashed"]=59055,["git-pull-request-closed"]=58133,["badge-check"]=57455,user=59087,["usb-c-port"]=59086,["layers-arrow-up"]=58270,["plug-zap"]=58607,["heading-4"]=58186,["chess-queen"]=57693,["graduation-cap"]=58147,["grid-3x2"]=58153,["zodiac-sagittarius"]=59195,["square-dashed-x-corner"]=58875,["square-dashed-bottom-code"]=58868,["clock-7"]=57789,["ethernet-port"]=57956,["scan-text"]=58728,upload=59084,["shower-head"]=58788,["equal-not"]=57954,unplug=59083,["move-down"]=58474,["clock-arrow-down"]=57793,["ticket-slash"]=59014,ruler=58700,locate=58331,unlink=59081,["circle-user-round"]=57759,university=59080,ungroup=59079,["list-filter"]=58312,["map-pin-check"]=58361,["egg-off"]=57945,["unfold-vertical"]=59078,cog=57827,dog=57917,["ice-cream-bowl"]=58217,swords=58961,spotlight=58834,["panel-right-dashed"]=58540,["undo-2"]=59075,["paper-bag"]=58550,["truck-electric"]=59061,undo=59074,["check-line"]=57686,underline=59073,bubbles=57595,bot=57568,["chart-bar-increasing"]=57665,["umbrella-off"]=59072,["playing-card"]=58602,["air-vent"]=57350,["type-outline"]=59070,dot=57926,["flask-round"]=58053,mouth=58468,["armenian-dram"]=59201,["clipboard-paste"]=57773,["chevron-last"]=57697,["book-heart"]=57545,paperclip=58551,["circle-parking"]=57743,["globe-check"]=58140,["cloud-check"]=57804,["panel-left"]=58533,["circle-chevron-right"]=57727,["case-lower"]=57652,fan=57973,["squares-unite"]=58919,["arrow-down-up"]=57414,["git-fork"]=58127,forward=58094,["brain-circuit"]=57578,["between-vertical-start"]=57513,database=57882,["panel-right"]=58538,["fingerprint-pattern"]=58036,turntable=59064,["turkish-lira"]=59063,["log-out"]=58339,["git-branch-plus"]=58122,["clipboard-minus"]=57772,["file-text"]=58025,["tube-lotion"]=59062,truck=59060,trophy=59059,["table-rows-split"]=58970,["milk-off"]=58430,["tv-minimal"]=59067,["cloud-upload"]=57820,banknote=57476,["triangles-centerline-dashed-horizontal"]=59057,["message-circle-dashed-check"]=58390,drumstick=57936,["folder-closed"]=58064,["calendar-search"]=57627,["triangle-alert"]=59054,["line-dot-top-vertical"]=58298,["bell-ring"]=57509,["circle-chevron-left"]=57726,triangle=59053,["arrow-down"]=57404,["arrow-up-down"]=57429,["folder-dot"]=58067,["tree-deciduous"]=59046,["trending-up"]=59051,["whole-word"]=59165,monitor=58436,["disc-2"]=57910,["trending-up-down"]=59052,["square-asterisk"]=58853,["user-shield"]=59108,transgender=59043,["tv-minimal-play"]=59068,["circle-stop"]=57757,["align-vertical-space-around"]=57378,["chess-bishop"]=57689,["train-front-tunnel"]=59040,["train-front"]=59039,["arrow-big-down"]=57396,["circle-parking-off"]=57744,["calendar-x-2"]=57630,["user-plus"]=59095,["move-diagonal-2"]=58473,bandage=57474,["gallery-horizontal-end"]=58103,["panel-top-dashed"]=58545,["traffic-cone"]=59037,tractor=59036,["tram-front"]=59042,["tower-control"]=59034,plug=58605,["touchpad-off"]=59032,["audio-lines"]=57443,touchpad=59031,torus=59030,tornado=59029,["toothbrush-sparkles"]=59028,rocket=58680,toothbrush=59027,["ear-off"]=57939,["tool-case"]=59025,["save-check"]=58711,toilet=59024,["squares-exclude"]=58916,printer=58619,["megaphone-off"]=58382,["toggle-left"]=59022,["arrow-big-right"]=57400,section=58743,["file-clock"]=57992,["timer-reset"]=59021,["toy-brick"]=59035,["square-chevron-down"]=58861,["dice-1"]=57901,drill=57930,["app-window"]=57389,["robot-vacuum"]=58679,["hand-metal"]=58169,timer=59019,["spell-check-2"]=58828,timeline=59018,["ticket-x"]=59015,["list-plus"]=58319,["sport-shoe"]=58833,["rotate-ccw-key"]=58687,["ticket-minus"]=59011,["chart-pie"]=57681,replace=58671,["message-circle-off"]=58393,["copy-slash"]=57851,wind=59174,["move-down-left"]=58475,["layout-panel-left"]=58279,["thermometer-sun"]=59005,["circle-percent"]=57746,["thermometer-snowflake"]=59004,["circle-arrow-out-down-right"]=57718,["square-x"]=58915,italic=58236,["chart-column-increasing"]=57671,thermometer=59003,["step-forward"]=58932,theater=59002,["a-arrow-down"]=57344,["broom-sparkles"]=57592,sticker=58934,["lock-keyhole-open"]=58336,["text-quote"]=58999,newspaper=58494,["text-cursor-input"]=58997,["text-cursor"]=58996,["heart-pulse"]=58198,import=58230,["badge-turkish-lira"]=57468,["square-terminal"]=58911,["file-music"]=58008,["text-align-justify-center"]=59206,beef=57498,faucet=57975,["file-user"]=58029,["text-align-justify"]=58994,["square-radical"]=58899,["text-align-end"]=58993,["image-upscale"]=58228,["book-type"]=57556,["text-align-center"]=58992,["signpost-big"]=58803,["test-tubes"]=58991,cloudy=57821,["test-tube-diagonal"]=58990,["rugby-ball"]=59205,["brick-wall-fire"]=57581,["navigation-off"]=58491,["arrow-left"]=57417,["car-taxi-front"]=57646,["square-scissors"]=58901,["mouth-off"]=58469,["chevrons-right-left"]=57707,tent=58986,telescope=58985,["house-wifi"]=58215,tangent=58983,["saudi-riyal"]=58708,leaf=58282,["square-dimensions"]=58876,["face-slightly-smiling"]=57970,["align-end-horizontal"]=57360,["layer-arrow-down"]=58265,equal=57951,megaphone=58381,["calendar-x"]=57629,["tally-3"]=58980,["table-of-contents"]=58968,egg=57943,["tally-1"]=58978,["rotate-cw-clock"]=58690,["ship-cargo"]=58779,["circle-pound-sterling"]=57750,["video-off"]=59128,["japanese-yen"]=58240,tablets=58973,["tablet-smartphone"]=58972,["refresh-cw-off"]=58663,library=58288,["file-terminal"]=58024,["circle-chevron-down"]=57725,accessibility=57347,["table-properties"]=58969,["square-library"]=58883,amphora=57383,["hourglass-cog"]=58209,["tally-2"]=58979,["table-columns-split"]=58967,["table-cells-merge"]=58965,["building-complex"]=57600,["table-2"]=58964,sheet=58759,["circle-check-big"]=57724,table=58963,syringe=58962,["map-pinned"]=58373,["corner-down-left"]=57855,["circuit-board"]=57761,["power-off"]=58617,["switch-camera"]=58959,["swiss-franc"]=58958,["shield-lock"]=58771,["folder-open-dot"]=58078,["book-dashed"]=57542,sunset=58955,["sun-medium"]=58951,bluetooth=57526,["tree-pine"]=59048,["receipt-indian-rupee"]=58644,["rotate-ccw-clock"]=58686,["mic-audio-lines"]=58420,subscript=58947,["stretch-vertical"]=58945,["stretch-horizontal"]=58944,["can-soda"]=57635,["flask-conical"]=58051,hotel=58207,funnel=58098,["square-star"]=58909,["folder-sync"]=58086,["monitor-pc"]=58444,["zodiac-ophiuchus"]=59193,headset=58191,["sticky-note-x"]=58940,["arrow-up-narrow-wide"]=57433,["fishing-hook"]=58041,["chart-no-axes-column-increasing"]=57678,["equal-approximately"]=57952,["gap-horizontal"]=58110,frame=58095,["calendar-arrow-down"]=57611,["clock-12"]=57783,["star-minus"]=58927,["sticky-note-check"]=58936,["sticky-note"]=58935,images=58229,lollipop=58341,["book-text"]=57555,stethoscope=58933,["lamp-floor"]=58254,["file-plus-corner"]=58014,image=58221,["step-back"]=58931,["badge-euro"]=57457,bike=57515,angle=57385,["star-off"]=58928,refrigerator=58664,star=58924,stamp=58923,squirrel=58922,["file-video-camera"]=58030,option=58512,["banknote-check"]=57479,["scroll-text"]=58736,["server-plus"]=58753,squircle=58920,["search-alert"]=58738,["repeat"]=58667,["toggle-right"]=59023,["square-user"]=58913,["ferris-wheel"]=57978,["camera-off"]=57633,["square-text"]=58912,["case-sensitive"]=57653,["square-stack"]=58908,["square-split-vertical"]=58906,["soap-dispenser-droplet"]=58817,group=58158,["square-slash"]=58903,battery=57485,rewind=58675,["tent-tree"]=58987,["square-round-corner"]=58900,["rectangle-horizontal"]=58654,["iv-bag"]=58239,["square-plus"]=58897,["square-play"]=58896,bitcoin=57521,["square-pilcrow"]=58895,["battery-plus"]=57490,["database-search"]=57889,["square-pi"]=58894,["file-diff"]=57996,["square-percent"]=58893,["message-square-lock"]=58406,["square-pause"]=58891,["spline-pointer"]=58830,ligature=58291,["axis-3d"]=57449,["square-parking"]=58889,piano=58582,binoculars=57517,["square-m"]=58884,["square-kanban"]=58882,["square-function"]=58881,rose=58683,["land-plot"]=58257,["mail-minus"]=58348,["square-equal"]=58879,["square-dot"]=58878,["square-divide"]=58877,["nut-off"]=58505,["clipboard-pen"]=57774,["bottle-wine"]=57571,["alarm-clock-off"]=57355,["shield-question-mark"]=58775,list=58304,["monitor-pause"]=58443,["square-arrow-right"]=58847,dome=57919,["badge-pound-sterling"]=57464,["bookmark-check"]=57562,["sliders-horizontal"]=58810,["wrench-off"]=59181,["square-dashed-bottom"]=58867,["a-arrow-up"]=57345,["clock-check"]=57797,["square-code"]=58865,["square-chevron-up"]=58864,["vibrate-off"]=59126,["face-grinning"]=57967,["zodiac-cancer"]=59188,ratio=58640,["file-code"]=57993,["sliders-vertical"]=58811,["carton-off"]=57651,["credit-card-reader"]=57869,["square-chart-gantt"]=58858,["cassette-tape"]=57655,["battery-low"]=57488,["square-centerline-dashed-vertical"]=58857,["square-bottom-dashed-scissors"]=58855,signpost=58802,["square-bookmark"]=58854,["calendar-arrow-up"]=57612,landmark=58258,["fish-symbol"]=58040,["trash-off"]=59045,loader=58328,bold=57530,["dice-2"]=57902,["file-type"]=58026,["clipboard-clock"]=57769,beer=57500,lectern=58284,["square-arrow-up-right"]=58852,router=58695,["phone-incoming"]=58577,binary=57516,["move-diagonal"]=58472,["square-arrow-right-exit"]=58849,["door-closed"]=57921,["square-arrow-right-enter"]=58848,["layout-template"]=58281,["square-arrow-out-up-right"]=58846,["square-arrow-out-up-left"]=58845,["monitor-off"]=58442,["bookmark-off"]=57564,["hand-heart"]=58167,["square-arrow-out-down-left"]=58843,["scan-qr-code"]=58725,["message-square-check"]=58400,["search-x"]=58742,["square-arrow-down-right"]=58841,["gamepad-directional"]=58109,brain=57577,["monitor-up"]=58449,square=58837,sprout=58836,key=58244,["clock-11"]=57782,["spray-can"]=58835,["ticket-plus"]=59013,["arrow-up-0-1"]=57426,["bell-electric"]=57505,["shield-keyhole"]=58770,heading=58182,["book-open-check"]=57551,["panel-top-close"]=58544,["lasso-select"]=58264,["screen-share-off"]=58734,caravan=57647,speech=58826,speaker=58825,bus=57602,sparkles=58824,["audio-lines-x"]=57445,["chart-no-axes-gantt"]=57680,["file-spreadsheet"]=58021,sparkle=58823,["clipboard-list"]=57771,spade=58822,["contact-round"]=57842,["file-play"]=58012,["keyboard-off"]=58249,soup=58820,["file-badge"]=57982,["battery-warning"]=57491,["mail-question-mark"]=58352,["arrow-down-from-line"]=57408,briefcase=57584,biohazard=57518,["rectangle-circle"]=58651,braces=57575,["scale-3d"]=58716,["panel-top-bottom-dashed"]=58543,["mail-x"]=58355,["square-dashed-mouse-pointer"]=58870,["square-sparkles"]=58904,["lock-open"]=58337,snowflake=58816,pizza=58595,["list-indent-decrease"]=58314,["arrow-up-wide-narrow"]=57436,snail=58815,["clock-5"]=57787,["smartphone-nfc"]=58814,["rotate-ccw"]=58685,["align-horizontal-justify-center"]=57365,["chevrons-down"]=57701,antenna=57386,["memory-stick"]=58383,["scan-eye"]=58721,smartphone=58812,["square-check"]=58859,["heart-plus"]=58197,["door-closed-cog"]=59202,["map-pin-minus-inside"]=58365,["git-merge"]=58129,["gallery-vertical-end"]=58106,["square-dashed-plus"]=58871,["hand-coins"]=58164,["zodiac-capricorn"]=59189,["wifi-low"]=59169,skull=58807,clock=57779,["file-pen"]=58010,["git-compare-arrows"]=58126,["cloud-sun-rain"]=57818,["align-horizontal-justify-start"]=57367,siren=58804,signature=58801,["signal-zero"]=58800,["calendar-plus"]=57624,["signal-medium"]=58799,["arrow-down-z-a"]=57416,bath=57484,["signal-low"]=58798,["unlink-2"]=59082,sigma=58795,["shopping-cart-minus"]=58785,["folder-check"]=58062,shuffle=58794,["book-key"]=57547,ribbon=58676,microwave=58426,shrink=58792,["gallery-vertical"]=58105,shrimp=58790,["hard-drive-download"]=58174,["square-dashed-text"]=58872,["map-pin-pen"]=58367,["move-up-left"]=58481,["shopping-cart-plus"]=58786,["folder-heart"]=58071,orbit=58513,["shopping-bag"]=58782,["ship-wheel"]=58780,["arrow-up-a-z"]=57428,["shield-user"]=58776,["square-dashed-top-solid"]=58873,["shield-plus"]=58774,["shield-off"]=58773,["git-pull-request-create"]=58134,["swatch-book"]=58957,["receipt-cent"]=58642,spool=58832,["folder-archive"]=58060,["folder-symlink"]=58085,can=57634,ban=57472,["message-square-x"]=58415,["paint-roller"]=58524,["shield-half"]=58769,archive=57392,["shield-cog-corner"]=58767,["shield-cog"]=58766,["shield-check"]=58765,["circle-slash-2"]=57754,["shield-ban"]=58764,cake=57606,["cloud-rain"]=57814,["chart-bar"]=57662,shield=58762,wrench=59180,shell=58760,gamepad=58107,share=58757,["flag-triangle-right"]=58046,shapes=58756,["settings-2"]=58755,bell=57502,settings=58754,["server-crash"]=58751,["music-3"]=58486,["chart-bar-big"]=57663,["user-check"]=59088,proportions=58624,server=58749,plane=58596,["webhook-off"]=59159,carrot=57649,["square-arrow-left"]=58842,["file-cog"]=57995,["circle-dashed"]=57729,["search-slash"]=58741,["search-code"]=58740,dices=57907,germ=58116,["squares-subtract"]=58918,search=58737,scroll=58735,split=58831,["list-sort-descending"]=58322,["screen-share"]=58733,forklift=58092,lightbulb=58292,["alarm-clock-minus"]=57354,["heart-x"]=58199,eraser=57955,["square-sigma"]=58902,school=58729,["bluetooth-connected"]=57527,["rotate-ccw-square"]=58688,["chart-no-axes-column"]=57676,["cannabis-off"]=57640,["folder-kanban"]=58073,["scan-search"]=58726,["mars-stroke"]=58376,["phone-off"]=58579,["messages-circle"]=58416,["scan-face"]=58722,["file-box"]=57983,["scan-box"]=58720,["paint-bucket"]=58523,["glass-water"]=58137,["scan-barcode"]=58719,glasses=58138,["piggy-bank"]=58586,scan=58718,cuboid=57876,["cloud-off"]=57813,["check-check"]=57685,activity=57348,axe=57448,["plane-takeoff"]=58598,["pin-off"]=58593,["cloud-rain-wind"]=57815,["save-plus"]=58714,gem=58114,["copy-x"]=57852,["file-axis-3d"]=57981,radical=58632,["chart-column-decreasing"]=57670,["save-off"]=58712,["bug-play"]=57598,["align-vertical-distribute-start"]=57374,["file-braces"]=57984,["waves-arrow-up"]=59151,["tally-5"]=58982,["satellite-dish"]=58707,sandwich=58705,salad=58704,["circle-divide"]=57731,sailboat=58703,["rows-2"]=58696,["ruler-dimension-line"]=58701,["life-buoy"]=58290,["external-link"]=57960,["rows-4"]=58698,["volume-2"]=59137,["battery-charging"]=57486,["russian-ruble"]=58702,["square-arrow-up-left"]=58851,["brick-wall-shield"]=57582,footprints=58091,["route-off"]=58694,building=57599,route=58693,["fire-extinguisher"]=58037,["rotate-cw-fading-clock"]=58691,["tag-x"]=58976,["book-alert"]=57537,["link-2"]=58302,astroid=57440,["bell-minus"]=57506,["image-up"]=58227,["closed-caption"]=57800,drum=57935,["arrow-up-z-a"]=57437,sun=58949,["rotate-3d"]=58684,["roller-coaster"]=58682,["file-key"]=58004,["database-arrow-down"]=57883,["robot-arm"]=58678,["scissors-line-dashed"]=58731,layers=58267,reply=58673,["replace-all"]=58672,["ticket-check"]=59010,combine=57833,["repeat-off"]=58670,["repeat-2"]=58669,mountain=58457,mars=58375,["picture-in-picture-2"]=58585,["radio-off"]=58634,["flower-2"]=58055,["repeat-1"]=58668,["squares-intersect"]=58917,["remove-formatting"]=58666,regex=58665,["keyboard-music"]=58248,["star-half"]=58926,["playing-cards-fan"]=58604,["code-xml"]=57825,["pencil-line"]=58565,mails=58357,["brain-cog"]=57579,tablet=58971,["refresh-cw"]=58662,pi=58581,trash=59044,["book-down"]=57543,["hdmi-port"]=58181,trailer=59038,["case-upper"]=57654,["circle-fading-arrow-up"]=57738,["pilcrow-left"]=58588,croissant=57871,redo=58657,["circle-arrow-right"]=57721,barcode=57481,["rectangle-vertical"]=58655,["rectangle-goggles"]=58653,bed=57495,["git-merge-conflict"]=58130,divide=57913,grape=58148,["receipt-swiss-franc"]=58648,["party-popper"]=58556,["file-chart-pie"]=57989,["receipt-russian-ruble"]=58647,["list-indent-increase"]=58315,["dice-6"]=57906,["receipt-japanese-yen"]=58645,blender=57523,["receipt-euro"]=58643,["zap-off"]=59185,["square-check-big"]=58860,rat=58639,rainbow=58638,["octagon-pause"]=58509,["laptop-minimal"]=58261,["radio-receiver"]=58635,radio=58633,["map-pin-minus"]=58364,radiation=58631,["chart-spline"]=57683,["message-square-more"]=58407,radar=58630,["chart-candlestick"]=57667,quote=58628,["arrow-down-a-z"]=57407,pyramid=58626,puzzle=58625,["move-horizontal"]=58477,["file-sliders"]=58020,projector=58623,["square-exclamation-point"]=58880,["cup-soda"]=57877,["printer-check"]=58621,["map-pin-plus"]=58368,sword=58960,power=58616,["pound-sterling"]=58615,earth=57940,slice=58809,["dice-3"]=57903,milk=58429,["mouse-pointer-ban"]=58465,crown=57875,["circle-slash"]=57753,["circle-star"]=57756,["rotate-cw-square"]=58692,atom=57442,["package-x"]=58522,["bed-double"]=57496,["layout-dashboard"]=58275,["circle-dot"]=57733,["file-exclamation-point"]=57999,["hand-fist"]=58165,["message-circle-code"]=58388,["folder-git-2"]=58070,["message-square-code"]=58401,plus=58608,["towel-rack"]=59033,["playing-cards"]=58603,["arrow-big-left-dash"]=57399,["play-off"]=58601,dumbbell=57937,play=58600,["plane-landing"]=58597,houses=58216,scale=58715,pin=58592,flashlight=58049,["panel-top-open"]=58546,pill=58590,mailbox=58356,notebook=58497,["redo-2"]=58658,pickaxe=58583,["square-menu"]=58885,["chevrons-left-right"]=57704,["monitor-smartphone"]=58446,laptop=58260,["scan-line"]=58724,["clock-4"]=57786,["square-arrow-up"]=58850,["book-minus"]=57549,["file-question-mark"]=58015,["phone-forwarded"]=58576,phone=58574,["save-pen"]=58713,["arrow-down-to-line"]=57413,phi=58572,["refresh-ccw"]=58660,["venetian-mask"]=59122,["calendar-check-2"]=57614,["pencil-off"]=58566,spline=58829,["banknote-x"]=57480,["git-pull-request-create-arrow"]=58135,["pen-off"]=58562,["circle-check"]=57723,["pen-line"]=58561,hand=58163,["pc-case"]=58559,["paw-print"]=58558,["bed-single"]=57497,parasol=58552,["timer-off"]=59020,["arrow-big-right-dash"]=57401,["calendar-minus"]=57621,["panels-left-bottom"]=58547,["panel-top"]=58542,backpack=57451,["panel-right-open"]=58541,["panel-right-close"]=58539,["panel-left-right-dashed"]=58537,["panel-left-open"]=58536,["mic-signal"]=58422,["arrow-down-right"]=57411,["panel-left-dashed"]=58535,letters=58287,["wifi-zero"]=59173,eject=57946,["panel-bottom-close"]=58530,["panel-bottom"]=58529,["layout-grid-circles"]=59204,["image-off"]=58224,panda=58528,["move-right"]=58479,["paintbrush-vertical"]=58526,["package-search"]=58521,["square-chevron-right"]=58863,["mail-search"]=58353,["package-open"]=58519,["bone-fracture"]=57534,crop=57872,["package-2"]=58516,package=58515,origami=58514,lambda=58250,ampersand=57381,ad=57349,["shopping-cart"]=58784,["align-vertical-justify-end"]=57376,omega=58511,["alarm-smoke"]=57357,dock=57916,["file-input"]=58003,["clock-8"]=57790,["hand-grab"]=58166,["cloud-cog"]=57805,blend=57522,hd=58180,["radio-tower"]=58636,["list-tree"]=58325,droplet=57932,["octagon-minus"]=58508,eye=57961,["cloud-sync"]=57819,["square-dashed-x"]=58874,banana=57473,gpu=58146,nut=58504,["notepad-text-dashed"]=58503,["circle-equal"]=57736,["face-slightly-frowning"]=57969,["notepad-text"]=58502,["library-big"]=58289,["file-chart-column-increasing"]=57987,["text-initial"]=58998,["arrow-up-right"]=57434,network=58493,["leafy-green"]=58283,["message-square-dot"]=58404,["file-chart-line"]=57988,["columns-3-cog"]=57831,["nepali-rupee"]=58492,["navigation-2"]=58489,["minimize-2"]=58432,navigation=58488,["music-2"]=58485,cone=57839,engine=57950,["file-image"]=58002,["move-up-right"]=58482,palette=58527,barrel=57482,["gallery-thumbnails"]=58104,["move-left"]=58478,cpu=57863,["move-down-right"]=58476,["thumbs-down"]=59006,merge=58385,hamburger=58161,["move-3d"]=58471,["hat-glasses"]=58178,code=57824,mail=58344,["mouse-pointer"]=58462,["mouse-off"]=58461,["list-clock"]=58309,carton=57650,["circle-arrow-out-down-left"]=57717,kanban=58242,bone=57533,apple=57391,["rocking-chair"]=58681,["bot-off"]=57570,flower=58054,mop=58453,moon=58451,["circle-arrow-out-up-left"]=57719,["message-square-plus"]=58409,["cable-car"]=57605,["arrow-down-left"]=57409,["square-activity"]=58838,["monitor-stop"]=58448,["cigarette-off"]=57712,["monitor-speaker"]=58447,["message-circle"]=58386,["circle-arrow-out-up-right"]=57720,["car-battery"]=57644,["monitor-play"]=58445,["fold-horizontal"]=58057,shovel=58787,["calendar-1"]=57610,["cloud-moon"]=57811,["square-arrow-out-down-right"]=58844,["lock-keyhole"]=58335,["clock-plus"]=57799,["circle-euro"]=57737,["cloud-snow"]=57816,anvil=57387,["arrow-big-up-dash"]=57403,["monitor-dot"]=58440,["monitor-cog"]=58439,["monitor-check"]=58437,["link-2-off"]=58303,minus=58433,["list-chevrons-up-down"]=58308,["chevrons-down-up"]=57702,["clipboard-plus"]=57776,["circle-x"]=57760,["list-end"]=58311,milestone=58428,microscope=58425,["chevrons-right"]=57706,["audio-lines-off"]=57444,["message-square-reply"]=58411,["corner-down-right"]=57856,["mic-vocal"]=58423,summary=58948,["lamp-wall-down"]=58255,mic=58419,["layout-arrow-down"]=58273,["ellipsis-vertical"]=57949,["globe-off"]=58143,["square-stop"]=58910,["arrow-up-1-0"]=57427,["align-horizontal-justify-end"]=57366,["scan-heart"]=58723,["align-vertical-distribute-end"]=57373,["heart-crack"]=58193,airplay=57351,["message-square-warning"]=58414,["message-square-text"]=58413,["message-square-share"]=58412,["monitor-x"]=58450,["bell-check"]=57503,["database-minus"]=57887,["square-pen"]=58892,["message-square-heart"]=58405,["message-square-diff"]=58403,["dice-5"]=57905,octagon=58506,ticket=59009,["message-circle-heart"]=58391,["message-circle-dashed"]=58389,["briefcase-plus"]=57588,bookmark=57561,["message-circle-check"]=58387,["utility-pole"]=59115,maximize=58378,["chart-bar-decreasing"]=57664,["database-plus"]=57888,["calendar-sync"]=57628,["funnel-plus"]=58099,store=58943,["circle-arrow-down"]=57715,["notebook-pen"]=58499,["egg-fried"]=57944,["map-pin-x-inside"]=58372,["map-pin-x"]=58371,["corner-right-up"]=57860,["hand-platter"]=58170,["printer-3d"]=58620,["user-round-plus"]=59104,["panel-left-close"]=58534,["map-pin"]=58360,["pilcrow-right"]=58589,["user-round-minus"]=59102,["bell-off"]=57507,["mail-pen"]=58350,["mail-plus"]=58351,["mail-clock"]=58347,["mail-check"]=58346,["mail-badge"]=58345,["mouse-pointer-2-off"]=58464,drone=57931,slash=58808,["credit-card-x"]=57870,aperture=57388,["arrow-right-left"]=57423,["circle-alert"]=57714,["vector-square"]=59120,["circle-gauge"]=57740,["log-in"]=58338,check=57684,["text-search"]=59000,["arrow-down-to-dot"]=57412,["monitor-down"]=58441,lock=58334,["chef-hat"]=57687,calculator=57608,["locate-fixed"]=58332,["file-archive"]=57980,["signal-high"]=58797,inbox=58231,["loader-pinwheel"]=58330,["loader-circle"]=58329,["image-play"]=58225,["align-horizontal-space-between"]=57369,["corner-right-down"]=57859,["calendar-check"]=57613,["database-zap"]=57891,droplets=57934,["list-video"]=58326,broom=57591,bird=57519,["layout-list"]=58278,["file-search"]=58017,["lamp-ceiling"]=58252,["alarm-clock-plus"]=57356,["circle-dollar-sign"]=57732,usb=59085,house=58210,["receipt-pound-sterling"]=58646,["house-plug"]=58213,["list-collapse"]=58310,["id-card"]=58219,mouse=58459,minimize=58431,["list-chevrons-down-up"]=58307,["list-checks"]=58306,galaxy=58101,["list-check"]=58305,["book-x"]=57560,["mirror-rectangular"]=58434,link=58301,["line-style"]=58300,["line-squiggle"]=58299,["headphone-off"]=58189,asterisk=57439,["line-dot-right-horizontal"]=58297,["octagon-x"]=58510,languages=58259,lighthouse=58294,["alarm-clock-check"]=57353,guitar=58159,["calendar-range"]=57626,["beer-off"]=57501,scooter=58732,["square-parking-off"]=58890,["notebook-text"]=58501,["arrow-right-to-line"]=57424,["clef-treble"]=57766,["tally-4"]=58981,["zodiac-taurus"]=59197,["layout-grid"]=58277,["door-open"]=57924,["flag-triangle-left"]=58045,["grid-3x3"]=58154,file=57979,["layout-freeform"]=58276,["pocket-knife"]=58609,["book-copy"]=57541,castle=57657,["car-front"]=57645,["clock-alert"]=57792,["reply-all"]=58674,["cloud-moon-rain"]=57812,["clipboard-type"]=57777,lasso=58263,["list-todo"]=58324,["printer-x"]=58622,["lamp-wall-up"]=58256,["list-start"]=58323,lamp=58251,["a-large-small"]=57346,keyboard=58247,["key-square"]=58246,["map-plus"]=58374,["kazakh-tenge"]=59203,kayak=58243,joystick=58241,["database-arrow-up"]=57884,["arrow-right-from-line"]=57422,["flame-kindling"]=58048,["square-power"]=58898,["iteration-cw"]=58238,["bring-to-front"]=57589,["iteration-ccw"]=58237,["inspection-panel"]=58235,["bell-plus"]=57508,info=58234,infinity=58233,["indian-rupee"]=58232,folders=58090,["mail-warning"]=58354,["image-minus"]=58223,["id-card-lanyard"]=58220,["ice-cream-cone"]=58218,bridge=57583,["chart-line"]=57674,["file-lock"]=58005,cast=57656,["circle-fading-plus"]=57739,["clock-10"]=57781,["undo-dot"]=59076,target=58984,["list-filter-plus"]=58313,["house-heart"]=58212,drama=57929,compass=57835,baseline=57483,martini=58377,contrast=57844,hospital=58206,["candy-off"]=57638,["heart-minus"]=58195,["book-check"]=57540,highlighter=58203,["book-lock"]=57548,helicopter=58201,["briefcase-medical"]=57587,calendars=57631,["text-align-start"]=58995,["heart-off"]=58196,["hop-off"]=58205,warehouse=59147,["sticky-notes"]=58941,["drafting-compass"]=57928,["save-all"]=58710,["heading-6"]=58188,["heading-5"]=58187,["heading-3"]=58185,["heading-2"]=58184,["heading-1"]=58183,["fishing-rod"]=58042,["book-headphones"]=57544,["credit-card"]=57865,haze=58179,["hard-hat"]=58176,["hard-drive-upload"]=58175,shredder=58789,["panel-bottom-open"]=58532,["door-closed-package"]=57923,handbag=58171,["credit-card-check"]=57866,balloon=57471,["map-pin-plus-inside"]=58369,["bookmark-x"]=57566,["badge-question-mark"]=57465,pen=58560,hammer=58162,["candy-cane"]=57637,grip=58155,["file-symlink"]=58023,["gamepad-2"]=58108,["grid-2x2-check"]=58150,["grid-2x2"]=58149,["globe-x"]=58144,["git-pull-request-draft"]=58136,["shield-minus"]=58772,["circle-off"]=57742,dessert=57895,eclipse=57942,church=57710,["columns-3"]=57830,cylinder=57880,["badge-japanese-yen"]=57460,["file-x"]=58032,["receipt-text"]=58649,["git-compare"]=58125,["git-commit-vertical"]=58124,["git-commit-horizontal"]=58123,["circle-ellipsis"]=57735,["file-output"]=58009,["disc-album"]=57912,["git-branch"]=58120,["arrow-down-0-1"]=57405,captions=57641,gift=58119,ghost=58118,["philippine-peso"]=58573,["badge-alert"]=57453,gauge=58112,["folder-pen"]=58080,cross=57873,["gap-vertical"]=58111,["chevron-right"]=57699,["sticky-note-minus"]=58937,["square-arrow-down-left"]=58840,["share-2"]=58758,fullscreen=58097,fuel=58096,["folder-up"]=58088,["folder-search-2"]=58084,["folder-root"]=58082,["folder-open"]=58077,["chess-pawn"]=57692,["folder-minus"]=58076,["briefcase-business"]=57585,["folder-lock"]=58075,["message-circle-reply"]=58396,["folder-cog"]=58066,["triangle-right"]=59056,["folder-clock"]=58063,folder=58059,["mop-sparkles"]=58454,type=59069,webhook=59158,["flashlight-off"]=58050,["align-horizontal-distribute-start"]=57364,["flag-off"]=58044,fish=58038,["pointer-off"]=58612,turtle=59065,camera=57632,film=58035,["file-x-corner"]=58033,["git-pull-request"]=58131,["bluetooth-searching"]=57529,["arrow-up-to-line"]=57435,["squircle-dashed"]=58921,["clock-3"]=57785,["badge-percent"]=57462,["face-expressionless"]=57966,["file-up"]=58028,["file-type-corner"]=58027,["grid-2x2-plus"]=58151,["file-stack"]=58022,box=57573,["file-search-corner"]=58018,["clock-1"]=57780,["file-heart"]=58001,["house-cog"]=58211,space=58821,["file-minus-corner"]=58007,["file-minus"]=58006,["file-digit"]=57997,["corner-up-left"]=57861,["clock-6"]=57788,["zodiac-scorpio"]=59196,["key-round"]=58245,headphones=58190,tv=59066,factory=57972,["face-neutral"]=57968,rss=58699,expand=57959,["at-sign"]=57441,["map-pin-check-inside"]=58362,["sticky-note-off"]=58938,music=58484,handshake=58172,["earth-lock"]=57941,["circle-user"]=57758,["copy-plus"]=57850,["droplet-off"]=57933,["virus-off"]=59132,["line-dot-left-horizontal"]=58296,disc=57909,diff=57908,["search-check"]=58739,["clipboard-check"]=57768,["columns-2"]=57829,["diamond-minus"]=57898,clipboard=57767,["align-center-vertical"]=57359,diameter=57896,delete=57894,club=57823,["cloud-fog"]=57808,mosque=58455,currency=57879,["map-pin-house"]=58363,["package-check"]=58517,["chevron-first"]=57696,pencil=58564,boxes=57574,["list-x"]=58327,copyright=57854,copyleft=57853,["corner-up-right"]=57862,cookie=57845,["clock-arrow-left"]=57794,container=57843,contact=57841,["badge-indian-rupee"]=57458,construction=57840,["redo-dot"]=58659,component=57836,["align-start-horizontal"]=57370,["chart-column-stacked"]=57672,["file-plus"]=58013,["git-pull-request-arrow"]=58132,coins=57828,["decimals-arrow-right"]=57893,["bell-dot"]=57504,["folder-down"]=58068,["cloud-drizzle"]=57807,["cloud-backup"]=57803,["align-horizontal-space-around"]=57368,["door-closed-locked"]=57922,["clock-9"]=57791,diamond=57897,blinds=57524,clapperboard=57763,["circle-play"]=57748,["book-search"]=57554,["git-branch-minus"]=58121,["circle-dashed-check"]=57730,recycle=58656,["mountain-snow"]=58458,luggage=58342,["chevrons-left-right-ellipsis"]=57705,["bot-message-square"]=57569,["phone-outgoing"]=58580,["smartphone-charging"]=58813,["chevron-left"]=57698,["train-track"]=59041,cherry=57688,["chart-bar-stacked"]=57666,["sticky-note-plus"]=58939,["chart-no-axes-column-decreasing"]=57677,["chart-network"]=57675,["chart-column-big"]=57669,["chart-no-axes-combined"]=57679,metronome=58418,["triangles-centerline-dashed-vertical"]=59058,["arrow-down-1-0"]=57406,["credit-card-minus"]=57867,candy=57636,["arrow-left-right"]=57419,["lightbulb-off"]=58293,["panels-top-left"]=58549,["beef-off"]=57499,["locate-off"]=58333,bug=57596,["test-tube"]=58989,["brick-wall"]=57580,["cooking-pot"]=57846,["boom-box"]=57567,["book-up"]=57557,["book-plus"]=57553,["laptop-minimal-check"]=58262,["mail-open"]=58349,park=58554,["baggage-claim"]=57470,variable=59117,["arrow-right"]=57421,["archive-restore"]=57393}
local fontFace
do
	pcall(function()
		if not AssetManager.Supported then return end
		
		local ttfFile = `{ASSET_FOLDER}/lucide.ttf`
		local familyFile = `{ASSET_FOLDER}/lucide.font`

		AssetManager.EnsureFolder(ASSET_FOLDER)
		AssetManager.Download(ttfFile, `{ASSET_BASE_URL}fonts/lucide.ttf`, function(data)
			return data:sub(1, 4) == "\0\1\0\0" -- TrueType header
		end)
		AssetManager.Write(familyFile, game:GetService("HttpService"):JSONEncode({
			name = "Lucide",
			loadStrategy = "sameFamilyOnly",
			faces = {
				{ name = "Regular", weight = 400, style = "normal", assetId = AssetManager.GetAsset(ttfFile) },
			},
		}))

		fontFace = Font.new(AssetManager.GetAsset(familyFile))
	end)
end

Lucide.Icons = iconIndices
function Lucide.GetAsset(name: string)
	local size = 48

	local iconIndex = table.find(iconIndices, name)

	if not iconIndex then
		return nil
	end

	local currentDifference = math.huge
	local currentSize = size

	for registrySize, _ in iconRegistry do
		local diff = math.abs(size - registrySize)

		if diff < currentDifference then
			currentDifference = diff
			currentSize = registrySize
		end
	end

	local iconData = nil
	
	local icon = iconRegistry[currentSize][iconIndex]
	if icon then
		iconData = iconData or {}

		SafeMerge(iconData, {
			IconName = name,
			Url = idIndices[icon[1]],
			ImageRectSize = Vector2.new(icon[2][1], icon[2][2]),
			ImageRectOffset = Vector2.new(icon[3][1], icon[3][2]),
		})
	end

	local codepoint = fontCodepoints[name]
	if codepoint and fontFace then
		iconData = iconData or {}

		SafeMerge(iconData, {
			FontFace = fontFace,
			Text = name,
		})
	end

	return iconData
end

--// Font \\--
if fontFace then
	Lucide.GetFontAsset = Lucide.GetAsset
end

return Lucide
end

local FetchIcons, Icons = true, BuildBuiltinIconModule()

-- 常用别名：把习惯叫法映射到 lucide 真实图标名，避免个别名字查不到导致空白
local ICON_ALIASES = {
    grid = "grid-2x2",
    unlock = "lock-open",
    close = "x",
    gear = "settings",
    home = "house",
    trash = "trash",
    edit = "pencil",
    add = "plus",
    remove = "minus",
    reload = "refresh-cw",
    picture = "image",
    profile = "user",
    notification = "bell",
    location = "map-pin",
}

function Library:GetIcon(IconName: string): Icon?
    if not IsIconModule(Icons) or typeof(IconName) ~= "string" then
        return nil
    end

    local Alias = ICON_ALIASES[IconName]
    if Alias then
        IconName = Alias
    end

    local Success, Icon = pcall(Icons.GetAsset, IconName)
    if Success and Icon then
        return Icon
    end

    -- 名字写错时给一个通用问号图案，而不是留空白或退回符号
    local FallbackSuccess, FallbackIcon = pcall(Icons.GetAsset, "circle-question-mark")
    return if FallbackSuccess then FallbackIcon else nil
end

-- 列出库内可用的全部图标名（1866 个），方便查名字直接用
function Library:ListIcons(): { string }
    if not IsIconModule(Icons) then
        return {}
    end
    return table.clone(Icons.Icons)
end


Library._UrlAssetCache = Library._UrlAssetCache or {}
function Library:GetImageFromUrl(Url: string): string?
    if typeof(Url) ~= "string" then
        return nil
    end
    if Library._UrlAssetCache[Url] then
        return Library._UrlAssetCache[Url]
    end
    if not (getcustomasset and writefile) then
        return nil
    end

    local ext = Url:match("%.(%w%w%w%w?)$") or "png"
    local safe = Url:gsub("%W", ""):sub(-40)
    local folder = "obsidian_images"
    local path = folder .. "/" .. #Url .. "_" .. safe .. "." .. ext

    local ok = pcall(function()
        if isfolder and makefolder and not isfolder(folder) then
            makefolder(folder)
        end
        if not (isfile and isfile(path)) then
            writefile(path, game:HttpGet(Url))
        end
    end)
    if not ok then
        return nil
    end

    local ok2, asset = pcall(getcustomasset, path)
    if ok2 and typeof(asset) == "string" and asset ~= "" then
        Library._UrlAssetCache[Url] = asset
        return asset
    end
    return nil
end

function Library:GetCustomIcon(IconName: string): any
    if not IconName then
        return nil
    end

    
    if typeof(IconName) == "string" and IconName:match("^https?://") then
        local Asset = Library:GetImageFromUrl(IconName)
        if Asset then
            return {
                Url = Asset,
                ImageRectOffset = Vector2.zero,
                ImageRectSize = Vector2.zero,
                Custom = true,
            }
        end
        return nil
    end

    if tonumber(IconName) then
        IconName = string.format("rbxassetid://%s", tostring(IconName))
    end

    if IsCustomAssetIcon(IconName, true) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
        }
    elseif IsValidCustomIcon(IconName) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    end

    local LucideIcon = Library:GetIcon(IconName)
    if LucideIcon then
        return LucideIcon
    end

    return nil
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    if typeof(Table) ~= "table" then
        return Template
    end

    for k, v in Template do
        if typeof(k) == "number" then
            continue
        end

        if typeof(v) == "table" then
            Table[k] = Library:Validate(Table[k], v)
        elseif Table[k] == nil then
            Table[k] = v
        end
    end

    return Table
end


local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
    local ThemeProperties = Library.Registry[Instance] or {}

    for key, value in Table do
        if key ~= "Text" then
            local SchemeValue = GetSchemeValue(value)

            if SchemeValue or typeof(value) == "function" then
                ThemeProperties[key] = value
                value = SchemeValue or value()
            else
                ThemeProperties[key] = nil
            end
        end

        Instance[key] = value
    end

    if GetTableSize(ThemeProperties) > 0 then
        Library.Registry[Instance] = ThemeProperties
    end
end

local function New(ClassName: string, Properties: { [string]: any }): any
    local Instance = Instance.new(ClassName)

    if Templates[ClassName] then
        FillInstance(Templates[ClassName], Instance)
    end
    FillInstance(Properties, Instance)

    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function()
            Instance.ZIndex = Properties.Parent.ZIndex
        end)
    end

    return Instance
end


local IconTextProperties = { ImageColor3 = "TextColor3", ImageTransparency = "TextTransparency" }
local IconSharedProperties = { "Name", "AnchorPoint", "Position", "Size", "SizeConstraint", "LayoutOrder", "ZIndex", "Visible", "Rotation", "ImageColor3", "ImageTransparency" }

local function IconProperties(ClassName: string, Properties: { [string]: any }): { [string]: any }
    if ClassName ~= "TextLabel" and ClassName ~= "TextButton" then
        return Properties
    end

    local Mapped: { [string]: any } = {}
    for Property, Value in Properties do
        Mapped[IconTextProperties[Property] or Property] = Value
    end

    return Mapped
end

local function IsFontIcon(Icon: Icon?): boolean
    return Icon ~= nil and Icon.FontFace ~= nil
end

local function ImageContent(Icon: Icon?): { [string]: any }
    return {
        Image = Icon and Icon.Url or "",
        ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
        ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
    }
end

local function SetIconProperties(Target: GuiObject, Properties: { [string]: any })
    FillInstance(IconProperties(Target.ClassName, Properties), Target)
end

local function TweenIcon(Target: GuiObject, Properties: { [string]: any }): Tween
    local Tween = TweenService:Create(Target, Library.TweenInfo, IconProperties(Target.ClassName, Properties))
    Tween:Play()

    return Tween
end

function Library:CreateIcon(Icon: Icon?, Properties: { [string]: any }?, IsButton: boolean?): GuiObject
    local IsFont = IsFontIcon(Icon)
    local ClassName = (if IsFont then "Text" else "Image") .. (if IsButton then "Button" else "Label")

    local Merged: { [string]: any } = {
        BackgroundTransparency = 1,
        ImageColor3 = Color3.new(1, 1, 1),
    }

    if not IsFont then
        Merged.ScaleType = Enum.ScaleType.Fit
    end

    if Properties then
        for Property, Value in Properties do
            Merged[Property] = Value
        end
    end

    return Library:ApplyIcon(New(ClassName, IconProperties(ClassName, Merged)), Icon)
end

function Library:ApplyIcon(Target: GuiObject, Icon: Icon?): GuiObject
    local IsFont = IsFontIcon(Icon)
    local IsText = Target:IsA("TextLabel") or Target:IsA("TextButton")

    if IsFont ~= IsText then
        local Theme = Library.Registry[Target] or {}
        local Properties: { [string]: any } = { Parent = Target.Parent }

        for _, Property in IconSharedProperties do
            local Source = if IsText then IconTextProperties[Property] or Property else Property
            Properties[Property] = if Theme[Source] ~= nil then Theme[Source] else (Target :: any)[Source]
        end

        local Replacement = Library:CreateIcon(Icon, Properties, Target:IsA("GuiButton"))
        Library:RemoveFromRegistry(Target)
        Target:Destroy()

        return Replacement
    end

    if IsFont and Icon then
        FillInstance({
            FontFace = Icon.FontFace,
            RichText = false,
            Text = Icon.Text,
            TextScaled = true,
        }, Target)

        if not Target:FindFirstChild("IconPadding") then
            New("UIPadding", {
                Name = "IconPadding",
                PaddingLeft = UDim.new(-0.5, -0.5),
                PaddingRight = UDim.new(-0.5, 0),
                Parent = Target,
            })
        end
    else
        FillInstance(ImageContent(Icon), Target)
    end

    return Target
end


function Library:ApplyLucideIcon(ImageGui: ImageLabel | ImageButton, Icon: Icon, Rotation: number?)
    warn("Obsidian:ApplyLucideIcon is deprecated, please use Obsidian:CreateIcon or Obsidian:ApplyIcon instead.")

    ImageGui.Rotation = Rotation or ImageGui.Rotation
    FillInstance(ImageContent(Icon), ImageGui)
end


local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
    local success, _error = pcall(function()
        if not Parent then
            Parent = CoreGui
        end

        local DestinationParent
        if typeof(Parent) == "function" then
            DestinationParent = Parent()
        else
            DestinationParent = Parent
        end

        Instance.Parent = DestinationParent
    end)

    if not (success and Instance.Parent) then
        Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
    if SkipHiddenUI then
        SafeParentUI(UI, CoreGui)
        return
    end

    pcall(protectgui, UI)
    SafeParentUI(UI, gethui)
end

local function SetAlwaysOnTop(Gui: ScreenGui, Enabled: boolean)
    if not Gui then
        return
    end

    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(Gui, "OnTopOfCoreBlur", Enabled)
        elseif setscriptable then
            setscriptable(Gui, "OnTopOfCoreBlur", true)
            Gui.OnTopOfCoreBlur = Enabled
            setscriptable(Gui, "OnTopOfCoreBlur", false)
        end
    end)
end

local ScreenGui = New("ScreenGui", {
    Name = RandomGuiName(),
    AutoLocalize = false,
    DisplayOrder = 998,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

ScreenGui.DescendantRemoving:Connect(function(Instance)
    task.defer(function()
        if Instance.Parent and Instance:IsDescendantOf(ScreenGui) then
            return
        end

        Library:RemoveFromRegistry(Instance)
    end)
end)

local ModalElement = New("TextButton", {
    BackgroundTransparency = 1,
    Modal = false,
    Size = UDim2.fromScale(0, 0),
    AnchorPoint = Vector2.zero,
    Text = "",
    ZIndex = -999,
    Parent = ScreenGui,
})


local Floats = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 10,
    Active = false,
    Parent = ScreenGui,
})

local Overlay = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 20,
    Active = false,
    Parent = ScreenGui,
})

Library.Floats = Floats
Library.Overlay = Overlay


local Cursor
local CursorCross
local InnerCross = {}
local CursorCustomImage
do
    Cursor = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(1, 1),
        Visible = false,
        ZIndex = 11000,
        Parent = ScreenGui,
    })

    CursorCross = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(11, 11),
        Parent = Cursor,
    })

    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 0, 0, 3),
        ZIndex = 1,
        Parent = CursorCross,
    })
    table.insert(InnerCross, New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -2, 0, 1),
        ZIndex = 2,
        Parent = CursorCross,
    }))

    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 3, 1, 0),
        ZIndex = 1,
        Parent = CursorCross,
    })
    table.insert(InnerCross, New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "WhiteColor",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 1, 1, -2),
        ZIndex = 2,
        Parent = CursorCross,
    }))

    CursorCustomImage = Library:CreateIcon(nil, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 3,
        Visible = false,
        Parent = Cursor,
    })
end

local function RestoreMouseIcon()
    pcall(function() 
        RunService:UnbindFromRenderStep(Library.ShowCursorBinding)
        RunService.RenderStepped:Wait()
    end)

    UserInputService.MouseIconEnabled = Library.OriginalMouseIconEnabled
    if Cursor then Cursor.Visible = false end
end


local NotificationArea
local NotifyOrder = {}
do
    NotificationArea = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.new(0, 300, 1, -6),
        ZIndex = 200,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = NotificationArea,
        })
    )
end


local CheckIcon, ArrowIcon, ResizeIcon, KeyIcon, MoveIcon, PopOutIcon, CloseIcon, SettingsIcon
function Library:SetIconModule(module: IconModule)
    FetchIcons = true
    Icons = module

    CheckIcon = Library:GetIcon("check")
    ArrowIcon = Library:GetIcon("chevron-up")
    ResizeIcon = Library:GetIcon("move-diagonal-2")
    KeyIcon = Library:GetIcon("key")
    MoveIcon = Library:GetIcon("move")
    PopOutIcon = Library:GetIcon("square-arrow-down-left")
    CloseIcon = Library:GetIcon("x")
    SettingsIcon = Library:GetIcon("settings")
end

-- [图案版] 图标来自 lucide 矢量图标模块
if FetchIcons and IsIconModule(Icons) then
    Library:SetIconModule(Icons)
end


Library.Cursor = {}

function Library.Cursor:ResetCross()
    for _, Inner in InnerCross do
        Library.Registry[Inner].BackgroundColor3 = "WhiteColor"
        Inner.BackgroundColor3 = Library.Scheme.WhiteColor
    end
end

function Library.Cursor:ResetIcon()
    CursorCross.Visible = true
    CursorCustomImage.Visible = false
    CursorCustomImage.Size = UDim2.fromOffset(20, 20)
    SetIconProperties(CursorCustomImage, { ImageColor3 = Color3.new(1, 1, 1) })
end

function Library.Cursor:ResetCursor()
    Library.Cursor:ResetCross()
    Library.Cursor:ResetIcon()
end

function Library.Cursor:ChangeCrossColor(Color: Color3)
    assert(typeof(Color) == "Color3", "Color3 expected.")
    for _, Inner in InnerCross do
        Inner.BackgroundColor3 = Color
        Library.Registry[Inner].BackgroundColor3 = nil
    end
end

function Library.Cursor:ChangeIcon(ImageId: string)
    if not ImageId or ImageId == "" then
        Library.Cursor:ResetIcon()
        return
    end

    local Icon = Library:GetCustomIcon(ImageId)
    assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

    CursorCross.Visible = false
    CursorCustomImage = Library:ApplyIcon(CursorCustomImage, Icon)
    CursorCustomImage.Visible = true
end

function Library.Cursor:ChangeIconColor(Color: Color3)
    assert(typeof(Color) == "Color3", "Color3 expected.")
    SetIconProperties(CursorCustomImage, { ImageColor3 = Color })
end

function Library.Cursor:ChangeIconSize(Size: UDim2)
    assert(typeof(Size) == "UDim2", "UDim2 expected.")
    CursorCustomImage.Size = Size
end


function Library:ChangeCursorCrossColor(Color: Color3)
    warn("Obsidian:ChangeCursorCrossColor is deprecated, please use Obsidian.Cursor:ChangeCrossColor instead.")
    Library.Cursor:ChangeCrossColor(Color)
end


function Library:ResetCursorCross()
    warn("Obsidian:ResetCursorCross is deprecated, please use Obsidian.Cursor:ResetCross instead.")
    Library.Cursor:ResetCross()
end


function Library:ChangeCursorIcon(ImageId: string)
    warn("Obsidian:ChangeCursorIcon is deprecated, please use Obsidian.Cursor:ChangeIcon instead.")
    Library.Cursor:ChangeIcon(ImageId)
end


function Library:ChangeCursorIconColor(Color: Color3)
    warn("Obsidian:ChangeCursorIconColor is deprecated, please use Obsidian.Cursor:ChangeIconColor instead.")
    Library.Cursor:ChangeIconColor(Color)
end


function Library:ChangeCursorIconSize(Size: UDim2)
    warn("Obsidian:ChangeCursorIconSize is deprecated, please use Obsidian.Cursor:ChangeIconSize instead.")
    Library.Cursor:ChangeIconSize(Size)
end


function Library:ResetCursorIcon()
    warn("Obsidian:ResetCursorIcon is deprecated, please use Obsidian.Cursor:ResetIcon instead.")
    Library.Cursor:ResetIcon()
end


function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * (Library.IsLightTheme and -4 or 2)
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

function Library:GetLighterColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
end

function Library:GetDarkerColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
        return string.char(KeyCode.Value)
    end

    return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
    local Scale = Library.DPIScale
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.RichText = true
    Params.Font = Font
    Params.Size = Size * Scale
    if Width then
        Params.Width = Width * Scale
    else
        Params.Width = workspace.CurrentCamera.ViewportSize.X - 32
    end

    local Bounds = TextService:GetTextBoundsAsync(Params)
    return math.ceil(Bounds.X / Scale), math.ceil(Bounds.Y / Scale)
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Mouse.X >= AbsPos.X
        and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y
        and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
    local GuiPos = Frame.AbsolutePosition
    local GuiSize = Frame.AbsoluteSize

    local FramePos = ParentFrame.AbsolutePosition
    local FrameSize = ParentFrame.AbsoluteSize

    return GuiPos.X >= FramePos.X
        and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
        and GuiPos.Y >= FramePos.Y
        and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Result = table.pack(xpcall(Func, function(Error)
        task.defer(error, debug.traceback(Error, 2))
        if Library.NotifyOnError and Library.Notify then
            Library:Notify(Error)
        end

        return Error
    end, ...))

    if not Result[1] then
        return nil
    end

    return table.unpack(Result, 2, Result.n)
end

function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
    local Pos1 = TargetPos or UI.AbsolutePosition
    local Size1 = UI.AbsoluteSize

    for _, Other in ipairs(Library.DraggableElements) do
        if Other == UI or not Other.Visible or not Other.Parent then
            continue
        end

        local Pos2 = Other.AbsolutePosition
        local Size2 = Other.AbsoluteSize

        if Pos1.X < Pos2.X + Size2.X and
            Pos1.X + Size1.X > Pos2.X and
            Pos1.Y < Pos2.Y + Size2.Y and
            Pos1.Y + Size1.Y > Pos2.Y then
            return Other
        end
    end

    return nil
end

function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
    local ScreenSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)) - Vector2.new(100, 100)
    local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
    local Padding = 6

    local CurrentX = Start.X
    local CurrentY = Start.Y

    local Size = UI.AbsoluteSize
    if Size.X == 0 and Size.Y == 0 then
        RunService.RenderStepped:Wait()
        Size = UI.AbsoluteSize
    end

    if Size.X == 0 then Size = Vector2.new(150, 40) end

    local MaxXInColumn = Size.X

    while true do
        local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
        if not Obstacle then
            break
        end

        if Obstacle.AbsoluteSize.X > MaxXInColumn then
            MaxXInColumn = Obstacle.AbsoluteSize.X
        end

        local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
        if NextY + Size.Y > ScreenSize.Y - Padding then
            local NextX = CurrentX + MaxXInColumn + Padding

            if NextX + Size.X > ScreenSize.X - Padding then
                break
            end

            CurrentY = Start.Y
            CurrentX = NextX
            MaxXInColumn = Size.X
        else
            CurrentY = NextY
        end
    end

    return UDim2.fromOffset(CurrentX, CurrentY)
end

function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
    UI.Position = GetNonOverlappingPosition(UI, StartPos)
end


local function GetCoreGuiInset(): (Vector2, Vector2)
    local Success, TopLeft, BottomRight = pcall(function()
        return GuiService:GetGuiInset()
    end)

    if Success and TopLeft and BottomRight then
        return TopLeft, BottomRight
    end

    return Vector2.zero, Vector2.zero
end

local function GetSnapEdges(ElemSize: Vector2, ViewportSize: Vector2, Margin: number, AvoidCoreGui: boolean)
    local SafeMin, SafeMax = Vector2.zero, ViewportSize

    if AvoidCoreGui then
        local TopLeftInset, BottomRightInset = GetCoreGuiInset()
        SafeMin = TopLeftInset
        SafeMax = ViewportSize - BottomRightInset
    end

    local TargetsX = {
        LeftEdge = SafeMin.X + Margin,
        Center = SafeMin.X + (SafeMax.X - SafeMin.X - ElemSize.X) / 2,
        RightEdge = SafeMax.X - ElemSize.X - Margin,
    }
    local TargetsY = {
        TopEdge = SafeMin.Y + Margin,
        Center = SafeMin.Y + (SafeMax.Y - SafeMin.Y - ElemSize.Y) / 2,
        BottomEdge = SafeMax.Y - ElemSize.Y - Margin,
    }

    return TargetsX, TargetsY
end

local function GetClosestSnapTarget(Value: number, Targets: { [string]: number }, Distance: number): (number?, string?)
    local ClosestName, ClosestValue, ClosestDist = nil, nil, Distance

    for Name, Target in Targets do
        local Dist = math.abs(Value - Target)
        if Dist <= ClosestDist then
            ClosestDist = Dist
            ClosestName = Name
            ClosestValue = Target
        end
    end

    return ClosestValue, ClosestName
end

local function GetSnapGuideOffset(Name: string, SnappedValue: number, ElemDimension: number): number
    if Name == "RightEdge" or Name == "BottomEdge" then
        return SnappedValue + ElemDimension
    elseif Name == "Center" then
        return SnappedValue + ElemDimension / 2
    end

    return SnappedValue 
end

function Library:MakeDraggable(
    UI: GuiObject,
    DragFrame: GuiObject,
    IgnoreToggled: boolean?,
    IsMainWindow: boolean?,
    SnapConfig: { Enabled: boolean, Distance: number?, Margin: number?, AvoidCoreGui: boolean? }?
)
    local StartPos
    local FramePos
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    local SnapGuideX, SnapGuideY

    local function GetSnapGuides()
        if not SnapGuideX then
            SnapGuideX = New("Frame", {
                BackgroundColor3 = "AccentColor",
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0),
                Size = UDim2.new(0, 2, 1, 0),
                Visible = false,
                ZIndex = 10000,
                Parent = ScreenGui,
            })
        end

        if not SnapGuideY then
            SnapGuideY = New("Frame", {
                BackgroundColor3 = "AccentColor",
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Visible = false,
                ZIndex = 10000,
                Parent = ScreenGui,
            })
        end

        return SnapGuideX, SnapGuideY
    end

    local function HideSnapGuides()
        if SnapGuideX then
            SnapGuideX.Visible = false
        end
        if SnapGuideY then
            SnapGuideY.Visible = false
        end
    end

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
            return
        end

        StartPos = Input.Position
        FramePos = UI.Position
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            HideSnapGuides()

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if
            (not IgnoreToggled and not Library.Toggled)
            or (IsMainWindow and Library.CantDragForced)
            or not (ScreenGui and ScreenGui.Parent)
        then
            Dragging = false
            HideSnapGuides()

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            local NewX = FramePos.X.Offset + Delta.X
            local NewY = FramePos.Y.Offset + Delta.Y

            if SnapConfig and SnapConfig.Enabled then
                local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
                local Distance = SnapConfig.Distance or 28
                local Margin = SnapConfig.Margin or 8

                local AbsX = FramePos.X.Scale * ViewportSize.X + NewX
                local AbsY = FramePos.Y.Scale * ViewportSize.Y + NewY

                local ElemSize = UI.AbsoluteSize
                local TargetsX, TargetsY = GetSnapEdges(ElemSize, ViewportSize, Margin, SnapConfig.AvoidCoreGui ~= false)
                local SnappedX, SnappedXName = GetClosestSnapTarget(AbsX, TargetsX, Distance)
                local SnappedY, SnappedYName = GetClosestSnapTarget(AbsY, TargetsY, Distance)

                if SnappedX then
                    NewX = SnappedX - FramePos.X.Scale * ViewportSize.X
                end
                if SnappedY then
                    NewY = SnappedY - FramePos.Y.Scale * ViewportSize.Y
                end

                local GuideX, GuideY = GetSnapGuides()
                GuideX.Visible = SnappedX ~= nil
                if SnappedX then
                    GuideX.Position = UDim2.fromOffset(GetSnapGuideOffset(SnappedXName, SnappedX, ElemSize.X), 0)
                end

                GuideY.Visible = SnappedY ~= nil
                if SnappedY then
                    GuideY.Position = UDim2.fromOffset(0, GetSnapGuideOffset(SnappedYName, SnappedY, ElemSize.Y))
                end
            end

            UI.Position = UDim2.new(FramePos.X.Scale, NewX, FramePos.Y.Scale, NewY)
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        if SnapGuideX then
            SnapGuideX:Destroy()
        end
        if SnapGuideY then
            SnapGuideY:Destroy()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
    local StartPos
    local FrameSize
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        StartPos = Input.Position
        FrameSize = UI.Size
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Size = UDim2.new(
                FrameSize.X.Scale,
                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                FrameSize.Y.Scale,
                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
            )
            if Callback then
                Library:SafeCallback(Callback)
            end
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeCover(Holder: GuiObject, Place: string)
    local Pos = Places[Place] or { 0, 0 }
    local Size = Sizes[Place] or { 1, 0.5 }

    local Cover = New("Frame", {
        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
        BackgroundColor3 = Holder.BackgroundColor3,
        Position = UDim2.fromScale(Pos[1], Pos[2]),
        Size = UDim2.fromScale(Size[1], Size[2]),
        Parent = Holder,
    })

    return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
    local Line = New("Frame", {
        AnchorPoint = Info.AnchorPoint or Vector2.zero,
        BackgroundColor3 = "OutlineColor",
        LayoutOrder = Info.LayoutOrder or 0,
        Position = Info.Position,
        Size = Info.Size,
        ZIndex = Info.ZIndex or Frame.ZIndex,
        Parent = Frame,
    })

    return Line
end

function Library:AddOutline(Frame: GuiObject)
    local OutlineStroke = New("UIStroke", {
        Color = "OutlineColor",
        Thickness = 1,
        ZIndex = 2,
        Parent = Frame,
    })
    local ShadowStroke = New("UIStroke", {
        Color = "DarkColor",
        Thickness = 1.5,
        ZIndex = 1,
        Parent = Frame,
    })
    return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame: GuiObject, Size: UDim2)
    return New("Frame", {
        BackgroundTransparency = 1,
        Size = Size or UDim2.fromScale(0, 0),
        Parent = Frame,
    })
end


local ActiveTabTweens = setmetatable({}, { __mode = "k" })

function Library:PlayTabAnimation(Tab, Showing: boolean, OnComplete: (() -> ())?, PreviousTab: any?)
    if type(Tab) ~= "table" or not Tab.Container then
        if OnComplete then
            OnComplete()
        end

        return
    end

    local TabContainer = Tab.Container :: Frame
    local Existing = ActiveTabTweens[TabContainer]
    if Existing then
        StopTween(Existing, true)
        ActiveTabTweens[TabContainer] = nil
    end

    local BaseZIndex = TabContainer.ZIndex
    if not (Library.Animations and Library.Animations.TabSwitch) then
        TabContainer.Visible = Showing
        TabContainer.Position = UDim2.fromScale(0, 0)
        TabContainer.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end

        return
    end

    if Showing then
        local TweenInfo = Library.TabTransitionInfo or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Offset = Library.TabSwipeOffset or 26
        local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
        local StartPosition
        local StartingPositions = {
            Left = UDim2.fromOffset(-Offset, 0),
            Right = UDim2.fromOffset(Offset, 0),
            Top = UDim2.fromOffset(0, -Offset),
            Bottom = UDim2.fromOffset(0, Offset),
        }

        PreviousTab = PreviousTab or Library.PreviousTab
        if SwipeFrom == "auto" and PreviousTab then
            local CurrentOrder = Tab.Button.LayoutOrder
            local PreviousOrder = PreviousTab.Button.LayoutOrder
            if CurrentOrder and PreviousOrder and Tab.IsSubTab then
                StartPosition = CurrentOrder > PreviousOrder and StartingPositions.Right or StartingPositions.Left
            elseif CurrentOrder and PreviousOrder then 
                StartPosition = CurrentOrder > PreviousOrder and StartingPositions.Top or StartingPositions.Bottom 
            else
                StartPosition = StartingPositions.Bottom
            end
        elseif SwipeFrom == "left" then
            StartPosition = StartingPositions.Left
        elseif SwipeFrom == "top" then
            StartPosition = StartingPositions.Top
        elseif SwipeFrom == "right" then
            StartPosition = StartingPositions.Right
        else 
            StartPosition = StartingPositions.Bottom
        end

        TabContainer.ZIndex = BaseZIndex + 1
        TabContainer.Position = StartPosition
        TabContainer.Visible = true

        local Tween = TweenService:Create(TabContainer, TweenInfo, {
            Position = UDim2.fromScale(0, 0)
        })

        ActiveTabTweens[TabContainer] = Tween
        Tween:Play()

        local Connection; Connection = Tween.Completed:Connect(function(PlaybackState)
            if Connection then
                Connection:Disconnect()
            end

            if ActiveTabTweens[TabContainer] == Tween then
                ActiveTabTweens[TabContainer] = nil
            end

            if PlaybackState == Enum.PlaybackState.Cancelled then
                return
            end

            TabContainer.ZIndex = BaseZIndex
            if OnComplete then
                OnComplete()
            end
        end)
    else
        TabContainer.Visible = false
        TabContainer.Position = UDim2.fromScale(0, 0)
        TabContainer.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end
    end
end


function Library:MakeBoxPopOut(Box: any, Options: {
    Enabled: boolean?,
    Header: GuiObject?,
    Children: (() -> { GuiObject })?,
    Before: (() -> ())?,
    After: (() -> ())?,
    MaxPopOutHeight: number?,
    PopOutWidth: number?,
})
    Box.PoppedOut = false
    Box.PopOutEnabled = Options.Enabled ~= false
    Box.PopOutFloat = nil
    Box.PopOutPlaceholder = nil
    Box.PopOutMaxHeight = if typeof(Options.MaxPopOutHeight) == "number" then Options.MaxPopOutHeight else nil
    Box.PopOutWidth = if typeof(Options.PopOutWidth) == "number" then Options.PopOutWidth else nil

    if not Box.PopOutEnabled then
        function Box:SetPoppedOut(_Value: boolean, _SetPoppedOut: UDim2) end
        function Box:TogglePoppedOut() end
        function Box:RefreshPopOutPlaceholder() end
        function Box:SetMaxPopOutHeight(_Height: number?) end
        function Box:SetPopOutWidth(_Width: number?) end
        return
    end

    local BoxHolder = Box.BoxHolder
    local Holder = Box.Holder
    local Header = Options.Header

    local Placeholder
    local PlaceholderHeader
    local Float
    local FloatScale

    local HandledChildren: { GuiObject } = {}
    local OriginalParents: { [GuiObject]: Instance? } = {}
    local OriginalLayoutOrders: { [GuiObject]: number } = {}

    local DragState: "Idle" | "Holding" | "Dragging" = "Idle"
    local DragInput: InputObject?
    local PressMouse: Vector2?

    local DragStartPos: UDim2?
    local DragChanged: RBXScriptConnection?
    local DragDidMove = false

    
    local function GetPopOutWidth(): number
        if typeof(Box.PopOutWidth) == "number" then
            return math.max(50, math.floor(Box.PopOutWidth + 0.5))
        end

        if typeof(Box.PopOutDockedWidth) == "number" then
            return math.max(50, math.floor(Box.PopOutDockedWidth + 0.5))
        end

        local Width = Holder.AbsoluteSize.X / Library.DPIScale
        if Width < 50 then
            Width = 200
        end

        return math.max(50, math.floor(Width + 0.5))
    end

    local function ApplyPopOutWidth()
        if not (Box.PoppedOut and Float) then
            return
        end

        Float.Size = UDim2.fromOffset(GetPopOutWidth(), Float.Size.Y.Offset)
        if Box.Resize then
            Box:Resize()
        end
    end

    local function RaiseFloat()
        if not Float or not Floats then
            return
        end

        local MaxZ = Float.ZIndex
        for _, Child in Floats:GetChildren() do
            if Child:IsA("GuiObject") and Child ~= Float then
                MaxZ = math.max(MaxZ, Child.ZIndex)
            end
        end

        Float.ZIndex = MaxZ + 1
        if Float.Parent == Floats then
            Float.Parent = Overlay
        end
        Float.Parent = Floats
    end

    local function CreatePlaceholder()
        local Frame = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            BackgroundTransparency = 0.12,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 0, 0),
            Parent = BoxHolder,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius),
                Parent = Frame,
            })
        )
        Library:AddOutline(Frame)

        PlaceholderHeader = Header:Clone()
        PlaceholderHeader.Parent = Frame
        RegisterPopOutClone(Header, PlaceholderHeader)
        DimPopOutClone(PlaceholderHeader)

        if PopOutIcon then
            local PlaceholderDockIcon = Library:CreateIcon(PopOutIcon, {
                AnchorPoint = Vector2.new(1, 0.5),
                ImageColor3 = "WhiteColor",
                Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.fromOffset(22, 22),
                ZIndex = PlaceholderHeader.ZIndex + 1,
                Parent = Frame,
            }, true)
            PlaceholderDockIcon.MouseButton1Click:Connect(function()
                Box:SetPoppedOut(false)
            end)
        end

        return Frame
    end

    function Box:RefreshPopOutPlaceholder()
        if not Box.PoppedOut or not Placeholder or not Header then
            return
        end

        if PlaceholderHeader then
            PlaceholderHeader:Destroy()
            PlaceholderHeader = nil
        end

        PlaceholderHeader = Header:Clone()
        PlaceholderHeader.Parent = Placeholder
        RegisterPopOutClone(Header, PlaceholderHeader)
        DimPopOutClone(PlaceholderHeader)
    end

    function Box:SetPoppedOut(Value: boolean, FloatPosition: UDim2?)
        if not Box.PopOutEnabled or Box.Destroyed then
            return
        end

        Value = Value == true
        if Box.PoppedOut == Value then
            if Value and FloatPosition and Float then
                Float.Position = FloatPosition
            end
            return
        end

        if Value then
            if Options.Before then
                Options.Before()
            end

            local BoxChildren = if Options.Children then Options.Children() else { Holder }
            HandledChildren = {}

            table.clear(OriginalParents)
            table.clear(OriginalLayoutOrders)

            for _, Child in BoxChildren do
                if not Child or not Child.Parent then
                    continue
                end

                table.insert(HandledChildren, Child)
                OriginalParents[Child] = Child.Parent
                OriginalLayoutOrders[Child] = Child.LayoutOrder
            end

            if #HandledChildren == 0 then
                return
            end

            local DockedWidth = Holder.AbsoluteSize.X / Library.DPIScale
            if DockedWidth < 50 then
                DockedWidth = 200
            end
            Box.PopOutDockedWidth = math.max(50, math.floor(DockedWidth + 0.5))

            local Width = GetPopOutWidth()

            local AbsolutePosition = Holder.AbsolutePosition
            Placeholder = CreatePlaceholder()
            Box.PopOutPlaceholder = Placeholder

            Float = New("Frame", {
                Active = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = FloatPosition or UDim2.fromOffset(
                    AbsolutePosition.X / Library.DPIScale,
                    AbsolutePosition.Y / Library.DPIScale
                ),
                Size = UDim2.fromOffset(Width, 0),
                ZIndex = 1,
                Parent = Floats,
            })
            FloatScale = New("UIScale", {
                Parent = Float,
            })
            table.insert(Library.Scales, FloatScale)
            FloatScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[FloatScale]) or 0)

            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = Float,
            })

            for _, Child in HandledChildren do
                Child.Parent = Float
            end

            if not table.find(Library.DraggableElements, Float) then
                table.insert(Library.DraggableElements, Float)
            end

            Box.PopOutFloat = Float
            Box.PoppedOut = true
            SyncPopOutVisibility(Box)
            RaiseFloat()

            Float:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                Box:Resize()
            end)

            if Options.After then
                Options.After()
            end

            return
        end

        if Float then
            local DraggableIndex = table.find(Library.DraggableElements, Float)
            if DraggableIndex then
                table.remove(Library.DraggableElements, DraggableIndex)
            end
        end

        if FloatScale then
            local ScaleIndex = table.find(Library.Scales, FloatScale)
            if ScaleIndex then
                table.remove(Library.Scales, ScaleIndex)
            end

            FloatScale = nil
        end

        for _, Child in HandledChildren do
            if not Child or not Child.Parent then
                continue
            end

            Child.Parent = OriginalParents[Child] or BoxHolder
            Child.LayoutOrder = OriginalLayoutOrders[Child] or 0
        end

        if Placeholder then
            Placeholder:Destroy()
            Placeholder = nil
        end
        
        PlaceholderHeader = nil

        if Float then
            Float:Destroy()
            Float = nil
        end

        Box.PopOutFloat = nil
        Box.PopOutPlaceholder = nil
        Box.PopOutDockedWidth = nil
        Box.PoppedOut = false

        table.clear(HandledChildren)
        table.clear(OriginalParents)
        table.clear(OriginalLayoutOrders)

        if Options.After then
            Options.After()
        end
    end

    function Box:TogglePoppedOut()
        Box:SetPoppedOut(not Box.PoppedOut)
    end

    function Box:SetMaxPopOutHeight(Height: number?)
        if Height ~= nil then
            assert(typeof(Height) == "number", "Height must be a number or nil")
            assert(Height >= 0, "Height must be higher than 0")
        end

        Box.PopOutMaxHeight = Height
        if Box.PoppedOut and Box.Resize then
            Box:Resize()
        end
    end

    function Box:SetPopOutWidth(Width: number?)
        if Width ~= nil then
            assert(typeof(Width) == "number", "Width must be a number or nil")
            assert(Width >= 0, "Width must be higher than 0")
        end

        Box.PopOutWidth = Width
        ApplyPopOutWidth()
    end

    
    local function StopDrag()
        if DragState == "Idle" then
            return
        end

        local WasDragging = DragState == "Dragging"
        local DidMove = DragDidMove
        DragState = "Idle"
        DragInput = nil
        PressMouse = nil
        DragStartPos = nil
        DragDidMove = false

        if DragChanged and DragChanged.Connected then
            DragChanged:Disconnect()
            DragChanged = nil
        end

        if not WasDragging or not Box.PoppedOut or not Float then
            return
        end

        local FloatCenter = Float.AbsolutePosition + (Float.AbsoluteSize * 0.5)
        local NearPlaceholder = false
        if Library.Toggled and Placeholder and Placeholder.Parent then
            local PlaceholderCenter = Placeholder.AbsolutePosition + (Placeholder.AbsoluteSize * 0.5)
            NearPlaceholder = (FloatCenter - PlaceholderCenter).Magnitude <= Library.PopOutSnapDistance
        end

        if NearPlaceholder or (DidMove and not IsScreenPointOutsideMain(FloatCenter)) then
            Box:SetPoppedOut(false)
        end
    end

    local function BeginDrag(Input: InputObject)
        if DragState ~= "Idle" or Box.Destroyed or not (ScreenGui and ScreenGui.Parent) then
            return
        end

        local Point = Vector2.new(Input.Position.X, Input.Position.Y)
        local Top = GetTopFloatAt(Point)
        if Box.PoppedOut then
            if not Float or Top ~= Float then
                return
            end
        elseif Top ~= nil and not Header:IsDescendantOf(Top) then
            return
        end

        DragState = "Holding"
        DragInput = Input
        PressMouse = Vector2.new(Input.Position.X, Input.Position.Y)
        DragStartPos = nil
        DragDidMove = false

        if Box.PoppedOut and Float then
            RaiseFloat()
        end

        DragChanged = Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                StopDrag()
            end
        end)

        task.delay(Library.PopOutHoldTime, function()
            if (DragState :: any) ~= "Holding" or DragInput ~= Input then
                return
            end

            DragState = "Dragging"
            if Box.PoppedOut and Float then
                RaiseFloat()
                DragStartPos = Float.Position
            end
        end)
    end

    local function UpdateDrag(Input: InputObject)
        if DragState ~= "Dragging" or not PressMouse then
            return
        end
        if not (ScreenGui and ScreenGui.Parent) then
            StopDrag()
            return
        end

        local MousePosition = Vector2.new(Input.Position.X, Input.Position.Y)
        local Delta = MousePosition - PressMouse

        if not Box.PoppedOut then
            if Delta.Magnitude < Library.PopOutDragThreshold then
                return
            end

            Box:SetPoppedOut(true)
            if not Float then
                return
            end

            RaiseFloat()
            DragStartPos = Float.Position
            DragDidMove = true
        elseif Delta.Magnitude >= Library.PopOutDragThreshold then
            DragDidMove = true
        end

        if Float and DragStartPos then
            Float.Position = UDim2.new(
                DragStartPos.X.Scale,
                DragStartPos.X.Offset + Delta.X,
                DragStartPos.Y.Scale,
                DragStartPos.Y.Offset + Delta.Y
            )
        end
    end

    local function BindDragSource(Gui: GuiObject)
        Library:GiveSignal(Gui.InputBegan:Connect(function(Input: InputObject)
            if IsClickInput(Input) then
                BeginDrag(Input)
            end
        end))
    end

    BindDragSource(Header)
    for _, Descendant in Header:QueryDescendants("GuiObject:not(ImageButton)") do
        BindDragSource(Descendant)
    end

    Library:GiveSignal(Header.DescendantAdded:Connect(function(Descendant)
        if Descendant:IsA("GuiObject") and not Descendant:IsA("ImageButton") then
            BindDragSource(Descendant)
        end
    end))

    Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
        if IsHoverInput(Input) then
            UpdateDrag(Input)
        end
    end))
end


function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
    warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
    local Holder = New("Frame", {
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromOffset(-2, -2),
        Size = UDim2.new(1, 4, 1, 4),
        ZIndex = ZIndex,
        Parent = Frame,
    })

    local Outline = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = ZIndex,
        Parent = Holder,
    })

    if Corner and Corner > 0 then
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner + 1),
            Parent = Holder,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner),
            Parent = Outline,
        })
    end

    return Holder, Outline
end

function Library:AddDraggableLabel(...)
    local Params = select(1, ...)
    local Text
    local Icon
    local IconPosition = "left"

    if typeof(Params) == "table" then
        Text = Params.Text
        Icon = Params.Icon
        IconPosition = Params.IconPosition or "left"
    elseif typeof(Params) == "string" then
        Text = Params
        Icon = select(2, ...)
        IconPosition = select(3, ...) or "left"
    end

    if typeof(IconPosition) ~= "string" then
        IconPosition = "left"
    end

    IconPosition = string.lower(IconPosition)
    assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

    local DraggableLabel = {
        Connections = {},
        Destroyed = false
    }

    local IconImage
    local Label = New("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(6, 6),
        Text = Text,
        TextSize = 15,
        ZIndex = 1,
        Parent = Floats,
    })

    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Label,
        })
    )

    local Padding = New("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 6),
        Parent = Label,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Label,
        })
    )

    Library:AddOutline(Label)
    Library:MakeDraggable(Label, Label, true)

    function DraggableLabel:SetText(Text: string)
        Label.Text = Text
    end

    function DraggableLabel:SetIcon(NewIcon: string)
        Icon = NewIcon

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        if IsNotEmpty then
            local CustomIcon = Library:GetCustomIcon(Icon)
            assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            IconImage = if IconImage then Library:ApplyIcon(IconImage, CustomIcon) else Library:CreateIcon(CustomIcon, {
                ImageColor3 = "FontColor",
                Size = UDim2.fromOffset(16, 16),
                ZIndex = 2,
                Parent = Label,
            })
        end

        if IconImage then IconImage.Visible = IsNotEmpty end
        DraggableLabel:SetIconPosition(IconPosition)
    end

    function DraggableLabel:SetIconPosition(NewPosition: string)
        IconPosition = string.lower(NewPosition)
        assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
        Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

        if IconImage then
            if IconPosition == "left" then
                IconImage.AnchorPoint = Vector2.new(0, 0.5)
                IconImage.Position = UDim2.new(0, -22, 0.5, 0)
            else
                IconImage.AnchorPoint = Vector2.new(1, 0.5)
                IconImage.Position = UDim2.new(1, 22, 0.5, 0)
            end
        end
    end

    function DraggableLabel:SetVisible(Visible: boolean)
        Label.Visible = Visible
    end

    DraggableLabel:SetIcon(Icon)
    DraggableLabel.Label = Label

    if not table.find(Library.DraggableElements, Label) then
        table.insert(Library.DraggableElements, Label)
    end

    PositionDraggable(Label, Label.Position)

    function DraggableLabel:Destroy()
        DraggableLabel.Destroyed = true

        if DraggableLabel.Connections then
            for _, connection in DraggableLabel.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Label)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Label then
            Label:Destroy()
        end
    end

    return DraggableLabel
end

function Library:AddDraggableButton(...)
    local Params = select(1, ...)

    local Text
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Text = Params.Text
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" then
        Text = Params
        Func = select(2, ...)
        ExcludeScaling = select(3, ...)
        ExcludeDragging = select(4, ...)
    end

    local DraggableButton = {
        Connections = {},
        Destroyed = false
    }

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        TextSize = 16,
        ZIndex = 1,
        Parent = Floats,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local PressPosition
    Button.InputBegan:Connect(function(Input: InputObject)
        if IsMouseInput(Input) then
            PressPosition = Button.AbsolutePosition
        end
    end)
    Button.Activated:Connect(function()
        if PressPosition and (Button.AbsolutePosition - PressPosition).Magnitude > 10 then
            return
        end

        Library:SafeCallback(Func, DraggableButton)
    end)

    function DraggableButton:SetText(Text: string)
        local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

        Button.Text = Text
        Button.TextSize = 16
        -- 浮标按钮固定为原生尺寸的长胶囊，不再随文字长短缩成小方块
        Button.Size = UDim2.fromOffset(math.max(X * 2 + 24, 96), math.max(Y * 2, 38))
    end

    if not ExcludeDragging then
        Library:MakeDraggable(Button, Button, true)
    end
    DraggableButton:SetText(Text)
    DraggableButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    function DraggableButton:Destroy()
        DraggableButton.Destroyed = true

        if DraggableButton.Connections then
            for _, connection in DraggableButton.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Button)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Button then
            Button:Destroy()
        end
    end

    return DraggableButton
end

function Library:AddDraggableMenu(Name: string)
    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(0, 0),
        ZIndex = 1,
        Parent = Floats,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    local DividerLine = Library:MakeLine(Holder, {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })
    local LabelPadding = New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = Label,
    })

    local Container = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        Parent = Container,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        Parent = Container,
    })

    Library:MakeDraggable(Holder, Label, true)

    if not table.find(Library.DraggableElements, Holder) then
        table.insert(Library.DraggableElements, Holder)
    end

    PositionDraggable(Holder, Holder.Position)

    return Holder, Container, Label, DividerLine, LabelPadding
end

function Library:AddDraggableImageButton(...)
    local Params = select(1, ...)

    local Icon
    local IconSize
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Icon = Params.Icon
        IconSize = Params.IconSize or 24
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" or typeof(Params) == "number" then
        Icon = Params
        IconSize = select(2, ...)
        Func = select(3, ...)
        ExcludeScaling = select(4, ...)
        ExcludeDragging = select(5, ...)
    end

    local DraggableImageButton = {}

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
        Text = "",
        ZIndex = 1,
        Parent = Floats,
    })

    local IconImage = Library:CreateIcon(nil, {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(IconSize, IconSize),
        ImageColor3 = "FontColor",
        ZIndex = 2,
        Parent = Button,
    })

    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local PressPosition
    Button.InputBegan:Connect(function(Input: InputObject)
        if IsMouseInput(Input) then
            PressPosition = Button.AbsolutePosition
        end
    end)
    Button.Activated:Connect(function()
        if PressPosition and (Button.AbsolutePosition - PressPosition).Magnitude > 10 then
            return
        end

        Library:SafeCallback(Func, DraggableImageButton)
    end)

    function DraggableImageButton:SetIcon(NewIcon: string)
        Icon = NewIcon or Icon

        local CustomIcon = Library:GetCustomIcon(Icon)
        assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        IconImage = Library:ApplyIcon(IconImage, CustomIcon)
    end

    function DraggableImageButton:SetIconSize(NewSize: number)
        IconSize = NewSize
        IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
        Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
    end

    if not ExcludeDragging then
        Library:MakeDraggable(Button, Button, true)
    end
    DraggableImageButton:SetIcon(Icon)
    DraggableImageButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    return DraggableImageButton
end


do
    local WatermarkLabel = Library:AddDraggableLabel("")
    WatermarkLabel:SetVisible(false)

    function Library:SetWatermark(Text: string)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetText(Text)
    end

    function Library:SetWatermarkVisibility(Visible: boolean)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetVisible(Visible)
    end
end


local CurrentMenu

local function CloseMenus(Until: any?, ShouldClose: ((Menu: any) -> boolean)?)
    local Closed = {}

    while CurrentMenu and CurrentMenu ~= Until and not Closed[CurrentMenu] do
        local Menu = CurrentMenu
        if ShouldClose and not ShouldClose(Menu) then
            break
        end

        Closed[Menu] = true
        Menu:Close()
    end
end

function Library:AddContextMenu(
    Holder: GuiObject,
    Size: UDim2 | () -> (),
    Offset: { [number]: number } | () -> {},
    List: number?,
    ActiveCallback: (Active: boolean) -> ()?,
    IgnoreCornerRadius: boolean?,
    SpecificCornersOnly: ("top" | "bottom" | "no_left" | "no_top_left")?, 
    AnimationType: ("Dropdown" | "KeyPicker" | "none")?
)
    local Menu
    local HolderGui = Holder:FindFirstAncestorOfClass("ScreenGui")
    local ParentGui = Overlay
    if HolderGui and HolderGui ~= ScreenGui and Library.ActiveLoading and HolderGui == Library.ActiveLoading.ScreenGui then
        ParentGui = HolderGui
    end

    if List then
        Menu = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3 = "BackgroundColor",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = List == 2 and 2 or 0,
            Size = typeof(Size) == "function" and Size() or Size,
            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            Visible = false,
            ZIndex = 1,
            Parent = ParentGui,
        })
    else
        Menu = New("Frame", {
            BackgroundColor3 = "BackgroundColor",
            Size = typeof(Size) == "function" and Size() or Size,
            Visible = false,
            ZIndex = 1,
            Parent = ParentGui,
        })
    end
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Menu,
        })
    )

    New("UIStroke", {
        Color = "OutlineColor",
        Parent = Menu,
    })

    local Corner;
    if IgnoreCornerRadius ~= true then
        if SpecificCornersOnly == "top" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "bottom" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_top_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        else
            Corner = New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.Corners, Corner)
        end
    end

    local Table = {
        Connections = {},
        Destroyed = false,

        Active = false,
        ActiveCallback = ActiveCallback,

        Holder = Holder,
        Menu = Menu,
        Corner = Corner,

        List = nil,
        Signal = nil,

        Size = Size,
        AutoSizeY = List == 1,

        OpenCloseTween = nil,
        Animated = function()
            if not AnimationType or AnimationType == "none" then
                return false
            end

            if not (Library.Animations and Library.Animations[AnimationType] == true) then
                return false
            end

            return true, Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    }

    if List == 1 then
        Table.List = New("UIListLayout", {
            Parent = Menu,
        })
    end

    function Table:Open()
        if CurrentMenu == Table then
            return
        end

        local NestedParent = nil
        local Check = CurrentMenu
        while Check do
            if Holder:IsDescendantOf(Check.Menu) then
                NestedParent = Check
                break
            end
            Check = Check.ParentMenu
        end

        CloseMenus(NestedParent)

        Table.ParentMenu = NestedParent
        CurrentMenu = Table
        Table.Active = true
        Menu.ZIndex = NestedParent and NestedParent.Menu.ZIndex + 1 or 1

        local TargetParent = if ParentGui == Overlay then Overlay else ParentGui
        Menu.Parent = nil
        Menu.Parent = TargetParent

        if typeof(Offset) == "function" then
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
            )
        else
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset[2])
            )
        end

        local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, true)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            local OpenSize = TargetSize
            if Table.AutoSizeY then
                local FullHeight = Menu.AbsoluteSize.Y

                Menu.AutomaticSize = Enum.AutomaticSize.None
                OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
            end

            Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
            Menu.Visible = true

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Size = TargetSize
            Menu.Visible = true
        end

        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
                )
            end

            local HolderAllowed = Table.ParentMenu ~= nil or Library:IsInsideFrame(Library.WindowContainer, Holder)
            if not HolderAllowed then
                for _, Surface in Library.DraggableElements do
                    if not (Surface and Library:IsInsideFrame(Surface, Holder)) then
                        continue
                    end

                    HolderAllowed = true
                    break
                end
            end

            if not HolderAllowed and Table.Active then
                Table:Close()
            end
        end)
    end

    function Table:Close()
        if CurrentMenu ~= Table then
            return
        end

        if Table.Signal then
            Table.Signal:Disconnect()
            Table.Signal = nil
        end

        Table.Active = false
        CurrentMenu = Table.ParentMenu
        Table.ParentMenu = nil

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, false)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            if Table.AutoSizeY then
                Menu.AutomaticSize = Enum.AutomaticSize.None
            end

            local CurrentSize = Menu.Size
            local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    Menu.Visible = false
                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Visible = false
        end
    end

    function Table:Toggle()
        if Table.Active then
            Table:Close()
        else
            Table:Open()
        end
    end

    function Table:SetSize(Size)
        Table.Size = Size
        Menu.Size = typeof(Size) == "function" and Size() or Size
    end

    function Table:Destroy()
        Table.Destroyed = true

        if Table.Connections then
            for _, Connection in Table.Connections do
                Connection:Disconnect()
            end
        end

        if Table.Active then
            CloseMenus(Table)
            Table:Close()
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local MenuIndex = table.find(Library.ContextMenus, Table)
        if MenuIndex then
            table.remove(Library.ContextMenus, MenuIndex)
        end

        if Menu then
            Menu:Destroy()
        end
    end

    table.insert(Library.ContextMenus, Table)
    return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
    if Library.Unloaded then
        return
    end

    if IsClickInput(Input, true) then
        local Location = Input.Position

        CloseMenus(nil, function(Menu)
            return not (Library:MouseIsOverFrame(Menu.Menu, Location) or Library:MouseIsOverFrame(Menu.Holder, Location))
        end)
    end
end))


local TooltipLabel = New("TextLabel", {
    BackgroundColor3 = "BackgroundColor",
    TextSize = 14,
    TextWrapped = true,
    Visible = false,
    ZIndex = 30,
    Parent = ScreenGui,
})
New("UIPadding", {
    PaddingBottom = UDim.new(0, 2),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingTop = UDim.new(0, 2),
    Parent = TooltipLabel,
})
table.insert(
    Library.Scales,
    New("UIScale", {
        Parent = TooltipLabel,
    })
)
New("UIStroke", {
    Color = "OutlineColor",
    Parent = TooltipLabel,
})
table.insert(
    Library.Corners,
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
        Parent = TooltipLabel,
    })
)

local TooltipMeasureId = 0
local LastTooltipText = ""
local LastTooltipMaxWidth = 0

local function UpdateTooltipSize(Force: boolean?)
    if Library.Unloaded or not TooltipLabel.Visible then
        return
    end

    local MaxWidth = math.max(
        40,
        (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
    )

    if
        not Force
        and TooltipLabel.Text == LastTooltipText
        and math.abs(MaxWidth - LastTooltipMaxWidth) < 1
        and TooltipLabel.Size.X.Offset > 0
    then
        return
    end

    TooltipMeasureId += 1
    local MeasureId = TooltipMeasureId
    local Text = TooltipLabel.Text

    local X, Y = Library:GetTextBounds(Text, TooltipLabel.FontFace, TooltipLabel.TextSize, MaxWidth)
    if MeasureId ~= TooltipMeasureId or TooltipLabel.Text ~= Text then
        return
    end

    LastTooltipText = Text
    LastTooltipMaxWidth = MaxWidth
    TooltipLabel.Size = UDim2.fromOffset(X + 8, Y + 4)
end

TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    UpdateTooltipSize(false)
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
    local TooltipTable = {
        Disabled = false,
        Hovering = false,
        Signals = {},
    }

    local function DoHover()
        if
            CurrentHoverInstance == HoverInstance
            or Library.ActiveDialog
            or (CurrentMenu and not HoverInstance:IsDescendantOf(CurrentMenu.Menu) and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
            or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
            or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
        then
            return
        end
        CurrentHoverInstance = HoverInstance

        local HolderGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
        if HolderGui and HolderGui ~= ScreenGui and Library.ActiveLoading and HolderGui == Library.ActiveLoading.ScreenGui then
            TooltipLabel.Parent = HolderGui
        else
            TooltipLabel.Parent = ScreenGui
        end

        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
        TooltipLabel.Position = UDim2.fromOffset(
            Mouse.X + (Library.ShowCustomCursor and 8 or 14),
            Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
        )
        TooltipLabel.Visible = true
        UpdateTooltipSize(true)

        while
            (Library.Toggled or Library.ActiveLoading)
            and not Library.ActiveDialog
            and Library:MouseIsOverFrame(HoverInstance, Mouse)
            and not (CurrentMenu and not HoverInstance:IsDescendantOf(CurrentMenu.Menu) and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
        do
            TooltipLabel.Position = UDim2.fromOffset(
                Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
            )

            RunService.RenderStepped:Wait()
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end

    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
        local ConnectionType = typeof(Connection)
        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
            table.insert(TooltipTable.Signals, Connection)
        end

        return Connection
    end

    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
    GiveSignal(HoverInstance.MouseLeave:Connect(function()
        if CurrentHoverInstance ~= HoverInstance then
            return
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end))

    function TooltipTable:Destroy()
        for Index = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        if CurrentHoverInstance == HoverInstance then
            if TooltipLabel then
                TooltipLabel.Visible = false
            end

            CurrentHoverInstance = nil
        end
    end

    table.insert(Tooltips, TooltipLabel)
    return TooltipTable
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

local BaseAddons, BaseGroupbox = {}, {}
do
    local Funcs = {}

    function Funcs:AddKeyPicker(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.KeyPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        if ParentObj.Type == "Button" or ParentObj.Type == "SubButton" then
            assert(Info.Mode == "Press", "KeyPicker on Buttons can only be applied with the 'Press' mode.")

            ToggleLabel = ParentObj.Base
        end

        local KeyPicker = {
            Connections = {},

            Text = Info.Text,
            Value = Info.Default, 
            Modifiers = Info.DefaultModifiers, 
            DisplayValue = Info.Default, 

            Blacklisted = Info.Blacklisted,
            BlacklistedModifiers = Info.BlacklistedModifiers,
            Whitelisted = Info.Whitelisted,
            WhitelistedModifiers = Info.WhitelistedModifiers,

            Toggled = false,
            Mode = Info.Mode,
            SyncToggleState = Info.SyncToggleState,

            NoUI = Info.NoUI == true,
            MenuVisible = Info.NoUI ~= true,

            Callback = Info.Callback,
            ChangedCallback = Info.ChangedCallback,
            Changed = Info.Changed,
            Clicked = Info.Clicked,

            Type = "KeyPicker",
            Idx = Idx,
        }

        if KeyPicker.Mode == "Press" then
            assert(ParentObj.Type == "Label" or ParentObj.Type == "Button" or ParentObj.Type == "SubButton", "KeyPicker with the mode 'Press' can be only applied on Labels and Buttons.")

            KeyPicker.SyncToggleState = false
            Info.Modes = { "Press" }
            Info.Mode = "Press"
        end

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle", "Hold" }

            if not table.find(Info.Modes, Info.Mode) then
                Info.Mode = "Toggle"
            end
        end

        local Picking = false
        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"

        
        local SpecialKeys = {
            ["MB1"] = Enum.UserInputType.MouseButton1,
            ["MB2"] = Enum.UserInputType.MouseButton2,
            ["MB3"] = Enum.UserInputType.MouseButton3,
        }

        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        }

        
        local Modifiers = {
            ["LAlt"] = Enum.KeyCode.LeftAlt,
            ["RAlt"] = Enum.KeyCode.RightAlt,

            ["LCtrl"] = Enum.KeyCode.LeftControl,
            ["RCtrl"] = Enum.KeyCode.RightControl,

            ["LShift"] = Enum.KeyCode.LeftShift,
            ["RShift"] = Enum.KeyCode.RightShift,

            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock,
        }

        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",

            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",

            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",

            [Enum.KeyCode.Tab] = "Tab",
            [Enum.KeyCode.CapsLock] = "CapsLock",
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local ActiveModifiers = {}

            for Name, Input in Modifiers do
                if table.find(ActiveModifiers, Name) then
                    continue
                end
                if not UserInputService:IsKeyDown(Input) then
                    continue
                end

                table.insert(ActiveModifiers, Name)
            end

            return ActiveModifiers
        end

        local AreModifiersHeld = function(Required)
            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
                return true
            end

            local ActiveModifiers = GetActiveModifiers()
            local Holding = true

            for _, Name in Required do
                if table.find(ActiveModifiers, Name) then
                    continue
                end

                Holding = false
                break
            end

            return Holding
        end

        local IsInputDown = function(Input)
            if not Input then
                return false
            end

            if SpecialKeysInput[Input.UserInputType] ~= nil then
                return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                    and not UserInputService:GetFocusedTextBox()
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
            else
                return false
            end
        end

        local ConvertToInputModifiers = function(CurrentModifiers)
            local InputModifiers = {}

            for _, name in CurrentModifiers do
                table.insert(InputModifiers, Modifiers[name])
            end

            return InputModifiers
        end

        local VerifyModifiers = function(CurrentModifiers)
            if typeof(CurrentModifiers) ~= "table" then
                return {}
            end

            local ValidModifiers = {}

            for _, name in CurrentModifiers do
                if not Modifiers[name] then
                    continue
                end

                table.insert(ValidModifiers, name)
            end

            return ValidModifiers
        end

        KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

        local SlideOverflow = true
        local LastDisplayText = nil
        local MaxPickerWidth = 85
        local SlidingLabel

        local SlideForwardTween
        local SlideBackTween
        local HandleForwardTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideBackTween then
                SlideBackTween:Play()
            end
        end

        local HandleBackTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideForwardTween then
                SlideForwardTween:Play()
            end
        end

        local SlideForwardConn, SlideBackConn
        local CancelSlidingTweens = function()
            if SlideForwardConn then
                SlideForwardConn:Disconnect()
                SlideForwardConn = nil
            end

            if SlideBackConn then
                SlideBackConn:Disconnect()
                SlideBackConn = nil
            end

            if SlideForwardTween then
                StopTween(SlideForwardTween, true)
                SlideForwardTween = nil
            end

            if SlideBackTween then
                StopTween(SlideBackTween, true)
                SlideBackTween = nil
            end

            RunService.RenderStepped:Wait()
        end

        local Picker = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromOffset(21, 21),
            Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
            TextSize = 14,
            TextTransparency = 0.4,
            Parent = ToggleLabel,
        })

        if IsForButton and SlideOverflow then
            Picker.ClipsDescendants = true

            SlidingLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = KeyPicker.Value,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = Picker,
            })
        end

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Picker,
        })

        local PickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Picker,
        }); table.insert(Library.SpecificCorners, PickerCorner)

        local PickerHoverTween = nil

        local function ApplyPickerTextTransparency(Transparency: number)
            StopTween(PickerHoverTween)
            PickerHoverTween = nil

            Picker.TextTransparency = Transparency
            if SlidingLabel then
                SlidingLabel.TextTransparency = Transparency
            end
        end

        local function TweenPickerTextTransparency(Transparency: number)
            StopTween(PickerHoverTween)

            PickerHoverTween = TweenService:Create(Picker, Library.TweenInfo, {
                TextTransparency = Transparency,
            })
            PickerHoverTween:Play()

            if SlidingLabel then
                TweenService:Create(SlidingLabel, Library.TweenInfo, {
                    TextTransparency = Transparency,
                }):Play()
            end
        end

        table.insert(KeyPicker.Connections, Picker.MouseEnter:Connect(function()
            if ParentObj.Disabled then
                return
            end

            TweenPickerTextTransparency(0)
        end))

        table.insert(KeyPicker.Connections, Picker.MouseLeave:Connect(function()
            if ParentObj.Disabled then
                return
            end

            TweenPickerTextTransparency(0.4)
        end))

        if IsForButton then
            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Parent = ToggleLabel.Parent,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6),
                Parent = Holder,
            })

            New("UIFlexItem", {
                FlexMode = Enum.UIFlexMode.Fill,
                Parent = ToggleLabel,
            })

            ToggleLabel.Parent = Holder
            Picker.Parent = Holder

            Picker.Size = UDim2.new(0, 18, 1, 0)
        end

        local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
        
        
        KeyPicker.KeybindsToggle = KeybindsToggle
        do
            local Holder = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = "",
                Visible = not Info.NoUI,
                Parent = Library.KeybindContainer,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Holder,
                })
            )
            local ButtonStroke = New("UIStroke", {
                Color = "OutlineColor",
                Enabled = false,
                Parent = Holder,
            })
            local ButtonPadding = New("UIPadding", {
                Parent = Holder,
            })

            local Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })

            local Checkbox = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Holder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Checkbox,
                })
            )
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })

            local CheckImage = Library:CreateIcon(CheckIcon, {
                ImageColor3 = "FontColor",
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })

            function KeybindsToggle:Display(State)
                if KeyPicker.Mode == "Press" then
                    Label.TextTransparency = 0.4
                    SetIconProperties(CheckImage, { ImageTransparency = 1 })
                    return
                end

                Label.TextTransparency = State and 0 or 0.5
                SetIconProperties(CheckImage, { ImageTransparency = State and 0 or 1 })
            end

            function KeybindsToggle:SetText(Text)
                Label.Text = Text
            end

            function KeybindsToggle:SetVisibility(Visibility)
                Holder.Visible = Visibility
            end

            function KeybindsToggle:SetNormal(Normal)
                KeybindsToggle.Normal = Normal

                local IsPress = KeyPicker.Mode == "Press"
                Holder.Active = not Normal or IsPress
                Checkbox.Visible = not Normal
                ButtonStroke.Enabled = IsPress
                Holder.BackgroundTransparency = IsPress and 0 or 1
                Holder.AutomaticSize = IsPress and Enum.AutomaticSize.X or Enum.AutomaticSize.None
                Holder.Size = IsPress and UDim2.fromOffset(0, 20) or UDim2.new(1, 0, 0, 16)
                ButtonPadding.PaddingLeft = UDim.new(0, IsPress and 8 or 0)
                ButtonPadding.PaddingRight = UDim.new(0, IsPress and 8 or 0)

                Label.AutomaticSize = Enum.AutomaticSize.X
                Label.Size = UDim2.fromScale(0, 1)
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Position = (not IsPress and not Normal) and UDim2.fromOffset(22, 0) or UDim2.fromOffset(0, 0)
            end

            KeyPicker.DoClick = function(...) end 
            table.insert(KeyPicker.Connections, Holder.MouseButton1Click:Connect(function()
                if KeyPicker.Mode == "Press" then
                    KeyPicker:DoClick()
                    return
                end

                if KeybindsToggle.Normal then
                    return
                end

                KeyPicker.Toggled = not KeyPicker.Toggled
                KeyPicker:DoClick()
                KeyPicker:Update()
            end))
            table.insert(KeyPicker.Connections, Holder.MouseEnter:Connect(function()
                if KeyPicker.Mode == "Press" and not ParentObj.Disabled then
                    Label.TextTransparency = 0
                end
            end))
            table.insert(KeyPicker.Connections, Holder.MouseLeave:Connect(function()
                if KeyPicker.Mode == "Press" then
                    Label.TextTransparency = 0.4
                end
            end))

            KeybindsToggle.Holder = Holder
            KeybindsToggle.Label = Label
            KeybindsToggle.Checkbox = Checkbox
            KeybindsToggle.Loaded = true
            table.insert(Library.KeybindToggles, KeybindsToggle)
        end

        local ModeButtons = {}
        local ModeCorners = {}
        local TotalModeButtons = GetTableSize(Info.Modes) + 1
        local MenuCornersOnly = if TotalModeButtons == 1 then "no_left" else "no_top_left"

        local MenuTable
        MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
            return { Picker.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, function(Active: boolean)
            local Half = UDim.new(0, Library.CornerRadius / 2)
            local Zero = UDim.new(0, 0)

            PickerCorner.TopLeftRadius = Half
            PickerCorner.BottomLeftRadius = Half
            PickerCorner.TopRightRadius = Active and Zero or Half
            PickerCorner.BottomRightRadius = Active and Zero or Half

            local MenuCorner = MenuTable and MenuTable.Corner
            if MenuCorner then
                if MenuCornersOnly == "no_left" then
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.BottomLeftRadius = Zero
                    MenuCorner.TopRightRadius = Half
                    MenuCorner.BottomRightRadius = Half
                else
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.TopRightRadius = Half
                    MenuCorner.BottomRightRadius = Half
                    MenuCorner.BottomLeftRadius = Half
                end
            end

            for _, Entry in ModeCorners do
                local Corner = Entry.Corner
                if Entry.Style == "single" then
                    Corner.TopLeftRadius = Zero
                    Corner.BottomLeftRadius = Zero
                    Corner.TopRightRadius = Half
                    Corner.BottomRightRadius = Half
                elseif Entry.Style == "first" then
                    Corner.TopLeftRadius = Zero
                    Corner.TopRightRadius = Half
                    Corner.BottomLeftRadius = Zero
                    Corner.BottomRightRadius = Zero
                elseif Entry.Style == "last" then
                    Corner.TopLeftRadius = Zero
                    Corner.TopRightRadius = Zero
                    Corner.BottomLeftRadius = Half
                    Corner.BottomRightRadius = Half
                end
            end
        end, false, MenuCornersOnly, "KeyPicker")
        KeyPicker.Menu = MenuTable

        for Index, Mode in Info.Modes do
            local ModeButton = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)),
                Text = Mode,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = MenuTable.Menu,
            })
            
            if Index == 1 and TotalModeButtons == 1 then
                local Corner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomLeftRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, Corner)
                table.insert(ModeCorners, { Corner = Corner, Style = "single" })
            elseif Index == 1 then
                local Corner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomLeftRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, 0),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, Corner)
                table.insert(ModeCorners, { Corner = Corner, Style = "first" })
            elseif Index == TotalModeButtons then
                local Corner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, Corner)
                table.insert(ModeCorners, { Corner = Corner, Style = "last" })
            end

            function ModeButton:Select()
                for _, Button in ModeButtons do
                    Button:Deselect()
                end

                KeyPicker.Mode = Mode

                Button.BackgroundTransparency = 0
                Button.TextTransparency = 0

                MenuTable:Close()
                if KeyPicker.Update then
                    KeyPicker:Update()
                end
            end

            function ModeButton:Deselect()
                KeyPicker.Mode = nil

                Button.BackgroundTransparency = 1
                Button.TextTransparency = 0.5
            end

            table.insert(KeyPicker.Connections, Button.MouseButton1Click:Connect(function()
                ModeButton:Select()
            end))

            table.insert(KeyPicker.Connections, Button.MouseEnter:Connect(function()
                if KeyPicker.Mode == Mode then
                    return
                end

                TweenService:Create(Button, Library.TweenInfo, {
                    BackgroundTransparency = 0.7,
                    TextTransparency = 0.1,
                }):Play()
            end))

            table.insert(KeyPicker.Connections, Button.MouseLeave:Connect(function()
                if KeyPicker.Mode == Mode then
                    return
                end

                TweenService:Create(Button, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                    TextTransparency = 0.5,
                }):Play()
            end))

            if KeyPicker.Mode == Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        do
            local RemoveButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                LayoutOrder = TotalModeButtons,
                Size = UDim2.new(1, 0, 0, IsForButton and 21 or 19),
                Text = "移除",
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = MenuTable.Menu,
            })

            local Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = RemoveButton,
            })
            table.insert(Library.SpecificCorners, Corner)
            table.insert(ModeCorners, { Corner = Corner, Style = "last" })

            table.insert(KeyPicker.Connections, RemoveButton.MouseButton1Click:Connect(function()
                MenuTable:Close()
                KeyPicker:SetValue({ "None", KeyPicker.Mode, {} })
            end))

            table.insert(KeyPicker.Connections, RemoveButton.MouseEnter:Connect(function()
                TweenService:Create(RemoveButton, Library.TweenInfo, {
                    BackgroundTransparency = 0.7,
                    TextTransparency = 0.1,
                }):Play()
            end))

            table.insert(KeyPicker.Connections, RemoveButton.MouseLeave:Connect(function()
                TweenService:Create(RemoveButton, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                    TextTransparency = 0.5,
                }):Play()
            end))
        end

        local SetPickingState = function(State, SkipUpdate: boolean?)
            Picking = State
            Library.IsPicking = State

            if ParentObj then
                ParentObj.AnyKeyPickerPicking = Picking
            end

            if IsForButton then
                ToggleLabel.Visible = not Picking
                LastDisplayText = nil
                RunService.RenderStepped:Wait()
            end

            if SkipUpdate ~= true then
                (KeyPicker :: any):Update()
            end
        end

        function KeyPicker:Display(PickerText)
            if Library.Unloaded then
                return
            end

            local DisplayText = PickerText or KeyPicker.DisplayValue
            if IsForButton and SlideOverflow then
                local X, _Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    10000
                )

                local OffsetScale = X + 9
                local TextChanged = LastDisplayText ~= DisplayText
                local LabelWidth

                SlidingLabel.Text = DisplayText
                LastDisplayText = DisplayText

                if Picking then
                    Picker.Size = UDim2.new(1, 0, 1, 0)
                    RunService.RenderStepped:Wait()
                    LabelWidth = Picker.AbsoluteSize.X

                    if LabelWidth <= 0 then
                        LabelWidth = MaxPickerWidth
                    end
                else
                    LabelWidth = math.min(OffsetScale, MaxPickerWidth)
                    Picker.Size = UDim2.new(0, LabelWidth, 1, 0)
                end

                if OffsetScale > LabelWidth then
                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)

                    local OverflowDistance = OffsetScale - LabelWidth - 4.5
                    if OverflowDistance > 0 then
                        if TextChanged or not SlideForwardTween then
                            SlidingLabel.Position = UDim2.fromOffset(4.5, 0)
                            CancelSlidingTweens()

                            local Duration = math.max(OverflowDistance / 25, 0.35)
                            local TweenInfo = TweenInfo.new(
                                Duration,
                                Enum.EasingStyle.Linear,
                                Enum.EasingDirection.InOut
                            )

                            SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
                                Position = UDim2.fromOffset(-OverflowDistance, 0),
                            })

                            SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
                                Position = UDim2.fromOffset(4.5, 0),
                            })

                            SlideForwardTween:Play()

                            if SlideForwardConn then
                                SlideForwardConn:Disconnect()
                            end

                            if SlideBackConn then
                                SlideBackConn:Disconnect()
                            end

                            SlideForwardConn = SlideForwardTween.Completed:Connect(HandleForwardTween)
                            SlideBackConn = SlideBackTween.Completed:Connect(HandleBackTween)
                        end
                    else
                        CancelSlidingTweens()

                        SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                        SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                        SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                    end
                else
                    CancelSlidingTweens()

                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                    SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                    SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                end
            else
                local X, Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    ToggleLabel.AbsoluteSize.X / Library.DPIScale
                )
                Picker.Text = DisplayText
                Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0) or UDim2.fromOffset(X + 9, 21)
            end
        end

        function KeyPicker:Update()
            local Disabled = ParentObj.Disabled == true

            if Disabled and Picking then
                SetPickingState(false, true)
            end

            KeyPicker:Display()

            Picker.Active = not Disabled
            ApplyPickerTextTransparency(Disabled and 0.8 or 0.4)

            if Disabled then
                if MenuTable.Active then
                    MenuTable:Close()
                end
            end

            if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                KeybindsToggle:SetVisibility(false)
                return
            end

            
            
            
            
            
            if KeyPicker.ForceListHidden then
                KeybindsToggle:SetVisibility(false)
                return
            end

            local State = KeyPicker:GetState()
            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                ParentObj:SetValue(State)
                State = KeyPicker:GetState()
            end

            if Info.NoUI then
                return
            end

            if KeybindsToggle.Loaded then
                if ShowToggle then
                    KeybindsToggle:SetNormal(false)
                else
                    KeybindsToggle:SetNormal(true)
                end

                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
                KeybindsToggle:SetVisibility(KeyPicker.MenuVisible ~= false)
                KeybindsToggle:Display(State)
            end
        end

        function KeyPicker:GetState()
            if KeyPicker.Mode == "Always" then
                return true
            elseif KeyPicker.Mode == "Hold" then
                local Key = KeyPicker.Value
                if Key == "None" then
                    return false
                end

                if not AreModifiersHeld(KeyPicker.Modifiers) then
                    return false
                end

                if Picking then
                    return false
                end

                if SpecialKeys[Key] ~= nil then
                    if Library.Toggled then
                        return false
                    end

                    return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
                        and not UserInputService:GetFocusedTextBox()
                else
                    return UserInputService:IsKeyDown(Enum.KeyCode[Key] :: any) and not UserInputService:GetFocusedTextBox()
                end
            else
                return KeyPicker.Toggled
            end
        end

        function KeyPicker:OnChanged(Func)
            KeyPicker.Changed = Func
        end

        function KeyPicker:OnClick(Func)
            KeyPicker.Clicked = Func
        end

        function KeyPicker:DoClick()
            if Picking or ParentObj.Disabled then
                return
            end

            if KeyPicker.Mode == "Press" then
                if KeyPicker.Toggled and Info.WaitForCallback == true then
                    return
                end

				KeyPicker.Toggled = true
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

            if IsForButton then
                Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
            end

            if Library.ToggleKeybind == KeyPicker and Library.Toggle then
                Library:Toggle()
            end

            if KeyPicker.Mode == "Press" then
                KeyPicker.Toggled = false
            end
        end

        function KeyPicker:RunChanged(IsKeyValid, KeyCode)
            if ParentObj.Disabled then
                return
            end

            if IsKeyValid == nil or KeyCode == nil then
                IsKeyValid, KeyCode = pcall(function()
                    if KeyPicker.Value == "None" then
                        return nil
                    end

                    if SpecialKeys[KeyPicker.Value] == nil then
                        return Enum.KeyCode[KeyPicker.Value]
                    end

                    return SpecialKeys[KeyPicker.Value]
                end)
            end

            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
            Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
            Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
        end

        function KeyPicker:SetValue(Data)
            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

            local IsKeyValid, KeyCode = pcall(function()
                if Key == "None" then
                    Key = nil
                    return nil
                end

                if SpecialKeys[Key] == nil then
                    return Enum.KeyCode[Key]
                end

                return SpecialKeys[Key]
            end)

            if Key == nil then
                KeyPicker.Value = "None"
            elseif IsKeyValid then
                KeyPicker.Value = Key
            else
                KeyPicker.Value = "Unknown"
            end

            KeyPicker.Modifiers =
                VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
                then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
                else KeyPicker.Value

            if ModeButtons[Mode] then
                ModeButtons[Mode]:Select()
            end

            KeyPicker:Update()
            KeyPicker:RunChanged(IsKeyValid, KeyCode)
        end

        function KeyPicker:SetText(Text)
            KeyPicker.Text = Text
            KeybindsToggle:SetText(Text)
            KeyPicker:Update()

            local KeybindMenu = Library.KeybindMenu
            if KeybindMenu and KeybindMenu.SettingsOpen then
                KeybindMenu:RefreshSettings()
            end
        end

        function KeyPicker:SetMenuVisibility(Visible: boolean)
            assert(typeof(Visible) == "boolean", "Visible must be a boolean")

            KeyPicker.MenuVisible = Visible
            KeyPicker:Update()

            local KeybindMenu = Library.KeybindMenu
            if KeybindMenu and KeybindMenu.SettingsOpen then
                KeybindMenu:RefreshSettings()
            end
        end

        table.insert(KeyPicker.Connections, Picker.MouseButton1Click:Connect(function()
            if Picking or Library.IsPicking or ParentObj.Disabled then
                return
            end

            SetPickingState(true)

            if IsForButton and SlideOverflow then
                KeyPicker:Display("...")
            else
                Picker.Text = "..."
                Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 21)
            end

            
            local ActiveModifiers = {}
            local CurrentInput = nil

            local IsValidInput = function(InputObj)
                if InputObj.KeyCode == Enum.KeyCode.Escape then
                    return true
                end

                local IsMod = IsModifierInput(InputObj)
                local KeyName
                if SpecialKeysInput[InputObj.UserInputType] ~= nil then
                    KeyName = SpecialKeysInput[InputObj.UserInputType]
                elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
                    if IsMod then
                        KeyName = ModifiersInput[InputObj.KeyCode]
                    else
                        KeyName = InputObj.KeyCode.Name
                    end
                end

                if KeyName then
                    if IsMod then
                        if KeyPicker.WhitelistedModifiers and #KeyPicker.WhitelistedModifiers > 0 and not table.find(KeyPicker.WhitelistedModifiers, KeyName) then
                            return false
                        end

                        if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
                            return false
                        end
                    else
                        if KeyPicker.Whitelisted and #KeyPicker.Whitelisted > 0 and not table.find(KeyPicker.Whitelisted, KeyName) then
                            return false
                        end

                        if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
                            return false
                        end
                    end
                end

                return true
            end

            
            while true do
                local InputObj = UserInputService.InputBegan:Wait()
                if UserInputService:GetFocusedTextBox() ~= nil then
                    SetPickingState(false)
                    return
                end

                if IsValidInput(InputObj) then
                    CurrentInput = InputObj
                    break
                end
            end

            
            while IsModifierInput(CurrentInput) do
                if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                    break
                end

                
                local ModName = ModifiersInput[CurrentInput.KeyCode]
                if ModName then
                    local text = if #ActiveModifiers > 0 then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..." else ModName .. " + ..."
                    KeyPicker:Display(text)
                end

                local NextInput = nil
                local Released = false

                local BeganConn
                local EndedConn

                BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        return
                    end
                    if IsValidInput(InputObj) then
                        NextInput = InputObj
                    end
                end)

                EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
                    if InputObj.KeyCode == CurrentInput.KeyCode then
                        Released = true
                    end
                end)

                repeat
                    task.wait()
                until Released or NextInput or UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded

                if BeganConn then BeganConn:Disconnect() end
                if EndedConn then EndedConn:Disconnect() end

                if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded then
                    SetPickingState(false)
                    return
                end

                if Released then
                    break 
                elseif NextInput then
                    
                    local OldModName = ModifiersInput[CurrentInput.KeyCode]
                    if OldModName and not table.find(ActiveModifiers, OldModName) then
                        ActiveModifiers[#ActiveModifiers + 1] = OldModName
                    end

                    CurrentInput = NextInput
                    if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                        break
                    end
                end
            end

            local Key = "Unknown"
            if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
                Key = SpecialKeysInput[CurrentInput.UserInputType]
            elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
                Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None" or CurrentInput.KeyCode.Name
            end

            ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

            KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
            KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

            repeat
                task.wait()
            until not IsInputDown(CurrentInput) or UserInputService:GetFocusedTextBox()

            SetPickingState(false)
        end))

        table.insert(KeyPicker.Connections, Picker.MouseButton2Click:Connect(function()
            if ParentObj.Disabled then
                return
            end

            MenuTable:Toggle()
        end))

        table.insert(KeyPicker.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject)
            if Library.Unloaded then
                return
            end

            local IsMouse = IsMouseClickInput(Input)
            if
                ParentObj.Disabled
                or KeyPicker.Mode == "Always"
                or KeyPicker.Value == "Unknown"
                or KeyPicker.Value == "None"
                or Picking
                or Library.IsPicking
                or UserInputService:GetFocusedTextBox()
                or (IsMouse and Library.Toggled)
            then
                return
            end

            local Key = KeyPicker.Value
            local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
            local HoldingKey = false

            if
                Key
                and HoldingModifiers == true
                and (
                    SpecialKeysInput[Input.UserInputType] == Key
                    or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
                )
            then
                HoldingKey = true
            end

            if HoldingKey then
                if KeyPicker.Mode == "Toggle" then
                    KeyPicker.Toggled = not KeyPicker.Toggled
                    KeyPicker:DoClick()
                elseif KeyPicker.Mode == "Press" then
                    KeyPicker:DoClick()
                elseif KeyPicker.Mode == "Hold" then
                    InputChanged = Input.Changed:Connect(function()
                        if KeyPicker:GetState() then
                            return
                        end

                        KeyPicker:Update()
                        if InputChanged and InputChanged.Connected then
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end

                KeyPicker:Update()
            end
        end))

        KeyPicker:Update()

        if not ParentObj.Addons then
            ParentObj.Addons = {}
        end

        table.insert(ParentObj.Addons, KeyPicker)

        KeyPicker.Default = KeyPicker.Value
        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

        function KeyPicker:Destroy()
            KeyPicker.Destroyed = true

            if SlideForwardConn then
                SlideForwardConn:Disconnect()
                SlideForwardConn = nil
            end

            if SlideBackConn then
                SlideBackConn:Disconnect()
                SlideBackConn = nil
            end

            if KeyPicker.Connections then
                for _, Connection in KeyPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if KeybindsToggle and KeybindsToggle.Loaded then
                if KeybindsToggle.Holder then
                    KeybindsToggle.Holder:Destroy()
                end
                local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
                if KTIdx then
                    table.remove(Library.KeybindToggles, KTIdx)
                end
            end

            if MenuTable then
                MenuTable:Destroy()
            end

            if IsForButton and SlideOverflow then
                if SlideForwardTween then
                    SlideForwardTween:Destroy()
                end

                if SlideBackTween then
                    SlideBackTween:Destroy()
                end
            end

            if Picker then
                Picker:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, KeyPicker)

                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            Options[Idx] = nil

            local KeybindMenu = Library.KeybindMenu
            if KeybindMenu and KeybindMenu.SettingsOpen then
                KeybindMenu:RefreshSettings()
            end
        end

        Options[Idx] = KeyPicker

        local KeybindMenu = Library.KeybindMenu
        if KeybindMenu and KeybindMenu.SettingsOpen then
            KeybindMenu:RefreshSettings()
        end

        return self
    end

    local HueSequenceTable = {}
    for Hue = 0, 1, 0.1 do
        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
    end
    function Funcs:AddColorPicker(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.ColorPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        local ColorPicker = {
            Connections = {},
            Destroyed = false,

            Value = Info.Default,

            Transparency = Info.Transparency or 0,
            Title = Info.Title,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Type = "ColorPicker",
        }
        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

        local Holder = New("TextButton", {
            BackgroundColor3 = ColorPicker.Value,
            Size = UDim2.fromOffset(21, 21),
            Text = "",
            Parent = ToggleLabel,
        })

        local HolderStroke = New("UIStroke", {
            Color = Library:GetDarkerColor(ColorPicker.Value),
            Parent = Holder,
        })

        local ColorPickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Holder,
        }); table.insert(Library.SpecificCorners, ColorPickerCorner)

        local HolderTransparency = New("ImageLabel", {
            Image = CustomImageManager.GetAsset("TransparencyTexture"),
            ImageTransparency = (1 - ColorPicker.Transparency),
            ScaleType = Enum.ScaleType.Tile,
            Position = UDim2.new(0, -1, 0, -1),
            Size = UDim2.new(1, 2, 1, 2),
            TileSize = UDim2.fromOffset(9, 9),
            Parent = Holder,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HolderTransparency,
            })
        )

        
        local MapSize = Library.IsMobile and 140 or 200
        local BarWidth = 16
        local MenuWidth = MapSize + BarWidth + 6 + 12
        if Info.Transparency then
            MenuWidth += BarWidth + 6
        end

        local ColorMenu
        local FooterCorner
        ColorMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(MenuWidth, 0),
            function()
                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
            end,
            1, function(Active: boolean)
                local Half = UDim.new(0, Library.CornerRadius / 2)
                local Zero = UDim.new(0, 0)

                ColorPickerCorner.TopLeftRadius = Half
                ColorPickerCorner.TopRightRadius = Half
                ColorPickerCorner.BottomRightRadius = Active and Zero or Half
                ColorPickerCorner.BottomLeftRadius = Active and Zero or Half

                local MenuCorner = ColorMenu and ColorMenu.Corner
                if MenuCorner then
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.TopRightRadius = Half
                    MenuCorner.BottomRightRadius = Half
                    MenuCorner.BottomLeftRadius = Half
                end

                if FooterCorner then
                    FooterCorner.TopLeftRadius = Zero
                    FooterCorner.TopRightRadius = Zero
                    FooterCorner.BottomLeftRadius = Half
                    FooterCorner.BottomRightRadius = Half
                end
            end, false, "no_top_left")
        ColorMenu.List.Padding = UDim.new(0, 8)
        ColorPicker.ColorMenu = ColorMenu

        
        local ContentHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = ContentHolder,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = ContentHolder,
        })

        
        local FooterHeight = Library.IsMobile and 30 or 22

        local FooterBackground = New("Frame", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Size = UDim2.new(1, 0, 0, FooterHeight),
            Parent = ColorMenu.Menu,
        })
        FooterCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, 0),
            TopRightRadius = UDim.new(0, 0),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = FooterBackground,
        })
        table.insert(Library.SpecificCorners, FooterCorner)
        Library:MakeLine(FooterBackground, {
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.new(1, 0, 0, 1),
        })

        local FooterBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = FooterBackground,
        })
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, Info.Resizable and (FooterHeight + 4) or 6),
            Parent = FooterBar,
        })

        local FooterInfoLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            TextTransparency = 0.5,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = FooterBar,
        })

        local function RefreshFooterInfo()
            FooterInfoLabel.Text = string.format(
                "#%s • %d, %d, %d",
                ColorPicker.Value:ToHex(),
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255)
            )
        end
        RefreshFooterInfo()

        if typeof(ColorPicker.Title) == "string" then
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Text = ColorPicker.Title,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ContentHolder,
            })
        end

        local ColorHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, MapSize),
            Parent = ContentHolder,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = ColorHolder,
        })

        
        local SatVipMap = New("ImageButton", {
            BackgroundColor3 = ColorPicker.Value,
            Image = CustomImageManager.GetAsset("SaturationMap"),
            Size = UDim2.fromOffset(MapSize, MapSize),
            Parent = ColorHolder,
        })

        local SatVibCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Size = UDim2.fromOffset(6, 6),
            Parent = SatVipMap,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SatVibCursor,
        })
        New("UIStroke", {
            Color = "DarkColor",
            Parent = SatVibCursor,
        })

        
        local HueSelector = New("TextButton", {
            Size = UDim2.fromOffset(BarWidth, MapSize),
            Text = "",
            Parent = ColorHolder,
        })
        New("UIGradient", {
            Color = ColorSequence.new(HueSequenceTable),
            Rotation = 90,
            Parent = HueSelector,
        })

        local HueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            BorderColor3 = "DarkColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
            Size = UDim2.new(1, 2, 0, 1),
            Parent = HueSelector,
        })

        
        local TransparencySelector, TransparencyColor, TransparencyCursor
        if Info.Transparency then
            TransparencySelector = New("ImageButton", {
                Image = CustomImageManager.GetAsset("TransparencyTexture"),
                ScaleType = Enum.ScaleType.Tile,
                Size = UDim2.fromOffset(BarWidth, MapSize),
                TileSize = UDim2.fromOffset(8, 8),
                Parent = ColorHolder,
            })

            TransparencyColor = New("Frame", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromScale(1, 1),
                Parent = TransparencySelector,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Parent = TransparencyColor,
            })

            TransparencyCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                BorderColor3 = "DarkColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = TransparencySelector,
            })
        end

        
        local ResizeGrabber
        if Info.Resizable then
            local BaseMapSize = 200
            local BaseBarWidth = BarWidth
            local BasePadding = 6
            local MinMapSize = 140

            ColorPicker.MapWidth = MapSize
            ColorPicker.MapHeight = MapSize

            local function GetBarWidth(MapWidth)
                return math.clamp(math.floor((MapWidth / BaseMapSize) * BaseBarWidth + 0.5), 12, 24)
            end

            local function GetContentWidth(MapWidth)
                local CurrentBarWidth = GetBarWidth(MapWidth)
                local Width = MapWidth + CurrentBarWidth + BasePadding
                if Info.Transparency then
                    Width += (CurrentBarWidth + BasePadding)
                end

                return Width + 12
            end

            local FixedVerticalOverhead = 6 + 6 + 8 + 20 + 8 + 20 + FooterHeight
            if typeof(ColorPicker.Title) == "string" then
                FixedVerticalOverhead += 8 + 8
            end

            local function ClampToViewport(NewWidth, NewHeight)
                local Camera = workspace.CurrentCamera
                if not Camera then
                    return NewWidth, NewHeight
                end

                local ViewportSize = Camera.ViewportSize
                local ScreenMargin = 12

                local MaxWidth = ViewportSize.X - ColorMenu.Menu.AbsolutePosition.X - ScreenMargin
                local MaxHeight = ViewportSize.Y - ColorMenu.Menu.AbsolutePosition.Y - ScreenMargin - FixedVerticalOverhead

                while NewWidth > MinMapSize and GetContentWidth(NewWidth) > MaxWidth do
                    NewWidth -= 4
                end

                if NewHeight > MaxHeight then
                    NewHeight = math.max(MinMapSize, math.floor(MaxHeight))
                end

                return NewWidth, NewHeight
            end

            local function UpdateColorMenuSize(NewWidth, NewHeight)
                NewWidth = math.max(MinMapSize, math.floor(NewWidth + 0.5))
                NewHeight = math.max(MinMapSize, math.floor(NewHeight + 0.5))
                NewWidth, NewHeight = ClampToViewport(NewWidth, NewHeight)

                if NewWidth == ColorPicker.MapWidth and NewHeight == ColorPicker.MapHeight then
                    return
                end

                local CurrentBarWidth = GetBarWidth(NewWidth)
                local CursorSize = math.clamp(math.floor((math.min(NewWidth, NewHeight) / BaseMapSize) * 6 + 0.5), 4, 10)

                ColorHolder.Size = UDim2.new(1, 0, 0, NewHeight)
                SatVipMap.Size = UDim2.fromOffset(NewWidth, NewHeight)
                SatVibCursor.Size = UDim2.fromOffset(CursorSize, CursorSize)
                HueSelector.Size = UDim2.new(0, CurrentBarWidth, 0, NewHeight)

                if TransparencySelector then
                    TransparencySelector.Size = UDim2.new(0, CurrentBarWidth, 0, NewHeight)
                end

                ColorPicker.MapWidth = NewWidth
                ColorPicker.MapHeight = NewHeight
                ColorMenu:SetSize(UDim2.new(0, GetContentWidth(NewWidth), 0, 0))
            end

            ResizeGrabber = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -Library.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = FooterBackground,
            })
            Library:CreateIcon(ResizeIcon, {
                ImageColor3 = "FontColor",
                ImageTransparency = 0.5,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = ResizeGrabber,
            })

            table.insert(ColorPicker.Connections, ResizeGrabber.InputBegan:Connect(function(Input: InputObject)
                Library.CantDragForced = true
                local StartMouse = Vector2.new(Mouse.X, Mouse.Y)
                local StartWidth = ColorPicker.MapWidth
                local StartHeight = ColorPicker.MapHeight

                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Delta = Vector2.new(Mouse.X, Mouse.Y) - StartMouse
                    UpdateColorMenuSize(StartWidth + Delta.X, StartHeight + Delta.Y)

                    RunService.RenderStepped:Wait()
                end

                Library.CantDragForced = false
            end))
        end

        local InfoHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ContentHolder,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = InfoHolder,
        })

        local HueBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "#??????",
            TextSize = 14,
            Parent = InfoHolder,
        })

        local HueBoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = HueBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HueBox,
            })
        )

        local RgbBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "?, ?, ?",
            TextSize = 14,
            Parent = InfoHolder,
        })

        local RgbBoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = RgbBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = RgbBox,
            })
        )

        
        local ContextMenu
        ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
            return { Holder.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, function(Active: boolean)
            local Half = UDim.new(0, Library.CornerRadius / 2)
            local Zero = UDim.new(0, 0)

            ColorPickerCorner.TopLeftRadius = Half
            ColorPickerCorner.BottomLeftRadius = Half
            ColorPickerCorner.TopRightRadius = Active and Zero or Half
            ColorPickerCorner.BottomRightRadius = Active and Zero or Half

            local MenuCorner = ContextMenu and ContextMenu.Corner
            if MenuCorner then
                MenuCorner.TopLeftRadius = Zero
                MenuCorner.TopRightRadius = Half
                MenuCorner.BottomRightRadius = Half
                MenuCorner.BottomLeftRadius = Half
            end
        end, false, "no_top_left")
        ColorPicker.ContextMenu = ContextMenu
        ContextMenu.List.Padding = UDim.new(0, 6)
        do
            local function CreateButton(Text, Func)
                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Text,
                    TextSize = 14,
                    Parent = ContextMenu.Menu,
                })

                table.insert(ColorPicker.Connections, Button.MouseButton1Click:Connect(function()
                    Library:SafeCallback(Func)
                    ContextMenu:Close()
                end))

                table.insert(ColorPicker.Connections, Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, Library.TweenInfo, {
                        BackgroundTransparency = 0.7,
                    }):Play()
                end))

                table.insert(ColorPicker.Connections, Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, Library.TweenInfo, {
                        BackgroundTransparency = 1,
                    }):Play()
                end))
            end

            CreateButton("复制颜色", function()
                Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
            end)

            ColorPicker.SetValueRGB = function(...) end 
            CreateButton("粘贴颜色", function()
                if not Library.CopiedColor then
                    return
                end

                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
            end)

            if setclipboard then
                CreateButton("复制 HEX", function()
                    setclipboard(tostring(ColorPicker.Value:ToHex()))
                end)

                CreateButton("复制 RGB", function()
                    setclipboard(table.concat({
                        math.floor(ColorPicker.Value.R * 255),
                        math.floor(ColorPicker.Value.G * 255),
                        math.floor(ColorPicker.Value.B * 255),
                    }, ", "))
                end)
            end
        end

        
        local ActionHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ContentHolder,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = ActionHolder,
        })

        local CopyColorButton = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            Text = "复制颜色",
            TextSize = 14,
            Parent = ActionHolder,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = CopyColorButton,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = CopyColorButton,
            })
        )

        local PasteColorButton = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            Text = "粘贴颜色",
            TextSize = 14,
            Parent = ActionHolder,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = PasteColorButton,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = PasteColorButton,
            })
        )

        local CopyColorOriginalText = CopyColorButton.Text
        local PasteColorOriginalText = PasteColorButton.Text
        local CopyColorResetId = 0
        local PasteColorResetId = 0

        table.insert(ColorPicker.Connections, CopyColorButton.MouseEnter:Connect(function()
            TweenService:Create(CopyColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library:GetBetterColor(Library.Scheme.MainColor, 10),
            }):Play()
        end))

        table.insert(ColorPicker.Connections, CopyColorButton.MouseLeave:Connect(function()
            TweenService:Create(CopyColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.MainColor,
            }):Play()
        end))

        table.insert(ColorPicker.Connections, PasteColorButton.MouseEnter:Connect(function()
            TweenService:Create(PasteColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library:GetBetterColor(Library.Scheme.MainColor, 10),
            }):Play()
        end))

        table.insert(ColorPicker.Connections, PasteColorButton.MouseLeave:Connect(function()
            TweenService:Create(PasteColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.MainColor,
            }):Play()
        end))

        table.insert(ColorPicker.Connections, CopyColorButton.MouseButton1Click:Connect(function()
            Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }

            CopyColorResetId += 1
            local ThisResetId = CopyColorResetId
            CopyColorButton.Text = "已复制颜色"

            task.delay(1, function()
                if ColorPicker.Destroyed or ThisResetId ~= CopyColorResetId then
                    return
                end

                CopyColorButton.Text = CopyColorOriginalText
            end)
        end))

        table.insert(ColorPicker.Connections, PasteColorButton.MouseButton1Click:Connect(function()
            PasteColorResetId += 1
            local ThisResetId = PasteColorResetId

            if not Library.CopiedColor then
                PasteColorButton.Text = "没有可粘贴的内容"
            else
                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
                PasteColorButton.Text = "已粘贴颜色"
            end

            task.delay(1, function()
                if ColorPicker.Destroyed or ThisResetId ~= PasteColorResetId then
                    return
                end

                PasteColorButton.Text = PasteColorOriginalText
            end)
        end))

        
        function ColorPicker:SetHSVFromRGB(Color)
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
        end

        function ColorPicker:Display()
            if Library.Unloaded then
                return
            end

            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
            if TransparencyColor then
                TransparencyColor.BackgroundColor3 = ColorPicker.Value
            end

            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
            if TransparencyCursor then
                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
            end

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255),
            }, ", ")

            RefreshFooterInfo()
        end

        local function ApplyHolderVisual(Disabled: boolean)
            Holder.Active = not Disabled
            HolderStroke.Transparency = Disabled and 0.5 or 0
            Holder.BackgroundTransparency = Disabled and 0.5 or 0

            if Disabled then
                Holder.BackgroundColor3 = ColorPicker.Value:Lerp(Library.Scheme.BackgroundColor, 0.5)
                HolderTransparency.ImageTransparency = math.clamp((1 - ColorPicker.Transparency) + 0.5, 0, 1)
            else
                Holder.BackgroundColor3 = ColorPicker.Value
                HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
                HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)
            end
        end

        function ColorPicker:RunChanged()
            if ParentObj.Disabled then
                return
            end

            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
        end

        function ColorPicker:Update()
            ColorPicker:Display()

            local Disabled = ParentObj.Disabled == true
            ApplyHolderVisual(Disabled)

            if Disabled then
                if ColorMenu.Active then
                    ColorMenu:Close()
                end

                if ContextMenu.Active then
                    ContextMenu:Close()
                end
            end

            ColorPicker:RunChanged()
        end

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func
        end

        function ColorPicker:SetValue(HSV, Transparency)
            if typeof(HSV) == "Color3" then
                ColorPicker:SetValueRGB(HSV, Transparency)
                return
            end

            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(function()
            if ParentObj.Disabled then
                return
            end

            ColorMenu:Toggle()
        end))

        table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(function()
            if ParentObj.Disabled then
                return
            end

            ContextMenu:Toggle()
        end))

        table.insert(ColorPicker.Connections, SatVipMap.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local MinX = SatVipMap.AbsolutePosition.X
                local MaxX = MinX + SatVipMap.AbsoluteSize.X
                local LocationX = math.clamp(Mouse.X, MinX, MaxX)

                local MinY = SatVipMap.AbsolutePosition.Y
                local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

                local OldSat = ColorPicker.Sat
                local OldVib = ColorPicker.Vib
                ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))

        table.insert(ColorPicker.Connections, HueSelector.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local Min = HueSelector.AbsolutePosition.Y
                local Max = Min + HueSelector.AbsoluteSize.Y
                local Location = math.clamp(Mouse.Y, Min, Max)

                local OldHue = ColorPicker.Hue
                ColorPicker.Hue = (Location - Min) / (Max - Min)

                if ColorPicker.Hue ~= OldHue then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))

        if TransparencySelector then
            table.insert(ColorPicker.Connections, TransparencySelector.InputBegan:Connect(function(Input: InputObject)
                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Min = TransparencySelector.AbsolutePosition.Y
                    local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                    local Location = math.clamp(Mouse.Y, Min, Max)

                    local OldTransparency = ColorPicker.Transparency
                    ColorPicker.Transparency = (Location - Min) / (Max - Min)

                    if ColorPicker.Transparency ~= OldTransparency then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end))
        end

        table.insert(ColorPicker.Connections, HueBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local Success, Color = pcall(Color3.fromHex, HueBox.Text)
            if Success and typeof(Color) == "Color3" then
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
            end

            ColorPicker:Update()
        end))

        table.insert(ColorPicker.Connections, RgbBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if R and G and B then
                ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
            end

            ColorPicker:Update()
        end))

        for _, BoxPair in {
            { HueBox, HueBoxStroke },
            { RgbBox, RgbBoxStroke }
        } do
            local TextBoxInstance, Stroke = BoxPair[1], BoxPair[2]

            table.insert(ColorPicker.Connections, TextBoxInstance.Focused:Connect(function()
                Library.Registry[Stroke].Color = "AccentColor"
                TweenService:Create(Stroke, Library.TweenInfo, {
                    Color = Library.Scheme.AccentColor,
                }):Play()
            end))

            table.insert(ColorPicker.Connections, TextBoxInstance.FocusLost:Connect(function()
                Library.Registry[Stroke].Color = "OutlineColor"
                TweenService:Create(Stroke, Library.TweenInfo, {
                    Color = Library.Scheme.OutlineColor,
                }):Play()
            end))
        end

        ColorPicker:Update()

        if not ParentObj.Addons then
            ParentObj.Addons = {}
        end

        table.insert(ParentObj.Addons, ColorPicker)

        ColorPicker.Default = ColorPicker.Value

        function ColorPicker:Destroy()
            ColorPicker.Destroyed = true

            if ColorPicker.Connections then
                for _, Connection in ColorPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if ColorMenu then
                ColorMenu:Destroy()
            end

            if ResizeGrabber then
                ResizeGrabber:Destroy()
            end

            if ContextMenu then
                ContextMenu:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, ColorPicker)

                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            Options[Idx] = nil
        end

        Options[Idx] = ColorPicker

        return self
    end

    function Funcs:AddSettings(Info)
        if self.Destroyed then return nil end

        local ParentObj = self
        if ParentObj.Settings and not ParentObj.Settings.Destroyed then
            return ParentObj.Settings
        end

        Info = Library:Validate(Info, Templates.Settings)

        local Settings = {
            Connections = {},
            Destroyed = false,

            Elements = {},
            DependencyBoxes = {},

            Width = Info.Width,

            Type = "Settings",
            Parent = ParentObj,
        }

        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"
        local IsForContainer = ParentObj.Type == "Input" or ParentObj.Type == "Dropdown"
        local ParentContainer = IsForContainer and ParentObj.Container or nil

        local Gear = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromOffset(18, 18),
            Text = "",
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Gear,
        })

        local GearCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Gear,
        }); table.insert(Library.SpecificCorners, GearCorner)

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 3),
            PaddingRight = UDim.new(0, 3),
            PaddingTop = UDim.new(0, 3),
            Parent = Gear,
        })

        local Icon = Library:CreateIcon(SettingsIcon, {
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            Size = UDim2.fromScale(1, 1),
            Parent = Gear,
        })

        if IsForButton then
            New("UIFlexItem", {
                FlexMode = Enum.UIFlexMode.None,
                Parent = Gear,
            })

            Gear.LayoutOrder = ParentObj.Base.LayoutOrder + 1
            Gear.Size = UDim2.new(0, 21, 1, 0)
            Gear.Parent = ParentObj.Base.Parent
        elseif IsForContainer then
            local Height = ParentContainer.Size.Y.Offset
            ParentContainer.Size = UDim2.new(1, -(Height + 6), 0, Height)

            Gear.AnchorPoint = Vector2.new(1, 1)
            Gear.Position = UDim2.fromScale(1, 1)
            Gear.Size = UDim2.fromOffset(Height, Height)
            Gear.Parent = ParentObj.Holder
        else
            Gear.Size = UDim2.fromOffset(21, 21)
            Gear.Parent = ParentObj.TextLabel
        end

        local function GetMenuSize()
            if typeof(Settings.Width) == "number" then
                return UDim2.fromOffset(Settings.Width, 0)
            end

            if not Library.WindowContainer then
                return UDim2.fromOffset(200, 0)
            end

            local Width = (Library.WindowContainer.AbsoluteSize.X / Library.DPIScale - 12) / 2 - 7
            return UDim2.fromOffset(math.floor(Width), 0)
        end

        local SettingsMenu; SettingsMenu = Library:AddContextMenu(Gear, GetMenuSize, function()
            return { 0.5, Gear.AbsoluteSize.Y + 1.5 }
        end, 1, function(Active: boolean)
            local Half = UDim.new(0, Library.CornerRadius / 2)
            local Zero = UDim.new(0, 0)

            GearCorner.TopLeftRadius = Half
            GearCorner.TopRightRadius = Half
            GearCorner.BottomRightRadius = Active and Zero or Half
            GearCorner.BottomLeftRadius = Active and Zero or Half

            local MenuCorner = SettingsMenu and SettingsMenu.Corner
            if MenuCorner then
                MenuCorner.TopLeftRadius = Zero
                MenuCorner.TopRightRadius = Half
                MenuCorner.BottomRightRadius = Half
                MenuCorner.BottomLeftRadius = Half
            end

            if ParentObj.Disabled then
                return
            end

            SetIconProperties(Icon, { ImageTransparency = Active and 0 or 0.5 })
        end, false, "no_top_left")
        Settings.Menu = SettingsMenu

        local Container = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = SettingsMenu.Menu,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = Container,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 7),
            PaddingLeft = UDim.new(0, 7),
            PaddingRight = UDim.new(0, 7),
            PaddingTop = UDim.new(0, 7),
            Parent = Container,
        })

        Settings.Holder = Container
        Settings.Container = Container
        Settings.Gear = Gear

        function Settings:Resize() end

        function Settings:SetWidth(Width: number?)
            if Width ~= nil then
                assert(typeof(Width) == "number", "Width must be a number or nil")
                assert(Width >= 0, "Width must be higher than 0")
            end

            Settings.Width = Width
            SettingsMenu:SetSize(GetMenuSize)
        end

        function Settings:Open()
            if ParentObj.Disabled then
                return
            end

            SettingsMenu:Open()
        end

        function Settings:Close()
            if not SettingsMenu.Active then
                return
            end

            CloseMenus(SettingsMenu)

            SettingsMenu:Close()
        end

        function Settings:Toggle()
            if SettingsMenu.Active then
                Settings:Close()
            else
                Settings:Open()
            end
        end

        function Settings:Update()
            local Disabled = ParentObj.Disabled == true

            Gear.Active = not Disabled
            Gear.BackgroundColor3 = Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
            Library.Registry[Gear].BackgroundColor3 = Disabled and "BackgroundColor" or "MainColor"
            SetIconProperties(Icon, { ImageTransparency = Disabled and 0.8 or (SettingsMenu.Active and 0 or 0.5) })

            if Disabled then
                Settings:Close()
            end
        end

        table.insert(Settings.Connections, Gear.MouseButton1Click:Connect(function()
            Settings:Toggle()
        end))

        table.insert(Settings.Connections, Gear.MouseEnter:Connect(function()
            if ParentObj.Disabled then
                return
            end

            TweenIcon(Icon, { ImageTransparency = 0 })
        end))

        table.insert(Settings.Connections, Gear.MouseLeave:Connect(function()
            if ParentObj.Disabled then
                return
            end

            TweenIcon(Icon, { ImageTransparency = SettingsMenu.Active and 0 or 0.5 })
        end))

        setmetatable(Settings, BaseGroupbox)

        function Settings:Destroy()
            Settings.Destroyed = true

            for _, Connection in Settings.Connections do
                Connection:Disconnect()
            end

            for Index = #Settings.Elements, 1, -1 do
                local Element = Settings.Elements[Index]
                if Element and Element.Destroy then
                    Element:Destroy()
                end
            end

            for Index = #Settings.DependencyBoxes, 1, -1 do
                local SubDepbox = Settings.DependencyBoxes[Index]
                if SubDepbox and SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            SettingsMenu:Destroy()

            if ParentContainer and ParentContainer.Parent then
                ParentContainer.Size = UDim2.new(1, 0, 0, ParentContainer.Size.Y.Offset)
            end

            if Gear then
                Gear:Destroy()
            end

            if ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, Settings)
                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            if ParentObj.Settings == Settings then
                ParentObj.Settings = nil
            end
        end

        if not ParentObj.Addons then
            ParentObj.Addons = {}
        end

        table.insert(ParentObj.Addons, Settings)
        ParentObj.Settings = Settings

        Settings:Update()

        return Settings
    end

    BaseAddons.__index = Funcs
    BaseAddons.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

do
    local Funcs = {}

    function Funcs:AddDivider(...)
        if self.Destroyed then return nil end

        local Params = select(1, ...)
        local Text
        local MarginTop = 0
        local MarginBottom = 0

        if typeof(Params) == "table" then
            Text = Params.Text
            MarginTop = Params.MarginTop or Params.Margin or 0
            MarginBottom = Params.MarginBottom or Params.Margin or 0
        elseif typeof(Params) == "string" then
            Text = Params
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
            Parent = Container,
        })

        local InnerHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingTop = UDim.new(0, MarginTop),
            PaddingBottom = UDim.new(0, MarginBottom),
            Parent = Holder,
        })

        if Text then
            local TextLabel = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = Text,
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = InnerHolder,
            })

            local X, _ = Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X / Library.DPIScale)
            local SizeX = X // 2 + 10

            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
            New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
        else
            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Parent = InnerHolder,
            })
        end

        Groupbox:Resize()

        local Divider = {
            Connections = {},
            Destroyed = false,

            Holder = Holder,
            Text = Text,
            MarginTop = MarginTop,
            MarginBottom = MarginBottom,
            Type = "Divider",

            Parent = Groupbox,
        }

        function Divider:SetVisible(Value)
            Holder.Visible = Value == true
            Groupbox:Resize()
        end

        function Divider:Destroy()
            Divider.Destroyed = true

            if Divider.Connections then
                for _, Connection in Divider.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Divider)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
        end

        table.insert(Groupbox.Elements, Divider)
        return Divider
    end

    function Funcs:AddLabel(...)
        if self.Destroyed then return nil end

        local Data = {}
        local Addons = {}

        local First = select(1, ...)
        local Second = select(2, ...)

        if typeof(First) == "table" or typeof(Second) == "table" then
            local Params = typeof(First) == "table" and First or Second

            Data.Text = Params.Text or ""
            Data.DoesWrap = Params.DoesWrap or false
            Data.Size = Params.Size or 14
            Data.Visible = if typeof(Params.Visible) == "boolean" then Params.Visible else true
            Data.Idx = typeof(Second) == "table" and First or nil
        else
            Data.Text = First or ""
            Data.DoesWrap = Second or false
            Data.Size = 14
            Data.Visible = true
            Data.Idx = select(3, ...) or nil
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Label = {
            Connections = {},
            Destroyed = false,

            Text = Data.Text,
            DoesWrap = Data.DoesWrap,

            Addons = Addons,

            Visible = Data.Visible,
            Type = "Label",

            Parent = Groupbox,
        }

        local TextLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = Label.Text,
            TextSize = Data.Size,
            TextWrapped = Label.DoesWrap,
            TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
            Visible = Label.Visible,
            Parent = Container,
        })

        function Label:Display()
            if not Label.DoesWrap then
                return
            end

            local Width = TextLabel.AbsoluteSize.X / Library.DPIScale
            if Width <= 0 then return end

            local _, Y = Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
        end

        function Label:SetVisible(Visible: boolean)
            Label.Visible = Visible

            TextLabel.Visible = Label.Visible
            Groupbox:Resize()
        end

        function Label:SetText(Text: string)
            Label.Text = Text
            TextLabel.Text = Text

            Label:Display()
            Groupbox:Resize()
        end

        if Label.DoesWrap then
            Label:Display()

            local Last = TextLabel.AbsoluteSize
            table.insert(Label.Connections, TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if TextLabel.AbsoluteSize == Last then
                    return
                end

                Label:Display()
                Last = TextLabel.AbsoluteSize

                Groupbox:Resize()
            end))
        else
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                Parent = TextLabel,
            })
        end

        Groupbox:Resize()

        Label.TextLabel = TextLabel
        Label.Container = Container
        if not Data.DoesWrap then
            setmetatable(Label, BaseAddons)
        end

        Label.Holder = TextLabel
        table.insert(Groupbox.Elements, Label)

        if Data.Idx then
            Labels[Data.Idx] = Label
        else
            table.insert(Labels, Label)
        end

        function Label:Destroy()
            Label.Destroyed = true

            if Label.Connections then
                for _, Connection in Label.Connections do
                    Connection:Disconnect()
                end
            end

            if Label.Addons then
                for Index = #Label.Addons, 1, -1 do
                    local Addon = table.remove(Label.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if TextLabel then
                TextLabel:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Label)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()

            if Data.Idx then
                Labels[Data.Idx] = nil
            else
                local LblIdx = table.find(Labels, Label)

                if LblIdx then
                    table.remove(Labels, LblIdx)
                end
            end
        end

        return Label
    end

    function Funcs:AddButton(...)
        if self.Destroyed then return nil end

        local function GetInfo(...)
            local Info = {}

            local First = select(1, ...)
            local Second = select(2, ...)

            if typeof(First) == "table" or typeof(Second) == "table" then
                local Params = typeof(First) == "table" and First or Second

                Info.Text = Params.Text or ""
                Info.Func = Params.Func or Params.Callback or function() end
                Info.DoubleClick = Params.DoubleClick
                Info.Icon = Params.Icon or Params.IconName

                Info.Tooltip = Params.Tooltip
                Info.DisabledTooltip = Params.DisabledTooltip

                Info.Risky = Params.Risky or false
                Info.Disabled = Params.Disabled or false
                Info.Visible = if typeof(Params.Visible) == "boolean" then Params.Visible else true
                Info.Idx = typeof(Second) == "table" and First or nil
            else
                Info.Text = First or ""
                Info.Func = Second or function() end
                Info.DoubleClick = false
                Info.Icon = nil

                Info.Tooltip = nil
                Info.DisabledTooltip = nil

                Info.Risky = false
                Info.Disabled = false
                Info.Visible = true
                Info.Idx = select(3, ...) or nil
            end

            return Info
        end
        local Info = GetInfo(...)

        local Groupbox = self
        local Container = Groupbox.Container

        local Button = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Func = Info.Func,
            DoubleClick = Info.DoubleClick,
            Icon = Info.Icon,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,
            Locked = false,

            Base = nil,
            Stroke = nil,
            Content = nil,
            Label = nil,
            IconImage = nil,

            Addons = {},

            Tween = nil,
            Type = "Button",

            Parent = Groupbox,
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 6),
            Parent = Holder,
        })

        local function ApplyButtonIcon(Button, IconName)
            local Content = Button.Content
            if not Content then
                return
            end

            local ParsedIcon = Library:GetCustomIcon(IconName)
            if ParsedIcon then
                Button.IconImage = if Button.IconImage then Library:ApplyIcon(Button.IconImage, ParsedIcon) else Library:CreateIcon(ParsedIcon, {
                    LayoutOrder = 0,
                    Size = UDim2.fromOffset(14, 14),
                    Parent = Content,
                })

                Button.IconImage.Visible = true
                SetIconProperties(Button.IconImage, {
                    ImageColor3 = if Button.Risky then "RedColor" elseif ParsedIcon.Custom then "WhiteColor" else "FontColor",
                    ImageTransparency = Button.Disabled and 0.8 or 0.4,
                })
            elseif Button.IconImage then
                Button.IconImage.Visible = false
            end
        end

        local function CreateButton(Button)
            local Base = New("TextButton", {
                Active = not Button.Disabled,
                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                LayoutOrder = Button.Type == "SubButton" and 2 or 0,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                Visible = Button.Visible,
                Parent = Holder,
            })

            local Stroke = New("UIStroke", {
                Color = "OutlineColor",
                Transparency = Button.Disabled and 0.5 or 0,
                Parent = Base,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Base,
                })
            )

            local Content = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(0, 16),
                Parent = Base,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                Parent = Content,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Content,
            })

            Button.Content = Content
            Button.Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.fromOffset(0, 16),
                Text = Button.Text,
                TextSize = 14,
                TextTransparency = Button.Disabled and 0.8 or 0.4,
                Visible = Button.Text ~= "",
                Parent = Content,
            })

            if Button.Risky then
                Button.Label.TextColor3 = Library.Scheme.RedColor
                Library.Registry[Button.Label].TextColor3 = "RedColor"
            end

            ApplyButtonIcon(Button, Button.Icon)

            return Base, Stroke
        end

        local function InitEvents(Button)
            table.insert(Button.Connections, Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Label, Library.TweenInfo, {
                    TextTransparency = 0,
                })
                Button.Tween:Play()

                if Button.IconImage and Button.IconImage.Visible then
                    TweenIcon(Button.IconImage, { ImageTransparency = 0 })
                end
            end))
            table.insert(Button.Connections, Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Label, Library.TweenInfo, {
                    TextTransparency = 0.4,
                })
                Button.Tween:Play()

                if Button.IconImage and Button.IconImage.Visible then
                    TweenIcon(Button.IconImage, { ImageTransparency = 0.4 })
                end
            end))

            table.insert(Button.Connections, Button.Base.MouseButton1Click:Connect(function()
                if Button.Disabled or Button.Locked then
                    return
                end

                if Button.DoubleClick then
                    Button.Locked = true

                    local IconWasVisible = false
                    if Button.IconImage then
                        IconWasVisible = Button.IconImage.Visible
                        Button.IconImage.Visible = false
                    end

                    Button.Label.Text = "确定吗？"
                    Button.Label.Visible = true
                    Button.Label.TextColor3 = Library.Scheme.AccentColor
                    Library.Registry[Button.Label].TextColor3 = "AccentColor"

                    local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                    Button.Label.Text = Button.Text
                    Button.Label.Visible = Button.Text ~= ""
                    Button.Label.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
                    Library.Registry[Button.Label].TextColor3 = Button.Risky and "RedColor" or "FontColor"

                    if Button.IconImage then
                        Button.IconImage.Visible = IconWasVisible
                    end

                    if Clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    RunService.RenderStepped:Wait()
                    Button.Locked = false
                    return
                end

                Library:SafeCallback(Button.Func)
            end))
        end

        Button.Base, Button.Stroke = CreateButton(Button)
        InitEvents(Button)

        function Button:AddButton(...)
            local Info = GetInfo(...)

            local SubButton = {
                Connections = {},
                Destroyed = false,

                Text = Info.Text,
                Func = Info.Func,
                DoubleClick = Info.DoubleClick,
                Icon = Info.Icon,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,
                Locked = false,

                Base = nil,
                Stroke = nil,
                Content = nil,
                Label = nil,
                IconImage = nil,

                Addons = {},

                Tween = nil,
                Type = "SubButton",
            }

            Button.SubButton = SubButton
            SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
            InitEvents(SubButton)

            function SubButton:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(SubButton.Tween)

                SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
                SubButton.Label.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                if SubButton.IconImage and SubButton.IconImage.Visible then
                    SetIconProperties(SubButton.IconImage, { ImageTransparency = SubButton.Disabled and 0.8 or 0.4 })
                end

                Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
                    or "MainColor"
            end

            function SubButton:SetDisabled(Disabled: boolean)
                SubButton.Disabled = Disabled

                if SubButton.TooltipTable then
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                SubButton.Base.Active = not SubButton.Disabled
                SubButton:UpdateColors()
                Library:UpdateAddons(SubButton)
            end

            function SubButton:SetVisible(Visible: boolean)
                SubButton.Visible = Visible

                SubButton.Base.Visible = SubButton.Visible
                Groupbox:Resize()
            end

            function SubButton:SetText(Text: string)
                SubButton.Text = Text
                SubButton.Label.Text = Text
                SubButton.Label.Visible = Text ~= ""
            end

            function SubButton:SetIcon(Icon: string?)
                SubButton.Icon = Icon
                ApplyButtonIcon(SubButton, Icon)
            end

            if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                SubButton.TooltipTable =
                    Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                SubButton.TooltipTable.Disabled = SubButton.Disabled
            end

            SubButton:UpdateColors()

            if Info.Idx then
                Buttons[Info.Idx] = SubButton
            else
                table.insert(Buttons, SubButton)
            end

            SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker
            SubButton.AddSettings = BaseAddons.__index.AddSettings

            function SubButton:Destroy()
                SubButton.Destroyed = true

                if SubButton.Connections then
                    for _, Connection in SubButton.Connections do
                        Connection:Disconnect()
                    end
                end

                if SubButton.Addons then
                    for Index = #SubButton.Addons, 1, -1 do
                        local Addon = table.remove(SubButton.Addons, Index)
                        if Addon and Addon.Destroy then
                            Addon:Destroy()
                        end
                    end
                end

                if SubButton.TooltipTable then
                    SubButton.TooltipTable:Destroy()
                end

                if SubButton.Tween then
                    SubButton.Tween:Destroy()
                end

                if SubButton.Base then
                    SubButton.Base:Destroy()
                end

                if Info.Idx then
                    Buttons[Info.Idx] = nil
                else
                    local BIdx = table.find(Buttons, SubButton)

                    if BIdx then
                        table.remove(Buttons, BIdx)
                    end
                end
            end

            return SubButton
        end

        function Button:UpdateColors()
            if Library.Unloaded then
                return
            end

            StopTween(Button.Tween)

            Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
            Button.Label.TextTransparency = Button.Disabled and 0.8 or 0.4
            Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

            if Button.IconImage and Button.IconImage.Visible then
                SetIconProperties(Button.IconImage, { ImageTransparency = Button.Disabled and 0.8 or 0.4 })
            end

            Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
        end

        function Button:SetDisabled(Disabled: boolean)
            Button.Disabled = Disabled

            if Button.TooltipTable then
                Button.TooltipTable.Disabled = Button.Disabled
            end

            Button.Base.Active = not Button.Disabled
            Button:UpdateColors()
            Library:UpdateAddons(Button)
        end

        function Button:SetVisible(Visible: boolean)
            Button.Visible = Visible

            Holder.Visible = Button.Visible
            Groupbox:Resize()
        end

        function Button:SetText(Text: string)
            Button.Text = Text
            Button.Label.Text = Text
            Button.Label.Visible = Text ~= ""
        end

        function Button:SetIcon(Icon: string?)
            Button.Icon = Icon
            ApplyButtonIcon(Button, Icon)
        end

        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
            Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
            Button.TooltipTable.Disabled = Button.Disabled
        end

        Button:UpdateColors()
        Groupbox:Resize()

        Button.Holder = Holder
        table.insert(Groupbox.Elements, Button)

        if Info.Idx then
            Buttons[Info.Idx] = Button
        else
            table.insert(Buttons, Button)
        end

        Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker
        Button.AddSettings = BaseAddons.__index.AddSettings

        function Button:Destroy()
            Button.Destroyed = true

            if Button.Connections then
                for _, Connection in Button.Connections do
                    Connection:Disconnect()
                end
            end

            if Button.Addons then
                for Index = #Button.Addons, 1, -1 do
                    local Addon = table.remove(Button.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if Button.TooltipTable then
                Button.TooltipTable:Destroy()
            end

            if Button.Tween then
                Button.Tween:Destroy()
            end

            if Button.SubButton then
                Button.SubButton:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Button)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()

            if Info.Idx then
                Buttons[Info.Idx] = nil
            else
                local BIdx = table.find(Buttons, Button)

                if BIdx then
                    table.remove(Buttons, BIdx)
                end
            end
        end

        return Button
    end

    function Funcs:AddCheckbox(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Checkbox",
            Type = "Toggle",

            Parent = Groupbox,
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Checkbox = New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Button,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Checkbox,
            })
        )

        local CheckboxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Checkbox,
        })

        local CheckImage = Library:CreateIcon(CheckIcon, {
            ImageColor3 = "FontColor",
            ImageTransparency = 1,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = Checkbox,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                SetIconProperties(CheckImage, { ImageTransparency = Toggle.Value and 0.8 or 1 })

                Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenIcon(CheckImage, { ImageTransparency = Toggle.Value and 0 or 1 })

            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            if Toggle.Disabled then
                return
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" then
                    if Addon.SyncToggleState then
                        Addon.Toggled = Toggle.Value
                        Addon:Update()
                    elseif Addon.Mode == "Toggle" and not Toggle.Value then
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Addon.Toggled = false
                        Addon:Update()
                    end
                end
            end

            if not Toggle.Disabled then
                Library:UpdateDependencyBoxes()
            end

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            Library:UpdateAddons(Toggle)

            Button.Active = not Toggle.Disabled
            Toggle:Display()

            Library:UpdateDependencyBoxes()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then
                Toggle.TooltipTable:Destroy()
            end

            if Button then
                Button:Destroy()
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddToggle(Idx, Info)
        if self.Destroyed then return nil end

        if Library.ForceCheckbox then
            return Funcs.AddCheckbox(self, Idx, Info)
        end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Switch",
            Type = "Toggle",

            Parent = Groupbox,
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -38, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Switch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(32, 18),
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Switch,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = Switch,
        })
        local SwitchStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Switch,
        })

        local Ball = New("Frame", {
            BackgroundColor3 = "FontColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Switch,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Ball,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            local Offset = Toggle.Value and 1 or 0

            Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
            SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

            Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
            SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

            Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
            Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                Ball.AnchorPoint = Vector2.new(Offset, 0)
                Ball.Position = UDim2.fromScale(Offset, 0)

                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                Library.Registry[Ball].BackgroundColor3 = function()
                    return Library:GetDarkerColor(Library.Scheme.FontColor)
                end

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(Ball, Library.TweenInfo, {
                AnchorPoint = Vector2.new(Offset, 0),
                Position = UDim2.fromScale(Offset, 0),
            }):Play()

            Ball.BackgroundColor3 = Library.Scheme.FontColor
            Library.Registry[Ball].BackgroundColor3 = "FontColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            if Toggle.Disabled then
                return
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" then
                    if Addon.SyncToggleState then
                        Addon.Toggled = Toggle.Value
                        Addon:Update()
                    elseif Addon.Mode == "Toggle" and not Toggle.Value then
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        Addon.Toggled = false
                        Addon:Update()
                    end
                end
            end

            if not Toggle.Disabled then
                Library:UpdateDependencyBoxes()
            end

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            Library:UpdateAddons(Toggle)

            Button.Active = not Toggle.Disabled
            Toggle:Display()

            Library:UpdateDependencyBoxes()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then
                Toggle.TooltipTable:Destroy()
            end

            if Button then
                Button:Destroy()
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddInput(Idx, Info)
        if self.Destroyed then return nil end

        if typeof(Info) == "table" and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true) then
            Info.Finished = true
        end

        Info = Library:Validate(Info, Templates.Input)

        local Groupbox = self
        local Container = Groupbox.Container

        local Input = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Finished = Info.Finished,
            Numeric = Info.Numeric,
            ClearTextOnFocus = Info.ClearTextOnFocus,
            ClearTextOnBlur = Info.ClearTextOnBlur,
            Placeholder = Info.Placeholder,
            AllowEmpty = Info.AllowEmpty,
            EmptyReset = Info.EmptyReset,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,
            VerifyValue = Info.VerifyValue,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},

            Holder = nil,
            Label = nil,
            Container = nil,

            Type = "Input",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 39),
            Visible = Input.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Input.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        local Box = New("TextBox", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
            PlaceholderText = Input.Placeholder,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = Input.Value,
            TextEditable = not Input.Disabled,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local BoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            })
        )

        function Input:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Input.Disabled and 0.8 or 0
            Box.TextTransparency = Input.Disabled and 0.8 or 0
            BoxStroke.Transparency = Input.Disabled and 0.5 or 0

            Box.BackgroundColor3 = Input.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
            Library.Registry[Box].BackgroundColor3 = Input.Disabled and "BackgroundColor" or "MainColor"
        end

        function Input:OnChanged(Func)
            Input.Changed = Func
        end

        function Input:RunChanged()
            if Input.Disabled then
                return
            end

            Library:SafeCallback(Input.Callback, Input.Value)
            Library:SafeCallback(Input.Changed, Input.Value)
        end

        function Input:SetValue(Text)
            if not Input.AllowEmpty and Trim(Text) == "" then
                Text = Input.EmptyReset
            end

            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength)
            end

            if Input.Numeric then
                if #tostring(Text) > 0 and not tonumber(Text) then
                    Text = Input.Value
                end
            end

            if typeof(Info.VerifyValue) == "function" and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true) then
                Text = Input.EmptyReset
            end

            Input.Value = Text
            Box.Text = Text

            Input:RunChanged()
        end

        function Input:SetDisabled(Disabled: boolean)
            Input.Disabled = Disabled

            if Input.TooltipTable then
                Input.TooltipTable.Disabled = Input.Disabled
            end

            Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
            Box.TextEditable = not Input.Disabled
            Input:UpdateColors()

            Library:UpdateAddons(Input)
        end

        function Input:SetVisible(Visible: boolean)
            Input.Visible = Visible

            Holder.Visible = Input.Visible
            Groupbox:Resize()
        end

        function Input:SetText(Text: string)
            Input.Text = Text
            Label.Text = Text
        end

        if Input.Finished then
            table.insert(Input.Connections, Box.FocusLost:Connect(function(Enter)
                if not Enter then
                    if Input.ClearTextOnBlur then
                        Box.Text = Input.Value
                    end

                    return
                end

                Input:SetValue(Box.Text)
            end))
        else
            table.insert(Input.Connections, Box:GetPropertyChangedSignal("Text"):Connect(function()
                if Box.Text == Input.Value then return end

                Input:SetValue(Box.Text)
            end))
        end

        table.insert(Input.Connections, Box.Focused:Connect(function()
            if Input.Disabled then
                return
            end

            Library.Registry[BoxStroke].Color = "AccentColor"
            TweenService:Create(BoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.AccentColor,
            }):Play()
        end))

        table.insert(Input.Connections, Box.FocusLost:Connect(function()
            if Input.Disabled then
                return
            end

            Library.Registry[BoxStroke].Color = "OutlineColor"
            TweenService:Create(BoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.OutlineColor,
            }):Play()
        end))

        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
            Input.TooltipTable.Disabled = Input.Disabled
        end

        Groupbox:Resize()

        Input.Holder = Holder
        Input.Label = Label
        Input.Container = Box

        Input.AddSettings = BaseAddons.__index.AddSettings
        table.insert(Groupbox.Elements, Input)

        Input.Default = Input.Value
        if typeof(Info.VerifyValue) == "function" and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true) then
            Input:SetValue(Input.EmptyReset)
            Input.Default = Input.EmptyReset
        end

        Input:UpdateColors()
        Options[Idx] = Input

        function Input:Destroy()
            Input.Destroyed = true

            if Input.Connections then
                for _, Connection in Input.Connections do
                    Connection:Disconnect()
                end
            end

            if Input.Addons then
                for Index = #Input.Addons, 1, -1 do
                    local Addon = table.remove(Input.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if Input.TooltipTable then
                Input.TooltipTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Input)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Input
    end

    function Funcs:AddSlider(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Slider)

        local Groupbox = self
        local Container = Groupbox.Container

        local Slider = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Min = Info.Min,
            Max = Info.Max,

            Prefix = Info.Prefix,
            Suffix = Info.Suffix,
            Compact = Info.Compact,
            Rounding = Info.Rounding,
            HideMax = Info.HideMax,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            AllowRightClickInput = Info.AllowRightClickInput,

            Type = "Slider",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
            Visible = Slider.Visible,
            Parent = Container,
        })

        local SliderLabel
        if not Info.Compact then
            SliderLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Slider.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
        end

        local Bar = New("TextButton", {
            Active = not Slider.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 15),
            Text = "",
            Parent = Holder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Bar,
        })

        local DisplayLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            ZIndex = Bar.ZIndex + 2,
            Parent = Bar,
        })
        New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = GetTextStrokeColor,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = DisplayLabel,
        })

        local InputTextBox
        if Info.AllowRightClickInput then
            InputTextBox = New("TextBox", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextSize = 14,
                ZIndex = Bar.ZIndex + 3,
                Visible = false,
                ClearTextOnFocus = false,
                Parent = Bar,
            })
            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = GetTextStrokeColor,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = InputTextBox,
            })
        end

        local Fill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            Size = UDim2.fromScale(0.5, 1),
            ZIndex = Bar.ZIndex + 1,
            Parent = Bar,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Bar,
            })
        )

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Fill,
            })
        )

        function Slider:UpdateColors()
            if Library.Unloaded then
                return
            end

            if SliderLabel then
                SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            end
            DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            
            if Info.AllowRightClickInput then
                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
            end

            if Info.AllowRightClickInput then
                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
            end

            Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
            Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
        end

        function Slider:Display()
            if Library.Unloaded then
                return
            end

            local CustomDisplayText = nil
            if Info.FormatDisplayValue then
                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
            end

            if CustomDisplayText then
                DisplayLabel.Text = tostring(CustomDisplayText)
            else
                if Info.Compact then
                    DisplayLabel.Text =
                        string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
                elseif Info.HideMax then
                    DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                else
                    DisplayLabel.Text = string.format(
                        "%s%s%s/%s%s%s",
                        Slider.Prefix,
                        Slider.Value,
                        Slider.Suffix,
                        Slider.Prefix,
                        Slider.Max,
                        Slider.Suffix
                    )
                end
            end

            local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Fill.Size = UDim2.fromScale(X, 1)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func
        end

        function Slider:SetMax(Value)
            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

            Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
            Slider.Max = Value
            Slider:Display()
        end

        function Slider:SetMin(Value)
            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

            Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
            Slider.Min = Value
            Slider:Display()
        end

        function Slider:RunChanged()
            if Slider.Disabled then
                return
            end

            Library:SafeCallback(Slider.Callback, Slider.Value)
            Library:SafeCallback(Slider.Changed, Slider.Value)
        end

        function Slider:SetValue(Str)
            local Num = tonumber(Str)
            if not Num or Num == Slider.Value then
                return
            end

            Num = math.clamp(Num, Slider.Min, Slider.Max)

            Slider.Value = Num
            Slider:Display()

            Slider:RunChanged()
        end

        function Slider:SetDisabled(Disabled: boolean)
            Slider.Disabled = Disabled

            if Slider.TooltipTable then
                Slider.TooltipTable.Disabled = Slider.Disabled
            end

            Bar.Active = not Slider.Disabled
            Slider:UpdateColors()
        end

        function Slider:SetVisible(Visible: boolean)
            Slider.Visible = Visible

            Holder.Visible = Slider.Visible
            Groupbox:Resize()
        end

        function Slider:SetText(Text: string)
            Slider.Text = Text
            if SliderLabel then
                SliderLabel.Text = Text
                return
            end
            Slider:Display()
        end

        function Slider:SetPrefix(Prefix: string)
            Slider.Prefix = Prefix
            Slider:Display()
        end

        function Slider:SetSuffix(Suffix: string)
            Slider.Suffix = Suffix
            Slider:Display()
        end

        if Info.AllowRightClickInput then
            local LastValidText = ""
            table.insert(Slider.Connections, InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
                local Text = InputTextBox.Text
                local AsNum = tonumber(Text)

                if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
                    InputTextBox.Text = LastValidText
                else
                    if Slider.Rounding == 0 and Text:find("%.") then
                        InputTextBox.Text = LastValidText
                        return
                    end

                    local DecimalPos = Text:find("%.")
                    if DecimalPos and Slider.Rounding > 0 then
                        local Decimals = #Text - DecimalPos
                        if Decimals > Slider.Rounding then
                            InputTextBox.Text = LastValidText
                            return
                        end
                    end

                    LastValidText = Text
                end
            end))

            table.insert(Slider.Connections, InputTextBox.FocusLost:Connect(function()
                InputTextBox.Visible = false
                DisplayLabel.Visible = true

                local Num = tonumber(InputTextBox.Text)
                if not Num then
                    return
                end

                Num = Round(Num, Slider.Rounding)
                Slider:SetValue(Num)
            end))
        end

        local LastTap = 0
        table.insert(Slider.Connections, Bar.InputBegan:Connect(function(Input: InputObject)
            local ValidInput = IsClickInput(Input) or Input.UserInputType == Enum.UserInputType.MouseButton2
            if not ValidInput or Slider.Disabled then
                return
            end

            if Info.AllowRightClickInput then
                local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
                local IsDoubleTap = false

                if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
                    if tick() - LastTap < 0.3 then
                        IsDoubleTap = true
                    end

                    LastTap = tick()
                end

                if IsRightClick or IsDoubleTap then
                    InputTextBox.Text = tostring(Slider.Value)
                    InputTextBox.Visible = true
                    DisplayLabel.Visible = false

                    task.spawn(InputTextBox.CaptureFocus, InputTextBox)
                    return
                end
            end

            if not IsClickInput(Input) then
                return
            end

            if Library.ActiveTab then
                for _, Side in Library.ActiveTab.Sides do
                    Side.ScrollingEnabled = false
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
            end

            while IsDragInput(Input) and not Slider.Destroyed do
                local Location = Mouse.X
                local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                local OldValue = Slider.Value
                Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

                Slider:Display()
                if Slider.Value ~= OldValue then
                    Slider:RunChanged()
                end

                RunService.RenderStepped:Wait()
            end

            if Library.ActiveTab then
                for _, Side in Library.ActiveTab.Sides do
                    Side.ScrollingEnabled = true
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
            end
        end))

        if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
            Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
            Slider.TooltipTable.Disabled = Slider.Disabled
        end

        Slider:UpdateColors()
        Slider:Display()
        Groupbox:Resize()

        Slider.Holder = Holder
        table.insert(Groupbox.Elements, Slider)

        Slider.Default = Slider.Value

        Options[Idx] = Slider

        function Slider:Destroy()
            Slider.Destroyed = true

            if Slider.Connections then
                for _, Connection in Slider.Connections do
                    Connection:Disconnect()
                end
            end

            if Slider.TooltipTable then
                Slider.TooltipTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Slider)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Slider
    end

    function Funcs:AddDropdown(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Dropdown)
        Info.FormatDisplayValue = Info.FormatDisplayValue or Info.FormatValue
        Info.FormatListValue = Info.FormatListValue or Info.FormatValue

        local Groupbox = self
        local Container = Groupbox.Container

        if Info.SpecialType == "Player" then
            Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams()
            Info.AllowNull = true
        end

        local Dropdown = {
            Connections = {},
            Destroyed = false,

            Text = typeof(Info.Text) == "string" and Info.Text or nil,

            Value = Info.Multi and {} or nil,
            Values = Info.Values,
            DisabledValues = Info.DisabledValues,
            ValueImages = Info.ValueImages,

            Multi = Info.Multi,
            DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,
            KeepDisabledValuePosition = Info.KeepDisabledValuePosition == true,

            SpecialType = Info.SpecialType,
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
            EnablePlayerImages = Info.EnablePlayerImages,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},

            Holder = nil,
            Label = nil,
            Container = nil,

            Type = "Dropdown",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
            Visible = Dropdown.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Dropdown.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not not Info.Text,
            ZIndex = 3,
            Parent = Holder,
        })

        local DisplayContainer = New("TextButton", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = "",
            TextTransparency = 1,
            ZIndex = 2,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 4),
            Parent = DisplayContainer,
        })

        local DisplayStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = DisplayContainer,
        })

        local DropdownCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = DisplayContainer,
        }); table.insert(Library.SpecificCorners, DropdownCorner)

        local DisplayImage = Library:CreateIcon(nil, {
            Position = UDim2.fromOffset(-4, 3),
            Size = UDim2.fromOffset(16, 16),
            ImageTransparency = 1,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local DisplayButton = New("TextButton", {
            Active = not Dropdown.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Text = "---",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local ArrowImage = Library:CreateIcon(ArrowIcon, {
            AnchorPoint = Vector2.new(1, 0.5),
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = DisplayContainer,
        })

        local SearchBox
        if Info.Searchable then
            SearchBox = New("TextBox", {
                BackgroundTransparency = 1,
                PlaceholderText = "搜索...",
                Position = UDim2.fromOffset(-8, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false,
                Parent = DisplayButton,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                Parent = SearchBox,
            })

            table.insert(Dropdown.Connections, SearchBox.Focused:Connect(function()
                Library.Registry[DisplayStroke].Color = "AccentColor"
                TweenService:Create(DisplayStroke, Library.TweenInfo, {
                    Color = Library.Scheme.AccentColor,
                }):Play()
            end))

            table.insert(Dropdown.Connections, SearchBox.FocusLost:Connect(function()
                Library.Registry[DisplayStroke].Color = "OutlineColor"
                TweenService:Create(DisplayStroke, Library.TweenInfo, {
                    Color = Library.Scheme.OutlineColor,
                }):Play()
            end))
        end

        local GetValueImage = function(Value, RawValue)
            if not Value then
                return nil
            end

            local ValueImage = nil
            if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
                local PlayerValue = Value
                if typeof(PlayerValue) ~= "Instance" and RawValue ~= nil then
                    PlayerValue = RawValue
                end

                if typeof(PlayerValue) == "Instance" and PlayerValue:IsA("Player") then
                    ValueImage = { Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(PlayerValue.UserId)) }
                end
            end

            if Dropdown.ValueImages then
                local IconRef = Dropdown.ValueImages[Value]
                if IconRef == nil and RawValue ~= nil then
                    IconRef = Dropdown.ValueImages[RawValue]
                end

                if IconRef then
                    ValueImage = Library:GetCustomIcon(IconRef)
                end
            end

            return ValueImage
        end

        local MenuTable
        MenuTable = Library:AddContextMenu(
            DisplayContainer,
            function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
            end,
            function()
                return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
            end,
            2,
            function(Active: boolean)
                DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

                SetIconProperties(ArrowImage, { ImageTransparency = Active and 0 or 0.5, Rotation = Active and 180 or 0 })

                if SearchBox then
                    SearchBox.Text = ""
                    SearchBox.Visible = Active
                end

                local Half = UDim.new(0, Library.CornerRadius / 2)
                local Zero = UDim.new(0, 0)

                DropdownCorner.TopLeftRadius = Half
                DropdownCorner.TopRightRadius = Half
                DropdownCorner.BottomRightRadius = Active and Zero or Half
                DropdownCorner.BottomLeftRadius = Active and Zero or Half

                local MenuCorner = MenuTable and MenuTable.Corner
                if MenuCorner then
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.TopRightRadius = Zero
                    MenuCorner.BottomRightRadius = Half
                    MenuCorner.BottomLeftRadius = Half
                end
            end,
            false,
            "bottom",
            "Dropdown"
        )
        Dropdown.Menu = MenuTable

        local ItemHeight = 21
        local PoolSize = math.max(1, Info.MaxVisibleDropdownItems + 2)
        local Pool = {}
        local FilteredEntries = {}
        local TextWidths = {}

        local function GetListWidth()
            local Width = DisplayContainer.AbsoluteSize.X / Library.DPIScale
            if not Info.AutoWidth then
                return Width
            end

            for _, Entry in FilteredEntries do
                local TextWidth = TextWidths[Entry.FormattedValue]
                if not TextWidth then
                    TextWidth = Library:GetTextBounds(Entry.FormattedValue, Library.Scheme.Font, 14)
                    TextWidths[Entry.FormattedValue] = TextWidth
                end

                local Extra = 16
                if Entry.ValueImage then
                    Extra += 18
                end

                if Entry.IsDivider and Entry.Title then
                    Extra += 40
                end

                Width = math.max(Width, TextWidth + Extra)
            end

            return math.ceil(Width)
        end

        function Dropdown:RecalculateListSize(Count)
            local ItemCount = Count or #FilteredEntries
            local Y = math.clamp(ItemCount * ItemHeight, 0, Info.MaxVisibleDropdownItems * ItemHeight)

            MenuTable.Menu.CanvasSize = UDim2.fromOffset(0, ItemCount * ItemHeight)

            MenuTable:SetSize(function()
                return UDim2.fromOffset(GetListWidth(), Y)
            end)
        end

        function Dropdown:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
            SetIconProperties(DisplayImage, { ImageTransparency = Dropdown.Disabled and 0.8 or 0 })
            SetIconProperties(ArrowImage, { ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5 })
        end

        function Dropdown:Display()
            if Library.Unloaded then
                return
            end

            local Str = ""
            local ValueImage = nil
            local IsDictionary = not IsSequentialArray(Dropdown.Values)

            if Info.Multi then
                for Key, RawValue in Dropdown.Values do
                    local Value = IsDictionary and Key or RawValue

                    if not IsDropdownDivider(RawValue) and Dropdown.Value[Value] then
                        if not ValueImage then
                            ValueImage = GetValueImage(Value, RawValue)
                        end

                        Str = Str
                            .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(RawValue)) or tostring(RawValue))
                            .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
            else
                local DisplayValue = Dropdown.Value
                if IsDictionary and Dropdown.Value ~= nil then
                    DisplayValue = Dropdown.Values[Dropdown.Value]
                end

                ValueImage = GetValueImage(Dropdown.Value, DisplayValue)
                Str = DisplayValue and tostring(DisplayValue) or ""

                if Str ~= "" and Info.FormatDisplayValue then
                    Str = tostring(Info.FormatDisplayValue(Str))
                end
            end

            local PlainStr = Str:gsub("<[^>]*>", "")
            if utf8.len(PlainStr) and utf8.len(PlainStr) > 25 then
                Str = PlainStr:sub(1, utf8.offset(PlainStr, 23) - 1) .. "..."
            end

            DisplayButton.Text = (Str == "" and "---" or Str)

            DisplayImage = Library:ApplyIcon(DisplayImage, ValueImage)
            SetIconProperties(DisplayImage, { ImageTransparency = if ValueImage then 0 else 1 })

            DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
            DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func
        end

        function Dropdown:GetActiveValues(ReturnCount)
            local Table = {}

            if Info.Multi then
                for Value, _ in Dropdown.Value do
                    table.insert(Table, Value)
                end
            else
                if Dropdown.Value then
                    table.insert(Table, Dropdown.Value)
                end
            end

            return ReturnCount == true and GetTableSize(Table) or Table
        end

        local DragSelecting = false
        local DragStartIndex = nil
        local DragPrevMin = nil
        local DragPrevMax = nil
        local DragLastIndex = nil
        local DragInitialValues = {}
        local DragInputEndedConn = nil
        local DragInputChangedConn = nil

        local function RecomputeFilteredEntries()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues
            local IsDictionary = not IsSequentialArray(Values)

            
            
            local SearchQuery = SearchBox and NormalizeSearch(LowerText(SearchBox.Text)) or ""
            local IsSearching = SearchQuery ~= ""

            local Keys = {}
            for Key in Values do
                table.insert(Keys, Key)
            end

            if not IsDictionary then
                table.sort(Keys)
            end

            local Groups = { { Items = {} } }
            local Count = 0

            for _, Key in Keys do
                local RawValue = Values[Key]

                if IsDropdownDivider(RawValue) then
                    if not IsDictionary then
                        local Title = RawValue.Title and tostring(RawValue.Title) or nil

                        table.insert(Groups, {
                            Divider = {
                                IsDivider = true,
                                Title = Title,
                                FormattedValue = Title or "",
                            },
                            Items = {},
                        })
                    end

                    continue
                end

                local Value = IsDictionary and Key or RawValue

                local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(RawValue) or RawValue)

                local MatchScore = 0
                if IsSearching then
                    local Matched, Score = FuzzyScore(LowerText((FormattedValue:gsub("<[^>]*>", ""))), SearchQuery)
                    if not Matched then
                        continue
                    end
                    MatchScore = Score
                end

                local IsDisabled = table.find(DisabledValues, Value) ~= nil
                    or (RawValue ~= nil and RawValue ~= Value and table.find(DisabledValues, RawValue) ~= nil)

                local Entry = {
                    Value = Value,
                    RawValue = RawValue,
                    FormattedValue = FormattedValue,
                    IsDisabled = IsDisabled,
                    ValueImage = GetValueImage(Value, RawValue),
                    MatchScore = MatchScore,
                    Order = Count + 1,
                }

                Count += 1
                table.insert(Groups[#Groups].Items, Entry)
            end

            table.clear(FilteredEntries)

            for _, Group in Groups do
                local Items = Group.Items
                if IsSearching then
                    if #Items == 0 then
                        continue
                    end

                    
                    table.sort(Items, function(A, B)
                        if A.MatchScore ~= B.MatchScore then
                            return A.MatchScore > B.MatchScore
                        end
                        return A.Order < B.Order
                    end)
                end

                if Group.Divider then
                    table.insert(FilteredEntries, Group.Divider)
                end

                if Dropdown.KeepDisabledValuePosition then
                    for _, Entry in Items do
                        table.insert(FilteredEntries, Entry)
                    end

                    continue
                end

                for _, Entry in Items do
                    if not Entry.IsDisabled then
                        table.insert(FilteredEntries, Entry)
                    end
                end

                for _, Entry in Items do
                    if Entry.IsDisabled then
                        table.insert(FilteredEntries, Entry)
                    end
                end
            end
        end

        local function GetFirstVisibleIndex()
            local Total = #FilteredEntries
            if Total <= PoolSize then
                return 1
            end

            local MaxFirst = Total - PoolSize + 1
            local ScrollY = MenuTable.Menu.CanvasPosition.Y / Library.DPIScale
            local Index = math.floor(ScrollY / ItemHeight) + 1
            return math.clamp(Index, 1, MaxFirst)
        end

        function Dropdown:RefreshPool()
            local Total = #FilteredEntries
            local First = GetFirstVisibleIndex()

            for SlotIndex, Row in Pool do
                local DataIndex = First + SlotIndex - 1
                local Entry = FilteredEntries[DataIndex]

                Row.Entry = Entry
                Row.Index = Entry and DataIndex or nil

                if not Entry then
                    Row.Container.Visible = false
                    continue
                end

                Row.Container.Visible = true
                Row.Container.Position = UDim2.fromOffset(0, (DataIndex - 1) * ItemHeight)

                local IsLast = DataIndex == Total
                Row.Corner.BottomRightRadius = IsLast and UDim.new(0, Library.CornerRadius / 2) or UDim.new(0, 0)
                Row.Corner.BottomLeftRadius = IsLast and UDim.new(0, Library.CornerRadius / 2) or UDim.new(0, 0)

                Row.Button.Text = Entry.FormattedValue
                Row.Button.TextXAlignment = Entry.IsDivider and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
                Row.LeftLine.Visible = Entry.IsDivider == true
                Row.RightLine.Visible = Entry.IsDivider == true and Entry.Title ~= nil

                if Entry.IsDivider then
                    Row.Image.Visible = false
                    Row.Button.Size = UDim2.new(1, 0, 0, ItemHeight - 1)
                    Row.Button.Position = UDim2.fromOffset(0, 0)

                    if Entry.Title then
                        local TitleWidth = Library:GetTextBounds(Entry.Title, Library.Scheme.Font, 14)
                        local HalfWidth = TitleWidth // 2 + 10

                        Row.LeftLine.Size = UDim2.new(0.5, -7 - HalfWidth, 0, 2)
                        Row.RightLine.Size = UDim2.new(0.5, -7 - HalfWidth, 0, 2)
                    else
                        Row.LeftLine.Size = UDim2.new(1, -14, 0, 2)
                    end

                    Row:UpdateButton()
                    continue
                end

                if Entry.ValueImage then
                    Row.Image = Library:ApplyIcon(Row.Image, Entry.ValueImage)
                    Row.Image.Visible = true
                    Row.Button.Size = UDim2.new(1, -18, 0, ItemHeight)
                    Row.Button.Position = UDim2.fromOffset(18, 0)
                else
                    Row.Image.Visible = false
                    Row.Button.Size = UDim2.new(1, 0, 0, ItemHeight)
                    Row.Button.Position = UDim2.fromOffset(0, 0)
                end

                Row:UpdateButton()
            end
        end

        function Dropdown:RunChanged()
            if Dropdown.Disabled then
                return
            end

            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
        end

        local function StopDragSelect()
            DragSelecting = false
            DragStartIndex = nil
            DragPrevMin = nil
            DragPrevMax = nil
            DragLastIndex = nil
            table.clear(DragInitialValues)

            if DragInputEndedConn then
                DragInputEndedConn:Disconnect()
                DragInputEndedConn = nil
            end

            if DragInputChangedConn then
                DragInputChangedConn:Disconnect()
                DragInputChangedConn = nil
            end
        end

        local DragActiveCount = 0

        local function ApplyDragIndex(Index, InRange)
            local Entry = FilteredEntries[Index]
            if not Entry or Entry.IsDisabled or Entry.IsDivider then
                return
            end

            local Try = DragInitialValues[Entry.Value]
            if InRange then
                Try = not Try
            end

            local WantActive = Try and true or false
            local IsActive = Dropdown.Value[Entry.Value] and true or false
            if WantActive == IsActive then
                return
            end

            if not WantActive and DragActiveCount == 1 and not Info.AllowNull then
                return
            end

            Dropdown.Value[Entry.Value] = WantActive and true or nil
            DragActiveCount += WantActive and 1 or -1
        end

        local function ApplyDragRange(From, To, InRange)
            for Index = From, To do
                ApplyDragIndex(Index, InRange)
            end
        end

        local function UpdateDrag(CurrentIndex)
            if CurrentIndex == nil or CurrentIndex == DragLastIndex then
                return
            end

            DragLastIndex = CurrentIndex

            local Min = math.min(DragStartIndex, CurrentIndex)
            local Max = math.max(DragStartIndex, CurrentIndex)
            DragActiveCount = Dropdown:GetActiveValues(true)

            if DragPrevMin == nil then
                ApplyDragRange(Min, Max, true)
            else
                if DragPrevMin < Min then
                    ApplyDragRange(DragPrevMin, Min - 1, false)
                end
                if DragPrevMax > Max then
                    ApplyDragRange(Max + 1, DragPrevMax, false)
                end
                if Min < DragPrevMin then
                    ApplyDragRange(Min, DragPrevMin - 1, true)
                end
                if Max > DragPrevMax then
                    ApplyDragRange(DragPrevMax + 1, Max, true)
                end
            end

            DragPrevMin = Min
            DragPrevMax = Max

            for _, OtherRow in Pool do
                OtherRow:UpdateButton()
            end
        end

        local function CreatePoolRow()
            local Row = {
                Entry = nil,
                Index = nil
            }

            local Container = New("Frame", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ItemHeight),
                Visible = false,
                Parent = MenuTable.Menu,
            })

            local Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Container,
            }); table.insert(Library.SpecificCorners, Corner)

            local Image = Library:CreateIcon(nil, {
                ImageTransparency = 0.5,
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromOffset(4, 3),
                Visible = false,
                Parent = Container,
            })

            local Button = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ItemHeight),
                RichText = true,
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Container,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                Parent = Button,
            })

            local LeftLine = New("Frame", {
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromOffset(7, (ItemHeight - 1) / 2 - 1),
                Visible = false,
                Parent = Container,
            })

            local RightLine = New("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.new(1, -7, 0, (ItemHeight - 1) / 2 - 1),
                Visible = false,
                Parent = Container,
            })

            Row.Container = Container
            Row.Corner = Corner
            Row.Image = Image
            Row.Button = Button
            Row.LeftLine = LeftLine
            Row.RightLine = RightLine

            function Row:UpdateButton()
                local Entry = Row.Entry
                if not Entry then
                    return
                end

                if Entry.IsDivider then
                    Row.Selected = false
                    Container.BackgroundTransparency = 1
                    Button.TextTransparency = 0.5
                    return
                end

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Entry.Value]
                else
                    Selected = Dropdown.Value == Entry.Value
                end

                Row.Selected = Selected and true or false

                Container.BackgroundTransparency = Selected and 0 or 1
                Button.TextTransparency = Entry.IsDisabled and 0.8 or Selected and 0 or 0.5

                if Entry.ValueImage then
                    SetIconProperties(Row.Image, { ImageTransparency = Entry.IsDisabled and 0.8 or Selected and 0 or 0.5 })
                end
            end

            table.insert(Dropdown.Connections, Button.MouseButton1Click:Connect(function()
                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled or Entry.IsDivider or DragSelecting then
                    return
                end

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Entry.Value]
                else
                    Selected = Dropdown.Value == Entry.Value
                end

                local Try = not Selected
                if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                    Selected = Try
                    if Info.Multi then
                        Dropdown.Value[Entry.Value] = Selected and true or nil
                    else
                        Dropdown.Value = Selected and Entry.Value or nil
                    end

                    for _, OtherRow in Pool do
                        OtherRow:UpdateButton()
                    end
                end

                Row:UpdateButton()
                Dropdown:Display()

                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end))

            table.insert(Dropdown.Connections, Button.MouseEnter:Connect(function()
                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled or Entry.IsDivider then
                    return
                end

                if Row.Selected then
                    return
                end

                TweenService:Create(Container, Library.TweenInfo, {
                    BackgroundTransparency = 0.85,
                }):Play()
                TweenService:Create(Button, Library.TweenInfo, {
                    TextTransparency = 0.25,
                }):Play()

                TweenIcon(Row.Image, { ImageTransparency = 0.25 })
            end))

            table.insert(Dropdown.Connections, Button.MouseLeave:Connect(function()
                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled or Entry.IsDivider then
                    return
                end

                if Row.Selected then
                    return
                end

                TweenService:Create(Container, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(Button, Library.TweenInfo, {
                    TextTransparency = 0.5,
                }):Play()

                TweenIcon(Row.Image, { ImageTransparency = 0.5 })
            end))

            table.insert(Dropdown.Connections, Button.InputBegan:Connect(function(StartInput)
                if not (Info.Multi and Dropdown.DragSelect and not Library.IsMobile) then
                    return
                end

                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled or Entry.IsDivider then
                    return
                end

                if not IsMouseInput(StartInput) then
                    return
                end

                DragSelecting = true
                DragStartIndex = Row.Index
                table.clear(DragInitialValues)

                for _, FilteredEntry in FilteredEntries do
                    if FilteredEntry.IsDivider then continue end
                    DragInitialValues[FilteredEntry.Value] = Dropdown.Value[FilteredEntry.Value]
                end

                UpdateDrag(Row.Index)

                if DragInputEndedConn then DragInputEndedConn:Disconnect() end
                if DragInputChangedConn then DragInputChangedConn:Disconnect() end

                DragInputChangedConn = Library:GiveSignal(UserInputService.InputChanged:Connect(function(ChangeInput)
                    if not IsMovementInput(ChangeInput) and ChangeInput ~= StartInput then
                        return
                    end

                    local Pos = ChangeInput.Position
                    for _, OtherRow in Pool do
                        if OtherRow.Entry and Library:MouseIsOverFrame(OtherRow.Button, Pos) then
                            UpdateDrag(OtherRow.Index)
                            break
                        end
                    end
                end))

                DragInputEndedConn = Library:GiveSignal(UserInputService.InputEnded:Connect(function(EndInput)
                    if EndInput ~= StartInput and not (IsMouseInput(EndInput) and EndInput.UserInputType == StartInput.UserInputType) then
                        return
                    end

                    Dropdown:Display()
                    Library:UpdateDependencyBoxes()
                    Dropdown:RunChanged()

                    StopDragSelect()
                end))

                table.insert(Dropdown.Connections, DragInputEndedConn)
                table.insert(Dropdown.Connections, DragInputChangedConn)
            end))

            return Row
        end

        function Dropdown:BuildDropdownList()
            StopDragSelect()

            RecomputeFilteredEntries()

            MenuTable.Menu.CanvasPosition = Vector2.new(0, 0)

            Dropdown:RefreshPool()
            Dropdown:RecalculateListSize(#FilteredEntries)
        end

        for _ = 1, PoolSize do
            table.insert(Pool, CreatePoolRow())
        end

        table.insert(Dropdown.Connections, MenuTable.Menu:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            Dropdown:RefreshPool()
        end))

        local function ValueExists(Val)
            if IsDropdownDivider(Val) then
                return false
            end

            if IsSequentialArray(Dropdown.Values) then
                for _, Existing in Dropdown.Values do
                    if Existing == Val then
                        return true
                    end
                end

                return false
            end

            return Dropdown.Values[Val] ~= nil
        end

        function Dropdown:SetValue(Value)
            if Info.Multi then
                if typeof(Value) == "string" then
                    Value = if Value == "" then {} else { [Value] = true }
                end

                local Table = {}
				
                for Val, Active in Value or {} do
                    if typeof(Active) ~= "boolean" then
                        Table[Active] = true
                    elseif Active and ValueExists(Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if ValueExists(Value) then
                    Dropdown.Value = Value
                elseif not Value then
                    Dropdown.Value = nil
                end
            end

            Dropdown:Display()
            for _, Row in Pool do
                Row:UpdateButton()
            end

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
            end

            Dropdown:RunChanged()
        end

        function Dropdown:SetValues(Values)
            Dropdown.Values = Values

            local Changed = false
            if Info.Multi then
                for Val in Dropdown.Value do
                    if not ValueExists(Val) then
                        Dropdown.Value[Val] = nil
                        Changed = true
                    end
                end

            elseif Dropdown.Value ~= nil and not ValueExists(Dropdown.Value) then
                Dropdown.Value = nil
                Changed = true
            end

            Dropdown:BuildDropdownList()
            Dropdown:Display()

            if Changed and not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
            end

            if Changed then
                Dropdown:RunChanged()
            end
        end

        function Dropdown:AddValues(Values)
            if typeof(Values) ~= "table" and typeof(Values) ~= "string" then
                return
            end

            local IsDictionary = not IsSequentialArray(Dropdown.Values)
            if IsDictionary then
                if typeof(Values) == "string" then
                    Dropdown.Values[Values] = Values

                elseif IsSequentialArray(Values) then
                    for _, Val in Values do
                        Dropdown.Values[Val] = Val
                    end

                else
                    for Key, Val in Values do
                        Dropdown.Values[Key] = Val
                    end
                end
            else
                if typeof(Values) == "table" then
                    for _, Val in Values do
                        table.insert(Dropdown.Values, Val)
                    end
                else
                    table.insert(Dropdown.Values, Values)
                end
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabledValues(DisabledValues)
            Dropdown.DisabledValues = DisabledValues
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in DisabledValues do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end

            Dropdown.ValueImages = ValueImages
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end

            for key, val in ValueImages do
                Dropdown.ValueImages[key] = val
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabled(Disabled: boolean)
            Dropdown.Disabled = Disabled

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
            end

            MenuTable:Close()
            DisplayButton.Active = not Dropdown.Disabled
            Dropdown:UpdateColors()
            Library:UpdateAddons(Dropdown)

            Library:UpdateDependencyBoxes()
        end

        function Dropdown:SetVisible(Visible: boolean)
            Dropdown.Visible = Visible

            Holder.Visible = Dropdown.Visible
            Groupbox:Resize()
        end

        function Dropdown:SetText(Text: string)
            Dropdown.Text = Text
            Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

            Label.Text = Text and Text or ""
            Label.Visible = not not Text
        end

        function Dropdown:SetDragSelect(Value: boolean)
            if not Info.Multi or Library.IsMobile then
                Value = false
            end

            Dropdown.DragSelect = Value == true
            Dropdown:BuildDropdownList()
        end

        local ToggleDropdown = function()
            if Dropdown.Disabled then
                return
            end

            MenuTable:Toggle()
        end

        table.insert(Dropdown.Connections, DisplayContainer.MouseButton1Click:Connect(ToggleDropdown))
        table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

        if SearchBox then
            table.insert(Dropdown.Connections, SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList))
        end

        local Defaults = (function()
            local Resolved = {}
            local Default = Info.Default
            if Default == nil then
                return Resolved
            end

            local IsDictionary = not IsSequentialArray(Dropdown.Values)
            local function ResolveOne(Candidate)
                if IsDictionary then
                    return Dropdown.Values[Candidate] ~= nil and Candidate or nil
                end

                for _, Existing in Dropdown.Values do
                    if Existing == Candidate then
                        return Existing
                    end
                end

                return nil
            end

            local DefaultType = typeof(Default)
            if DefaultType == "string" then
                local Value = ResolveOne(Default)
                if Value ~= nil then
                    table.insert(Resolved, Value)
                end

            elseif DefaultType == "table" then
                for _, Candidate in Default do
                    local Value = ResolveOne(Candidate)
                    if Value ~= nil then
                        table.insert(Resolved, Value)
                    end
                end

            elseif Dropdown.Values[Default] ~= nil and not IsDropdownDivider(Dropdown.Values[Default]) then
                table.insert(Resolved, IsDictionary and Default or Dropdown.Values[Default])
            end

            return Resolved
        end)()

        for _, SelectValue in Defaults do
            if Info.Multi then
                Dropdown.Value[SelectValue] = true
            else
                Dropdown.Value = SelectValue
                break
            end
        end

        if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
            Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
            Dropdown.TooltipTable.Disabled = Dropdown.Disabled
        end

        Dropdown:UpdateColors()
        Dropdown:Display()
        Dropdown:BuildDropdownList()
        Groupbox:Resize()

        Dropdown.Holder = Holder
        Dropdown.Label = Label
        Dropdown.Container = DisplayContainer

        Dropdown.AddSettings = BaseAddons.__index.AddSettings
        table.insert(Groupbox.Elements, Dropdown)

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = Dropdown.Values

        Options[Idx] = Dropdown

        function Dropdown:Destroy()
            Dropdown.Destroyed = true

            StopDragSelect()

            if Dropdown.Connections then
                for _, Connection in Dropdown.Connections do
                    Connection:Disconnect()
                end
            end

            if Dropdown.Addons then
                for Index = #Dropdown.Addons, 1, -1 do
                    local Addon = table.remove(Dropdown.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable:Destroy()
            end

            if MenuTable then
                MenuTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Dropdown)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Dropdown
    end

    function Funcs:AddViewport(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Viewport)

        local Groupbox = self
        local Container = Groupbox.Container

        local Dragging, Pinching = false, false
        local LastMousePos, LastPinchDist = nil, 0

        local ViewportObject = Info.Object
        if Info.Clone and typeof(Info.Object) == "Instance" then
            if Info.Object.Archivable then
                ViewportObject = ViewportObject:Clone()
            else
                Info.Object.Archivable = true
                ViewportObject = ViewportObject:Clone()
                Info.Object.Archivable = false
            end
        end

        local Viewport = {
            Connections = {},
            Destroyed = false,

            Object = ViewportObject :: PVInstance,
            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
            Interactive = Info.Interactive,
            AutoFocus = Info.AutoFocus,
            Visible = Info.Visible,
            Type = "Viewport",
        }

        assert(
            typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
            "Instance must be a BasePart or Model."
        )

        assert(
            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
            "Camera must be a valid Camera instance."
        )

        local function GetModelSize(model)
            if model:IsA("BasePart") then
                return model.Size
            end

            return select(2, model:GetBoundingBox())
        end

        local function FocusCamera()
            local ModelSize = GetModelSize(Viewport.Object)
            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
            local CameraDistance = MaxExtent * 2
            local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

            Viewport.Camera.CFrame = CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
        end

        local function GetPivotPosition()
            return (Viewport.Object :: PVInstance):GetPivot().Position
        end

        local function OrbitCamera(Yaw: number, Pitch: number)
            local Position = GetPivotPosition()
            local Camera = Viewport.Camera

            local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), Yaw)
            Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

            local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, Pitch)
            local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

            if PitchedCFrame.UpVector.Y > 0.1 then
                Camera.CFrame = PitchedCFrame
            end
        end

        local function ZoomCamera(Amount: number)
            Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * Amount
        end

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Viewport.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ViewportFrame = New("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Box,
            CurrentCamera = Viewport.Camera,
            Active = Viewport.Interactive,
        })

        table.insert(Viewport.Connections, ViewportFrame.MouseEnter:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in Groupbox.Tab.Sides do
                Side.ScrollingEnabled = false
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.MouseLeave:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in Groupbox.Tab.Sides do
                Side.ScrollingEnabled = true
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputBegan:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 or (input.UserInputType == Enum.UserInputType.Touch and not Pinching) then
                Dragging = true
                LastMousePos = input.Position
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputEnded:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputChanged:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Dragging or Pinching then
                return
            end

            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                local MouseDelta = input.Position - LastMousePos
                LastMousePos = input.Position

                OrbitCamera(-MouseDelta.X * 0.01, -MouseDelta.Y * 0.01)
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputChanged:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseWheel then
                ZoomCamera(input.Position.Z * 2)
            end
        end))

        table.insert(Viewport.Connections, UserInputService.TouchPinch:Connect(function(touchPositions, _, _, state)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
                return
            end

            if state == Enum.UserInputState.Begin then
                Pinching = true
                Dragging = false
                LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
            elseif state == Enum.UserInputState.Change then
                local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                local delta = (currentDist - LastPinchDist) * 0.1
                LastPinchDist = currentDist
                ZoomCamera(delta)
            elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                Pinching = false
            end
        end))

        ;(Viewport.Object :: PVInstance).Parent = ViewportFrame
        if Viewport.AutoFocus then
            FocusCamera()
        end

        function Viewport:SetObject(Object: Instance, Clone: boolean?)
            assert(Object, "Object cannot be nil.")

            if Clone then
                Object = Object:Clone()
            end

            if Viewport.Object then
                Viewport.Object:Destroy()
            end

            Viewport.Object = Object
            ;(Viewport.Object :: PVInstance).Parent = ViewportFrame

            Groupbox:Resize()
        end

        function Viewport:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Viewport:Focus()
            if not Viewport.Object then
                return
            end

            FocusCamera()
        end

        function Viewport:SetCamera(Camera: Instance)
            assert(
                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            Viewport.Camera = Camera
            ViewportFrame.CurrentCamera = Camera
        end

        function Viewport:SetCameraCFrame(NewCFrame: CFrame)
            assert(typeof(NewCFrame) == "CFrame", "CFrame must be a valid CFrame.")

            Viewport.Camera.CFrame = NewCFrame
        end

        function Viewport:GetCameraCFrame(): CFrame
            return Viewport.Camera.CFrame
        end

        function Viewport:Rotate(Yaw: number, Pitch: number?)
            if not Viewport.Object then
                return
            end

            OrbitCamera(math.rad(Yaw or 0), math.rad(Pitch or 0))
        end

        function Viewport:Zoom(Amount: number)
            assert(typeof(Amount) == "number", "Amount must be a number.")

            ZoomCamera(Amount)
        end

        function Viewport:LookAt(Target: Vector3?)
            if not Target and not Viewport.Object then
                return
            end

            Viewport.Camera.CFrame = CFrame.lookAt(Viewport.Camera.CFrame.Position, Target or GetPivotPosition())
        end

        function Viewport:SetDistance(Distance: number)
            assert(typeof(Distance) == "number" and Distance > 0, "Distance must be greater than 0.")
            if not Viewport.Object then
                return
            end

            local Position = GetPivotPosition()
            local Offset = Viewport.Camera.CFrame.Position - Position
            local Direction = Offset.Magnitude > 0 and Offset.Unit or -Viewport.Camera.CFrame.LookVector

            Viewport.Camera.CFrame = CFrame.lookAt(Position + Direction * Distance, Position)
        end

        function Viewport:GetDistance(): number
            if not Viewport.Object then
                return 0
            end

            return (Viewport.Camera.CFrame.Position - GetPivotPosition()).Magnitude
        end

        function Viewport:SetFieldOfView(FieldOfView: number)
            assert(typeof(FieldOfView) == "number", "FieldOfView must be a number.")

            Viewport.Camera.FieldOfView = math.clamp(FieldOfView, 1, 120)
        end

        function Viewport:SetInteractive(Interactive: boolean)
            Viewport.Interactive = Interactive
            ViewportFrame.Active = Interactive
        end

        function Viewport:SetVisible(Visible: boolean)
            Viewport.Visible = Visible

            Holder.Visible = Viewport.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Viewport.Holder = Holder
        table.insert(Groupbox.Elements, Viewport)

        Options[Idx] = Viewport

        function Viewport:Destroy()
            Viewport.Destroyed = true

            if Viewport.Connections then
                for _, Connection in Viewport.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Viewport)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Viewport
    end

    function Funcs:AddImage(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Image)

        local Groupbox = self
        local Container = Groupbox.Container

        local Image = {
            Connections = {},
            Destroyed = false,

            Image = Info.Image,
            Color = Info.Color,
            RectOffset = Info.RectOffset,
            RectSize = Info.RectSize,
            Height = Info.Height,
            ScaleType = Info.ScaleType,
            Transparency = Info.Transparency,
            BackgroundTransparency = Info.BackgroundTransparency,

            Visible = Info.Visible,
            Type = "Image",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Image.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BackgroundTransparency = Image.BackgroundTransparency,
            ClipsDescendants = true,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            })
        )
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local Icon = Library:GetCustomIcon(Image.Image)
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        local ImageLabel = New("ImageLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ImageTransparency = Image.Transparency,
            ImageColor3 = Image.Color,
            ScaleType = Image.ScaleType,
            Parent = Box,
        })
        FillInstance(ImageContent(Icon), ImageLabel)

        function Image:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Image.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Image:SetImage(NewImage: string)
            assert(typeof(NewImage) == "string", "Image must be a string.")

            local Icon = Library:GetCustomIcon(NewImage)
            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            Image.RectOffset = Icon.ImageRectOffset
            Image.RectSize = Icon.ImageRectSize

            FillInstance(ImageContent(Icon), ImageLabel)
            Image.Image = Icon.Url
        end

        function Image:SetColor(Color: Color3)
            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

            ImageLabel.ImageColor3 = Color
            Image.Color = Color
        end

        function Image:SetRectOffset(RectOffset: Vector2)
            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

            ImageLabel.ImageRectOffset = RectOffset
            Image.RectOffset = RectOffset
        end

        function Image:SetRectSize(RectSize: Vector2)
            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

            ImageLabel.ImageRectSize = RectSize
            Image.RectSize = RectSize
        end

        function Image:SetScaleType(ScaleType: Enum.ScaleType)
            assert(
                typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
                "ScaleType must be a valid Enum.ScaleType."
            )

            ImageLabel.ScaleType = ScaleType
            Image.ScaleType = ScaleType
        end

        function Image:SetTransparency(Transparency: number)
            assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

            ImageLabel.ImageTransparency = Transparency
            Image.Transparency = Transparency
        end

        function Image:SetVisible(Visible: boolean)
            Image.Visible = Visible

            Holder.Visible = Image.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Image.Holder = Holder
        table.insert(Groupbox.Elements, Image)

        Options[Idx] = Image

        function Image:Destroy()
            Image.Destroyed = true

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Image)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Image
    end

    function Funcs:AddVideo(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Video)

        local Groupbox = self
        local Container = Groupbox.Container

        local Video = {
            Connections = {},
            Destroyed = false,

            Video = Info.Video,
            Looped = Info.Looped,
            Playing = Info.Playing,
            Volume = Info.Volume,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "Video",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Video.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local VideoFrameInstance = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Video = Video.Video,
            Looped = Video.Looped,
            Volume = Video.Volume,
            Parent = Box,
        })

        VideoFrameInstance.Playing = Video.Playing

        function Video:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Video.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Video:SetVideo(NewVideo: string)
            assert(typeof(NewVideo) == "string", "Video must be a string.")

            VideoFrameInstance.Video = NewVideo
            Video.Video = NewVideo
        end

        function Video:SetLooped(Looped: boolean)
            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

            VideoFrameInstance.Looped = Looped
            Video.Looped = Looped
        end

        function Video:SetVolume(Volume: number)
            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

            VideoFrameInstance.Volume = Volume
            Video.Volume = Volume
        end

        function Video:SetPlaying(Playing: boolean)
            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

            VideoFrameInstance.Playing = Playing
            Video.Playing = Playing
        end

        function Video:Play()
            VideoFrameInstance.Playing = true
            Video.Playing = true
        end

        function Video:Pause()
            VideoFrameInstance.Playing = false
            Video.Playing = false
        end

        function Video:SetVisible(Visible: boolean)
            Video.Visible = Visible

            Holder.Visible = Video.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Video.Holder = Holder
        Video.VideoFrame = VideoFrameInstance
        table.insert(Groupbox.Elements, Video)

        Options[Idx] = Video

        function Video:Destroy()
            Video.Destroyed = true

            if Video.Connections then
                for _, Connection in Video.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Video)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Video
    end

    function Funcs:AddUIPassthrough(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.UIPassthrough)

        local Groupbox = self
        local Container = Groupbox.Container

        assert(Info.Instance, "Instance must be provided.")
        assert(
            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
            "Instance must inherit from GuiBase2d."
        )
        assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

        local Passthrough = {
            Connections = {},
            Destroyed = false,

            Instance = Info.Instance,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "UIPassthrough",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Passthrough.Visible,
            Parent = Container,
        })

        Passthrough.Instance.Parent = Holder

        Groupbox:Resize()

        function Passthrough:SetHeight(Height: number)
            assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

            Passthrough.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Passthrough:SetInstance(Instance: Instance)
            assert(Instance, "Instance must be provided.")
            assert(
                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )

            if Passthrough.Instance then
                Passthrough.Instance.Parent = nil
            end

            Passthrough.Instance = Instance
            Passthrough.Instance.Parent = Holder
        end

        function Passthrough:SetVisible(Visible: boolean)
            Passthrough.Visible = Visible

            Holder.Visible = Passthrough.Visible
            Groupbox:Resize()
        end

        Passthrough.Holder = Holder
        table.insert(Groupbox.Elements, Passthrough)

        Options[Idx] = Passthrough

        function Passthrough:Destroy()
            Passthrough.Destroyed = true

            if Passthrough.Connections then
                for _, Connection in Passthrough.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Passthrough)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Passthrough
    end

    function Funcs:AddDependencyBox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Container = Groupbox.Container

        local DepboxContainer
        local DepboxList

        do
            DepboxContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            DepboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepboxContainer,
            })
        end

        local Depbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            Holder = DepboxContainer,
            Container = DepboxContainer,

            Elements = {},
            DependencyBoxes = {}
        }

        function Depbox:Resize()
            DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
            Groupbox:Resize()
        end

        function Depbox:Update(CancelSearch)
            for _, Dependency in Depbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Disabled then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                end

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    end
                end
            end

            Depbox.Visible = true
            DepboxContainer.Visible = true
            if not Library.Searching then
                task.defer(function()
                    Depbox:Resize()
                end)
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        table.insert(Depbox.Connections, DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not Depbox.Visible then
                return
            end

            Depbox:Resize()
        end))

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            Depbox.Dependencies = Dependencies
            Depbox:Update()
        end

        table.insert(Depbox.Connections, DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            Depbox:Resize()
        end))

        setmetatable(Depbox, BaseGroupbox)

        table.insert(Groupbox.DependencyBoxes, Depbox)
        table.insert(Library.DependencyBoxes, Depbox)

        function Depbox:Destroy()
            Depbox.Destroyed = true

            if Depbox.Connections then
                for _, Connection in Depbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in Depbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in Depbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepboxContainer then
                DepboxContainer:Destroy()
            end

            local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
            if ElemIdx then
                table.remove(Groupbox.DependencyBoxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, Depbox)
            if LibIdx then
                table.remove(Library.DependencyBoxes, LibIdx)
            end
        end

        return Depbox
    end

    function Funcs:AddDependencyGroupbox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Tab = Groupbox.Tab
        local BoxHolder = Groupbox.BoxHolder

        local DepGroupboxContainer
        local DepGroupboxList

        do
            DepGroupboxContainer = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = BoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = DepGroupboxContainer,
                })
            )
            Library:AddOutline(DepGroupboxContainer)

            DepGroupboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepGroupboxContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 7),
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                PaddingTop = UDim.new(0, 7),
                Parent = DepGroupboxContainer,
            })
        end

        local DepGroupbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            BoxHolder = BoxHolder,
            Holder = DepGroupboxContainer,
            Container = DepGroupboxContainer,

            Tab = Tab,
            Elements = {},
            DependencyBoxes = {},
        }

        function DepGroupbox:Resize()
            DepGroupboxContainer.Size = UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
            if Groupbox.RefreshBoxHolderLayout then
                Groupbox.RefreshBoxHolderLayout()
            end
        end

        function DepGroupbox:Update(CancelSearch)
            for _, Dependency in DepGroupbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Disabled then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                end

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    end
                end
            end

            DepGroupbox.Visible = true
            if not Library.Searching then
                DepGroupboxContainer.Visible = true
                DepGroupbox:Resize()
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function DepGroupbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            DepGroupbox.Dependencies = Dependencies
            DepGroupbox:Update()
        end

        setmetatable(DepGroupbox, BaseGroupbox)

        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
        table.insert(Library.DependencyBoxes, DepGroupbox :: any)

        function DepGroupbox:Destroy()
            DepGroupbox.Destroyed = true

            if DepGroupbox.Connections then
                for _, Connection in DepGroupbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in DepGroupbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in DepGroupbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepGroupboxContainer then
                DepGroupboxContainer:Destroy()
            end

            local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
            if ElemIdx then
                table.remove(Tab.DependencyGroupboxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
            if LibIdx then
                table.remove(Library.DependencyBoxes, LibIdx)
            end
        end

        return DepGroupbox
    end

    BaseGroupbox.__index = Funcs
    BaseGroupbox.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

function Library:SetFont(FontFace)
    if typeof(FontFace) == "EnumItem" then
        FontFace = Font.fromEnum(FontFace :: any)
    end

    Library.Scheme.Font = FontFace
    Library:UpdateColorsUsingRegistry()

    for _, Label in Labels do
        if Label.DoesWrap then
            Label:Display()
            Label.Parent:Resize()
        end
    end

    if Library.Window and Library.Window.RefreshTitleSize then
        Library.Window:RefreshTitleSize()
    end
end

function Library:SetBackgroundImage(Image: string | number)
    assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))

    Library.Scheme.BackgroundImage = Image
    if Library.Window then
        Library.Window:SetBackgroundImage(Image)
    end

    Library:UpdateColorsUsingRegistry()
end

local function GetNotifySide(): (boolean, boolean)
    local Side = tostring(Library.NotifySide):lower()
    return Side:find("left") ~= nil, Side:find("bottom") ~= nil
end

function Library:UpdateNotificationPositions(Snap: boolean?)
    local IsLeft, IsBottom = GetNotifySide()
    local XScale, YScale, YSign = IsLeft and 0 or 1, IsBottom and 1 or 0, IsBottom and -1 or 1
    local RunningY = 0

    for _, FakeBackground in NotifyOrder do
        local Data = Library.Notifications[FakeBackground]
        if not (Data and FakeBackground.Parent) then continue end

        local Target = UDim2.new(XScale, 0, YScale, RunningY * YSign)
        if Snap or not Data.PositionInitialized then
            FakeBackground.Position = Target
            Data.PositionInitialized = true

        elseif FakeBackground.Position ~= Target then
            TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
                Position = Target,
            }):Play()
        end

        RunningY = RunningY + FakeBackground.AbsoluteSize.Y / Library.DPIScale + 8
    end
end

function Library:SetNotifySide(Side: "Left" | "Right" | "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight" | string)
    Library.NotifySide = Side

    local IsLeft, IsBottom = GetNotifySide()
    local Anchor = Vector2.new(IsLeft and 0 or 1, IsBottom and 1 or 0)
    NotificationArea.AnchorPoint = Anchor
    NotificationArea.Position = UDim2.new(Anchor.X, IsLeft and 6 or -6, Anchor.Y, IsBottom and -6 or 6)

    for FakeBackground in Library.Notifications do
        if not (FakeBackground and FakeBackground.Parent) then continue end
        FakeBackground.AnchorPoint = Anchor
    end

    if Library.UpdateNotificationPositions then
        Library:UpdateNotificationPositions(true)
    end

end

function Library:Notify(...)
    local Data = {}
    local Info = select(1, ...)

    if typeof(Info) == "table" then
        Data.Title = tostring(Info.Title)
        Data.TitleColor = Info.TitleColor

        Data.Description = tostring(Info.Description)
        Data.DescriptionColor = Info.DescriptionColor

        Data.Time = Info.Time or 5
        Data.SoundId = Info.SoundId
        Data.Steps = Info.Steps
        Data.Persist = Info.Persist

        Data.Callback = typeof(Info.Callback) == "function" and Info.Callback or nil
        Data.Closable = Info.Closable == true

        Data.Icon = Info.Icon
        Data.BigIcon = Info.BigIcon
        Data.IconColor = Info.IconColor

        Data.Volume = tonumber(Info.Volume) or 3
    else
        Data.Description = tostring(Info)
        Data.Time = select(2, ...) or 5
        Data.SoundId = select(3, ...)
        Data.Volume = select(4, ...) or 3
    end
    Data.Destroyed = false

    local DeletedInstance = false
    local DeleteConnection = nil
    if typeof(Data.Time) == "Instance" then
        DeleteConnection = Data.Time.Destroying:Connect(function()
            DeletedInstance = true

            DeleteConnection:Disconnect()
            DeleteConnection = nil
        end)
    end

    local IsLeft, IsBottom = GetNotifySide()
    local FakeBackground = New("Frame", {
        AnchorPoint = Vector2.new(IsLeft and 0 or 1, IsBottom and 1 or 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 0),
        Visible = false,
        Parent = NotificationArea,
    })

    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = "MainColor",
        Position = IsLeft and UDim2.new(-1, -8, 0, 0) or UDim2.new(1, 8, 0, 0),
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
        Parent = FakeBackground,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    local ContentHolder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = ContentHolder,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
        Parent = ContentHolder,
    })

    local CloseButton
    if Data.Closable then
        CloseButton = Library:CreateIcon(CloseIcon, {
            AnchorPoint = Vector2.new(1, 0),
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            Position = UDim2.new(1, -8, 0, 8),
            Size = UDim2.fromOffset(14, 14),
            ZIndex = 6,
            Parent = Holder,
        }, true)

        CloseButton.MouseEnter:Connect(function()
            TweenIcon(CloseButton, { ImageTransparency = 0 })
        end)
        CloseButton.MouseLeave:Connect(function()
            TweenIcon(CloseButton, { ImageTransparency = 0.5 })
        end)
        CloseButton.MouseButton1Click:Connect(function()
            Data:Destroy("user")
        end)
    end

    local ContentContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromOffset(0, 0),
        Parent = ContentHolder,
    })

    if Data.BigIcon then
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = ContentContainer,
        })
    end

    local BigIconLabel
    if Data.BigIcon then
        local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
        if ParsedIcon then
            BigIconLabel = Library:CreateIcon(ParsedIcon, {
                Size = UDim2.fromOffset(24, 24),
                ImageColor3 = Data.IconColor or "AccentColor",
                Parent = ContentContainer,
            })
        end
    end

    local TextContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromOffset(0, 0),
        Parent = ContentContainer,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TextContainer,
    })

    local TitleContainer
    if Data.Title then
        TitleContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0),
            Parent = TextContainer,
        })
    end

    local IconLabel
    if Data.Icon and TitleContainer then
        local ParsedIcon = Library:GetCustomIcon(Data.Icon)
        if ParsedIcon then
            IconLabel = Library:CreateIcon(ParsedIcon, {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 1),
                Size = UDim2.fromOffset(15, 15),
                ImageColor3 = Data.IconColor or "FontColor",
                Parent = TitleContainer,
            })
        end
    end

    local Title
    local Desc
    local TitleX = 0
    local DescX = 0

    local TimerFill

    if Data.Title then
        Title = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, (IconLabel and 21 or 0), 0.5, 0),
            Size = UDim2.fromScale(0, 0),
            Text = Data.Title,
            TextColor3 = Data.TitleColor or "FontColor",
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true,
            Parent = TitleContainer,
        })
    end

    if Data.Description then
        Desc = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Text = Data.Description,
            TextColor3 = Data.DescriptionColor or "FontColor",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = TextContainer,
        })
    end

    function Data:Resize()
        local ExtraWidth = BigIconLabel and 32 or 0
        local IconWidth = IconLabel and 21 or 0
        local CloseWidth = Data.Closable and 20 or 0
        local MaxTextWidth = math.max(
            40,
            (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - CloseWidth
        )

        if Title then
            local X, Y = Library:GetTextBounds(Title.Text, Title.FontFace, Title.TextSize, MaxTextWidth - IconWidth)
            Title.Size = UDim2.fromOffset(X, Y)
            TitleX = X + IconWidth
            TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
        end

        if Desc then
            local X, Y = Library:GetTextBounds(Desc.Text, Desc.FontFace, Desc.TextSize, MaxTextWidth)
            Desc.Size = UDim2.fromOffset(X, Y)
            DescX = X
        end

        FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth + CloseWidth, 0)

        if Library.Notifications[FakeBackground] then
            task.defer(function()
                if Data.Destroyed or not FakeBackground.Parent then
                    return
                end

                if FakeBackground.AbsoluteSize.Y <= 0 then
                    task.defer(function()
                        if Data.Destroyed or not FakeBackground.Parent then
                            return
                        end

                        Library:UpdateNotificationPositions(true)
                    end)
                    return
                end

                Library:UpdateNotificationPositions(true)
            end)
        end
    end

    function Data:ChangeTitle(Text)
        if Title then
            Data.Title = tostring(Text)
            Title.Text = Data.Title
            Data:Resize()
        end
    end

    function Data:ChangeDescription(Text)
        if Desc then
            Data.Description = tostring(Text)
            Desc.Text = Data.Description
            Data:Resize()
        end
    end

    function Data:ChangeStep(NewStep)
        if TimerFill and Data.Steps then
            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
        end
    end

    function Data:Destroy(Reason)
        if Data.Destroyed then
            return
        end

        Reason = Reason or "script"
        Data.Destroyed = true

        if Data.Callback then
            pcall(Data.Callback, Reason)
        end

        if typeof(Data.Time) == "Instance" then
            pcall(Data.Time.Destroy, Data.Time)
        end

        if DeleteConnection then
            DeleteConnection:Disconnect()
        end

        if FakeBackground then
            local Idx = table.find(NotifyOrder, FakeBackground)
            if Idx then
                table.remove(NotifyOrder, Idx)
            end
        end

        Library:UpdateNotificationPositions()

        TweenService
            :Create(Holder, Library.NotifyTweenInfo, {
                Position = GetNotifySide() and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
            })
            :Play()

        task.delay(Library.NotifyTweenInfo.Time, function()
            Library.Notifications[FakeBackground] = nil
            FakeBackground:Destroy()
        end)
    end

    local TimerHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 7),
        Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
        Parent = ContentHolder,
    })
    local TimerBar = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TimerHolder,
    })
    TimerFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        Size = UDim2.fromScale(1, 1),
        Parent = TimerBar,
    })

    if typeof(Data.Time) == "Instance" then
        TimerFill.Size = UDim2.fromScale(0, 1)
    end
    if Data.SoundId then
        local SoundId = Data.SoundId
        if typeof(SoundId) == "number" then
            SoundId = string.format("rbxassetid://%d", SoundId)
        end

        New("Sound", {
            SoundId = SoundId,
            Volume = tonumber(Data.Volume) or 3,
            PlayOnRemove = true,
            Parent = SoundService,
        }):Destroy()
    end

    Data.Holder = Holder

    table.insert(NotifyOrder, FakeBackground)
    Library.Notifications[FakeBackground] = Data

    Data:Resize()

    FakeBackground.Visible = true
    TweenService:Create(Holder, Library.NotifyTweenInfo, {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    task.defer(function()
        if not Data.Destroyed then
            Library:UpdateNotificationPositions(true)
        end
    end)

    task.delay(Library.NotifyTweenInfo.Time, function()
        if Data.Persist then
            return
        elseif typeof(Data.Time) == "Instance" then
            repeat
                task.wait()
            until DeletedInstance or Data.Destroyed
        else
            TweenService
                :Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    Size = UDim2.fromScale(0, 1),
                })
                :Play()
            task.wait(Data.Time)
        end

        Data:Destroy("timer")
    end)

    return Data
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    local MaxX = ViewportSize.X - 64
    local MaxY = ViewportSize.Y - 64

    Library.OriginalMinSize =
        Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
    Library.MinSize = Vector2.new(math.min(WindowInfo.MinContainerWidth, MaxX), Library.OriginalMinSize.Y)

    WindowInfo.Size = UDim2.fromOffset(
        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
    )
    if typeof(WindowInfo.Font) == "EnumItem" then
        WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
    end
    WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)

    local TabButtonsStyle = WindowInfo.TabButtonsStyle

    
    if WindowInfo.Compact ~= nil then
        WindowInfo.SidebarCompacted = WindowInfo.Compact
    end
    if WindowInfo.SidebarMinWidth ~= nil then
        WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
    end
    WindowInfo.MinSidebarWidth = math.max(64 + TabButtonsStyle.Padding * 2, WindowInfo.MinSidebarWidth)
    WindowInfo.SidebarCompactWidth = math.max(40 + TabButtonsStyle.Padding * 2, WindowInfo.SidebarCompactWidth)
    WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
    WindowInfo.CompactWidthActivation = math.max(40 + TabButtonsStyle.Padding * 2, WindowInfo.CompactWidthActivation)
    WindowInfo.SnapDistance = math.max(0, WindowInfo.SnapDistance)
    WindowInfo.SnapMargin = math.max(0, WindowInfo.SnapMargin)

    Library.CornerRadius = WindowInfo.CornerRadius
    Library:SetNotifySide(WindowInfo.NotifySide)
    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
    Library.Scheme.Font = WindowInfo.Font
    Library.ToggleKeybind = WindowInfo.ToggleKeybind
    Library.GlobalSearch = WindowInfo.GlobalSearch
    
    Library.Animations = WindowInfo.Animations
    Library.TabTransitionInfo = TweenInfo.new(
        math.max(0, WindowInfo.TabTransitionTime or 0.22),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

    Library.Animations = WindowInfo.Animations
    Library.TabTransitionInfo = TweenInfo.new(
        math.max(0, WindowInfo.TabTransitionTime or 0.22),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

    local IsDefaultSearchbarSize = WindowInfo.SearchbarSize == UDim2.fromScale(1, 1)
    local MainFrame
    local DividerLine
    local TitleHolder
    local WindowTitle
    local WindowIcon
    local RightWrapper
    local SearchBox
    local CurrentTabInfo
    local CurrentTabLabel
    local CurrentTabDescription
    local ResizeButton
    local Tabs
    local Container
    local BackgroundImage
    local HasBackgroundImage = false
    local BottomBackground
    local BottomBackgroundCorner
    local FooterLabel
    local TopBar
    local WindowSnapConfig = {
        Enabled = WindowInfo.Snapping,
        Distance = WindowInfo.SnapDistance,
        Margin = WindowInfo.SnapMargin,
        AvoidCoreGui = WindowInfo.SnapAvoidCoreGui,
    }

    local InitialLeftWidth = math.ceil(WindowInfo.Size.X.Offset * 0.3)
    local IsCompact = WindowInfo.SidebarCompacted
    local LastExpandedWidth = InitialLeftWidth
    local RefreshWindowTitleSize

    do
        local KeybindFrame, KeybindContainer, _, KeybindDivider, KeybindLabelPadding = Library:AddDraggableMenu("Keybinds")
        KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
        KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
        KeybindFrame.Visible = false
        KeybindLabelPadding.PaddingRight = UDim.new(0, 34)

        local HeaderButtons = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -8, 0, 17),
            Size = UDim2.fromOffset(0, 22),
            ZIndex = 2,
            Parent = KeybindFrame,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            Parent = HeaderButtons,
        })

        local SettingsButton = Library:CreateIcon(SettingsIcon, {
            ImageColor3 = "FontColor",
            LayoutOrder = 1,
            Size = UDim2.fromOffset(18, 18),
            Visible = false,
            ZIndex = 2,
            Parent = HeaderButtons,
        }, true)

        local CollapseButton = Library:CreateIcon(ArrowIcon, {
            ImageColor3 = "FontColor",
            LayoutOrder = 2,
            Rotation = 180,
            Size = UDim2.fromOffset(18, 18),
            ZIndex = 2,
            Parent = HeaderButtons,
        }, true)

        local SettingsFrame, SettingsContainer, _, _, SettingsLabelPadding = Library:AddDraggableMenu("Visible Keybinds")
        SettingsFrame.Visible = false
        SettingsLabelPadding.PaddingRight = UDim.new(0, 34)

        local CloseSettingsButton = Library:CreateIcon(CloseIcon, {
            AnchorPoint = Vector2.new(1, 0.5),
            ImageColor3 = "FontColor",
            Position = UDim2.new(1, -8, 0, 17),
            Size = UDim2.fromOffset(18, 18),
            ZIndex = 2,
            Parent = SettingsFrame,
        }, true)

        local KeybindMenu = {
            VisibilityControl = false,
            Collapsed = false,
            SettingsOpen = false,
            Frame = KeybindFrame,
            Container = KeybindContainer,
            SettingsFrame = SettingsFrame,
            SettingsContainer = SettingsContainer,
        }

        function KeybindMenu:RefreshSettings()
            for _, Child in SettingsContainer:GetChildren() do
                if Child:IsA("GuiObject") and not Child:IsA("UIListLayout") and not Child:IsA("UIPadding") then
                    Child:Destroy()
                end
            end

            for Idx, Option in Options do
                if Option.Type ~= "KeyPicker" or Option.NoUI == true then
                    continue
                end

                local Holder = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = "",
                    Parent = SettingsContainer,
                })

                local Visible = Option.MenuVisible ~= false
                New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(22, 0),
                    Size = UDim2.fromScale(0, 1),
                    Text = ("[%s] %s (%s)"):format(
                        Option.DisplayValue or Option.Value or "None",
                        Option.Text or tostring(Idx),
                        Option.Mode or "Toggle"
                    ),
                    TextSize = 14,
                    TextTransparency = Visible and 0 or 0.5,
                    Parent = Holder,
                })

                local Checkbox = New("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = "MainColor",
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromOffset(14, 14),
                    Parent = Holder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Checkbox,
                    })
                )
                New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Checkbox,
                })

                Library:CreateIcon(CheckIcon, {
                    ImageColor3 = "FontColor",
                    ImageTransparency = Visible and 0 or 1,
                    Position = UDim2.fromOffset(2, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    Parent = Checkbox,
                })

                Holder.MouseButton1Click:Connect(function()
                    local Picker = Options[Idx]
                    if not (Picker and Picker.Type == "KeyPicker" and Picker.SetMenuVisibility) then
                        return
                    end

                    Picker:SetMenuVisibility(Picker.MenuVisible == false)
                end)
            end
        end

        function KeybindMenu:SetCollapsed(Collapsed: boolean)
            Collapsed = Collapsed == true
            KeybindMenu.Collapsed = Collapsed

            KeybindContainer.Visible = not Collapsed
            KeybindDivider.Visible = not Collapsed

            if Collapsed then
                local Width = math.max(160, KeybindFrame.AbsoluteSize.X / Library.DPIScale)
                KeybindFrame.AutomaticSize = Enum.AutomaticSize.None
                KeybindFrame.Size = UDim2.fromOffset(Width, 34)
                CollapseButton.Rotation = 0
            else
                KeybindFrame.AutomaticSize = Enum.AutomaticSize.XY
                KeybindFrame.Size = UDim2.fromOffset(0, 0)
                CollapseButton.Rotation = 180
            end
        end

        function KeybindMenu:ToggleCollapsed()
            KeybindMenu:SetCollapsed(not KeybindMenu.Collapsed)
        end

        function KeybindMenu:SetSettingsOpen(Open: boolean)
            Open = Open == true
            if Open and not KeybindMenu.VisibilityControl then
                return
            end

            KeybindMenu.SettingsOpen = Open
            SettingsFrame.Visible = Open

            if Open then
                KeybindMenu:RefreshSettings()

                local Bounds = Floats.AbsoluteSize
                local Pos = KeybindFrame.AbsolutePosition - Floats.AbsolutePosition
                local Size = KeybindFrame.AbsoluteSize
                local SettingsSize = SettingsFrame.AbsoluteSize

                local X = Pos.X + Size.X + 8
                if X + SettingsSize.X > Bounds.X then
                    X = Pos.X - SettingsSize.X - 8
                end

                SettingsFrame.Position = UDim2.fromOffset(
                    math.clamp(X, 0, math.max(0, Bounds.X - SettingsSize.X)),
                    math.clamp(Pos.Y, 0, math.max(0, Bounds.Y - SettingsSize.Y))
                )
            end
        end

        function KeybindMenu:ToggleSettings()
            KeybindMenu:SetSettingsOpen(not KeybindMenu.SettingsOpen)
        end

        function KeybindMenu:SetVisibilityControl(Enabled: boolean)
            Enabled = Enabled == true
            KeybindMenu.VisibilityControl = Enabled
            SettingsButton.Visible = Enabled
            KeybindLabelPadding.PaddingRight = UDim.new(0, Enabled and 56 or 34)

            if not Enabled then
                KeybindMenu:SetSettingsOpen(false)
            end
        end

        function KeybindMenu:Destroy()
            local DraggableIndex = table.find(Library.DraggableElements, SettingsFrame)
            if DraggableIndex then
                table.remove(Library.DraggableElements, DraggableIndex)
            end

            SettingsFrame:Destroy()
            KeybindMenu.SettingsFrame = nil
            KeybindMenu.SettingsContainer = nil
            KeybindMenu.SettingsOpen = false
            Library.KeybindMenu = nil
        end

        SettingsButton.MouseButton1Click:Connect(function()
            KeybindMenu:ToggleSettings()
        end)
        CollapseButton.MouseButton1Click:Connect(function()
            KeybindMenu:ToggleCollapsed()
        end)
        CloseSettingsButton.MouseButton1Click:Connect(function()
            KeybindMenu:SetSettingsOpen(false)
        end)

        Library.KeybindFrame = KeybindFrame
        Library.KeybindContainer = KeybindContainer
        Library.KeybindMenu = KeybindMenu

        MainFrame = New("TextButton", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            Name = "Main",
            Text = "",
            Position = WindowInfo.Position,
            Size = WindowInfo.Size,
            Visible = false,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = MainFrame,
            })
        )
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = MainFrame,
            })
        )
        Library:AddOutline(MainFrame)
        Library:MakeLine(MainFrame, {
            Position = UDim2.fromOffset(0, 48),
            Size = UDim2.new(1, 0, 0, 1),
        })

        DividerLine = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(InitialLeftWidth, 0),
            Size = UDim2.new(0, 1, 1, -21),
            Parent = MainFrame,
            ZIndex = 2
        })

        local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
        HasBackgroundImage = BackgroundIcon ~= nil
        BackgroundImage = New("ImageLabel", {
            Active = false,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Stretch,
            ZIndex = Overlay.ZIndex + 1,
            BackgroundTransparency = 1,
            ImageTransparency = 0.75,
            Visible = false,
            Parent = ScreenGui,
        })
        FillInstance(ImageContent(BackgroundIcon), BackgroundImage)

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BackgroundImage,
            })
        )

        Library:GiveSignal(RunService.RenderStepped:Connect(function()
            if not (BackgroundImage and MainFrame) then
                return
            end

            local ShouldShow = HasBackgroundImage and MainFrame.Visible
            BackgroundImage.Visible = ShouldShow

            if not ShouldShow then
                return
            end

            BackgroundImage.Position = UDim2.fromOffset(
                MainFrame.AbsolutePosition.X,
                MainFrame.AbsolutePosition.Y
            )
            BackgroundImage.Size = UDim2.fromOffset(
                MainFrame.AbsoluteSize.X,
                MainFrame.AbsoluteSize.Y
            )
        end))

        if WindowInfo.Center then
            MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
        end

        
        TopBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Parent = MainFrame,
        })
        Library:MakeDraggable(MainFrame, TopBar, false, true, WindowSnapConfig)

        
        TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, InitialLeftWidth, 1, 0),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            Parent = TitleHolder,
        })

        if WindowInfo.Icon then
            WindowIcon = Library:CreateIcon(Library:GetCustomIcon(WindowInfo.Icon), {
                Size = WindowInfo.IconSize,
                Parent = TitleHolder,
            })
        else
            WindowIcon = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = WindowInfo.IconSize,
                Text = WindowInfo.Title:sub(1, 1),
                TextScaled = true,
                Visible = false,
                Parent = TitleHolder,
            })
        end

        WindowTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0),
            Text = WindowInfo.Title,
            TextSize = 20,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = TitleHolder,
        })

        RefreshWindowTitleSize = function()
            local IconWidth = 0
            if WindowIcon and WindowIcon.Visible then
                IconWidth = WindowIcon.Size.X.Offset + 6
            end

            local MaxWidth = math.max(0, (TitleHolder.AbsoluteSize.X / Library.DPIScale) - IconWidth - 12)
            local NaturalWidth = Library:GetTextBounds(WindowTitle.Text, Library.Scheme.Font, WindowTitle.TextSize)
            WindowTitle.Size = UDim2.new(0, math.min(NaturalWidth, MaxWidth), 1, 0)
        end
        RefreshWindowTitleSize()

        
        RightWrapper = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -49, 0.5, 0),
            Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, -16),
            Parent = TopBar,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            Parent = RightWrapper,
        })

        CurrentTabInfo = New("Frame", {
            Size = UDim2.fromScale(WindowInfo.DisableSearch and 1 or 0.5, 1),
            Visible = false,
            BackgroundTransparency = 1,
            Parent = RightWrapper,
        })

        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Grow,
            Parent = CurrentTabInfo,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = CurrentTabInfo,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = CurrentTabInfo,
        })

        CurrentTabLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = CurrentTabInfo,
        })

        CurrentTabDescription = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            TextWrapped = true,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.5,
            Parent = CurrentTabInfo,
        })

        SearchBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            PlaceholderText = "搜索",
            Size = WindowInfo.SearchbarSize,
            TextScaled = true,
            Visible = not (WindowInfo.DisableSearch or false),
            Parent = RightWrapper,
        })
        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Shrink,
            Parent = SearchBox,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = SearchBox,
            })
        )
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = SearchBox,
        })
        local SearchBoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = SearchBox,
        })

        Library:GiveSignal(SearchBox.Focused:Connect(function()
            Library.Registry[SearchBoxStroke].Color = "AccentColor"
            TweenService:Create(SearchBoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.AccentColor,
            }):Play()
        end))

        Library:GiveSignal(SearchBox.FocusLost:Connect(function()
            Library.Registry[SearchBoxStroke].Color = "OutlineColor"
            TweenService:Create(SearchBoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.OutlineColor,
            }):Play()
        end))

        local SearchIcon = Library:GetIcon("search")
        if SearchIcon then
            Library:CreateIcon(SearchIcon, {
                ImageColor3 = "FontColor",
                ImageTransparency = 0.5,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = SearchBox,
            })
        end

        if MoveIcon then
            Library:CreateIcon(MoveIcon, {
                AnchorPoint = Vector2.new(1, 0.5),
                ImageColor3 = "OutlineColor",
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(28, 28),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = TopBar,
            })
        end

        
        local BottomClip = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            ZIndex = 3,
            Parent = MainFrame,
        })

        BottomBackground = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, math.max(20, WindowInfo.CornerRadius * 2)),
            ZIndex = 3,
            Parent = BottomClip,
        })
        Library:MakeLine(MainFrame, {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, -20),
            Size = UDim2.new(1, 0, 0, 1),
            ZIndex = 3,
        })

        local BottomBar = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            ZIndex = 4,
            Parent = MainFrame,
        })
        BottomBackgroundCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, 0),
            TopRightRadius = UDim.new(0, 0),
            BottomLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
            BottomRightRadius = UDim.new(0, WindowInfo.CornerRadius),
            Parent = BottomBackground,
        })

        
        FooterLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = WindowInfo.Footer,
            TextSize = 14,
            TextTransparency = 0.5,
            Parent = BottomBar,
        })

        
        if WindowInfo.Resizable then
            ResizeButton = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = BottomBar,
            })

            Library:MakeResizable(MainFrame, ResizeButton, function()
                for _, Tab in Library.Tabs do
                    Tab:Resize(true)
                end
            end)
        end

        Library:CreateIcon(ResizeIcon, {
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = ResizeButton,
        })

        
        Tabs = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            CanvasSize = UDim2.fromScale(0, 0),
            Position = UDim2.fromOffset(0, 49),
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            Size = UDim2.new(0, InitialLeftWidth, 1, -70),
            Parent = MainFrame,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, TabButtonsStyle.Gap),
            Parent = Tabs,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, TabButtonsStyle.Padding),
            PaddingLeft = UDim.new(0, TabButtonsStyle.Padding),
            PaddingRight = UDim.new(0, TabButtonsStyle.Padding),
            PaddingTop = UDim.new(0, TabButtonsStyle.Padding),
            Parent = Tabs,
        })

        
        Container = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
            end,
            ClipsDescendants = true,
            Name = "Container",
            Position = UDim2.new(1, 0, 0, 49),
            Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
            Parent = MainFrame,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 0),
            Parent = Container,
        })

        Library.WindowContainer = Container
    end

    
    local Window = {}
    local Fading = false

    local function SetUICorner(UICorner, Corner, HalfValue)
        local Current = UICorner[Corner]
        if Current.Offset == 0 and Current.Scale == 0 then
            return
        end

        UICorner[Corner] = HalfValue
    end

    function Window:ChangeTitle(title)
        assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

        WindowTitle.Text = title
        WindowInfo.Title = title
        RefreshWindowTitleSize()
    end

    function Window:RefreshTitleSize()
        RefreshWindowTitleSize()
    end

    function Window:SetBackgroundImage(Image: string)
        local ValidIcon = false

        if typeof(Image) == "string" then
            local BackgroundIcon = Library:GetCustomIcon(Image)

            if BackgroundIcon then
                ValidIcon = true

                FillInstance(ImageContent(BackgroundIcon), BackgroundImage)
            elseif Image:match("http://") or Image:match("https://") then
                local RawFileName = Image:match("(.+)%..+$")
                local _, Domain = Image:match("^(https?://)([^/]+)");

                if RawFileName and Domain then
                    local Extention = string.sub(Image, #RawFileName + 1, #Image)
                    local FileNamePos = RawFileName:gsub("\\", "/"):find("/[^/]*$")
                    local FileName = FileNamePos and Image:sub(FileNamePos + 1) or nil

                    if FileName then
                        ValidIcon = true

                        local AssetName = Domain .. FileName
                        if #AssetName > 255 then
                            local NewLength = 255 - #Domain - #Extention
                            if NewLength < 0 then
                                AssetName = Domain .. Extention
                            else
                                AssetName = Domain .. string.sub(FileName:sub(1, #FileName - #Extention), 1, NewLength) .. Extention
                            end
                        end

                        if CustomImageManagerAssets[FileName] == nil then
                            CustomImageManager.AddAsset(FileName, 0, Image)
                        else
                            CustomImageManager.DownloadAsset(FileName, true)
                        end

                        FillInstance(ImageContent({ Url = CustomImageManager.GetAsset(FileName) }), BackgroundImage)
                    end
                end
            end
        end

        if not ValidIcon then
            FillInstance(ImageContent(nil), BackgroundImage)
        end

        HasBackgroundImage = ValidIcon
        WindowInfo.BackgroundImage = Image
    end

    function Window:SetFooter(Footer: string)
        assert(typeof(Footer) == "string", "Expected string for footer got: " .. typeof(Footer))

        FooterLabel.Text = Footer
        WindowInfo.Footer = Footer
    end

    function Window:SetAlwaysOnTop(Enabled: boolean)
        WindowInfo.AlwaysOnTop = Enabled == true
        SetAlwaysOnTop(Library.ScreenGui, WindowInfo.AlwaysOnTop)
    end

    function Window:SetSnapping(Enabled: boolean, Distance: number?, Margin: number?, AvoidCoreGui: boolean?)
        WindowInfo.Snapping = Enabled == true
        WindowSnapConfig.Enabled = WindowInfo.Snapping

        if Distance then
            WindowInfo.SnapDistance = math.max(0, Distance)
            WindowSnapConfig.Distance = WindowInfo.SnapDistance
        end

        if Margin then
            WindowInfo.SnapMargin = math.max(0, Margin)
            WindowSnapConfig.Margin = WindowInfo.SnapMargin
        end

        if AvoidCoreGui ~= nil then
            WindowInfo.SnapAvoidCoreGui = AvoidCoreGui == true
            WindowSnapConfig.AvoidCoreGui = WindowInfo.SnapAvoidCoreGui
        end
    end

    function Window:SetCornerRadius(Radius: number)
        assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
        Radius = math.min(Radius, 20)

        local RadiusHalf = UDim.new(0, Radius / 2)
        local RadiusUDim = UDim.new(0, Radius)
        local HalfCurrent = Library.CornerRadius / 2

        for _, UICorner in Library.Corners do
            if math.abs(UICorner.CornerRadius.Offset - HalfCurrent) < 0.001 then
                UICorner.CornerRadius = RadiusHalf
            else
                UICorner.CornerRadius = RadiusUDim
            end
        end

        for _, UICorner in Library.SpecificCorners do
            SetUICorner(UICorner, "TopRightRadius", RadiusHalf)
            SetUICorner(UICorner, "TopLeftRadius", RadiusHalf)
            SetUICorner(UICorner, "BottomRightRadius", RadiusHalf)
            SetUICorner(UICorner, "BottomLeftRadius", RadiusHalf)
        end

        Library.CornerRadius = Radius
        WindowInfo.CornerRadius = Radius

        if ResizeButton then
            ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
        end
        if BottomBackgroundCorner then
            BottomBackground.Size = UDim2.new(1, 0, 0, math.max(20, Radius * 2))
            BottomBackgroundCorner.BottomLeftRadius = RadiusUDim
            BottomBackgroundCorner.BottomRightRadius = RadiusUDim
        end

        for _, Menu in Library.ContextMenus do
            if Menu.Destroyed then
                continue
            end

            if typeof(Menu.ActiveCallback) ~= "function" then
                continue
            end

            if not Menu.Active then
                local HolderActive = false
                for _, Other in Library.ContextMenus do
                    if Other == Menu then 
                        continue
                    end
   
                    if Other.Active and Other.Holder == Menu.Holder then
                        HolderActive = true
                        break
                    end
                end

                if HolderActive then
                    continue
                end

                Menu.ActiveCallback(false)
                continue
            end

            Menu.ActiveCallback(true)
        end

        for _, Option in Options do
            if Option.Type == "Dropdown" and Option.RefreshPool then
                Option:RefreshPool()
            end
        end

        for _, Tab in Library.Tabs do
            if Tab.IsKeyTab then
                continue
            end

            for _, Tabbox in Tab.Tabboxes do
                Tabbox:UpdateCorners()
            end
        end
    end

    function Window:SetAnimations(Animations: { [string]: boolean }?, TabTransitionTime: number?, TabSwipeOffset: number?, TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?)
        if typeof(Animations) == "table" then
            WindowInfo.Animations = Animations
            Library.Animations = Animations
        end

        if typeof(TabTransitionTime) == "number" then
            local TweenInfo = TweenInfo.new(
                math.max(0, TabTransitionTime or 0.22),
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            WindowInfo.TabTransitionInfo = TweenInfo
            Library.TabTransitionInfo = TweenInfo
        end

        if typeof(TabSwipeOffset) == "number" then
            TabSwipeOffset = math.max(1, TabSwipeOffset)

            WindowInfo.TabSwipeOffset = TabSwipeOffset
            Library.TabSwipeOffset = TabSwipeOffset
        end

        if typeof(TabSwipeFrom) == "string" then
            TabSwipeFrom = string.lower(TabSwipeFrom)

            WindowInfo.TabSwipeFrom = TabSwipeFrom
            Library.TabSwipeFrom = TabSwipeFrom
        end
    end

    local function ApplyCompact()
        IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
        if WindowInfo.DisableCompactingSnap then
            IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
        end

        WindowTitle.Visible = not IsCompact
        if not WindowInfo.Icon then
            WindowIcon.Visible = IsCompact
        end

        for _, Button in Library.TabButtons do
            if not Button.Icon then
                continue
            end

            Button.Label.Visible = not IsCompact
            Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
            Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
            Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
        end
    end

    function Window:IsSidebarCompacted()
        return IsCompact
    end

    function Window:SetCompact(State)
        Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
    end

    function Window:GetSidebarWidth()
        return Tabs.Size.X.Offset
    end

    function Window:SetSidebarWidth(Width)
        Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

        DividerLine.Position = UDim2.fromOffset(Width, 0)

        TitleHolder.Size = UDim2.new(0, Width, 1, 0)
        RightWrapper.Size = UDim2.new(1, -Width - 57 - 1, 1, -16)
        Tabs.Size = UDim2.new(0, Width, 1, -70)
        Container.Size = UDim2.new(1, -Width - 1, 1, -70)

        if WindowInfo.EnableCompacting then
            ApplyCompact()
        end
    
        RefreshWindowTitleSize()
        if not IsCompact then
            LastExpandedWidth = Width
        end
    end

    function Window:ShowTabInfo(Name, Description, RichText)
        CurrentTabLabel.RichText = RichText == true
        CurrentTabLabel.Text = Name
        CurrentTabDescription.Text = Description or ""
        CurrentTabDescription.Visible = typeof(Description) == "string" and Description ~= ""

        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(0.5, 1)
        end
        CurrentTabInfo.Visible = true
    end

    function Window:HideTabInfo()
        CurrentTabInfo.Visible = false
        if IsDefaultSearchbarSize then
            SearchBox.Size = UDim2.fromScale(1, 1)
        end
    end

    local function CreateTab(ParentTab, ...)
        local Name = nil
        local Icon = nil
        local Description = nil
        local Tooltip = nil
        local Order = nil
        local HasSubTabs = false

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
            Tooltip = Info.Tooltip
            Order = Info.Order
            HasSubTabs = Info.SubTabs == true and ParentTab == nil
        else
            Name = select(1, ...)
            Icon = select(2, ...)
            Description = select(3, ...)
            Order = select(4, ...)
        end

        if not tonumber(Order) then
            Order = if ParentTab then ParentTab.SubTabCount + 1 else #Tabs:GetChildren()
        end

        local TabKey = if ParentTab then ParentTab.Name .. "/" .. Name else Name

        local TabButton: TextButton
        local TabIndicator
        local TabStroke
        local TabLabel
        local TabIcon

        local TabContainer
        local TabLeft
        local TabRight

        local SubTabBar
        local SubTabHolder

        Icon = Library:GetCustomIcon(Icon)
        if ParentTab then
            TabButton = New("TextButton", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = "MainColor",
                LayoutOrder = Order,
                Size = UDim2.fromScale(0, 1),
                Text = "",
                Parent = ParentTab.SubTabBar,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = TabButton,
                })
            )

            TabStroke = New("UIStroke", {
                Color = "OutlineColor",
                Parent = TabButton,
            })
            Library:AddToRegistry(TabStroke, {
                Color = function()
                    return if ParentTab.ActiveSubTab and ParentTab.ActiveSubTab.Button == TabButton then Library.Scheme.AccentColor else Library.Scheme.OutlineColor
                end,
            })

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = TabButton,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = TabButton,
            })

            if Icon then
                TabIcon = Library:CreateIcon(Icon, {
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageTransparency = 0.5,
                    LayoutOrder = 1,
                    Size = UDim2.fromOffset(16, 16),
                    Parent = TabButton,
                })
            end

            TabLabel = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = UDim2.fromOffset(0, 16),
                Text = Name,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = TabButton,
            })
        else
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                LayoutOrder = Order,
                Parent = Tabs,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
                Parent = TabButton,
            })

            if TabButtonsStyle.Indicator then
                TabIndicator = New("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = "AccentColor",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0.5, 0),
                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
                    Parent = TabButton,
                })

                New("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = TabIndicator,
                })
            end

            local ButtonHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = TabButton,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = ButtonHolder,
            })
            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = ButtonHolder,
            })

            if Icon then
                TabIcon = Library:CreateIcon(Icon, {
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = ButtonHolder,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })
        end

        
        TabContainer = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            Parent = if ParentTab then ParentTab.SubTabHolder else Container,
        })

        if HasSubTabs then
            SubTabBar = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromOffset(2, 5),
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.X,
                Size = UDim2.new(1, -4, 0, 30),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SubTabBar,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 3),
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                PaddingTop = UDim.new(0, 3),
                Parent = SubTabBar,
            })

            Library:MakeLine(TabContainer, {
                Position = UDim2.fromOffset(-6, 40),
                Size = UDim2.new(1, 12, 0, 1),
            })

            SubTabHolder = New("Frame", {
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Position = UDim2.fromOffset(0, 41),
                Size = UDim2.new(1, 0, 1, -41),
                Parent = TabContainer,
            })
        else
            TabLeft = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabLeft,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabLeft,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabLeft,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabLeft,
                })
            end

            TabRight = New("ScrollingFrame", {
                AnchorPoint = Vector2.new(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(1, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabRight,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabRight,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabRight,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabRight,
                })
            end
        end

        
        local Tab = {
            Name = Name,
            Description = Description,

            Tooltip = Tooltip,
            TooltipTable = nil,

            Connections = {},
            Destroyed = false,

            Window = Window,
            ParentTab = ParentTab,
            IsSubTab = ParentTab ~= nil,

            Button = TabButton,
            Container = TabContainer,
            Sides = {
                TabLeft,
                TabRight,
            },
            WarningBox = {
                IsNormal = false,
                LockSize = false,
                Visible = false,
                Title = "警告",
                Text = "",
            },

            Groupboxes = {},
            Tabboxes = {},
            DependencyGroupboxes = {},

            
            HasSubTabs = HasSubTabs,
            SubTabBar = SubTabBar,
            SubTabHolder = SubTabHolder,

            SubTabs = {},
            SubTabCount = 0,
            ActiveSubTab = nil,
            PreviousSubTab = nil,
        }

        
        local WarningBoxHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 7),
            Size = UDim2.fromScale(1, 0),
            Visible = false,
            Parent = TabContainer,
        })

        local WarningBox
        local WarningBoxOutline
        local WarningBoxShadowOutline
        local WarningBoxScrollingFrame
        local WarningTitle
        local WarningStroke
        local WarningText
        do
            WarningBox = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(127, 0, 0),
                Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(1, -5, 0, 0),
                Parent = WarningBoxHolder,
            })
            Library:AddToRegistry(WarningBox, {
                BackgroundColor3 = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
                end
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = WarningBox,
                })
            )
            WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)
            Library:AddToRegistry(WarningBoxOutline, {
                Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
                end
            })
            Library:AddToRegistry(WarningBoxShadowOutline, {
                Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
                end
            })

            WarningBoxScrollingFrame = New("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Parent = WarningBox,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 4),
                Parent = WarningBoxScrollingFrame,
            })

            WarningTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -4, 0, 14),
                Text = "",
                TextColor3 = Color3.fromRGB(255, 50, 50),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = WarningBoxScrollingFrame,
            })
            Library:AddToRegistry(WarningTitle, {
                TextColor3 = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
                end
            })

            WarningStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = Color3.fromRGB(169, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningTitle,
            })
            Library:AddToRegistry(WarningStroke, {
                Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
                end
            })

            WarningText = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.new(1, -4, 0, 0),
                Text = "",
                TextSize = 14,
                TextWrapped = true,
                Parent = WarningBoxScrollingFrame,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
            })

            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = GetTextStrokeColor,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningText,
            })
        end

        
        function Tab:UpdateWarningBox(Info)
            if HasSubTabs then
                error(string.format("Tab '%s' uses SubTabs, update the warning box of a subtab instead", Name))
            end

            if typeof(Info.IsNormal) == "boolean" then
                Tab.WarningBox.IsNormal = Info.IsNormal
            end
            if typeof(Info.LockSize) == "boolean" then
                Tab.WarningBox.LockSize = Info.LockSize
            end
            if typeof(Info.Visible) == "boolean" then
                Tab.WarningBox.Visible = Info.Visible
            end
            if typeof(Info.Title) == "string" then
                Tab.WarningBox.Title = Info.Title
            end
            if typeof(Info.Text) == "string" then
                Tab.WarningBox.Text = Info.Text
            end

            WarningBoxHolder.Visible = Tab.WarningBox.Visible
            WarningTitle.Text = Tab.WarningBox.Title
            WarningText.Text = Tab.WarningBox.Text
            Tab:Resize(true)

            WarningBox.BackgroundColor3 = Library.Registry[WarningBox].BackgroundColor3()
            WarningBoxShadowOutline.Color = Library.Registry[WarningBoxShadowOutline].Color()
            WarningBoxOutline.Color = Library.Registry[WarningBoxOutline].Color()
            WarningTitle.TextColor3 = Library.Registry[WarningTitle].TextColor3()
            WarningStroke.Color = Library.Registry[WarningStroke].Color()
        end

        function Tab:RefreshSides()
            if HasSubTabs then
                if Tab.ActiveSubTab then
                    Tab.ActiveSubTab:RefreshSides()
                end

                return
            end

            local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
            local Width = TabContainer.AbsoluteSize.X / Library.DPIScale
            local LeftWidth = math.floor(Width / 2 - 3)

            TabLeft.Position = UDim2.fromOffset(0, Offset)
            TabLeft.Size = UDim2.new(0, LeftWidth, 1, -Offset)

            TabRight.Position = UDim2.new(1, 0, 0, Offset)
            TabRight.Size = UDim2.new(0, Width - LeftWidth - 6, 1, -Offset)
        end
        table.insert(Tab.Connections, TabContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() Tab:RefreshSides() end))

        function Tab:Resize(ResizeWarningBox: boolean?)
            if ResizeWarningBox then
                local MaximumSize = math.floor((TabContainer.AbsoluteSize.Y / Library.DPIScale) / 3.25)
                local _, YText = Library:GetTextBounds(
                    WarningText.Text,
                    Library.Scheme.Font,
                    WarningText.TextSize,
                    WarningText.AbsoluteSize.X / Library.DPIScale
                )

                local YBox = 24 + YText
                if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
                    YBox = MaximumSize
                else
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
                end

                WarningText.Size = UDim2.new(1, -4, 0, YText)
                WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
            end

            Tab:RefreshSides()
        end

        local function AddTabbox(self, Info)
            Info = Library:Validate(Info, Templates.Tabbox)
            local ParentObj = self
            local IsNested = ParentObj.Type == "Groupbox" or ParentObj.Type == "SubTab"

            if typeof(Info.Side) == "string" then
                local lowerSide = string.lower(Info.Side)
                if not SideIndex[lowerSide] then
                    error(string.format("Invalid side: %s", Info.Side))
                end

                Info.Side = SideIndex[lowerSide]
            end

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = if IsNested then ParentObj.Container else (Info.Side == 1 and TabLeft or TabRight),
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local TabboxHolder
            local TabboxButtons

            do
                TabboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = TabboxHolder,
                    })
                )
                Library:AddOutline(TabboxHolder)

                TabboxButtons = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = TabboxHolder,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Parent = TabboxButtons,
                })
            end

            local TotalTabs = 0
            local FirstTab
            local LastTab

            local Tabbox: any = {
                Type = "Tabbox",

                Connections = {},
                Destroyed = false,

                Visible = true,
                ActiveTab = nil,
                MaxHeight = Info.MaxHeight,

                BoxHolder = BoxHolder,
                Holder = TabboxHolder,
                Tabs = {},

                ParentBox = if IsNested then ParentObj else nil,
            }

            function Tabbox:UpdateCorners()
                for _, Tab in Tabbox.Tabs do
                    Tab:UpdateCorners()
                end
            end

            function Tabbox:Resize()
                if Tabbox.ActiveTab then
                    Tabbox.ActiveTab:Resize()
                end
            end

            function Tabbox:SetMaxHeight(MaxHeight: number?)
                if MaxHeight ~= nil then
                    assert(typeof(MaxHeight) == "number", "MaxHeight must be a number or nil")
                    assert(MaxHeight > 0, "MaxHeight must be higher than 0")
                end

                Tabbox.MaxHeight = MaxHeight
                Tabbox:Resize()
            end

            function Tabbox:AddTab(Name, IconName, MaxHeight)
                TotalTabs = TotalTabs + 1
                local TabIndex = TotalTabs

                LastTab = TabIndex
                if not FirstTab then
                    FirstTab = TabIndex
                end

                local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
                local TabStoringIndex = IsNameEmpty and tostring(TabIndex) or Name

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(0, 34),
                    Text = "",
                    Parent = TabboxButtons,
                })

                local ButtonCorner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
                    TopRightRadius = UDim.new(0, WindowInfo.CornerRadius),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0),
                    Parent = Button,
                }); table.insert(Library.SpecificCorners, ButtonCorner)

                local ButtonContent = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(0, 16),
                    Parent = Button,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = ButtonContent,
                })

                local ButtonIcon
                local BoxIcon = Library:GetCustomIcon(IconName)
                if BoxIcon then
                    ButtonIcon = Library:CreateIcon(BoxIcon, {
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageTransparency = 0.5,
                        Size = IsNameEmpty and UDim2.fromOffset(16, 16) or UDim2.fromOffset(18, 18),
                        Parent = ButtonContent,
                    })
                end

                local ButtonLabel
                if not IsNameEmpty then
                    ButtonLabel = New("TextLabel", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 16),
                        Text = Name,
                        TextSize = 15,
                        TextTransparency = 0.5,
                        Parent = ButtonContent,
                    })
                end

                local Line = Library:MakeLine(Button, {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local Container = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.fromOffset(0, 0),
                    Position = UDim2.fromOffset(0, 35),
                    ScrollBarImageTransparency = 1,
                    ScrollBarThickness = 0,
                    ScrollingEnabled = false,
                    Size = UDim2.new(1, 0, 1, -35),
                    Visible = false,
                    Parent = TabboxHolder,
                })
                local List = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = Container,
                })

                local Tab = {
                    Type = "SubTab",
                    Name = Name,
                    MaxHeight = MaxHeight,

                    Connections = {},
                    Destroyed = false,

                    ButtonHolder = Button,
                    Container = Container,
                    ButtonCorner = ButtonCorner,

                    Tab = Tab,
                    Tabbox = Tabbox,

                    Elements = {},
                    DependencyBoxes = {},
                }

                function Tab:Show()
                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Hide()
                    end

                    Button.BackgroundTransparency = 1

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0
                    end
                    if ButtonIcon then
                        SetIconProperties(ButtonIcon, { ImageTransparency = 0 })
                    end

                    Line.Visible = false

                    Container.Visible = true

                    Tabbox.ActiveTab = Tab
                    Tab:Resize()
                    Tabbox:RefreshPopOutPlaceholder()
                end

                function Tab:Hide()
                    Button.BackgroundTransparency = 0

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0.5
                    end
                    if ButtonIcon then
                        SetIconProperties(ButtonIcon, { ImageTransparency = 0.5 })
                    end
                    Line.Visible = true
                    Container.Visible = false

                    Tabbox.ActiveTab = nil
                end

                function Tab:Resize()
                    if Tabbox.ActiveTab ~= Tab then
                        return
                    end

                    local ContentSize = (List.AbsoluteContentSize.Y / Library.DPIScale) + 14
                    local FrameSize = ContentSize
                    local TabMaxHeight = Tab.MaxHeight or Tabbox.MaxHeight
                    if Tabbox.PoppedOut then
                        FrameSize = math.min(ContentSize, GetPopOutBodyMaxHeight(Tabbox, 35))
                    elseif typeof(TabMaxHeight) == "number" then
                        FrameSize = math.min(ContentSize, math.max(TabMaxHeight - 35, 0))
                    end

                    local NeedsScroll = ContentSize > FrameSize + 1
                    Container.CanvasSize = UDim2.fromOffset(0, if NeedsScroll then ContentSize else 0)
                    Container.ScrollingEnabled = NeedsScroll
                    TabboxHolder.Size = UDim2.new(1, 0, 0, FrameSize + 35)

                    if IsNested then
                        ParentObj:Resize()
                    end
                end

                function Tab:SetMaxHeight(NewMaxHeight: number?)
                    if NewMaxHeight ~= nil then
                        assert(typeof(NewMaxHeight) == "number", "MaxHeight must be a number or nil")
                        assert(NewMaxHeight > 0, "MaxHeight must be higher than 0")
                    end

                    Tab.MaxHeight = NewMaxHeight
                    Tab:Resize()
                end

                function Tab:UpdateCorners()
                    local Radius = WindowInfo.CornerRadius

                    ButtonCorner.TopLeftRadius = UDim.new(0, TabIndex == FirstTab and Radius or 0)
                    ButtonCorner.TopRightRadius = UDim.new(0, TabIndex == LastTab and Radius or 0)
                end

                function Tab:Destroy()
                    Tab.Destroyed = true

                    if Tab.Connections then
                        for _, Connection in Tab.Connections do
                            Connection:Disconnect()
                        end
                    end

                    for _, Element in Tab.Elements do
                        if Element.Destroy then
                            Element:Destroy()
                        end
                    end

                    for _, SubDepbox in Tab.DependencyBoxes do
                        if SubDepbox.Destroy then
                            SubDepbox:Destroy()
                        end
                    end

                    if Container then
                        Container:Destroy()
                    end

                    if Button then
                        Button:Destroy()
                    end
                end

                
                if not Tabbox.ActiveTab then
                    Tab:Show()
                end

                Button.MouseButton1Click:Connect(Tab.Show)

                Tab.AddTabbox = AddTabbox
                setmetatable(Tab, BaseGroupbox)

                Tabbox.Tabs[TabStoringIndex] = Tab
                Tabbox:UpdateCorners()

                return Tab, TabStoringIndex
            end

            Library:MakeBoxPopOut(Tabbox, {
                Enabled = Info.PopOut ~= false,
                MaxPopOutHeight = Info.MaxPopOutHeight,
                PopOutWidth = Info.PopOutWidth,

                Header = TabboxButtons,
                Children = function()
                    return { TabboxHolder }
                end,

                After = function()
                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Resize()
                    end
                    if IsNested then
                        ParentObj:Resize()
                    end
                end,
            })

            function Tabbox:Destroy()
                if Tabbox.PoppedOut then
                    Tabbox:SetPoppedOut(false)
                end

                Tabbox.Destroyed = true

                if Tabbox.Connections then
                    for _, Connection in Tabbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Tab in Tabbox.Tabs do
                    if Tab.Destroy then
                        Tab:Destroy()
                    end
                end

                if TabboxHolder then
                    TabboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            if Info.Name then
                Tab.Tabboxes[Info.Name] = Tabbox
            else
                table.insert(Tab.Tabboxes, Tabbox)
            end

            return Tabbox
        end

        Tab.AddTabbox = function(self, Info)
            if HasSubTabs then
                error(string.format("Tab '%s' uses SubTabs, add tabboxes to a subtab instead", Name))
            end

            return AddTabbox(self, Info)
        end

        
        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Side = 1, Name = Name })
        end

        
        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Side = 2, Name = Name })
        end

        function Tab:AddGroupbox(Info)
            if HasSubTabs then
                error(string.format("Tab '%s' uses SubTabs, add groupboxes to a subtab instead", Name))
            end

            Info = Library:Validate(Info, Templates.Groupbox)

            if typeof(Info.Side) == "string" then
                local lowerSide = string.lower(Info.Side)
                if not SideIndex[lowerSide] then
                    error(string.format("Invalid side: %s", Info.Side))
                end

                Info.Side = SideIndex[lowerSide]
            end

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = (Info.Side == 1) and TabLeft or TabRight,
            })
            local BoxHolderList = New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local GroupboxHolder

            local GroupboxTop
            local GroupboxLabel
            local GroupboxDescription

            local GroupboxContainer
            local GroupboxList

            local GroupboxCollapseArrow
            local GroupboxLine

            do
                GroupboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = GroupboxHolder,
                    })
                )
                New("UIListLayout", {
                    Parent = GroupboxHolder,
                })
                Library:AddOutline(GroupboxHolder)

                GroupboxTop = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Parent = GroupboxHolder,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingTop = UDim.new(0, 6),
                    Parent = GroupboxTop,
                })

                local BoxIcon = Library:GetCustomIcon(Info.IconName)
                if BoxIcon then
                    Library:CreateIcon(BoxIcon, {
                        AnchorPoint = Vector2.new(0, 0.5),
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxTop,
                    })
                end

                local RightInset = if Info.DisableCollapsing ~= true then 22 else 0
                local TextsFrame = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
                    Size = UDim2.new(1, -RightInset - (BoxIcon and 24 or 0), 0, 0),
                    Parent = GroupboxTop,
                })
                New("UIListLayout", {
                    Parent = TextsFrame,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 3),
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingTop = UDim.new(0, 3),
                    Parent = TextsFrame,
                })

                GroupboxLabel = New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Text = Info.Name,
                    TextSize = 15,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TextsFrame,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 1),
                    Parent = GroupboxLabel,
                })

                GroupboxDescription = New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Text = Info.Description or "",
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Visible = (Info.Description ~= nil),
                    Parent = TextsFrame,
                })

                GroupboxCollapseArrow = Library:CreateIcon(ArrowIcon, {
                    Visible = Info.DisableCollapsing ~= true,
                    AnchorPoint = Vector2.new(1, 0.5),
                    ImageColor3 = "WhiteColor",
                    Position = UDim2.fromScale(1, 0.5),
                    Rotation = 180,
                    Size = UDim2.fromOffset(22, 22),
                    Parent = GroupboxTop,
                }, true)

                GroupboxLine = Library:MakeLine(GroupboxHolder, {
                    LayoutOrder = 1,
                    Size = UDim2.new(1, 0, 0, 1),
                })

                GroupboxContainer = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.fromOffset(0, 0),
                    LayoutOrder = 2,
                    ScrollBarImageTransparency = 1,
                    ScrollBarThickness = 0,
                    ScrollingEnabled = false,
                    Size = UDim2.fromScale(1, 0),
                    Parent = GroupboxHolder,
                })

                GroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = GroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = GroupboxContainer,
                })
            end

            local Groupbox: any = {
                Type = "Groupbox",

                Name = Info.Name,
                Description = Info.Description,

                Connections = {},
                Destroyed = false,

                Visible = true,
                Collapsed = false,
                MaxHeight = Info.MaxHeight,

                BoxHolder = BoxHolder,
                Holder = GroupboxHolder,
                Container = GroupboxContainer,

                Tab = Tab,
                DependencyBoxes = {},
                Elements = {}
            }

            local ResizeTween
            local CollapseArrowTween

            local function RefreshBoxHolderLayout()
                BoxHolder.AutomaticSize = Enum.AutomaticSize.None
                BoxHolder.Size = UDim2.new(1, 0, 0, BoxHolderList.AbsoluteContentSize.Y / Library.DPIScale + 8)
                BoxHolder.AutomaticSize = Enum.AutomaticSize.Y
            end
            Groupbox.RefreshBoxHolderLayout = RefreshBoxHolderLayout

            function Groupbox:Resize()
                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                local TopSize = (GroupboxTop.AbsoluteSize.Y / Library.DPIScale)
                local ContentSize = (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 14
                local ContainerSize = ContentSize
                if Groupbox.PoppedOut then
                    ContainerSize = math.min(ContainerSize, GetPopOutBodyMaxHeight(Groupbox, TopSize + 1))
                elseif typeof(Groupbox.MaxHeight) == "number" then
                    ContainerSize = math.min(ContainerSize, math.max(Groupbox.MaxHeight - TopSize - 1, 0))
                end

                local NeedsScroll = ContentSize > ContainerSize + 1
                GroupboxContainer.CanvasSize = UDim2.fromOffset(0, if NeedsScroll then ContentSize else 0)
                GroupboxContainer.ScrollingEnabled = NeedsScroll

                local TargetSize = UDim2.new(1, 0, 0, if Groupbox.Collapsed then TopSize else (TopSize + 1 + ContainerSize))
                GroupboxContainer.Size = UDim2.new(1, 0, 0, ContainerSize)
                GroupboxLine.Visible = not Groupbox.Collapsed

                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
                    ResizeTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if ResizeTween == Tween then
                            StopTween(ResizeTween, true)
                            ResizeTween = nil
                        end

                        RefreshBoxHolderLayout()
                    end))

                    Tween:Play()
                else
                    GroupboxHolder.Size = TargetSize
                    RefreshBoxHolderLayout()
                end
            end

            table.insert(Groupbox.Connections, GroupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if Groupbox.Visible == false or Groupbox.Destroyed then
                    return
                end

                Groupbox:Resize()
            end))

            function Groupbox:SetDescription(Description: string | nil)
                GroupboxDescription.Text = Description or ""
                GroupboxDescription.Visible = (Description ~= nil)

                Groupbox:Resize()
            end

            function Groupbox:SetCollapsed(Collapsed: boolean)
                if Info.DisableCollapsing == true then return end
                Groupbox.Collapsed = Collapsed

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                local TargetRotation = if Collapsed then 0 else 180

                GroupboxContainer.Visible = not Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxCollapseArrow, TweenInfo, { Rotation = TargetRotation })
                    CollapseArrowTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Connect(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if CollapseArrowTween == Tween then
                            StopTween(CollapseArrowTween, true)
                            CollapseArrowTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxCollapseArrow.Rotation = TargetRotation
                end

                Groupbox:Resize()
            end

            function Groupbox:ToggleCollapsed()
                if Info.DisableCollapsing == true then return end
                Groupbox:SetCollapsed(not Groupbox.Collapsed)
            end

            function Groupbox:SetMaxHeight(MaxHeight: number?)
                if MaxHeight ~= nil then
                    assert(typeof(MaxHeight) == "number", "MaxHeight must be a number or nil")
                    assert(MaxHeight > 0, "MaxHeight must be higher than 0")
                end

                Groupbox.MaxHeight = MaxHeight
                Groupbox:Resize()
            end

            Library:MakeBoxPopOut(Groupbox, {
                Enabled = Info.PopOut ~= false,
                MaxPopOutHeight = Info.MaxPopOutHeight,
                PopOutWidth = Info.PopOutWidth,

                Header = GroupboxTop,
                Children = function()
                    local Children = {}
                    for _, Child in BoxHolder:GetChildren() do
                        if Child:IsA("GuiObject") and Child ~= Groupbox.PopOutPlaceholder then
                            table.insert(Children, Child)
                        end
                    end
                    return Children
                end,

                Before = function()
                    GroupboxCollapseArrow.Visible = false
                end,
                After = function()
                    GroupboxCollapseArrow.Visible = Info.DisableCollapsing ~= true
                    Groupbox:Resize()
                end
            })

            function Groupbox:Destroy()
                if Groupbox.PoppedOut then
                    Groupbox:SetPoppedOut(false)
                end

                Groupbox.Destroyed = true

                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                if Groupbox.Connections then
                    for _, Connection in Groupbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Element in Groupbox.Elements do
                    if Element.Destroy then
                        Element:Destroy()
                    end
                end
                table.clear(Groupbox.Elements)

                for _, SubDepbox in Groupbox.DependencyBoxes do
                    if SubDepbox.Destroy then
                        SubDepbox:Destroy()
                    end
                end
                table.clear(Groupbox.DependencyBoxes)

                if GroupboxHolder then
                    GroupboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            function Groupbox:SetVisible(Visible: boolean)
                Groupbox.Visible = Visible
                BoxHolder.Visible = Visible
                SyncPopOutVisibility(Groupbox)

                if Visible == true and Library.Searching then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function Groupbox:Show()
                Groupbox:SetVisible(true)
            end

            function Groupbox:Hide()
                Groupbox:SetVisible(false)
            end

            if Info.DisableCollapsing ~= true then
                GroupboxCollapseArrow.MouseButton1Click:Connect(function()
                    Groupbox:ToggleCollapsed()
                end)
            end

            Groupbox.AddTabbox = AddTabbox
            setmetatable(Groupbox, BaseGroupbox)

            Groupbox:Resize()
            Tab.Groupboxes[Info.Name] = Groupbox

            if Info.Visible == false then
                Groupbox:Hide()
            end

            if Info.DisableCollapsing ~= true and Info.Collapsed == true then
                Groupbox:SetCollapsed(true)
            end

            return Groupbox
        end

        
        function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 1, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
        end

        
        function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 2, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
        end

        local function IsActive()
            if ParentTab then
                return ParentTab.ActiveSubTab == Tab
            end

            return Library.ActiveTab == Tab
        end

        function Tab:Hover(Hovering)
            if IsActive() then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = Hovering and 0.25 or 0.5 })
            end
        end

        function Tab:UpdateTabInfo()
            local SubTab = Tab.ActiveSubTab
            if SubTab then
                local Title = string.format('<font transparency="0.5">%s /</font> <b>%s</b>', EscapeRichText(Name), EscapeRichText(SubTab.Name))
                Window:ShowTabInfo(Title, SubTab.Description or Description, true)
            elseif Description then
                Window:ShowTabInfo(Name, Description)
            else
                Window:HideTabInfo()
            end
        end

        local function SetButtonActive(Active: boolean)
            if TabStroke then
                TweenService:Create(TabStroke, Library.TweenInfo, {
                    Color = Active and Library.Scheme.AccentColor or Library.Scheme.OutlineColor,
                }):Play()
            else
                TweenService:Create(TabButton, Library.TweenInfo, {
                    BackgroundTransparency = Active and 0 or 1,
                }):Play()
            end
            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = Active and 0 or 1,
                }):Play()
            end
            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Active and 0 or 0.5,
            }):Play()
            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = Active and 0 or 0.5 })
            end
        end

        function Tab:Show(KeepParent: boolean?)
            if ParentTab then
                if ParentTab.ActiveSubTab == Tab then
                    if not KeepParent and Library.ActiveTab ~= ParentTab then
                        ParentTab:Show()
                    end

                    return
                end

                local ParentActive = Library.ActiveTab == ParentTab
                if ParentTab.ActiveSubTab then
                    ParentTab.ActiveSubTab:Hide()
                end

                ParentTab.ActiveSubTab = Tab
                ParentTab.Sides = Tab.Sides
                SetButtonActive(true)

                if ParentActive then
                    Library:PlayTabAnimation(Tab, true, nil, ParentTab.PreviousSubTab)
                    Tab:RefreshSides()
                    ParentTab:UpdateTabInfo()

                    if Library.Searching then
                        Library:UpdateSearch(Library.SearchText)
                    end
                else
                    TabContainer.Position = UDim2.fromScale(0, 0)
                    TabContainer.Visible = true
                    Tab:RefreshSides()

                    if not KeepParent then
                        ParentTab:Show()
                    end
                end

                return
            end

            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            SetButtonActive(true)
            Tab:UpdateTabInfo()

            Library:PlayTabAnimation(Tab, true)
            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            SetButtonActive(false)

            if ParentTab then
                Library:PlayTabAnimation(Tab, false)

                ParentTab.PreviousSubTab = Tab
                if ParentTab.ActiveSubTab == Tab then
                    ParentTab.ActiveSubTab = nil
                    ParentTab.Sides = {}
                end

                return
            end

            Library:PlayTabAnimation(Tab, false)
            Window:HideTabInfo()

            Library.PreviousTab = Tab
            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if Visible or not IsActive() then
                return
            end

            Tab:Hide()

            if ParentTab then
                for _, SubTab in ParentTab.SubTabs do
                    if SubTab ~= Tab and SubTab.Button.Visible then
                        SubTab:Show()
                        break
                    end
                end
            end
        end

        function Tab:AddSubTab(...)
            if not HasSubTabs then
                error(string.format("Tab '%s' was not created with SubTabs = true", Name))
            end

            local SubTab = CreateTab(Tab, ...)
            Tab.SubTabCount += 1
            table.insert(Tab.SubTabs, SubTab)

            if not Tab.ActiveSubTab then
                SubTab:Show(true)
            end

            return SubTab
        end

        function Tab:SetOrder(NewOrder: number)
            Order = NewOrder
            TabButton.LayoutOrder = Order
        end

        function Tab:SetTooltip(Text: string?)
            Tab.Tooltip = Text

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            if typeof(Text) == "string" then
                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
            end
        end

        function Tab:Destroy()
            Tab.Destroyed = true

            if Tab.Connections then
                for _, Connection in Tab.Connections do
                    Connection:Disconnect()
                end
            end

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            for _, Groupbox in Tab.Groupboxes do
                if Groupbox.Destroy then
                    Groupbox:Destroy()
                end
            end
            table.clear(Tab.Groupboxes)

            for _, Tabbox in Tab.Tabboxes do
                if Tabbox.Destroy then
                    Tabbox:Destroy()
                end
            end
            table.clear(Tab.Tabboxes)

            for _, DepGroupbox in Tab.DependencyGroupboxes do
                if DepGroupbox.Destroy then
                    DepGroupbox:Destroy()
                end
            end

            for Index = #Tab.SubTabs, 1, -1 do
                local SubTab = Tab.SubTabs[Index]
                if SubTab and not SubTab.Destroyed then
                    SubTab:Destroy()
                end
            end
            table.clear(Tab.SubTabs)

            if ParentTab then
                local SubIndex = table.find(ParentTab.SubTabs, Tab)
                if SubIndex then
                    table.remove(ParentTab.SubTabs, SubIndex)
                end

                if ParentTab.ActiveSubTab == Tab then
                    ParentTab.ActiveSubTab = nil
                    ParentTab.Sides = {}

                    local NextSubTab = ParentTab.SubTabs[1]
                    if NextSubTab then
                        NextSubTab:Show(true)
                    end

                    if Library.ActiveTab == ParentTab then
                        ParentTab:UpdateTabInfo()
                    end
                end
            end

            if TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end

                TabButton:Destroy()
            end

            Library.Tabs[TabKey] = nil
        end

        
        if typeof(Tooltip) == "string" then
            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
        end

        if not ParentTab and not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(function()
            Tab:Show()
        end)

        Library.Tabs[TabKey] = Tab

        return Tab
    end

    function Window:AddTab(...)
        return CreateTab(nil, ...)
    end

    function Window:AddKeyTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil
        local Tooltip = nil
        local Order = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
            Tooltip = Info.Tooltip
            Order = Info.Order
        else
            Name = select(1, ...) or "Tab"
            Icon = select(2, ...)
            Description = select(3, ...)
            Order = select(4, ...)
        end

        if not tonumber(Order) then
            Order = #Tabs:GetChildren()
        end

        Icon = Icon or "key"

        local TabButton: TextButton
        local TabIndicator
        local TabLabel
        local TabIcon

        local TabContainer

        Icon = if Icon == "key" then KeyIcon else Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                LayoutOrder = Order,
                Parent = Tabs,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
                Parent = TabButton,
            })

            if TabButtonsStyle.Indicator then
                TabIndicator = New("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = "AccentColor",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0.5, 0),
                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
                    Parent = TabButton,
                })

                New("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = TabIndicator,
                })
            end

            local ButtonHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = TabButton,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = ButtonHolder,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = ButtonHolder,
            })

            if Icon then
                TabIcon = Library:CreateIcon(Icon, {
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = ButtonHolder,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            
            TabContainer = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarThickness = 0,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })
            New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = TabContainer,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                Parent = TabContainer,
            })
        end

        
        local Tab = {
            Description = Description,
            IsKeyTab = true,

            Tooltip = Tooltip,
            TooltipTable = nil,

            Elements = {},

            Window = Window,
            Button = TabButton,
            Container = TabContainer
        }

        function Tab:AddKeyBox(Callback)
            assert(typeof(Callback) == "function", "Callback must be a function")

            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.75, 0, 0, 21),
                Parent = TabContainer,
            })

            local Box = New("TextBox", {
                BackgroundColor3 = "MainColor",
                PlaceholderText = "按键",
                Size = UDim2.new(1, -71, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Box,
            })
            local BoxStroke = New("UIStroke", {
                Color = "OutlineColor",
                Parent = Box,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Box,
                })
            )

            Box.Focused:Connect(function()
                Library.Registry[BoxStroke].Color = "AccentColor"
                TweenService:Create(BoxStroke, Library.TweenInfo, {
                    Color = Library.Scheme.AccentColor,
                }):Play()
            end)

            Box.FocusLost:Connect(function()
                Library.Registry[BoxStroke].Color = "OutlineColor"
                TweenService:Create(BoxStroke, Library.TweenInfo, {
                    Color = Library.Scheme.OutlineColor,
                }):Play()
            end)

            local Button = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 63, 1, 0),
                Text = "执行",
                TextSize = 14,
                TextTransparency = 0.4,
                Parent = Holder,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Button,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
            )

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, Library.TweenInfo, {
                    TextTransparency = 0,
                }):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, Library.TweenInfo, {
                    TextTransparency = 0.4,
                }):Play()
            end)

            Button.InputBegan:Connect(function(Input)
                if not IsClickInput(Input) then
                    return
                end

                if not Library:MouseIsOverFrame(Button, Input.Position) then
                    return
                end

                Callback(Box.Text)
            end)
        end
        function Tab:Destroy()
            if TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end

                TabButton:Destroy()
            end

            Library.Tabs[Name] = nil
        end

        function Tab:SetOrder(NewOrder: number)
            Order = NewOrder
            TabButton.LayoutOrder = Order
        end

        function Tab:RefreshSides() end
        function Tab:Resize() end
        function Tab:UpdateCorners() end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = Hovering and 0.25 or 0.5 })
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()

            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = 0,
                }):Play()
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()

            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = 0 })
            end

            Library:PlayTabAnimation(Tab, true)

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = 0.5 })
            end

            Library:PlayTabAnimation(Tab, false)
            Window:HideTabInfo()

            Library.PreviousTab = Tab
            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        function Tab:SetTooltip(Text: string?)
            Tab.Tooltip = Text

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            if typeof(Text) == "string" then
                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
            end
        end

        
        if typeof(Tooltip) == "string" then
            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
        end

        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Tab.Container = TabContainer
        setmetatable(Tab, BaseGroupbox)

        Library.Tabs[Name] = Tab

        return Tab
    end

    function Window:AddCustomTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil
        local Tooltip = nil
        local Order = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
            Tooltip = Info.Tooltip
            Order = Info.Order
        else
            Name = select(1, ...) or "Tab"
            Icon = select(2, ...)
            Description = select(3, ...)
            Order = select(4, ...)
        end

        if not tonumber(Order) then
            Order = #Tabs:GetChildren()
        end

        local TabButton: TextButton
        local TabIndicator
        local TabLabel
        local TabIcon

        local TabContainer

        Icon = Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                LayoutOrder = Order,
                Parent = Tabs,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
                Parent = TabButton,
            })

            if TabButtonsStyle.Indicator then
                TabIndicator = New("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = "AccentColor",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0.5, 0),
                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
                    Parent = TabButton,
                })

                New("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = TabIndicator,
                })
            end

            local ButtonHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = TabButton,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = ButtonHolder,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = ButtonHolder,
            })

            if Icon then
                TabIcon = Library:CreateIcon(Icon, {
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageTransparency = 0.5,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = ButtonHolder,
                })
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            
            TabContainer = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })
        end

        
        local Tab = {
            Name = Name,
            Description = Description,
            IsCustomTab = true,

            Tooltip = Tooltip,
            TooltipTable = nil,

            Connections = {},
            Destroyed = false,

            Window = Window,
            Button = TabButton,
            Container = TabContainer,
            Sides = {},

            Groupboxes = {},
            Tabboxes = {},
            DependencyGroupboxes = {},
        }

        function Tab:RefreshSides() end
        function Tab:Resize() end
        function Tab:UpdateCorners() end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = Hovering and 0.25 or 0.5 })
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()

            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = 0,
                }):Play()
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()

            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = 0 })
            end

            Library:PlayTabAnimation(Tab, true)

            if Description then
                Window:ShowTabInfo(Name, Description)
            end

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenIcon(TabIcon, { ImageTransparency = 0.5 })
            end

            Library:PlayTabAnimation(Tab, false)
            Window:HideTabInfo()

            Library.PreviousTab = Tab
            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        function Tab:SetOrder(NewOrder: number)
            Order = NewOrder
            TabButton.LayoutOrder = Order
        end

        function Tab:SetTooltip(Text: string?)
            Tab.Tooltip = Text

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            if typeof(Text) == "string" then
                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
            end
        end

        function Tab:Destroy()
            Tab.Destroyed = true

            if Tab.Connections then
                for _, Connection in Tab.Connections do
                    Connection:Disconnect()
                end
            end

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            if Library.ActiveTab == Tab then
                Tab:Hide()
            end

            if TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end

                TabButton:Destroy()
            end

            Library.Tabs[Name] = nil
        end

        
        if typeof(Tooltip) == "string" then
            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
        end

        if not Library.ActiveTab then
            Tab:Show()
        end

        table.insert(Tab.Connections, TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end))
        table.insert(Tab.Connections, TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end))
        table.insert(Tab.Connections, TabButton.MouseButton1Click:Connect(Tab.Show))

        Library.Tabs[Name] = Tab

        return TabContainer, Tab
    end

    function Window:AddDialog(Idx, Info)
        Info = Library:Validate(Info, Templates.Dialog)

        local DialogFrame
        local DialogOverlay
        local DialogContainer
        local ButtonsHolder
        local FooterButtonsList = {}

        DialogOverlay = New("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = "DarkColor",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Active = false,
            ZIndex = 9000,
            Visible = true,
            Parent = MainFrame,
        })
        TweenService:Create(DialogOverlay, Library.TweenInfo, {
            BackgroundTransparency = 0.5,
        }):Play()

        DialogFrame = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "BackgroundColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 1,
            Parent = DialogOverlay,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = DialogFrame,
            })
        )
        Library:AddOutline(DialogFrame)

        local InnerContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
            Parent = DialogFrame,
        })
        local DialogScale = New("UIScale", {
            Scale = 0.95,
            Parent = DialogFrame,
        })
        TweenService:Create(DialogScale, Library.TweenInfo, {
            Scale = 1
        }):Play()
        local _InnerPadding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            Parent = InnerContainer,
        })
        local _InnerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = InnerContainer,
        })

        local HeaderContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 2,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = HeaderContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = HeaderContainer,
        })

        local TitleRow = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 2,
            Parent = HeaderContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TitleRow,
        })

        if Info.Icon then
            local ParsedIcon = Library:GetCustomIcon(Info.Icon)
            if ParsedIcon then
                Library:CreateIcon(ParsedIcon, {
                    Size = UDim2.fromOffset(16, 16),
                    ImageColor3 = Info.TitleColor or "FontColor",
                    LayoutOrder = 1,
                    ZIndex = 2,
                    Parent = TitleRow,
                })
            end
        end

        local TitleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Title,
            TextSize = 18,
            TextColor3 = Info.TitleColor or "FontColor",
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 2,
            Parent = TitleRow,
        })

        local DescriptionLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Description,
            TextSize = 14,
            TextTransparency = Info.DescriptionColor and 0 or 0.2,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Info.DescriptionColor or "FontColor",
            TextWrapped = true,
            LayoutOrder = 2,
            ZIndex = 2,
            Parent = HeaderContainer,
        })

        DialogContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 4,
            ZIndex = 2,
            Parent = InnerContainer,
        })
        local _DialogContainerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DialogContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = DialogContainer,
        })

        local _Sep2 = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = 5,
            ZIndex = 2,
            Parent = InnerContainer,
        })

        ButtonsHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 6,
            ZIndex = 2,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ButtonsHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            Parent = ButtonsHolder,
        })

        local Dialog = {
            Destroyed = false,
            Elements = {},
            Container = DialogContainer,
            OutsideClickDismiss = Info.OutsideClickDismiss,
        }

        function Dialog:Resize()
            local MaxWidth = (MainFrame.AbsoluteSize.X / Library.DPIScale) * 0.75
            local MinWidth = 400

            local TotalButtonWidth = 0
            local ButtonCount = 0
            local HasButtons = false

            for _, BtnWrap in FooterButtonsList do
                HasButtons = true
                ButtonCount = ButtonCount + 1
                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
            end

            local TargetWidth = MinWidth
            if HasButtons then
                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
            end

            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

            local _DescX, DescY = Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

            local HasElements = false
            for _, v in DialogContainer:GetChildren() do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                    HasElements = true
                    break
                end
            end
            DialogContainer.Visible = HasElements

            ButtonsHolder.Visible = HasButtons
            _Sep2.Visible = HasButtons
        end

        function Dialog:SetTitle(Title)
            TitleLabel.Text = Title
            Dialog:Resize()
        end

        function Dialog:SetDescription(Description)
            DescriptionLabel.Text = Description
            Dialog:Resize()
        end

        function Dialog:Dismiss()
            if Dialog.Destroyed then
                return
            end

            Dialog.Destroyed = true

            if Library.ActiveDialog == Dialog then
                Library.ActiveDialog = nil
            end

            for Index = #Dialog.Elements, 1, -1 do
                local Element = Dialog.Elements[Index]
                if Element and Element.Destroy then
                    Element:Destroy()
                end
            end
            table.clear(Dialog.Elements)

            local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
            TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
            CloseTween:Play()

            task.delay(Library.TweenInfo.Time, function()
                DialogOverlay:Destroy()
            end)
            Library.Dialogues[Idx] = nil
        end

        DialogOverlay.MouseButton1Click:Connect(function()
            if Info.OutsideClickDismiss then
                Dialog:Dismiss()
            end
        end)

        function Dialog:RemoveFooterButton(ButtonIdx)
            if FooterButtonsList[ButtonIdx] then
                FooterButtonsList[ButtonIdx].Container:Destroy()
                FooterButtonsList[ButtonIdx] = nil
            end
        end

        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
            if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
            end
        end

        function Dialog:SetButtonOrder(ButtonIdx, Order)
            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
            end
        end

        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
            Dialog:RemoveFooterButton(ButtonIdx)

            local WaitTime = ButtonInfo.WaitTime or 0

            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                LayoutOrder = ButtonInfo.Order or 0,
                ZIndex = 2,
                Parent = ButtonsHolder,
            })

            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"

            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 2,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = TextBtn
                })
            )

            local _BtnPadding = New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or ButtonIdx,
                TextColor3 = TextColor,
                TextTransparency = WaitTime > 0 and 0.5 or 0,
                TextSize = 14,
                ZIndex = 2,
                Parent = TextBtn,
            })

            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ProgressBar
            if WaitTime > 0 then
                ProgressBar = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -2),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 2,
                    Parent = TextBtn,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius),
                        Parent = ProgressBar
                    })
                )
            end

            local IsActive = WaitTime <= 0

            local ButtonWrap = {
                Container = ButtonContainer,
                SetDisabled = function(self, Disabled)
                    IsActive = not Disabled
                    if Disabled then
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
                    else
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
                    end
                end
            }

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if not IsActive then return end
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Dialog)
                end
                if Info.AutoDismiss then
                    Dialog:Dismiss()
                end
            end)

            if WaitTime > 0 then
                TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, 0, 2)
                }):Play()

                task.delay(WaitTime, function()
                    ButtonWrap:SetDisabled(false)
                    if ProgressBar then
                        TweenService:Create(ProgressBar, Library.TweenInfo, {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end)
            end

            FooterButtonsList[ButtonIdx] = ButtonWrap
        end

        for BIdx, BInfo in Info.FooterButtons do
            if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
            Dialog:AddFooterButton(BIdx, BInfo)
        end

        setmetatable(Dialog, BaseGroupbox)
        Library.Dialogues[Idx] = Dialog

        Dialog:Resize()

        Library.ActiveDialog = Dialog
        return Dialog
    end

    function Window:Toggle(Value: boolean?)
        if Fading then
            return
        end

        if Library.ActiveLoading then
            if Value == true then
                return
            end

            if not Library.Toggled then
                return
            end
        end

        if typeof(Value) == "boolean" then
            Library.Toggled = Value
        else
            Library.Toggled = not Library.Toggled
        end

        if Library.Animations and Library.Animations.ToggleWindow == true then
            local Toggled = Library.Toggled
            Fading = true

            local FadeGroup = New("CanvasGroup", {
                BackgroundTransparency = 1,
                GroupTransparency = Toggled and 1 or 0,
                Name = "MainFade",
                Size = UDim2.fromScale(1, 1),
                ZIndex = MainFrame.ZIndex,
                Parent = ScreenGui,
            })

            MainFrame.Visible = true
            MainFrame.Parent = FadeGroup

            task.spawn(function()
                RunService.Heartbeat:Wait()
                RunService.Heartbeat:Wait()

                TweenService:Create(FadeGroup, Library.WindowAnimationInfo, { GroupTransparency = Toggled and 0 or 1 }):Play()
                task.wait(Library.WindowAnimationInfo.Time)

                Fading = false
                if Library.Unloaded then
                    return
                end

                MainFrame.Visible = Library.Toggled
                MainFrame.Parent = ScreenGui
                FadeGroup:Destroy()
            end)
        else
            MainFrame.Visible = Library.Toggled
        end

        if WindowInfo.UnlockMouseWhileOpen then
            ModalElement.Modal = Library.Toggled
        end

        if Library.Toggled and not Library.IsMobile then
            local ShowCursorBinding = Library.ShowCursorBinding
            Library.OriginalMouseIconEnabled = UserInputService.MouseIconEnabled

            pcall(function() RunService:UnbindFromRenderStep(ShowCursorBinding) end)
            RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
                UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
                Cursor.Visible = Library.ShowCustomCursor

                if Library.Unloaded == true or not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                    RestoreMouseIcon()
                end
            end)
        elseif not Library.Toggled then
            RestoreMouseIcon()
            TooltipLabel.Visible = false

            CloseMenus()
        end
    end

    function Library:Toggle(Value: boolean?)
        return Window:Toggle(Value)
    end

    if WindowInfo.EnableSidebarResize then
        local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth) * WindowInfo.SidebarCollapseThreshold
        local StartPos, StartWidth
        local Dragging = false
        local Changed

        local SidebarGrabber = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(0, 8, 1, 0),
            Text = "",
            Parent = DividerLine,
        })
        SidebarGrabber.MouseEnter:Connect(function()
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
            }):Play()
        end)
        SidebarGrabber.MouseLeave:Connect(function()
            if Dragging then
                return
            end
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.OutlineColor,
            }):Play()
        end)

        SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) then
                return
            end

            Library.CantDragForced = true

            StartPos = Input.Position
            StartWidth = Window:GetSidebarWidth()
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Library.CantDragForced = false
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                local Width = StartWidth + Delta.X

                if WindowInfo.DisableCompactingSnap then
                    Window:SetSidebarWidth(Width)
                    return
                end

                if Width > Threshold then
                    Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
                else
                    Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
                end
            end
        end))
    end

    Window:SetAlwaysOnTop(WindowInfo.AlwaysOnTop)
    if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
    end
    if WindowInfo.AutoShow and not Library.ActiveLoading then
        task.spawn(Library.Toggle)
    end

    if Library.IsMobile then
        local ToggleButton = Library:AddDraggableButton("切换", function()
            Library:Toggle()
        end, true)

        local LockButton = Library:AddDraggableButton("锁定", function(self)
            Library.CantDragForced = not Library.CantDragForced
            self:SetText(Library.CantDragForced and "解锁" or "锁定")
        end, true)

        if WindowInfo.MobileButtonsSide == "Right" then
            ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)
            ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)

            LockButton.Button.AnchorPoint = Vector2.new(1, 0)
            LockButton.Button.Position = UDim2.new(1, -(ToggleButton.Button.Size.X.Offset + 12), 0, 6)
        else
            ToggleButton.Button.AnchorPoint = Vector2.new(0, 0)
            ToggleButton.Button.Position = UDim2.fromOffset(6, 6)

            LockButton.Button.AnchorPoint = Vector2.new(0, 0)
            LockButton.Button.Position = UDim2.fromOffset(ToggleButton.Button.Size.X.Offset + 12, 6)
        end

        if WindowInfo.ShowMobileButtons == false then
            ToggleButton.Button.Visible = false
            LockButton.Button.Visible = false
        end
    end

    
    Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Library:UpdateSearch(SearchBox.Text)
    end))

    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
        if Library.Unloaded then
            return
        end

        if Input.KeyCode == Enum.KeyCode.Escape then
            
            local FocusedBox = UserInputService:GetFocusedTextBox()
            if FocusedBox then
                FocusedBox:ReleaseFocus()
                return
            end

            
            if Library.ActiveDialog and Library.ActiveDialog.OutsideClickDismiss ~= false then
                Library.ActiveDialog:Dismiss()
                return
            end

            if CurrentMenu then
                CurrentMenu:Close()
                return
            end

            return
        end

        if UserInputService:GetFocusedTextBox() then
            return
        end

        if Input.KeyCode == Library.ToggleKeybind then
            Library:Toggle()
        end
    end))

    Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
        Library.IsRobloxFocused = true
    end))
    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
        Library.IsRobloxFocused = false
    end))

    Window.MainFrame = MainFrame
    Library.Window = Window

    return Window
end

function Library:CreateLoading(LoadingInfo)
    if Library.ActiveLoading then
        warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
        return Library.ActiveLoading
    end

    LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

    local Loading = {
        CurrentStep = LoadingInfo.CurrentStep,
        TotalSteps = LoadingInfo.TotalSteps,

        ShowSidebar = LoadingInfo.ShowSidebar,
        AutoResizeHeight = LoadingInfo.AutoResizeHeight,
        AlwaysOnTop = LoadingInfo.AlwaysOnTop,

        IsError = false,
        Destroyed = false,

        WindowWidth = LoadingInfo.WindowWidth,
        WindowHeight = LoadingInfo.WindowHeight,
        BaseWindowHeight = LoadingInfo.WindowHeight,
        WindowErrorHeight = LoadingInfo.WindowHeight,

        ContentWidth = LoadingInfo.ContentWidth,
        SidebarWidth = LoadingInfo.SidebarWidth,
    }

    
    local ScreenGui = New("ScreenGui", {
        Name = RandomGuiName(),
        
        
        
        AutoLocalize = false,
        DisplayOrder = 999,
        ResetOnSpawn = false
    })
    ParentUI(ScreenGui)
    Loading.ScreenGui = ScreenGui
    SetAlwaysOnTop(ScreenGui, LoadingInfo.AlwaysOnTop)

    ScreenGui.DescendantRemoving:Connect(function(Instance)
        task.defer(function()
            if Instance.Parent and Instance:IsDescendantOf(ScreenGui) then
                return
            end

            Library:RemoveFromRegistry(Instance)
        end)
    end)

    
    local MainFrame = New("TextButton", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = function()
            return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
        end,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth, Loading.WindowHeight),
        ClipsDescendants = true,
        Text = "",
        AutoButtonColor = false,
        Parent = ScreenGui,
    })
    Library:AddOutline(MainFrame)
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame }))

    local MainScale = New("UIScale", {
        Scale = Library.IsMobile and 0.8 or 1,
        Parent = MainFrame
    })
    table.insert(Library.Scales, MainScale)
    Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

    
    local Container = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
        Parent = MainFrame,
    })

    local SideBar = New("Frame", {
        Name = "SideBar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(Loading.ContentWidth, 0),
        Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
        ClipsDescendants = true,
        Visible = Loading.ShowSidebar,
        Parent = MainFrame,
    })
    local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
    table.insert(Library.Corners, SidebarCorner)

    Library:AddOutline(SideBar)

    local SidebarDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        Visible = Loading.ShowSidebar,
        Parent = SideBar,
    })

    
    local TopBar = New("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 2,
        Parent = Container,
    })
    Library:MakeDraggable(MainFrame, TopBar, true, true)

    local TitleHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = TopBar,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = TitleHolder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        Parent = TitleHolder,
    })

    if LoadingInfo.Icon then
        Library:CreateIcon(Library:GetCustomIcon(LoadingInfo.Icon), {
            Size = LoadingInfo.IconSize,
            Parent = TitleHolder,
        })
    else
        New("TextLabel", {
            BackgroundTransparency = 1,
            Size = LoadingInfo.IconSize,
            Text = LoadingInfo.Title:sub(1, 1),
            TextScaled = true,
            Visible = false,
            Parent = TitleHolder,
        })
    end

    local LoadingIconWidth = LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0
    local LoadingMaxWidth = math.max(0, (TitleHolder.AbsoluteSize.X / Library.DPIScale) - LoadingIconWidth - 12)
    local LoadingTitleWidth = math.min(
        Library:GetTextBounds(LoadingInfo.Title, Library.Scheme.Font, 20),
        LoadingMaxWidth
    )
    local _WindowTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, LoadingTitleWidth, 1, 0),
        Text = LoadingInfo.Title,
        TextSize = 20,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = TitleHolder,
    })

    Library:MakeLine(Container, {
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 0, 1),
    })

    
    local InnerContent = New("Frame", {
        Name = "InnerContent",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        Parent = Container,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12),
        Parent = InnerContent,
    })

    local IconHolder = New("Frame", {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(64, 64),
        Parent = InnerContent,
    })

    local LoadingIcon = Library:CreateIcon(Library:GetCustomIcon(LoadingInfo.LoadingIcon), {
        Name = "LoaderIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        ImageColor3 = LoadingInfo.LoadingIconColor or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
        Parent = IconHolder,
    })

    local RotationTween
    if LoadingInfo.LoadingIconTweenTime > 0 then
        RotationTween = TweenService:Create(
            LoadingIcon,
            TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
            { Rotation = 360 }
        )
        RotationTween:Play()
    end

    local MessageLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 18,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    local DescriptionLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 14,
        TextTransparency = 0.5,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    
    local SliderBar = New("Frame", {
        BackgroundColor3 = "MainColor",
        Size = UDim2.new(0.7, 0, 0, 15),
        Parent = InnerContent,
    })
    Library:AddOutline(SliderBar)
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar }))

    local SliderFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        Parent = SliderBar,
    })
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill }))

    local ProgressLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextSize = 14,
        ZIndex = 2,
        Parent = SliderBar,
    })
    New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Color = GetTextStrokeColor,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = ProgressLabel,
    })

    
    local SidebarScrolling = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = "OutlineColor",
        Parent = SideBar,
    })
    local SidebarList = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SidebarScrolling,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        Parent = SidebarScrolling,
    })

    local SidebarObject = {
        Elements = {},
        DependencyBoxes = {},
        Tabboxes = {},

        BoxHolder = SidebarScrolling,
        Container = SidebarScrolling,

        Resize = function(self)
            SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
        end,
        Tab = {
            Elements = {},
            DependencyBoxes = {},
            DependencyGroupboxes = {},
            Tabboxes = {},
        },
    }

    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarObject:Resize()
    end)

    setmetatable(SidebarObject, BaseGroupbox)
    Loading.Sidebar = SidebarObject

    
    local ErrorFrame = New("Frame", {
        Name = "错误",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        ClipsDescendants = true,
        Visible = false,
        Parent = Container,
    })

    local _ErrorTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 18),
        Text = "错误",
        TextColor3 = "RedColor",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ErrorFrame,
    })

    local ErrorLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 39),
        Size = UDim2.new(1, -30, 1, -90),
        Text = "错误信息",
        TextSize = 14,
        TextTransparency = 0.2,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ErrorFrame,
    })

    local ErrorButtonsDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 1, -48),
        Size = UDim2.new(1, -30, 0, 1),
        Visible = false,
        Parent = ErrorFrame,
    })

    local ErrorButtonsHolder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 42),
        Visible = false,
        Parent = ErrorFrame,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ErrorButtonsHolder,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = ErrorButtonsHolder,
    })

    function Loading:UpdateLayout()
        if Loading.IsError then
            Loading:RecalculateErrorHeight()
        end

        local ShowSidebar = Loading.ShowSidebar
        local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
        local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight

        if ShowSidebar then
            SideBar.Visible = true
            SidebarDivider.Visible = true
        end

        TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
        TweenService:Create(SideBar, Library.TweenInfo, { Position = UDim2.fromOffset(Loading.ContentWidth, 0), Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0) }):Play()
        TweenService:Create(Container, Library.TweenInfo, { Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }):Play()

        if not ShowSidebar then
            task.delay(Library.TweenInfo.Time, function()
                if not Loading.ShowSidebar then
                    SideBar.Visible = false
                    SidebarDivider.Visible = false
                end
            end)
        end
    end

    
    function Loading:RecalculateLoadingHeight()
        if not Loading.AutoResizeHeight then
            return
        end

        local RequiredHeight =
              49 
            + 48 
            + InnerContent.UIListLayout.AbsoluteContentSize.Y

        Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
    end

    function Loading:SetMessage(Text)
        MessageLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetDescription(Text)
        DescriptionLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetLoadingIcon(Icon)
        local IconData = Library:GetCustomIcon(Icon)
        assert(IconData, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        local Replacement = Library:ApplyIcon(LoadingIcon, IconData)
        if Replacement ~= LoadingIcon then
            LoadingIcon = Replacement
            Loading:SetLoadingIconTweenTime(LoadingInfo.LoadingIconTweenTime)
        end
    end

    function Loading:SetLoadingIconTweenTime(TweenTime)
        LoadingInfo.LoadingIconTweenTime = TweenTime

        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        if TweenTime > 0 then
            RotationTween = TweenService:Create(
                LoadingIcon,
                TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            )
            RotationTween:Play()
        else
            LoadingIcon.Rotation = 0
        end
    end

    function Loading:SetLoadingIconColor(Color)
        SetIconProperties(LoadingIcon, { ImageColor3 = Color })
    end

    function Loading:SetCurrentStep(Step)
        Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

        local Progress = Loading.CurrentStep / Loading.TotalSteps
        TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

        ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
    end

    function Loading:SetTotalSteps(Steps)
        Loading.TotalSteps = Steps
        Loading:SetCurrentStep(Loading.CurrentStep)
    end

    
    function Loading:SetWindowHeight(Height)
        Loading.WindowHeight = Height
        Loading:UpdateLayout()
    end

    function Loading:SetWindowWidth(Width)
        Loading.WindowWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetContentWidth(Width)
        Loading.ContentWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetSidebarWidth(Width)
        Loading.SidebarWidth = Width
        Loading:UpdateLayout()
    end

    
    function Loading:ShowSidebarPage(Bool)
        Loading.ShowSidebar = Bool
        Loading:UpdateLayout()
    end

    
    function Loading:ShowErrorPage(Enabled)
        Loading.IsError = Enabled
        InnerContent.Visible = not Enabled
        ErrorFrame.Visible = Enabled

        if Loading.ShowSidebar then
            Loading:ShowSidebarPage(not Enabled)
        else
            Loading:UpdateLayout()
        end
    end

    function Loading:RecalculateErrorHeight()
        local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth) - 30
        local _, ErrorY = Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

        ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

        local HasButtons = ErrorButtonsHolder.Visible
        local RequiredHeight =
              49                        
            + 15                        
            + 18                        
            + 6                         
            + ErrorY                    
            + 15                        
            + (HasButtons and 48 or 0)  

        Loading.WindowErrorHeight = RequiredHeight 
    end

    function Loading:SetErrorMessage(Text)
        ErrorLabel.Text = Text
        Loading:UpdateLayout()
    end

    function Loading:SetErrorButtons(Buttons)
        assert(typeof(Buttons) == "table", "Buttons must be a table")

        for _, button in ErrorButtonsHolder:GetChildren() do
            if button:IsA("Frame") then
                button:Destroy()
            end
        end

        local HasButtons = GetTableSize(Buttons) > 0
        ErrorButtonsHolder.Visible = HasButtons
        ErrorButtonsDivider.Visible = HasButtons

        for Idx, ButtonInfo in Buttons do
            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                Parent = ErrorButtonsHolder,
            })

            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"

            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = TextBtn
                })
            )

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or Idx,
                TextColor3 = TextColor,
                TextSize = 14,
                Parent = TextBtn,
            })

            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Loading)
                end
            end)
        end

        Loading:UpdateLayout()
    end

    
    function Loading:Destroy()
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        ScreenGui:Destroy()
        Loading.Destroyed = true
        Library.ActiveLoading = nil

        if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
            Library:Toggle(true)
        end
    end

    Loading.Continue = Loading.Destroy;

    if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
        Library:Toggle(false)
    end

    Loading:SetCurrentStep(Loading.CurrentStep)

    Library.ActiveLoading = Loading
    return Loading
end

local function OnPlayerChange()
    if Library.Unloaded then
        return
    end

    local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
            Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
        end
    end
end

local function OnTeamChange()
    if Library.Unloaded then
        return
    end

    local TeamList = GetTeams()
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
            Dropdown:SetValues(TeamList)
        end
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

function Library:Unload()
    Library.Unloaded = true

    
    for Index = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Index)

        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    
    for _ = 1, #Library.UnloadSignals do
        local Callback = table.remove(Library.UnloadSignals, 1)

        if Callback then
            Library:SafeCallback(Callback)
        end
    end

    
    for Index = #Library.Tabs, 1, -1 do
        local Tab = table.remove(Library.Tabs, Index)

        if Tab and Tab.Destroy then
            Library:SafeCallback(Tab.Destroy, Tab)
        end
    end

    for Index = #Tooltips, 1, -1 do
        local Tooltip = table.remove(Tooltips, Index)

        if Tooltip and Tooltip.Destroy then
            Library:SafeCallback(Tooltip.Destroy, Tooltip)
        end
    end

    if Library.ActiveLoading then
        Library.ActiveLoading:Destroy()
    end

    if Library.KeybindMenu then
        Library.KeybindMenu:Destroy()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end

    
    table.clear(Library.Registry)

    table.clear(Options)
    table.clear(Toggles)
    table.clear(Buttons)
    table.clear(Labels)
    table.clear(Tooltips)

    table.clear(Library.Tabs)
    table.clear(Library.TabButtons)

    table.clear(Library.Scales)
    table.clear(Library.ScalesOffset)

    table.clear(Library.Corners)
    table.clear(Library.SpecificCorners)
    table.clear(Library.ContextMenus)

    table.clear(Library.Notifications)
    table.clear(Library.Dialogues)
    table.clear(Library.DraggableElements)
    table.clear(Library.KeybindToggles)
    table.clear(Library.DependencyBoxes)

    table.clear(ActiveTabTweens)

    Library.Toggle = function(...) end
    Library.ScreenGui = nil
    Library.Floats = nil
    Library.Overlay = nil
    Library.WindowContainer = nil
    Library.KeybindFrame = nil
    Library.KeybindContainer = nil
    Library.KeybindMenu = nil

    getgenv().Library = nil
end

getgenv().Library = Library
return Library
]====]

local THEME_SOURCE = [====[
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))


local isfolder, isfile, listfiles = isfolder, isfile, listfiles
local isfolder_copy, isfile_copy, listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)
local isfolder_success, isfolder_error = pcall(function() return isfolder_copy("test" .. tostring(math.random(1000000, 9999999))) end)

if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
    isfolder = function(folder)
        local success, data = pcall(isfolder_copy, folder)
        return (if success then data else false)
    end

    isfile = function(file)
        local success, data = pcall(isfile_copy, file)
        return (if success then data else false)
    end

    listfiles = function(folder)
        local success, data = pcall(listfiles_copy, folder)
        return (if success then data else {})
    end
end


local ContrastWarnThreshold = 4.5 
local SrgbLinearThreshold = 0.03928 
local SrgbLinearDivisor = 12.92 
local SrgbGammaOffset = 0.055 
local SrgbGammaScale = 1.055 
local SrgbGammaExponent = 2.4 
local LuminanceRedWeight,
      LuminanceGreenWeight,
      LuminanceBlueWeight = 0.2126, 0.7152, 0.0722 
local ContrastRatioOffset = 0.05 


local SchemeIndexes = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

local ThemeManager = {
    Library = nil,

    Folder = "ObsidianLibSettings",

    AppliedToTab = false,
    DefaultThemeName = nil,

    
    ContrastLabel = nil,
    ContrastWasPoor = false,

    BuiltInThemes = {
        ["Halloween!!"] = {
            [3] = "万圣节",
            0,
            { FontColor = "f6ead9", MainColor = "17111c", AccentColor = "ff7a18", BackgroundColor = "0d0a10", OutlineColor = "33243d", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Revenant"] = {
            [3] = "亡灵",
            1,
            { FontColor = "ffffff", MainColor = "131519", AccentColor = "ffffff", BackgroundColor = "0f1112", OutlineColor = "282828", FontFace = "Roboto", BackgroundImage = "" },
        },
        
        
        
        ["Normal Obsidian"] = {
            [3] = "经典黑曜石",
            2,
            { FontColor = "ffffff", MainColor = "191919", AccentColor = "7d55ff", BackgroundColor = "0f0f0f", OutlineColor = "282828", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Old Revenant."] = {
            [3] = "旧版亡灵",
            3,
            { FontColor = "ffffff", MainColor = "191919", AccentColor = "a2a2a2", BackgroundColor = "000000", OutlineColor = "282828", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Aurora"] = {
            [3] = "极光",
            4,
            { FontColor = "e0f7fa", MainColor = "2b303b", AccentColor = "81a1c1", BackgroundColor = "1c222b", OutlineColor = "3e4755", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["BBot"] = {
            [3] = "蓝紫终端",
            5,
            { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Berry Smoothie"] = {
            [3] = "莓果冰沙",
            6,
            { FontColor = "ffffff", MainColor = "722f37", AccentColor = "d36ba6", BackgroundColor = "40102b", OutlineColor = "703060", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Buttercup"] = {
            [3] = "金凤花",
            7,
            { FontColor = "ffffff", MainColor = "967011", AccentColor = "ffeb3b", BackgroundColor = "3a301a", OutlineColor = "7a6d28", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Candy Cane"] = {
            [3] = "拐杖糖",
            8,
            { FontColor = "000000", MainColor = "ff9191", AccentColor = "ec3737", BackgroundColor = "fccbcb", OutlineColor = "b49797", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Candy Pop"] = {
            [3] = "糖果汽水",
            9,
            { FontColor = "ffffff", MainColor = "5e2e65", AccentColor = "00e6e6", BackgroundColor = "1c002a", OutlineColor = "4a0044", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Canyon Clay"] = {
            [3] = "峡谷红陶",
            10,
            { FontColor = "ffffff", MainColor = "7f5539", AccentColor = "d78e6c", BackgroundColor = "3a2117", OutlineColor = "6c4a3b", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Catppuccin"] = {
            [3] = "卡布奇诺",
            11,
            { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Celestial"] = {
            [3] = "星空",
            12,
            { FontColor = "eaeaf2", MainColor = "1f1c3c", AccentColor = "7986cb", BackgroundColor = "0b0928", OutlineColor = "362e61", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Copper Canyon"] = {
            [3] = "铜色峡谷",
            13,
            { FontColor = "ffffff", MainColor = "7c2d12", AccentColor = "ff7043", BackgroundColor = "38190a", OutlineColor = "5c321d", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Crimson Tide"] = {
            [3] = "赤色潮汐",
            14,
            { FontColor = "ffffff", MainColor = "5a0000", AccentColor = "ff1744", BackgroundColor = "330000", OutlineColor = "990000", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Cyberpunk"] = {
            [3] = "赛博朋克",
            15,
            { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Deep Space"] = {
            [3] = "深空",
            16,
            { FontColor = "cfd8dc", MainColor = "0d1b2a", AccentColor = "4e8bbf", BackgroundColor = "081421", OutlineColor = "284259", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Desert Storm"] = {
            [3] = "沙漠风暴",
            17,
            { FontColor = "ffffff", MainColor = "c6ab80", AccentColor = "af8e6a", BackgroundColor = "372d26", OutlineColor = "6b5541", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Dracula"] = {
            [3] = "德古拉",
            18,
            { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Dust Bowl"] = {
            [3] = "沙尘盆地",
            19,
            { FontColor = "ffffff", MainColor = "5c4537", AccentColor = "b2957e", BackgroundColor = "3b3024", OutlineColor = "7a6d58", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Dusty Rose"] = {
            [3] = "灰调玫瑰",
            20,
            { FontColor = "ffffff", MainColor = "ba6b6c", AccentColor = "f4a7b9", BackgroundColor = "3d1f23", OutlineColor = "70454b", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Electric Lime"] = {
            [3] = "电光青柠",
            21,
            { FontColor = "d4d4d4", MainColor = "454f09", AccentColor = "aeea00", BackgroundColor = "222222", OutlineColor = "4f4f4f", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Emerald Dream"] = {
            [3] = "翡翠梦境",
            22,
            { FontColor = "e0ffe0", MainColor = "014421", AccentColor = "33cc99", BackgroundColor = "001a10", OutlineColor = "02442b", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Fatality"] = {
            [3] = "终结",
            23,
            { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Flame Ember"] = {
            [3] = "余烬烈焰",
            24,
            { FontColor = "ffffff", MainColor = "692423", AccentColor = "ff7043", BackgroundColor = "2e0005", OutlineColor = "8b3a3a", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Forest Mist"] = {
            [3] = "森林薄雾",
            25,
            { FontColor = "dcedc8", MainColor = "2e4d2b", AccentColor = "a8d5ba", BackgroundColor = "1b2f20", OutlineColor = "3c5a3d", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Glacial"] = {
            [3] = "冰川",
            26,
            { FontColor = "e0f7fa", MainColor = "2c3e50", AccentColor = "4dd0e1", BackgroundColor = "1a2d3a", OutlineColor = "2c5f58", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Goldenrod"] = {
            [3] = "金菊黄",
            27,
            { FontColor = "ffffff", MainColor = "8c7a3f", AccentColor = "ffd54f", BackgroundColor = "4c3d20", OutlineColor = "6e5e3a", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Graphite"] = {
            [3] = "石墨",
            28,
            { FontColor = "d1d1d1", MainColor = "2b2b2b", AccentColor = "777777", BackgroundColor = "1a1a1a", OutlineColor = "444444", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Gruvbox"] = {
            [3] = "灰调复古",
            29,
            { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Iceberg"] = {
            [3] = "冰山",
            30,
            { FontColor = "ffffff", MainColor = "1e3d59", AccentColor = "00b7ff", BackgroundColor = "12273d", OutlineColor = "30577a", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Inferno"] = {
            [3] = "炼狱",
            31,
            { FontColor = "ffffff", MainColor = "4b000f", AccentColor = "ff3300", BackgroundColor = "2e0005", OutlineColor = "7a0011", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Jade Forest"] = {
            [3] = "玉林",
            32,
            { FontColor = "f0fff0", MainColor = "0a2c2a", AccentColor = "3bbf9b", BackgroundColor = "081d1b", OutlineColor = "205752", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Jester"] = {
            [3] = "小丑",
            33,
            { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Lavender Mist"] = {
            [3] = "薰衣草雾",
            34,
            { FontColor = "faf0ff", MainColor = "7e5a9b", AccentColor = "cba5e6", BackgroundColor = "44275a", OutlineColor = "71538c", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Lunar Eclipse"] = {
            [3] = "月蚀",
            35,
            { FontColor = "dcdcdc", MainColor = "2c2933", AccentColor = "908ec3", BackgroundColor = "1b1823", OutlineColor = "3e3a4e", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Marshmallow"] = {
            [3] = "棉花糖",
            36,
            { FontColor = "000000", MainColor = "eccbea", AccentColor = "f8bbd0", BackgroundColor = "e4dfdf", OutlineColor = "96a8d7", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Material"] = {
            [3] = "材质派",
            37,
            { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Midnight Blue"] = {
            [3] = "午夜蓝",
            38,
            { FontColor = "e0eaf2", MainColor = "1a2634", AccentColor = "5c8fc0", BackgroundColor = "0f1221", OutlineColor = "2c3e50", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Midnight Orchid"] = {
            [3] = "午夜兰花",
            39,
            { FontColor = "f8f8ff", MainColor = "2a1e3b", AccentColor = "b86bbe", BackgroundColor = "1a0c27", OutlineColor = "4f2b55", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Mint"] = {
            [3] = "薄荷",
            40,
            { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Mint Chocolate"] = {
            [3] = "薄荷巧克力",
            41,
            { FontColor = "ffffff", MainColor = "2e4639", AccentColor = "a1c349", BackgroundColor = "1c2f24", OutlineColor = "3c5a4e", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Mocha Mist"] = {
            [3] = "摩卡雾",
            42,
            { FontColor = "f5e1da", MainColor = "6b4c3b", AccentColor = "bc987e", BackgroundColor = "3c2b24", OutlineColor = "795b48", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Monokai"] = {
            [3] = "莫诺凯",
            43,
            { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Mystic Violet"] = {
            [3] = "神秘紫罗兰",
            44,
            { FontColor = "f0e6ff", MainColor = "3e1f47", AccentColor = "ba68c8", BackgroundColor = "2a102f", OutlineColor = "5c3d63", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Neon Jungle"] = {
            [3] = "霓虹丛林",
            45,
            { FontColor = "ccff99", MainColor = "1a1f27", AccentColor = "00ff88", BackgroundColor = "0d0d0d", OutlineColor = "2a2a2a", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Nord"] = {
            [3] = "北欧极夜",
            46,
            { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Ocean Breeze"] = {
            [3] = "海风",
            47,
            { FontColor = "e0f7fa", MainColor = "005377", AccentColor = "00bcd4", BackgroundColor = "002d3a", OutlineColor = "014f62", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Ocean Pearl"] = {
            [3] = "海洋珍珠",
            48,
            { FontColor = "ffffff", MainColor = "036865", AccentColor = "42eecf", BackgroundColor = "002f3a", OutlineColor = "014f52", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Oceanic Next"] = {
            [3] = "深海蓝调",
            49,
            { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["One Dark"] = {
            [3] = "暗夜一号",
            50,
            { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Opal Glow"] = {
            [3] = "蛋白石辉光",
            51,
            { FontColor = "f0fff0", MainColor = "567572", AccentColor = "b2f5ea", BackgroundColor = "213837", OutlineColor = "2b4f3c", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Peach Fuzz"] = {
            [3] = "蜜桃绒",
            52,
            { FontColor = "ffffff", MainColor = "b6846b", AccentColor = "ff8e72", BackgroundColor = "3a2525", OutlineColor = "7f5a56", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Peacock Feather"] = {
            [3] = "孔雀羽",
            53,
            { FontColor = "ffffff", MainColor = "004953", AccentColor = "00bcd4", BackgroundColor = "002f3d", OutlineColor = "006370", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Peanut Butter"] = {
            [3] = "花生酱",
            54,
            { FontColor = "ffffff", MainColor = "e1a95f", AccentColor = "ffca80", BackgroundColor = "2b221a", OutlineColor = "7a6326", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Quartz"] = {
            [3] = "石英",
            55,
            { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Retro Wave"] = {
            [3] = "复古浪潮",
            56,
            { FontColor = "f0f8ff", MainColor = "2d033b", AccentColor = "ff77ff", BackgroundColor = "1a0126", OutlineColor = "5b114b", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Rose Quartz"] = {
            [3] = "玫瑰石英",
            57,
            { FontColor = "ffffff", MainColor = "c48793", AccentColor = "f7cad0", BackgroundColor = "2f1b24", OutlineColor = "6f4b57", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Sandstone"] = {
            [3] = "砂岩",
            58,
            { FontColor = "2e1e1e", MainColor = "c2b280", AccentColor = "d7b889", BackgroundColor = "f5e6ca", OutlineColor = "a79876", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Slate Grey"] = {
            [3] = "板岩灰",
            59,
            { FontColor = "ffffff", MainColor = "607d8b", AccentColor = "b0bec5", BackgroundColor = "263238", OutlineColor = "546e7a", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Solar Flare"] = {
            [3] = "太阳耀斑",
            60,
            { FontColor = "ffffff", MainColor = "4e1609", AccentColor = "ff7043", BackgroundColor = "2b0702", OutlineColor = "6f1e07", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Solarized"] = {
            [3] = "日光色调",
            61,
            { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Steel Blue"] = {
            [3] = "钢青",
            62,
            { FontColor = "f1f5f9", MainColor = "1f3a58", AccentColor = "607d8b", BackgroundColor = "152439", OutlineColor = "2c526d", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Stormy Night"] = {
            [3] = "暴风夜",
            63,
            { FontColor = "e0e0e0", MainColor = "2f3e4e", AccentColor = "627d98", BackgroundColor = "1b232f", OutlineColor = "34455b", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Sunrise Glow"] = {
            [3] = "日出辉光",
            64,
            { FontColor = "ffffff", MainColor = "ad6700", AccentColor = "ffeb99", BackgroundColor = "3d281e", OutlineColor = "8c5200", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Sunset Horizon"] = {
            [3] = "日落地平线",
            65,
            { FontColor = "ffffff", MainColor = "9f4f48", AccentColor = "fbc687", BackgroundColor = "2a0f0f", OutlineColor = "7b3f39", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Tokyo Night"] = {
            [3] = "东京之夜",
            66,
            { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Tropical Punch"] = {
            [3] = "热带果酒",
            67,
            { FontColor = "ffffff", MainColor = "e96c98", AccentColor = "ffc200", BackgroundColor = "4d2b47", OutlineColor = "e83296", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Twilight"] = {
            [3] = "暮光",
            68,
            { FontColor = "e0e6f8", MainColor = "121212", AccentColor = "9fa8da", BackgroundColor = "0a0a0a", OutlineColor = "333444", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Ubuntu"] = {
            [3] = "乌班图",
            69,
            { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Vintage Paper"] = {
            [3] = "复古纸张",
            70,
            { FontColor = "2f2f2f", MainColor = "d8cfc4", AccentColor = "b89c73", BackgroundColor = "f3e9d2", OutlineColor = "a68f7c", FontFace = "Roboto", BackgroundImage = "" },
        },
        ["Vodka Lime"] = {
            [3] = "伏特加青柠",
            71,
            { FontColor = "70a634", MainColor = "6f8740", AccentColor = "396b07", BackgroundColor = "2a2a2a", OutlineColor = "4f4f4f", FontFace = "Roboto", BackgroundImage = "" },
        },
    }
}

function ThemeManager:SetLibrary(Library)
    ThemeManager.Library = Library
end


local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    return typeof(Name) == "string" and (
        Trim(Name) ~= "" and 
        not Name:match("^%s*$") and 
        not Name:find('[<>:"|%?%*%z]')
    )
end


local function LinearizeChannel(Channel: number): number
    if Channel <= SrgbLinearThreshold then
        return Channel / SrgbLinearDivisor
    end

    return ((Channel + SrgbGammaOffset) / SrgbGammaScale) ^ SrgbGammaExponent
end

local function GetRelativeLuminance(Color: Color3): number
    local R = LinearizeChannel(Color.R)
    local G = LinearizeChannel(Color.G)
    local B = LinearizeChannel(Color.B)

    return LuminanceRedWeight * R + LuminanceGreenWeight * G + LuminanceBlueWeight * B
end

local function GetContrastRatio(ColorA: Color3, ColorB: Color3): number
    local LuminanceA = GetRelativeLuminance(ColorA)
    local LuminanceB = GetRelativeLuminance(ColorB)

    local Lighter = math.max(LuminanceA, LuminanceB)
    local Darker = math.min(LuminanceA, LuminanceB)

    return (Lighter + ContrastRatioOffset) / (Darker + ContrastRatioOffset)
end

local function IsValidThemeData(Data: any): boolean
    if typeof(Data) ~= "table" then
        return false
    end

    
    for _, SchemeIndex in SchemeIndexes do
        if typeof(Data[SchemeIndex]) ~= "string" then
            return false
        end
    end

    return true
end


local function SplitPath(Path: string): {string}
	local Result = {}
	local Current = ""

	for Part in string.gmatch(Path, "[^/]+") do
		Current = if Current == "" then Part else (Current .. "/" .. Part)
		table.insert(Result, Current)
	end

	return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(ThemeManager.Folder) then
        return false
    end

    return string.format("%s/themes", ThemeManager.Folder)
end

local GetCurrentThemesPath = GetFolderPath


local function GetThemePath(ThemeName: string): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false then false else string.format("%s/%s.json", CurrentThemesPath, ThemeName)
end

local function DoesThemeExist(ThemeName: string, IncludeBuiltIn: boolean): boolean
    if ThemeManager.BuiltInThemes[ThemeName] then
        return true
    end

    local ThemePath = GetThemePath(ThemeName)
    return if ThemePath == false then false else isfile(ThemePath)
end

local function GetDefaultThemePath(): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false then false else string.format("%s/default.txt", CurrentThemesPath)
end


function ThemeManager:GetPaths(): {string}
    local FolderPath = GetFolderPath()
    return if FolderPath == false then {} else SplitPath(FolderPath)
end

function ThemeManager:BuildFolderTree(SkipWhenCreated: boolean?)
    local Paths = ThemeManager:GetPaths()
    if #Paths == 0 then
        return false
    end

    if SkipWhenCreated == true then
        if isfolder(Paths[1]) then
            return true
        end
    end

    for _, Path in Paths do
        if isfolder(Path) then continue end
        
        makefolder(Path)
    end

    return true
end

function ThemeManager:CheckFolderTree()
    return ThemeManager:BuildFolderTree(true)
end

function ThemeManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "路径无效")

    ThemeManager.Folder = Folder
    ThemeManager:BuildFolderTree()
end


function ThemeManager:ReloadCustomThemes()
    local SettingsPath = GetCurrentThemesPath()
    if SettingsPath == false then
        return {}
    end

    pcall(makefolder, SettingsPath)
    local SuccessList, Files = pcall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        ThemeManager.Library:Notify(string.format("加载主题列表失败：%s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local RawFileName = FilePath:match("(.+)%..+$")
        if not RawFileName then continue end

        local Position = RawFileName:gsub("\\", "/"):find("/[^/]*$")
        local FileName = Position and RawFileName:sub(Position + 1) or RawFileName
        if not FileName or FileName == "default" then continue end

        table.insert(FileNames, FileName)
    end

    return FileNames
end

function ThemeManager:GetCustomTheme(ThemeName: string): any
    if IsStringEmpty(ThemeName) then
        return nil
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not isfile(ThemePath) then
        return nil
    end

    local SuccessRead, Content = pcall(readfile, ThemePath)
    if not SuccessRead then
        return nil
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" then
        return nil
    end

    return Decoded
end

local function BuildCurrentThemeData(): {[string]: any}
    local Library = ThemeManager.Library
    local ThemeData = {
        FontFace = Library.Options.FontFace.Value,
        BackgroundImage = Library.Options.BackgroundImage.Value
    }

    for _, SchemeIndex in SchemeIndexes do
        ThemeData[SchemeIndex] = Library.Options[SchemeIndex].Value:ToHex()
    end

    return ThemeData
end

function ThemeManager:SaveCustomTheme(ThemeName: string): any
    if IsStringEmpty(ThemeName) then
        return false, "主题名称无效"
    end

    if string.lower(ThemeName) == "default" then
        return false, "主题名称无效"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false then
        return false, "主题名称无效"
    end

    ThemeManager:CheckFolderTree()

    
    local EncodedData, SuccessEncode, EncodeErrorMessage = ThemeManager:SaveJSON()
    if not SuccessEncode then
        return false, EncodeErrorMessage
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, ThemePath, EncodedData)
    if not SuccessWrite then
        return false, "写入主题文件失败：" .. tostring(ErrorMessage)
    end

    return true
end

function ThemeManager:Delete(ThemeName: string): (boolean | string?)
    if IsStringEmpty(ThemeName) then
        return false, "未选择主题"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not isfile(ThemePath) then
        return false, "主题文件不存在"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, ThemePath)
    if not SuccessDelete then
        return false, "删除主题文件失败：" .. tostring(ErrorMessage)
    end

    if ThemeName == ThemeManager.DefaultThemeName then
        ThemeManager:DeleteDefaultTheme()
    end

    return true
end


function ThemeManager:GetDefaultTheme(): (string, boolean, string?)
    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return "none", false, "路径无效"
    end

    if not isfile(DefaultThemePath) then
        return "none", false, "未设置默认主题"
    end

    local SuccessRead, DefaultThemeName = pcall(readfile, DefaultThemePath)
    if not (SuccessRead and typeof(DefaultThemeName) == "string") then
        return "none", false, DefaultThemeName
    end

    local ConfigExists = DoesThemeExist(DefaultThemeName, true)
    if not ConfigExists then
        return "none", false, "主题文件未找到"
    end

    ThemeManager.DefaultThemeName = DefaultThemeName
    return DefaultThemeName, true
end

function ThemeManager:SetDefaultTheme(Theme: any)
    assert(ThemeManager.Library, "库未设置，请先调用 ThemeManager:SetLibrary(Library)。")
    assert(not ThemeManager.AppliedToTab, "已将 ThemeManager 应用到标签页，无法再设置默认主题！")

    local Library = ThemeManager.Library
    local DefaultThemeData = ThemeManager.BuiltInThemes["Default"][2]

    local LibraryScheme = {}
    local FinalTheme = {}

    for _, SchemeIndex in SchemeIndexes do
        local IndexData = Theme[SchemeIndex]
        local IndexType = typeof(IndexData)
        
        if IndexType == "Color3" then
            LibraryScheme[SchemeIndex] = IndexData
            FinalTheme[SchemeIndex] = string.format("#%s", IndexData:ToHex())

        elseif IndexType == "string" then
            LibraryScheme[SchemeIndex] = Color3.fromHex(IndexData)
            FinalTheme[SchemeIndex] = if IndexData:sub(1, 1) == "#" then IndexData else string.format("#%s", IndexData)
        
        else
            local Value = DefaultThemeData[SchemeIndex]
            LibraryScheme[SchemeIndex] = Color3.fromHex(Value)
            FinalTheme[SchemeIndex] = Value
        end
    end

    
    local FontFace = Theme["FontFace"]
    local FontFaceType = typeof(FontFace)
    
    if FontFaceType == "EnumItem" then
        LibraryScheme.Font = Font.fromEnum(FontFace)
        FinalTheme.FontFace = FontFace.Name

    elseif FontFaceType == "string" then
        LibraryScheme.Font = Font.fromEnum(Enum.Font[FontFace] :: Enum.Font)
        FinalTheme.FontFace = FontFace
    
    else
        LibraryScheme.Font = Font.fromEnum(Enum.Font.Roboto)
        FinalTheme.FontFace = "Roboto"
    end

    
    for _, DefaultSchemeColor in { "RedColor", "DestructiveColor", "DarkColor", "WhiteColor" } do
        LibraryScheme[DefaultSchemeColor] = Library.Scheme[DefaultSchemeColor]
    end

    
    Library.Scheme = LibraryScheme
    ThemeManager.BuiltInThemes["Default"] = { 1, FinalTheme }

    Library:UpdateColorsUsingRegistry()
end

function ThemeManager:SaveDefault(ThemeName: string): (boolean, string?)
    if IsStringEmpty(ThemeName) then
        return false, "未选择主题"
    end

    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "路径无效"
    end

    if not DoesThemeExist(ThemeName, true) then
        return false, "主题不存在"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, DefaultThemePath, ThemeName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = ThemeName
    return true
end

function ThemeManager:LoadDefault()
    local ThemeName, Success, FetchErrorMessage = ThemeManager:GetDefaultTheme()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "未设置默认主题" then
            ThemeManager.Library:Notify(string.format("应用默认主题失败：%s", FetchErrorMessage))
        else
            
            pcall(function()
                ThemeManager.Library.Options.ThemeManager_ThemeList:SetValue("Halloween!!")
            end)
        end

        return
    end

    if not ThemeManager:GetCustomTheme(ThemeName) then
        ThemeManager.Library.Options.ThemeManager_ThemeList:SetValue(ThemeName)
        return
    end

    local SuccessLoad, LoadErrorMessage = ThemeManager:ApplyTheme(ThemeName)
    if not SuccessLoad then
        ThemeManager.Library:Notify(string.format("应用默认主题失败：%s", LoadErrorMessage))
        return
    end

    ThemeManager.Library:Notify(string.format("已应用默认主题 %q", ThemeManager:GetDisplayName(ThemeName)))
end

function ThemeManager:DeleteDefaultTheme(): (boolean, string?)
    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "路径无效"
    end

    if not isfile(DefaultThemePath) then
        return false, "未设置默认主题"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, DefaultThemePath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = nil
    return true
end


function ThemeManager:GetContrastReport(): { Ratio: number, PairName: string, Passes: boolean }
    local Library = ThemeManager.Library
    local FontColorOption = Library.Options.FontColor
    local BackgroundColorOption = Library.Options.BackgroundColor
    local MainColorOption = Library.Options.MainColor

    if not (FontColorOption and BackgroundColorOption and MainColorOption) then
        return { Ratio = math.huge, PairName = "", Passes = true }
    end

    local FontColor = FontColorOption.Value
    local Surfaces = {
        { Name = "字体色 与 背景色", Color = BackgroundColorOption.Value },
        { Name = "字体色 与 主色", Color = MainColorOption.Value },
    }

    local WorstRatio, WorstName = math.huge, ""
    for _, Surface in Surfaces do
        local Ratio = GetContrastRatio(FontColor, Surface.Color)
        if Ratio < WorstRatio then
            WorstRatio = Ratio
            WorstName = Surface.Name
        end
    end

    return {
        Ratio = WorstRatio,
        PairName = WorstName,
        Passes = WorstRatio >= ContrastWarnThreshold,
    }
end

function ThemeManager:UpdateContrastWarning()
    local ContrastLabel = ThemeManager.ContrastLabel
    if not ContrastLabel or ContrastLabel.Destroyed then
        return
    end

    local Library = ThemeManager.Library
    local Report = ThemeManager:GetContrastReport()
    local TextLabel = ContrastLabel.TextLabel

    if not Library.Registry[TextLabel] then
        Library:AddToRegistry(TextLabel, {})
    end

    if Report.Passes then
        ContrastLabel:SetText(string.format("对比度检查：良好（%.1f:1）", Report.Ratio))

        TextLabel.TextColor3 = Library.Scheme.FontColor
        Library.Registry[TextLabel].TextColor3 = "FontColor"
    else
        ContrastLabel:SetText(string.format(
            "对比度偏低（%.1f:1，涉及 %s）。建议至少 %.1f:1，文字才清晰可读。",
            Report.Ratio, Report.PairName, ContrastWarnThreshold
        ))

        TextLabel.TextColor3 = Library.Scheme.RedColor
        Library.Registry[TextLabel].TextColor3 = "RedColor"

        if not ThemeManager.ContrastWasPoor then
            Library:Notify({
                Title = "低对比度主题",
                Description = string.format(
                    "%s 的对比度为 %.1f:1，低于建议的 %.1f:1，文字可能难以辨认。",
                    Report.PairName, Report.Ratio, ContrastWarnThreshold
                ),
                Time = 10,
            })
        end
    end

    ThemeManager.ContrastWasPoor = not Report.Passes
end


function ThemeManager:ThemeUpdate()
    local Library = ThemeManager.Library

    for _, SchemeIndex in SchemeIndexes do
        local Element = Library.Options[SchemeIndex]
        if not Element then continue end

        Library.Scheme[SchemeIndex] = Element.Value
    end

    Library:UpdateColorsUsingRegistry()
    ThemeManager:UpdateContrastWarning()
end



function ThemeManager:ApplyThemeData(ThemeData: any): (boolean, string?)
    if typeof(ThemeData) ~= "table" then
        return false, "主题数据无效"
    end

    local Library = ThemeManager.Library

    for Index, Value in ThemeData do
        if Index == "VideoLink" then
            continue
        end

        local Element = Library.Options[Index]
        local FinalValue = Value

        if Index == "FontFace" then
            if typeof(Value) ~= "string" or not Enum.Font[Value] then continue end
            ThemeManager.Library:SetFont(Enum.Font[Value])

        elseif Index == "BackgroundImage" then
            if typeof(Value) ~= "string" then continue end
            ThemeManager.Library:SetBackgroundImage(Value)

        elseif table.find(SchemeIndexes, Index) then
            local SuccessColor, Color = pcall(Color3.fromHex, Value)
            if not SuccessColor then continue end

            FinalValue = Color
            Library.Scheme[Index] = FinalValue

        else
            continue 
        end

        if Element then
            Element:SetValue(FinalValue)
        end
    end

    ThemeManager:ThemeUpdate()
    return true
end

function ThemeManager:ApplyTheme(ThemeName: string)
    if IsStringEmpty(ThemeName) then
        return false, "未选择主题"
    end

    local CustomThemeData = ThemeManager:GetCustomTheme(ThemeName)
    local Data = CustomThemeData or ThemeManager.BuiltInThemes[ThemeName]
    
    if not Data then
        return false, "主题未找到"
    end
    
    local ThemeData = CustomThemeData or Data[2]
    return ThemeManager:ApplyThemeData(ThemeData)
end


function ThemeManager:SaveJSON(): (string, boolean, string?)
    local ThemeData = BuildCurrentThemeData()

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, ThemeData)
    if not SuccessEncode then
        return "", false, "Failed to encode data"
    end

    return EncodedData, true
end

function ThemeManager:LoadJSON(Content: string): (boolean, string?)
    if IsStringEmpty(Content) then
        return false, "未提供 JSON"
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or not IsValidThemeData(Decoded) then
        return false, "主题数据解析失败"
    end

    return ThemeManager:ApplyThemeData(Decoded)
end


local function ShowDialog(
    Condition: () -> boolean,

    Index: string, 
    Title: string, 
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return ThemeManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            Cancel = {
                Title = "取消",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end
            },

            DestructiveAction = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end
            }
        }
    })
end

function ThemeManager:GetDisplayName(Name)
    local Entry = ThemeManager.BuiltInThemes[Name]
    if Entry and type(Entry[3]) == "string" then
        return Entry[3]
    end

    return Name
end

function ThemeManager:CreateThemeManager(Themesbox: any)
    assert(ThemeManager.Library, "库未设置，请先调用 ThemeManager:SetLibrary(Library)。")

    local BuiltInThemesNames = {}
    for Name, _ThemeData in ThemeManager.BuiltInThemes do
        table.insert(BuiltInThemesNames, Name)
    end

    local CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, DefaultThemeLabel, ThemeJSONInput
    local function RefreshList()
        CustomThemeList:SetValues(ThemeManager:ReloadCustomThemes())
        CustomThemeList:SetValue(nil)

        ThemeList:SetValues(BuiltInThemesNames)
    end

    local function RefreshDefaultThemeLabel()
        local DefaultThemeName, _Success, _ErrorMessage = ThemeManager:GetDefaultTheme()

        DefaultThemeLabel:SetText(string.format("当前默认主题：%s", ThemeManager:GetDisplayName(DefaultThemeName)))
        if CustomThemeList then RefreshList() end
    end

    table.sort(BuiltInThemesNames, function(IndexA, IndexB)
        return ThemeManager.BuiltInThemes[IndexA][1] < ThemeManager.BuiltInThemes[IndexB][1]
    end)

    local function CreateColorOption(Text, SchemeIndex)
        Themesbox:AddLabel(Text):AddColorPicker(SchemeIndex, {
            Default = ThemeManager.Library.Scheme[SchemeIndex]
        })

        return ThemeManager.Library.Options[SchemeIndex]
    end

    local BackgroundColor = CreateColorOption("背景颜色", "BackgroundColor")
    local MainColor = CreateColorOption("主色", "MainColor")
    local AccentColor = CreateColorOption("强调色", "AccentColor")
    local OutlineColor = CreateColorOption("描边颜色", "OutlineColor")
    local FontColor = CreateColorOption("字体颜色", "FontColor")

    
    ThemeManager.ContrastLabel = Themesbox:AddLabel({
        Text = "对比度检查：不适用",
        DoesWrap = true,
    })

    Themesbox:AddDropdown("FontFace", {
        Text = "字体",
        Default = "Roboto",
        
        Values = { "BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans" },
        AllowNull = false,
        Multi = false
    })
    
    local XJW_BG_CDNS = {
        "https://cdn.jsdelivr.net/gh/jiuyijiuyijiuyi91/XJW666@main/",
        "https://gcore.jsdelivr.net/gh/jiuyijiuyijiuyi91/XJW666@main/",
        "https://fastly.jsdelivr.net/gh/jiuyijiuyijiuyi91/XJW666@main/",
        "https://testingcf.jsdelivr.net/gh/jiuyijiuyijiuyi91/XJW666@main/",
        "https://raw.githubusercontent.com/jiuyijiuyijiuyi91/XJW666/refs/heads/main/",
    }
    local XJW_BG_PRESETS = {
        { "默认立绘", "XJW%E8%84%9A%E6%9C%AC%E5%A3%81%E7%BA%B8.png" },
        { "茉莉路", "%E8%8C%89%E8%8E%89%E8%B7%AF%E6%9C%AC%E4%BA%BA.jpg" },
        { "群友分享", "%E7%BE%A4%E5%8F%8B%E5%88%86%E4%BA%AB.png" },
        { "群友分享(2)", "%E7%BE%A4%E5%8F%8B%E5%88%86%E4%BA%AB%282%29.jpg" },
    }
    local XJW_BG_MAP, XJW_BG_NAMES = {}, {}
    for _, XJWPreset in ipairs(XJW_BG_PRESETS) do
        XJW_BG_MAP[XJWPreset[1]] = XJWPreset[2]
        table.insert(XJW_BG_NAMES, XJWPreset[1])
    end
    XJW_BG_MAP["无背景（纯主题配色）"] = ""
    table.insert(XJW_BG_NAMES, "无背景（纯主题配色）")

    local XJWBgPreview = nil
    if not ThemeManager._BgGuardStarted then
        ThemeManager._BgGuardStarted = true
        task.spawn(function()
            while true do
                task.wait(1)
                local Picked = ThemeManager.PickedBackground
                if type(Picked) == "string" and Picked ~= "" then
                    local Lib2 = ThemeManager.Library
                    if type(Lib2) == "table" and type(Lib2.Scheme) == "table" and Lib2.Scheme.BackgroundImage ~= Picked then
                        pcall(function() XJWUI:ApplyBackgroundImage(Picked) end)
                    end
                end
            end
        end)
    end
    local function XJWEnsurePreview(Asset)
        if XJWBgPreview then
            return XJWBgPreview
        end
        local Initial = Asset
        if type(Initial) ~= "string" or Initial == "" then
            local Lib = ThemeManager.Library
            local HasPlaceholder = false
            if type(Lib) == "table" and type(Lib.GetIcon) == "function" then
                local OkIcon, Icon = pcall(function()
                    return Lib:GetIcon("image")
                end)
                HasPlaceholder = OkIcon and Icon ~= nil
            end
            if not HasPlaceholder then
                return nil
            end
            Initial = "image"
        end
        local Ok, Obj = pcall(function()
            return Themesbox:AddImage("XJWBgPreview", {
                Image = Initial,
                Height = 120,
                ScaleType = Enum.ScaleType.Crop,
                Visible = false,
            })
        end)
        if Ok and Obj then
            XJWBgPreview = Obj
        end
        return XJWBgPreview
    end
    local function XJWResolveBackground(File, OnDone)
        if File == "" then
            OnDone("")
            return
        end
        local Lib = ThemeManager.Library
        if type(Lib) ~= "table" or type(Lib.GetImageFromUrl) ~= "function" then
            OnDone(nil)
            return
        end
        task.spawn(function()
            local Asset = nil
            for _, Base in ipairs(XJW_BG_CDNS) do
                local Ok, Res = pcall(function()
                    return Lib:GetImageFromUrl(Base .. File)
                end)
                if Ok and type(Res) == "string" and Res ~= "" then
                    Asset = Res
                    break
                end
            end
            OnDone(Asset)
        end)
    end
    local function XJWApplyBackground(Value)
        local File = XJW_BG_MAP[Value]
        if type(File) ~= "string" then
            return
        end
        XJWResolveBackground(File, function(Asset)
            if Asset == "" then
                ThemeManager.PickedBackground = ""
                if XJWBgPreview then
                    pcall(function() XJWBgPreview:SetVisible(false) end)
                end
                pcall(function() XJWUI:ApplyBackgroundImage("") end)
                return
            end
            if type(Asset) ~= "string" then
                return
            end
            local Preview = XJWEnsurePreview(Asset)
            if Preview then
                pcall(function() Preview:SetImage(Asset) end)
                pcall(function() Preview:SetVisible(true) end)
            end
            ThemeManager.PickedBackground = Asset
            pcall(function() XJWUI:ApplyBackgroundImage(Asset) end)
        end)
    end

    ThemeManager.BackgroundDropdown = Themesbox:AddDropdown("BackgroundImagePick", {
        Text = "背景图片",
        Values = XJW_BG_NAMES,
        Default = "默认立绘",
        AllowNull = false,
        Multi = false,
        Tooltip = "选择窗口背景图，下方为实时预览",

        Callback = function(Value)
            XJWApplyBackground(Value)
        end,
    })

    task.defer(function()
        local Current = ""
        pcall(function()
            if type(XJWUI) == "table" and type(XJWUI.GetBackgroundImage) == "function" then
                Current = tostring(XJWUI:GetBackgroundImage() or "")
            end
        end)
        if Current == "" then
            XJWApplyBackground("默认立绘")
        end
    end)

    Themesbox:AddDivider()

    Themesbox:AddDropdown("ThemeManager_ThemeList", { 
        Text = "主题列表", 

        Values = BuiltInThemesNames,
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            local Shown = ThemeManager:GetDisplayName(Value)
            if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s（默认）", Shown)
            end

            return Shown
        end,
        FormatListValue = function(Value: any)
            local Shown = ThemeManager:GetDisplayName(Value)
            if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s（默认）", Shown)
            end

            return Shown
        end
    })

    Themesbox:AddButton("设为默认", function()
        local ThemeName = ThemeList.Value
        ThemeManager:SaveDefault(ThemeName)

        ThemeManager.Library:Notify(string.format("已将默认主题设为 %q", ThemeManager:GetDisplayName(ThemeName)))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddDivider()

    CustomThemeName = Themesbox:AddInput("ThemeManager_CustomThemeName", { 
        Text = "自定义主题名称" 
    })

    local function SaveThemeWithContrastCheck(Name: string, SuccessMessage: string, OnSaved: (() -> nil)?)
        local function DoSave()
            local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
            if not Success then
                ThemeManager.Library:Notify(string.format("保存主题 %q 失败：%s", ThemeManager:GetDisplayName(Name), ErrorMessage))
                return
            end

            ThemeManager.Library:Notify(string.format(SuccessMessage, ThemeManager:GetDisplayName(Name)))
            if OnSaved then OnSaved() end
        end

        local Report = ThemeManager:GetContrastReport()
        if Report.Passes then
            DoSave()
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_LowContrastSave",
            "低对比度主题",
            string.format(
                "该主题对比度为 %.1f:1（涉及 %s），低于建议的 %.1f:1，文字可能难以辨认。仍要保存吗？",
                Report.Ratio, Report.PairName, ContrastWarnThreshold
            ),

            "仍然保存",
            DoSave
        )
    end

    Themesbox:AddButton("创建主题", function()
        local Name = CustomThemeName.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("主题名称不能为空。")
            return
        end

        if string.lower(Name) == "default" then
            ThemeManager.Library:Notify("主题名称无效。")
            return
        end

        ShowDialog(
            function(): boolean
                return ThemeManager:GetCustomTheme(Name) ~= nil
            end,

            "ThemeManager_CreateTheme",
            "主题已存在",
            string.format("已存在名为 %q 的自定义主题，覆盖后会用当前配色替换它。", Name),

            "覆盖",
            function()
                SaveThemeWithContrastCheck(Name, "主题 %q 创建成功", RefreshList)
            end
        )
    end)

    Themesbox:AddDivider()

    CustomThemeList = Themesbox:AddDropdown("ThemeManager_CustomThemeList", { 
        Text = "自定义主题",

        Values = ThemeManager:ReloadCustomThemes(), 
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s（默认）", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s（默认）", Value)
            end

            return Value
        end
    })

    Themesbox:AddButton("加载主题", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ThemeManager:ApplyTheme(Name)
        ThemeManager.Library:Notify(string.format("主题 %q 加载成功", ThemeManager:GetDisplayName(Name)))
    end)

    Themesbox:AddButton("覆盖主题", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_OverwriteTheme",
            "覆盖主题",
            string.format("确定要用当前配色覆盖 %q 吗？此操作不可撤销。", Name),

            "覆盖",
            function()
                SaveThemeWithContrastCheck(Name, "主题 %q 覆盖成功")
            end
        )
    end)

    Themesbox:AddButton("删除主题", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_DeleteTheme",
            "删除主题",
            string.format("确定要删除 %q 吗？此操作不可撤销。", Name),
            
            "删除",
            function()
                local Success, ErrorMessage = ThemeManager:Delete(Name)
                if not Success then
                    ThemeManager.Library:Notify(string.format("删除主题失败：%s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify(string.format("主题 %q 已删除", ThemeManager:GetDisplayName(Name)))
                RefreshDefaultThemeLabel()
            end
        )
    end)

    Themesbox:AddButton("刷新列表", RefreshList)

    Themesbox:AddButton("设为默认", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("请先选择一个主题。")
            return
        end

        ThemeManager:SaveDefault(Name)
        ThemeManager.Library:Notify(string.format("已将默认主题设为 %q", Name))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddButton("重置默认", function()
        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ResetDefault",
            "重置默认主题",
            "确定要清除默认主题吗？下次加载时库将回到内置默认主题。",
            
            "重置",
            function()
                local Success, ErrorMessage = ThemeManager:DeleteDefaultTheme()
                if not Success then
                    ThemeManager.Library:Notify(string.format("重置默认主题失败：%s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify("已重置默认主题。")
                RefreshDefaultThemeLabel()
            end
        )
    end)

    DefaultThemeLabel = Themesbox:AddLabel("当前默认主题：未设置", true);

    Themesbox:AddDivider()

    
    Themesbox:AddInput("ThemeManager_ThemeJSON", {
        Text = "主题 JSON"
    })

    Themesbox:AddButton("导入主题", function()
        local ThemeJSON = ThemeJSONInput.Value
        if IsStringEmpty(ThemeJSON) then
            ThemeManager.Library:Notify("主题 JSON 不能为空")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ImportTheme",
            "导入主题",
            "确定要导入该主题吗？当前配色将被覆盖。",

            "导入",
            function()
                local Success, ErrorMessage = ThemeManager:LoadJSON(ThemeJSON)
                if not Success then
                    ThemeManager.Library:Notify(string.format("导入主题失败：%s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify("主题导入成功")
            end
        )
    end)

    Themesbox:AddButton("导出当前主题", function()
        local EncodedData, Success, ErrorMessage = ThemeManager:SaveJSON()
        if not Success then
            ThemeManager.Library:Notify(ErrorMessage)
            return
        end

        ThemeJSONInput:SetValue(EncodedData)
        if setclipboard then
            setclipboard(EncodedData)
            ThemeManager.Library:Notify("已复制主题到剪贴板")
        end
    end)

    
    CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, ThemeJSONInput =
        ThemeManager.Library.Options.ThemeManager_CustomThemeList,
        ThemeManager.Library.Options.ThemeManager_CustomThemeName,
        ThemeManager.Library.Options.ThemeManager_ThemeList,
        ThemeManager.Library.Options.FontFace,
        ThemeManager.Library.Options.BackgroundImage,
        ThemeManager.Library.Options.ThemeManager_ThemeJSON;

    
    ThemeList:OnChanged(function()
        ThemeManager:ApplyTheme(ThemeList.Value)
    end)

    local function UpdateTheme()
        ThemeManager:ThemeUpdate()
    end

    BackgroundColor:OnChanged(UpdateTheme)
    MainColor:OnChanged(UpdateTheme)
    AccentColor:OnChanged(UpdateTheme)
    OutlineColor:OnChanged(UpdateTheme)
    FontColor:OnChanged(UpdateTheme)
    FontFace:OnChanged(function(Value) ThemeManager.Library:SetFont(Enum.Font[Value]) end)
    if BackgroundImage and type(BackgroundImage.OnChanged) == "function" then
        BackgroundImage:OnChanged(function(Value) ThemeManager.Library:SetBackgroundImage(Value) end)
    end

    
    ThemeManager:LoadDefault()
    ThemeManager:UpdateContrastWarning()
    ThemeManager.AppliedToTab = true
    RefreshDefaultThemeLabel()

    return Themesbox
end

function ThemeManager:CreateGroupBox(Tab: any, IconName: string)
    return Tab:AddGroupbox({
        Side = "Left",
        Name = "主题",
        IconName = IconName or "paintbrush",
    })
end

function ThemeManager:ApplyToTab(Tab: any, IconName: string)
    local Groupbox = ThemeManager:CreateGroupBox(Tab, IconName)
    return ThemeManager:CreateThemeManager(Groupbox)
end

function ThemeManager:ApplyToGroupbox(Groupbox: any)
    return ThemeManager:CreateThemeManager(Groupbox)
end

getgenv().ObsidianThemeManager = ThemeManager
return ThemeManager
]====]

local SAVE_SOURCE = [====[
local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))


local isfolder, isfile, listfiles = isfolder, isfile, listfiles
local isfolder_copy, isfile_copy, listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)
local isfolder_success, isfolder_error = pcall(function() return isfolder_copy("test" .. tostring(math.random(1000000, 9999999))) end)

if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
    isfolder = function(folder)
        local success, data = pcall(isfolder_copy, folder)
        return (if success then data else false)
    end

    isfile = function(file)
        local success, data = pcall(isfile_copy, file)
        return (if success then data else false)
    end

    listfiles = function(folder)
        local success, data = pcall(listfiles_copy, folder)
        return (if success then data else {})
    end
end


local SaveManager = {
    Library = nil,

    Folder = "ObsidianLibSettings",
    SubFolder = "",

    Ignore = {},
    LoadingOrder = {},
    UseLoadingOrder = false,

    AutoloadConfig = nil
}

function SaveManager:SetLibrary(Library)
    SaveManager.Library = Library
end


local SpecialValueParser = {
    UDim2 = {
        Encode = function(Value: UDim2)
            return {
                X = { Scale = Value.X.Scale, Offset = Value.X.Offset },
                Y = { Scale = Value.Y.Scale, Offset = Value.Y.Offset }
            }
        end,

        Decode = function(Data: any)
            local DataType = typeof(Data)
            if DataType == "table" then
                return UDim2.new(Data.X.Scale, Data.X.Offset, Data.Y.Scale, Data.Y.Offset)
            elseif DataType == "UDim2" then
                return Data
            end

            return nil
        end
    }
}

local ElementParser = {}; do
    local function CreateParser(
        ElementType: string, 
        LibaryIndex: string, 
        
        Save: (string, any, ...any) -> any, 
        Load: (any?, any) -> any,
        CustomElementFetcher: boolean?
    )
        ElementParser[ElementType] = { 
            Save = function(Index: string, Element: any, ...)
                local Data = Save(Index, Element, ...)
                Data.type = ElementType
                Data.idx = Index

                return Data
            end, 

            Load = function(Index: string?, Data: any)
                if CustomElementFetcher == true then
                    return Load(nil, Data)
                end

                local Elements = SaveManager.Library and SaveManager.Library[LibaryIndex]
                local Element = Elements and Elements[Index]
                return Load(Element, Data)
            end
        }
    end

    CreateParser(
        "Toggle", "Toggles",
        function(Index: string, Toggle: any)
            return { value = Toggle.Value }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end
            
            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "Slider", "Options",
        function(Index: string, Slider: any)
            return { value = tostring(Slider.Value) }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end

            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "Dropdown", "Options",
        function(Index: string, Dropdown: any)
            return { value = Dropdown.Value, multi = Dropdown.Multi }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end
            
            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "ColorPicker", "Options",
        function(Index: string, ColorPicker: any)
            return { value = ColorPicker.Value:ToHex(), transparency = ColorPicker.Transparency }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            
            Element:SetValueRGB(Color3.fromHex(Data.value), Data.transparency)
        end
    )

    CreateParser(
        "KeyPicker", "Options",
        function(Index: string, KeyPicker: any)
            return { mode = KeyPicker.Mode, key = KeyPicker.Value, modifiers = KeyPicker.Modifiers, toggled = KeyPicker.Toggled }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            
            Element:SetValue({ Data.key, Data.mode, Data.modifiers })
            if Data.mode == "Toggle" and Data.toggled ~= nil then
                Element.Toggled = Data.toggled
                Element:Update()
            end
        end
    )

    CreateParser(
        "Input", "Options",
        function(Index: string, Input: any)
            return { text = Input.Value }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if typeof(Data.text) ~= "string" then return end

            if Element.Value == Data.text then
                Element:RunChanged()
                return
            end

            Element:SetValue(Data.text)
        end
    )

    CreateParser(
        "Groupbox", "Tabs",
        function(Index: string, Groupbox: any, TabIndex: string)
            return {
                tabIdx = TabIndex,
                collapsed = Groupbox.Collapsed,
                poppedOut = Groupbox.PoppedOut == true,
                popoutPos = if Groupbox.PoppedOut and Groupbox.PopOutFloat then SpecialValueParser.UDim2.Encode(Groupbox.PopOutFloat.Position) else nil,
            }
        end,
        function(_, Data: any)
            local TabIndex, Index = Data.tabIdx, Data.idx
            if typeof(TabIndex) ~= "string" or typeof(Index) ~= "string" then return end

            local Tabs = SaveManager.Library and SaveManager.Library.Tabs
            local Tab = Tabs and Tabs[TabIndex]
            if not Tab then return end

            local Groupbox = Tab.Groupboxes[Index]
            if not Groupbox then return end

            
            if Groupbox.Collapsed ~= Data.collapsed then
                Groupbox:SetCollapsed(Data.collapsed == true)
            end

            
            if Groupbox.PopOutEnabled then
                if Data.poppedOut == true then
                    local Position = SpecialValueParser.UDim2.Decode(Data.popoutPos)
                    Groupbox:SetPoppedOut(true, Position)
                elseif Groupbox.PoppedOut then
                    Groupbox:SetPoppedOut(false)
                end
            end
        end,
        true
    )

    CreateParser(
        "Tabbox", "Tabs",
        function(Index: string, Tabbox: any, TabIndex: string)
            return {
                tabIdx = TabIndex,
                poppedOut = Tabbox.PoppedOut == true,
                popoutPos = if Tabbox.PoppedOut and Tabbox.PopOutFloat then SpecialValueParser.UDim2.Encode(Tabbox.PopOutFloat.Position) else nil,
            }
        end,
        function(_, Data: any)
            local TabIndex, Index = Data.tabIdx, Data.idx
            if typeof(TabIndex) ~= "string" or typeof(Index) ~= "string" then return end

            local Tabs = SaveManager.Library and SaveManager.Library.Tabs
            local Tab = Tabs and Tabs[TabIndex]
            if not Tab then return end

            local Tabbox = Tab.Tabboxes and Tab.Tabboxes[Index]
            if not Tabbox then return end

            
            if Tabbox.PopOutEnabled then
                if Data.poppedOut == true then
                    local Position = SpecialValueParser.UDim2.Decode(Data.popoutPos)
                    Tabbox:SetPoppedOut(true, Position)
                elseif Tabbox.PoppedOut then
                    Tabbox:SetPoppedOut(false)
                end
            end
        end,
        true
    )
end


local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    return typeof(Name) == "string" and (
        Trim(Name) ~= "" and 
        not Name:match("^%s*$") and 
        not Name:find('[<>:"|%?%*%z]')
    )
end


local function SplitPath(Path: string): {string}
    local Result = {}
    local Current = ""

    for Part in string.gmatch(Path, "[^/]+") do
        Current = if Current == "" then Part else (Current .. "/" .. Part)
        table.insert(Result, Current)
    end

    return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) then
        return false
    end

    return string.format("%s/settings", SaveManager.Folder)
end

local function GetSubFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) or IsStringEmpty(SaveManager.SubFolder) then
        return false
    end

    return string.format("%s/settings/%s", SaveManager.Folder, SaveManager.SubFolder)
end

local function GetCurrentSettingsPath(): false | string
    local SubFolderPath = GetSubFolderPath()
    return if SubFolderPath == false then GetFolderPath() else SubFolderPath
end


local function GetConfigPath(ConfigName: string): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/%s.json", CurrentSettingsPath, ConfigName)
end

local function DoesConfigExist(ConfigName: string): boolean
    local ConfigPath = GetConfigPath(ConfigName)
    return if ConfigPath == false then false else isfile(ConfigPath)
end

local function GetAutoloadPath(): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/autoload.txt", CurrentSettingsPath)
end


function SaveManager:SetLoadingOrder(Enabled: boolean, Order: {string}?)
    SaveManager.UseLoadingOrder = Enabled == true
    SaveManager.LoadingOrder = typeof(Order) == "table" and Order or SaveManager.LoadingOrder
end

function SaveManager:SetIgnoreIndexes(Indexes: {string}?)
    assert(typeof(Indexes) == "table", "Expected table, got " .. typeof(Indexes))

    for _, Index in Indexes do
        SaveManager.Ignore[Index] = true
    end
end

function SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({
        "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "FontFace", "BackgroundImage",
        "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName", "ThemeManager_ThemeJSON"
    })
end


function SaveManager:GetPaths(): {string}
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        local FolderPath = GetFolderPath()
        return if FolderPath == false then {} else SplitPath(FolderPath)
    end

    return SplitPath(SubFolderPath)
end

function SaveManager:BuildFolderTree(SkipWhenCreated: boolean?)
    local Paths = SaveManager:GetPaths()
    if #Paths == 0 then
        return false
    end

    if SkipWhenCreated == true then
        if isfolder(Paths[1]) then
            return true
        end
    end

    for _, Path in Paths do
        if isfolder(Path) then continue end
        
        makefolder(Path)
    end

    return true
end

function SaveManager:CheckFolderTree()
    return SaveManager:BuildFolderTree(true)
end

function SaveManager:CheckSubFolder(CreateFolder: boolean)
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        return false
    end

    local FolderExists = isfolder(SubFolderPath)
    if not CreateFolder then
        return FolderExists
    end

    makefolder(SubFolderPath)
    return true
end

function SaveManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "路径无效")

    SaveManager.Folder = Folder
    SaveManager:BuildFolderTree()
end

function SaveManager:SetSubFolder(SubFolder: string)
    assert(IsValidFolderPath(SubFolder), "路径无效")

    SaveManager.SubFolder = SubFolder
    SaveManager:BuildFolderTree()
end


function SaveManager:RefreshConfigList()
    local SettingsPath = GetCurrentSettingsPath()
    if SettingsPath == false then
        return {}
    end

    pcall(makefolder, SettingsPath)
    local SuccessList, Files = pcall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        SaveManager.Library:Notify(string.format("加载配置列表失败：%s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local RawFileName = FilePath:match("(.+)%..+$")
        if not RawFileName then continue end

        local Position = RawFileName:gsub("\\", "/"):find("/[^/]*$")
        local FileName = Position and RawFileName:sub(Position + 1) or RawFileName
        if not FileName or FileName == "autoload" then continue end

        table.insert(FileNames, FileName)
    end

    return FileNames
end

function SaveManager:SaveJSON(ConfigName)
    local Library = SaveManager.Library
    local IgnoreIndexes = SaveManager.Ignore
    local CurrentData = {
        timestamp = os.date("%d.%m.%Y %H:%M:%S"),
        name = ConfigName or "",

        objects = {},
        keybindMenu = nil,
    }

    if Library.KeybindFrame then
        local Hidden = {}
        for Index, Option in Library.Options do
            if Option.Type == "KeyPicker" and Option.NoUI ~= true and Option.MenuVisible == false then
                Hidden[Index] = true
            end
        end

        local KeybindMenu = Library.KeybindMenu
        local SettingsPosition = nil
        if KeybindMenu and KeybindMenu.SettingsFrame then
            SettingsPosition = SpecialValueParser.UDim2.Encode(KeybindMenu.SettingsFrame.Position)
        end

        CurrentData.keybindMenu = {
            visible = Library.KeybindFrame.Visible,
            position = SpecialValueParser.UDim2.Encode(Library.KeybindFrame.Position),
            collapsed = if KeybindMenu then KeybindMenu.Collapsed == true else false,
            settingsOpen = false,
            settingsPosition = SettingsPosition,
            hidden = Hidden,
        }
    end

    
    for Index, Toggle in Library.Toggles do
        if not Toggle.Type then continue end
        if IgnoreIndexes[Index] then continue end

        local Parser = ElementParser[Toggle.Type]
        if not Parser then continue end

        table.insert(CurrentData.objects, Parser.Save(Index, Toggle))
    end

    
    for Index, Option in Library.Options do
        if not Option.Type then continue end
        if IgnoreIndexes[Index] then continue end

        local Parser = ElementParser[Option.Type]
        if not Parser then continue end

        table.insert(CurrentData.objects, Parser.Save(Index, Option))
    end

    
    for TabIndex, Tab in Library.Tabs do
        if Tab.Groupboxes then
            for Index, Groupbox in Tab.Groupboxes do
                if typeof(Index) ~= "string" or IgnoreIndexes[Index] then continue end

                local Parser = ElementParser.Groupbox
                if not Parser then continue end

                table.insert(CurrentData.objects, Parser.Save(Index, Groupbox, TabIndex))
            end
        end

        if Tab.Tabboxes then
            for Index, Tabbox in Tab.Tabboxes do
                if typeof(Index) ~= "string" or IgnoreIndexes[Index] then continue end

                local Parser = ElementParser.Tabbox
                if not Parser then continue end

                table.insert(CurrentData.objects, Parser.Save(Index, Tabbox, TabIndex))
            end
        end
    end

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, CurrentData)
    if not SuccessEncode then
        return "", false, "Failed to encode data"
    end

    return EncodedData, true
end

function SaveManager:Save(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "配置名称无效"
    end

    if string.lower(ConfigName) == "autoload" then
        return false, "配置名称无效"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false then
        return false, "配置名称无效"
    end

    SaveManager:CheckFolderTree()

    local EncodedData, SuccessEncode, EncodeErrorMessage = SaveManager:SaveJSON(ConfigName)
    if not SuccessEncode then
        return false, EncodeErrorMessage
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, ConfigPath, EncodedData)
    if not SuccessWrite then
        return false, "写入配置文件失败：" .. tostring(ErrorMessage)
    end

    return true
end

function SaveManager:LoadJSON(Content: string)
    if IsStringEmpty(Content) then
        return false, "未提供 JSON"
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" or typeof(Decoded.objects) ~= "table" then
        return false, "配置数据解析失败"
    end

    local Library = SaveManager.Library
    local LoadingOrder = SaveManager.LoadingOrder
    local IgnoreIndexes = SaveManager.Ignore

    if SaveManager.UseLoadingOrder == true and typeof(LoadingOrder) == "table" then
        table.sort(Decoded.objects, function(a, b)
            local aIndex = table.find(LoadingOrder, a.type) or math.huge
            local bIndex = table.find(LoadingOrder, b.type) or math.huge
            return aIndex < bIndex
        end)
    end

    
    if Library.KeybindFrame and typeof(Decoded.keybindMenu) == "table" then
        local KeybindFrameData = Decoded.keybindMenu
        local IsVisible = KeybindFrameData.visible == true
        local Position = SpecialValueParser.UDim2.Decode(KeybindFrameData.position)

        Library.KeybindFrame.Visible = IsVisible
        Library.KeybindFrame.Position = Position or Library.KeybindFrame.Position

        local KeybindMenuToggle = Library.Options and Library.Options.KeybindMenuOpen
        if KeybindMenuToggle then
            KeybindMenuToggle:SetValue(IsVisible)
        end

        local KeybindMenu = Library.KeybindMenu
        if KeybindMenu then
            if KeybindMenu.SetCollapsed then
                KeybindMenu:SetCollapsed(KeybindFrameData.collapsed == true)
            end

            if typeof(KeybindFrameData.hidden) == "table" then
                for Index, Option in Library.Options do
                    if Option.Type ~= "KeyPicker" or Option.NoUI == true or not Option.SetMenuVisibility then
                        continue
                    end

                    Option:SetMenuVisibility(KeybindFrameData.hidden[Index] ~= true)
                end
            end

            local SettingsPosition = SpecialValueParser.UDim2.Decode(KeybindFrameData.settingsPosition)
            if SettingsPosition and KeybindMenu.SettingsFrame then
                KeybindMenu.SettingsFrame.Position = SettingsPosition
            end
            KeybindMenu:SetSettingsOpen(false)
        end
    end

    
    for _, Option in Decoded.objects do
        if not Option.type then continue end
        if IgnoreIndexes[Option.idx] then continue end

        local Parser = ElementParser[Option.type]
        if not Parser then continue end

        task.defer(Parser.Load, Option.idx, Option)
    end

    return true
end

function SaveManager:Load(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "未选择配置"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not isfile(ConfigPath) then
        return false, "配置文件不存在"
    end

    local SuccessRead, Content = pcall(readfile, ConfigPath)
    if not SuccessRead then
        return false, "读取配置文件失败"
    end

    return SaveManager:LoadJSON(Content)
end

function SaveManager:Delete(ConfigName: string): (boolean | string?)
    if IsStringEmpty(ConfigName) then
        return false, "未选择配置"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not isfile(ConfigPath) then
        return false, "配置文件不存在"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, ConfigPath)
    if not SuccessDelete then
        return false, "删除配置文件失败：" .. tostring(ErrorMessage)
    end

    if ConfigName == SaveManager.AutoloadConfig then
        SaveManager:DeleteAutoLoadConfig()
    end

    return true
end


function SaveManager:GetAutoloadConfig(): (string, boolean, string?)
    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return "none", false, "路径无效"
    end

    if not isfile(AutoloadPath) then
        return "none", false, "未设置自动加载配置"
    end

    local SuccessRead, AutoloadConfigName = pcall(readfile, AutoloadPath)
    if not (SuccessRead and typeof(AutoloadConfigName) == "string") then
        return "none", false, AutoloadConfigName
    end

    local ConfigExists = DoesConfigExist(AutoloadConfigName)
    if not ConfigExists then
        return "none", false, "配置文件未找到"
    end

    SaveManager.AutoloadConfig = AutoloadConfigName
    return AutoloadConfigName, true
end

function SaveManager:SaveAutoloadConfig(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "未选择配置"
    end

    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "路径无效"
    end

    if not DoesConfigExist(ConfigName) then
        return false, "配置不存在"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, AutoloadPath, ConfigName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = ConfigName
    return true
end

function SaveManager:LoadAutoloadConfig()
    local ConfigName, Success, FetchErrorMessage = SaveManager:GetAutoloadConfig()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "未设置自动加载配置" then
            SaveManager.Library:Notify(string.format("加载自动加载配置失败：%s", FetchErrorMessage))
        end

        return
    end

    local SuccessLoad, LoadErrorMessage = SaveManager:Load(ConfigName)
    if not SuccessLoad then
        SaveManager.Library:Notify(string.format("加载自动加载配置失败：%s", LoadErrorMessage))
        return
    end

    SaveManager.Library:Notify(string.format("自动加载配置 %q 加载成功", ConfigName))
end

function SaveManager:DeleteAutoLoadConfig(): (boolean, string?)
    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "路径无效"
    end

    if not isfile(AutoloadPath) then
        return false, "未设置自动加载配置"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, AutoloadPath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = nil
    return true
end


local function ShowDialog(
    Condition: () -> boolean,

    Index: string, 
    Title: string, 
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return SaveManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            Cancel = {
                Title = "取消",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end
            },

            DestructiveAction = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end
            }
        }
    })
end

function SaveManager:BuildConfigSection(Tab: any, IconName: string)
    assert(SaveManager.Library, "库未设置，请先调用 SaveManager:SetLibrary(Library)。")
    local ConfigurationBox = Tab:AddGroupbox({
        Side = "Right",
        Name = "配置",
        IconName = IconName or "folder-cog",
    })

    local ConfigNameInput, ConfigList, ConfigJSONInput, AutoloadConfigLabel
    local function RefreshList()
        ConfigList:SetValues(SaveManager:RefreshConfigList())
        ConfigList:SetValue(nil)
    end

    local function RefreshAutoloadConfigLabel()
        local AutoloadConfigName, _Success, _ErrorMessage = SaveManager:GetAutoloadConfig()

        AutoloadConfigLabel:SetText(string.format("当前自动加载配置：%s", AutoloadConfigName))
        if ConfigList then RefreshList() end
    end

    
    ConfigurationBox:AddInput("SaveManager_ConfigName", {
        Text = "配置名称"
    })

    ConfigurationBox:AddButton("创建配置", function()
        local ConfigName = ConfigNameInput.Value
        if IsStringEmpty(ConfigName) then
            SaveManager.Library:Notify("配置名称不能为空。")
            return
        end

        if string.lower(ConfigName) == "autoload" then
            SaveManager.Library:Notify("配置名称无效。")
            return
        end
        
        ShowDialog(
            function(): boolean
                return DoesConfigExist(ConfigName)
            end,

            "SaveManager_CreateConfig",
            "配置已存在",
            string.format("已存在名为 %q 的配置，覆盖后会用当前设置替换它。", ConfigName),

            "覆盖",
            function()
                local Success, ErrorMessage = SaveManager:Save(ConfigName)
                if not Success then
                    SaveManager.Library:Notify(string.format("创建配置 %q 失败：%s", ConfigName, ErrorMessage))
                    return
                end

                SaveManager.Library:Notify(string.format("配置 %q 创建成功", ConfigName))
                RefreshList()
            end
        )
    end)

    ConfigurationBox:AddDivider()

    
    ConfigurationBox:AddDropdown("SaveManager_ConfigList", {
        Text = "配置列表",

        Values = SaveManager:RefreshConfigList(),
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s（自动加载）", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s（自动加载）", Value)
            end

            return Value
        end
    })

    ConfigurationBox:AddButton({
        Text = "加载配置",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            ShowDialog(
                function(): boolean
                    return true 
                end,

                "SaveManager_LoadConfig",
                "加载配置",
                string.format("确定要加载 %q 吗？当前设置将被覆盖。", ConfigName),

                "加载",
                function()
                    local Success, ErrorMessage = SaveManager:Load(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("加载配置 %q 失败：%s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("配置 %q 加载成功", ConfigName))
                end
            )
        end
    })
    
    ConfigurationBox:AddButton({
        Text = "覆盖配置",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            ShowDialog(
                function(): boolean
                    return true 
                end,

                "SaveManager_OverwriteConfig",
                "覆盖配置",
                string.format("确定要用当前设置覆盖 %q 吗？此操作不可撤销。", ConfigName),

                "覆盖",
                function()
                    local Success, ErrorMessage = SaveManager:Save(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("覆盖配置 %q 失败：%s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("配置 %q 覆盖成功", ConfigName))
                end
            )
        end
    })

    ConfigurationBox:AddButton({
        Text = "删除配置",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            ShowDialog(
                function(): boolean
                    return true 
                end,

                "SaveManager_DeleteConfig",
                "删除配置",
                string.format("确定要删除 %q 吗？此操作不可撤销。", ConfigName),
                
                "删除",
                function()
                    local Success, ErrorMessage = SaveManager:Delete(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("删除配置 %q 失败：%s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("配置 %q 已删除", ConfigName))
                    RefreshAutoloadConfigLabel()
                end
            )
        end
    })

    ConfigurationBox:AddButton("刷新列表", RefreshList)

    
    ConfigurationBox:AddButton({
        Text = "设为自动加载",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("请先选择一个配置。")
                return
            end

            local Success, ErrorMessage = SaveManager:SaveAutoloadConfig(ConfigName)
            if not Success then
                SaveManager.Library:Notify(string.format("设置自动加载配置 %q 失败：%s", ConfigName, ErrorMessage))
                return
            end

            SaveManager.Library:Notify(string.format("已将 %q 设为自动加载配置", ConfigName))
            RefreshAutoloadConfigLabel()
        end
    })

    ConfigurationBox:AddButton({
        Text = "重置自动加载",
        DoubleClick = false,

        Func = function()
            ShowDialog(
                function(): boolean
                    return true 
                end,

                "SaveManager_ResetAutoload",
                "重置自动加载配置",
                "确定要清除自动加载配置吗？下次启动将不再自动加载任何配置。",
                
                "重置",
                function()
                    local Success, ErrorMessage = SaveManager:DeleteAutoLoadConfig()
                    if not Success then
                        SaveManager.Library:Notify(string.format("重置自动加载配置失败：%s", ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify("已重置自动加载配置。")
                    RefreshAutoloadConfigLabel()
                end
            )
        end
    })

    AutoloadConfigLabel = ConfigurationBox:AddLabel("当前自动加载配置：未设置", true);

    ConfigurationBox:AddDivider()

    
    ConfigurationBox:AddInput("SaveManager_JSON", {
        Text = "配置 JSON"
    })

    ConfigurationBox:AddButton("导入配置", function()
        local ConfigJSON = ConfigJSONInput.Value
        if IsStringEmpty(ConfigJSON) then
            SaveManager.Library:Notify("配置 JSON 不能为空")
            return
        end

        ShowDialog(
            function(): boolean
                return true 
            end,

            "SaveManager_ImportConfig",
            "导入配置",
            "确定要导入该配置吗？当前设置将被覆盖。",

            "导入",
            function()
                local Success, ErrorMessage = SaveManager:LoadJSON(ConfigJSON)
                if not Success then
                    SaveManager.Library:Notify(string.format("导入配置失败：%s", ErrorMessage))
                    return
                end

                SaveManager.Library:Notify("配置导入成功")
            end
        )
    end)

    ConfigurationBox:AddButton("导出当前配置", function()
        local EncodedData, Success, ErrorMessage = SaveManager:SaveJSON()
        if not Success  then
            SaveManager.Library:Notify(ErrorMessage)
            return
        end

        ConfigJSONInput:SetValue(EncodedData)
        if setclipboard then
            setclipboard(EncodedData)
            SaveManager.Library:Notify("已复制配置到剪贴板")
        end
    end)

    
    ConfigNameInput, ConfigList, ConfigJSONInput =
        SaveManager.Library.Options.SaveManager_ConfigName, 
        SaveManager.Library.Options.SaveManager_ConfigList,
        SaveManager.Library.Options.SaveManager_JSON;

    
    RefreshAutoloadConfigLabel()
    SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName", "SaveManager_JSON" })

    return ConfigurationBox
end

SaveManager:BuildFolderTree()
return SaveManager
]====]

local function xjwCompile(name, source)
	local chunk, err = loadstring(source, "XJWUI:" .. name)
	if not chunk then error("[XJWUI] " .. name .. " 编译失败: " .. tostring(err)) end
	local ok, res = pcall(chunk)
	if not ok then error("[XJWUI] " .. name .. " 执行失败: " .. tostring(res)) end
	return res
end

Library = xjwCompile("Library", LIBRARY_SOURCE)
if type(Library) ~= "table" or type(Library.CreateWindow) ~= "function" then
	error("[XJWUI] 内核加载失败")
end
Library.ForceCheckbox = true

local function guardPrimaryPartCFrame()
	if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return end
	pcall(function()
		if type(getgenv) == "function" then
			local env = getgenv()
			if type(env) == "table" then
				if env.__revPPCFGuard then return end
				env.__revPPCFGuard = true
			end
		end
		local oldNamecall
		local function hookFn(self, ...)
			if getnamecallmethod() == "SetPrimaryPartCFrame" then
				local isModel = false
				pcall(function() isModel = self:IsA("Model") end)
				if isModel then
					local hasPart = false
					pcall(function() hasPart = self.PrimaryPart ~= nil end)
					if not hasPart then
						local cf = select(1, ...)
						pcall(function() self:PivotTo(cf) end)
						return self
					end
				end
			end
			if type(oldNamecall) ~= "function" then return end
			return oldNamecall(self, ...)
		end
		if type(newcclosure) == "function" then
			local okWrap, wrapped = pcall(newcclosure, hookFn)
			if okWrap and type(wrapped) == "function" then hookFn = wrapped end
		end
		oldNamecall = hookmetamethod(game, "__namecall", hookFn)
	end)
end

guardPrimaryPartCFrame()

local REV_I18N = {
	Enable = false,
	Started = true,
	Translate = function(s) return s end,
	SetEnabled = function() end,
}

local function xjwTryCompile(name, source)
	local ok, res = pcall(xjwCompile, name, source)
	if ok and type(res) == "table" then return res end
	return nil
end

local ThemeManager = xjwTryCompile("ThemeManager", THEME_SOURCE)
local SaveManager = xjwTryCompile("SaveManager", SAVE_SOURCE)

function XJWUI:Translate(s)
	-- 源码已直改中文，翻译器不再介入
	return s
end

function XJWUI:EnableChinese(enable)
	-- 兼容旧接口：界面文案已全部内置中文，无需运行期翻译
	return true
end

function XJWUI:InstallNotify(defaultTitle)
	if type(Library) ~= "table" or Library.__XJWUINotifyHooked then return end
	Library.__XJWUINotifyHooked = true
	local fallback = tostring(defaultTitle or self.Defaults.NotifyTitle or "提示")
	local rawNotify = Library.Notify
	if type(rawNotify) ~= "function" then return end
	Library.Notify = function(a, b)
		if Library.Unloaded then return end
		if type(b) == "table" then
			local title = tostring(b.Title or "")
			if title == "" then title = fallback end
			return rawNotify(a, {
				Title = self:Translate(title),
				Description = self:Translate(tostring(b.Content or b.Description or "")),
				Time = b.Time or b.Duration or 4,
				SoundId = b.SoundId or self.Defaults.NotifySoundId or 106145041472451,
				Volume = b.Volume or 1,
			})
		end
		return rawNotify(a, {
			Title = fallback,
			Description = self:Translate(tostring(b or "")),
			Time = 4,
			SoundId = self.Defaults.NotifySoundId or 106145041472451,
			Volume = 1,
		})
	end
end

function XJWUI:StyleSidebar(width, textOffset, textSize)
	width = width or self.Defaults.SidebarWidth
	textOffset = textOffset or self.Defaults.TabTextOffset
	textSize = textSize or self.Defaults.TabTextSize

	local function styleTabButtons()
		if type(Library.TabButtons) ~= "table" then return end
		for _, btn in ipairs(Library.TabButtons) do
			if type(btn) == "table" then
				local label = btn.Label
				if label then
					label.Visible = true
					label.TextXAlignment = Enum.TextXAlignment.Left
					label.TextSize = textSize
					label.TextTransparency = 0.3
					label.Position = UDim2.fromOffset(textOffset, 0)
					label.Size = UDim2.new(1, -textOffset, 1, 0)
					label:SetAttribute("XJWUITabLabel", true)
				end
				if btn.Padding then
					btn.Padding.PaddingLeft = UDim.new(0, 12)
					btn.Padding.PaddingRight = UDim.new(0, 12)
				end
			end
		end
	end

	local win = self.Window
	if win and type(win.SetSidebarWidth) == "function" then
		pcall(function() win:SetSidebarWidth(width) end)
	end

	styleTabButtons()
	task.defer(styleTabButtons)
	task.delay(0.5, styleTabButtons)
	task.delay(1.5, styleTabButtons)
	task.delay(3, styleTabButtons)
end

function XJWUI:CreateWindow(opts)
	opts = opts or {}
	local d = self.Defaults
	local anims = type(opts.Animations) == "table" and opts.Animations or {
		ToggleWindow = false,
		TabSwitch = true,
		Groupbox = true,
		Dropdown = true,
		KeyPicker = true,
	}

	local win = Library:__XJWCreateWindowRaw({
		Title = opts.Title or d.Title,
		Footer = opts.Footer or d.Footer,
		Icon = opts.Icon,
		CornerRadius = opts.CornerRadius or d.CornerRadius,
		SidebarCompacted = false,
		EnableCompacting = false,
		MinSidebarWidth = opts.MinSidebarWidth or d.MinSidebarWidth,
		NotifySide = opts.NotifySide or "Right",
		ShowCustomCursor = false,
		Resizable = true,
		Center = true,
		AutoShow = true,
		Animations = anims,
	})

	Library.ShowCustomCursor = false
	if type(Library.Animations) == "table" then
		Library.Animations.ToggleWindow = false
	end

	self.Window = win
	if opts.TitleFlow ~= false then
		task.defer(function()
			pcall(function()
				self:InstallTitleFlow(win, { Title = opts.Title or d.Title })
			end)
		end)
	end

	task.delay(0.6, function()
		if type(Library.Toggles) ~= "table" then return end
		for _, t in pairs(Library.Toggles) do
			if type(t) == "table" and type(t.Display) == "function" then
				pcall(function() t:Display() end)
			end
		end
	end)

	task.defer(function()
		self:StyleSidebar(opts.SidebarWidth, opts.TabTextOffset, opts.TabTextSize)
	end)

	if opts.BackgroundImage ~= false then
		task.defer(function()
			self:ApplyBackgroundImage(opts.BackgroundImage or self:GetBackgroundImage())
			pcall(function() XJWUI:SoftenOuterBorder() end)
		end)
	end

	return win
end


local XJW_BACKGROUND_SCALE = Enum.ScaleType.Crop

local function xjwFixBackgroundAspect()
	local gui = Library and Library.ScreenGui
	if not gui then return end
	local ok, children = pcall(function() return gui:GetChildren() end)
	if not ok or type(children) ~= "table" then return end
	for _, obj in ipairs(children) do
		if obj:IsA("ImageLabel") and obj.Image ~= "" and obj.BackgroundTransparency == 1 then
			if obj:FindFirstChildOfClass("UICorner") and obj.ImageTransparency >= 0.5 then
				if obj.ScaleType ~= XJW_BACKGROUND_SCALE then
					obj.ScaleType = XJW_BACKGROUND_SCALE
				end
			end
		end
	end
end

function XJWUI:GetBackgroundImage()
	return tostring(self.Defaults.BackgroundImage or "")
end

function XJWUI:ApplyBackgroundImage(url)
	if type(Library) ~= "table" or type(Library.SetBackgroundImage) ~= "function" then return false end
	url = tostring(url or self:GetBackgroundImage())
	local ok = pcall(function() Library:SetBackgroundImage(url) end)
	task.defer(xjwFixBackgroundAspect)
	return ok
end

function XJWUI:SoftenOuterBorder()
	local gui = Library and Library.ScreenGui
	if not gui then return end
	local outline = (Library.Scheme and Library.Scheme.OutlineColor) or Color3.fromRGB(70, 70, 80)
	local ok, list = pcall(function() return gui:GetDescendants() end)
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

function XJWUI:InstallBackground(url)
	if type(Library) ~= "table" then return false end
	if type(url) == "string" and url ~= "" then
		self.Defaults.BackgroundImage = url
	end
	if not self.__XJWBackgroundHooked then
		self.__XJWBackgroundHooked = true
		if type(Library.SetBackgroundImage) == "function" then
			local rawSetBackgroundImage = Library.SetBackgroundImage
			Library.SetBackgroundImage = function(self2, image)
				local ok, res = pcall(rawSetBackgroundImage, self2, image)
				task.defer(xjwFixBackgroundAspect)
				if not ok then return nil end
				return res
			end
		end
		if type(Library.UpdateColorsUsingRegistry) == "function" then
			local rawUpdateColors = Library.UpdateColorsUsingRegistry
			Library.UpdateColorsUsingRegistry = function(self2, ...)
				local res = rawUpdateColors(self2, ...)
				pcall(function() XJWUI:SoftenOuterBorder() end)
				return res
			end
		end
		task.spawn(function()
			for _ = 1, 40 do
				xjwFixBackgroundAspect()
				task.wait(0.5)
			end
		end)
		task.spawn(function()
			for _ = 1, 20 do
				pcall(function() XJWUI:SoftenOuterBorder() end)
				task.wait(0.5)
			end
		end)
	end
	self:ApplyBackgroundImage()
	pcall(function() XJWUI:SoftenOuterBorder() end)
	return true
end

function XJWUI:InstallBackgroundDropdown(tab, opts)
	opts = opts or {}
	local gb = tab and tab.Groupboxes and tab.Groupboxes["主题"]
	if not gb or type(gb.Elements) ~= "table" then return nil end

	-- 库内设置页已自带带图片预览的背景下拉，存在时不再叠加第二个
	for _, el in ipairs(gb.Elements) do
		local exists = false
		pcall(function()
			exists = el.Type == "Dropdown" and el.Text == "背景图片"
		end)
		if exists then
			pcall(function() self:ApplyBackgroundImage() end)
			return el
		end
	end

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

	local DefaultImage = tostring(opts.BackgroundImage or self:GetBackgroundImage())
	local presets = {
		{ "默认立绘", DefaultImage },
		{ "无背景（纯主题配色）", "" },
	}

	local ThemeManager = Library.ThemeManager
	if type(ThemeManager) == "table" and type(ThemeManager.BuiltInThemes) == "table" then
		local used = {}
		for name, theme in pairs(ThemeManager.BuiltInThemes) do
			local data = type(theme) == "table" and theme[2]
			local img = type(data) == "table" and data.BackgroundImage
			if type(img) == "string" and img ~= "" and not used[img] and type(name) == "string" then
				used[img] = true
				local shown = ThemeManager.GetDisplayName and ThemeManager:GetDisplayName(name) or name
				table.insert(presets, { "主题背景 · " .. shown, img })
			end
		end
	end

	local values, map = {}, {}
	for _, preset in ipairs(presets) do
		if map[preset[1]] == nil then
			map[preset[1]] = preset[2]
			table.insert(values, preset[1])
		end
	end

	local picked = DefaultImage
	local dd = gb:AddDropdown("BackgroundImagePick" .. tostring(math.floor(os.clock() * 1000)), {
		Text = "背景图片",
		Values = values,
		Default = values[1],
		AllowNull = false,
		Multi = false,
		Tooltip = "选择窗口背景立绘，支持主题自带背景",
		Callback = function(value)
			local img = map[value]
			if type(img) ~= "string" then return end
			picked = img
			self:ApplyBackgroundImage(img)
		end,
	})
	if not dd then return nil end

	self:ApplyBackgroundImage(picked)

	task.spawn(function()
		while true do
			local scheme = Library and Library.Scheme
			if type(scheme) == "table" and type(picked) == "string" and scheme.BackgroundImage ~= picked then
				self:ApplyBackgroundImage(picked)
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
	return dd
end

function XJWUI:BuildSettingsTab(tab, opts)
	opts = opts or {}
	if type(tab) ~= "table" then return nil end
	local d = self.Defaults
	local Folder = tostring(opts.Folder or d.ConfigFolder or "Revenant")
	local ThemeManager = Library.ThemeManager
	local SaveManager = Library.SaveManager

	if type(ThemeManager) == "table" then
		pcall(function()
			ThemeManager:SetLibrary(Library)
			ThemeManager:SetFolder(Folder)
			ThemeManager:ApplyToTab(tab)
		end)
	end

	if type(SaveManager) == "table" then
		pcall(function()
			SaveManager:SetLibrary(Library)
			SaveManager:SetFolder(Folder)
			SaveManager:BuildConfigSection(tab)
			SaveManager:LoadAutoloadConfig()
		end)
	end

	pcall(function()
		local floatBox = tab:AddLeftGroupbox("悬浮窗", "settings")
		floatBox:AddDropdown("XJWFloatStyle", {
			Text = "开关方式",
			Values = { "黑曜石悬浮窗" },
			Default = (self.BootHandle and self.BootHandle.styleKey) or self:GetFloatStyle(),
			AllowNull = false,
			Multi = false,
			Tooltip = "使用黑曜石原生浮标",
			Callback = function(value)
				self:SetFloatStyle(value)
			end,
		})
		floatBox:AddLabel("仅使用黑曜石原生浮标，不再提供其他浮窗形态")
	end)
	pcall(function()
		local okAdd, box1 = pcall(function()
			return tab:AddLeftGroupbox("卸载", "shield")
		end)
		local unloadBox = (okAdd and box1) or nil
		if not unloadBox then
			local okFallback, box = pcall(function()
				return tab:AddLeftGroupbox("卸载")
			end)
			unloadBox = okFallback and box or nil
		end
		if not unloadBox then
			return
		end
		pcall(function()
			local holder = unloadBox.BoxHolder
			if not holder then
				return
			end
			local themes = tab.Groupboxes and tab.Groupboxes["主题"]
			local baseOrder = 0
			if themes and themes.BoxHolder and type(themes.BoxHolder.LayoutOrder) == "number" then
				baseOrder = themes.BoxHolder.LayoutOrder
			end
			holder.LayoutOrder = baseOrder - 10
		end)
		unloadBox:AddButton({
			Text = "卸载脚本",
			Func = function()
				local window = opts.Window or self.SettingsWindow or Library.Window
				local function doUnload()
					if type(opts.OnUnload) == "function" then
						task.defer(opts.OnUnload)
						return
					end
					task.defer(function()
						pcall(function()
							Library:Unload()
						end)
					end)
				end
				if window and type(window.AddDialog) == "function" then
					local okDialog = pcall(function()
						window:AddDialog("XJWUnloadConfirm" .. tostring(math.floor(os.clock() * 1000)), {
							Title = "卸载脚本",
							Description = "确定要卸载脚本吗？所有已启用的功能将被关闭，脚本随即终止。",
							AutoDismiss = true,
							OutsideClickDismiss = true,
							FooterButtons = {
								Cancel = { Title = "取消", Variant = "Ghost", Order = 1, Callback = function() end },
								Unload = { Title = "卸载", Variant = "Destructive", Order = 2, Callback = doUnload },
							},
						})
					end)
					if okDialog then
						return
					end
				end
				if not self._UnloadConfirmAt or (os.clock() - self._UnloadConfirmAt) > 4 then
					self._UnloadConfirmAt = os.clock()
					pcall(function()
						self:Notify("再次点击「卸载脚本」确认卸载，4 秒内有效")
					end)
					return
				end
				self._UnloadConfirmAt = nil
				doUnload()
			end,
		})
	end)
	task.defer(function() self:InstallBackgroundDropdown(tab, opts) end)
	return tab
end

function XJWUI:SetBackgroundImage(url)
	if type(Library) ~= "table" or type(Library.SetBackgroundImage) ~= "function" then return false end
	local ok = pcall(function() Library:SetBackgroundImage(url or "") end)
	return ok
end

function XJWUI:Notify(text, title)
	if type(Library) ~= "table" or type(Library.Notify) ~= "function" then return end
	Library:Notify({ Title = title or self.Defaults.NotifyTitle, Content = tostring(text or "") })
end




local XJW_ICON_B64 = {
	["house"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADJElEQVR42sWXv1sUURDHv3N7l4DGGEE4sRGrgIWlgloIQhrLNJJGCQELiQpaqH+BpcF0gsS/wFR2YqWFoJB0QkCsRAwJqMTc5fY+Fs6Tcd277F0UB46d3Zn3nXnz672TKhJQA+oV9OpArSquVTS+z8y2nL8v6ZCklqQRV2lLGpW0aWZ3imv1RMCIPyeAG+xON4CJuHZYwxb4MeC6G+gAW0AejOb+rePv14GxMqyBdg5kzi8AX4PBnZKdx29fgQVfm1WOBGBueDx8WwQ2HXgb+Ob8GnDJf2v+7Zvr4GsWA864Y1s/47XwPgFcC7vaALrOvwHmgu6cf8N1NsK6a6kmQjdZv3wfBZrAfAhtzPdnYMp19wP7nZ9yWayLlJZ5xzxaWhfAaMj7KvAxgLUDaAs46XnNPGoW3k+6DoW1nx1zNXTVaBwcGXAOWC4U1nd/PvJcTxfbs4Sfdt1HBYxEy24rA+px91dDyNdD2JeBycKky0pqKIuTEpgMG8odM6Xk6q8ohJDMhJC1vKdXgvwA0Ei5K9SNhUJuAAdCSlccqxXSMpPkcWbXJDWcH5H0XNIFM2t7d6SxWgca6Rl5SSkCW0DNzNqSLjhWSlPDbf0ECw7kgX8oacnM1n13ZmZ5QWe3mZIB5hh3Jb2TNF+0FR0g8E/N7K2HcsvMcuCYpDMu7/Swm/BemdkHd2KfYx0MDlDmQKSmF1pLUuYen5e0VDEAVyQ98bUtx2qWKfY6t3MPuXqkaDf6Tbdf+uoDgLZC6B9Ieh3WdySdknQz6Fai+oCHZNJ/ZmYvCkW3Lum2hgQclJredvFG1BwGaFgHcjPbSQPI+XwYoJr+M/VyICub93u43mXekpUd2PbWsao35z637jRFtwepgXaY2wK6hR1kXoRJTj+5t2V7NwciwD3giJk9DmH8FOSfzGxH0k4VOTArabbMVjECadCclXQI+BJCeTrILwKHC4OoTJ5m/i1JJ0rPkHDeXw63li5/nyLm5bL7QDboX7YhCvIPW+YXhy5w3EOfjkskdQsAWThsKDHQS14rdNRLM3s/yJ/Yf0bxXlfbw2gelDpm1pWkH8hGXjNeDAZbAAAAAElFTkSuQmCC",
	["user"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACoUlEQVR42sWXvWoUURTHf2dnds1oIiLiB4RgY0qFYKGFbcqEvIFYKXkIS20tRCWkygNIwBewMoV5giDYaQwxFgmazc7+bc6V67i7c2d3wQOXveycrzmf/zEakCQDcsCGsQA9MxPTJkktSXkCXy6plarXEo13zKzr9zXgAtDzaBDdT8zsbVVm0jc3SZmf25JONZxOnSfw2zQcaPvvsqQD1dOBpOVYdlzDWZT7dUm7bqAcYTw823WZVqxrEOV19WFmfUmrwBJwApwHPgCfgVBsfeAmcM95loBDM3vZpNb+qeboviWpF73pygD+leh5T9LWIF1VSm2XzE+gzgCezgh+xknBKJqTNAuEIjsD5sZRlOpA6Se81b6ZHVdSsD+Af2oOzLhxeUEtSLoWhb0LLETjOHOZqTkQDP30LngOPI2qW0BR4elMPAGj2X5f0qZX+NmIORCebbpMHusa15GgZFHSdsIk3Ja0WNd+TZfRrJkdS+oAH4GrwK8oz+H+DbhrZt0gM7EDPs/Nq7oP3KgUJNG9BL74fMkAmdnZ2LsgJYSJ+CBrFIHK/l+N9n+W0Dk9j0TAB9uN8EHD/V9HzfHBGPt/InwQb7zMzEqglLQOPAKueOHFS+sx8N0HTTcaVF3gMvA64u27jmeSbgGvKrb+yuew/X8OeA98BX6Y2ZuaCN4BLgHXgQc+GevxQc3+X6t0R3vIySK+tRR8kCfu/+JPmDxNCR1YpOCDYYAkDI9D4AmwI6lIAZkeiQLYcdnDis4kCLbhi2Uv+q9oMHyK6L7nujYG2WqN2P85cFHSvKNbNRuAakmaBy66rpkmKWhHjpRm1m+IbM1lyshwuw6QxIX1AnjnbXgUoZ5UCrxHwEMf5Z+G2Pq/ZCMKsjXp53blc75vZr0qz2/IUD9XO95+1gAAAABJRU5ErkJggg==",
	["crosshair"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADSUlEQVR42s2XP2sUYRDGn9m9O5MYNaAWNoIWgk0KGxuRgBCsgoUIGhQkYBNJWm0U/QYBA3ZWWuQT2NiIIhZ+AC0U0iqYoObi5u5+Fs7GyZtdcwnIObDsu7vzb9+ZeWZeUw0BmaSGJJlZoT0Q0PJlx8x6VTxWI9g0s43wfE3SeUldSfkOdkuel2b2rE5nSY0qr82sAI5IuuivH0o6scsNmPRdlKTnZval1F23XRbWB4A5/lAX6LCdCr9S6rhMSXPAgSpbW/4cyH29AHxLHNgtRZlvwILrzkNu/A6Bx6fw9SNJ05JGJf2UtC7pkKQPku6H3Dkrad6fFyS9lYQ/P5B0StKqpCHXdQPIzey2pO5mTgAZMAScBGaD16tAz9fvgJvJjk0AG35NJN9uugyuYzXonXVbQ0AmYJ8LXQ/xWw/GPwOTzrMfGAWawHRQOu3vRoH9zjvpsqUT6yGPrjvPviw43vZ77muTVEi6IOmF58eapKKqnPxdIWnNeV+4bOG62qGE21sAB5gBXgPtkNXvgakUVMrSAo4DV/06nnxrBbkp11VWTdttzWyWKbCUlNWbMuZAIyrcDQoCjZATb5KyXYrMi0mdT4WY16Fl5nFvBsDZhi0hJ6YSnFiMSJgnEDsSDDeAborl/tzboZfkAXhGwudNe40a+RUzQ9IP7ZGCgxvuxEoVX+pAT1Im6SIw6t+7kt6a2TKQ1XW1+Odm1vPEPOt/2pF0LrGxRehxSMIqKhOy2UfyNUPiUdM/AB5rmycDoDQEecD2VzEEoderj3lADkRXkhDMp/NE6kDs389rEquf5JOZLUtaDqH57g5kfx1InMZC6RSSuv0YrynDlkP4WBVfFrYtbu+al2HtPLcTELlMx9e4E0rtlTtw1L0tm8xd4LCZPXEoztJRqg8gaknqmdkPr6JbQX/Tbf4HzSjMA5dDrX71+09g3Meo3LG9dGTLPBAakAX+cdcRdQJcrpoHhkN8hn28apV93cy6npStKkDydy1JI857wWVbrms45NlwmkwDG8kajttdM/soaRE47UPpWBhKz0i6A7STobRM4kvAsTCU3kmG0oOSViQ9NbPFMAj3Bj6WD/xgYv/waPZJ0r2djmYDP5zaoI/nvwBl9oXvrFmTIQAAAABJRU5ErkJggg==",
	["eye"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACrUlEQVR42u2Xv1udZRTHP6e5SUw1oSUKQaqToGvAIcVBBUEo0lEIiINrsdDB0Q6OXaS41MWhONm/QBC6Onbs4KSFBkygtNX2/vy4fN/45HKNt0W4ij3w8D73vefXc873Oee88H+nmodJXZqXtxWrqvF/NwJqAT2Aqho+jXJ1OdtRVTm3A+pya1T9BHgPGHVOHUMdzw9V9c1f6eyoN8P4SlUN1E3gfUDgM+CNJwzAtvooh/y+qg463ceFvNuvqxf9k8bqyPlpFJmOLqrrs2wdOXnQjnpVfdAomPjk1Mo8UK92N0pdOZIC9WRV/Z79V8BHwAvAfWACnAJ+Ar4Afk5aJnl2WDqR56vAZeA14F7ebwAfqyeq6lNgfGizOfVp9ULj9aDZ31J3w7etvq3uqG9l7eTddnh2IzNL1wX19GF9SejX1UthGKr9hO2uuqeej8DZv0nHRD0b3vORvRtd/eg2ttbVFdRSrzQ5H4TxhrqV1VM/UPfnyP1+eHuN/I3oHDSYuKJWr6pUzyTnvwFLwHPAalXtNSDdAjaT+z6wNoXjR8BqeLaqagTsRXY1eHsMDGLrTFXZ1YEDYBgFAD8CN9WT+d0PIPvAStYv4QPYAV4OCPvA/WCr03cTeAl4M44MY/PwdNemwniu8zzed8Bq6Xojf33qv90Z8uemeK6RK7JQ6lIwzOoq1Ofq68DXTTseNymYAO+o3zUpGOdAg9zzpeAJ9RLwYfoEqR/D1oFNYLkB4Q7wa1V92YR5IzmdxMgrWdMgXAU2Mgt0xe3d6HwcR5+PTXqpy3eAh0HnMJ72g3yA/SD6IIJrM6K51gB6T+0BLzYgHjU37CFwR61/RSFaaCmuY5rRqX+4Gd0Dvk0zOmJzoe144QNJzTmSXX6Kkex2UnbsSLbwoXThY/mzT7Nn9Ad//ecqpjM/LwAAAABJRU5ErkJggg==",
	["terminal"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACSklEQVR42u2XsW4TQRCGv7EdJ8QgI0EEkUiFSIlEyQukhQZ6ahDPQYuCRAc9XQqKvAESCAlRUfAAIYkQCU4cx/ZHM442Jg6ydK7CSqfZ8613/pn55789uOgjxn9QG6cWRPQvdorUulqbaQnUuYg4VtvAC6Cdz3Yj4lmuaUVEZ1ZRLqRd9u/xVL2az5uzAjCf9ob6Q+2ru2lVn6uXi/UxKwA31cN0uldkYV99WXCiWTWAWm68oD5Uv6Xj32o35z/VV8V/WpWzvZg/UT+n46H6awInarPgw2LaNXW7ANEd40RbnZsFgMhy1NW76lE6PSyysKe+HpFxXD2rANEs5o/VDxn9sdpJEO8nyfc048waRkRPvaQ2I+Id8BGoAwOgAXSBrSqCbUwqA9CNCNVlYAUwAQssAFdmBgBYjIhOlmITuAP0gCZwmLY5KwK2cr6qbhTEO0gOqL5R749qX4kylj2t3ksnptP9AsiGulop+zPyRirikrqZzjrqIDugr34ZdUilSlhsuqR+TWeDvEZtt6leL6Q7qiThaLM6cDvvt4FrwCLwFliPiJ0sVZQvsWliBXoR4Xlvw4Ox80BZ81bVxG8UyEih+Q4s5f0W8CiF6dSJKA8x7SkiD2CYp6yhGhFxouWRolPLtI/SPIiI7bE1jYjoqw+A9QJ4/RwAR8A8sAOsZSmbEdFrpPSadpi1H29Pi7qN2vVWKuQ0YyVV9GSfxhkS3CxIeRZpBmk/JTnJ1J53NjgG5oC9vAAu+PfGxE+zadTzH8Rjwqv+f+pPjT8tFYmrHNPdeQAAAABJRU5ErkJggg==",
	["map"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACuklEQVR42u2XvWsUURTFf3d3ZlmSwIaQDxAbTWMjFlop2AlBK7EyCIFU1tYB/wOLFPkT7MRKLUQ7O9PbqI0BkyhswMBmv47NfeG6zuzsSsAmF4a589497533Me+da4wxSQZkgJWFAH0z0wR4hXb6ZjakrGFJGVAHBmbWryD5V+w0eBthWweIIEn3gVmg76Mh+Mdm9nKETBm+B+Re/MHMvkqqlY1qSdKKpKuSTlRuJx6zImlpCvymxzXKCGxL+i5pT9W257E7Ab9Tgd9IBDJJmZn1Jd0GHnsbd4BF9zthyuMSpLILXrYuad79u0BrBA/Q9HcvkU2bpQ9cAR6G3f3L65sFk5QFP3XQCngq8LXYkAIgMasDc+7/AAbeUBrVkXdcDzMVR5YX4HNgoZSJ+7k/6e/oAmvANWArxG552ZrHEDrOw3fEPw3l/aKpHAT/GbALdM1s1zfM51D/2cz2gX1J60ADuAE8CfiPI/gvVKxlPM3emNk7B84AQ2A+1M9LagI1M3vhcfuBwCszez+Cb1URiLYkKfeR9cysKymeaH0z60hqSJr1qV4O9csV+MI9EG1gZr34u4yxnscO/gVf4z/bOYFzAucEsglicklKaildVn7Q5BP860X4SgJZOGqP/Ug9CPUH6aCRNOPSKqvAH05D4MjMOg58EC6bZPckrfhlk+6CdqhvF+CvF2nRMgKXvYOLwHNvIFq6dLqSbgLfgNVQv1qAj5ddPeq/hr8fBc320zXd4YiW6/oT7dBj26GsXYAfBPz6qSYsmYGFAsk1NyI2kuRaLMC3CjThbMAntWSRwDAolU5YomaQYa/HiM4y0doM0uyt+59ORVBYgo0zlN1F+O2yHCAR2DzDxGMs/o/UTFLNzIaSLgG3grrNp0y9Jk7dXLCIMVnvmSWfVbExOY2nmUJKPWn6PXX6DvAbPQETJJbrCa0AAAAASUVORK5CYII=",
	["film"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACc0lEQVR42uWXvU8UYRDGf3N3CCYQkosJUtoSqRAJSqI2NtIaCBIpLDQmxvpiQoEx9pAYLej9A7Sw00KNRuqzghgKtSHSobfcYzOL491uWITckTjJm33v1duZeefr2TVcJJWACp2RxMyaHAcxSSUza0o6A1xMA+KrCZQB831Rr0u+BOz63nwBvDWzDUmliof9F3AFWO3QwW8BG0ClFMDdDkZ+z1YsusRXin8CVoBHwGngDfDM75czHI7YbeAS8A14ANwDzgX9CaH6T/h1Tn/klaRJx+uOLRc9nqRlf6buvyddZypzqe2Yglhgz4G6pAlg0LFBST2+ToZ9G9byzARQd51ttmIK4v4x8BDoBQbS+2bWcM9lZknLqfcwSamuKvAC+JlnK2/wDLXUBqGFCrV3qItT+/VrVyUvAltAw08w4P/TAfQqtNsPv/Z4SnIjEHO6BIwD19wZgCQUWWsB/oUFXVuuY9x1ttmqZHgNsGZmm8CmpB3HttMi9Oi0SiMU5LZvd8zso2NrWbYqOdG44dxQDS01Kul6wUE0GtrwvkfiQqatMIjm1TmZzxpEXe+CGNKnwDtPwaJfXwNPCqbgLnDZQ78UUnCnzVZIwUwI0VS4v34ILlgP2FTQP5ParmRML4AxSV+AYaAvckGIXJIRzRRLC7dP0nngKzCWZSuPCxaBWhhEh+GCl2EQFeaC6n/PBd/95L1HxAUpHQ8V5YIacBaYPgIumHZdtf24IDozC3w2s/c+14f/kQu2zeyDv97NZtlqbcPUs6tAVdIK0O/4yAG4YMSf6Zd0M+Ol1LIG0UIHuWAhiwvKHSz+8rH5NOv+x2m3P89/AyuUoddyMtm2AAAAAElFTkSuQmCC",
	["shirt"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADS0lEQVR42u2XP4wVVRTGf9+beY8nLMImIhhgCxtLEztjQmyICRZAsRbbYGtjAhZYYKExRjoTY2EHFNZSWNgRWsw2FtYUyq7EGLL8ebz581F47noZ5z0fm0204CSTmXvnnu989zv3njsjwmwPgBJA0pQZZrsEWkltp38ADCTVc3xH8VgnfyXQ3NH2GnACaIACmAJ7gD8lfZzAEtHO85fAMvAYGGUYNyV9l09EUl3aLiTVtg8B78T7T4FXZ8ziN+AH4I7t1F3aPg68C1ycIcDJUAngR0l3bRfYHtl+0fZ5/22N7ce2q2i3th/YrqO91kNsLd7VMbaNdhVYTYZ/PmKOSqACPgc+yPDUcx+GlACPemaY+ooYqxlYAJ8BrwAXS0m2fQxYAh5G3sq4A7wPnIn0pLXwke1VIEnaAitAHbkfRJq+B65kxOvAWAKOSXIZL/4IJfbE4BvAHWBD0lXbbwIvZMHeiqtrLbAvnjfD93XgSMz47VCiipgkAsO4kn0l6XrkNkm/ATiAZtkgiAsobA8lXQic00GgyNK0TaBr22QkVbY/AS4BLwM/Zenp2jRS9ftfrqr6MHObRWC/7aVweiRpI8lq+z1gb7a/yZ4fSvo52xnjSF0F7J9HoO0Abkq639lm46hg1+ekIFXKUtJE0gSYRP9mNqyJmNsERhHckb8V24dDgQq4J2liW7Em5lkdhW0MHMgwVhLHiDXKWV+LAvHA9tT2Xdu3bW/EdTZbkPyLAsO4n838bwfmNGLY9rVUQofA1yHJucB5qYO7zLPbMnB4xgK/Cnxje5hOv1u2L0cdUBSko3EgAWztgMBWyj9wE/g1Fq+By5J+2VbUdtEj5amsdq/uIAWrmf+pnnFFKhxIanqwRuye/QMrxSwzRsoqVAWMd5HAOLZnwm4k+SkC0VHbVmyjZhcJNIGp7hfTgP/YnhN4TmBRAkVfsZpTjIrsZJ1r5YKYm5Ia23sD3J2PTLK+oaStzvG7IwJ5gDO270laXwBzYvuN+JDtw1qYQC7hh8Brts9lfnUPVur7IvvJYV465hFoo2ymGZwAbmVt9yjm7Divs3b7LASSXAc7H5IlcHyHi/3grFT0EUhnwDrwbWcG1YIBh51dtt7B/v/YE78VDfvzrhK2AAAAAElFTkSuQmCC",
	["ellipsis"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABAUlEQVR42u2UQWoCQRBF34+TQTDgLgTxJF7HrQfwCDmAi9wg+yw9gFfwAlmEkI2gIIlDZdMNRdlZu0g9GIau/lVF1/xpSJIk+e8oBsysa+gGSeY0o0auSRqcRsDoqqF0ybFffQIzu5f0Y2ZT4BmYAmdgXHQbSTs33hWwAOo4O2AnaeM0C2BVlrXWAVhLOtSeVTwu75m1WQafbBuabdAs/6g18z2r4arBLsA78AicgEmJH8PkPoDv8gD0JeY5uv1a69NNzQDubu2BLvyOHTB3p6o8hLynst+HGCGnD7XmsWddDG5ULw0T7kPxN+ArmjBo9sBrw4Sn0DPvgbyKkyRJbssvnB6lowVzZrgAAAAASUVORK5CYII=",
	["image"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADNklEQVR42s2XvW8cVRTFf2dmba8T2wiJAEUaGhQShKCLlIpYooQGEAiqUNBRAIURTZAo3EML+QNSBSlSmogGKiRS4TIREgWKXYGDl7VnD82Z6Gkz481aTsKTRvP2vZ37cc69990nMmxXwIDHMw4kTfg/DNmuJE1svwBcaAHJc1xWVoDyAPws6Y7tahDYx8DrwHePyfGPgDvAoCoWm2LuR6DUXbrKoDvI065vAZeBpfxueoSOewyui28uA2cL+QddBpS/fwKuSLp6LK7bq8ClIsboMqD0cFPS9Xy4VgSPCs+VIN3JWz1ILEr63vafwPXDKCjHSt5rwA3gFPBv6KCYbwMXJW3bHkoadXjfGr3YpajPgGXbdfbPJo26xqlChvoZcA0M5zGgkdTYboA/gGeBUSGknd8t4bQ96NEx6gnimaVXgbpVXHoxzJ4Kow+6yu4UFQ9UqGMIctcPUTsWjoKAE3CjPBRBCLAPrEm6a/tl2xv5pilqQQV8DNyaxwAVAk5HyDT8AM8Dt22fAT4H3uuRdxv4q0N+rwGTgr+tRHsbeI7nNfA78BzwJfAh8E9ktik3jrIvOqrkoQaM894BLnbEykng7/B6AzgT2IdT0a5ZNM9EQNJ2T+Q9BWwCr2RpNwYsZB1gIyi2iC3OHQNFbg+AiaQ92+eBT4D3o2APWM3/rhUGvAS8lW/vzWPAfUcljZPD+2lcngG+At4I50PgRKD/DXg3HpP5L8C5Pl0PWwdORPkicBNYLzgfBd6bwLqkceRWma9nb+koBlS2VyTds/0icDWc14F9Eu+vABuSdtLc3m90Je0kC77pOnmrQxS3nO/afi0B9WY4382JOQB+yPF9y/bJ0NZIalIlVyX9mth4oDvqTcO2rofzzYLz5YLzLeCdxMmKpN227kuyJNtuq+bTc1dC2yvh71wULgeBBeBH4ANg3/YSMLa9UMBfngHjGH+oAXUx/9T220mtNs/3YkCdLPg2/JZnQ9fYt30pLdnMStgepxeK/m0UROrsK2n2qu3T8WxWU/rZVFPaicCgh5KuTubrI7blg2m9VQ8Fj+QW1qWr72o2mVEjmjkvL71Xsyd/OX3S1/P/ADWDTsL2CqdsAAAAAElFTkSuQmCC",
	["key"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADQ0lEQVR42rWXTYtcVRCGn+ruO5lMMpFghhaELEUQXAT9AZqVgooryUIluPJj5cqfIO5CCG4ENUKUCILustCdC0GyEATdGRCSxYgDJjPT0933cVMHTpq+PR+ZLij63nPqnqpTH29VwxJJDbVZJBNLVN4ARsREvQS8ALS5/XlE/KIOlqV8pXp+Xf3Lh+m93DsxWIbbganaB54BvgFWgH+B0ym2VcR7S3DAyYiYAheBH1N5m8obYAA0aeDxur3EVL2s3k53T9WJOq5C8FIJwTJi/qr6Zyq6r+6pbRpRDLqmPn8sSZil1k9+Vh1VyufRXv5eB+gtKeYCa/t8t9dpgNqoqwv4hHpKHUTEtnoZ+Bg4lwm3mxhzD3gRuJlHj9O4XeABmZF1+fQBImKcwotoVGIOfAQ8lYeu7OPZSXpn4yEDIsLcRF3fx4WreYsh8G0qfQCcmpF7Avip3DHLsAHuA3+rER0huAK8kV5oOiC8TY9t5No013uVu3vFq8BOGtoHPgQ+A0aog4z5RfVG8qYHp1bdqd7fVn+u3mer4X31bF60PwD6ETFSN4BLaW2b3BXLkmiD5B5wB/guIr5Ut/N9DXgN+A34HdiKiGupfC0itkvGn1HfzRoeVcBxV703w3crUGmruv+iqqAmn8+od9Q3q/D2tWoBCSSfqFuVAaq31GHyk8nl/VbK1PJfzVRUeR7WSNmFZjfykEnyVfXCAvkLKTNJaFX9uuoFTeZWbchgXgMqZfjPTMb/EBG3sxwLeJTsb3LvceCD2q6ImNTP6d1VYFztzTWgmSm3YVq7m6BU3770+uF+GJ3YsrtIpivLp4nvXQdPs+4fmboMaBYNk7nXHIcBg6qupxVqbUbEWD2pOvtNROyom7XHjuqRYkCByKLsvLoeEf/NayaZnOcr+X72hyMPFddn6nor+0GX/JU5uPF9XXIH9kAKX81J9Z1cfwx4Sz0302DavPXLKbOd658CN9X+oRO0DIY5vxcaH6AJ1TKvzM6Gh8mBNut6JScYgLP1rNBVqkBJxNU8oz3qHwnU9TlYv4jqXnH6qPnXNZA8Bzzd0ZLL2h8R8euj4kDdLHoFXCJidJj8Saxvj9MDgwOM7G1XgzkM/Q9ektJ6i0LBUAAAAABJRU5ErkJggg==",
	["bot"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADJUlEQVR42tWXsW6cRRSFv7P+17sB4oWAbRKHN0DpKBCijASiMA0NoqHkDXgECiQKSgokeACUkhIBHY0pUJQyClgEg2QJe9f2eg/NmWX49dvexLYsRhrt1dz5771z59wzd+GKhxbZZLsP9E7ZciRpxv9xLJqBETA8ZcuupMmFBmC7kTSN/DmwCUyBpmwBBpE/kvSN7b6koycJoFkwuNeAV07Z+8LTXkHTdfISQCV/DTwAjoE+MANuAW9Ev5+9jW2fmvJk9dzD9l3/O959Wju9CwLz4bmqoIAnaP8EGAFHuaLDBKoq6BlwG3g9az8CDytdbX854O0Du8DHknaLzxLAUNLE9i3g10su/Q1JvxWfdUkRkD0C1pOBa8B21lXtK5ko3087Tm5gCbgJjJOB32Nr7rOrDPvVPATeAh6HiBYlm7J3DfgJeKay3YnoQX7XbT8Ksr+zvXkB1bIZW47t9dpnqYJeqeMqlVuS7tlubF/vMDy0Pcgcduivh03vAVtZnoUrmuK7XMGhpGPb+9U9r1TVMY6TUc39thVycVsPjCVN85KuVPe+n3XPMyCpAGNcHWJWeD3sdTcn2YpcDlAO8R99YbzYqAE6rn02SdeHwJsByegEwDyf6ihym8i69LRsjYAvbB8B30v6skT/HvB2qyTbAfydSfXrM/TtAFaADyK/DMwD+Bl4NalaS/0ft4wsA89VMk+gL7YmKelefM7v71PgM+Al4Ftgo4Pfl06QF9EXW38B7wA7JagmgNgJFnbCauU5HuRjAT8A71fcT7WXtt52L1e0XL0jU+B+Bfo5CJ9NRGsVsPYkHcTQQNLDPDh13+Cqe2rrrwEHsbFXgXbD9mNgSdJecTZNT3dQRXvD9qqkmaRxV2Mh6Thz2qEfS5rZXgVuVG/EQXxNT6Li7dDm2PaW7eVz0PBybIxjc7tNxe3HyLnzSXR3gK/CkE3rzs9q9aZ5hO5EnsS2uxqS0g/czHPc43LGDLgtabvdD8wqlP4CrCbiQdbc0Q+c1WmVb5pgawj8UWVxVmdAeVB6wIuXnIE/A05JMlc91EKtwtu6JH/OH9mrP3kZ/wDcTc5/Ksoq8wAAAABJRU5ErkJggg==",
	["earth"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAESElEQVR42sWXS2hcVRjHf19mJpnY1orGCj6ojyLiA/EJsdJsRNqFtIssNBKpiiC0RESouhFbdeHCRSVK4kZXit2IitjQQkmRtgsR6jKoLeqixsTaRMxkXn8X/m88vcw0M4r0wOWee+73Ot/r/E/QZkjqAYoAEVHlXwxJvZ7WI6LZiibaMJYiopZ8jwBbgAZQWEVvRnM0Ij5sJzMbxVZWR0RV0gCw1cv7gBu6dMDD9iLAwYiYy2S3c1ck83WSxvTPaPjpdNRz9GOS1rXSdd7OJRU83y9pUf9tpAYsStpv1YUkN/4OgeNT9XwceBxYC1SBJlAGDgOvARuBHmA5l0MFx1/AXuBm4Jx51wJPSCpExG6gsZITknoklSXdKGlXYvWCXVnzc0jSXR1m/zOSTuZkZWOXdZUl9SCpz0yjSfyWc+5c8rsp6R4z96YlK6kkqZiEcUjST5ZXl1TxW5JGTdPXkxi+lLgyrdkmUErK9iCwJc3miGhGRC0i6hHR8No08AAwb5m1pISX0hyoSXoaeAqomKgMnAAmgA9Me9brA8Dr3kXJBk5GxLSkK5wnG0zfMM2y8wbPn5e0Hng/c+EBu6bq54SkYf97u4OKeM7u39RBdWThPZA2ol8TawH2RsSXduWYpAow4gwvAZfZUzL9XETUJS0APwNX2eWXAHOWXQbW2xMN61xxSyHXYs9rFBGxB7gDuBe4E5i28SU/dZNmISxZeRXYZp5Xk7Cv6Cu26eMvSXoU6HWMF4AjEfGxw/IyMAPsNt+YpO1WeqnXjgNvRsTX5vnhQnU7kYtPqzHt8iub56GkR6Sj4rVJ0xXNN5qjm2jlgSwks35vcMkUgR8jopK1U+CaVocZ0Of3gKSSj+K6pHqrzRfbfD9p938C9HutlLXPiGhIWq0h9juXiqYtdGIASTJNOcb7gMuB+YioSSp6l8dt6LKrYckZ37Sy02mzkvRLNwbcDhwB3gX22IDbJG2PiE+d9TN+0lzanHTSWyQNWoeAzUln7VnNgN8iQpJucv0CDAGDku4DzgBrXGYL9thO4L0OzqpGKwMaObiVopa6m0rWWA4DfzrGs8DWiFiU1OwCLWX6Viy5MjkwasALknZExPfA1UljyWg3ukJuTTbRtLFZts+4ez4IHHIYan4XLIeicduUy+pu/7wfeNHQ6Q3gWitaA+xIFM1mO7EBmTHfAO9ExEfGEMXEsCZwDJjK44HhpEmcTRrT9TnY9m2CD85Iui6HJyRpm9cGjSGUO9CGW+GB/iQ+2bwX+ErSkL9rRsqfJflRdMNJ6/y0pE3A5+4F2SHWyOniQpDs98T6k5KeTXje8vqpDOFKeiTh/ULS0QRFnWsLyTJQmggfT0JQsSGS9J2kEUk7JR3z2rwFPiZpssX58YdlZGEdTy8q3cDyRpeQvNYpLO/mYlLPXTyquZOwmSCqaqcXk/gfr2angFdWu5pd9MtpXOzr+V+LMY2lKNUXQwAAAABJRU5ErkJggg==",
	["keyboard"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAC2ElEQVR42uWXz4vNURjGP+/cO+YqTSHNLAYlCSsWNlMWKBt/gI2U0qwkKyuFUsqKhZ1SsqRsRyGRBYqdxkpcNZr86IZ7mZn7WHjOnTddYzAzprx1Ot+e8+N5znve95zzhX9sASCpClQWmXs6IqZYKh7oB5YvMnczIhpFwDngIDAJ9AJTQHueCXuAauK4EhHHq24cAgYW2QNDWBHAO6Dl7xrwAHhupe1UIgWrgGl/V8p2GpNXXMoksAkYTjzvsoCKidvABHA6Im7O53Il7QWuAqstqlL2BSsEGAd2A7cWwOW3PPd45iweaCdwLCKmJe0CDhm/5G1ZCZxw/cA4wGG79z1wxvWwcYDLEXFH0lhabDu754K+W13SRkkVSUc1Y8fcb0PC7qfx9xO+wdixhB31nBvNIUkXsgdIgdW0B14Dr4yXugk8AgaBx2ncY2Cd3dtMY8q4156zaY6OdRMwlfZsh78/Sep15O5z7HwxBnAKOGu3NoyPpvFfXE/9SsDMERnx4SdNE12wbn0ngY+/iszqLGmzInljG7DWOXzP9RCw3e1PgLpTeafrV8DTwhMRH2fL0RKELyUNJAGl/brbW5LWGxtJQTZibL37SNL1HxaDpAFzdIKw51/fhtXZ7mtJASwDzgM3HOENSTXgri8wgIfGGsAB36wvJPUBX9OR/VsCFBFyBN9zyTbmkq0FXOuyxfojAZJ6fHb3+rKJlEo96WKaTpdV1e1yJrz9MfXmKuCryUeBNfZEX5osupwhBS99J4C9FjEnAQH0Sar45KqlVPvTO78WEZJUsajoJkDppKpHRNvkn4GLQH96yczFSt8G8FlSLSJakurpbFEWUNJxGbBV0rOIaDmojszTe6ACbDFHh7MQl5UNAreBPQuQ8ns892DmrKYoLk+lNcBJSfvdHn+7eLt9s+duJc6OgFU+v4sNuyyE1RJnR0AdeLPIz/L6kvgxWTK/Zv/vz+k3IBKvGA7KzlgAAAAASUVORK5CYII=",
	["parentheses"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACt0lEQVR42u2Xu05bQRCGvzm2sYEg0lhcxDOkpkBCoo6Q6NKkzutAE/ICUJImJU/BA9CkoIgQlsAXHB//KfKfZHM4vhCihCIjWbueM/8/s5fZnQ2miKQA6kAUKmAUEfoT9sxwnkmq80SRVJeUTfoek0ARMXL/AHjh0QyATxExkFSLiNw2tYjIJbWA10DL3HcR8bHMOU/ULf9eSbrXT+lLWrfNYmK/6HbdNoXcm6Pl4B5IVjV6YOSRnAMLQO7Pt54JkpaS7tb93Nhzc42qlrRqbTJP1RBom/SLv7UTTFQsZWYbjJH/D82ZTQzAOxggJO0Ae0APGAPrQAc4BnreVOl6jqzr2aZjzNi6PXNGydeDqS/6Z8ka3kvqSDqqsp2APzLmPtlDZ9PwZYITg8aShpLeSVp5ROqtGDM0hySdVPnKrGgAuaRVScfANnDnKWsA1xFxK2lpDudLEXELXBsb5tqWdCxp1b4av6Sd280khXpOqTNJu06l2hwB1Gy7a2zfXIVspj4LUNPtmqTPknIbXyXBLT5iCRaT8+TKXLm511KfVWnYKOlbFXk/M4YStvDVmOccKB/Vy5VpM3sWAliedNzPGwC/e5sZM/Psz/jH8j+AeQKoP2ET1p8agIDuEzZhd1b6VgXw1bdYIYNp1dOMSmuQ6MbmrgygANSALev7wEvgVNLu91md7yi27S5wao6+Obfs44fPIoDca9YFPgCXrmhawAHQjogB0Jxj9E3bto1tmevS3F37yp/FdfysCpKiXGpK2pF0KKkraWSCG0nvXTNk6X0uqWHdqm1ujBmZ49CczYklWUK24HY/WYar5D7fmFKWbyR2V8n076fcs9Jw7ClacGUbpUp3PKUsH5cq6PD/BXOOn93DpD7lCh4BF5LelJ5mHdsME/ui3wHelp5mFxM33rN9nP7N5/k3VCluGFSqXGYAAAAASUVORK5CYII=",
	["person-standing"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACZElEQVR42t2Xv1tTURTHP+clsY221KUIDhYHQZxd7B7/BMGp4FIEN/GPcBe6uTp3Vee4uXTTQSIOkRKagpWYl+Trci4e4suPl75S9MAl9537vfd97/mZB5cstsomSQ0gm1JPzCznX5NVLbAFrE+pB2Z2emFMJdXD/EBSV9JXH11JB0XYRVJfkc8t4EaBrrTU59zYgFrESkrzY+AHkIKuARyHm0cswNjMVIqAbxgF1SiQawIbU1uaZjaaxi6SbEUXNJbUlc8CSTUzG0vaBZ4lEzo2EX4LfA4uGgN3gIepJgAK66/MrJ3OXuSCmh94F3g8g/g3J5AFAvfm4N8D7XD2XAIpWAaxyvnLhv78wse0pPUrYU88S2VioHHOWMmWiY+iGMjMbCJpB9h1K+VAC3gyBR/NsORr4J2/eAS0zayTzp7rggQwsw7QCcQ+Ak2/2Ri4DTzw5Q/AF/fxBHhpZp9mnb1s6c0kNdIoWG/pj7SKOmYYWelK6GwnK9YJKm/Nkup+m01JzyW1JeU+2q7bdEydqiW6QdKhm37gQ5IOi7CVlGJvTJJUk7Tt+T7y/ZnPh5K2JdUca1Xefs2D8qakI0k//eYTHwPXHTkmk7RWJYGrYT50k5+FLEjzYdGec7nAUyiXtCNpHzhxk9f9N85PJO17EcvnpV/p4JO0F26c62+Jur1lg7EMw/FFYMvk6y/gzMutvPymP6JPgfvuhrFjKyewAVwLzz0ze+OmfuR9ImIrJ9AHvoe+3gs+7gHd0F37lX+YSFoHtqJLzKzva9eBmPenZjb4vz7NPKcbRR+jBR+reanef5nyG95+3dZCanKBAAAAAElFTkSuQmCC",
	["server"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABoUlEQVR42u2XO0sDURCFv3GzYhRRFBFS2outjWV6CwVBtBP8AWIliIU/wMqgnSKI+A8sLbS3FwsRRHyAiI81HpvZcA02xiSbYgeWy95ld86cedyzkLEZgKR5YAqoAhGQAF9N9tUFxIGPUzM7KPjDGWC6zcGPAjUANx71J1AEHoCXlCE3/YNlAX3AEPAKFNwnKYDI6Yn9fgM4cjCJ09ZoSmLgA5gDtvybqc8agMTXe2ANODSzp2byLWnPgWw6E0kIoOrrs5lV/IVxYMIpPAOuAzr/5BvoNbNHoCJp1QFUQwBprmNJY8AVMAns+P6ime1Lis0saSB6k9QFlII0W9oamVqhrsITM7t01OfAQpoCST2ASYoaSEHRzN6Aa0lJ6DPsAoB+SctehBfARZMCfZc06J0w8FsXpHkZBraBbkmtasNw/0cXhINoHVhpwSAiGEQ/umCkbhAN+dUKKwY+awBOAiaigPZmWlR3GJ2QW6AHloByu1NgZrtpDZSB2QwIqAG4y0AP3OV6INcDuR7I9UBH6YFSBnqgFAI4Bm7b/XPaEcfxNwAB9UYl4N5ZAAAAAElFTkSuQmCC",
	["sparkles"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADXklEQVR42sWXTYtcRRSGn9PdN+nO5wRGRvOB4EIXgmBAsnUXdK0kClmIi8wi4A/wD2SRjYuACKOgCxHGlZgsBBGyDBnyDxJCnCQoZIbEmfF+zOvCt5Ly2p3uO07wwOWeW+dU1am3znnrFnQQSSGpeIa9kBRdxowOk/cjorH+AfA2UNlcAL9ExLfJ12P3bf8QOAWsAZeAR0BExNbMk/sZSnpP0i39W27ZNnQAef/vM7+CriJp5PeLkjY90Lqk0s+62zYlvWTfeUkLfr6x321Jr7ttvksAwyyAh55sI1tV0h9KOmHfs5Lu+FmzvXIQdyRdBBh0BQP4Azjcyp/IbKn9GHCi1X8AvGz9jZ0EkPrEhIQeAI2/V4CvrJ8CXnWAPzh5r+1kCxYk3c/2Wy39vqQF++7N+i/Zfi/lU5JehyB6LrdpUtg3r4RR9h5lpfp0C9xQTNj3kWv1rqQEcQ1sZTpAExF3U+WYlAL4AvgJ2ADC6Gw/2S5HPA2BOUmLzuhmDA80ti1KmpsRUUJSRIQkDYB5r/gfkDppzgCfZSuugXV/HzaaCdFPgO+yvnni1sDvEVFLipC0JyJKSe9kWVu3KkTAfuAgsOn9vQIs2v458K4hHTmwzVa15GN+FBFXJe1JNPuxpBVNl+1M/zGD84q6yYrn7A8iopF0GnjTh0SREUuSbbc3wFWv5kYqT+Bn13htdE6aiJShkMasPNfpiFhKK7hsmiwnRJyodnXGhP3S/uPGKz3X5U488LwkJcUL1h8Z5vYWJOiOAMuSauBGVhUXTLf5Fmy5XzNmCw56Tv7/JAT6EbEkaXVCGYaTsF2GZeJ94E+g7FCGn6YyzIloZCKilb2FB3v/PxBR+9R8QkRdTsQ5Sed3nYr98RbwmqHtZbXfMxo3I+KmfX8FjgKPsxXXwAFgNSKO2e9IOnzGzF+lH9wUzddTkua8pJ6kV2b4Hzhu3+EsyKbVllP8mojYzo7dZ0ll3048UHrwKvsnqFsQM+ak3DUi6llX6xQcjLnA1BMC0YwIsaNfsiyQ/ROYMrd1RqAx/NWElSoLICVXlfWvTEDDrte+hMBR7/0+vwsPmOsAvwHngNvAocx+yG3ngDX/X5ZdEFgGHhiJfosHAK7z921yw4dRMeFyuty+yO6qPI/r+V/LjxRwLLqiyAAAAABJRU5ErkJggg==",
	["star"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAD6UlEQVR42sWXT2hcVRTGvzOTSWJpTCmWliLZCIKLirXoypVgSrvIQuhGpNhdsVDoThBXIsVlN+2m0JCiG8HSjYUIoqAIohbsQiiILoppLGibppnJJDM/F/0unD7fZCYQ8MJl7pz/95zvnnuf9D+PGFUQaEhCUkvSO5JeltQzuynpZ0nzkjYkRUT0dzRSoJXWN/jvuFEnO2yMjeg8Hv/QlLRX0qqkrncrZ2UV2Cfpb8tGRLBTu58AGsBB4BawBrSBvmfbtFuWaQATO5n+6bTuOuUPgY7nQ9O6dTqjOglgrGaOm78HOA38BWzUYGDDvNPAHuuMD7AZ2w1uN3C24qwN3PVsV4I6C+zejoPmEP4FYKWk2c6uAQc8r5lWyrMCXBjF5xjQiogN4AVJH5jfM7L7PvvHJU1JWvH/aUkTEXG3gNQn6oF7y9OSTgLP+H/DJ6Zs9MOI+BVoCWgBrwDzbD36af0jcA7Y5XnOtDrZujFvn62SjgUzHjmNXaBXUeoAS6750QSyAtKj5i1ZNo9esvvItIXciNqpobSc5ipSv5F00vR/TNtI/K8lvWTdBUmzidewXrbZzgGUM9tJgXwp6SNJz1rul4hYziCKiF5ar0sqmHhP0qeSNiXdkfS+pDcccMf2pwsIm5IWJT0v6bBb7LqjXomIT3JH9C66xbke3zw9X1bjkoiIm5JuWuewba1bd8q8RaCpVMNjwD3XZy2B6Qgw6XrHiA1t3DpHEiCLzXvAsYKhotAAmsCLwHpqtUVhdtRbrsgAs2lDxda6fTTtM+qu2jngdlIA+Ak44zTXNq5Cs+Ez1sk2bgNzA6/s0re9PgV872NTol9MsmM1AYyl9WLaede2ThW5UvZBKdyVMlHGJnB1GwFctU4Zc9n2sAfJpn9zlM3URiWpWQPIRtKtyo9XbG8ZAMCkj8sTDkxXRHQGZG8yBZPHlHm9kZ5kEdEBlivkTnEMvCrpucqj9LeI+MH8aoDLttkaKQC/ZmYq5L3Afq/PS3q9wv8KeKvIVngztrm2FfgyiC4B99P9TnqALFUAloG6lB4opPfDfeBSna9Br+IZ9+p82Ux6qq6WHgcG0OsyumUAy740CpL7DqYv6SnTH0j6wvzj6UJrG4StBMaObY4cwJR3202oLs/sPx3A5xHxrlN6UdKbzszBanVta2pYD88YuO76rVZwsA4cAvb7I6TI7zPtUGq9pf6rXl/fqpGVr5/SKl8DriRDl4G3gRPVoKvGgBOWvZz0r9jmWPb1RAnyZ1REfAvccQmQ9HFE/J6ib0rqRcRmDe0z075z5wtJ5yPijxLA0E+2Ab1+3A/YGPIWaNVdNrVpl/QvMzlVKlxVPqkAAAAASUVORK5CYII=",
	["wind"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACXklEQVR42t2Xv4sTQRTHPy+7uctxhYrnD0SuEUSwUURsrURtrrBRUGuvEhtLsfFvEAtBmysEsVTsLK45EP0X1KCBi8SAkIub5GvzEsY1u9nE5aI+WN5k9k1m9jvfee87MGezooGSKkA1J2RgZgn/mk2DQA3YkxOyY2bt0lcoKXa/JumTpC+S6u4b3teQ9DA9pogVCay4P+pPlq2mFh7lcCYxs/5oAU6wStY2OfzvgefAlRB2IPGJmkF/ZGZdoJ9HajMbxABmNgAGGbE995vApqQt4CAQOSKxP6OvNbOuI3AA0BjeNc2sJ8lm4cSSpEVJN/SrbaTiLjg3Gs6ZevD7kscsDLfgJnDeIYvGzetbZA51ApzwLRj4u34w+TpwHTiU8R0PJB0BngwHvNKf2+tgAW8zYjqS2t5+Fp6Cd8DJgFAUPB2RcyQGPgTvtoDDjlwV+AHUgBWP7QPbo0QkaR+wPGMik/sd4Jv37wUWvb0AfAXWgKfB2Edmdmt4ClpAq8T8tZ0i5GXgqiNccd4kYR44BxwPCDWL9Yd/6rAveJ+A+8AxoONzLAP7Qw7cBq7tQu1Zcv8dqEuymPnYPeAxULUStyBvS6JULnlpZi3PlvMxSdUyjmHesewA7VT/CB2vPyMS3vXUOU0impSYXpjZ+lAfmFkvTw+cnlDrZ7HVaQTJBvA5pxgVLU4XAyI3d4tME8tznkQrIw+8CQQKAQeKa8IJkixtkUN/BrgDnM2QaEnhBUyQZOO0XFfSqZQ+xEtuzdsrZani325A7uv+xAF5LUDgY6kXk7/mojK3q9l/e1n9CeXBqR4hpg7jAAAAAElFTkSuQmCC",
	["settings"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAEFElEQVR42t2XT2hdRRTGf+e+f3naNtU+EdKGKkGqxUWF6k7ooiguXATEoi2UuojiVoNZSRGEii5cCUpx0U2huqmiUHAjUpDgoqugSIgSE7SU2jakSd6/z4XfwHjzXhvdBBwY7p1zzpwzc86Zb87ANrfYipCkGtAD7gfeAnYCXaBqkfS/ArwHXAcqEdH5TwuQVCnxGhGx6oW076KzHhEdSfcCG7naiOiVhasDV1USlFRIagITwDLQ8q7vscht67oGHJA0D3QiorvlWNhIzbss80LSMUlXJXUldbS5dcy7atkYFEr3YpMHIqIP9C34CnDUrAJ4FVgAHjBtA/ge+Mjj14EngYZlFoBdkj5OOoFvIuLTTSGQVEREX9IE8JTp08CjmdyCEyzFtAFci4jzXvCLpiX+UWASOJbpeELSmv9nI2JeUoGketp15s6euyS1B7h7RdJZSXX3s6aVW3uAPtnDSKoX2QrLGVqUvr1M5jQwA9TdZ0wry5V1bLaVeeC4Eykl09eSpgbsavIOiTw5QH7KurqZ/uPJdrWECfn4h4j4RNIjwEPOgT+AW5JeMBilmDbN/xM4Azxo/i/WsQ94bhD+VIdtBjgkaSwiprMd7gfmgcqQeT1gIiJ+zeaMAYesc9PRzGPTBzoZsDwDXJLUSu4FLt/BOOZdTmHy3EvWddsynexoUmSr2gnUsp00gIPAqKF5HNjrnawNML5m3l5g3HNGraORJV7NtgCiAHpGpjngS2Ddmd0DfgM2DM03snNeBxaBz9wXTUsgdcNzNqyjZ/66bczZZi/FaSSD3OUsg3+XNG7eqVJ2n8vifK7EO2X6uHWktpwgOtkstrseKCRVgbakp4GLwH12VXKhsrxI4x5wRNIFSReAI6bJMr3sNKXxunVftK22pGrVhUNX0kHgeU+8BYwA+4CGE2q3k0muCcbd8yQcscxuz2lYRwGsArts46uI+E5Srch2uJIdw4pXPgfcdEItAks+Nc0B3myatwQses5N69jIjm/Htv72UAbFJ7Jk6Uv6wiCSQ+1+Q+qw1jVY5XPGrKufyZ0YBMXlUu1KRCxLer8Exc86lsOg+DVJORRPS7qShXdoSSaXWWkBhyVNAW+W5sxGxOfDLiPfjDntZ+BwlqRk33/chidL9UDu1vRN/29Iakna4d4yrSzXHaLz5KAQlDG+7+ztm5fzTwOPuRQD+DCrfiolHZUc+8sy1czt3wIv+//trCSr+YpdMR1gB7AnItreyR7TElS/4xyYye6cH00HmE3viaqLUSJi3lctLsHzovQMcAB4N8P7lqSXPG6Z1kgFKPAT8HCpKD1fKv/7216Wb/XNUJfUlPS4pCVJG5JWM+Orpi1ZppmS+3/zNAu7bRT44C6P01FJ14H2v3qabVf7C/bWIBEGaxb9AAAAAElFTkSuQmCC",
	["shield"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADi0lEQVR42s2XP4hcVRTGf9+bmezGYV0lLguaIKJI2oA2KUyTGCtBrLS0sjFgoVhZWIkWEiySylTZLk2qVaws0miTxkK0EKI4qLDZ1WUyf95nkXOTy82bN2+CoBce790/3znnnXvOd88VHZvtCugDSJosWHMkPmeS6i5ytUThAPBdnbqTzb0JvATMYqgPfCNpJ1uzlrDAdJFB/QbFvVA4A3KlTwCvRPcj4JkC+nIYDbAr6Y9Cbh+wpHlXl/dtb9s+Hu8Lvt/mtmdZfxZjqV0osH1WbbbP2/4tnlu29wuFZcvH9gOT8OdbY8D2QNLU9ibwCbABPA2cLtaPgfX4/hH4MNuS5xrWpHYD+Bk4AN6XdDvpTAasSxrbfhL4ZYlzrgGTCLrLgX87gvII8PoS/FOSfk06kwFrku7Y3ga+A7aB/SzK01+NgBdTGtoeRFpOszT8NvC5J/rAo4F/QdIo6WwKDkf6fQW8G2M9YA7UOQckxVl/YvssUGUYgM+AN0J2expmi/YkjRqCUyG8Trkd6VcBc0m/N2D2CtmtBiRyGtpeLzxgYBIckf95DdS2FQSkwgPDRcTXlp9zSePECaXSxpSSnMgrx9heSD4V/3H7XxtQPRSFNlB6m542A6Zd9r1DXMyA6cMYMP8XPb1SECa3n7N9Kc6HeWK9jm4fBGbT9iXgXGvWRe4SR+eoOOVORH4fXcGAo4E5UcgaBd3f01m1MGEN3AIOIr+9SuwF5iBk1IuYsFqSIb04VFrLtxY2HYeMzlmQmGwe78eBHdtn7nrNvQ7u78XaM8BOyMhluskAZZx/PN6HcZy+BmwFLa9FqaamQypyfi3WbgV2PWTlsu/prLL9Js7/78PaYYxPgGO2NyQdSprF/j5wDsTcoe0N4Fhg65A1D9mzQud9621XtrdsfxlR+5ftse092xfzkt32oHiqbP5iYMYhwyFzK7APerEQcMr2lQCO4/2n7au2d2yfbNiCkzF3Ndbm2Cu2TzXpUkOx8Yikv10/D3wKvJqqoaiUAL4Avs76U+As8FbWT1l0HXhP0g+2h8Bh0xaWfzNMNZ7tm0XdP/HiNinuDTfTdS3J7MpkSm6KfdvNlExt1w3K65hLbdf2VhYzWvVu2AtGq22fBp4FNoHPl9j/DnAb+EnSjfgRLbqSaZkngEFeCdv+GHgsUizdhtP3nqQPitvytG3P1XFLeqnIXHa5XGUtwD9aP2c6gSZRnwAAAABJRU5ErkJggg==",
	["users"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADl0lEQVR42s2XsYtcVRTGf2fem5lMnI0xbKLRuFqlMxqIYEA7XZLCDdumEiuD/g8WIqSKVSBRIkgUtNJtFGIhWqUwhZ0QBDtdF42ETSY7O28+m3OXs9f3Zt4SCw889u58955z3n3nft+5xgyTZEAJWNMUYGJmapi/C9+TSepIKlvMKyUVc/BOE24Ni3pmNvbxKvAIMPG3I4zvmdmXKWGgC7wO7HPfmwHf8TnvjUxS4c8JSVtqti2fU/raJyWNavDkz9ok0PW/y5I2NN82JK34mqWw5kHAl6PvpsBF+PZvS7rlDqoZwRP2k6Tzkg5mO5bwW+6zE2PtqgFJpZlNfHwDeA24B+wHbgK/AqmYpsCzwEvAfa+RL4DzwAfAYeAp4JWAf2tmy3msXdUaxtclTcKbrNTs2ErAJ5I+y/BzGX69LlbT8Sj8SdarmdPL5ucF1p3hb8fKlrSwIGkYnG4DCzWkhKT9/mLDNo6bEqj8SVmvm9lmtsXr4d9p2gEzu+/4Ro2/1gns8+Byx0uSHg/bPgaWwpt30ueUtOhrnw544T5bJ5ACjfwUXATezTh+kM256+f8Gw9uGd6jhfAk7j4t6ZpX8PYMHkjYp5JekHRE0t3Aggm/5j7LGKtRPPzvcUlrLZhwTdJzvuaZjIoTfjw/fvPEaGhmm5J6wI/AEeBB+I5p/AdwyszGzm6PAd85EQGsAy86PswLuTYB/47mVTsFjmYFSRhXwG+hCDvAo44ZUJnZhidXADKz7UYtaKP/D2t5/5AKr5syk3Qu6H/RgqwmgTNGZvaVF9nA174K9H13Ns1sbVdM1/+OZzZP/+dZ2/6g9JiGFxqSzrbU//+iPzibuqQSqCS9CbwDLHrhRZF6C/jLiWQciGoMHAKuZJS8CLzn2vE1cMCxfsDfl3QU+KQ0s0rSGeCk638f+B74HfjbzK7OKarngYPAE67/I+AEsAJ87gke9tP0suMngTNm9nFycjnT/9XsdHQbniLMW53TH+T45agFuV4Pdo6JWaOSZTbI9L8zBy9iQ5LI4U/gAnBT0mBmExmIS9LA27YL7gNgK5z7YQ2+HZ1ccuG4HX4b7IFcBmF82319FH5bqMEvxR3o++c4IOmYd6/aG8GpI+mYV32Z6X8d3o8JdEMjUpnZdMZ9sPaG5WuqELjbBk9F+CHwgx/DO6HraWtp7h3gDafyXwI+qsF/5v9gFm4qxUNdp/99PZ/ml48Mr8ys+gdpgXr3CcqVUAAAAABJRU5ErkJggg==",
	["zap"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADZUlEQVR42r2Xy2ucZRTGf2cuTdKkbRamoWQjCAruLHTRQncSEPMPSKmFUHARqTv/gipiV9G4bhtwIZVsKi666NJFu7KFrqogbtS6aCeXab65PC76vOH168yQ+Tr0wMd5+S5zLs85zzkDFURSgwlJVDEeEV1JbwGfAwL2gSmgBVyNiJakZkR0JuUoksJ6WtJ5SZsaLEt+b4ZJiqRmdt6ysR1JhaSW9Z+SFpOjh/nd2jhwSar73LZuDrjGktoho5+NiCIiepI2gLN2Ii/GnmtBk079EesTktYyrPcGnHuSTk2kBlLR+Twn6YqNdEpF15f0XFJb0kNJC/5m6pUjT5hLWpe0PcSBwk5sSVqQVJPUyAMYJY0RmO/6/C3wMTAH7AFHga+AHeAqUDefbEfEE0N2BOiMcKITEb1xMO9lON/2s9OlTNyskulGjnlEKCIKSXPAJWAd6AIdM90D4KOI2JF0Jn1qfSxxgH+3O8Lus4h4LilyCJqSek7NF8Cq7xdO+x3gQkTs+H7LjmFj7wP3M4pXKdB+FvCnwI9Ao5FYLiIKnzeAi8Z8F5gFbgDfRMS/hqgDzGTEk/SxQ2Z+PvFQQ1LNht8EPgTWUqHY+M/AtYh4JGneZNMHHgO3snf7WUbkaAX8AywDbzszPRfwi/eyolt1MXXN7buS7r3qCHZL/uBWTXIpFXytRKW4reaAn4BzB4MgoltxX/gFWHHUuY2XeGDfmNeduneALyWddOq62f7Q9BxJ2G/YUBOYioinkt4FrgFnDM3RrADverp2DyhT0mVVl1VJkcH5nqTr2ciWpGcu8P+N99QeAE+Bv7O2qpV6OW+teX+bMtiOCAGFpDfMlMtmzlmn/0ZEfGZ6r6euK286iyOupey85aJKhfVJNrR+zZgzzY0rJreXBl3VQXWzBMFp0/PtbDz3fF6TdCKn+WFUXB+x0cjPioPUvZC+ofrAnbOSDawWsBkR35UHXKXdwP1c88hNEBSlTKSUb0taT4ENinxcB1KnLHjpaHsJ6Q9xYOKYz1ifyrDdG7KejcS8qgPT1icl/WG6bpd2hd9LfT47ycU0ObAo6S8bTg7sW39fBfNaBX86Ay48nvE+MfHVPNXA0hAq3vTftelxi+6wIzZR8rYHzPHsD2kAX0fEb2kKmpZfr1TdF/4D2KAxrs+uTCsAAAAASUVORK5CYII=",
	["flame"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADfklEQVR42rWXvYudRRSHn3Pv7t1PV4yJH0FMoUSCIggiZMvYKyksEoTYBVSwUVEU/wKLBLYRJNiIhdXabWEnFnY2YhFEERNlN8aN2ezez8ci55Xh9d69d7PXgWHedz7O/M6cc35nJriHos4AjVr3ICJ6/J9FDbU1TZlxgM0bETHI7+eBU0AvZTSAnyPimwpoRDhtzWfUpnpM3fC/Zb1moonKpBNbQBd4BNhI7eulp85GRPcgyk0KoBkRbeCa+hTQBG4msADmgK2Dbs4QTx5qe6CrnlAv5sY94AFgCVgEBJ5Rz6rLua45LfvPZnuhsHdX3VH/UHvqbvbfUY/k/IWpnEBR+qVJgC+A08CvwGz272at5kwVQC9rFb5XI+KndMwmsJ2+8Ll6MiJuq0tqTAtAHcwZ9TzwKXANuD8BnAXeV5+LiB0gDuUPFfOprxY+cCvbmzn2gXo7+3ay3VCPVo487iTqmzbV2axLSUQXhgD4M4lpUX23cNA7al/9vlBg6bDR8IR6Uf0rN+mrv6mP5/gR9Y0E0U8QquvqybEMWR6RuqqeU89ne7wSoF4vTuJ39aFSsLqmbuf4XrZX1NPVvKHmqAlZr/H8O+qy+ugQAA/nmpXK2dTLCaJd+MbQXDEqCjq1/4+AtyLiOrA3Yk03Iiqu+BB4L/lhcYTMfXPBXoZaJ2N8GXhdfRo4mompAbSThgGqVL0QEX+rvxTpvj8K+CgAzRwztWgDx4FzOX4LWAEeKxivUWbFBFrKax6GiOZq/yup1Q8FOw7+veXczYrdaVNxvXwNnAFupFN17kXIuPtAdWyfAN+mlt3s/zEiNtPulFewNMHsYQD0s1YArkTEd0NCdw7oVHfFSmZE7KpbQ+RNbIL53NysLyTTVRTdUmciol1pXpFLbn4fcKJY30yZY+/6dSJqZ91WLxdsuFjkiqoujCCi9kSX1kqD1HJVvZSZrVdlPnVtgpyxlnPNtTspa7UAGCPfBWorIjrqS8B6HuGNIq7fzP+5wvNbyRUPAhXIrfwP4OWI+KqSPc4JB3lELWATOFZs3is22O+yMlOs2QRaKXMwaeqdz/psYUPVjuNLOaedMubV+YmfZunhvfx+JY/7ReC1CfnlsySqdkR8WZc50dsw3wONAsiTwNtFXDeHcEfV93FEXC08flDjiskep+mtM3fDOw5EtXkVE+jt91D9B4tKoNfhd53YAAAAAElFTkSuQmCC",
	["swords"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAET0lEQVR42rWXS2hdVRSG/3Xvzb15i31QA06cFOygIB1kUGkHIhYRnSgIlkI7qVUH4qC0jpyIFUQUNToqgghqUIuoEE0HVpwIiqnWgghWlIKBos079/U5+XfZOT25aSpu2Jx9ztrrX3uv9wl5ABVJNa0/uhHR1g0MoCap0mNLOyK62uwA6kD0oAdQ3wxmAJWI6AJ3SNrr7y3foCqp6+fPEfGdNRUR0SkIr0rCWHsk7ZLUMU7HOH3e/k1E/AZUlE4MHKH3mAK2J3PlmvDNK15v995e40jSaG6nzgbaukfSNFC3/QYz2qBvXpc07b29xjVZ+QFWJLU9D0s67u9NSXM2w25Jk8DOiFgEhoA+r3dKmvSeqnmaxjhuzIS/UnaAFAU1SQ1J5yRNSKpLGpW0YOYHJZ0A9kTEoqQqsE/SCdPa3jtq3gljNTL8yhrP9vNgwU7vAIPA18AK0PFcNP0ssNW8H/vbQrZvxbyDxsrHwTIf6Nr7UxQ8ImlK0n1WbcWq67cN90v63PsvpftIWvbeSfNOGSvH7uYaaPh51KdrAVez004A48Czfu8Acxn9A+DHwg2fMc9E9u2qsQGOXpMN1IAqsBc4kzHMWRgWXgRcAtrZ+0XgNR/oIeDkOgc+Y1lVZ8w1WqgDMwZuF2zeyyfawIdORmU+kfBmMp9rFFNoeL0tSySLGzhVoi97fc4YL5s+70OkRLatKG9NKs2y2V3A6cwn5jfwicWM/hHwU8En3gXGsyxa7VVMhrzeBXz2H3ziAvCK563GHOpVzK7LDV5/CzRL8kAvn+gA7wMN+9VYyhk3U4JrN+ETyQEvAb8Cl4E3C/2ClDcgQDWVWOBJSfucWGYlnZL0laTnnUQWJY1IulvSS5Jel3TR9FRshjzTGCu7YN4B5bZ5QNKB7P1PSWcl3S7pmIXPW8AxSX+YPibpkL83s+w6cqNtVFq/VxJGuc2X1/GJUeB3vy/72QT+Wc8E6x3gUzOvAt0Sm79dYvNlC29lgjH/U8DWUsEFZ+sHhoE7gefMTCHO3wDuB17Ivq2WdD2tbJ1ywKhlVK7rByKiHRErEbEgackOiMl11/hVSU+YfkrSJ66QVds8b2rIquxhYDwi5ixjTTVMKXgY2OE5XVBjcTye3ehylojKRjNLxQl/OMnO/wUOSJqR9IPDK0VJq4fvpt6g5VnsK1sZ/n5jz2QRVqtl4TciaUfG3LTq+ySdlvSF39uSvrfmBhyaylrupyX95VB+LMNqSLotkyVJUZYHln3yhu3+paQXI+KXEsf9W9Jbkm4x/5WIeNW0C+6c7/Xh5vwcWJNzgD4XoYeB2YIHXwEGMnv3pf09oqkKjHo9YIwcc9ayAuhLFbDh8NhdCKklYEsC20T9SIfeUnDOVcvot8yoRQRA23XgPPCopGGH0Yqkpm/c3CiDpnA2T8U8h+ysIWkhIs5ntYei6mr6n0fqQcsKUMoJeWTgX2luUtiGeP8CMaTh5FRdKeEAAAAASUVORK5CYII=",
	["palette"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAEQElEQVR42rWXS2idRRTHf//7SG76SCJNW0uq+ABBF6ItXVShG6FVN0pxIb7AuJJi0V1dKCKKbisWXehKEXRnVawLS3FRBZFuBFcWtJW0msam1Zjc+937d9EzcfJ5vyY34oGPOTPfzJnzPmdEBdiuAQ0ASW3WALaHAi0k9frtUcXBpqRONn8E2AN0gfoK96Y9X0n6oIpmgkY/riW1bU8A98byy8CNAypgb2gR4JikmUS7Sl3K8I22D/of6NouvHoo4kyCg7Y39rtrmeS264Eftn25xMCg0Mvwy7YPB+165htXTBD2aQf+JvAosAFYBBaAMeAn4KXwmy7QAXrAdMk3tgKvALcAF4EaMAo8Ybsm6Rmga3udpHls12y3bN9k+0DG9VyGn7B9f4Xpdtq+2/Ye2ztjbcr2qex8O8MP2L4maQPbwzF5PLPfQqbC87b32x4LJq+zvcV20/b1Jd8obN8c9B6wfc72dJhg0XYn9j0XfjZUy4T5K8Z64AIuAbuAO4Hvga+Bb4F7IqQMzGY0ZoE/Az8B3BFnj4UpnEXVC0CnAXRsPwVMhb3rwDjwI/CspJ9t3wBszy4azZjdnK1vBmS7dSV/6VxoYyT8bQFoh39tl+SGpJ7tfcBd4VgA3wDvSvo0TLSlT7IhpH07nBRgDpiXtBCXJfgMmAB2BiMd4EKeiH4Los2YvybpaIRLO7RxPiM4k1Qu6ek+jjkGtGLalPSW7TPAJ9m2Zs5AvZRih7IwNfAi8CpQZJIiqVuRBV8HHkyp3vZ9SeIVU3HA+rhgviRxvzBsZLQKSQWwDbg22zaemXdVDFy0vRnYl5nmLHAyq25FMFkEI0v4IFDFwK/AbcB72drHko6XpK6C6cxnFBmx1W9jrYJALbN3OU/0hZL0hyL+dwG7JZ0CNg2igS4wUlobL/cRUdWGYu40SppLjpqyLHAg/CDt7VyNgfEoPh9GwSGz/1IekOQoWP2ccxLYG5c9H8WpE2G9LmmkioFRST8AD1eou5e1bZtKpmzGRfuBN2KtFyZtxvcHcNa2GplEeUldTNWqX6zbHpa0GJcfjxS8AAzHRU6hnI5k6q9HXnlnKfHZ/igrm23bJ21Pxb+W7XWljmkkxm1raFaWleNGqPELYBLYERzuBjbZnpF0NOtw25lESXNno1Z0Yv55aGMoM0075rOSjgS9pYYk9QMPZVz+HuOi7dujjaonLUS1w/bWqPkJptO/q2TOetasLnOekVIIOrj+Mup/Fxix3QSaaexzR6uy8Yz6seyNsEJLlrqi72w/WSHRL9mZc7YnbTdsb4hx2fevRBT9QFfSaeCI7VujKR3PmtIdwCHbqVNqZc3q+lIEFZIK28VAteE/tuXzmQa25n4yCANrfZi0bV+K8cyaGSg/KG1P2H4svtMDxPlknisGLsfxLmxKmgHeD2K9FR6nnYiIS8Dl5AurYUD/5/N8NfA3yKaOzr5tQgIAAAAASUVORK5CYII=",
	["sun"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADb0lEQVR42s2XP2ybZRDGf+fEbpNYrRpZaoU6MXSohJDoUpGpC2OXLixVSqVsTGwMFYKtA5QhCwJEu3RIBwRLFRg6laVKVcTG0I0qkSJLCJtQ/3tYnjdcvtqOWTAnvfo+f3f33Pne+/O+MGeKcR8lLQILgIB+RCjxFiJiKOkSsOHPX0bETuEl2QDqtjOMiMGxHtl4/l0zUPnd8POm/qGbmVeMS6pNwwZ45UNEDCQ1gSYwiIj9AuhIlGj8DvTSO4WXZSW1bKcTEZ2qvdoE724Bz4CH6V8t/4utXU4ReWisWxMjIWnRoT4l6XNJeym830m6YLl62oL1JLNeDEqq+/2CdQvtGfuUbS1mB076eT4p7Eoa+P1rSZftwEk/1yRtea1VeJetI2PsJtzz2SbJ85DUkvRUUk/S0KtTIjFr/NM/7yScnrFbttXIOdB32bWBd4BH5h04sQT0xmXxhCrqJb0DYz0ydtu2+odVEBGSNIqIEbAv6UPgN+C9hN11hXwGvAa8BJbMOwBOAC8i4gNJXdd+0/xvgM1UUZTeEhXvA1iOiK4T72N73wZ+AbrA3WOCcANYAd4AVoER8FFE/CppBfgzN7aq8YkNQ9JGSqq+XqV+StqNaQ0u2zpsr87esg7Lyfw7ktqandqS7iT9Q8y0FnIODIHhBK8FXATOOLkawCbwU+qkA+Bt4H3LnAEu2khERH/Sfi3a0CXgde9XqY4XEfHY/D1nbemK30fEjxVn9+1Aw7J7ZTBJWnPiZvznEbFTlO+PCeN2At+q8K47pE2vhr9l2kr622Pw7x+ZBfOisoefAt9WtyDJ/eWwlsTcjYhemoZI2k3yfesU+gT4qroFOQl3gJ0pSXjWxksSXk1jNichSeZsSsLHx7XPuZXh3BvR3Ftx9qrmYdSV9JZr+t0EfC8ibkh685hhdE/SXWA96R5I2oyIpxVbRw6Q5VTUSnXbkfSHpJGkB7OOY8uOrFvOE9vGrlkmch+ouxWvAj8AVxy6JW9TAI1ZjtWWaSS9JWNdMfaqbdX/V0ey+R5Kx5TJbXv9JBlcKU74eU3SS69rFd5KcuiJsW5PK/OqM01J59ztjtTujA7kntIyVnPaLDgSCd9gOqVkAKXaLeCn03g+nXk+Y4bb8H4FezDL1Wzi5TQdXH4GvkjvmVecKLej2S+n/zX9DZ84WAprnDtFAAAAAElFTkSuQmCC",
	["moon"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADdUlEQVR42r2XvYtcZRTGf2fmzsy6a0g2a1zZ3hVFU2iaELARIoIgpIiNIAgSQdJb+19YpRGLBIILaQKaIgQCIRZZAqKVlV8T88Ga2dmde+ex8Hnj63XnYyeznurO3Pc9n895zrnBFCKpABpjjpQRMWTeIikktTlAiRGGG0CRIpN0AngZqLJMDLPnGxHxk6TG3DMh6ZikqxovH/psa7/6iwnG28A3wCsT9FSzBljU0i6gDXwKvAEsAMd95JF/d/y7n90vn9qBrOY7kt4E3ssMLQCH/fsi8BqwDjTHYWkaaSS0AwMD7hgwAHaAbRu/B/wK3IqI94ErmfGnkpSBtiNPNV+3E8/6/eeOPNV6dV4gb5hkSkmnbOS4oy6A34FPgC8j4reIuCepCTwzLwcKoOnoX3XdS2ALWPa7L1ym54FHPjuo6WnasZkwID9vOe2FO6EP/CBpzR3yOCJ2RoCuHxHVLGAsas4kIlkEvgbOAff9brfW91UGxPSuJUlT2K0SYxZjKPphRHSzYZQrXrXxP80Ln0laiYgL82TCJUmdLDplhLUBrACv+/1JYEXStp1v7sGOykp0M82ORLdI+qDG71/VxjE530s6Lanrs7van3yUqL4xA3BLI/5b4C1noAU83oeO6l9MOEKakjpmyX/AESG3ZxURm8BZ4EdgaYLRbbd4mc+OcRh40nZ1YEfErks3jIgNSUeB01kbyzgogT+At4EXs4BjkgMCjngu3E/zwtE/cSJhwui/MGKkt9w16yOHUbbhJIbrAe8A13x5aHL6b79GDMbsE0eBm8C71oltDHMHUjoOGUylgbUAvBQRP5s0FiW165iwoaakQlJL0qIzB/DQrbpknaVtHEr+N4DKqL7r/i48B/rAA0nnJC1HxAOnPWwsGS1qDNeLiK6kZeBjoGtdy9a9Ady1zSpF0El9KemOpG1JW1nfnpe0Kmltih1yzWfPZ/e3rPNOxjud+vod2RJ6SVJfUs8KupJ+kbQ5bk13AJs+m0iqZ12XUmlye0XqbV8unb5Wbfd7zs8vABcl9Wp0m54Xva6R3U27Q8u6G0CRuiivX/m3c+oA181sC8CZbCntZLviKOl7nTvs+5f933fZbJluic0wMdD+ZZDX/KA/TPaSq1k7Hsin2SgZGhPfR8Ttuq7/9eN0FHFNzMAMn+d7ZiIiJoLtL1JDHFGX2fgyAAAAAElFTkSuQmCC",
	["folder"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACMElEQVR42u2XPWtUQRiFn7PfSUwKIZLOQgT1Dwi28aO0FGystFG0trKytLC1M7/BRhT/gBAwFkqwsNhGBFGjJmb33mPzThgvq+5NNlmLvDDscO/Oe86c9+POCMB2E2gyvg0llUzTbLcn4Ufh7CxwEiiBBlAArmICCfSJpM+2O5K2J7GbFdez27bns/XaLXYrfuvu4j5wArgT+dOxPazpo5RU5ASGIX8DeAQ8AzrZ+4vAdeA7cAS4Zrsp6RawuVcF0vwH8BR4IGm9EqY14BhwOQDngZu2XwOfguzflEybS3n2TtLL5PxhxPa97V48W7DdjjEfzzq2X9kuYuzFVhKralX0Yj6QNJA0AL7ZbkTGnweej1hb17arIUgE5mx/yctQkm03gsRH23eBx1Gu5RhhHgAXgBvx//JPBFKXs/17G5BU2JbtrqRVYLVmqa8Bi8AlYHZUEv67a0kGfkbp1QnBjKR121eBt8DxUKUegVyNkH/c3SecXuq+eWkc0KfDAuamRSCFbziqOUzVDgkcEvjvCAjoRqebdCNoAt1qH2hl5z2iTvuSStuztgfVBbvBBtqStmz3s17gnEBSogOcsf1G0sYEBdgIBU5np6xGDpxOu0vAC2B5H8K9HL6XcsykQAFsxXwRuGf7SlxWygnkWQGcCt9bGeYOgaPZSQjgXIz9sF6GuUOgD3yIb3Q7EqXch4prZRj9/Ga0AMwccAvYlPR12n1oR4FWzdvxJKyQNJy6Ar8AH2lnCOrj+n0AAAAASUVORK5CYII=",
	["info"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADOUlEQVR42sVXPWgUURD+5nbvcnckKP5UNmphmUIIqIUggWCVKpUhQgiYIpJaG0Ub64B1rFRIZypTBEGQFGKvNqbQKgYNgexl7/Y+C7895za3ubvEcAPLvn1v/nZm3rzvGXKIZAFACABmFuMIRLKkYcPMmp14LEewaGZ1930HwE0ACYCgi92U572ZvcrTmVLYyWszi0meA3Bb008BXOozABOKIgC8NbOfqe68cJkbj5Bc5D9KSDbYOzUkk9IiyZFOttr+nGSg8RLJ3YwD/ZKX2SW5JN2Bq42/KVB+Yo2fA5gGMAxgH0ANwCkAXwE8Vt0EyrWndI4AngC4AmAHQFm67pIMzOw+gKRVEyQLJMskL5NccF7vkGxq/InkbB/VPysZSseO07sgW2WSBZAcktCMy1/NGd8iOSGeKsminsAZDNx8VXMTkk2dqLk6mhHPUME5HrlQRgp1DGAcwLoMRmZW19NKgZkl6TyASLzrko2lK3JbOGprOCTnSH4gGZGM5eUXkpPZpuIKdYzksp6xzFrJyU1KF6U7kq251jYlueIYYpIbac5JhhmFqSPzLq/zHQyXSIauJjacfpJc8Y1oSxVc1PczM1slWTWzvUyNpS31B4DvbuzX4HZV1cxekNwG8MZ1yy3vQJBpsa0entNqoRxf13g7s+apkdHZZi/M2Ull5ZMHDg8z6h25CLStHdyVDNQP0PUsSP/EzBLXy9uK1syaJC8CuKXpd2a2ma51cDohmfTjwGEUKNc3ACxrbhrAplvrmQo4OiU5474oPKYDjZNyIPCtNofMyVuXsyHIAzJ5Kaip1RqOTyZdtcMcSDJhjHtIURNAXU+zhyjHmfQlfvG8QpRitockz6qDhQAKDkqlURl2nXM4mwq15aaZ7amt33P6i7KJUHt9DcAFAFflyDUAZ0hum9mqx4ouUp8BvHbjVjF67KcD7YEASl08HwGsZfHAlDtcfum9T3JU533QEct1wJaOf1Q6vE6SnOqEByruLypqw6X0XFchVboBEgAV8Y5LtiRdFRe9ShYPDAySWfbS4EDp6f8ISocA/AbwUqD04EVlULB84BcTO8Gr2TcAj7pdzQZ+ObVBX8//AMeboT13eqU7AAAAAElFTkSuQmCC",
	["lock"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACu0lEQVR42u2XsWsUURDGf3O3p17ARNDLVTYKEVJKwEbsxDZ9CsEmYJHSwj/AwtJCsBFCerUNYiHYiCSNaSwU7JIiRTguXu727rOZDZN1c7drTm0cWN7ue9/MfG/ezLw7KCGSEipKWR2bYMSAppkdSroOPAIEDIF6Dp7NGfDUzL5KmgF+mJn4jR3UwvuSpA2Vlw1JS0W2yjo3SYmkmqSWpE033JV0NMbxkWPkOi23kXg0SxM472NL0mdJqaShP/0xBPoBl7puK9rMy2mJUgvri/59AMz5+0vgLXDOcX3gLvDAvzPsYvBRqxKBCz7OS/ruu+lK6kh6JWmhQGfB1zqOTV13PtqsSqAtaTeEeF9S09dmJTX8mfW5pmMy2ZXUHkegVrE4mv4ADMxsYGYDYFCwXkrKEEh9fA+sAH1vMv1AiXMrjo26kwmE0kuA4xEYOWTHzF4D3SyxAj5L2K5jdnxuFG1l+FiSx1Xg3Sp1w10zk6Sud74svBmuV7CZYe6ocN2umaWZzVJHEIC9QGBQ4WgHgUAvZ/OkL0mJM7wNPCzo7feAGeAb8DEQHxVsJpu7BVwDDoHNgrvjuZl9kJTErreqvyerWXdMQog7IXTm7/ueJ+a7S0seQeIRyfLqMtDI+QI4cWfXHJTJO+B+MJhW7BlRZ92P8pfcS07J4mfAupntMQWR9Bj4AqzlfUUCMUvfmNm2pIt+FJr046XIr+s03NZcIKBJt2FbUh3oeas9y+6HbqtdpRUPzWzIlMRtDadxGU1d/hM4jUDdE4cplWG94Gf82CrYM7OhpBlXPmsZdiTtTSIQHSxLOjCz7SkEoCfpJrBc5CsSiCFaA25ImlYrfpJrxfUiAqPcZXQH+BS+q/69ijpXnIyCr2MCWTgu5S6jBLj6h5L/UkYyCR1qC3iRYziYksNGruq2Ci7AfyM/AWYXstpkBYy+AAAAAElFTkSuQmCC",
	["play"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADJElEQVR42s2Xv4tdRRTHP+ft2/dW15hEsmwQC7EKgbWySCFYKJjOQlyIhaVg4Z8gRFs7IWnEFCopDIFYKBFN0C6VJBHEUgVRNxKFrO6+X/ux8AwMl3373u57JB643Jm5586c+Z7vOXMm2EXUNtBivAwjYoc5SBz0R7ULCAwiwpkNUKNMpD4LPAnsVEjU7c8j4m7qtgBnMaKGvbQ/dW95Uz2uPl5vYJ4GXJpgwB31N/W22sl/DtVzTCvjiNYDhkB/l2/bwDFgFVgDPlFPRMS9iBiqbXVpWmPGKZnf7gGf5aICy8BLqXO36m+o15OQl9P4GtXRRI40XPBBQv1julSNd9Rb6qByR79q99Q1dVVdmcUFUb2XioER0QdeAK41dEtO6ABXgZvAW5XhLXVhPy6oJ19WN4GH1c2IuKOeBT4EDgPnK/0toETGGfVYzvF2RPygPlK4VRLZNEQZJrl6/23GbkTcAG7k7tbSkKeAU8mXfhL1TM7xj3ouIr6dlgMX0qc/q6s5VnNhQV2sYVVfVDca4dpTN7P9RXJjNZFAjdaB0mfEKCIGETGqhq8lP5qhu5jv55Ibt4DThQLtWQ+TRGExIraB2+qrQDcXfL1S7QLHs32kBMHMBiQKozQkMg+g3gSOptozwBNAQezvYn+LOUllyKLaiYjvI2I9ItaBr9MVS/ksTMoD903a85qocsEg+yeBs5ULBpULRnMzoEFC1JcrEr4yJiKWi+fmScI2cBK4mCmZKiQ7ecL+mZnxr1LktGfYdQvYqXLB88BH1eJFBjn2DfBaIwqG7f2tawCdiOgVP6rnq1S8UqXiR3PhDnABOBcRvzfQm6poaCe83Tzve+qpXPAw8EbjMHooQ+0P4MuE/N1xh9Gks+An9Uj9XV1Rr1b5fqCOqv4v6q/qe7Mcx1bv7YRrmPXfV0m2WrdVke40sFHVCOx1hxhnQCHSY8BFtS7Jnm6UZF3gfaCUZN/tguq+S7KPE9reLhXxVqN/RT1RzzOPorS7x7dCsFFCvR4RffUQsBURw1KUzmJAZ8J/7wCXgFbWiQCbB7kdPfCr2f/ncvqgruf/Ape7qK7WgVuLAAAAAElFTkSuQmCC",
	["activity"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAC90lEQVR42s2Xv1scVxDHP7O7Z87IIWqMwREIGdy4cRHyH5gUadwGNyFJI1y4cZsibQJ2K2EQGBcubdK4cCdSBeMiTVIEoiRIYONGJOhHtLv3TeHvE4/z3kk6rXAGhp2dN2/fvPm98J4hJi1IKiJiZPpr4BOg9XIJvIiItXHZ3kDSwM9K0rrehXVJVS47CxTTdACIiAbYAGpgx1gDG147lJ0FqhPIDoBRRp8dSBpICkkfSlqR9IekA0mt8cC8FcvEadzQpcB5Py9nPt+dQF/O9/QVA8mnLbBp08dY9oy81p4mDoppaWhfDybIHa5bttcgDOf1pqR0wwbYz2iANiI2rXD0YgHfRpKuSFoG5mzuC8DQeMG8OUnLkhaB5jSWyBU45+etLNBqSfuSXhn3zUvwxawFqfDG0qk3yHJ8b8xVz4Hrxufj7pNUjlsyfXMClocxEBFtFs21pK+AL+3zyhH+JiJe++Pb2VktsBURbfqopEFE1Fnhmh6Ekj4GrrrEFsBd4Jqt8K/jYFHS0PuGPjiMNyXtAj/5QrWkeeAzK5/SuDVdAL9HxMtkrseaDn9LepCZ94n5+0ZJ+iFbn5d054hvPj5JL/gGeJS9lx0ybUZ/D3x+kjpwD3iamae06Qqb7llEbGfB9h3wF3A7O7zJXHQF+MCdswDOA78A3/qMAfDbrPNBStMbkprMpI8y2TU3rFrSnqQfHdgTg7A8YjZoHdUWVwl8NOaKeUmXTF/M0rkC7kfEU0lzwIH5o4hou9Lw6DnubcrlrAb4FPg5KWNecnHqlHV2kZkrZSowiy7D254RxqH12rLL+rCXUj3e+yVt+cB/7O8905K01bXnuDPhETqokLSQxUGVNatk+lLSQmpwfSqA23Vt7Cq5h+vTRvZq1vOzgrTQMRGlGpJbKPq0QOMBZAdYBf70ZUbGyrxVYMeyTd+Tc5XRDzt6w8Mu2b5c0AV1dstjW/Y0CkR2u6VsgE2wJKny31OchQJt+nVzH/i14+e16eiU/y/4D7+m3JN036cOAAAAAElFTkSuQmCC",
	["globe"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADc0lEQVR42s2Xz2ucZRDHP5Ndt6a0IQcLQVEQLz0LFqVEekmJRHuqgkJPzVGaq71I8eI52EMOOVsaetFWtBcRIRT0XxA8CDZYwdbUJvvubr4e/D7p5PHdlgplHVj2eef3MzPPPPMEY0DSFNAFiIiG/wCSel4OI2KvjSfGCD4TEYP0/QHwJjACOo+xW3i+j4jPx+ks0G3zOiIaSc8Bi0Z/Arz8hAE47SgCfBMRvxfd48IVaX1U0gU9hJGkvqSm+vUfgR8l+QuSjrbZOrBzSR2vVyVtVw4MdBBGyYFRRRtUuG1Jq9bdSbXxMD9pfVnSHxbcrRx5Uti2Dlnn5dpmOE894HngLaAw/QnMeH0DeAC8lwrtF+CWv98AXkwFugEcBt5u0fUh8DXwK9Ag6ZA9OmdPh/Z6z99bkl6TdMq4gr+adnPVuEI/ZZmthN+1bkk6Z7lDUykTO/7veB32/ASwBFwBBv7hHVKtC/2KZU5YR1hnp7L1T8ORdF7SpqQdV7Ek/SRpyTzXUnSGkj6TNC/pWf/mjRumXV6z7JJ1ybp3bOv8/jGVtJEYGkm3JC2XMDnE/VRcC4lWUriQ6H3LFNqydTZpgxu5Ed1xYZXT8GlEfOlKbYChC7XAnKQuIBvoAnOJ3rNM4w64Luk34ItUxHeyA52qxR5Orbo7pv1OJYcHLfSOZaOlZvbtdce00bv5EpJ0v6JvmdakWtqqeO5Xvf9um6HagT3vbDG3TuB4xbckaTbJD4GTFc9xSe+m75OVjQOdcC0V4dOGYmONf3kyAei2FA7AKrCZ8CtViAu9TsFK4tk0X07BSmtBpxQUWKzo6xV9oUXHQsWzXtEXK/rao07BbBqpBByp6HOm5WM4V/EccR8Jn5hZxpzl0hhGCf+gOO7wjlpk91Lv3xszmg1Ls0o6D9grDhxzborCi5KWfY57jlRT9YGhm0x4nftAY5leRAzc1i8m/R3bpOsL4SbwAvCqia8DxyTdjoivPCn1UiTOSNoFfnSq5oEzid4DOhHR94X2EfCKjY8sd1PSVJ4HzqYCKRPRPUkvSbok6XYawSTpeiqw6+kS6pv3kmXvVTol6Wy5zHIRTqf8TDt3M8APwDvAd8C3LXWS16Uo3wf+suyMdU2nkX16/10w8ZFs0kPp/2Msn+TDJJ7i0+xn4OPHPc0m/jiNST/P/wa2abn6Wm5bVgAAAABJRU5ErkJggg==",
	["code"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACFklEQVR42u2WvU4bURCFz9jGsWMkaBDwEnkJEJIb0qVIBxVSpLwLTeRnoEuVBl4hBV3alNkChGNiG5uP5lxysxg7VqLYEUwzd3dnzp3/HemZnjrFLAFg5ReFiJu/KT8NqArU/tRDoAZU54oAUI+Ioc+vJbUkIakv6VNE9IFqRIyTsRExBhqS2pIaxu5FxMcy5iyLw95XgVfAgJ/0A9iyXDPTaZpvWSbRwBgJ74HDlQk2NO3ZjqQzSXVJI3/rOhLKuErvuj6PrHsmaceYzWme11POgQPgs724BYrMq+0pEdjO5ArrYqyDrCbqj1YusA98seJ3oO/zBfABWAMqJZ0Vv1uzzIV1+sbAmPsP7nTOKxNy3s286QLHeWVPqvbsfDxBv1wTFSCUwgG0s1Df2vqRn98Dq3O03qp1MEY/S0cBtFPaU78flnJ+nVn/Dli/V5h9eXJo3bqJrks1cXg/H4ATf7iyxQPgK9DJgFtzRKCVnTvGGhj7yned5G1YuG1eZO1zGhFHjlA9Inq/Pd8jeu6qakQcSTrN2jndUTw2B/4pJQM2JNUkDcyHknaBTkSMI2I4bwoiYujx3JG0a8z8jo38p7O4IlyGNlzsIFr4KF6Kn1HJkJfme9nFN+bfgE1/b2Q6DfNNy+Q6BbCXYy/VQlKbMMXwBBtKOgfelFayS4vm61U6X0p6W1rJzrOVbPx/LKVLsZY/05OhO+XityiPGvPHAAAAAElFTkSuQmCC",
	["database"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAACzElEQVR42sWXv1sUURDHP7O3Xi7+IlyMQSRgIWJjIUT/Ae2MWFmJKHZaWaSxERTsbASxtrBSsFACBhSxE61txDJEYiQJQWNu78fXwtnwWG/vbrOnGVj217z5zvvOzHvzjEAkGRADZmYJQxRJVUBAy8yUfrdAoeLALX8/Csz67zZQKYgZjrlvZl/cbgzIzNr4bJFUST9IugiMAGeAq0MiYETSG6BhZs9CTHPaq87GMeCjvwM0gV0lwUMbCXAK+OzhSCJnIQFmgNcBOEMAz9qoOsaMY8YxEJmZJI0BE+7ZD2CP328D626oWQC0CewH7gJ7gZ9+nwDGHDOKHRBXaLiXAiJg3cwelMz+WXckxWk4FoDiQLfiyUeQvTVJJ4Hv/q8xaNK57gGgFtg0/7dVUXGOgQhoAXVgHuj4YA3ogAUs1t1W1E0xz4HRIGsnSiZh4mGN82a6Fa7geQ54l6mI7UrVbc11w4ozK1cqt5y2t/7e6sFWnoRjrvvzuSxWntEjZvZS0nSB0sstSTNbkHS+SA6MS6qa2cIQN6LxIg4spruhpFEvG4WbVz9M122b2S8zSyQtFnFgStKkr5JfS87+kJfxVD8Hwuc7wD3gm6Tp7fYGTv08cNCT8i+sPAYO+30SeCppw8PQHhA71d0NnOil2K+0NoELJXNwM1iOey5EoSwBa70GFpCa21rqx0AYoytO3/MhdUTXgA3gVRYrLwTr3jhc9lh2erCVJ+mYCvACOF0kB44DH8zsyZAWoorbHNiBVTNrewdrwfZadCGSd8AtSatFkrDJnx69VaAH6OpI2ubn7SlZBtKW7KakS8Camd0oSf8jIOw3k6wDKa37vF0ScDYw8AlYcccGXRFT3bpvxWFoRhwLwGKg42eDFWA56IA6fj0smYNpOxb5ZJeBFcfs7PjBxP7T0ewx0PVoFnu2t4PDaarwPmjD/9nh1Hb6eP4bhUss9SmqG9wAAAAASUVORK5CYII=",
	["bell"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADKUlEQVR42s2Xv44URxDGfzW7s+yZw/wRZ5BIkBwQOkBO7g1Izu+AkEguxm+ABE7vDXiCk2xZJCZzgCOHBA6cIOHAh72G29vd2Y/AX6OmPXM7czaSSxr1bE/VV9XdX1X1Qg+RNGag9LWJDSABbEXEW0mfAw8AAQ0wKtTTXACPI+IXSZ8AxxEhzrCCkaTK77clPVF/eSLptm0rSaOhzsOrR9JVSU8N/KaH86TzVNLVEq9vAFOPE0k/S2okLSQtewSwtG5j20mOuZED3q4AvgS+Br4CVkAi1T7wOzABFp5L71eAA88lm0PgEfAToIhoNq0+RXwvW9FM0q+SDnrs3oF1Z9mO3cuxc6naMDzOgKVXsQ08i4h9k3NLUl08W5JGEbEPPLPN2BizAvu9jLsyAKj9pBT7+8wiGkmriFgWNhTbm9KyBuquTGjbgTDQq2xuBNzIQNS1c9a5UdSJV8aMzgCyNGkk7QJ7md6PJpM2BeDx0DZJ9ozZFL7aS6ekwyK19jxf9yBh7XGvwDhs81V14CyK3xOGy2QD5j8DcMU6Z+bmhJoOKafWnRaEXEo6V25/VbBPEXECzAsSNRsLyIc4TbGAETCPiJOyMVU5KZzjO8ClDqKdVQRckrSTdjL5TDtQA2vgGvADcAd4629Lfxsqa9tirDvGvuZvdR5AFRHriHgJ3PL5LVzPa+BCn/tDoXPBtitjTYFbEfEyItbJd+Wev5J0U9J94MgcuOxK+R3wwt0sJI1Pe6wzBV7YdmysOXAk6b6km/ZZ5c3nbpazM/f15//68KXnxppl+HdTc6qKVElyHvgW2P0PCLhrrPNtvvJmdAK8ccrIXHgo6TOf66onBxLrxx5/M9bc9o19vQ8ggW4XUX7h52PIdiLsOEux11kHXJmlq6E36Y76kfyMM18A65AUESEz92KP6Dc1pGUPjD8iYj7oovqxJFpuQW0yMnmmrmjT4s9Jep8D32e9pKt/LIf0FiRtebwu6fiUK/mxpOu5zSapBqRVGmct/X2RXWRPuzWdOYDIjmKn5cKR3neyY+lFsL7/elM6/gV8A3xqttcZ82vgT+vQkcL/P3kHIYTbQStSJ5kAAAAASUVORK5CYII=",
	["camera"] = "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADQ0lEQVR42s2Xz2tcVRTHP9+ZN5Nk0Ja2xLSSbUEFFYoidGmhLgrtspsiuNJF192K267txqX4DyhuLKR0JQiuG5cVA/7CQJMmmWTmzXHh94bDJVNmWhJ74PHeu++e8z33/H7wP5Nm2RQRPaAzp+yJpBEvO81qgdPA4pyyh5KePLcCEdFIGtv8XwLXgTHQ831SsXSABhj5/h1wW9KoyDoKp0k+7mZ8oB8RexZwBjg/pwXOFHBgKSIOqgO3kkYNgIOlDph9K3cDWAG2rfAS8CPwSzmALfIGcBnY8/tKRNyQ9K15p7sgIk5ZcKFFYAi8BvwM9IGnwAD4B7gl6X7lsqvAN8A5YBd4BTgA3gP+SjIL7UnaKgrcBT62FXpA66sLXPCpusAmcBVYl9RWCnSBN4H7wFnzLwG/J1ndhPG1pDvFhKs28zQa+H4BePwfXiz7pCTLPPaeTK9PkblK8uFmMs9i5eMS2QvAFrAjKYC/k7AdW2EH+Ao45RgqGZNjZJgwDxXoGnhiwV/UPk6mPuesmaSoDqfhSNKnU/hyjHRK1hUFSgb8AXwErFfM8qkBHthdw1ScyvOfwLtH8ACsAR8CP9gto6xAKSoHwCNJk4h41T4uteID4A7wzjNiZSUivgfuAj9FREnRgaTtiHhkjEPMTlURG2DVET1ypIekfeAicM0Cj8rrbX+7Blw0T1jGyDJX06GVLZAr4L6k1n4ua7gOlBRastlLrT/ttRKwTyteLHM/rzFni+0YvCi+Brzvay0dZq7W3bxAJ92Q9JvjY+N5hcyjQNjHjZ8vRcQn/nbJa/KeOA4Fmqr5FPOTUrlX7ZvJr7NSadetwfI8MPFaW+2dWwEBC06Zw74dEX3gIXDbwgcVb8drXe95aJ62alYL9RDUVOkydnBNImIQEaVCNpJ+Be5FxNvudgdu06TnTUn3DDiw8l2gJ2noYB1nzKayRB94KyLWJeVis5vy+bOZhk1pNxep1K77GbOTchePXQ+AK8cwAF+x7PMZs0mBVdrkMvB5RNy0TydzZs74iDhr3Y6XE06bhZ2txu7Lvo6DFhPmoQIbbqWjZ4zdL0p5bO8Zc+pQehK0J2nr5fg1889D94Sx22l/SydK/wKwIV+czTDWywAAAABJRU5ErkJggg==",
}

local XJW_ICON_CACHE = {}
local XJW_ICON_FOLDER = tostring(DIR or "Revenant") .. "/assets/icons"
local XJW_B64_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function xjwB64Decode(Source)
	local Output = table.create(#Source)
	local Count = 0
	local Buffer, Bits = 0, 0
	for Index = 1, #Source do
		local Char = string.sub(Source, Index, Index)
		local Value = string.find(XJW_B64_ALPHABET, Char, 1, true)
		if Value then
			Buffer = (Buffer * 64 + (Value - 1)) % 16777216
			Bits = Bits + 6
			if Bits >= 8 then
				Bits = Bits - 8
				local Byte = math.floor(Buffer / (2 ^ Bits)) % 256
				Count = Count + 1
				Output[Count] = string.char(Byte)
				Buffer = Buffer % (2 ^ Bits)
			end
		end
	end
	return table.concat(Output, "", 1, Count)
end

local function xjwEnsureIconFolder()
	pcall(function()
		if type(isfolder) ~= "function" or type(makefolder) ~= "function" then return end
		local Root = tostring(DIR or "Revenant")
		if not isfolder(Root) then makefolder(Root) end
		if not isfolder(Root .. "/assets") then makefolder(Root .. "/assets") end
		if not isfolder(XJW_ICON_FOLDER) then makefolder(XJW_ICON_FOLDER) end
	end)
end

function Library:GetBundledIcon(Name)
	if typeof(Name) ~= "string" then return nil end
	local Key = string.lower(Name)
	if XJW_ICON_CACHE[Key] then return XJW_ICON_CACHE[Key] end

	local Encoded = XJW_ICON_B64[Key]
	if not Encoded then return nil end
	if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then return nil end

	local Success, Icon = pcall(function()
		xjwEnsureIconFolder()
		local Path = XJW_ICON_FOLDER .. "/" .. Key .. ".png"
		if type(isfile) ~= "function" or not isfile(Path) then
			writefile(Path, xjwB64Decode(Encoded))
		end
		local Asset = getcustomasset(Path)
		if typeof(Asset) ~= "string" or Asset == "" then return nil end
		return {
			Url = Asset,
			ImageRectOffset = Vector2.zero,
			ImageRectSize = Vector2.zero,
			Custom = true,
		}
	end)

	if Success and Icon then
		XJW_ICON_CACHE[Key] = Icon
		return Icon
	end
	return nil
end


if type(Library.GetCustomIcon) == "function" and not Library.__XJWIconPatched then
	Library.__XJWIconPatched = true
	local RawGetCustomIcon = Library.GetCustomIcon
	Library.GetCustomIcon = function(self, Name)
		local Resolved = RawGetCustomIcon(self, Name)
		if Resolved ~= nil then return Resolved end
		if not Name then return nil end
		return Library:GetBundledIcon(Name)
	end
end



Library.__XJWCreateWindowRaw = Library.__XJWCreateWindowRaw or Library.CreateWindow

Library.XJWUI = XJWUI
Library.Version = XJWUI.Version
Library.Defaults = XJWUI.Defaults
Library.ThemeManager = ThemeManager
Library.SaveManager = SaveManager
Library.I18N = REV_I18N
Library.RootFolder = DIR
Library.Repo = REPO
Library.GuardPrimaryPartCFrame = guardPrimaryPartCFrame

Library.Translate = XJWUI.Translate
Library.EnableChinese = XJWUI.EnableChinese
Library.InstallNotify = XJWUI.InstallNotify
Library.StyleSidebar = XJWUI.StyleSidebar
Library.NotifyText = XJWUI.Notify
Library.Library = Library
Library.UI = XJWUI
Library.GetBackgroundImage = XJWUI.GetBackgroundImage
Library.ApplyBackgroundImage = XJWUI.ApplyBackgroundImage
Library.SoftenOuterBorder = XJWUI.SoftenOuterBorder
Library.InstallBackground = XJWUI.InstallBackground
Library.InstallBackgroundDropdown = XJWUI.InstallBackgroundDropdown
Library.BuildSettingsTab = XJWUI.BuildSettingsTab
local XJW_SCHEMES = {
	orange = {
		BackgroundColor = Color3.fromRGB(16, 12, 8),
		MainColor = Color3.fromRGB(30, 22, 14),
		AccentColor = Color3.fromRGB(255, 146, 44),
		OutlineColor = Color3.fromRGB(76, 54, 26),
		FontColor = Color3.new(1, 1, 1),
		DarkColor = Color3.new(0, 0, 0),
		WhiteColor = Color3.new(1, 1, 1),
	},
	default = {
		BackgroundColor = Color3.fromRGB(15, 15, 15),
		MainColor = Color3.fromRGB(25, 25, 25),
		AccentColor = Color3.fromRGB(125, 85, 255),
		OutlineColor = Color3.fromRGB(40, 40, 40),
		FontColor = Color3.new(1, 1, 1),
		DarkColor = Color3.new(0, 0, 0),
		WhiteColor = Color3.new(1, 1, 1),
	},
}

XJWUI.FloatStyle = "obsidian"
XJWUI.FloatGui = nil
XJWUI.FloatScreen = nil
XJWUI.FloatUnloadHooked = false
XJWUI.FloatConnections = {}
XJWUI.FloatPositions = {}

local XJW_GOLD = Color3.fromRGB(245, 197, 66)
local XJW_GOLD_LIGHT = Color3.fromRGB(255, 233, 168)
local XJW_GOLD_DEEP = Color3.fromRGB(168, 118, 10)
local XJW_INK = Color3.fromRGB(24, 18, 7)
local XJW_FLOAT_LABEL = {
	island = "黑曜石悬浮窗",
	bar = "黑曜石悬浮窗",
	orb = "黑曜石悬浮窗",
	obsidian = "黑曜石悬浮窗",
	off = "隐藏",
}
local XJW_FLOAT_KEY = {
	["灵动岛"] = "obsidian",
	["悬浮窗"] = "obsidian",
	["黑曜石悬浮窗"] = "obsidian",
	["黑曜石"] = "obsidian",
	["隐藏"] = "off",
	island = "obsidian",
	bar = "obsidian",
	orb = "obsidian",
	obsidian = "obsidian",
	off = "off",
	horizontal = "obsidian",
	draggable = "obsidian",
	none = "off",
}

local function XJWFloatReset()
	if XJWUI.FloatGui then
		pcall(function()
			XJWUI.FloatGui:Destroy()
		end)
		XJWUI.FloatGui = nil
	end
	for _, connection in ipairs(XJWUI.FloatConnections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	XJWUI.FloatConnections = {}
end

function XJWUI:InstallFloat(style)
	local key = XJW_FLOAT_KEY[style] or style
	key = (key == "off") and "off" or "obsidian"
	self.FloatStyle = key
	XJWFloatReset()
	local nativeHolder = Library.Floats
	if not nativeHolder then
		return false
	end
	pcall(function()
		for _, child in ipairs(nativeHolder:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextLabel") then
				local text = child.Text
				if text == "Toggle" or text == "Lock" or text == "切换" or text == "锁定" or text == "解锁" then
					child.Visible = (key ~= "off")
				end
			end
		end
	end)
	return true
end

function XJWUI:SetFloatStyle(style)
	local key = XJW_FLOAT_KEY[style] or style
	key = (key == "off") and "off" or "obsidian"
	if self.BootHiding and not self.BootForce then
		self.FloatStyle = key
		return XJW_FLOAT_LABEL[key] or "黑曜石悬浮窗"
	end
	self:InstallFloat(key)
	return XJW_FLOAT_LABEL[key] or "黑曜石悬浮窗"
end

function XJWUI:GetFloatStyle()
	return XJW_FLOAT_LABEL[self.FloatStyle or "obsidian"] or "黑曜石悬浮窗"
end

task.defer(function()
	pcall(function()
		XJWUI:InstallFloat(XJWUI.FloatStyle or "obsidian")
	end)
end)

Library.__XJWCreateWindowRaw = Library.__XJWCreateWindowRaw or Library.CreateWindow

Library.XJWUI = XJWUI
Library.Version = XJWUI.Version
Library.Defaults = XJWUI.Defaults
Library.ThemeManager = ThemeManager
Library.SaveManager = SaveManager
Library.I18N = REV_I18N
Library.RootFolder = DIR
Library.Repo = REPO
Library.GuardPrimaryPartCFrame = guardPrimaryPartCFrame

Library.Translate = XJWUI.Translate
Library.EnableChinese = XJWUI.EnableChinese
Library.InstallNotify = XJWUI.InstallNotify
Library.StyleSidebar = XJWUI.StyleSidebar
Library.NotifyText = XJWUI.Notify
Library.Library = Library
Library.UI = XJWUI
Library.GetBackgroundImage = XJWUI.GetBackgroundImage
Library.ApplyBackgroundImage = XJWUI.ApplyBackgroundImage
Library.SoftenOuterBorder = XJWUI.SoftenOuterBorder
Library.InstallBackground = XJWUI.InstallBackground
Library.InstallBackgroundDropdown = XJWUI.InstallBackgroundDropdown
Library.BuildSettingsTab = XJWUI.BuildSettingsTab
Library.InstallFloat = XJWUI.InstallFloat
local XJW_SCHEMES = {
	orange = {
		BackgroundColor = Color3.fromRGB(16, 12, 8),
		MainColor = Color3.fromRGB(30, 22, 14),
		AccentColor = Color3.fromRGB(255, 146, 44),
		OutlineColor = Color3.fromRGB(76, 54, 26),
		FontColor = Color3.new(1, 1, 1),
		DarkColor = Color3.new(0, 0, 0),
		WhiteColor = Color3.new(1, 1, 1),
	},
	default = {
		BackgroundColor = Color3.fromRGB(15, 15, 15),
		MainColor = Color3.fromRGB(25, 25, 25),
		AccentColor = Color3.fromRGB(125, 85, 255),
		OutlineColor = Color3.fromRGB(40, 40, 40),
		FontColor = Color3.new(1, 1, 1),
		DarkColor = Color3.new(0, 0, 0),
		WhiteColor = Color3.new(1, 1, 1),
	},
}

function XJWUI:PickFloatStyle(opts)
	opts = opts or {}
	self:SetFloatStyle("obsidian")
	if type(opts.Callback) == "function" then
		task.spawn(opts.Callback, "obsidian")
	end
	return "黑曜石悬浮窗"
end

function XJWUI:ApplyScheme(name)
	local key = tostring(name or "orange"):lower()
	local palette = XJW_SCHEMES[key] or XJW_SCHEMES.orange
	for k, v in pairs(palette) do
		pcall(function()
			Library.Scheme[k] = v
		end)
	end
	pcall(function()
		if type(Library.UpdateColorsUsingRegistry) == "function" then
			Library:UpdateColorsUsingRegistry()
		end
	end)
	return key ~= nil and key or "orange"
end

local function XJWBootSchemeColor(key, fallback)
	local scheme = Library and Library.Scheme
	local c = type(scheme) == "table" and scheme[key]
	if typeof(c) == "Color3" then
		return c
	end
	return fallback
end

function XJWUI:Boot(opts)
	opts = opts or {}
	if self.BootHandle and not self.BootHandle.finished then
		return self.BootHandle
	end
	if opts.Chinese ~= false then
		pcall(function()
			self:EnableChinese(true)
		end)
	end
	if opts.Scheme then
		pcall(function()
			self:ApplyScheme(opts.Scheme)
		end)
	end

	local labels = opts.Options
	if type(labels) ~= "table" or #labels == 0 then
		labels = { "黑曜石悬浮窗" }
	end
	local boot = {
		styleKey = nil,
		picked = false,
		uiReady = false,
		awaiting = false,
		finished = false,
	}
	self.BootHandle = boot
	self.BootHiding = true
	boot.HideFloats = function()
		pcall(function()
			XJWFloatReset()
		end)
		pcall(function()
			local holder = Library and Library.Floats
			if not holder then
				return
			end
			for _, item in ipairs(holder:GetDescendants()) do
				if item:IsA("GuiObject") then
					item.Visible = false
				end
			end
		end)
	end

	local named = {}
	local pickerGui = nil

	local function paint()
		local accent = XJWBootSchemeColor("AccentColor", Color3.fromRGB(125, 85, 255))
		local idle = XJWBootSchemeColor("MainColor", Color3.fromRGB(25, 25, 25))
		local font = XJWBootSchemeColor("FontColor", Color3.new(1, 1, 1))
		local onAccent = XJWBootSchemeColor("DarkColor", Color3.new(0, 0, 0))
		local bright = 0.299 * accent.R + 0.587 * accent.G + 0.114 * accent.B
		if bright < 0.6 then
			onAccent = font
		end
		for label, btn in pairs(named) do
			if boot.styleKey == label then
				pcall(function()
					btn.BackgroundColor3 = accent
					btn.TextColor3 = onAccent
				end)
			else
				pcall(function()
					btn.BackgroundColor3 = idle
					btn.TextColor3 = font
				end)
			end
		end
	end

	local function destroyPicker()
		if not pickerGui then
			return
		end
		pcall(function()
			pickerGui:Destroy()
		end)
		pickerGui = nil
		named = {}
	end

	local function finish()
		if boot.finished then
			return
		end
		boot.finished = true
		boot.awaiting = false
		destroyPicker()
		self.BootHiding = false
		boot.styleKey = boot.styleKey or labels[1]
		if type(boot.OnApply) == "function" then
			pcall(boot.OnApply, boot.styleKey)
		end
		pcall(function()
			self:SetFloatStyle(boot.styleKey)
		end)
		pcall(function()
			self:Notify("加载完成")
		end)
		if type(opts.OnFinish) == "function" then
			task.spawn(opts.OnFinish, boot.styleKey)
		end
	end

	boot.Finish = finish

	local function pick(label)
		if boot.picked or boot.finished then
			return
		end
		boot.styleKey = label
		boot.picked = true
		paint()
		if boot.uiReady then
			task.defer(finish)
		end
	end

	boot.Pick = pick

	local function ready()
		boot.uiReady = true
		paint()
		if boot.picked then
			finish()
			return
		end
		if not pickerGui then
			pick(labels[1])
			finish()
			return
		end
		boot.awaiting = true
	end

	boot.Ready = ready

	return boot
end

function XJWUI:_AttachTitleFlow(label, speed)
	if not label or label:FindFirstChild("XJWTitleFlow") then
		return nil
	end
	local accent = Color3.fromRGB(245, 197, 66)
	pcall(function()
		if type(Library.Scheme) == "table" then
			accent = Library.Scheme.AccentColor
		end
	end)
	local grad = Instance.new("UIGradient")
	grad.Name = "XJWTitleFlow"
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, accent:Lerp(Color3.new(0, 0, 0), 0.55)),
		ColorSequenceKeypoint.new(0.35, accent),
		ColorSequenceKeypoint.new(0.5, accent:Lerp(Color3.new(1, 1, 1), 0.55)),
		ColorSequenceKeypoint.new(0.65, accent),
		ColorSequenceKeypoint.new(1, accent:Lerp(Color3.new(0, 0, 0), 0.55)),
	})
	label.TextColor3 = Color3.new(1, 1, 1)
	grad.Parent = label
	task.spawn(function()
		local base = os.clock()
		while grad.Parent == label do
			local t = os.clock() - base
			grad.Rotation = (t * (speed or 62)) % 360
			grad.Offset = Vector2.new(math.sin(t * 1.1) * 0.08, 0)
			RunService.RenderStepped:Wait()
		end
	end)
	return grad
end

function XJWUI:InstallTitleFlow(win, opts)
	opts = opts or {}
	local target = opts.Title
	local speed = opts.Speed or 62
	local function seek()
		local frame = nil
		pcall(function()
			frame = win and win.MainFrame
		end)
		if not frame then
			return nil
		end
		local found = nil
		for _, obj in ipairs(frame:GetDescendants()) do
			if obj:IsA("TextLabel") and (target == nil or obj.Text == target) and obj.TextSize >= 15 then
				found = obj
				break
			end
		end
		return found
	end
	local label = seek()
	if label then
		return self:_AttachTitleFlow(label, speed)
	end
	task.spawn(function()
		for _ = 1, 120 do
			local found = seek()
			if found then
				self:_AttachTitleFlow(found, speed)
				return
			end
			task.wait(0.1)
		end
	end)
	return nil
end

Library.SetFloatStyle = XJWUI.SetFloatStyle
Library.GetFloatStyle = XJWUI.GetFloatStyle
Library.PickFloatStyle = XJWUI.PickFloatStyle
Library.FloatLabels = XJW_FLOAT_LABEL
Library.ApplyScheme = XJWUI.ApplyScheme
Library.InstallTitleFlow = XJWUI.InstallTitleFlow

task.defer(function()
	pcall(function()
		XJWUI:EnableChinese(true)
	end)
end)

Library.Boot = function(self, opts)
	return XJWUI:Boot(opts)
end

Library.StartBoot = Library.Boot

Library.GetBoot = function()
	return XJWUI.BootHandle
end

local XJW_UnloadCore = Library.Unload

function Library:Unload()
	if type(XJW_UnloadCore) == "function" and not self.Unloaded then
		pcall(XJW_UnloadCore, self)
	end
	self.Unloaded = true
	pcall(function()
		XJWUI.BootHiding = false
		if XJWUI.BootHandle then
			XJWUI.BootHandle.finished = true
		end
	end)
	local parents = {}
	pcall(function()
		table.insert(parents, LocalPlayer:FindFirstChild("PlayerGui"))
	end)
	pcall(function()
		table.insert(parents, game:GetService("CoreGui"))
	end)
	for _, parentGui in ipairs(parents) do
		if parentGui then
			pcall(function()
				for _, child in ipairs(parentGui:GetChildren()) do
					if child:IsA("ScreenGui") and type(child.Name) == "string" and child.Name:sub(1, 3) == "XJW" then
						child:Destroy()
					end
				end
			end)
		end
	end
	pcall(function()
		if self.ScreenGui then
			self.ScreenGui:Destroy()
		end
	end)
	self.ScreenGui = nil
	XJWUI.FloatScreen = nil
	XJWUI.FloatGui = nil
end


Library.CreateWindow = function(self, opts)
	return XJWUI:CreateWindow(opts)
end



setmetatable(XJWUI, {
	__index = function(_, key)
		return Library[key]
	end,
})

if type(getgenv) == "function" then
	local okEnv, env = pcall(getgenv)
	if okEnv and type(env) == "table" then
		env.XJWUI = Library
	end
end

return Library
