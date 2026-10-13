-- Eclipse UI - NOIR-inspired standalone interface
-- Made by @ronzy.exe on discord
-- UI scaffold for Roblox Studio / authorized projects.
-- This is a standalone visual interface; example controls only update local UI state.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("EclipseStandaloneUI")
if old then old:Destroy() end

local COLORS = {
    bg = Color3.fromRGB(14, 14, 15),
    panel = Color3.fromRGB(19, 19, 20),
    card = Color3.fromRGB(22, 22, 23),
    card2 = Color3.fromRGB(27, 27, 28),
    stroke = Color3.fromRGB(42, 42, 44),
    text = Color3.fromRGB(242, 242, 244),
    muted = Color3.fromRGB(155, 155, 160),
    white = Color3.fromRGB(247, 247, 249),
    black = Color3.fromRGB(15, 15, 16),
}

local state = {
    ["Enable ESP"] = false,
    ["Show bots"] = true,
    ["Names"] = true,
    ["Health"] = true,
    ["Distance"] = true,
    ["Highlights"] = true,
    ["Through walls"] = true,
    ["Team check"] = true,
    ["Show status"] = true,
    ["Movement option"] = false,
    ["Maximum distance"] = 1500,
    ["Text size"] = 13,
}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function label(parent, text, size, color, bold)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        Font = bold and Enum.Font.GothamSemibold or Enum.Font.Gotham,
        TextSize = size or 14,
        TextColor3 = color or COLORS.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

local gui = make("ScreenGui", {
    Name = "EclipseStandaloneUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
}, playerGui)

local main = make("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(0.88, 0, 0.82, 0),
    BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
corner(main, 22)
stroke(main, Color3.fromRGB(50, 50, 52), 1, 0.12)

local scale = make("UIScale", {Scale = 1}, main)
local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    if viewport.X < 700 then
        scale.Scale = 0.78
    elseif viewport.X < 1000 then
        scale.Scale = 0.9
    else
        scale.Scale = 1
    end
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

local sidebar = make("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 235, 1, 0),
    BackgroundColor3 = Color3.fromRGB(16, 16, 17),
    BorderSizePixel = 0,
}, main)
make("Frame", {
    Position = UDim2.new(1, -1, 0, 18),
    Size = UDim2.new(0, 1, 1, -36),
    BackgroundColor3 = COLORS.stroke,
    BorderSizePixel = 0,
}, sidebar)

local brand = make("Frame", {
    Position = UDim2.fromOffset(18, 16),
    Size = UDim2.new(1, -36, 0, 54),
    BackgroundTransparency = 1,
}, sidebar)
local logo = make("Frame", {
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.fromOffset(0, 3),
    BackgroundColor3 = Color3.fromRGB(31, 31, 33),
    BorderSizePixel = 0,
}, brand)
corner(logo, 13)
stroke(logo, Color3.fromRGB(61, 61, 64), 1, 0.2)
label(logo, "E", 22, COLORS.white, true).Size = UDim2.fromScale(1, 1)
local brandTitle = label(brand, "Eclipse", 16, COLORS.text, true)
brandTitle.Position = UDim2.fromOffset(54, 5)
brandTitle.Size = UDim2.new(1, -54, 0, 22)
local brandSub = label(brand, "Sniper Arena", 11, COLORS.muted, false)
brandSub.Position = UDim2.fromOffset(54, 27)
brandSub.Size = UDim2.new(1, -54, 0, 18)

local nav = make("Frame", {
    Position = UDim2.fromOffset(12, 90),
    Size = UDim2.new(1, -24, 1, -172),
    BackgroundTransparency = 1,
}, sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, nav)

local profile = make("Frame", {
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 12, 1, -12),
    Size = UDim2.new(1, -24, 0, 58),
    BackgroundColor3 = COLORS.card,
    BorderSizePixel = 0,
}, sidebar)
corner(profile, 13)
stroke(profile, COLORS.stroke, 1, 0.2)
local avatar = make("Frame", {
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.fromOffset(36, 36),
    BackgroundColor3 = Color3.fromRGB(45, 45, 48),
    BorderSizePixel = 0,
}, profile)
corner(avatar, 18)
label(avatar, string.upper(string.sub(player.DisplayName or player.Name, 1, 1)), 15, COLORS.white, true).Size = UDim2.fromScale(1, 1)
local profileName = label(profile, player.DisplayName or player.Name, 12, COLORS.text, true)
profileName.Position = UDim2.fromOffset(55, 10)
profileName.Size = UDim2.new(1, -64, 0, 18)
local profileTag = label(profile, "Eclipse UI", 10, COLORS.muted, false)
profileTag.Position = UDim2.fromOffset(55, 29)
profileTag.Size = UDim2.new(1, -64, 0, 16)

local content = make("Frame", {
    Name = "Content",
    Position = UDim2.new(0, 235, 0, 0),
    Size = UDim2.new(1, -235, 1, 0),
    BackgroundTransparency = 1,
}, main)

local topbar = make("Frame", {
    Position = UDim2.fromOffset(18, 14),
    Size = UDim2.new(1, -36, 0, 54),
    BackgroundTransparency = 1,
}, content)
local pageIcon = make("Frame", {
    Position = UDim2.fromOffset(0, 3),
    Size = UDim2.fromOffset(42, 42),
    BackgroundColor3 = COLORS.card2,
    BorderSizePixel = 0,
}, topbar)
corner(pageIcon, 12)
stroke(pageIcon, COLORS.stroke, 1, 0.25)
local pageGlyph = label(pageIcon, "◉", 20, COLORS.white, true)
pageGlyph.Size = UDim2.fromScale(1, 1)
local pageTitle = label(topbar, "ESP", 16, COLORS.text, true)
pageTitle.Position = UDim2.fromOffset(54, 4)
pageTitle.Size = UDim2.new(1, -140, 0, 22)
local pageDescription = label(topbar, "Player and bot visibility.", 11, COLORS.muted, false)
pageDescription.Position = UDim2.fromOffset(54, 27)
pageDescription.Size = UDim2.new(1, -140, 0, 17)

local minimize = make("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -35, 0, 5),
    Size = UDim2.fromOffset(28, 30),
    Text = "–",
    Font = Enum.Font.Gotham,
    TextSize = 22,
    TextColor3 = COLORS.muted,
    BackgroundTransparency = 1,
    AutoButtonColor = false,
}, topbar)
local close = make("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 5),
    Size = UDim2.fromOffset(28, 30),
    Text = "×",
    Font = Enum.Font.Gotham,
    TextSize = 22,
    TextColor3 = COLORS.muted,
    BackgroundTransparency = 1,
    AutoButtonColor = false,
}, topbar)

make("Frame", {
    Position = UDim2.new(0, 18, 0, 72),
    Size = UDim2.new(1, -36, 0, 1),
    BackgroundColor3 = COLORS.stroke,
    BorderSizePixel = 0,
}, content)

local pageBody = make("ScrollingFrame", {
    Position = UDim2.fromOffset(18, 88),
    Size = UDim2.new(1, -36, 1, -106),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(90, 90, 94),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, content)
local grid = make("UIGridLayout", {
    CellSize = UDim2.new(0.5, -7, 0, 300),
    CellPadding = UDim2.fromOffset(12, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, pageBody)
make("UIPadding", {
    PaddingTop = UDim.new(0, 2),
    PaddingBottom = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 1),
}, pageBody)

local pages = {}
local selectedTab = "ESP"
local pageConfigs = {
    Main = {icon = "◎", desc = "General options and status."},
    ESP = {icon = "◉", desc = "Player and bot visibility."},
    Player = {icon = "♙", desc = "Local presentation settings."},
    Config = {icon = "⚙", desc = "Interface preferences."},
}

local function makeCard(parent, title, icon, height)
    local card = make("Frame", {
        BackgroundColor3 = COLORS.panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, height or 260),
    }, parent)
    corner(card, 16)
    stroke(card, Color3.fromRGB(39, 39, 41), 1, 0.25)
    local header = make("Frame", {
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.new(1, -24, 0, 36),
        BackgroundTransparency = 1,
    }, card)
    local iconBox = make("Frame", {
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = COLORS.card2,
        BorderSizePixel = 0,
    }, header)
    corner(iconBox, 11)
    label(iconBox, icon or "◉", 16, COLORS.text, true).Size = UDim2.fromScale(1, 1)
    local titleLabel = label(header, title, 13, COLORS.text, true)
    titleLabel.Position = UDim2.fromOffset(43, 0)
    titleLabel.Size = UDim2.new(1, -68, 1, 0)
    local chevron = label(header, "⌄", 17, COLORS.muted, true)
    chevron.TextXAlignment = Enum.TextXAlignment.Right
    chevron.Size = UDim2.fromOffset(20, 34)
    chevron.Position = UDim2.new(1, -20, 0, 0)
    local body = make("Frame", {
        Position = UDim2.fromOffset(12, 56),
        Size = UDim2.new(1, -24, 1, -66),
        BackgroundTransparency = 1,
    }, card)
    return card, body
end

local function makeToggle(parent, text, initial, order, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 37),
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
    }, parent)
    local glyph = label(row, "◉", 15, COLORS.muted, true)
    glyph.Size = UDim2.fromOffset(20, 34)
    local title = label(row, text, 12, COLORS.text, false)
    title.Position = UDim2.fromOffset(27, 0)
    title.Size = UDim2.new(1, -95, 1, 0)
    local track = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(48, 27),
        BackgroundColor3 = initial and COLORS.white or Color3.fromRGB(48, 48, 50),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, row)
    corner(track, 15)
    local knob = make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = initial and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
        Size = UDim2.fromOffset(19, 19),
        BackgroundColor3 = initial and COLORS.black or Color3.fromRGB(180, 180, 183),
        BorderSizePixel = 0,
    }, track)
    corner(knob, 12)
    local value = initial
    local function set(nextValue, quiet)
        value = not not nextValue
        TweenService:Create(track, TweenInfo.new(0.15), {
            BackgroundColor3 = value and COLORS.white or Color3.fromRGB(48, 48, 50)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = value and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
            BackgroundColor3 = value and COLORS.black or Color3.fromRGB(180, 180, 183)
        }):Play()
        state[text] = value
        if callback and not quiet then callback(value) end
    end
    track.Activated:Connect(function() set(not value) end)
    set(initial, true)
    return {Set = set, Get = function() return value end, Row = row}
end

local function makeSlider(parent, text, minValue, maxValue, initial, order, callback)
    local holder = make("Frame", {
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
    }, parent)
    local title = label(holder, text, 12, COLORS.text, false)
    title.Position = UDim2.fromOffset(0, 0)
    title.Size = UDim2.new(1, -65, 0, 23)
    local valueLabel = label(holder, tostring(initial), 12, COLORS.text, true)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.Size = UDim2.fromOffset(60, 23)
    local bar = make("TextButton", {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 6),
        BackgroundColor3 = Color3.fromRGB(42, 42, 44),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, holder)
    corner(bar, 5)
    local ratio = math.clamp((initial - minValue) / (maxValue - minValue), 0, 1)
    local fill = make("Frame", {
        Size = UDim2.new(ratio, 0, 1, 0),
        BackgroundColor3 = COLORS.white,
        BorderSizePixel = 0,
    }, bar)
    corner(fill, 5)
    local knob = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(ratio, 0, 0.5, 0),
        Size = UDim2.fromOffset(17, 17),
        BackgroundColor3 = COLORS.white,
        BorderSizePixel = 0,
    }, bar)
    corner(knob, 10)
    local current = initial
    local dragging = false
    local function setValue(value, quiet)
        current = math.clamp(math.floor(value + 0.5), minValue, maxValue)
        local r = (current - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, 0, 0.5, 0)
        valueLabel.Text = tostring(current)
        state[text] = current
        if callback and not quiet then callback(current) end
    end
    local function fromX(x)
        local width = math.max(1, bar.AbsoluteSize.X)
        setValue(minValue + math.clamp((x - bar.AbsolutePosition.X) / width, 0, 1) * (maxValue - minValue))
    end
    bar.Activated:Connect(function() fromX(UserInputService:GetMouseLocation().X) end)
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            fromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            fromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return {Set = setValue, Get = function() return current end}
end

local function clearPage()
    for _, child in ipairs(pageBody:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIGridLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function addNav(name, icon, order)
    local button = make("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = COLORS.card,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        LayoutOrder = order,
        AutoButtonColor = false,
    }, nav)
    corner(button, 12)
    local activeBar = make("Frame", {
        Position = UDim2.fromOffset(0, 12),
        Size = UDim2.fromOffset(3, 22),
        BackgroundColor3 = COLORS.white,
        BorderSizePixel = 0,
        Visible = false,
    }, button)
    corner(activeBar, 3)
    local iconLabel = label(button, icon, 18, COLORS.muted, true)
    iconLabel.Position = UDim2.fromOffset(15, 0)
    iconLabel.Size = UDim2.fromOffset(24, 46)
    local nameLabel = label(button, name, 13, COLORS.text, true)
    nameLabel.Position = UDim2.fromOffset(47, 0)
    nameLabel.Size = UDim2.new(1, -55, 1, 0)
    pages[name] = {button = button, bar = activeBar, icon = iconLabel, text = nameLabel}
    button.Activated:Connect(function()
        selectedTab = name
        for tabName, item in pairs(pages) do
            local active = tabName == name
            item.button.BackgroundTransparency = active and 0 or 1
            item.bar.Visible = active
            item.icon.TextColor3 = active and COLORS.white or COLORS.muted
            item.text.TextColor3 = active and COLORS.text or Color3.fromRGB(190, 190, 194)
        end
        pageTitle.Text = name
        pageDescription.Text = pageConfigs[name].desc
        pageGlyph.Text = pageConfigs[name].icon
        clearPage()

        if name == "ESP" then
            local _, visibility = makeCard(pageBody, "Visibility", "◉", 345)
            make("UIListLayout", {Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder}, visibility)
            makeToggle(visibility, "Enable ESP", state["Enable ESP"], 1)
            makeToggle(visibility, "Show bots", state["Show bots"], 2)
            makeToggle(visibility, "Names", state["Names"], 3)
            makeToggle(visibility, "Health", state["Health"], 4)
            makeToggle(visibility, "Distance", state["Distance"], 5)
            makeSlider(visibility, "Maximum distance", 100, 5000, state["Maximum distance"], 6)
            local _, appearance = makeCard(pageBody, "Appearance", "◌", 230)
            make("UIListLayout", {Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder}, appearance)
            makeToggle(appearance, "Highlights", state["Highlights"], 1)
            makeToggle(appearance, "Through walls", state["Through walls"], 2)
            makeSlider(appearance, "Text size", 10, 24, state["Text size"], 3)
        elseif name == "Main" then
            local _, general = makeCard(pageBody, "General", "◎", 190)
            make("UIListLayout", {Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder}, general)
            makeToggle(general, "Team check", state["Team check"], 1)
            makeToggle(general, "Show status", state["Show status"], 2)
            local _, info = makeCard(pageBody, "Information", "ⓘ", 130)
            local text = label(info, "Eclipse interface loaded.\nExample controls update local UI state only.", 12, COLORS.muted, false)
            text.Size = UDim2.new(1, 0, 0, 50)
            text.TextWrapped = true
            text.TextYAlignment = Enum.TextYAlignment.Top
        elseif name == "Player" then
            local _, movement = makeCard(pageBody, "Player options", "♙", 160)
            make("UIListLayout", {Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder}, movement)
            makeToggle(movement, "Movement option", state["Movement option"], 1)
            local _, view = makeCard(pageBody, "View", "◉", 130)
            local info = label(view, "This page is a UI scaffold. Connect only to features you own or are authorized to use.", 12, COLORS.muted, false)
            info.Size = UDim2.new(1, 0, 0, 65)
            info.TextWrapped = true
            info.TextYAlignment = Enum.TextYAlignment.Top
        else
            local _, config = makeCard(pageBody, "Interface", "⚙", 175)
            make("UIListLayout", {Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder}, config)
            makeToggle(config, "Show status", state["Show status"], 1)
            local _, about = makeCard(pageBody, "About", "ⓘ", 125)
            local info = label(about, "Eclipse UI\nStandalone NOIR-inspired layout.", 12, COLORS.muted, false)
            info.Size = UDim2.new(1, 0, 0, 52)
            info.TextYAlignment = Enum.TextYAlignment.Top
        end
    end)
end

addNav("Main", "◎", 1)
addNav("ESP", "◉", 2)
addNav("Player", "♙", 3)
addNav("Config", "⚙", 4)

-- Initial page selection
pages["ESP"].button:Activate()

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    sidebar.Visible = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(250, 64) or UDim2.new(0.88, 0, 0.82, 0)
    if minimized then
        main.Position = UDim2.new(0.5, 0, 0.18, 0)
        local mini = main:FindFirstChild("MinimizedTitle")
        if not mini then
            mini = label(main, "Eclipse  •  tap × to close", 14, COLORS.text, true)
            mini.Name = "MinimizedTitle"
            mini.Position = UDim2.fromOffset(18, 0)
            mini.Size = UDim2.new(1, -36, 1, 0)
        end
        mini.Visible = true
    else
        main.Position = UDim2.fromScale(0.5, 0.5)
        local mini = main:FindFirstChild("MinimizedTitle")
        if mini then mini.Visible = false end
    end
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Drag window using the top bar.
local dragging, dragStart, startPos = false, nil, nil
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("[Eclipse UI] Standalone interface loaded.")
