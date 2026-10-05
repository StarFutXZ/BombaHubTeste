local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local localPlayer = Players.LocalPlayer
local currentCamera = Workspace.CurrentCamera
local mouse = localPlayer:GetMouse()
local str = "BF_AutoBounty_Config.json"

local tbl = {
	"Hunt_Auto",
	"Hunt_AutoRun",
	"Hunt_AutoSelect",
	"Hunt_StartWait",
	"Hunt_UseLevel",
	"Hunt_MinLevel",
	"Hunt_AllowUnknown",
	"Hunt_NoSafe",
	"Hunt_NoArena",
	"Hunt_NoMarineAlly",
	"Hunt_MaxDist",
	"Hunt_FlySpeed",
	"Hunt_StopDist",
	"Hunt_AutoSoru",
	"Hunt_SoruInterval",
	"Hunt_AutoSkill",
	"Hunt_SkillInterval",
	"Hunt_AutoHop",
	"Hunt_HopInterval",
	"Hunt_HopIfEmpty",
	"Hunt_EmptyWait",
	"Hunt_Team",
	"Hunt_HopWaitCombat",
	"Hunt_HopCombatWait",
	"G_ServerRegion",
	"G_HopPlayerRange",
	"G_HopBountyRange",
	"Hunt_AutoAttack",
	"Hunt_AutoEquip",
	"Hunt_Weapons",
	"Hunt_SkillAim",
	"Hunt_SoruAim",
	"Hunt_RotateWeapon",
	"Hunt_AutoFlee",
	"Hunt_FleeHP",
	"Hunt_FleeHeight",
	"Hunt_FleeRecover",
	"Hunt_AutoStand",
	"Hunt_HopSkyUp",
	"Hunt_HopSkyHeight",
	"Hunt_KillHop",
	"Hunt_KillHopCount",
	"Hunt_NoKilledEnough",
	"G_FastAttack",
	"G_FastAttackMode",
	"G_AttackMobs",
	"G_AttackPlayers",
	"Hunt_AutoSave",
	"G_Language",
}

local tbl2 = { "果实", "拳法", "剑", "枪" }

local tbl3 = {
	["拳法"] = { "Z", "X", "C" },
	["剑"] = { "Z", "X" },
	["枪"] = { "Z", "X" },
	["果实"] = { "Z", "X", "C", "V", "F" },
}

local flag = writefile ~= nil and readfile ~= nil and isfile ~= nil

local function fn()
	local tbl4 = {}

	for _, v in ipairs(tbl) do
		tbl4[v] = _G[v]
	end

	tbl4.Hunt_TypeSkills = {}

	for _, v in ipairs(tbl2) do
		tbl4.Hunt_TypeSkills[v] = {}

		for _, v2 in ipairs(tbl3[v]) do
			tbl4.Hunt_TypeSkills[v][v2] = _G.Hunt_TypeSkills[v][v2] ~= false
		end
	end

	tbl4.Hunt_Weapons = {}

	for _, v in ipairs(tbl2) do
		tbl4.Hunt_Weapons[v] = _G.Hunt_Weapons[v] == true
	end

	return tbl4
end

local function fn2()
	local tbl4 = {}

	for _, v in ipairs(tbl) do
		table.insert(tbl4, v .. "=" .. tostring(_G[v]))
	end

	for _, v in ipairs(tbl2) do
		for _, v2 in ipairs(tbl3[v]) do
			table.insert(tbl4, "Sk" .. v .. v2 .. "=" .. tostring(_G.Hunt_TypeSkills[v][v2]))
		end
	end

	for _, v in ipairs(tbl2) do
		table.insert(tbl4, "Weapon" .. v .. "=" .. tostring(_G.Hunt_Weapons[v]))
	end

	return table.concat(tbl4, "|")
end

local function fn3()
	if not flag then
		return false
	end

	return (pcall(function()
		writefile("BF_AutoBounty_Config.json", HttpService:JSONEncode(fn()))
	end))
end

local function fn4()
	if not flag then
		return false
	end
	local json = nil

	if not pcall(function()
		if isfile("BF_AutoBounty_Config.json") then
			json = readfile("BF_AutoBounty_Config.json")
		end
	end) or not json or json == "" then
		return false
	end

	local data = nil
	if not pcall(function()
		data = HttpService:JSONDecode(json)
	end) or type(data) ~= "table" then
		return false
	end

	for _, v in ipairs(tbl) do
		if data[v] ~= nil then
			_G[v] = data[v]
		end
	end

	if type(data.Hunt_TypeSkills) == "table" then
		for _, v in ipairs(tbl2) do
			local v2 = data.Hunt_TypeSkills[v]

			if type(v2) == "table" then
				for _, v3 in ipairs(tbl3[v]) do
					_G.Hunt_TypeSkills[v][v3] = v2[v3] ~= false
				end
			end
		end
	end

	if type(data.Hunt_Weapons) == "table" then
		for _, v in ipairs(tbl2) do
			_G.Hunt_Weapons[v] = data.Hunt_Weapons[v] == true
		end
	end

	return true
end

_G.Hunt_Auto = true
_G.Hunt_StartWait = 8
_G.Hunt_AutoSelect = true
_G.Hunt_Target = nil
_G.Hunt_UseLevel = true
_G.Hunt_MinLevel = 2100
_G.Hunt_AllowUnknown = true
_G.Hunt_NoSafe = true
_G.Hunt_NoArena = true
_G.Hunt_NoPvp = true
_G.Hunt_NoMarineAlly = true
_G.Hunt_MaxDist = 10000
_G.Hunt_FlySpeed = 160
_G.Hunt_StopDist = 6
_G.Hunt_AutoSoru = true
_G.Hunt_SoruInterval = 13
_G.Hunt_AutoSkill = true
_G.Hunt_SkillInterval = 1

_G.Hunt_TypeSkills = {
	["拳法"] = { Z = true, X = true, C = true },
	["剑"] = { Z = true, X = true },
	["枪"] = { Z = true, X = true },
	["果实"] = { Z = true, X = true, C = true, V = true, F = true },
}

_G.Hunt_AutoHop = true
_G.Hunt_HopInterval = 300
_G.Hunt_HopIfEmpty = true
_G.Hunt_EmptyWait = 15
_G.Hunt_HopWaitCombat = true
_G.Hunt_HopCombatWait = 60
_G.Hunt_Team = "不切换"
_G.Hunt_AutoAttack = true
_G.Hunt_AutoEquip = true
_G.Hunt_Weapons = { ["果实"] = true, ["拳法"] = true, ["剑"] = true, ["枪"] = true }
_G.Hunt_SkillAim = true
_G.Hunt_SoruAim = true
_G.Hunt_RotateWeapon = true
_G.Hunt_AutoFlee = true
_G.Hunt_FleeHP = 30
_G.Hunt_FleeHeight = 3500
_G.Hunt_FleeRecover = 100
_G.Hunt_FleeMaxTime = 30
_G.Hunt_AutoStand = true
_G.Hunt_HopSkyUp = true
_G.Hunt_HopSkyHeight = 3500
_G.Hunt_KillHop = true
_G.Hunt_KillHopCount = 3
_G.Hunt_NoKilledEnough = true
_G.Hunt_Fleeing = false
_G.Hunt_HopSkyTimer = false
_G.Hunt_HopSkyEmpty = false
_G.Hunt_ForceHop = false
_G.Hunt_HopTimer = nil
_G.Hunt_RotateIndex = 1

pcall(function()
	getgenv().IsServerHopping = false
end)

_G.Hunt_AutoHaki = true
_G.Hunt_AutoKen = true
_G.Hunt_AutoV3 = true
_G.Hunt_AutoV4 = true
_G.Hunt_AutoRun = true
_G.Hunt_AutoSave = true
_G.G_FastAttack = false
_G.G_FastAttackMode = "模式2(部分账号失效用)"
_G.G_AttackMobs = true
_G.G_AttackPlayers = true
_G.G_Language = _G.G_Language or "中文"
local v = fn4()
_G.Hunt_AutoAttack = true
local v2 = fn2()

task.spawn(function()
	while task.wait(2) do
		if _G.Hunt_AutoSave and flag then
			local v3 = fn2()

			if v3 ~= v2 then
				if fn3() then
					v2 = v3
				end
			end
		end
	end
end)

_G.G_ServerRegion = _G.G_ServerRegion or "Singapore"
_G.G_HopPlayerRange = _G.G_HopPlayerRange or "1-12"
_G.G_HopBountyRange = _G.G_HopBountyRange or "大于3m"
_G.G_HopMinPlayers = _G.G_HopMinPlayers or 1
_G.G_HopMaxPlayers = _G.G_HopMaxPlayers or 12
_G.G_HopMinBounty = _G.G_HopMinBounty or 3000001
_G.G_HopMaxBounty = _G.G_HopMaxBounty or 999999999

local function fn5(arg)
	local match, v3, v4 = tostring(math.floor(tonumber(arg) or 0)):match("^([^%d]*%d)(%d*)(.-)$")
	return match .. v3:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. v4
end

local function fn6(gHopPlayerRange)
	_G.G_HopPlayerRange = gHopPlayerRange
	local match, v3 = gHopPlayerRange:match("(%d+)%-(%d+)")

	if match and v3 then
		_G.G_HopMinPlayers = tonumber(match)
		_G.G_HopMaxPlayers = tonumber(v3)
		return
	end

	_G.G_HopMinPlayers = 1
	_G.G_HopMaxPlayers = 12
end

local function fn7(gHopBountyRange)
	_G.G_HopBountyRange = gHopBountyRange
	local match = gHopBountyRange:match("大于([%d%.]+[Mm]?)")

	if match then
		local match2, v3 = match:match("([%d%.]+)([Mm]?)")
		local n = tonumber(match2) or 0

		if v3 and v3:lower() == "m" then
			n *= 1000000
		end

		_G.G_HopMinBounty = n + 1
		_G.G_HopMaxBounty = 999999999
		return
	end

	_G.G_HopMinBounty = 0
	_G.G_HopMaxBounty = 999999999
end

local function fn8(arg)
	if type(arg) ~= "string" or arg == "" then
		return nil
	end
	local match = arg:match("Region:%s*(.-)%s*%-%s*Players:")
	local match2, v3 = arg:match("Players:%s*(%d+)%s*/%s*(%d+)")
	local match3 = arg:match("Bounty:%s*([%d,]+)")
	if not match2 or not v3 or not match3 then
		return nil
	end
	local v4 = tonumber
	local str2 = match3:gsub(",", "")
	local v5 = v4(str2)
	if not v5 then
		return nil
	end
	return { Region = match or "Unknown", Players = tonumber(match2), MaxPlayers = tonumber(v3), Bounty = v5 }
end

local function fn9(arg)
	if not arg then
		return false
	end

	if arg.MaxPlayers and arg.Players >= arg.MaxPlayers then
		return false
	end

	if arg.Players < _G.G_HopMinPlayers or arg.Players > _G.G_HopMaxPlayers then
		return false
	end

	if arg.Bounty < _G.G_HopMinBounty or arg.Bounty > _G.G_HopMaxBounty then
		return false
	end
	return true
end

fn6(_G.G_HopPlayerRange)
fn7(_G.G_HopBountyRange)

local tbl4 = {
	"https://raw.githubusercontent.com/kismile36/script/refs/heads/main/autobounty",
	"https://cdn.jsdelivr.net/gh/kismile36/script@main/autobounty",
}

local str2 = "AutoBounty.file"
local queueOnTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport
local queueOnTeleport2

if queueOnTeleport then
	queueOnTeleport2 = queueOnTeleport
else
	queueOnTeleport2 = fluxus and fluxus.queue_on_teleport
end

if isfile and isfile("AutoBounty.file") then
	local ok, result = pcall(function()
		return readfile("AutoBounty.file")
	end)

	_G.AutoExecute = ok and result == "true"
else
	_G.AutoExecute = true

	if writefile then
		pcall(function()
			writefile("AutoBounty.file", "true")
		end)
	end
end

local function fn10(arg)
	local tbl5 = {}

	for _, v3 in ipairs(arg) do
		tbl5[#tbl5 + 1] = "\"" .. v3 .. "\""
	end

	return "{" .. table.concat(tbl5, ", ") .. "}"
end

local str3 = "local NAME = \"" .. "kiyo hub auto bounty" .. [["
local ok, err = pcall(function()
	if isfile and isfile("AutoBounty.file") and readfile("AutoBounty.file") ~= "true" then
		warn("[猎赏] 换服后自动重跑是关的（AutoBounty.file 不是 true）")
		return
	end
	local urls = ]] .. fn10(tbl4) .. [[	local lastErr
	for _, u in ipairs(urls) do
		local got, src = pcall(function() return game:HttpGet(u) end)
		if got and src and src ~= "" then
			-- 线上那份可能是旧名字：把脚本名/面板标题强行改成 NAME，保证换服后名字不变
			src = src:gsub("local SCRIPT_NAME%s*=%s*\"[^\"]*\"", "local SCRIPT_NAME = \"" .. NAME .. "\"")
			src = src:gsub("(CreateWindow%s*%(%s*{%s*Title%s*=%s*)\"[^\"]*\"", "%1\"" .. NAME .. "\"")
			src = src:gsub("自动猎赏 已加载", NAME .. " 已加载")
			print("[猎赏] 传送完成，正在重新加载脚本: " .. u)
			loadstring(src)()
			return
		end
		lastErr = src
	end
	error("所有地址都加载失败，最后一个错误: " .. tostring(lastErr))
end)
if not ok then
	warn("[猎赏] 传送后自动重跑失败: " .. tostring(err) .. "（检查脚本地址是否可访问、是否已更新）")
end]]

local flag2 = false

local function fn11()
	if flag2 then
		return
	end

	if _G.AutoExecute ~= true then
		print("[猎赏] 换服后自动重跑: 关（AutoBounty.file 内容不是 true）")
		return
	end

	if type(queueOnTeleport2) ~= "function" then
		warn("[猎赏] 当前执行器不支持 queue_on_teleport -> 换服后需手动重新注入（或把脚本放进执行器 autoexec 文件夹）")
		return
	end
	local ok, result = pcall(queueOnTeleport2, str3)

	if ok then
		flag2 = true
		print("[猎赏] 已排队 -> 传送完成后自动重新加载脚本（本次会话只排一次，不会跑两遍）")
	else
		warn("[猎赏] 排队自动重跑失败: " .. tostring(result))
	end
end

local function fn12()
	fn11()
	local tbl5 = { "teleport", game.JobId }

	local ok = pcall(function()
		ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer(unpack(tbl5))
	end)

	print(ok and "[猎赏] 已请求重进当前服务器" or "[猎赏] 重进失败")
	return ok
end

_G.G_RemoveLava = true
_G.G_WalkOnWater = true

local function fn13(arg)
	if not arg then
		return
	end
	local name = arg.Name

	if name == "Lava" then
		pcall(function()
			arg:Destroy()
		end)
	elseif name == "LavaParts" then
		local parent = arg.Parent

		if parent then
			local name2 = parent.Name

			if name2 == "CircleIsland" or name2 == "GhostShipInterior" then
				local parent2 = parent.Parent

				if parent2 and parent2.Name == "Map" then
					pcall(function()
						arg:Destroy()
					end)
				end
			end
		end
	end
end

local function fn14()
	task.spawn(function()
		pcall(function()
			local n = 0

			for _, descendant in pairs(Workspace:GetDescendants()) do
				fn13(descendant)
				n += 1

				if n % 500 == 0 then
					task.wait()
				end
			end

			for _, descendant in pairs(ReplicatedStorage:GetDescendants()) do
				fn13(descendant)
				n += 1

				if n % 500 == 0 then
					task.wait()
				end
			end
		end)

		print("[猎赏] 已移除岩浆 (需重进恢复)")
	end)
end

local flag3 = false

local function fn15()
	if flag3 then
		return
	end
	flag3 = true

	task.spawn(function()
		while task.wait(0.2) do
			if _G.G_WalkOnWater then
				pcall(function()
					local waterBasePlane = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("WaterBase-Plane")

					if waterBasePlane then
						waterBasePlane.Size = Vector3.new(1000, 112, 1000)
					end
				end)

				continue
			end

			break
		end

		flag3 = false
	end)
end

local function fn16()
	_G.G_WalkOnWater = false

	pcall(function()
		local waterBasePlane = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("WaterBase-Plane")

		if waterBasePlane then
			waterBasePlane.Size = Vector3.new(1000, 80, 1000)
		end
	end)
end

fn14()
fn15()
_G.G_LowGraphics = true

local function fn17(arg)
	if arg:IsA("Part") or arg:IsA("Union") or arg:IsA("CornerWedgePart") or arg:IsA("TrussPart") then
		arg.Material = "Plastic"
		arg.Reflectance = 0
	elseif arg:IsA("Decal") or arg:IsA("Texture") then
		arg.Transparency = 1
	elseif arg:IsA("ParticleEmitter") or arg:IsA("Trail") then
		arg.Lifetime = NumberRange.new(0)
	elseif arg:IsA("Explosion") then
		arg.BlastPressure = 1
		arg.BlastRadius = 1
	elseif arg:IsA("Fire") or arg:IsA("SpotLight") or arg:IsA("Smoke") then
		arg.Enabled = false
	end
end

local function fn18()
	task.spawn(function()
		pcall(function()
			local n = 0

			for _, descendant in pairs(game:GetDescendants()) do
				fn17(descendant)
				n += 1

				if n % 500 == 0 then
					task.wait()
				end
			end
		end)

		print("[猎赏] 减画质: 已完成全图处理")
	end)
end

fn18()

Workspace.DescendantAdded:Connect(function(descendant)
	if _G.G_LowGraphics then
		pcall(fn17, descendant)
	end
end)

pcall(function()
	local VirtualUser = game:GetService("VirtualUser")

	localPlayer.Idled:Connect(function()
		pcall(function()
			VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
		end)

		print("[猎赏] Anti-AFK: 已模拟鼠标输入，避免被踢出")
	end)
end)

task.spawn(function()
	while task.wait(0.5) do
		if _G.Hunt_AutoStand then
			local character = localPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 and humanoid.Sit then
				if pcall(function()
					humanoid.Sit = false
					humanoid.Jump = true
				end) then
					pcall(function()
						VirtualInputManager:SendKeyEvent(true, "Space", false, game)
						task.wait(0.05)
						VirtualInputManager:SendKeyEvent(false, "Space", false, game)
					end)

					print("[猎赏] 检测到坐在椅子上 -> 已自动站起")
				end
			end
		end
	end
end)

local n = 5000

local function fn19(arg)
	if not arg then
		return false
	end
	local humanoid = arg:FindFirstChildOfClass("Humanoid")
	return humanoid and humanoid.Health and humanoid.Health > 0
end

local function fn20(arg)
	if not arg then
		return nil
	end
	local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil
	end
	local tbl5 = {}
	local head = arg:FindFirstChild("Head")
	local upperTorso = arg:FindFirstChild("UpperTorso")
	local lowerTorso = arg:FindFirstChild("LowerTorso")
	local torso = arg:FindFirstChild("Torso")
	tbl5[1] = head
	tbl5[2] = upperTorso
	tbl5[3] = lowerTorso
	tbl5[4] = torso
	tbl5[5] = humanoidRootPart
	local tbl6 = {}

	for _, v3 in ipairs(tbl5) do
		if v3 and v3:IsA("BasePart") then
			table.insert(tbl6, v3)
		end
	end

	if #tbl6 > 0 then
		return tbl6[math.random(1, #tbl6)]
	end
	return humanoidRootPart
end

local tbl5 = {
	consecutiveFailures = 0,
	maxConsecutiveFailures = 5,
	Remotes = nil,
	Net = nil,
	RegisterAttack = nil,
	RegisterHit = nil,
	Enemies = nil,
}

local function fn21()
	if tbl5.Remotes and tbl5.Net and tbl5.RegisterAttack and tbl5.RegisterHit and tbl5.Enemies then
		return tbl5.Remotes, tbl5.Net, tbl5.RegisterAttack, tbl5.RegisterHit, tbl5.Enemies
	end
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local modules = ReplicatedStorage:FindFirstChild("Modules")
	local net = modules and modules:FindFirstChild("Net")
	local reRegisterAttack = net and (net:FindFirstChild("RE/RegisterAttack") or net:FindFirstChild("RegisterAttack"))
	local reRegisterHit = net and (net:FindFirstChild("RE/RegisterHit") or net:FindFirstChild("RegisterHit"))
	local enemies = Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("NPCs")

	if remotes and modules and net and reRegisterAttack and reRegisterHit and enemies then
		tbl5.Remotes = remotes
		tbl5.Net = net
		tbl5.RegisterAttack = reRegisterAttack
		tbl5.RegisterHit = reRegisterHit
		tbl5.Enemies = enemies
		return remotes, net, reRegisterAttack, reRegisterHit, enemies
	end

	return nil, nil, nil, nil, nil
end

local function fn22(arg, arg2)
	if not arg2 or not _G.G_AttackMobs then
		return nil
	end
	local position = localPlayer.Character and localPlayer.Character.PrimaryPart and localPlayer.Character.PrimaryPart.Position
	if not position then
		return nil
	end
	local v3 = nil

	for _, child in ipairs(arg2:GetChildren()) do
		if not (child == localPlayer.Character or not fn19(child)) then
			local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				if (humanoidRootPart.Position - position).Magnitude < 500 then
					local v4 = fn20(child)

					if v4 then
						table.insert(arg, { child, v4 })
						v3 = v4
					end
				end
			end
		end
	end

	return v3
end

local function fn23(arg)
	if not _G.G_AttackPlayers then
		return nil
	end

	if not (localPlayer.Character and localPlayer.Character.PrimaryPart and localPlayer.Character.PrimaryPart.Position) then
		return nil
	end
	local v3 = nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local character = player.Character

			if fn19(character) then
				local v4 = fn20(character)

				if v4 and localPlayer:DistanceFromCharacter(v4.Position) < 500 then
					table.insert(arg, { character, v4 })
					v3 = v4
				end
			end
		end
	end

	return v3
end

local function fn24(arg, arg2)
	local v3, v4, v5, v6 = fn21()

	if not (arg and arg2 and #arg2 > 0 and v5 and v6) then
		tbl5.consecutiveFailures = tbl5.consecutiveFailures + 1

		if tbl5.maxConsecutiveFailures <= tbl5.consecutiveFailures then
			tbl5.Remotes = nil
			tbl5.Net = nil
			tbl5.RegisterAttack = nil
			tbl5.RegisterHit = nil
			tbl5.Enemies = nil
			tbl5.consecutiveFailures = 0
		end

		return
	end

	tbl5.consecutiveFailures = 0

	if not pcall(function()
		v5:FireServer(0.3)
		v6:FireServer(arg, arg2)
	end) then
		tbl5.RegisterAttack = nil
		tbl5.RegisterHit = nil
	end
end

local function fn25()
	local v3, v4, v5, v6, v7 = fn21()
	if not v7 then
		tbl5.Enemies = nil
		return
	end
	local tbl6 = {}
	local v8 = fn22(tbl6, v7)
	local v9 = fn23(tbl6)

	if #tbl6 > 0 then
		fn24(v8 or v9, tbl6)
	end
end

local tbl6 = { Found = nil, Id = nil }

local function fn26(child)
	if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
		tbl6.Id = child:GetAttribute("Id")
		tbl6.Found = child
	end
end

task.spawn(function()
	local tbl7 = {}
	local util = ReplicatedStorage:FindFirstChild("Util")
	local common = ReplicatedStorage:FindFirstChild("Common")
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local findFirstChild = ReplicatedStorage.FindFirstChild
	tbl7[1] = util
	tbl7[2] = common
	tbl7[3] = remotes
	tbl7[4] = assets

	do
		local values = table.pack(findFirstChild(ReplicatedStorage, "FX"))
		table.move(values, 1, values.n, 5, tbl7)
	end

	for _, v3 in ipairs(tbl7) do
		if v3 then
			for _, child in ipairs(v3:GetChildren()) do
				fn26(child)
			end

			v3.ChildAdded:Connect(fn26)
		end
	end
end)

local function fn27()
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return {}
	end
	local tbl7 = {}
	local position = humanoidRootPart.Position
	local findFirstChild = Workspace.FindFirstChild

	for _, v3 in ipairs({ Workspace:FindFirstChild("Enemies"), findFirstChild(Workspace, "Characters") }) do
		if v3 then
			for _, child in ipairs(v3:GetChildren()) do
				if child ~= character then
					local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
					local humanoid = child:FindFirstChild("Humanoid")

					if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
						if (humanoidRootPart2.Position - position).Magnitude <= n then
							table.insert(tbl7, { Model = child, Root = humanoidRootPart2, Head = child:FindFirstChild("Head") or humanoidRootPart2 })
						end
					end
				end
			end
		end
	end

	return tbl7
end

local function fn28()
	local character = localPlayer.Character
	if not character then
		return
	end

	if not (character:FindFirstChildOfClass("Tool") or character:FindFirstChild("EquippedWeapon")) then
		return
	end
	local v3 = fn27()
	if #v3 == 0 then
		return
	end
	local modules = ReplicatedStorage:FindFirstChild("Modules")
	local net = modules and modules:FindFirstChild("Net")
	local reRegisterAttack = net and (net:FindFirstChild("RE/RegisterAttack") or net:FindFirstChild("RegisterAttack"))
	local reRegisterHit

	if net then
		reRegisterHit = net:FindFirstChild("RE/RegisterHit") or net:FindFirstChild("RegisterHit")
	else
		reRegisterHit = net
	end

	if not reRegisterAttack or not reRegisterHit then
		return
	end
	local v4 = v3[1]
	local tbl7 = {}

	for _, v5 in ipairs(v3) do
		table.insert(tbl7, { v5.Model, v5.Root })
	end

	reRegisterAttack:FireServer()
	local str4 = tostring(localPlayer.UserId):sub(2, 4) .. tostring(math.random(10000, 99999))

	pcall(function()
		reRegisterHit:FireServer(v4.Head, tbl7, {}, str4)
	end)

	if tbl6.Found and tbl6.Id then
		pcall(function()
			local seed = net:FindFirstChild("seed")
			local v5 = bit32.bxor(tbl6.Id + 909090, (seed and seed:InvokeServer() or 1) * 2)
			local n2 = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
			local head = v4.Head

			tbl6.Found:FireServer(string.gsub("RE/RegisterHit", ".", function(arg)
				return string.char(bit32.bxor(string.byte(arg), n2))
			end), v5, head, tbl7)
		end)
	end
end

local function fn29()
	if not _G.G_FastAttack then
		return
	end

	if _G.G_FastAttackMode == "模式1" then
		local character = localPlayer.Character
		local tool = character and fn19(character) and character:FindFirstChildOfClass("Tool")
		if not tool or tool.ToolTip == "Gun" then
			return
		end
		fn25()
	else
		fn28()
	end
end

task.spawn(function()
	while true do
		if not _G.G_FastAttack then
			task.wait(0.3)
		else
			local now = tick()
			pcall(fn29)
			if _G.G_FastAttackMode == "模式1" then
				task.wait(0.3)
				continue
			end
			task.wait(math.max(0.05 - tick() - now, 0.001))
		end
	end
end)

local fn30 = nil
local fn31 = nil
local fn32 = nil
local fn33 = nil
local fn34 = nil
local tbl7 = {}

local function fn35(arg, arg2)
	local v3 = tbl7[arg]

	if v3 then
		pcall(function()
			v3:Set(arg2)
		end)
	end
end

local function fn36(huntAuto)
	_G.Hunt_Auto = huntAuto
	_G.Hunt_AutoSoru = huntAuto
	_G.Hunt_AutoSkill = huntAuto
	_G.Hunt_AutoAttack = huntAuto
	_G.Hunt_AutoEquip = huntAuto
	_G.Hunt_SkillAim = huntAuto
	_G.Hunt_SoruAim = huntAuto
	_G.Hunt_AutoHop = huntAuto
	fn35("Hunt_Auto", huntAuto)
	fn35("Hunt_AutoSoru", huntAuto)
	fn35("Hunt_AutoSkill", huntAuto)
	fn35("Hunt_AutoAttack", huntAuto)
	fn35("Hunt_AutoEquip", huntAuto)
	fn35("Hunt_SkillAim", huntAuto)
	fn35("Hunt_SoruAim", huntAuto)
	fn35("Hunt_AutoHop", huntAuto)
	print("[猎赏] 自动执行: " .. (huntAuto and "已开启，全部功能已打开" or "已关闭"))
end

local tbl8 = {
	["中文"] = {},
	English = {
		["猎赏"] = "Bounty Hunt",
		["战斗"] = "Combat",
		["杀戮光环"] = "Kill Aura",
		["移动"] = "Movement",
		["环境"] = "Environment",
		["服务器"] = "Server",
		["设置"] = "Settings",
		["总控"] = "Master Control",
		["自动执行脚本 (一键全开)"] = "Auto Run Script (Enable All)",
		["狩猎设置"] = "Hunt Settings",
		["自动猎赏"] = "Auto Hunt",
		["自动选择玩家"] = "Auto Select Player",
		["进服务器后等待 (秒)"] = "Wait After Joining (s)",
		["自动攻击（保持开启）"] = "Auto Attack (Always On)",
		["自动装备 "] = "Auto Equip ",
		["武器类型"] = "Weapon Type",
		["等级过滤"] = "Level Filter",
		["启用等级过滤"] = "Enable Level Filter",
		["最低等级"] = "Minimum Level",
		["等级未知也打"] = "Attack If Level Unknown",
		["目标过滤"] = "Target Filter",
		["排除安全区的人"] = "Exclude Safe Zone Players",
		["排除竞技场里的人"] = "Exclude Colosseum Players",
		["只猎开战斗模式(PvP)的玩家"] = "Only Hunt Players With PvP On",
		["强制开启，不受开关和存档影响"] = "Forced on, ignores toggles and saved config",
		["排除海军盟友"] = "Exclude Marine Allies",
		["换人距离 (米)"] = "Target Switch Distance (m)",
		["霸气 / 种族"] = "Haki / Race",
		["自动武装色 (Buso)"] = "Auto Buso (Armament)",
		["自动见闻色 (Ken)"] = "Auto Ken (Observation)",
		["自动 V3"] = "Auto Race V3",
		["自动 V4"] = "Auto Race V4",
		["瞬步（限龙族"] = "Soru (Dragon Race Only",
		["自动瞬步"] = "Auto Soru",
		["瞬步间隔 (秒)"] = "Soru Interval (s)",
		["立即瞬步 (测试用)"] = "Soru Now (Test)",
		["瞬步自瞄 (冲向锁定目标)"] = "Soru Aim (Dash To Locked Target)",
		["低血逃生"] = "Low HP Escape",
		["低血自动往天上飞"] = "Fly Up When Low HP",
		["触发血量 (%)"] = "Trigger HP (%)",
		["上升高度 (米)"] = "Rise Height (m)",
		["恢复猎赏血量 (%)"] = "Resume Hunt HP (%)",
		["技能释放 (可多选)"] = "Skills (Multi-select)",
		["自动释放技能"] = "Auto Use Skills",
		["技能自瞄 (只瞄锁定目标)"] = "Skill Aim (Locked Target Only)",
		["技能放完自动换下一把武器"] = "Auto Switch Weapon After Skills",
		["技能间隔 (秒)"] = "Skill Interval (s)",
		["立即放技能 (测试用)"] = "Use Skills Now (Test)",
		["拳法 技能 (3 个)"] = "Melee Skills (3)",
		["剑 技能 (2 个)"] = "Sword Skills (2)",
		["枪 技能 (2 个)"] = "Gun Skills (2)",
		["果实 技能 (5 个)"] = "Fruit Skills (5)",
		["拳法 - Z"] = "Melee - Z",
		["拳法 - X"] = "Melee - X",
		["拳法 - C"] = "Melee - C",
		["剑 - Z"] = "Sword - Z",
		["剑 - X"] = "Sword - X",
		["枪 - Z"] = "Gun - Z",
		["枪 - X"] = "Gun - X",
		["果实 - Z"] = "Fruit - Z",
		["果实 - X"] = "Fruit - X",
		["果实 - C"] = "Fruit - C",
		["果实 - V"] = "Fruit - V",
		["果实 - F"] = "Fruit - F",
		["飞行"] = "Flight",
		["飞行速度"] = "Fly Speed",
		["停靠距离"] = "Stop Distance",
		["站立"] = "Standing",
		["坐在椅子上自动站起"] = "Auto Stand Up From Chairs",
		["移除岩浆 (需重进恢复)"] = "Remove Lava (Rejoin To Restore)",
		["水上行走"] = "Walk On Water",
		["画质"] = "Graphics",
		["减画质 (持续开启)"] = "Reduce Graphics (Always On)",
		["果实"] = "Fruit",
		["拳法"] = "Melee",
		["剑"] = "Sword",
		["枪"] = "Gun",
		["快速攻击"] = "Fast Attack",
		["开启快速攻击"] = "Enable Fast Attack",
		["快速攻击模式"] = "Fast Attack Mode",
		["模式1"] = "Mode 1",
		["模式2(部分账号失效用)"] = "Mode 2 (Use If Mode 1 Fails)",
		["攻击怪物"] = "Attack Mobs",
		["攻击玩家"] = "Attack Players",
		["自动跳服务器"] = "Auto Server Hop",
		["换服后自动重跑脚本"] = "Auto Reload Script After Hop",
		["跳服间隔 (秒)"] = "Hop Interval (s)",
		["选择服务器区域"] = "Server Region",
		["选择人数"] = "Player Count",
		["选择赏金"] = "Bounty",
		["大于3m"] = "Above 3M",
		["大于5m"] = "Above 5M",
		["大于10m"] = "Above 10M",
		["大于15m"] = "Above 15M",
		["大于25m"] = "Above 25M",
		["大于35m"] = "Above 35M",
		["大于50m"] = "Above 50M",
		["立即跳服务器"] = "Hop Server Now",
		["重进服务器"] = "Rejoin Server",
		["等战斗结束再跳服"] = "Wait For Fight To End Before Hop",
		["战斗结束最多等 (秒)"] = "Max Wait For Fight End (s)",
		["没人开战斗模式就跳服"] = "Hop When Nobody Has PvP On",
		["空服判定时长 (秒)"] = "Empty Server Detect Time (s)",
		["跳服前先飞到天上等"] = "Fly Up Before Hop",
		["跳服前飞天高度 (米)"] = "Pre-Hop Fly Height (m)",
		["击杀换服"] = "Hop After Kills",
		["同一个玩家打死 N 次就跳服"] = "Hop After Killing Same Player N Times",
		["击杀次数 N"] = "Kill Count N",
		["过滤已打死 N 次的玩家"] = "Filter Players Already Killed N Times",
		["阵营 (换服后自动选)"] = "Team (Auto Pick After Hop)",
		["阵营"] = "Team",
		["不切换"] = "Don't Switch",
		["海盗"] = "Pirate",
		["海军"] = "Marine",
		["立即切换阵营"] = "Switch Team Now",
		["手动指定目标"] = "Manual Target",
		["选择玩家"] = "Select Player",
		["刷新玩家列表"] = "Refresh Player List",
		["清除指定目标 (回到自动)"] = "Clear Target (Back To Auto)",
		["配置"] = "Config",
		["自动保存配置"] = "Auto Save Config",
		["立即保存配置"] = "Save Config Now",
		["重置为默认配置 (需重载)"] = "Reset To Default (Reload Needed)",
		["语言"] = "Language",
		["点一下切换"] = "click to switch",
		["语言已切换为: "] = "Language switched to: ",
		["重新执行脚本后面板文案生效"] = "panel text applies after you re-run the script",
	},
}

local function fn37(arg)
	if _G.G_Language == "English" and tbl8.English[arg] then
		return tbl8.English[arg]
	end
	return arg
end

local function fn38(arg)
	if _G.G_Language == "English" then
		for k, v3 in pairs(tbl8.English) do
			if v3 == arg then
				return k
			end
		end
	end

	return arg
end

local v3 = nil
print("[猎赏] 正在加载界面库 WindUI (约 1.3MB，请稍等) ...")

for i, v4 in ipairs({
	"https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
	"https://cdn.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua",
}) do
	local ok, result = pcall(function()
		local response = game:HttpGet(v4)

		if not response or response == "" then
			error("返回内容为空")
		end

		return loadstring(response)()
	end)

	if ok and result ~= nil then
		v3 = result
		print("[猎赏] 界面库加载成功 (第 " .. i .. " 个源)")
		break
	else
		warn("[猎赏] 界面库加载失败 (第 " .. i .. " 个源): " .. tostring(v4) .. " -> " .. tostring(result))
	end
end

if not v3 then
	warn("[猎赏] 界面库全部失败，界面不会出现；自动猎赏等其它功能照常运行")
end

if v3 then
	local v4 = v3:CreateWindow({
		Title = "kiyo hub auto bounty",
		Icon = "sword",
		Author = "kiyo",
		Folder = "WindUI",
		Size = UDim2.fromOffset(460, 400),
		Transparent = true,
		Theme = "Dark",
		Acrylic = false,
		HideSearchBar = false,
		SideBarWidth = 170,
		ToggleKey = Enum.KeyCode.G,
	})

	local v5 = v4:Tab({ Title = fn37("猎赏"), Icon = "crosshair" })
	local v6 = v4:Tab({ Title = fn37("战斗"), Icon = "sword" })
	local v7 = v4:Tab({ Title = fn37("杀戮光环"), Icon = "zap" })
	local v8 = v4:Tab({ Title = fn37("移动"), Icon = "wind" })
	local v9 = v4:Tab({ Title = fn37("环境"), Icon = "monitor" })
	local v10 = v4:Tab({ Title = fn37("服务器"), Icon = "server" })
	local v11 = v4:Tab({ Title = fn37("设置"), Icon = "settings" })
	v5:Section({ Title = fn37("总控") })

	v5:Toggle({
		Title = fn37("自动执行脚本 (一键全开)"),
		Value = _G.Hunt_AutoRun,
		Callback = function(huntAutoRun)
			_G.Hunt_AutoRun = huntAutoRun
			fn36(huntAutoRun)
		end,
	})

	v5:Section({ Title = fn37("狩猎设置") })

	tbl7.Hunt_Auto = v5:Toggle({
		Title = fn37("自动猎赏"),
		Value = _G.Hunt_Auto,
		Callback = function(huntAuto)
			_G.Hunt_Auto = huntAuto
		end,
	})

	v5:Toggle({
		Title = fn37("自动选择玩家"),
		Value = _G.Hunt_AutoSelect,
		Callback = function(huntAutoSelect)
			_G.Hunt_AutoSelect = huntAutoSelect
		end,
	})

	v5:Slider({
		Title = fn37("进服务器后等待 (秒)"),
		Value = { Min = 0, Max = 60, Default = _G.Hunt_StartWait },
		Callback = function(huntStartWait)
			_G.Hunt_StartWait = huntStartWait
		end,
	})

	tbl7.Hunt_AutoAttack = v5:Toggle({
		Title = fn37("自动攻击（保持开启）"),
		Value = _G.Hunt_AutoAttack,
		Callback = function(huntAutoAttack)
			_G.Hunt_AutoAttack = huntAutoAttack
		end,
	})

	tbl7.Hunt_AutoEquip = v5:Toggle({
		Title = fn37("自动装备 "),
		Value = _G.Hunt_AutoEquip,
		Callback = function(huntAutoEquip)
			_G.Hunt_AutoEquip = huntAutoEquip
		end,
	})

	for _, v12 in ipairs(tbl2) do
		tbl7["Weapon_" .. v12] = v5:Toggle({
			Title = fn37("武器类型") .. ": " .. fn37(v12),
			Value = _G.Hunt_Weapons[v12],
			Callback = function(arg)
				_G.Hunt_Weapons[v12] = arg
			end,
		})
	end

	v5:Section({ Title = fn37("等级过滤") })

	v5:Toggle({
		Title = fn37("启用等级过滤"),
		Value = _G.Hunt_UseLevel,
		Callback = function(huntUseLevel)
			_G.Hunt_UseLevel = huntUseLevel
		end,
	})

	v5:Slider({
		Title = fn37("最低等级"),
		Value = { Min = 1, Max = 2800, Default = _G.Hunt_MinLevel },
		Callback = function(huntMinLevel)
			_G.Hunt_MinLevel = huntMinLevel
		end,
	})

	v5:Toggle({
		Title = fn37("等级未知也打"),
		Value = _G.Hunt_AllowUnknown,
		Callback = function(huntAllowUnknown)
			_G.Hunt_AllowUnknown = huntAllowUnknown
		end,
	})

	v5:Section({ Title = fn37("目标过滤") })

	v5:Toggle({
		Title = fn37("排除安全区的人"),
		Value = _G.Hunt_NoSafe,
		Callback = function(huntNoSafe)
			_G.Hunt_NoSafe = huntNoSafe
		end,
	})

	v5:Toggle({
		Title = fn37("排除竞技场里的人"),
		Value = _G.Hunt_NoArena,
		Callback = function(huntNoArena)
			_G.Hunt_NoArena = huntNoArena
		end,
	})

	v5:Paragraph({ Title = fn37("只猎开战斗模式(PvP)的玩家"), Desc = fn37("强制开启，不受开关和存档影响") })

	v5:Toggle({
		Title = fn37("排除海军盟友"),
		Value = _G.Hunt_NoMarineAlly,
		Callback = function(huntNoMarineAlly)
			_G.Hunt_NoMarineAlly = huntNoMarineAlly
		end,
	})

	v5:Slider({
		Title = fn37("换人距离 (米)"),
		Value = { Min = 500, Max = 50000, Default = _G.Hunt_MaxDist },
		Callback = function(huntMaxDist)
			_G.Hunt_MaxDist = huntMaxDist
		end,
	})

	v6:Section({ Title = fn37("瞬步（限龙族") })

	tbl7.Hunt_AutoSoru = v6:Toggle({
		Title = fn37("自动瞬步"),
		Value = _G.Hunt_AutoSoru,
		Callback = function(huntAutoSoru)
			_G.Hunt_AutoSoru = huntAutoSoru
		end,
	})

	v6:Slider({
		Title = fn37("瞬步间隔 (秒)"),
		Value = { Min = 1, Max = 60, Default = _G.Hunt_SoruInterval },
		Callback = function(huntSoruInterval)
			_G.Hunt_SoruInterval = huntSoruInterval
		end,
	})

	v6:Button({
		Title = fn37("立即瞬步 (测试用)"),
		Callback = function()
			fn30()
			print("[猎赏] 瞬步测试 -> 已发送瞬步发包 (CommE)")
		end,
	})

	tbl7.Hunt_SoruAim = v6:Toggle({
		Title = fn37("瞬步自瞄 (冲向锁定目标)"),
		Value = _G.Hunt_SoruAim,
		Callback = function(huntSoruAim)
			_G.Hunt_SoruAim = huntSoruAim
		end,
	})

	v6:Section({ Title = fn37("霸气 / 种族") })

	tbl7.Hunt_AutoHaki = v6:Toggle({
		Title = fn37("自动武装色 (Buso)"),
		Value = _G.Hunt_AutoHaki,
		Callback = function(huntAutoHaki)
			_G.Hunt_AutoHaki = huntAutoHaki
		end,
	})

	tbl7.Hunt_AutoKen = v6:Toggle({
		Title = fn37("自动见闻色 (Ken)"),
		Value = _G.Hunt_AutoKen,
		Callback = function(huntAutoKen)
			_G.Hunt_AutoKen = huntAutoKen
		end,
	})

	tbl7.Hunt_AutoV3 = v6:Toggle({
		Title = fn37("自动 V3"),
		Value = _G.Hunt_AutoV3,
		Callback = function(huntAutoV3)
			_G.Hunt_AutoV3 = huntAutoV3
		end,
	})

	tbl7.Hunt_AutoV4 = v6:Toggle({
		Title = fn37("自动 V4"),
		Value = _G.Hunt_AutoV4,
		Callback = function(huntAutoV4)
			_G.Hunt_AutoV4 = huntAutoV4
		end,
	})

	v6:Section({ Title = fn37("低血逃生") })

	tbl7.Hunt_AutoFlee = v6:Toggle({
		Title = fn37("低血自动往天上飞"),
		Value = _G.Hunt_AutoFlee,
		Callback = function(huntAutoFlee)
			_G.Hunt_AutoFlee = huntAutoFlee
		end,
	})

	v6:Slider({
		Title = fn37("触发血量 (%)"),
		Value = { Min = 5, Max = 90, Default = _G.Hunt_FleeHP },
		Callback = function(huntFleeHP)
			_G.Hunt_FleeHP = huntFleeHP
		end,
	})

	v6:Slider({
		Title = fn37("上升高度 (米)"),
		Value = { Min = 200, Max = 10000, Default = _G.Hunt_FleeHeight },
		Callback = function(huntFleeHeight)
			_G.Hunt_FleeHeight = huntFleeHeight
		end,
	})

	v6:Slider({
		Title = fn37("恢复猎赏血量 (%)"),
		Value = { Min = 30, Max = 100, Default = _G.Hunt_FleeRecover },
		Callback = function(huntFleeRecover)
			_G.Hunt_FleeRecover = huntFleeRecover
		end,
	})

	v6:Section({ Title = fn37("技能释放 (可多选)") })

	tbl7.Hunt_AutoSkill = v6:Toggle({
		Title = fn37("自动释放技能"),
		Value = _G.Hunt_AutoSkill,
		Callback = function(huntAutoSkill)
			_G.Hunt_AutoSkill = huntAutoSkill
		end,
	})

	tbl7.Hunt_SkillAim = v6:Toggle({
		Title = fn37("技能自瞄 (只瞄锁定目标)"),
		Value = _G.Hunt_SkillAim,
		Callback = function(huntSkillAim)
			_G.Hunt_SkillAim = huntSkillAim
		end,
	})

	tbl7.Hunt_RotateWeapon = v6:Toggle({
		Title = fn37("技能放完自动换下一把武器"),
		Value = _G.Hunt_RotateWeapon,
		Callback = function(huntRotateWeapon)
			_G.Hunt_RotateWeapon = huntRotateWeapon
		end,
	})

	v6:Slider({
		Title = fn37("技能间隔 (秒)"),
		Value = { Min = 0.3, Max = 10, Default = _G.Hunt_SkillInterval, Float = 0.1 },
		Callback = function(huntSkillInterval)
			_G.Hunt_SkillInterval = huntSkillInterval
		end,
	})

	v6:Button({
		Title = fn37("立即放技能 (测试用)"),
		Callback = function()
			print("[猎赏] 技能测试 -> 背包工具数: " .. #fn33())
			fn32()
			fn31(true)
		end,
	})

	for _, v12 in ipairs({ "拳法", "剑", "枪", "果实" }) do
		local v13 = tbl3[v12]
		v6:Section({ Title = fn37(v12 .. " 技能 (" .. #v13 .. " 个)") })

		for _, v14 in ipairs(v13) do
			tbl7["Skill_" .. v12 .. "_" .. v14] = v6:Toggle({
				Title = fn37(v12 .. " - " .. v14),
				Value = _G.Hunt_TypeSkills[v12][v14],
				Callback = function(arg)
					_G.Hunt_TypeSkills[v12][v14] = arg
				end,
			})
		end
	end

	v8:Section({ Title = fn37("飞行") })

	v8:Slider({
		Title = fn37("飞行速度"),
		Value = { Min = 50, Max = 600, Default = _G.Hunt_FlySpeed },
		Callback = function(huntFlySpeed)
			_G.Hunt_FlySpeed = huntFlySpeed
		end,
	})

	v8:Slider({
		Title = fn37("停靠距离"),
		Value = { Min = 2, Max = 40, Default = _G.Hunt_StopDist },
		Callback = function(huntStopDist)
			_G.Hunt_StopDist = huntStopDist
		end,
	})

	v8:Section({ Title = fn37("站立") })

	v8:Toggle({
		Title = fn37("坐在椅子上自动站起"),
		Value = _G.Hunt_AutoStand,
		Callback = function(huntAutoStand)
			_G.Hunt_AutoStand = huntAutoStand
		end,
	})

	v9:Section({ Title = fn37("环境") })

	v9:Toggle({
		Title = fn37("移除岩浆 (需重进恢复)"),
		Value = _G.G_RemoveLava,
		Callback = function(gRemoveLava)
			_G.G_RemoveLava = gRemoveLava

			if gRemoveLava then
				fn14()
			end
		end,
	})

	v9:Toggle({
		Title = fn37("水上行走"),
		Value = _G.G_WalkOnWater,
		Callback = function(gWalkOnWater)
			_G.G_WalkOnWater = gWalkOnWater

			if gWalkOnWater then
				fn15()
			else
				fn16()
			end
		end,
	})

	v9:Section({ Title = fn37("画质") })

	v9:Toggle({
		Title = fn37("减画质 (持续开启)"),
		Value = _G.G_LowGraphics,
		Callback = function(gLowGraphics)
			_G.G_LowGraphics = gLowGraphics

			if gLowGraphics then
				fn18()
			end
		end,
	})

	v7:Section({ Title = fn37("快速攻击") })

	v7:Toggle({
		Title = fn37("开启快速攻击"),
		Value = _G.G_FastAttack,
		Callback = function(gFastAttack)
			_G.G_FastAttack = gFastAttack
		end,
	})

	local dropdown = v7.Dropdown
	local tbl9 = { Title = fn37("快速攻击模式") }
	local values = {}
	local v12 = fn37("模式1")
	local v13 = fn37("模式2(部分账号失效用)")
	values[1] = v12
	values[2] = v13
	tbl9.Values = values
	tbl9.Value = fn37(_G.G_FastAttackMode)

	tbl9.Callback = function(arg)
		_G.G_FastAttackMode = fn38(arg)
	end

	dropdown(v7, tbl9)

	v7:Toggle({
		Title = fn37("攻击怪物"),
		Value = _G.G_AttackMobs,
		Callback = function(gAttackMobs)
			_G.G_AttackMobs = gAttackMobs
		end,
	})

	v7:Toggle({
		Title = fn37("攻击玩家"),
		Value = _G.G_AttackPlayers,
		Callback = function(gAttackPlayers)
			_G.G_AttackPlayers = gAttackPlayers
		end,
	})

	v10:Section({ Title = fn37("服务器") })

	tbl7.Hunt_AutoHop = v10:Toggle({
		Title = fn37("自动跳服务器"),
		Value = _G.Hunt_AutoHop,
		Callback = function(huntAutoHop)
			_G.Hunt_AutoHop = huntAutoHop
		end,
	})

	v10:Toggle({
		Title = fn37("换服后自动重跑脚本"),
		Value = _G.AutoExecute,
		Callback = function(autoExecute)
			_G.AutoExecute = autoExecute

			if writefile then
				pcall(function()
					writefile("AutoBounty.file", autoExecute and "true" or "false")
				end)
			end

			local v14 = print
			autoExecute = autoExecute and "开"
			v14("[猎赏] 换服后自动重跑脚本: " .. (autoExecute or "关") .. " (写入 " .. str2 .. ")")
		end,
	})

	v10:Slider({
		Title = fn37("跳服间隔 (秒)"),
		Value = { Min = 60, Max = 1200, Default = _G.Hunt_HopInterval },
		Callback = function(huntHopInterval)
			_G.Hunt_HopInterval = huntHopInterval
		end,
	})

	v10:Dropdown({
		Title = fn37("选择服务器区域"),
		Values = {
			"Oregon",
			"Florida",
			"Texas",
			"California",
			"Hong Kong",
			"Germany",
			"Brazil",
			"Singapore",
		},
		Value = _G.G_ServerRegion,
		Callback = function(gServerRegion)
			_G.G_ServerRegion = gServerRegion
			print("[猎赏] 区域设置: " .. gServerRegion)
		end,
	})

	v10:Dropdown({
		Title = fn37("选择人数"),
		Values = { "1-12", "3-12", "5-12", "7-12", "9-12" },
		Value = _G.G_HopPlayerRange,
		Callback = function(arg)
			fn6(arg)
			print("[猎赏] 人数设置: " .. arg .. " (" .. _G.G_HopMinPlayers .. "-" .. _G.G_HopMaxPlayers .. ")")
		end,
	})

	local dropdown2 = v10.Dropdown
	local tbl10 = { Title = fn37("选择赏金") }
	local values2 = {}
	local v14 = fn37("大于3m")
	local v15 = fn37("大于5m")
	local v16 = fn37("大于10m")
	local v17 = fn37("大于15m")
	local v18 = fn37("大于25m")
	local v19 = fn37("大于35m")
	local v20 = fn37("大于50m")
	values2[1] = v14
	values2[2] = v15
	values2[3] = v16
	values2[4] = v17
	values2[5] = v18
	values2[6] = v19
	values2[7] = v20
	tbl10.Values = values2
	tbl10.Value = fn37(_G.G_HopBountyRange)

	tbl10.Callback = function(arg)
		local v21 = fn38(arg)
		fn7(v21)
		print("[猎赏] 赏金设置: " .. v21 .. " (" .. fn5(_G.G_HopMinBounty) .. " - " .. fn5(_G.G_HopMaxBounty) .. ")")
	end

	dropdown2(v10, tbl10)

	v10:Button({
		Title = fn37("立即跳服务器"),
		Callback = function()
			_G.Hunt_ForceHop = true
		end,
	})

	v10:Button({
		Title = fn37("重进服务器"),
		Callback = function()
			fn12()
		end,
	})

	v10:Toggle({
		Title = fn37("等战斗结束再跳服"),
		Value = _G.Hunt_HopWaitCombat,
		Callback = function(huntHopWaitCombat)
			_G.Hunt_HopWaitCombat = huntHopWaitCombat
		end,
	})

	v10:Slider({
		Title = fn37("战斗结束最多等 (秒)"),
		Value = { Min = 10, Max = 600, Default = _G.Hunt_HopCombatWait },
		Callback = function(huntHopCombatWait)
			_G.Hunt_HopCombatWait = huntHopCombatWait
		end,
	})

	v10:Toggle({
		Title = fn37("没人开战斗模式就跳服"),
		Value = _G.Hunt_HopIfEmpty,
		Callback = function(huntHopIfEmpty)
			_G.Hunt_HopIfEmpty = huntHopIfEmpty
		end,
	})

	v10:Slider({
		Title = fn37("空服判定时长 (秒)"),
		Value = { Min = 5, Max = 120, Default = _G.Hunt_EmptyWait },
		Callback = function(huntEmptyWait)
			_G.Hunt_EmptyWait = huntEmptyWait
		end,
	})

	v10:Toggle({
		Title = fn37("跳服前先飞到天上等"),
		Value = _G.Hunt_HopSkyUp,
		Callback = function(huntHopSkyUp)
			_G.Hunt_HopSkyUp = huntHopSkyUp
		end,
	})

	v10:Slider({
		Title = fn37("跳服前飞天高度 (米)"),
		Value = { Min = 200, Max = 10000, Default = _G.Hunt_HopSkyHeight },
		Callback = function(huntHopSkyHeight)
			_G.Hunt_HopSkyHeight = huntHopSkyHeight
		end,
	})

	v10:Section({ Title = fn37("击杀换服") })

	v10:Toggle({
		Title = fn37("同一个玩家打死 N 次就跳服"),
		Value = _G.Hunt_KillHop,
		Callback = function(huntKillHop)
			_G.Hunt_KillHop = huntKillHop
		end,
	})

	v10:Slider({
		Title = fn37("击杀次数 N"),
		Value = { Min = 1, Max = 10, Default = _G.Hunt_KillHopCount },
		Callback = function(huntKillHopCount)
			_G.Hunt_KillHopCount = huntKillHopCount
		end,
	})

	v10:Toggle({
		Title = fn37("过滤已打死 N 次的玩家"),
		Value = _G.Hunt_NoKilledEnough,
		Callback = function(huntNoKilledEnough)
			_G.Hunt_NoKilledEnough = huntNoKilledEnough
		end,
	})

	v10:Section({ Title = fn37("阵营 (换服后自动选)") })
	local dropdown3 = v10.Dropdown
	local tbl11 = { Title = fn37("阵营") }
	local values3 = {}
	local v21 = fn37("不切换")
	local v22 = fn37("海盗")
	local v23 = fn37("海军")
	values3[1] = v21
	values3[2] = v22
	values3[3] = v23
	tbl11.Values = values3
	tbl11.Value = fn37(_G.Hunt_Team)

	tbl11.Callback = function(arg)
		local v24 = fn38(arg)
		_G.Hunt_Team = v24

		if v24 ~= "不切换" then
			fn34(true)
		end
	end

	dropdown3(v10, tbl11)

	v10:Button({
		Title = fn37("立即切换阵营"),
		Callback = function()
			fn34(true)
		end,
	})

	v5:Section({ Title = fn37("手动指定目标") })

	local function fn39()
		local tbl12 = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer then
				table.insert(tbl12, player.Name)
			end
		end

		return tbl12
	end

	local v24 = v5:Dropdown({
		Title = fn37("选择玩家"),
		Values = fn39(),
		Value = "",
		Callback = function(huntTarget)
			_G.Hunt_Target = huntTarget
		end,
	})

	v5:Button({
		Title = fn37("刷新玩家列表"),
		Callback = function()
			if v24 then
				v24:Refresh(fn39())
			end
		end,
	})

	v5:Button({
		Title = fn37("清除指定目标 (回到自动)"),
		Callback = function()
			_G.Hunt_Target = nil
			_G.Hunt_AutoSelect = true
		end,
	})

	v11:Section({ Title = fn37("语言") })
	local gLanguage = _G.G_Language

	v11:Button({
		Title = fn37("语言") .. ": " .. gLanguage .. " (" .. fn37("点一下切换") .. ")",
		Icon = "globe",
		Callback = function()
			_G.G_Language = _G.G_Language == "中文" and "English" or "中文"
			local v25 = fn3()
			print("[猎赏] " .. fn37("语言已切换为: ") .. _G.G_Language .. (v25 and " (已保存)" or " (存档不可用)"))

			pcall(function()
				local gLanguage2 = _G.G_Language

				v3:Notify({
					Title = fn37("语言"),
					Content = fn37("语言已切换为: ") .. gLanguage2 .. " | " .. fn37("重新执行脚本后面板文案生效"),
					Duration = 5,
				})
			end)
		end,
	})

	v11:Section({ Title = fn37("配置") })

	v11:Toggle({
		Title = fn37("自动保存配置"),
		Value = _G.Hunt_AutoSave,
		Callback = function(huntAutoSave)
			_G.Hunt_AutoSave = huntAutoSave

			if huntAutoSave then
				fn3()
				v2 = fn2()
			end
		end,
	})

	v11:Button({
		Title = fn37("立即保存配置"),
		Callback = function()
			local v25 = fn3()
			v2 = fn2()
			print("[猎赏] 配置保存" .. (v25 and "成功: " .. str or "失败(执行器不支持文件读写)"))
		end,
	})

	v11:Button({
		Title = fn37("重置为默认配置 (需重载)"),
		Callback = function()
			_G.Hunt_AutoSave = false

			pcall(function()
				if flag and isfile("BF_AutoBounty_Config.json") then
					delfile("BF_AutoBounty_Config.json")
				end
			end)

			print("[猎赏] 配置已删除并关闭自动保存，重载脚本即恢复默认")
		end,
	})

	print("[猎赏] 界面已创建 (猎赏/战斗/杀戮光环/移动/环境/服务器/设置) | 按 G 开关界面")
end

local function fn39(arg)
	local attribute = nil
	if pcall(function()
		attribute = arg:GetAttribute("Level")
	end) and attribute then
		return tonumber(attribute)
	end

	if pcall(function()
		attribute = arg.Data.Level.Value
	end) and attribute then
		return tonumber(attribute)
	end

	if pcall(function()
		attribute = arg.leaderstats.Level.Value
	end) and attribute then
		return tonumber(attribute)
	end
	return nil
end

local function fn40(arg)
	local character = arg.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end
	return true
end

local v4 = nil
local name = nil
local tbl9 = {}
local n2 = 30
local tbl10 = {}
local tbl11 = {}
local tbl12 = {}

local function fn41(arg)
	local character = arg.Character
	local tbl13 = { arg, character }

	if character then
		table.insert(tbl13, character:FindFirstChild("HumanoidRootPart"))
	end

	for _, v5 in ipairs(tbl13) do
		if v5 then
			local attribute = v5:GetAttribute("SafeZone")

			if attribute == nil then
				attribute = v5:GetAttribute("InSafeZone")
			end

			if attribute ~= nil then
				return attribute == true
			end
		end
	end

	return nil
end

local function fn42(arg)
	if fn41(arg) == true then
		return true
	end
	local v5 = tbl12[arg.Name]

	if v5 then
		if tick() < v5 then
			return true
		end
		tbl12[arg.Name] = nil
	end

	return false
end

local tbl13 = {}
local tbl14 = { "arena", "colosseum" }

local function fn43(arg)
	if type(arg) ~= "string" or arg == "" then
		return false
	end
	local v5 = string.lower(arg)

	for _, v6 in ipairs(tbl14) do
		if string.find(v5, v6, 1, true) then
			return true
		end
	end

	return false
end

local function fn44(arg)
	local character = arg.Character
	local tbl15 = {}
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	tbl15[1] = arg
	tbl15[2] = character
	tbl15[3] = humanoidRootPart

	for _, v5 in ipairs(tbl15) do
		if v5 then
			local ok, result = pcall(function()
				return v5:GetAttributes()
			end)

			if ok and type(result) == "table" then
				for k, v6 in pairs(result) do
					if fn43(k) then
						if v6 == true then
							return true
						end
						continue
					end

					if type(v6) == "string" and fn43(v6) then
						return true
					end
				end
			end
		end
	end

	return nil
end

local n3 = 3
local tbl15 = {}

local function fn45(arg)
	local character = arg.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil
	end
	local v5 = tbl15[arg.Name]
	local flag4

	if v5 then
		local t = v5.t
		flag4 = tick() < t
	else
		flag4 = v5
	end

	if flag4 then
		return v5.v
	end

	local ok, result = pcall(function()
		return Workspace:GetPartBoundsInRadius(humanoidRootPart.Position, 80)
	end)

	local v6 = ok and result
	local flag5 = nil

	if v6 then
		flag5 = nil

		for _, v7 in ipairs(result) do
			for i = 1, 4 do
				if v7 then
					if fn43(v7.Name) then
						flag5 = true
						break
					else
						v7 = v7.Parent
						continue
					end
				end

				break
			end

			if not flag5 then
				continue
			end
			break
		end
	end

	tbl15[arg.Name] = { v = flag5, t = tick() + n3 }
	return flag5
end

local function fn46(arg)
	if fn44(arg) == true then
		return true
	end
	local v5 = tbl13[arg.Name]

	if v5 then
		if tick() < v5 then
			return true
		end
		tbl13[arg.Name] = nil
	end

	return fn45(arg) == true
end

task.spawn(function()
	while task.wait(0.5) do
		if _G.Hunt_Auto and name and (_G.Hunt_NoSafe or _G.Hunt_NoArena) then
			local playerGui = localPlayer:FindFirstChild("PlayerGui")

			if playerGui then
				for _, descendant in ipairs(playerGui:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Visible and descendant.Text ~= "" then
						local str4 = descendant.Text:lower()

						if _G.Hunt_NoSafe and str4:find("cannot attack") and str4:find("safe") then
							tbl12[name] = tick() + 20
							break
						elseif _G.Hunt_NoArena and (str4:find("arena") or str4:find("colosseum")) and (str4:find("cannot") or str4:find("can't") or str4:find("friendly")) then
							tbl13[name] = tick() + 20
							break
						end
					end
				end
			end
		end
	end
end)

local function fn47(arg)
	for _, v5 in ipairs({ arg, arg.Character }) do
		if v5 then
			local ok, result = pcall(function()
				return v5:GetAttribute("PvpDisabled")
			end)

			if ok and result ~= nil then
				return result
			end
		end
	end

	return nil
end

local function fn48(arg)
	local v5 = fn47(arg)
	if v5 == nil then
		return true
	end
	return v5 == false
end

local function fn49(arg)
	if _G.Hunt_NoPvp and not fn48(arg) then
		return false
	end

	if _G.Hunt_NoSafe and fn42(arg) then
		return false
	end

	if _G.Hunt_NoArena and fn46(arg) then
		return false
	end

	if _G.Hunt_NoKilledEnough then
		local flag4 = tbl11[arg.Name]

		if flag4 then
			flag4 = flag4 >= (_G.Hunt_KillHopCount or 3)
		end

		if flag4 then
			return false
		end
	end

	if _G.Hunt_NoMarineAlly then
		local team = localPlayer.Team
		local team2 = arg.Team
		if team and team2 and team.Name == "Marines" and team2.Name == "Marines" then
			return false
		end
	end

	if not _G.Hunt_UseLevel then
		return true
	end
	local v5 = fn39(arg)
	if not v5 then
		return _G.Hunt_AllowUnknown
	end
	return v5 >= _G.Hunt_MinLevel
end

local function fn50(arg)
	local character = arg.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart"), character
end

local function fn51(arg)
	local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	local v5 = fn50(arg)
	if not humanoidRootPart or not v5 then
		return nil
	end
	return (v5.Position - humanoidRootPart.Position).Magnitude
end

local function fn52(arg)
	local v5 = fn51(arg)
	if not v5 then
		return false
	end
	return v5 > (_G.Hunt_MaxDist or 10000)
end

local n4 = 3
local now = nil

local function fn53(arg)
	if not arg or not arg.Parent then
		return false, "gone"
	end
	local character = arg.Character
	character = character and character:FindFirstChildOfClass("Humanoid")
	if not character or character.Health <= 0 then
		return false, "dead"
	end

	if fn52(arg) then
		return false, "far"
	end

	if not fn49(arg) then
		return false, "filter"
	end
	return true
end

local function fn54()
	if not now then
		now = tick()
	end

	return tick() - now < n4
end

local function fn55()
	if _G.Hunt_Target and _G.Hunt_Target ~= "" then
		local v5 = Players:FindFirstChild(_G.Hunt_Target)

		if v5 and v5 ~= localPlayer then
			local v6, v7 = fn53(v5)
			if v6 then
				now = nil
				return v5, 1
			end

			if v7 ~= "gone" and v7 ~= "dead" and fn54() then
				return v5, 1
			end
			now = nil
		end
	end

	if _G.Hunt_AutoSelect and v4 and v4 ~= localPlayer then
		local v5, v6 = fn53(v4)
		if v5 then
			now = nil
			return v4, 1
		end

		if v6 ~= "gone" and v6 ~= "dead" and fn54() then
			return v4, 1
		end
		now = nil

		if v6 == "dead" or v6 == "gone" then
			print("[猎赏] 目标 " .. v4.Name .. (v6 == "dead" and " 已死亡" or " 已离开") .. " -> 解除锁定，换下一个")
		end
	end

	if not _G.Hunt_AutoSelect then
		return nil, 0
	end
	local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return nil, 0
	end
	local n5 = 0
	local huge = math.huge
	local v5 = nil

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and fn40(player) and fn49(player) then
			local v6 = fn50(player)

			if v6 then
				n5 += 1
				local magnitude = (v6.Position - humanoidRootPart.Position).Magnitude

				if magnitude <= _G.Hunt_MaxDist and magnitude < huge then
					huge = magnitude
					v5 = player
				end
			end
		end
	end

	return v5, n5
end

local n5 = 0

local function fn56()
	if tick() - n5 < 10 then
		return
	end
	n5 = tick()
	local n6 = 0
	local n7 = 0
	local n8 = 0
	local n9 = 0
	local n10 = 0
	local n11 = 0
	local n12 = 0
	local n13 = 0
	local n14 = 0
	local n15 = 0

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			n6 += 1

			if fn40(player) then
				n7 += 1

				if not fn50(player) then
					n8 += 1
				elseif _G.Hunt_NoPvp and not fn48(player) then
					n9 += 1
				elseif _G.Hunt_NoSafe and fn42(player) then
					n10 += 1
				elseif _G.Hunt_NoArena and fn46(player) then
					n11 += 1
				else
					local huntNoKilledEnough = _G.Hunt_NoKilledEnough
					local flag4

					if huntNoKilledEnough then
						flag4 = (tbl11[player.Name] or 0) >= (_G.Hunt_KillHopCount or 3)
					else
						flag4 = huntNoKilledEnough
					end

					if flag4 then
						n12 += 1
					elseif _G.Hunt_NoMarineAlly and localPlayer.Team and player.Team and localPlayer.Team.Name == "Marines" and player.Team.Name == "Marines" then
						n13 += 1
					elseif _G.Hunt_UseLevel then
						local v5 = fn39(player)

						if v5 then
							if v5 < _G.Hunt_MinLevel then
								n14 += 1
							end
						elseif not _G.Hunt_AllowUnknown then
							n14 += 1
						end
					end
				end

				if fn49(player) and fn52(player) then
					n15 += 1
				end
			end
		end
	end

	print(string.format("[猎赏] 排查 -> 其他玩家:%d 存活:%d | 无角色:%d PvP挡:%d 安全区挡:%d 竞技场挡:%d 打死过挡:%d 海军挡:%d 等级挡:%d 超距挡:%d", n6, n7, n8, n9, n10, n11, n12, n13, n14, n15))
end

local name2 = nil
local n6 = 0

task.spawn(function()
	if (_G.Hunt_StartWait or 0) > 0 then
		print("[猎赏] 进服务器后等待 " .. _G.Hunt_StartWait .. " 秒再开始猎赏")
		task.wait(_G.Hunt_StartWait)
	end

	while task.wait(1) do
		if _G.Hunt_Auto then
			local ok, result, result2 = pcall(fn55)

			if not ok then
				if tick() - n6 > 30 then
					n6 = tick()
					print("[猎赏] 目标扫描异常(已自动继续): " .. tostring(result))
				end

				result = v4
				result2 = 1
			end

			if v4 and v4 ~= result and fn52(v4) then
				print("[猎赏] " .. v4.Name .. " 距离 " .. math.floor(fn51(v4) or 0) .. " 米，超过 " .. _G.Hunt_MaxDist .. " 米 -> 换下一个玩家")
			end

			v4 = result
			name = result and result.Name or nil

			if result then
				if name2 ~= result.Name then
					name2 = result.Name
					print("[猎赏] 锁定目标: " .. result.Name .. " | 过滤后候选: " .. result2 .. " | 距离: " .. math.floor(fn51(result) or 0))
				end
			else
				if name2 ~= nil then
					name2 = nil
					print("[猎赏] 当前无可用目标 | 过滤后候选: 0")
				end

				pcall(fn56)
			end
		end
	end
end)

task.spawn(function()
	while task.wait(5) do
		_G.Hunt_NoPvp = true

		if not _G.Hunt_AutoAttack then
			_G.Hunt_AutoAttack = true
			fn35("Hunt_AutoAttack", true)
			print("[猎赏] 「自动攻击」已自动恢复为开启（保持开启）")
		end
	end
end)

local function fn57()
	if not _G.Hunt_SkillAim then
		return nil
	end

	if v4 then
		local v5 = fn50(v4)
		if v5 and v5.Parent then
			return v5
		end
	end

	return nil
end

local flag4 = false
local mouse2 = ReplicatedStorage:FindFirstChild("Mouse")
local module = nil

if mouse2 then
	pcall(function()
		module = require(mouse2)
	end)
end

if module and typeof(module) == "table" then
	pcall(function()
		local tbl16 = { Hit = rawget(module, "Hit"), Target = rawget(module, "Target") }
		local tbl17 = getrawmetatable(module)

		if tbl17 then
			setreadonly(tbl17, false)
		else
			tbl17 = {}
			setmetatable(module, tbl17)
		end

		local index = tbl17.__index

		tbl17.__index = function(arg, arg2)
			local v5 = fn57()

			if v5 then
				if arg2 == "Hit" then
					return CFrame.new(v5.Position)
				end

				if arg2 == "Target" then
					return v5
				end
			end

			if type(index) == "function" then
				return index(arg, arg2)
			end

			if type(index) == "table" then
				return index[arg2]
			end
			return tbl16[arg2]
		end

		tbl17.__newindex = function(arg, arg2, arg3)
			if arg2 == "Hit" or arg2 == "Target" then
				tbl16[arg2] = arg3
			else
				rawset(arg, arg2, arg3)
			end
		end

		setreadonly(tbl17, true)
		rawset(module, "Hit", nil)
		rawset(module, "Target", nil)
		flag4 = true
	end)
end

local flag5 = type(checkcaller) == "function"
local v5 = nil

pcall(function()
	v5 = hookmetamethod(game, "__index", function(arg, arg2)
		if _G.Hunt_SkillAim and v4 and arg == mouse then
			if flag5 and checkcaller() then
				return v5(arg, arg2)
			end
			local v6 = fn57()

			if v6 then
				local position = v6.Position
				local position2 = currentCamera.CFrame.Position
				if arg2 == "Hit" then
					return CFrame.new(position)
				end

				if arg2 == "Target" then
					return v6
				end

				if arg2 == "UnitRay" then
					return Ray.new(position2, (position - position2).Unit)
				end

				if arg2 == "Origin" then
					return position2
				end

				if arg2 == "Direction" then
					return (position - position2).Unit
				end
			end
		end

		return v5(arg, arg2)
	end)
end)

print("[猎赏] 技能自瞄: " .. (flag4 and "已 hook ReplicatedStorage.Mouse 模块 + 标准 Mouse" or "未找到 Mouse 模块，仅 hook 标准 Mouse"))
local n7 = 0

fn30 = function()
	if tick() - n7 < 0.5 then
		return
	end
	n7 = tick()
	local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	local huntSoruAim = _G.Hunt_SoruAim and v4 and fn50(v4)
	local position

	if huntSoruAim then
		position = (huntSoruAim.CFrame * CFrame.new(0, 0, 3)).Position
	else
		position = humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 40
	end

	local cFrame = humanoidRootPart.CFrame
	local n8 = cFrame - cFrame.Position + position + Vector3.new(0, humanoidRootPart.Size.Y * 1.5, 0)

	pcall(function()
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		local commE = remotes and remotes:FindFirstChild("CommE")

		if commE then
			local random = math.random
			commE:FireServer("Soru", cFrame, n8, workspace:GetServerTimeNow(), random(1, 999999999))
		end
	end)
end

local tbl16 = {
	["果实"] = { "Blox Fruit" },
	["拳法"] = { "Melee", "Fighting" },
	["剑"] = { "Sword" },
	["枪"] = { "Gun" },
}

local function fn58()
	local tbl17 = {}

	for _, v6 in ipairs(tbl2) do
		if _G.Hunt_Weapons[v6] then
			for _, v7 in ipairs(tbl16[v6]) do
				table.insert(tbl17, v7)
			end
		end
	end

	if #tbl17 == 0 then
		return nil
	end
	return tbl17
end

local function fn59()
	local tbl17 = {}

	for _, v6 in ipairs(tbl2) do
		if _G.Hunt_Weapons[v6] then
			table.insert(tbl17, v6)
		end
	end

	if #tbl17 == 0 then
		return "随便"
	end
	return table.concat(tbl17, "/")
end

local function fn60()
	if not _G.Hunt_RotateWeapon then
		return nil, nil
	end
	local tbl17 = {}

	for _, v6 in ipairs(tbl2) do
		if _G.Hunt_Weapons[v6] then
			table.insert(tbl17, v6)
		end
	end

	if #tbl17 == 0 then
		return nil, nil
	end
	return tbl17[(_G.Hunt_RotateIndex - 1) % #tbl17 + 1], tbl17
end

local function fn61(arg, arg2)
	if not arg or not arg:IsA("Tool") then
		return false
	end

	if arg2 == nil then
		return true
	end

	for _, v6 in ipairs(arg2) do
		if arg.ToolTip == v6 then
			return true
		end
	end

	return false
end

fn33 = function()
	local backpack = localPlayer:FindFirstChild("Backpack")
	if not backpack then
		return {}
	end
	local tbl17 = {}

	for _, child in ipairs(backpack:GetChildren()) do
		if child:IsA("Tool") then
			table.insert(tbl17, child)
		end
	end

	return tbl17
end

local n8 = 0
local name3 = nil

fn32 = function()
	if not _G.Hunt_AutoEquip then
		return
	end
	local character = localPlayer.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	local str4 = fn60()
	local v6

	if str4 then
		v6 = tbl16[str4]
	else
		v6 = fn58()
	end

	local tool = character:FindFirstChildOfClass("Tool")
	if tool and fn61(tool, v6) then
		return
	end
	local backpack = localPlayer:FindFirstChild("Backpack")
	if not backpack then
		return
	end

	for _, child in ipairs(backpack:GetChildren()) do
		if fn61(child, v6) then
			local ok = pcall(function()
				humanoid:EquipTool(child)
			end)

			if child.Name ~= name3 then
				name3 = child.Name
				local v7 = print
				local name4 = child.Name
				local str5 = tostring(child.ToolTip)
				str4 = str4 and " <-轮换:" .. str4 or ""
				v7("[猎赏] 切换装备: " .. name4 .. " (" .. str5 .. ")" .. str4 .. (ok and "" or " EquipTool报错"))
			end

			return
		end
	end

	if tick() - n8 > 10 then
		n8 = tick()
		print("[猎赏] 自动装备失败: 背包里没有「" .. (str4 or fn59()) .. "」类型的武器")
	end
end

task.spawn(function()
	while task.wait(0.5) do
		fn32()
	end
end)

local tbl17 = { ["海盗"] = "Pirates", ["海军"] = "Marines" }

local function fn62()
	local ok, result = pcall(function()
		return localPlayer.Data.Team.Value
	end)

	if ok and result and result ~= "" then
		return result
	end
	local team = localPlayer.Team
	return team and team.Name or nil
end

fn34 = function(arg)
	local v6 = tbl17[_G.Hunt_Team]
	if not v6 then
		return
	end

	if not arg and fn62() == v6 then
		return
	end

	pcall(function()
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		remotes = remotes and remotes:FindFirstChild("CommF_")

		if remotes then
			remotes:InvokeServer("SetTeam", v6)
		end
	end)

	print("[猎赏] 切换阵营: " .. _G.Hunt_Team .. " (" .. v6 .. ")")
end

task.spawn(function()
	local flag6 = false
	local n9 = 0

	while true do
		task.wait(3)
		local v6 = tbl17[_G.Hunt_Team]

		if not v6 then
			flag6 = false
			n9 = 0
		else
			if fn62() == v6 then
				if not flag6 then
					print("[猎赏] 阵营已是 " .. _G.Hunt_Team .. "，无需切换")
					flag6 = true
				end

				n9 = 0
				continue
			end

			if n9 < 5 then
				n9 += 1
				fn34(true)
			end
		end
	end
end)

task.spawn(function()
	while task.wait(2) do
		if _G.Hunt_AutoHaki then
			local character = localPlayer.Character

			if character and not character:FindFirstChild("HasBuso") then
				pcall(function()
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					remotes = remotes and remotes:FindFirstChild("CommF_")

					if remotes then
						remotes:InvokeServer("Buso")
					end
				end)
			end
		end
	end
end)

task.spawn(function()
	while task.wait(0.5) do
		if _G.Hunt_AutoKen then
			pcall(function()
				local remotes = ReplicatedStorage:FindFirstChild("Remotes")
				remotes = remotes and remotes:FindFirstChild("CommE")

				if remotes then
					remotes:FireServer("Ken", true)
				end
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(1) do
		if _G.Hunt_AutoV3 then
			pcall(function()
				local remotes = ReplicatedStorage:FindFirstChild("Remotes")
				remotes = remotes and remotes:FindFirstChild("CommE")

				if remotes then
					remotes:FireServer("ActivateAbility")
				end
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(1) do
		if _G.Hunt_AutoV4 then
			pcall(function()
				local backpack = localPlayer:FindFirstChild("Backpack")
				backpack = backpack and backpack:FindFirstChild("Awakening")
				backpack = backpack and backpack:FindFirstChild("RemoteFunction")

				if backpack then
					backpack:InvokeServer(true)
				end
			end)
		end
	end
end)

local tbl18 = {
	Z = Enum.KeyCode.Z,
	X = Enum.KeyCode.X,
	C = Enum.KeyCode.C,
	V = Enum.KeyCode.V,
	F = Enum.KeyCode.F,
}

local tbl19 = { ["Blox Fruit"] = "果实", Melee = "拳法", Fighting = "拳法", Sword = "剑", Gun = "枪" }

local function fn63()
	local character = localPlayer.Character
	character = character and character:FindFirstChildOfClass("Tool")
	if not character then
		return nil
	end
	return tbl19[character.ToolTip]
end

local function fn64(arg)
	local tbl20 = {}
	if not arg or not tbl3[arg] then
		return tbl20
	end

	for _, v6 in ipairs(tbl3[arg]) do
		if _G.Hunt_TypeSkills[arg][v6] then
			table.insert(tbl20, v6)
		end
	end

	return tbl20
end

local function fn65()
	local tbl20 = {}

	for _, v6 in ipairs(tbl2) do
		local v7 = fn64(v6)

		if #v7 > 0 then
			table.insert(tbl20, v6 .. ":" .. table.concat(v7, ""))
		end
	end

	if #tbl20 == 0 then
		return "无"
	end
	return table.concat(tbl20, " ")
end

local n9 = 0
local n10 = 0

fn31 = function(arg)
	if not _G.Hunt_AutoSkill then
		return
	end

	if _G.Hunt_Fleeing then
		return
	end

	if _G.Hunt_HopSkyTimer or _G.Hunt_HopSkyEmpty then
		return
	end
	local flag6 = not arg

	if flag6 then
		local huntSkillInterval = _G.Hunt_SkillInterval
		flag6 = tick() - n9 < huntSkillInterval
	end

	if flag6 then
		return
	end
	n9 = tick()
	fn32()
	local character = localPlayer.Character
	local v6 = fn63()
	character = character and character:FindFirstChildOfClass("Tool")
	local tbl20 = fn64(v6)

	if #tbl20 == 0 and v6 == nil and character then
		tbl20 = { "Z", "X" }
	end

	if tick() - n10 > 5 then
		n10 = tick()
		print("[猎赏] 释放技能: " .. (v6 or "未知类型") .. " -> " .. (#tbl20 > 0 and table.concat(tbl20, "") or "无") .. " | 手持: " .. (character and character.Name .. " [" .. tostring(character.ToolTip) .. "]" or "空手"))
	end

	if #tbl20 == 0 then
		return
	end

	task.spawn(function()
		for _, v7 in ipairs(tbl20) do
			pcall(function()
				VirtualInputManager:SendKeyEvent(true, tbl18[v7], false, game)
				task.wait(0.03)
				VirtualInputManager:SendKeyEvent(false, tbl18[v7], false, game)
			end)

			task.wait(0.05)
		end

		if _G.Hunt_RotateWeapon then
			_G.Hunt_RotateIndex = _G.Hunt_RotateIndex + 1
			fn32()
		end
	end)
end

task.spawn(function()
	while task.wait(1) do
		local flag6 = _G.Hunt_Auto and _G.Hunt_AutoSoru and not _G.Hunt_Fleeing

		if flag6 then
			flag6 = not (_G.Hunt_HopSkyTimer or _G.Hunt_HopSkyEmpty)
		end

		if flag6 then
			if _G.Hunt_SoruInterval <= tick() - n7 then
				pcall(fn30)
			end
		end
	end
end)

local n11 = 0

local function fn66(arg)
	if not _G.Hunt_AutoAttack then
		return
	end

	if tick() - n11 < 0.12 then
		return
	end
	n11 = tick()
	local character = localPlayer.Character
	if not (character and character:FindFirstChild("HumanoidRootPart")) then
		return
	end
	local character2 = arg.Character
	local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
	local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
	if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
		return
	end
	ReplicatedStorage:FindFirstChild("Remotes")
	local net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
	if not net then
		return
	end
	local reRegisterAttack = net:FindFirstChild("RE/RegisterAttack")
	local reRegisterHit = net:FindFirstChild("RE/RegisterHit")
	if not reRegisterAttack or not reRegisterHit then
		return
	end
	local tbl20 = {}

	for _, child in ipairs(character2:GetChildren()) do
		if child:IsA("BasePart") then
			table.insert(tbl20, { character2, child })
		end
	end

	if #tbl20 == 0 then
		return
	end

	pcall(function()
		reRegisterAttack:FireServer(0.3)
		reRegisterHit:FireServer(humanoidRootPart, tbl20)
	end)

	tbl9[arg.Name] = tick()
end

local flag6 = false
local n12 = 0
local n13 = 0
local y = nil
local n14 = 0

local function fn67(arg)
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoidRootPart or not humanoid then
		return
	end

	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.CanCollide then
			descendant.CanCollide = false
		end
	end

	if _G.Hunt_AutoFlee and humanoid.Health > 0 then
		local n15 = humanoid.Health / humanoid.MaxHealth * 100

		if not flag6 and n15 <= _G.Hunt_FleeHP then
			flag6 = true
			_G.Hunt_Fleeing = true
			n12 = humanoidRootPart.Position.Y
			n13 = tick()
			local str4 = "% -> 向上逃生 " .. _G.Hunt_FleeHeight .. " 米，暂停猎赏"
			print("[猎赏] 血量 " .. math.floor(n15) .. str4)
		elseif flag6 then
			local n16 = tick() - n13
			local flag7 = n15 >= _G.Hunt_FleeRecover
			local flag8 = n16 >= _G.Hunt_FleeMaxTime and n15 > _G.Hunt_FleeHP

			if flag7 or flag8 or n16 >= _G.Hunt_FleeMaxTime * 3 then
				flag6 = false
				_G.Hunt_Fleeing = false
				print("[猎赏] 血量 " .. math.floor(n15) .. "% -> " .. (flag7 and "已恢复，结束逃生，自动恢复猎赏" or flag8 and "逃生超时，恢复猎赏" or "逃生过久强制恢复猎赏（血量一直没涨）"))
			end
		end

		if flag6 then
			local n16 = n12 + _G.Hunt_FleeHeight

			if humanoidRootPart.Position.Y < n16 then
				local n17 = humanoidRootPart.CFrame - humanoidRootPart.Position
				humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, math.min(_G.Hunt_FlySpeed * arg, n16 - humanoidRootPart.Position.Y), 0)) * n17
				humanoidRootPart.Velocity = Vector3.zero
				humanoidRootPart.RotVelocity = Vector3.zero
			end

			return
		end
	elseif flag6 then
		flag6 = false
		_G.Hunt_Fleeing = false
	end

	if not _G.Hunt_HopSkyUp then
		_G.Hunt_HopSkyTimer = false
		_G.Hunt_HopSkyEmpty = false
	end

	local huntHopSkyTimer = _G.Hunt_HopSkyTimer or _G.Hunt_HopSkyEmpty

	if huntHopSkyTimer and not flag6 and humanoid.Health > 0 then
		if not y then
			y = humanoidRootPart.Position.Y
		end

		local n15 = y + _G.Hunt_HopSkyHeight

		if humanoidRootPart.Position.Y < n15 then
			local n16 = humanoidRootPart.CFrame - humanoidRootPart.Position
			humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + Vector3.new(0, math.min(_G.Hunt_FlySpeed * arg, n15 - humanoidRootPart.Position.Y), 0)) * n16
			humanoidRootPart.Velocity = Vector3.zero
			humanoidRootPart.RotVelocity = Vector3.zero
		end

		return
	end

	if not huntHopSkyTimer then
		y = nil
	end

	if not _G.Hunt_Auto or not v4 then
		return
	end
	local v6 = fn50(v4)
	if not v6 then
		return
	end
	local n15 = v6.Position + Vector3.new(0, _G.Hunt_StopDist, 0)
	local magnitude = (n15 - humanoidRootPart.Position).Magnitude

	if magnitude > 1 then
		local n16 = humanoidRootPart.CFrame - humanoidRootPart.Position
		humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + (n15 - humanoidRootPart.Position).Unit * math.min(_G.Hunt_FlySpeed * arg, magnitude)) * n16
		humanoidRootPart.Velocity = Vector3.zero
		humanoidRootPart.RotVelocity = Vector3.zero
	end

	if magnitude <= _G.Hunt_StopDist + 20 then
		fn31()
		fn66(v4)
	end

	if magnitude <= _G.Hunt_StopDist + 6 then
		fn30()
	end
end

RunService.Heartbeat:Connect(function(deltaTime)
	local ok, result = pcall(fn67, deltaTime)

	if not ok and tick() - n14 > 10 then
		n14 = tick()
		print("[猎赏] 飞行/猎赏循环异常(已自动继续): " .. tostring(result))
	end
end)

task.spawn(function()
	while task.wait(0.5) do
		local now2 = tick()

		for k, v6 in pairs(tbl9) do
			if now2 - v6 <= 10 then
				local character = Players:FindFirstChild(k)
				character = character and character.Character
				character = character and character:FindFirstChildOfClass("Humanoid")
				local flag7 = character ~= nil and character.Health > 0

				if tbl10[k] == true and not flag7 then
					tbl10[k] = false
					tbl11[k] = (tbl11[k] or 0) + 1
					print("[猎赏] 已打死 " .. k .. " " .. tbl11[k] .. " 次")

					if _G.Hunt_KillHop and tbl11[k] >= _G.Hunt_KillHopCount then
						tbl11[k] = 0
						print("[猎赏] " .. k .. " 已打死 " .. _G.Hunt_KillHopCount .. " 次（赏金收益变低）-> 自动换服务器")
						_G.Hunt_ForceHop = true
					end
				else
					tbl10[k] = flag7
				end
			end
		end
	end
end)

local function fn68(arg)
	local jobId = game.JobId
	if not pcall(arg) then
		return false
	end
	local now2 = tick()

	while tick() - now2 < 3 do
		if game.JobId ~= jobId then
			return true
		end
		task.wait(0.2)
	end

	return false
end

local function fn69()
	local str4 = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"

	local ok, result = pcall(function()
		return game:HttpGet(str4)
	end)

	if not ok or type(result) ~= "string" or result == "" then
		print("[猎赏] HTTP 兜底: 拿服务器列表失败 -> " .. tostring(result))
		return false
	end

	local ok2, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)

	if not ok2 or type(result2) ~= "table" or type(result2.data) ~= "table" then
		print("[猎赏] HTTP 兜底: 服务器列表解析失败")
		return false
	end
	local tbl20 = {}
	local n15 = 0

	for _, v6 in ipairs(result2.data) do
		local id = v6.id
		local playing = v6.playing or 0

		if id and id ~= game.JobId and playing < (v6.maxPlayers or 12) then
			n15 += 1
			local flag7 = playing >= (_G.G_HopMinPlayers or 1)

			if flag7 then
				flag7 = playing <= (_G.G_HopMaxPlayers or 12)
			end

			if flag7 then
				table.insert(tbl20, { Job = id, Players = playing })
			end
		end
	end

	if #tbl20 == 0 then
		print("[猎赏] HTTP 兜底: " .. n15 .. " 个有空位的服务器，但没有符合人数条件(" .. _G.G_HopPlayerRange .. ")的")
		return false
	end

	table.sort(tbl20, function(arg, arg2)
		return arg.Players < arg2.Players
	end)

	print("[猎赏] HTTP 兜底: 找到 " .. #tbl20 .. " 个候选 | 这条路没有区域/赏金过滤")
	fn11()
	local n16 = 0

	for _, v6 in ipairs(tbl20) do
		n16 += 1
		print("[猎赏] HTTP 兜底 尝试第 " .. n16 .. " 个: " .. v6.Job .. "（" .. v6.Players .. " 人）")

		if fn68(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, v6.Job, localPlayer)
		end) then
			print("[猎赏] HTTP 兜底传送成功，正在传送...")
			return true
		end

		print("[猎赏] HTTP 兜底: 这个也没跳进去 -> 换下一个服务器")
		if n16 >= 5 then
			print("[猎赏] HTTP 兜底: 试了 " .. n16 .. " 个都不行 -> 本轮放弃，稍后重试")
			break
		end
	end

	return false
end

local function fn70()
	if getgenv().IsServerHopping == true then
		return false
	end
	getgenv().IsServerHopping = true
	local playerGui = localPlayer.PlayerGui

	if not playerGui:FindFirstChild("ServerBrowser") then
		print("[猎赏] 没找到 ServerBrowser 界面 -> 改用 HTTP 服务器列表兜底")
		local v6 = fn69()
		getgenv().IsServerHopping = false
		return v6
	end

	playerGui.ServerBrowser.Enabled = true
	task.wait(0.1)
	local filters = playerGui.ServerBrowser.Frame:FindFirstChild("Filters")
	local searchRegion = filters and filters:FindFirstChild("SearchRegion")
	searchRegion = searchRegion and searchRegion:FindFirstChild("TextBox")

	if not searchRegion then
		print("[猎赏] ServerBrowser 里找不到区域输入框 -> 改用 HTTP 服务器列表兜底")
		local v6 = fn69()
		getgenv().IsServerHopping = false
		return v6
	end

	searchRegion.Text = _G.G_ServerRegion
	filters = filters and filters:FindFirstChild("Full")
	filters = filters and filters:FindFirstChild("Check")

	if filters then
		filters.Text = "✔️"
		task.wait(0.1)
	end

	local scrollingFrame = playerGui.ServerBrowser.Frame.ScrollingFrame
	local inside = playerGui.ServerBrowser.Frame.FakeScroll.Inside

	task.spawn(function()
		while getgenv().IsServerHopping do
			scrollingFrame.CanvasPosition = Vector2.new(0, math.random(100, 7000))
			task.wait(0.3)
		end
	end)

	task.wait()
	local jobId = game.JobId
	local serverBrowser = ReplicatedStorage:WaitForChild("__ServerBrowser")
	print("[猎赏] 扫描服务器 | 区域: " .. _G.G_ServerRegion .. " | 人数: " .. _G.G_HopPlayerRange .. " | 赏金: " .. _G.G_HopBountyRange)
	local tbl20 = {}
	local n15 = 0

	while getgenv().IsServerHopping and n15 < 12 do
		n15 += 1

		for _, child in ipairs(inside:GetChildren()) do
			if child.Name == "Template" then
				local join = child:FindFirstChild("Join")
				local textLabel = child:FindFirstChild("TextLabel")
				textLabel = textLabel and fn8(textLabel.Text)

				if join and textLabel and fn9(textLabel) then
					local attribute = join:GetAttribute("Job")

					if attribute then
						local str4 = tostring(attribute)

						if str4:find("-", 1, true) and str4 ~= jobId then
							local v6 = tbl20[str4]

							if not v6 or textLabel.Players < v6.Players then
								tbl20[str4] = textLabel
							end
						end
					end
				end
			end
		end

		task.wait(0.3)
	end

	local v6 = nil
	local n16 = 0
	local v7 = nil

	for k, v8 in pairs(tbl20) do
		n16 += 1

		if not v7 or v8.Players < v7.Players then
			v6 = k
			v7 = v8
		end
	end

	if not v6 then
		print("[猎赏] 界面里没扫到符合条件(人数/赏金/满人)的服务器 -> 改用 HTTP 服务器列表兜底")
		local v8 = fn69()
		getgenv().IsServerHopping = false
		return v8
	end

	local players = v7.Players
	local maxPlayers = v7.MaxPlayers
	print("[猎赏] 扫到 " .. n16 .. " 个可用服务器 -> 选人数最少的: 地区 " .. tostring(v7.Region) .. " | 人数 " .. players .. "/" .. maxPlayers .. " | 赏金 " .. fn5(v7.Bounty))
	fn11()
	local jobId2 = game.JobId

	if pcall(function()
		serverBrowser:InvokeServer("teleport", v6)
	end) or pcall(function()
		serverBrowser:InvokeServer("teleport", v6)
	end) then
		local now2 = tick()

		while tick() - now2 < 3 do
			if game.JobId ~= jobId2 then
				print("[猎赏] 跳服成功，正在传送...")
				return true
			end
			task.wait(0.2)
		end

		print("[猎赏] 游戏内跳服没生效（还停在原服务器）-> 改用 HTTP 服务器列表兜底")
	else
		print("[猎赏] 游戏内跳服发包失败 -> 改用 HTTP 服务器列表兜底")
	end

	local v8 = fn69()
	getgenv().IsServerHopping = false
	task.wait(0.3)
	return v8
end

local function fn71()
	local ok, result = pcall(fn70)
	getgenv().IsServerHopping = false
	if not ok then
		print("[猎赏] 跳服异常: " .. tostring(result))
		return false
	end
	return result == true
end

local function fn72()
	if _G.Hunt_Fleeing then
		return true
	end

	if _G.Hunt_Target and _G.Hunt_Target ~= "" then
		return true
	end

	if tick() - n11 < 5 then
		return true
	end
	local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		local now2 = tick()

		for k, v6 in pairs(tbl9) do
			if n2 < now2 - v6 then
				tbl9[k] = nil
				continue
			end
			local v7 = Players:FindFirstChild(k)

			if v7 and fn40(v7) then
				local v8 = fn50(v7)
				local flag7

				if v8 then
					flag7 = (v8.Position - humanoidRootPart.Position).Magnitude <= (_G.Hunt_MaxDist or 10000)
				else
					flag7 = v8
				end

				if flag7 then
					return true
				end
			end
		end
	end

	return false
end

local function fn73(arg)
	local huntHopCombatWait = _G.Hunt_HopCombatWait or 60
	return arg ~= nil and huntHopCombatWait > 0 and tick() - arg >= huntHopCombatWait
end

local function fn74(arg, arg2)
	if arg or not _G.Hunt_HopWaitCombat then
		return true
	end

	if fn73(arg2) then
		return true
	end

	if fn72() then
		return false
	end
	task.wait(2)
	return not fn72()
end

task.spawn(function()
	local now2 = nil
	local flag7 = false

	while task.wait(1) do
		if _G.Hunt_ForceHop then
			_G.Hunt_ForceHop = false
			local huntHopSkyUp = _G.Hunt_HopSkyUp

			if huntHopSkyUp then
				huntHopSkyUp = not (_G.Hunt_HopSkyTimer or _G.Hunt_HopSkyEmpty)
			end

			if huntHopSkyUp then
				_G.Hunt_HopSkyTimer = true
				y = nil
				print("[猎赏] 准备跳服 -> 飞到天上 " .. _G.Hunt_HopSkyHeight .. " 米等待")
			end

			if fn74(true, now2) then
				if fn73(now2) then
					print("[猎赏] 已等战斗结束 " .. (_G.Hunt_HopCombatWait or 60) .. " 秒仍未结束 -> 直接跳服")
				elseif flag7 then
					print("[猎赏] 战斗结束 -> 开始跳服")
				end

				print("[猎赏] 跳服务器中...")
				local v6 = fn71()

				if v6 then
					_G.Hunt_HopTimer = tick()
				else
					local huntHopInterval = _G.Hunt_HopInterval
					_G.Hunt_HopTimer = tick() - huntHopInterval + 20
				end

				now2 = nil
				flag7 = false

				if _G.Hunt_HopSkyTimer then
					_G.Hunt_HopSkyTimer = false
					now2 = nil

					if not v6 then
						print("[猎赏] 这轮没跳成功 -> 从天上下来继续猎赏，稍后重试")
						now2 = nil
					end
				end
			elseif not flag7 then
				now2 = tick()
				print("[猎赏] 到跳服时间了，但战斗还没结束 -> 打完再跳，最多等 " .. (_G.Hunt_HopCombatWait or 60) .. " 秒")
				flag7 = true
			end
		elseif _G.Hunt_AutoHop then
			if not _G.Hunt_HopTimer then
				_G.Hunt_HopTimer = tick()
			end

			local huntHopTimer = _G.Hunt_HopTimer

			if tick() - huntHopTimer >= _G.Hunt_HopInterval then
				local huntHopSkyUp = _G.Hunt_HopSkyUp

				if huntHopSkyUp then
					huntHopSkyUp = not (_G.Hunt_HopSkyTimer or _G.Hunt_HopSkyEmpty)
				end

				if huntHopSkyUp then
					_G.Hunt_HopSkyTimer = true
					y = nil
					print("[猎赏] 准备跳服 -> 飞到天上 " .. _G.Hunt_HopSkyHeight .. " 米等待")
				end

				if fn74(false, now2) then
					if fn73(now2) then
						print("[猎赏] 已等战斗结束 " .. (_G.Hunt_HopCombatWait or 60) .. " 秒仍未结束 -> 直接跳服")
					elseif flag7 then
						print("[猎赏] 战斗结束 -> 开始跳服")
					end

					print("[猎赏] 跳服务器中...")
					local v6 = fn71()

					if v6 then
						_G.Hunt_HopTimer = tick()
					else
						local huntHopInterval = _G.Hunt_HopInterval
						_G.Hunt_HopTimer = tick() - huntHopInterval + 20
					end

					now2 = nil
					flag7 = false

					if _G.Hunt_HopSkyTimer then
						_G.Hunt_HopSkyTimer = false
						now2 = nil

						if not v6 then
							print("[猎赏] 这轮没跳成功 -> 从天上下来继续猎赏，稍后重试")
							now2 = nil
						end
					end
				elseif not flag7 then
					now2 = tick()
					print("[猎赏] 到跳服时间了，但战斗还没结束 -> 打完再跳，最多等 " .. (_G.Hunt_HopCombatWait or 60) .. " 秒")
					flag7 = true
				end
			else
				now2 = nil
				flag7 = false

				if _G.Hunt_HopSkyTimer then
					_G.Hunt_HopSkyTimer = false
					print("[猎赏] 当前没有待跳服 -> 从天上下来继续猎赏")
					now2 = nil
				end
			end
		else
			_G.Hunt_HopTimer = tick()
			now2 = nil
			flag7 = false

			if _G.Hunt_HopSkyTimer then
				_G.Hunt_HopSkyTimer = false
				print("[猎赏] 当前没有待跳服 -> 从天上下来继续猎赏")
				now2 = nil
			end
		end
	end
end)

task.spawn(function()
	task.wait(25)
	local now2 = nil
	local now3 = nil
	local flag7 = false

	while task.wait(2) do
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		character = character and character:FindFirstChildOfClass("Humanoid")

		if _G.Hunt_HopIfEmpty and _G.Hunt_Auto and humanoidRootPart ~= nil and character ~= nil and character.Health > 0 then
			if fn55() == nil then
				if not now2 then
					now2 = tick()
					print("[猎赏] 服务器里没有可猎目标（没开战斗模式/全被过滤），开始计时 " .. _G.Hunt_EmptyWait .. " 秒")
				elseif _G.Hunt_EmptyWait <= tick() - now2 then
					local huntHopSkyUp = _G.Hunt_HopSkyUp

					if huntHopSkyUp then
						huntHopSkyUp = not (_G.Hunt_HopSkyTimer or _G.Hunt_HopSkyEmpty)
					end

					if huntHopSkyUp then
						_G.Hunt_HopSkyEmpty = true
						y = nil
						print("[猎赏] 准备跳服 -> 飞到天上 " .. _G.Hunt_HopSkyHeight .. " 米等待")
					end

					if fn74(false, now3) then
						if fn73(now3) then
							print("[猎赏] 空服判定到期，已等战斗结束 " .. (_G.Hunt_HopCombatWait or 60) .. " 秒仍未结束 -> 直接跳服")
						end

						print("[猎赏] 持续 " .. _G.Hunt_EmptyWait .. " 秒没有可猎目标 -> 切换服务器")
						local v6 = fn71()

						if _G.Hunt_HopSkyEmpty then
							_G.Hunt_HopSkyEmpty = false

							if not v6 then
								print("[猎赏] 这轮没跳成功 -> 从天上下来继续猎赏，稍后重试")
							end
						end

						task.wait(30)
						now2 = nil
						now3 = nil
						flag7 = false
					elseif not flag7 then
						now3 = tick()
						print("[猎赏] 空服判定到期，但战斗还没结束 -> 打完再跳，最多等 " .. (_G.Hunt_HopCombatWait or 60) .. " 秒")
						flag7 = true
					end
				end
			else
				if now2 then
					print("[猎赏] 已经有可猎目标，取消跳服")
				end

				now2 = nil
				now3 = nil
				flag7 = false

				if _G.Hunt_HopSkyEmpty then
					_G.Hunt_HopSkyEmpty = false
					print("[猎赏] 取消跳服 -> 从天上下来继续猎赏")
					now2 = nil
					now3 = nil
				end
			end
		else
			if now2 then
				print("[猎赏] 已经有可猎目标，取消跳服")
			end

			now2 = nil
			now3 = nil
			flag7 = false

			if _G.Hunt_HopSkyEmpty then
				_G.Hunt_HopSkyEmpty = false
				print("[猎赏] 取消跳服 -> 从天上下来继续猎赏")
				now2 = nil
				now3 = nil
			end
		end
	end
end)

print(string.rep("=", 40))
print("  kiyo hub auto bounty 已加载")
print("  配置: " .. (not flag and "执行器不支持文件读写(无法保存)" or v and "已读取 " .. str or "无存档，使用默认值") .. (_G.Hunt_AutoSave and " | 自动保存: 开" or " | 自动保存: 关"))
print("  自动执行(一键全开): " .. (_G.Hunt_AutoRun and "开" or "关"))
print("  换服后自动重跑脚本: " .. (_G.AutoExecute and "开" or "关") .. (type(queueOnTeleport2) == "function" and " (queue_on_teleport 可用)" or " | 当前执行器不支持 queue_on_teleport"))
print("  等级过滤: " .. (_G.Hunt_UseLevel and ">= " .. _G.Hunt_MinLevel or "关闭"))
print("  进服务器等待: " .. _G.Hunt_StartWait .. " 秒后才开始猎赏")
print("  过滤: " .. (_G.Hunt_NoSafe and "排除安全区 " or "") .. (_G.Hunt_NoArena and "排除竞技场 " or "") .. (_G.Hunt_NoKilledEnough and "排除已打死 " .. _G.Hunt_KillHopCount .. " 次的 " or "") .. "只猎开战斗模式(强制) " .. (_G.Hunt_NoMarineAlly and "排除海军盟友 " or "") .. "| 换人距离: " .. _G.Hunt_MaxDist .. " 米")
print("  瞬步: CommE 发包(冲向锁定目标) 每 " .. _G.Hunt_SoruInterval .. " 秒")
local str4 = " | 间隔 " .. _G.Hunt_SkillInterval .. " 秒"
print("  技能: " .. fn65() .. str4)
print("  飞行: " .. _G.Hunt_FlySpeed .. " | 跳服: 每 " .. _G.Hunt_HopInterval .. " 秒 (ServerBrowser 扫描)" .. " | " .. (_G.Hunt_HopWaitCombat and "等战斗结束才跳(最多 " .. _G.Hunt_HopCombatWait .. " 秒)" or "到点就跳"))
print("  跳服筛选: 区域 " .. _G.G_ServerRegion .. " | 人数 " .. _G.G_HopPlayerRange .. " | 赏金 " .. _G.G_HopBountyRange .. " (" .. fn5(_G.G_HopMinBounty) .. " - " .. fn5(_G.G_HopMaxBounty) .. ")")
print("  自动装备: " .. (_G.Hunt_AutoEquip and "开" or "关") .. " | 武器类型: " .. fn59() .. " | 背包工具数: " .. #fn33())
print("  霸气/种族: " .. (_G.Hunt_AutoHaki and "武装色 " or "") .. (_G.Hunt_AutoKen and "见闻色 " or "") .. (_G.Hunt_AutoV3 and "V3 " or "") .. (_G.Hunt_AutoV4 and "V4" or "") .. " (全程开启)")
print("  自瞄: " .. (_G.Hunt_SkillAim and "技能 " or "") .. (_G.Hunt_SoruAim and "瞬步" or "") .. " -> 只瞄锁定目标")
print("  武器轮换: " .. (_G.Hunt_RotateWeapon and "技能放完自动换下一把" or "关"))
print("  空服跳服: " .. (_G.Hunt_HopIfEmpty and "连续 " .. _G.Hunt_EmptyWait .. " 秒无可猎目标就跳" or "关"))
print("  阵营: " .. _G.Hunt_Team .. (tbl17[_G.Hunt_Team] and " (换服后自动选)" or ""))
local v6 = print
local gRemoveLava = _G.G_RemoveLava or _G.G_WalkOnWater

if gRemoveLava then
	gRemoveLava = (_G.G_RemoveLava and "移除岩浆 " or "") .. (_G.G_WalkOnWater and "水上行走" or "")
end

v6("  环境: " .. (gRemoveLava or "关"))
print("  杀戮光环: " .. (_G.G_FastAttack and "开 " .. _G.G_FastAttackMode or "关") .. " | 怪物: " .. (_G.G_AttackMobs and "打" or "不打") .. " | 玩家: " .. (_G.G_AttackPlayers and "打" or "不打") .. " | 减画质: " .. (_G.G_LowGraphics and "开" or "关"))
print("  低血逃生: " .. (_G.Hunt_AutoFlee and "血量<" .. _G.Hunt_FleeHP .. "% 上飞 " .. _G.Hunt_FleeHeight .. " 米，恢复到 " .. _G.Hunt_FleeRecover .. "% 继续猎赏（超 " .. _G.Hunt_FleeMaxTime .. " 秒强制恢复）" or "关"))