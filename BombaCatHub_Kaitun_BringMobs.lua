Config = {
    Team = "Pirates",
    Configuration = {
        HopWhenIdle = true,
        AutoHop = true,
        AutoHopDelay = 60 * 60,
        FpsBoost = false,
        blackscreen = false,
        LowGraphics = true
    },
    Items = {
        AutoFullyMelees = true,
        Saber = true,
        CursedDualKatana = true,
        SoulGuitar = true,
        RaceV2 = true,
        AutoRaceV3 = true,
        AutoRandomFruit = false,
    },
    Sword = {
        ["Shark Saw"]        = true,
        ["Wardens Sword"]    = true,
        ["Pole (1st Form)"]  = true,
        ["Gravity Blade"]    = true,
        ["Longsword"]        = true,
        ["Rengoku"]          = true,
        ["Flail"]            = true,
        ["Twin Hooks"]       = true,
    },
    BossWeapons = {
        ["Awakened Ice Admiral"] = true,
        ["Tide Keeper"]          = true,
        ["Deandre"]              = true,
        ["Urban"]                = true,
        ["Diablo"]               = true,
        ["Soul Reaper"]          = true,
        ["Cake Prince"]          = true,
        ["Core"]                 = true,
        ["Darkbeard"]            = true,
        ["Katakuri"]             = true,
        ["Beautiful Pirates"]    = true,
    },
    Melee = {
        AutoBuy              = true,
        CheckMasteryAfterBuy = true,
        RaidAtV1Mastery      = 500,
        GodhumanAtV2Mastery  = 400,
    },
    AutoKen = true,
    BringMobs = true,  -- Ativado com o novo Bring Mobs otimizado
    BringRadius = 800,
    BringMaxMobs = 30,
    PanicMode = {
        Enabled          = true,
        LowHealthPercent = 20,
        SafeHealthPercent = 75,
        EscapeHeight     = 2000,
        CheckInterval    = 1,
    },
    Settings = {
        StayInSea2UntilHaveDarkFragments = true
    },
    AutoSea2 = true,
    AutoSea3 = true,
    AutoRaidIce_TargetFragments = 5000,
}
print("[BombaCat Hub] Script carregado, a esperar o jogo carregar...")
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lp = Players.LocalPlayer

print("[BombaCat Hub] A iniciar...")
timeee = os.time()
local W_angle = 30
local lastChange = tick()

-- ============================================================
-- CHỌN VŨ KHÍ
-- ============================================================
_G.ChooseWP = "Melee"  
_G.SelectWeapon = nil

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local bp = lp:FindFirstChild("Backpack")
            if not bp then return end
            if _G.ChooseWP == "Melee" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Melee" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            elseif _G.ChooseWP == "Sword" then
                for _, v in pairs(bp:GetChildren()) do
                    if v:IsA("Tool") and v.ToolTip == "Sword" then
                        _G.SelectWeapon = v.Name
                        break
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- GAME DATA
-- ============================================================
local GameData = {
	QUESTS = {
		Sea_1 = {
			{1, 9, "Team-dependent", "Team-dependent", 1},
			{10, 14, "Monkey", "JungleQuest", 1},
			{15, 29, "Gorilla", "JungleQuest", 2, "The Gorilla King", 20},
			{30, 39, "Pirate", "BuggyQuest1", 1},
			{40, 59, "Brute", "BuggyQuest1", 2, "Chief", 55},
			{60, 74, "Desert Bandit", "DesertQuest", 1},
			{75, 89, "Desert Officer", "DesertQuest", 2},
			{90, 99, "Snow Bandit", "SnowQuest", 1},
			{100, 119, "Snowman", "SnowQuest", 2, "Yeti", 105},
			{120, 149, "Chief Petty Officer", "MarineQuest2", 1, "Vice Admiral", 130},
			{150, 174, "Sky Bandit", "SkyQuest", 1},
			{175, 189, "Dark Master", "SkyQuest", 2},
			{190, 209, "Prisoner", "PrisonerQuest", 1},
			{210, 249, "Dangerous Prisoner", "PrisonerQuest", 2, {"Warden", 220, "ImpelQuest", 1}, {"Chief Warden", 230, "ImpelQuest", 2}, {"Swan", 240, "ImpelQuest", 3}},
			{250, 274, "Toga Warrior", "ColosseumQuest", 1},
			{275, 299, "Gladiator", "ColosseumQuest", 2},
			{300, 324, "Military Soldier", "MagmaQuest", 1},
			{325, 374, "Military Spy", "MagmaQuest", 2, "Magma Admiral", 350},
			{375, 399, "Fishman Warrior", "FishmanQuest", 1},
			{400, 449, "Fishman Commando", "FishmanQuest", 2, "Fishman Lord", 425},
			{450, 474, "God's Guard", "SkyExp1Quest", 1},
			{475, 524, "Shanda", "SkyExp1Quest", 2, "Wysper", 500},
			{525, 549, "Royal Squad", "SkyExp2Quest", 1},
			{550, 624, "Royal Soldier", "SkyExp2Quest", 2, "Thunder God", 575},
			{625, 649, "Galley Pirate", "FountainQuest", 1},
			{650, 9999, "Galley Captain", "FountainQuest", 2, "Cyborg", 675},
		},
		Sea_2 = {
			{700, 724, "Raider", "Area1Quest", 1},
			{725, 774, "Mercenary", "Area1Quest", 2, "Diamond", 750},
			{775, 799, "Swan Pirate", "Area2Quest", 1},
			{800, 874, "Factory Staff", "Area2Quest", 2, "Jeremy", 850},
			{875, 899, "Marine Lieutenant", "MarineQuest3", 1},
			{900, 949, "Marine Captain", "MarineQuest3", 2, "Orbitus", 925},
			{950, 974, "Zombie", "ZombieQuest", 1},
			{975, 999, "Vampire", "ZombieQuest", 2},
			{1000, 1049, "Snow Trooper", "SnowMountainQuest", 1},
			{1050, 1099, "Winter Warrior", "SnowMountainQuest", 2},
			{1100, 1124, "Lab Subordinate", "IceSideQuest", 1},
			{1125, 1174, "Horned Warrior", "IceSideQuest", 2, "Smoke Admiral", 1150},
			{1175, 1199, "Magma Ninja", "FireSideQuest", 1},
			{1200, 1249, "Lava Pirate", "FireSideQuest", 2},
			{1250, 1274, "Ship Deckhand", "ShipQuest1", 1},
			{1275, 1299, "Ship Engineer", "ShipQuest1", 2},
			{1300, 1324, "Ship Steward", "ShipQuest2", 1},
			{1325, 1349, "Ship Officer", "ShipQuest2", 2},
			{1350, 1374, "Arctic Warrior", "FrostQuest", 1},
			{1375, 1424, "Snow Lurker", "FrostQuest", 2, "Awakened Ice Admiral", 1400},
			{1425, 1449, "Sea Soldier", "ForgottenQuest", 1},
			{1450, 9999, "Water Fighter", "ForgottenQuest", 2, "Tide Keeper", 1475},
		},
		Sea_3 = {
			{1500, 1524, "Pirate Millionaire", "PiratePortQuest", 1},
			{1525, 1574, "Pistol Billionaire", "PiratePortQuest", 2},
			{1575, 1599, "Dragon Crew Warrior", "DragonCrewQuest", 1},
			{1600, 1624, "Dragon Crew Archer", "DragonCrewQuest", 2},
			{1625, 1649, "Hydra Enforcer", "VenomCrewQuest", 1},
			{1650, 1699, "Venomous Assailant", "VenomCrewQuest", 2},
			{1700, 1724, "Marine Commodore", "MarineTreeIsland", 1},
			{1725, 1774, "Marine Rear Admiral", "MarineTreeIsland", 2},
			{1775, 1799, "Fishman Raider", "DeepForestIsland3", 1},
			{1800, 1824, "Fishman Captain", "DeepForestIsland3", 2},
			{1825, 1849, "Forest Pirate", "DeepForestIsland", 1},
			{1850, 1899, "Mythological Pirate", "DeepForestIsland", 2},
			{1900, 1924, "Jungle Pirate", "DeepForestIsland2", 1},
			{1925, 1974, "Musketeer Pirate", "DeepForestIsland2", 2},
			{1975, 1999, "Reborn Skeleton", "HauntedQuest1", 1},
			{2000, 2024, "Living Zombie", "HauntedQuest1", 2},
			{2025, 2049, "Demonic Soul", "HauntedQuest2", 1},
			{2050, 2074, "Posessed Mummy", "HauntedQuest2", 2},
			{2075, 2099, "Peanut Scout", "NutsIslandQuest", 1},
			{2100, 2124, "Peanut President", "NutsIslandQuest", 2},
			{2125, 2149, "Ice Cream Chef", "IceCreamIslandQuest", 1},
			{2150, 2199, "Ice Cream Commander", "IceCreamIslandQuest", 2},
			{2200, 2224, "Cookie Crafter", "CakeQuest1", 1},
			{2225, 2249, "Cake Guard", "CakeQuest1", 2},
			{2250, 2274, "Baking Staff", "CakeQuest2", 1},
			{2275, 2299, "Head Baker", "CakeQuest2", 2},
			{2300, 2324, "Cocoa Warrior", "ChocQuest1", 1},
			{2325, 2349, "Chocolate Bar Battler", "ChocQuest1", 2},
			{2350, 2374, "Sweet Thief", "ChocQuest2", 1},
			{2375, 2399, "Candy Rebel", "ChocQuest2", 2},
			{2400, 2424, "Candy Pirate", "CandyQuest1", 1},
			{2425, 2449, "Snow Demon", "CandyQuest1", 2},
			{2450, 2474, "Isle Outlaw", "TikiQuest1", 1},
			{2475, 2499, "Island Boy", "TikiQuest1", 2},
			{2500, 2524, "Sun-kissed Warrior", "TikiQuest2", 1},
			{2525, 2549, "Isle Champion", "TikiQuest2", 2},
			{2550, 2574, "Serpent Hunter", "TikiQuest3", 1},
			{2575, 2599, "Skull Slayer", "TikiQuest3", 2},
			{2600, 2624, "Reef Bandit", "SubmergedQuest1", 1},
			{2625, 2649, "Coral Pirate", "SubmergedQuest1", 2},
			{2650, 2674, "Sea Chanter", "SubmergedQuest2", 1},
			{2675, 2699, "High Disciple", "SubmergedQuest3", 1},
			{2700, 9999, "Grand Devotee", "SubmergedQuest3", 2},
		}
	},
	BossList = {
		Sea_1 = {
			{20, "The Gorilla King", "JungleQuest", 3, CFrame.new(-1602, 37, 153)},
			{55, "Chief", "BuggyQuest1", 2, CFrame.new(-1140, 5, 3827)},
			{105, "Yeti", "SnowQuest", 3, CFrame.new(1387, 87, -1298)},
			{130, "Vice Admiral", "MarineQuest2", 2, CFrame.new(-5036, 29, 4325)},
			{220, "Warden", "ImpelQuest", 1, CFrame.new(5192, 3, 686)},
			{230, "Chief Warden", "ImpelQuest", 2, CFrame.new(5192, 3, 686)},
			{240, "Swan", "ImpelQuest", 3, CFrame.new(5192, 3, 686)},
			{350, "Magma Admiral", "MagmaQuest", 3, CFrame.new(-5315, 12, 8517)},
			{425, "Fishman Lord", "FishmanQuest", 3, CFrame.new(61123, 18, 1569)},
			{500, "Wysper", "SkyExp1Quest", 3, CFrame.new(-7862, 5546, -380)},
			{575, "Thunder God", "SkyExp2Quest", 3, CFrame.new(-7903, 5636, -1411)},
			{675, "Cyborg", "FountainQuest", 3, CFrame.new(5258, 39, 4050)},
		},
		Sea_2 = {
			{750, "Diamond", "Area1Quest", 3, CFrame.new(-428, 73, 1835)},
			{850, "Jeremy", "Area2Quest", 3, CFrame.new(637, 73, 918)},
			{925, "Orbitus", "MarineQuest3", 3, CFrame.new(-2442, 73, -3218)},
			{1150, "Smoke Admiral", "IceSideQuest", 3, CFrame.new(-5429, 16, -5298)},
			{1400, "Awakened Ice Admiral", "FrostQuest", 3, CFrame.new(5669, 29, -6483)},
			{1475, "Tide Keeper", "ForgottenQuest", 3, CFrame.new(-3054, 237, -10145)},
		},
		Sea_3 = {
			{1575, "Stone", "PiratePortQuest", 3, CFrame.new(-290, 44, 5580)},
			{1775, "Kilo Admiral", "MarineTreeIsland", 3, CFrame.new(2179, 29, -6740)},
			{1875, "Captain Elephant", "DeepForestIsland", 3, CFrame.new(-13233, 332, -7626)},
			{1950, "Beautiful Pirate", "DeepForestIsland2", 3, CFrame.new(-12682, 391, -9902)},
			{2175, "Cake Queen", "IceCreamIslandQuest", 3, CFrame.new(-819, 65, -10967)},
		}
	}
}

function hoangtuveu()
    local W = {Instances = {}}
    repeat task.wait() until game.CoreGui

    local gui = Instance.new('ScreenGui')
    gui.Name = "KaitunUI"
    gui.Parent = game:GetService('CoreGui')
    gui.Enabled = true
    gui.ResetOnSpawn = true
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = false

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Parent = gui
    container.AnchorPoint = Vector2.new(0.5, 0)
    container.Position = UDim2.new(0.5, 0, 0.01, 0)
    container.AutomaticSize = Enum.AutomaticSize.XY
    container.Size = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1

    local containerLayout = Instance.new("UIListLayout", container)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.FillDirection = Enum.FillDirection.Vertical
    containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Name = "DiscordLabel"
    discordLabel.Parent = container
    discordLabel.LayoutOrder = 1
    discordLabel.AutomaticSize = Enum.AutomaticSize.XY
    discordLabel.Size = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "BombaCat Hub"
    discordLabel.TextSize = 13
    discordLabel.Font = Enum.Font.Highway
    discordLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center

    local frame = Instance.new("Frame")
    frame.Name = "Frame"
    frame.Parent = container
    frame.LayoutOrder = 2
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(38, 30, 5)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0

    local padding = Instance.new("UIPadding", frame)
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 200, 0)
    stroke.Thickness = 1.5
    stroke.Transparency = 0

    local layout = Instance.new("UIListLayout", frame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical

    local features = Instance.new("Frame")
    features.Name = "Features"
    features.Parent = frame
    features.LayoutOrder = 1
    features.AutomaticSize = Enum.AutomaticSize.XY
    features.Size = UDim2.new(0, 0, 0, 0)
    features.BackgroundTransparency = 1

    local featLayout = Instance.new("UIListLayout", features)
    featLayout.SortOrder = Enum.SortOrder.LayoutOrder
    featLayout.Padding = UDim.new(0, 2)
    featLayout.FillDirection = Enum.FillDirection.Vertical

    local taskLabel = Instance.new("TextLabel")
    taskLabel.Name = "Task"
    taskLabel.Parent = features
    taskLabel.LayoutOrder = 1
    taskLabel.AutomaticSize = Enum.AutomaticSize.XY
    taskLabel.Size = UDim2.new(0, 0, 0, 0)
    taskLabel.BackgroundTransparency = 1
    taskLabel.Text = "Status :"
    taskLabel.TextSize = 14
    taskLabel.Font = Enum.Font.Ubuntu
    taskLabel.TextColor3 = Color3.fromRGB(255, 230, 150)
    taskLabel.TextXAlignment = Enum.TextXAlignment.Left

    local subTaskLabel = Instance.new("TextLabel")
    subTaskLabel.Name = "SubTask"
    subTaskLabel.Parent = features
    subTaskLabel.LayoutOrder = 2
    subTaskLabel.AutomaticSize = Enum.AutomaticSize.XY
    subTaskLabel.Size = UDim2.new(0, 0, 0, 0)
    subTaskLabel.BackgroundTransparency = 1
    subTaskLabel.Text = "Sub Task :"
    subTaskLabel.TextSize = 13
    subTaskLabel.Font = Enum.Font.Ubuntu
    subTaskLabel.TextColor3 = Color3.fromRGB(255, 230, 150)
    subTaskLabel.TextTransparency = 0
    subTaskLabel.TextXAlignment = Enum.TextXAlignment.Left

    W.Instances['Task1'] = taskLabel
    W.Instances['Task2'] = subTaskLabel
    W.Instances['MainTextLabel'] = taskLabel

    function SetText(key, text)
        task.spawn(function()
            local label = W.Instances[key]
            if not label then return end
            if label.Text == text then return end
            local ts = game:GetService("TweenService")
            local fadeOut = ts:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1, TextStrokeTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            label.Text = text
            local t = 0
            local fadeIn = ts:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = t, TextStrokeTransparency = t})
            fadeIn:Play()
        end)
    end
    getgenv().alert = function() end
    W.SetText = SetText
    W.ToggleUI = function() end
    W.ToggleInterface = function() end
    W.RegisterForBlur = function() end

    OldSessionTime = isfile and readfile and isfile('.tdif-' .. game.Players.LocalPlayer.Name) and tonumber(readfile(".tdif-" .. game.Players.LocalPlayer.Name)) or 0
    repeat
        task.wait()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", Config.Team)
    until game.Players.LocalPlayer.Character
    repeat wait() until game.Players.LocalPlayer.Character

    StartTick = tick()
    SetText('MainTextLabel', 'Initalizing Script..')
    ScriptStorage = {IsInitalized = false, PlayerData = {}, Melees = {}, CurrentMeleeData = {}, Enemies = {}, Tools = {}, Backpack = {}, IgnoreStoreFruits = {}, Connections = {LocalPlayer = {}}, Task = {}, Tracebacks = {}, TaskController = {}, TracebackUpdater = {}, Interface = W, NPCs = {}, Map = {}}
    Players = game.Players
    LocalPlayer = Players.LocalPlayer
    Character = Players.LocalPlayer.Character
    Humanoid = Character:WaitForChild('Humanoid')
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    PlayerGui = LocalPlayer:WaitForChild('PlayerGui', 10)
    Lighting = game:GetService('Lighting')
    Services = {}
    setmetatable(Services, {__index = function(J, J) return game:GetService(J) end})
    setmetatable(ScriptStorage.Enemies, {__index = function(J, J) return Services.Workspace.Enemies:FindFirstChild(J) or Services.ReplicatedStorage:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Map, {__index = function(J, J) return Services.Workspace.Map:FindFirstChild(J) or Services.Workspace:FindFirstChild(J) end})
    setmetatable(ScriptStorage.Tools, {__index = function(J, J) return LocalPlayer.Character:FindFirstChild(J) or (LocalPlayer:FindFirstChild('Backpack') and LocalPlayer.Backpack:FindFirstChild(J)) end})
    setmetatable(ScriptStorage.NPCs, {__index = function(J, J) if not J then return end; return workspace.NPCs:FindFirstChild(J) or game.ReplicatedStorage.NPCs:FindFirstChild(J) end})

    -- PANIC MODE + AUTO KEN
    _G.PanicModeActive = false
    task.spawn(function()
        local escapeY = nil
        while task.wait(Config.PanicMode.CheckInterval) do
            pcall(function()
                if not Config.PanicMode.Enabled then return end
                local char = LocalPlayer.Character
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")

                if not hum or not hrp or hum.Health <= 0 then
                    if _G.PanicModeActive then
                        _G.PanicModeActive = false
                        escapeY = nil
                    end
                    return
                end

                local pct = (hum.Health / hum.MaxHealth) * 100
                if not _G.PanicModeActive and pct < Config.PanicMode.LowHealthPercent then
                    pcall(function() if TweenInstance then TweenInstance:Cancel() end end)
                    _G.PanicModeActive = true
                    escapeY = hrp.Position.Y + Config.PanicMode.EscapeHeight
                    SetTask("MainTask", "⚠️ PANIC MODE | Máu " .. math.floor(pct) .. "% — bay lên trốn")
                    hrp.CFrame = CFrame.new(hrp.Position.X, escapeY, hrp.Position.Z)
                elseif _G.PanicModeActive then
                    if hrp.Position.Y < (escapeY or 0) - 50 then
                        pcall(function() if TweenInstance then TweenInstance:Cancel() end end)
                        hrp.CFrame = CFrame.new(hrp.Position.X, escapeY, hrp.Position.Z)
                    end
                    if pct >= Config.PanicMode.SafeHealthPercent then
                        SetTask("MainTask", "✅ Máu hồi " .. math.floor(pct) .. "% — bay xuống tiếp tục farm")
                        _G.PanicModeActive = false
                        escapeY = nil
                    end
                end
            end)
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if not Config.AutoKen then return end
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HasKen") then return end
                Services.ReplicatedStorage.Remotes.CommE:FireServer("Ken", true)
            end)
        end
    end)

    function SetTask(J, W)
        if ScriptStorage.Task[J] == W then return end
        local a = {MainTask = "Task1", SubTask = 'Task2'}
        if a[J] then if SetText then SetText(a[J], J .. ' : ' .. W) end end
        ScriptStorage.Task[J] = W
    end

    Remotes = {}
    BindedMeleeNPCNames = {BlackLeg = 'Dark Step Teacher', Electro = "Mad Scientist", FishmanKarate = "Water Kung-fu Teacher", DeathStep = "Phoeyu, the Reformed", SharkmanKarate = 'Sharkman Teacher', DragonTalon = "Uzoth", ElectricClaw = 'Previous Hero', Godhuman = "Ancient Monk"}
    setmetatable(Remotes, {__index = function(W, W)
        local W = {InvokeServer = function(a, ...)
            return Services.ReplicatedStorage.Remotes.CommF_:InvokeServer(...)
        end}
        return W
    end})

    function RefreshPlayerData()
        pcall(function()
            for a, a in LocalPlayer.Data:GetChildren() do 
                pcall(function() ScriptStorage.PlayerData[a.Name] = a.Value end) 
            end
        end)
    end

    function RefreshRace()
        local W, a = Remotes.CommF_:InvokeServer('Alchemist', "1"), Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        ScriptStorage.PlayerData.RaceLevel = 1
        if LocalPlayer.Character:FindFirstChild("RaceTransformed") then
            ScriptStorage.PlayerData.RaceLevel = 4
        elseif a == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 3
        elseif W == -2.0 then
            ScriptStorage.PlayerData.RaceLevel = 2
        end
    end

    function RefreshInventory()
        ScriptStorage.Backpack = {}
        for W, W in Remotes.CommF_:InvokeServer('getInventory') do ScriptStorage.Backpack[W.Name] = W end
    end

    RefreshPlayerData()
    RefreshRace()
    RefreshInventory()

    -- HAKI DO ARMAMENTO CONTÍNUO
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local character = LocalPlayer.Character
                if character and not character:FindFirstChild("HasBuso") then
                    Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end)

    TasksOrder = {
        "SpecialBossesTask", "SwordBossTask", "BossesTask",
        "RaidController", "AutoRaidIce",
        "CakePrinceTask", "MeleesController",
        "LevelFarm", "Tushita", 'Yama',
        "Saber", "CursedDualKatana", "SoulGuitar", "EvoRace", "RaceAwakening",
        'Trevor', "UtillyItemsActivitation", 'ColosseumPuzzle', "ThirdSeaPuzzle", "PirateRaid", "SecondSeaPuzzle", "CollectDrops"
    }
    MaxLevel = 2800
    placeId = game.PlaceId
    if placeId == 85211729168715 or placeId == 2753915549 then
        Sea = 'Main'
        SeaIndex = 1
    elseif placeId == 79091703265657 or placeId == 4442272183 then
        Sea = "Dressrosa"
        SeaIndex = 2
    elseif placeId == 100117331123089 or placeId == 7449423635 then
        Sea = "Zou"
        SeaIndex = 3
    end
    Portals = ({{Vector3.new(-7894.62, 5545.49, -380.25), Vector3.new(-4607.82, 872.54, -1667.56), Vector3.new(61163.85, 11.76, 1819.78), Vector3.new(3876.28, 35.11, -1939.32)}, {Vector3.new(-288.46, 306.13, 598), Vector3.new(2284.91, 15.15, 905.48), Vector3.new(923.21, 126.98, 32852.83), Vector3.new(-6508.56, 89.03, -132.84)}, {}})[SeaIndex]

    BossesOrder = {"Awakened Ice Admiral", "Tide Keeper", 'Deandre', "Urban", "Diablo", 'Soul Reaper'}
    BossesOrderLevel = {['Awakened Ice Admiral'] = 700, ['Tide Keeper'] = 700, ['Deandre'] = 1500, ['Urban'] = 1500, ['Diablo'] = 1500, ['Soul Reaper'] = 1500}
    BossesOrderWL = {["Deandre"] = 1500, ["Urban"] = 1500, ["Diablo"] = 1500, ['Don Swan'] = 1100, ["Awakened Ice Admiral"] = 700, ['Tide Keeper'] = 700}
    SpecialBossesOrder = {["Core"] = 700, ['Darkbeard'] = 700, ["Katakuri"] = 2150, ["Beautiful Pirates"] = 1500}
    HAUNTED_CASTLE_BONES_CF = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)

    function CaculateDistance(W, a)
        if not W then return 0 end
        a = a or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        return (Vector3.new(W.X, W.Y, W.Z) - Vector3.new(a.X, a.Y, a.Z)).magnitude
    end

    W_angle = W_angle or 0
    lastChange = lastChange or tick()
    CaculateCircreDirection = function(a)
        local now = tick()
        local deg = Config.OrbitDegPerSec or 120
        W_angle = (W_angle + deg * math.min(now - lastChange, 0.1)) % 360
        lastChange = now
        local h = a + Vector3.new(math.cos(math.rad(W_angle)) * 40, 0, math.sin(math.rad(W_angle)) * 40)
        return CFrame.new(h.p)
    end

    function GetMonAsSortedRange()
        local W = {}
        for _, a in pairs(Services.Workspace.Enemies:GetChildren()) do
            if a and a:FindFirstChild('Humanoid') and a:FindFirstChild("HumanoidRootPart") and a.Humanoid.Health > 0 then
                table.insert(W, a)
            end
        end
        table.sort(W, function(a, h) return CaculateDistance(a.HumanoidRootPart.CFrame) < CaculateDistance(h.HumanoidRootPart.CFrame) end)
        return W
    end

    -- ============================================================
    -- FLY CONTROLLER & TWEEN
    -- ============================================================
    local block = Instance.new("Part", workspace)
    block.Size = Vector3.new(1, 1, 1)
    block.Name = "Rip_Indra"
    block.Anchored = true
    block.CanCollide = false
    block.CanTouch = false
    block.Transparency = 1

    FlyCtl = {Goal = nil, LastCall = 0, MaxAge = 10, Active = false, Penalty = 1, PenaltyUntil = 0, LastSet = nil, LastBackoff = 0, WasOn = false}
    function FlyCtl.SpeedFor(dist)
        local base = Config.FlySpeed or 230
        local maxs = Config.FlySpeedMax or 290
        local t = math.clamp((dist - 600) / 2400, 0, 1)
        return (base + (maxs - base) * t) * FlyCtl.Penalty
    end
    function FlyCtl.SetGoal(cf)
        FlyCtl.Goal = cf
        FlyCtl.LastCall = tick()
        local c = game.Players.LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local d = r and (cf.Position - r.Position).Magnitude or 0
        FlyCtl.MaxAge = d / 60 + 5
    end

    TweenInstance = {
        PlaybackState = Enum.PlaybackState.Playing,
        Cancel = function() FlyCtl.Goal = nil end,
    }

    RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            dt = math.min(dt, 0.05)
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not block or block.Parent ~= workspace then
                getgenv().OnFarm = false
                return
            end
            local now = tick()
            local goal = FlyCtl.Goal
            if goal and (now - FlyCtl.LastCall) > FlyCtl.MaxAge then
                FlyCtl.Goal = nil; goal = nil
            end

            local active = false
            if goal then
                if not FlyCtl.Active then
                    block.CFrame = hrp.CFrame
                end
                local d0 = (goal.Position - block.Position).Magnitude
                active = d0 > 0.5 or (now - FlyCtl.LastCall) < 0.35
                if not active then FlyCtl.Goal = nil end
            end

            if active then
                FlyCtl.Active = true
                local cur = block.Position
                local delta = goal.Position - cur
                local d = delta.Magnitude
                local step = FlyCtl.SpeedFor(d) * dt
                local newPos = (d <= step) and goal.Position or (cur + delta.Unit * step)

                block.CFrame = CFrame.new(newPos)
                hrp.CFrame = block.CFrame
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                getgenv().OnFarm = true
            else
                FlyCtl.Active = false
                block.CFrame = hrp.CFrame
                getgenv().OnFarm = false
            end
        end)
    end)

    TweenController = {}
    function TweenController.Create(W)
        if not W then return end
        local a = typeof(W) ~= 'CFrame' and CFrame.new(W.X, W.Y, W.Z) or W
        FlyCtl.SetGoal(CFrame.new(a.Position))
    end

    -- ============================================================
    -- NOVO SISTEMA DE BRING MOBS INTEGRADO E OTIMIZADO
    -- ============================================================
    local BringAnchor = nil
    local BringAnchorTick = 0

    local function BringEnemy()
        if not Config.BringMobs then return end
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local enemiesFolder = workspace:FindFirstChild("Enemies")
            if not enemiesFolder then return end

            local radius = Config.BringRadius or 800
            local maxPull = Config.BringMaxMobs or 30
            local pulled = 0

            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                if pulled >= maxPull then break end
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                local root = enemy:FindFirstChild("HumanoidRootPart")
                
                if hum and root and hum.Health > 0 then
                    local dist = (root.Position - hrp.Position).Magnitude
                    if dist <= radius and dist > 8 then
                        pulled = pulled + 1
                        root.CFrame = hrp.CFrame * CFrame.new(math.random(-3, 3), 0, math.random(-5, -2))
                        root.CanCollide = false
                        root.AssemblyLinearVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                        
                        local head = enemy:FindFirstChild("Head")
                        if head then head.CanCollide = false end
                    end
                end
            end
        end)
    end

    RunService.Heartbeat:Connect(function()
        pcall(BringEnemy)
    end)

    -- ============================================================
    -- FAST ATTACK
    -- ============================================================
    local NetModules = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local RE_RegisterAttack = NetModules:WaitForChild("RE/RegisterAttack")
    local RE_RegisterHit = NetModules:WaitForChild("RE/RegisterHit")

    function GetAllBladeHits()
        local bladehits = {}
        for _, X in pairs(workspace.Enemies:GetChildren()) do
            if X:FindFirstChild('Humanoid') and X:FindFirstChild('HumanoidRootPart') and X.Humanoid.Health > 0 and (X.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 65 then
                table.insert(bladehits, X)
            end
        end
        return bladehits
    end

    local FastAttackObj = {}
    function FastAttackObj:Attack()
        local X = GetAllBladeHits()
        if #X == 0 then return end
        local y = {[1] = nil, [2] = {}, [4] = "078da5141"}
        for _, L in pairs(X) do
            RE_RegisterAttack:FireServer(0)
            if not y[1] then y[1] = L.Head end
            table.insert(y[2], {[1] = L, [2] = L.HumanoidRootPart})
            table.insert(y[2], L)
        end
        RE_RegisterHit:FireServer(unpack(y))
    end

    task.spawn(function()
        while task.wait(0.06) do
            pcall(function() FastAttackObj:Attack() end)
        end
    end)

    CombatController = {MAX_ATTACK_DURATION = 30}
    function CombatController.Attack(names)
        if type(names) == "string" then names = {names} end
        while task.wait() do
            local target = nil
            for _, name in ipairs(names) do
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == name and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        target = v
                        break
                    end
                end
                if target then break end
            end

            if target and target:FindFirstChild("HumanoidRootPart") then
                TweenController.Create(target.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0))
            else
                local reg = ScriptStorage.MobRegions and ScriptStorage.MobRegions[names[1]]
                if reg and reg[1] then
                    TweenController.Create(reg[1] + Vector3.new(0, 20, 0))
                end
            end
        end
    end

    -- REGISTOS DE FUNÇÕES
    FunctionsHandler = {Initalized = false}
    setmetatable(FunctionsHandler, {__index = function(h, X)
        local QueryResult = rawget(h, X)
        if not QueryResult then
            return {
                Register = function(w)
                    if w == false then return end
                    local Result = {CacheListener = {}, RealCache = {}, Methods = {}, Constants = {}, Events = {}, Initalized = true}
                    function Result.RegisterMethod(w, D, y)
                        w.Methods[D] = {Name = D, Callback = y, Call = function(w, ...) return w.Callback(...) end, Events = {}}
                        return true
                    end
                    FunctionsHandler[X] = Result
                end, Initalized = false
            }
        end
        return QueryResult
    end})

    FunctionsHandler.LocalPlayerController:Register()
    FunctionsHandler.LevelFarm:Register()
    FunctionsHandler.BossesTask:Register()
    FunctionsHandler.SpecialBossesTask:Register()
    FunctionsHandler.MeleesController:Register()

    FunctionsHandler.LevelFarm:RegisterMethod("Refresh", function() return 1 end)
    FunctionsHandler.LevelFarm:RegisterMethod("Start", function()
        local lv = ScriptStorage.PlayerData.Level or 1
        if lv < 10 then
            CombatController.Attack("Bandit")
        elseif lv < 70 then
            CombatController.Attack("Monkey")
        else
            CombatController.Attack("Brute")
        end
    end)

    -- INICIALIZAÇÃO DO LOOP DE TAREFAS
    while task.wait() do
        pcall(function()
            if ScriptStorage.PlayerData.Level and ScriptStorage.PlayerData.Level > 0 then
                FunctionsHandler.LevelFarm.Methods.Start:Call()
            end
        end)
    end
end

-- UI INICIAL
task.spawn(function()
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "BombaCat Ui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 50

    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
    ToggleBtn.Position = UDim2.new(0, 15, 0.5, 0)
    ToggleBtn.BackgroundColor3 = Color3.new(0, 0, 0)
    ToggleBtn.BackgroundTransparency = 0.5
    ToggleBtn.Image = "rbxthumb://type=Asset&id=113347835552896&w=420&h=420"
    ToggleBtn.Draggable = true
    
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
end)

hoangtuveu()
