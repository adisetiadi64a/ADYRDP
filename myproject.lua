-- 🎮 Mod Menu v5.0 Fly Update
-- by Ady & ChatGPT
-- Full Features: FPS Boost, Infinite Jump, ESP, Teleport, Copy Coordinate, Fly (Part 2)
-- Modular System (mudah tambah fitur baru)

repeat task.wait() until game and game:IsLoaded()

-------------------------------------------------
-- 🔧 Services
-------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-------------------------------------------------
-- ⚙️ GUI parent
-------------------------------------------------
local function getGuiParent()
	if typeof(gethui) == "function" then
		local ok, g = pcall(gethui)
		if ok and g then return g end
	end
	if game:FindFirstChild("CoreGui") then
		return game.CoreGui
	end
	return player:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()
if guiParent:FindFirstChild("ModMenuUI") then
	pcall(function() guiParent.ModMenuUI:Destroy() end)
end

-------------------------------------------------
-- 🧠 State Variables
-------------------------------------------------
local boosted = false
local infJumpEnabled = false
local espEnabled = false
local autoTeleportEnabled = false
local autoTeleportDelay = 3
local savedSettings = {}
local menuVisible = false
local autoTeleportThread = nil
local espObjects = {}
local featureList = {}

-------------------------------------------------
-- 🧱 Utility: Save & Restore (FPS Booster)
-------------------------------------------------
local function SaveSettings()
	savedSettings = {
		GlobalShadows = Lighting.GlobalShadows,
		Brightness = Lighting.Brightness,
		FogEnd = Lighting.FogEnd,
		Ambient = Lighting.Ambient,
		EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
		EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
		QualityLevel = settings().Rendering.QualityLevel
	}
end

local function BoostFPS()
	SaveSettings()
	for _, obj in pairs(Workspace:GetDescendants()) do
		pcall(function()
			if obj:IsA("BasePart") then
				obj.Material = Enum.Material.Plastic
				obj.CastShadow = false
				obj.Reflectance = 0
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 1
			end
		end)
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	Lighting.Brightness = 1
	Lighting.Ambient = Color3.fromRGB(128,128,128)
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
end

local function RestoreSettings()
	for k,v in pairs(savedSettings) do
		if k ~= "QualityLevel" then
			pcall(function() Lighting[k] = v end)
		end
	end
	pcall(function() settings().Rendering.QualityLevel = savedSettings.QualityLevel end)
end

-------------------------------------------------
-- 🚀 Infinite Jump
-------------------------------------------------
UIS.JumpRequest:Connect(function()
	if infJumpEnabled then
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-------------------------------------------------
-- 👁️ ESP Implementation
-------------------------------------------------
local function removeESP(p)
	if espObjects[p] then
		local o = espObjects[p]
		pcall(function()
			if o.highlight and o.highlight.Parent then o.highlight:Destroy() end
			if o.billboard and o.billboard.Parent then o.billboard:Destroy() end
			if o.conn then o.conn:Disconnect() end
		end)
		espObjects[p] = nil
	end
end

local function createESP(p)
	if not p or not p.Character then return end
	local char = p.Character
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	removeESP(p)

	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = Color3.fromRGB(255, 0, 0)
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency = 0.5
	hl.Parent = char

	local billboard = Instance.new("BillboardGui", hrp)
	billboard.Size = UDim2.new(0, 180, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true

	local textLabel = Instance.new("TextLabel", billboard)
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 10
	textLabel.TextColor3 = Color3.new(1,1,1)
	textLabel.TextStrokeTransparency = 0.5

	local conn = RunService.RenderStepped:Connect(function()
		if not espEnabled then return end
		if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
		if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

		local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
		local status = dist < 50 and "🟢 Dekat" or (dist < 200 and "🟡 Sedang" or "🔴 Jauh")
		textLabel.Text = string.format("%s - %.0fm (%s)", p.Name, dist, status)
	end)

	espObjects[p] = {highlight = hl, billboard = billboard, conn = conn}
end

local function toggleESP(state)
	espEnabled = state
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					createESP(p)
				end
				p.CharacterAdded:Connect(function()
					repeat task.wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
					if espEnabled then createESP(p) end
				end)
			end
		end
	else
		for p in pairs(espObjects) do
			removeESP(p)
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		repeat task.wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if espEnabled then createESP(p) end
	end)
end)

-------------------------------------------------
-- 🧩 Modular Feature System
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenuUI"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 300)
frame.Position = UDim2.new(1, -250, 0, 110)
frame.BackgroundColor3 = Color3.fromRGB(28,28,28)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "🎮 Mod Menu v5.0 Fly Update"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Fungsi pembuat tombol fitur modular
local function addFeature(name, onToggle)
	local index = #featureList
	local y = 40 + (index * 35)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 28)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Text = name .. " [OFF]"
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		onToggle(state)
		if state then
			btn.Text = name .. " [ON]"
			btn.BackgroundColor3 = Color3.fromRGB(40,160,60)
		else
			btn.Text = name .. " [OFF]"
			btn.BackgroundColor3 = Color3.fromRGB(170,40,40)
		end
	end)

	table.insert(featureList, {btn = btn, toggle = onToggle})
end

-------------------------------------------------
-- 🎣 Fish It Feature (Submenu)
-------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- safe remote getter
local function safeGet(name)
    local ok, v = pcall(function()
        return ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net[name]
    end)
    return ok and v or nil
end

-- remotes
local REFishingCompleted = safeGet("RE/FishingCompleted")
local RFEquipOxygenTank = safeGet("RF/EquipOxygenTank")
local RFUpdateFishingRadar = safeGet("RF/UpdateFishingRadar")

-- buat popup frame
local fishFrame = Instance.new("Frame", gui)
fishFrame.Size = UDim2.new(0, 200, 0, 200)
fishFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
fishFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
fishFrame.Visible = false
fishFrame.Active = true
fishFrame.Draggable = true
Instance.new("UICorner", fishFrame).CornerRadius = UDim.new(0, 10)

local fishTitle = Instance.new("TextLabel", fishFrame)
fishTitle.Size = UDim2.new(1, -20, 0, 30)
fishTitle.Position = UDim2.new(0, 10, 0, 6)
fishTitle.BackgroundTransparency = 1
fishTitle.Text = "🎣 Fish It Menu"
fishTitle.Font = Enum.Font.GothamBold
fishTitle.TextSize = 14
fishTitle.TextColor3 = Color3.new(1,1,1)
fishTitle.TextXAlignment = Enum.TextXAlignment.Left

local closeFish = Instance.new("TextButton", fishFrame)
closeFish.Size = UDim2.new(0, 26, 0, 26)
closeFish.Position = UDim2.new(1, -34, 0, 6)
closeFish.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeFish.Text = "X"
closeFish.Font = Enum.Font.GothamBold
closeFish.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeFish).CornerRadius = UDim.new(0, 6)
closeFish.MouseButton1Click:Connect(function()
    fishFrame.Visible = false
end)

-- fungsi pembuat tombol kecil
local function makeFishBtn(text, orderY, callback)
    local btn = Instance.new("TextButton", fishFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 40 + (orderY * 40))
    btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text .. " [OFF]"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        callback(state)
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
            btn.Text = text .. " [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
            btn.Text = text .. " [OFF]"
        end
    end)
    return btn
end

-------------------------------------------------
-- ⚡ Fast Fishing
-------------------------------------------------
local fastFishingEnabled = false
makeFishBtn("⚡ Fast Fishing", 0, function(state)
    fastFishingEnabled = state
end)

task.spawn(function()
    while task.wait(0.1) do
        if fastFishingEnabled and REFishingCompleted then
            pcall(function()
                REFishingCompleted:FireServer()
            end)
        end
    end
end)

-------------------------------------------------
-- 🤿 Diving Gear
-------------------------------------------------
makeFishBtn("🤿 Diving Gear", 1, function(state)
    if state and RFEquipOxygenTank then
        pcall(function()
            RFEquipOxygenTank:InvokeServer(105)
        end)
    end
end)

-------------------------------------------------
-- 📡 Radar
-------------------------------------------------
makeFishBtn("📡 Radar", 2, function(state)
    if RFUpdateFishingRadar then
        pcall(function()
            RFUpdateFishingRadar:InvokeServer(state)
        end)
    end
end)



-------------------------------------------------
-- 🧩 Tambah Fitur Lama ke Sistem Modular
-------------------------------------------------
addFeature("🌿 FPS Booster", function(state)
	if state then BoostFPS() else RestoreSettings() end
end)

addFeature("🚀 Infinite Jump", function(state)
	infJumpEnabled = state
end)

addFeature("👁️ ESP", function(state)
	toggleESP(state)
end)

addFeature("🎣 Fish It", function(state)
    fishFrame.Visible = state
end)

-------------------------------------------------
-- 📦 Teleport Data (Gunung List)
-------------------------------------------------
local teleportData = {
	["Gunung Sumbing"] = {
		icon = "⛰️",
		points = {
			{ name = "Awal", pos = Vector3.new(-391.71, 5.01, 245.32) },
			{ name = "cp1", pos = Vector3.new(-376.50, 425.01, 2182.94) },
			{ name = "cp2", pos = Vector3.new(-368.54, 830.67, 3123.00) },
			{ name = "cp3", pos = Vector3.new(-47.78, 1263.81, 4013.42) },
			{ name = "cp4", pos = Vector3.new(-1014.69, 1553.01, 4823.71) },
			{ name = "cp5", pos = Vector3.new(-989.67, 1896.13, 5426.57) },
		}
	},
    ["Gunung Prambanan"] = {
		icon = "⛰️",
		points = {
			{ name = "cp1", pos = Vector3.new(-313.019, 37.941, 878.038) },
			{ name = "cp2", pos = Vector3.new(-78.025, 46.134, 935.538) },
			{ name = "cp3", pos = Vector3.new(-79.244, 121.737, 1013.295) },
			{ name = "cp4", pos = Vector3.new(-111.648, 121.976, 789.963) },
			{ name = "cp5", pos = Vector3.new(53.335, 221.885, 809.889) },
			{ name = "cp6", pos = Vector3.new(72.573, 218.971, 896.509) },
			{ name = "cp7", pos = Vector3.new(65.019, 202.593, 1390.312) },
			{ name = "cp8", pos = Vector3.new(377.617, 110.672, 1883.454) },
			{ name = "cp9", pos = Vector3.new(597.975, 154.437, 1210.952) },
			{ name = "cp10", pos = Vector3.new(840.955, 194.321, 862.219) },
			{ name = "cp11", pos = Vector3.new(568.781, 222.976, 576.038) },
			{ name = "cp12", pos = Vector3.new(139.471, 410.136, 309.629) },
			{ name = "cp13", pos = Vector3.new(113.769, 407.232, 165.234) },
			{ name = "cp14", pos = Vector3.new(410.260, 408.099, -11.131) },
			{ name = "cp15", pos = Vector3.new(631.684, 406.593, -50.940) },
			{ name = "cp16", pos = Vector3.new(1317.062, 402.275, -18.839) },
			{ name = "cp17", pos = Vector3.new(1846.751, 270.437, -256.768) },
			{ name = "cp18", pos = Vector3.new(1943.206, 270.437, -475.053) },
			{ name = "cp19", pos = Vector3.new(1773.749, 354.437, -497.223) },
			{ name = "cp20", pos = Vector3.new(1341.667, 354.437, -519.987) },
			{ name = "cp21", pos = Vector3.new(1134.124, 361.636, -507.621) },
			{ name = "cp22", pos = Vector3.new(884.959, 422.593, -501.815) },
			{ name = "cp23", pos = Vector3.new(220.728, 410.129, -659.692) },
			{ name = "cp24", pos = Vector3.new(108.022, 510.437, -550.268) },
			{ name = "cp25", pos = Vector3.new(-287.965, 554.337, -349.616) },
			{ name = "cp26", pos = Vector3.new(-890.938, 513.008, -615.087) },
		}
	},

	["Gunung YNTKTS"] = {
		icon = "🏔️",
		points = {
			{ name = "cp1", pos = Vector3.new(-45.633, 42.523, -555.684) },
			{ name = "cp2", pos = Vector3.new(831.428, 66.533, -430.544) },
			{ name = "cp3", pos = Vector3.new(1016.156, 71.146, -109.264) },
			{ name = "cp4", pos = Vector3.new(2087.681, 70.532, -149.818) },
			{ name = "cp5", pos = Vector3.new(2329.175, 62.750, -135.099) },
			{ name = "cp6", pos = Vector3.new(2548.745, 42.401, -412.719) },
			{ name = "cp7", pos = Vector3.new(2679.067, 86.612, -335.003) },
			{ name = "cp8", pos = Vector3.new(2710.476, 158.735, -363.584) },
			{ name = "cp9", pos = Vector3.new(3032.635, 154.528, -367.989) },
			{ name = "cp10", pos = Vector3.new(3238.665, 118.545, -411.910) },
			{ name = "cp11", pos = Vector3.new(3667.236, 22.669, -219.243) },
			{ name = "cp12", pos = Vector3.new(3725.937, 90.527, -246.372) },
			{ name = "cp13", pos = Vector3.new(3965.504, 66.756, -309.780) },
			{ name = "cp14", pos = Vector3.new(4438.375, 83.462, -308.013) },
		}
	},
	["Gunung Aneh"] = {
		icon = "🗻",
		points = {
			{ name = "cp2", pos = Vector3.new(-23.69, 597.01, 507.89) },
			{ name = "cp3", pos = Vector3.new(468.91, 601.01, 443.64) },
			{ name = "cp4", pos = Vector3.new(1172.81, 646.01, 668.12) },
			{ name = "cp5", pos = Vector3.new(2124.97, 786.40, 1024.68) },
			{ name = "cp6", pos = Vector3.new(2726.26, 916.01, 1196.33) },
			{ name = "cp7", pos = Vector3.new(3451.35, 1309.01, 1768.11) },
			{ name = "cp8", pos = Vector3.new(3205.85, 1613.01, 2725.28) },
		}
	},
	["Gunung Kawai"] = {
		icon = "🌋",
		points = {
			{ name = "cp1", pos = Vector3.new(275.65, 84.73, 247.94) },
			{ name = "cp2", pos = Vector3.new(583.77, 275.87, -56.04) },
			{ name = "cp3", pos = Vector3.new(1200.37, 273.29, 293.01) },
			{ name = "cp4", pos = Vector3.new(1551.19, 286.17, 288.59) },
			{ name = "cp5", pos = Vector3.new(1819.28, 325.01, -7.08) },
			{ name = "cp6", pos = Vector3.new(2256.92, 397.61, 109.88) },
			{ name = "cp7", pos = Vector3.new(3165.28, 513.01, 334.94) },
			{ name = "cp8", pos = Vector3.new(3670.93, 494.24, 251.00) },
			{ name = "cp9", pos = Vector3.new(4221.57, 492.12, 514.72) },
			{ name = "cp10", pos = Vector3.new(4414.23, 709.01, 809.32) },
			{ name = "cp11", pos = Vector3.new(4370.59, 701.41, 1875.67) },
			{ name = "cp12", pos = Vector3.new(5029.31, 445.93, 2445.03) },
			{ name = "cp13", pos = Vector3.new(5226.98, 447.45, 3078.37) },
			{ name = "cp14", pos = Vector3.new(5252.75, 446.75, 3866.20) },
			{ name = "cp15", pos = Vector3.new(5312.39, 692.43, 4056.49) },
			{ name = "cp16", pos = Vector3.new(5430.21, 1095.96, 4401.30) },
			{ name = "finish", pos = Vector3.new(5139.54, 1147.29, 4713.37) },
		}
	},
["Gunung Yahayuk"] = {
 icon = "⛰️",
 points = {
 { name = "cp1", pos =
 Vector3.new(-420.13, 248.01, 786.83) }, 
{ name = "cp2", pos =
 Vector3.new(-332.34, 387.01, 525.27) }, 
{ name = "cp3", pos =
 Vector3.new(295.65, 428.73, 494.68) }, 
{ name = "cp4", pos =
 Vector3.new(327.19, 489.01, 345.06) }, 
{ name = "cp5", pos = 
Vector3.new(231.39, 313.01, -145.40) }, 
{ name = "cp6", pos = 
Vector3.new(-478.91, 710.34, -409.71) },
 }
 },

	["Gunung Pengganguran"] = {
		icon = "🏔️",
		points = {
			{ name = "cp1", pos = Vector3.new(-60.969, 53.007, -1173.702) },
			{ name = "cp2", pos = Vector3.new(-378.102, 145.008, -1781.101) },
			{ name = "cp3", pos = Vector3.new(-587.527, 276.789, -1570.368) },
			{ name = "cp4", pos = Vector3.new(-951.935, 253.008, -1579.784) },
			{ name = "cp5", pos = Vector3.new(-1277.299, 256.756, -1798.436) },
			{ name = "cp6", pos = Vector3.new(-1645.830, 168.987, -1671.342) },
			{ name = "cp7", pos = Vector3.new(-2141.449, 377.008, -1334.677) },
			{ name = "cp8", pos = Vector3.new(-1991.575, 477.008, -184.452) },
			{ name = "cp9", pos = Vector3.new(-2385.999, 585.007, -111.349) },
			{ name = "cp10", pos = Vector3.new(-2023.047, 724.566, 64.546) },
			{ name = "cp11", pos = Vector3.new(-1621.521, 747.467, -8.590) },
			{ name = "cp12", pos = Vector3.new(-1843.068, 784.807, 639.782) },
			{ name = "cp13", pos = Vector3.new(-2260.079, 1021.007, 1434.147) },
			{ name = "cp14", pos = Vector3.new(-2377.022, 1061.007, 1834.373) },
			{ name = "cp15", pos = Vector3.new(-2713.954, 1205.007, 1921.084) },
			{ name = "cp16", pos = Vector3.new(-3081.088, 1337.007, 1858.613) },
			{ name = "cp17", pos = Vector3.new(-3235.904, 1337.007, 2173.848) },
			{ name = "finish", pos = Vector3.new(-3337.460, 1424.834, 2207.007) },
		}
	},
	["Gunung Rindara"] = {
		icon = "🌄",
		points = {
			{ name = "cp1", pos = Vector3.new(-6.942, 68.008, -45.782) },
			{ name = "cp2", pos = Vector3.new(-31.496, 33.614, -462.236) },
			{ name = "cp3", pos = Vector3.new(344.766, 81.008, -769.411) },
			{ name = "cp4", pos = Vector3.new(-107.222, 141.008, -1380.291) },
			{ name = "cp5", pos = Vector3.new(-612.847, 219.089, -1331.625) },
			{ name = "cp6", pos = Vector3.new(-1143.874, 186.507, -1584.812) },
			{ name = "cp7", pos = Vector3.new(-1028.492, 185.008, -1812.884) },
			{ name = "cp8", pos = Vector3.new(-121.310, 356.770, -3007.281) },
			{ name = "cp9", pos = Vector3.new(-807.717, 321.008, -3179.727) },
			{ name = "cp10", pos = Vector3.new(-629.122, 362.349, -4072.554) },
			{ name = "cp11", pos = Vector3.new(-84.064, 492.885, -4365.187) },
			{ name = "cp12", pos = Vector3.new(-170.922, 476.542, -4773.956) },
			{ name = "cp13", pos = Vector3.new(-171.837, 553.007, -4904.244) },
			{ name = "cp14", pos = Vector3.new(-204.188, 593.007, -5047.344) },
			{ name = "cp15", pos = Vector3.new(-272.518, 645.007, -4948.372) },
			{ name = "cp16", pos = Vector3.new(-93.343, 701.007, -5050.534) },
			{ name = "cp17", pos = Vector3.new(343.711, 609.897, -4955.690) },
			{ name = "cp18", pos = Vector3.new(644.947, 651.565, -4508.574) },
			{ name = "cp19", pos = Vector3.new(900.133, 677.007, -4327.476) },
			{ name = "cp20", pos = Vector3.new(1288.082, 776.831, -4648.964) },
			{ name = "cp21", pos = Vector3.new(1657.953, 821.327, -4200.537) },
			{ name = "cp22", pos = Vector3.new(1667.865, 933.901, -5006.915) },
			{ name = "finish", pos = Vector3.new(1744.773, 1104.645, -5026.188) },
		}
	},
        ["Gunung Taroja"] = {
		icon = "🗻",
		points = {
			{ name = "cp1", pos = Vector3.new(4.786, 112.448, 98.836) },
			{ name = "cp2", pos = Vector3.new(-71.968, 160.141, -314.002) },
			{ name = "cp3", pos = Vector3.new(518.516, 317.808, -362.968) },
			{ name = "cp4", pos = Vector3.new(869.861, 413.958, -1016.750) },
			{ name = "cp5", pos = Vector3.new(653.632, 649.007, -1282.004) },
			{ name = "cp6", pos = Vector3.new(696.596, 950.007, -1671.589) },
			{ name = "cp7", pos = Vector3.new(799.355, 1145.007, -1844.764) },
			{ name = "cp8", pos = Vector3.new(1248.602, 1350.007, -1786.630) },
			{ name = "Finish", pos = Vector3.new(1338.813, 1753.815, -2986.280) },
		}
	},
}

-------------------------------------------------
-- 🧭 Teleport Functions
-------------------------------------------------
local function teleportTo(position)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char:MoveTo(position)
	end
end

local function startAutoTeleport(gunungName)
	if autoTeleportThread then task.cancel(autoTeleportThread) end
	autoTeleportThread = task.spawn(function()
		local gunung = teleportData[gunungName]
		if not gunung then return end
		for i, point in ipairs(gunung.points) do
			if not autoTeleportEnabled then break end
			teleportTo(point.pos)
			game.StarterGui:SetCore("SendNotification", {
				Title = "🧭 Auto Teleport",
				Text = string.format("(%d/%d) %s - %s", i, #gunung.points, gunungName, point.name),
				Duration = 2
			})
			task.wait(autoTeleportDelay)
		end
		autoTeleportEnabled = false
	end)
end

-------------------------------------------------
-- 📋 Copy Coordinate
-------------------------------------------------
local function copyCoordinate()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local pos = char.HumanoidRootPart.Position
		local vecStr = string.format("Vector3.new(%.3f, %.3f, %.3f)", pos.X, pos.Y, pos.Z)
		pcall(function() setclipboard(vecStr) end)
		game.StarterGui:SetCore("SendNotification", {
			Title="📋 Copied!",
			Text="Koordinat disalin ke clipboard.",
			Duration=3
		})
	end
end


-------------------------------------------------
-- 🎨 GUI Setup Tambahan
-------------------------------------------------
local openBtn = Instance.new("ImageButton", gui)
openBtn.Size = UDim2.new(0, 45, 0, 45)
openBtn.Position = UDim2.new(1, -65, 0, 60)
openBtn.BackgroundTransparency = 1
openBtn.Image = "rbxassetid://6034509993"
openBtn.ImageColor3 = Color3.fromRGB(230,230,230)

local teleportFrame = Instance.new("Frame", gui)
teleportFrame.Size = UDim2.new(0, 260, 0, 320)
teleportFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
teleportFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
teleportFrame.Visible = false
teleportFrame.Active = true
teleportFrame.Draggable = true
Instance.new("UICorner", teleportFrame).CornerRadius = UDim.new(0, 10)

local teleportTitle = Instance.new("TextLabel", teleportFrame)
teleportTitle.Size = UDim2.new(1, -20, 0, 30)
teleportTitle.Position = UDim2.new(0, 10, 0, 8)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "📦 PILIH GUNUNG"
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 14
teleportTitle.TextColor3 = Color3.new(1,1,1)
teleportTitle.TextXAlignment = Enum.TextXAlignment.Left

local closeTeleport = Instance.new("TextButton", teleportFrame)
closeTeleport.Size = UDim2.new(0, 28, 0, 28)
closeTeleport.Position = UDim2.new(1, -38, 0, 6)
closeTeleport.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeTeleport.Text = "X"
closeTeleport.Font = Enum.Font.GothamBold
closeTeleport.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeTeleport).CornerRadius = UDim.new(0, 6)

local teleportList = Instance.new("ScrollingFrame", teleportFrame)
teleportList.Size = UDim2.new(1, -20, 1, -50)
teleportList.Position = UDim2.new(0, 10, 0, 40)
teleportList.BackgroundTransparency = 1
teleportList.ScrollBarThickness = 4
teleportList.CanvasSize = UDim2.new(0,0,0,0)

local teleportLayout = Instance.new("UIListLayout", teleportList)
teleportLayout.Padding = UDim.new(0,3)
teleportLayout.SortOrder = Enum.SortOrder.LayoutOrder

-------------------------------------------------
-- 📦 Teleport GUI Logic
-------------------------------------------------
local function makeTeleportBtn(text, color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 28)
	b.BackgroundColor3 = color or Color3.fromRGB(70,70,70)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.Text = text
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local function clearTeleportEntries()
	for _, child in pairs(teleportList:GetChildren()) do
		if child ~= teleportLayout then child:Destroy() end
	end
end

local function showGunungList()
	clearTeleportEntries()
	teleportTitle.Text = "📦 PILIH GUNUNG"
	for gunungName, gunungInfo in pairs(teleportData) do
		local btn = makeTeleportBtn((gunungInfo.icon or "").." "..gunungName)
		btn.Parent = teleportList
		btn.MouseButton1Click:Connect(function()
			showCheckpointList(gunungName)
		end)
	end
	task.wait(0.05)
	teleportList.CanvasSize = UDim2.new(0,0,0,teleportLayout.AbsoluteContentSize.Y+5)
end

function showCheckpointList(gunungName)
	clearTeleportEntries()
	local info = teleportData[gunungName]
	teleportTitle.Text = (info.icon or "").." "..gunungName

	local autoBtn = makeTeleportBtn("⚙️ Auto Teleport [OFF]", Color3.fromRGB(100,40,40))
	autoBtn.Parent = teleportList

	local delayBox = Instance.new("TextBox", teleportList)
	delayBox.Size = UDim2.new(1, 0, 0, 28)
	delayBox.PlaceholderText = "Delay (1-120 detik)"
	delayBox.Text = tostring(autoTeleportDelay)
	delayBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
	delayBox.TextColor3 = Color3.new(1,1,1)
	delayBox.Font = Enum.Font.GothamBold
	delayBox.TextScaled = true
	Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0,6)

	autoBtn.MouseButton1Click:Connect(function()
		autoTeleportEnabled = not autoTeleportEnabled
		autoBtn.Text = autoTeleportEnabled and "⚙️ Auto Teleport [ON]" or "⚙️ Auto Teleport [OFF]"
		if autoTeleportEnabled then
			startAutoTeleport(gunungName)
		end
	end)

	delayBox.FocusLost:Connect(function()
		local n = tonumber(delayBox.Text)
		if n and n>=1 and n<=120 then
			autoTeleportDelay = n
		else
			delayBox.Text = tostring(autoTeleportDelay)
		end
	end)

	for _, point in ipairs(info.points) do
		local btn = makeTeleportBtn("➡️ "..point.name, Color3.fromRGB(80,80,80))
		btn.Parent = teleportList
		btn.MouseButton1Click:Connect(function()
			teleportTo(point.pos)
			game.StarterGui:SetCore("SendNotification", {
				Title = "✅ Teleport",
				Text = "Berhasil ke "..gunungName.." - "..point.name,
				Duration = 2
			})
		end)
	end

	local back = makeTeleportBtn("⬅️ Kembali", Color3.fromRGB(170,40,40))
	back.Parent = teleportList
	back.MouseButton1Click:Connect(showGunungList)

	task.wait(0.05)
	teleportList.CanvasSize = UDim2.new(0,0,0,teleportLayout.AbsoluteContentSize.Y+5)
end

-------------------------------------------------
-- ✈️ Fly System (PC + Mobile)
-------------------------------------------------
local _flyEnabled = false
local _flyVel, _flyGyro
local _flyAscend = 0
local _FLY_SPEED = 70
local _FLY_VERT = 60
local _FLY_SMOOTH = 0.2

local function _createFlyControllers(hrp)
	_flyVel = Instance.new("BodyVelocity")
	_flyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
	_flyVel.P = 1500
	_flyVel.Velocity = Vector3.new()
	_flyVel.Parent = hrp

	_flyGyro = Instance.new("BodyGyro")
	_flyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
	_flyGyro.P = 3000
	_flyGyro.CFrame = hrp.CFrame
	_flyGyro.Parent = hrp
end

local function _destroyFlyControllers()
	if _flyVel then _flyVel:Destroy() _flyVel = nil end
	if _flyGyro then _flyGyro:Destroy() _flyGyro = nil end
end

local function _toggleFly(state)
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	_flyEnabled = state
	if state then
		hum.PlatformStand = true
		_createFlyControllers(hrp)
	else
		hum.PlatformStand = false
		_destroyFlyControllers()
		_flyAscend = 0
		local pg = player:FindFirstChild("PlayerGui")
		if pg and pg:FindFirstChild("FlyControls") then
			pg.FlyControls:Destroy()
		end
	end
end

RunService.RenderStepped:Connect(function()
	if not _flyEnabled or not _flyVel or not _flyGyro then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	local cam = workspace.CurrentCamera
	local move = hum.MoveDirection
	local f = (cam.CFrame.LookVector * Vector3.new(1,0,1)).Unit
	local r = (cam.CFrame.RightVector * Vector3.new(1,0,1)).Unit
	local desired = (f * move.Z + r * move.X)
	if desired.Magnitude > 1 then desired = desired.Unit end

	local horiz = desired * _FLY_SPEED
	local vert = Vector3.new(0, _flyAscend * _FLY_VERT, 0)
	_flyVel.Velocity = _flyVel.Velocity:Lerp(horiz+vert, _FLY_SMOOTH)
	local look = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
	_flyGyro.CFrame = _flyGyro.CFrame:Lerp(look, _FLY_SMOOTH*2)
end)

UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.E then
		_flyAscend = 1
	elseif input.KeyCode == Enum.KeyCode.Q then
		_flyAscend = -1
	end
end)
UIS.InputEnded:Connect(function(input,gp)
	if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Q then
		_flyAscend = 0
	end
end)

-- UI tombol Fly di HP (otomatis muncul)
local function _createFlyUI()
	local pg = player:WaitForChild("PlayerGui")
	local guiFly = Instance.new("ScreenGui")
	guiFly.Name = "FlyControls"
	guiFly.Parent = pg

	local function btn(name, text, y)
		local b = Instance.new("TextButton", guiFly)
		b.Name = name
		b.Size = UDim2.new(0,80,0,40)
		b.Position = UDim2.new(1,-100,1,y)
		b.BackgroundColor3 = Color3.fromRGB(30,30,30)
		b.TextColor3 = Color3.new(1,1,1)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 16
		b.Text = text
		local u = Instance.new("UICorner", b)
		u.CornerRadius = UDim.new(0,10)
		return b
	end

	local t = btn("Toggle","FLY OFF",-180)
	local u = btn("Up","▲",-130)
	local d = btn("Down","▼",-80)

	t.MouseButton1Click:Connect(function()
		_toggleFly(not _flyEnabled)
		t.Text = _flyEnabled and "FLY ON" or "FLY OFF"
	end)
	u.MouseButton1Down:Connect(function() _flyAscend = 1 end)
	u.MouseButton1Up:Connect(function() _flyAscend = 0 end)
	d.MouseButton1Down:Connect(function() _flyAscend = -1 end)
	d.MouseButton1Up:Connect(function() _flyAscend = 0 end)
end

-- lanjut dari Part 2
-------------------------------------------------
-- 📱 Auto-create Fly UI saat aktif
-------------------------------------------------
RunService.Heartbeat:Connect(function()
	if _flyEnabled then
		local pg = player:FindFirstChild("PlayerGui")
		if pg and not pg:FindFirstChild("FlyControls") then
			_createFlyUI()
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	task.wait(1)
	if _flyEnabled then
		_toggleFly(true)
	end
end)

-------------------------------------------------
-- ✈️ Tambah Tombol Fly ke Menu Utama
-------------------------------------------------
addFeature("✈️ Fly Mode", function(state)
	_toggleFly(state)
	if state then
		_createFlyUI()
	else
		local pg = player:FindFirstChild("PlayerGui")
		if pg and pg:FindFirstChild("FlyControls") then
			pg.FlyControls:Destroy()
		end
	end
end)

-------------------------------------------------
-- 📋 Copy Coordinate Button
-------------------------------------------------
addFeature("📋 Copy Coordinate", function(state)
	if state then
		copyCoordinate()
		task.delay(1, function()
			for _, f in ipairs(featureList) do
				if f.btn.Text:find("Copy Coordinate") then
					f.btn.Text = "📋 Copy Coordinate [OFF]"
					f.btn.BackgroundColor3 = Color3.fromRGB(170,40,40)
				end
			end
		end)
	end
end)

-------------------------------------------------
-- 🧭 Teleport Menu Button
-------------------------------------------------
addFeature("🧭 Teleport Menu", function(state)
	teleportFrame.Visible = state
end)
-------------------------------------------------
-- 🧍 Teleport To Player (with popup + refresh)
-------------------------------------------------
local teleportPlayerFrame = Instance.new("Frame", gui)
teleportPlayerFrame.Size = UDim2.new(0, 260, 0, 300)
teleportPlayerFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
teleportPlayerFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
teleportPlayerFrame.Visible = false
teleportPlayerFrame.Active = true
teleportPlayerFrame.Draggable = true
Instance.new("UICorner", teleportPlayerFrame).CornerRadius = UDim.new(0, 10)

-- Title bar
local tpTitle = Instance.new("TextLabel", teleportPlayerFrame)
tpTitle.Size = UDim2.new(1, -20, 0, 30)
tpTitle.Position = UDim2.new(0, 10, 0, 6)
tpTitle.BackgroundTransparency = 1
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 14
tpTitle.TextColor3 = Color3.new(1, 1, 1)
tpTitle.Text = "🧍 Teleport To Player"
tpTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol X
local closeTP = Instance.new("TextButton", teleportPlayerFrame)
closeTP.Size = UDim2.new(0, 26, 0, 26)
closeTP.Position = UDim2.new(1, -34, 0, 6)
closeTP.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
closeTP.Text = "X"
closeTP.Font = Enum.Font.GothamBold
closeTP.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeTP).CornerRadius = UDim.new(0, 6)
closeTP.MouseButton1Click:Connect(function()
    teleportPlayerFrame.Visible = false
end)

-- 🔄 Tombol Refresh
local refreshBtn = Instance.new("TextButton", teleportPlayerFrame)
refreshBtn.Size = UDim2.new(0.9, 0, 0, 32)
refreshBtn.Position = UDim2.new(0.05, 0, 0, 40)
refreshBtn.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 14
refreshBtn.Text = "🔄 Refresh Player List"
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)

-- Scroll list pemain
local scroll = Instance.new("ScrollingFrame", teleportPlayerFrame)
scroll.Size = UDim2.new(1, -20, 1, -85)
scroll.Position = UDim2.new(0, 10, 0, 80)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi refresh daftar pemain
local function refreshPlayerList()
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton", scroll)
			btn.Size = UDim2.new(1, 0, 0, 32)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.Text = p.Name
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

			btn.MouseButton1Click:Connect(function()
				local char = player.Character
				local targetChar = p.Character
				if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
					char:MoveTo(targetChar.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
					game.StarterGui:SetCore("SendNotification", {
						Title = "✅ Teleport",
						Text = "Teleport ke " .. p.Name,
						Duration = 3
					})
				else
					game.StarterGui:SetCore("SendNotification", {
						Title = "⚠️ Gagal",
						Text = "Tidak bisa teleport ke " .. p.Name,
						Duration = 3
					})
				end
			end)
		end
	end

	task.wait(0.05)
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

-- Hubungkan tombol refresh ke fungsi di atas
refreshBtn.MouseButton1Click:Connect(function()
	refreshPlayerList()
	game.StarterGui:SetCore("SendNotification", {
		Title = "🔄 Player List",
		Text = "Daftar pemain diperbarui.",
		Duration = 2
	})
end)

-------------------------------------------------
-- Tambahkan tombol utama ke menu
-------------------------------------------------
addFeature("🧍 Teleport To Player", function(state)
	if state then
		refreshPlayerList()
		teleportPlayerFrame.Visible = true
	else
		teleportPlayerFrame.Visible = false
	end
end)

-------------------------------------------------
-- 🧠 Menu Toggle (Buka/Tutup)
-------------------------------------------------
openBtn.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	frame.Visible = menuVisible
end)

closeTeleport.MouseButton1Click:Connect(function()
	teleportFrame.Visible = false
end)

showGunungList()

-------------------------------------------------
-- 🧩 Penutup + Info Developer
-------------------------------------------------
print("[✅ Mod Menu v5.0 Fly Update Loaded Successfully]")
print("Fitur: FPS, Jump, ESP, Teleport, Copy Coord, Fly")
print("By Ady & ChatGPT")

game.StarterGui:SetCore("SendNotification", {
	Title = "🎮 Mod Menu v5.0",
	Text = "Fly Update aktif — tekan tombol untuk membuka menu",
	Duration = 6
})

-------------------------------------------------
-- 📖 Dokumentasi Singkat: Menambah Fitur Baru
-------------------------------------------------
-- Cukup tambahkan baris ini setelah tombol lain:
-- addFeature("🔥 Nama Fitur", function(state)
--     if state then
--         -- aktifkan fitur
--     else
--         -- matikan fitur
--     end
-- end)
--
-- Contoh:
-- addFeature("⚡ Speed Boost", function(state)
--     local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
--     if hum then
--         hum.WalkSpeed = state and 80 or 16
--     end
-- end)
--
-- Semua fitur akan otomatis muncul di menu dengan gaya dan warna yang sama.
-- Tombol akan menyesuaikan urutan berdasarkan urutan kamu menulis addFeature().