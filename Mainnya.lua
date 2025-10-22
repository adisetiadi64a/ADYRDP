-- https://github.com/BloodLetters/Ash-Libs
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

GUI:CreateMain({
    Name = "Ady",
    title = "Ady HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(50, 50, 60),
        NavBackground = Color3.fromRGB(20, 20, 30)
    },
    Blur = {
        Enable = false,
        value = 0.2
    },
    Config = {
        Enabled = false,
    }
})

-------------------------------------------------
-- 🏠 Main Tab
-------------------------------------------------
local main = GUI:CreateTab("Main", "home")

GUI:CreateSection({
    parent = main,  
    text = "Section"
})

GUI:CreateButton({
    parent = main,  
    text = "Wellcome",  
    callback = function()
        GUI:CreateNotify({title = "Welcome", description = "Welcome to Ady Hub!"})
    end
})

-------------------------------------------------
-- 🧍 Player Tab
-------------------------------------------------
local playerTab = GUI:CreateTab("Player", "user")
GUI:CreateSection({ parent = playerTab, text = "Player Settings" })

-------------------------------------------------
-- 🚀 Infinite Jump
-------------------------------------------------
local UIS = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local infJumpEnabled = false

UIS.JumpRequest:Connect(function()
	if infJumpEnabled then
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

GUI:CreateButton({
	parent = playerTab,
	text = "🚀 Toggle Infinite Jump",
	callback = function()
		infJumpEnabled = not infJumpEnabled
		if infJumpEnabled then
			GUI:CreateNotify({ title = "Infinite Jump", description = "Infinite Jump Aktif ✅" })
		else
			GUI:CreateNotify({ title = "Infinite Jump", description = "Infinite Jump Nonaktif ❌" })
		end
	end
})

-------------------------------------------------
-- ✈️ Fly Mode dengan GUI Naik/Turun
-------------------------------------------------
local RunService = game:GetService("RunService")

local flyEnabled = false
local flyVel, flyGyro, flyAscend = nil, nil, 0
local FLY_SPEED = 70
local FLY_VERT = 60
local FLY_SMOOTH = 0.2

-- buat kontrol fisik fly
local function createFlyControllers(hrp)
	flyVel = Instance.new("BodyVelocity")
	flyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	flyVel.P = 1500
	flyVel.Velocity = Vector3.new()
	flyVel.Parent = hrp

	flyGyro = Instance.new("BodyGyro")
	flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	flyGyro.P = 3000
	flyGyro.CFrame = hrp.CFrame
	flyGyro.Parent = hrp
end

local function destroyFlyControllers()
	if flyVel then flyVel:Destroy() flyVel = nil end
	if flyGyro then flyGyro:Destroy() flyGyro = nil end
end

-- toggle fly utama
local function toggleFly(state)
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")

	flyEnabled = state
	if state then
		hum.PlatformStand = true
		createFlyControllers(hrp)
		GUI:CreateNotify({ title = "Fly Mode", description = "Fly Mode Aktif ✅" })
	else
		hum.PlatformStand = false
		destroyFlyControllers()
		flyAscend = 0
		local pg = player:FindFirstChild("PlayerGui")
		if pg and pg:FindFirstChild("FlyControls") then
			pg.FlyControls:Destroy()
		end
		GUI:CreateNotify({ title = "Fly Mode", description = "Fly Mode Nonaktif ❌" })
	end
end

-- gerakan fly
RunService.RenderStepped:Connect(function()
	if not flyEnabled or not flyVel or not flyGyro then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	local cam = workspace.CurrentCamera
	local move = hum.MoveDirection
	local f = (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
	local r = (cam.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
	local desired = (f * move.Z + r * move.X)
	if desired.Magnitude > 1 then desired = desired.Unit end

	local horiz = desired * FLY_SPEED
	local vert = Vector3.new(0, flyAscend * FLY_VERT, 0)
	flyVel.Velocity = flyVel.Velocity:Lerp(horiz + vert, FLY_SMOOTH)
	local look = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
	flyGyro.CFrame = flyGyro.CFrame:Lerp(look, FLY_SMOOTH * 2)
end)

-- key E/Q naik turun
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.E then
		flyAscend = 1
	elseif input.KeyCode == Enum.KeyCode.Q then
		flyAscend = -1
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Q then
		flyAscend = 0
	end
end)

-- buat GUI Fly (HP/PC)
local function createFlyUI()
	local pg = player:WaitForChild("PlayerGui")
	if pg:FindFirstChild("FlyControls") then pg.FlyControls:Destroy() end

	local guiFly = Instance.new("ScreenGui")
	guiFly.Name = "FlyControls"
	guiFly.Parent = pg

	local function makeBtn(name, text, y)
		local b = Instance.new("TextButton", guiFly)
		b.Name = name
		b.Size = UDim2.new(0, 80, 0, 40)
		b.Position = UDim2.new(1, -100, 1, y)
		b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 16
		b.Text = text
		local u = Instance.new("UICorner", b)
		u.CornerRadius = UDim.new(0, 10)
		return b
	end

	local toggleBtn = makeBtn("Toggle", "FLY OFF", -180)
	local upBtn = makeBtn("Up", "▲", -130)
	local downBtn = makeBtn("Down", "▼", -80)

	toggleBtn.MouseButton1Click:Connect(function()
		toggleFly(not flyEnabled)
		toggleBtn.Text = flyEnabled and "FLY ON" or "FLY OFF"
	end)
	upBtn.MouseButton1Down:Connect(function() flyAscend = 1 end)
	upBtn.MouseButton1Up:Connect(function() flyAscend = 0 end)
	downBtn.MouseButton1Down:Connect(function() flyAscend = -1 end)
	downBtn.MouseButton1Up:Connect(function() flyAscend = 0 end)
end

-- tampil otomatis saat aktif
RunService.Heartbeat:Connect(function()
	if flyEnabled then
		local pg = player:FindFirstChild("PlayerGui")
		if pg and not pg:FindFirstChild("FlyControls") then
			createFlyUI()
		end
	end
end)

-- tombol di tab Player
GUI:CreateButton({
	parent = playerTab,
	text = "✈️ Toggle Fly Mode",
	callback = function()
		toggleFly(not flyEnabled)
		if flyEnabled then createFlyUI() end
	end
})

-------------------------------------------------
-- 🚷 Noclip Toggle (langsung di tab Player)
-------------------------------------------------
local noclipActive = false
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local noclipButton = GUI:CreateButton({
	parent = playerTab,
	text = "🚷 Noclip: OFF",
	callback = function()
		noclipActive = not noclipActive
		if noclipActive then
			noclipButton.Text = "🚷 Noclip: ON"
			GUI:CreateNotify({
				title = "Noclip",
				description = "Noclip Aktif ✅"
			})
		else
			noclipButton.Text = "🚷 Noclip: OFF"
			GUI:CreateNotify({
				title = "Noclip",
				description = "Noclip Dimatikan ❌"
			})
		end
	end
})

-- loop ringan untuk jaga CanCollide false saat aktif
RunService.Stepped:Connect(function()
	if not noclipActive then return end
	local char = player.Character
	if char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- kembalikan collide normal saat respawn
player.CharacterAdded:Connect(function(char)
	if not noclipActive then return end
	task.wait(0.3)
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end)

GUI:CreateButton({
    parent = playerTab,
    text = "🕺 Emote AllMap",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/adisetiadi64a/ADYRDP/refs/heads/main/emote.lua"))()
			loadstring(game:HttpGet("https://yarhm.mhi.im/scr?channel=afemmax"))()
    end
})
-------------------------------------------------
-- 🧭 Teleport Tab
-------------------------------------------------
local teleportTab = GUI:CreateTab("Teleport", "cigarette")
GUI:CreateSection({ parent = teleportTab, text = "Teleport To Player" })

-------------------------------------------------
-- 🧍 Teleport to Player (tanpa popup)
-------------------------------------------------
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- frame container untuk daftar pemain
local scrollContainer = Instance.new("ScrollingFrame")
scrollContainer.Parent = teleportTab
scrollContainer.Size = UDim2.new(1, -10, 0, 200)
scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollContainer.ScrollBarThickness = 5
scrollContainer.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scrollContainer)
layout.Padding = UDim.new(0, 3)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- fungsi untuk membuat tombol daftar pemain
local function refreshPlayerList()
	for _, child in pairs(scrollContainer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton", scrollContainer)
			btn.Size = UDim2.new(1, 0, 0, 28)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 13
			btn.Text = "🧍 " .. p.Name
			local u = Instance.new("UICorner", btn)
			u.CornerRadius = UDim.new(0, 6)

			btn.MouseButton1Click:Connect(function()
				local char = player.Character
				local targetChar = p.Character
				if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
					char:MoveTo(targetChar.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
					GUI:CreateNotify({
						title = "✅ Teleport",
						description = "Berhasil teleport ke " .. p.Name,
					})
				else
					GUI:CreateNotify({
						title = "⚠️ Gagal",
						description = "Tidak bisa teleport ke " .. p.Name,
					})
				end
			end)
		end
	end
end

-- tombol refresh daftar pemain
GUI:CreateButton({
	parent = teleportTab,
	text = "🔄 Refresh Player List",
	callback = function()
		refreshPlayerList()
		GUI:CreateNotify({
			title = "Teleport",
			description = "Daftar pemain diperbarui ✅",
		})
	end
})

-- inisialisasi awal
refreshPlayerList()
-------------------------------------------------
-- 🎣 Fish It Tab
-------------------------------------------------
local fishTab = GUI:CreateTab("Fish It", "fish")
GUI:CreateSection({ parent = fishTab, text = "Fishing Tools" })

GUI:CreateButton({
    parent = fishTab,
    text = "🎣 Fish It",
    callback = function()
        GUI:CreateNotify({
            title = "Fish It",
            description = "Loading Fish It script..."
        })
local games = {
    [121864768012064] = "https://raw.githubusercontent.com/adisetiadi64a/ADYRDP/refs/heads/main/FishIt.lua",
}

local currentID = game.PlaceId
local scriptURL = games[currentID]

if scriptURL then
    loadstring(game:HttpGet(scriptURL))()
else
    GUI:CreateNotify({title = "Info", description = "Lu ga di room fish it!"})
			end
            end
})

-------------------------------------------------
-- ⛰️ Gunung Tab
-------------------------------------------------
local gunungTab = GUI:CreateTab("Gunung", "mountain")
GUI:CreateSection({ parent = gunungTab, text = "Menu Gunung" })

GUI:CreateButton({
    parent = gunungTab,
    text = "🧭 Teleport Gunung",
    callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/adisetiadi64a/ADYRDP/refs/heads/main/TeleportBox_Final.txt"))()
    end
})
-------------------------------------------------
-- 🧩 Misc Tab (pengganti Tools)
-------------------------------------------------
local miscTab = GUI:CreateTab("Misc", "wrench")
GUI:CreateSection({ parent = miscTab, text = "Miscellaneous Tools" })
-------------------------------------------------
-- 🌿 FPS Booster
-------------------------------------------------
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local savedSettings = {}
local fpsBoostEnabled = false

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
	Lighting.Ambient = Color3.fromRGB(128, 128, 128)
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
end

local function RestoreSettings()
	for k, v in pairs(savedSettings) do
		if k ~= "QualityLevel" then
			pcall(function() Lighting[k] = v end)
		end
	end
	pcall(function() settings().Rendering.QualityLevel = savedSettings.QualityLevel end)
end

GUI:CreateButton({
	parent = miscTab,
	text = "🌿 Toggle FPS Booster",
	callback = function()
		fpsBoostEnabled = not fpsBoostEnabled
		if fpsBoostEnabled then
			BoostFPS()
			GUI:CreateNotify({ title = "FPS Booster", description = "FPS Booster Aktif ✅" })
		else
			RestoreSettings()
			GUI:CreateNotify({ title = "FPS Booster", description = "FPS Booster Nonaktif ❌" })
		end
	end
})

-------------------------------------------------
-- 🧊 Anti Lag (Client Performance)
-------------------------------------------------
GUI:CreateButton({
	parent = miscTab,
	text = "🧊 Anti Lag (Client)",
	callback = function()
		GUI:CreateNotify({
			title = "Anti Lag",
			description = "Mengaktifkan mode performa...",
		})
		-- Panggil script Anti Lag lewat RAW URL
		loadstring(game:HttpGet("https://raw.githubusercontent.com/adisetiadi64a/ADYRDP/refs/heads/main/antilag.lua"))()
	end
})



-------------------------------------------------
-- 👁️ ESP (Highlight + Nama Pemain)
-------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local espEnabled = false
local espObjects = {}

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
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextStrokeTransparency = 0.5

	local conn = RunService.RenderStepped:Connect(function()
		if not espEnabled then return end
		if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
		if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

		local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
		local status = dist < 50 and "🟢 Dekat" or (dist < 200 and "🟡 Sedang" or "🔴 Jauh")
		textLabel.Text = string.format("%s - %.0fm (%s)", p.Name, dist, status)
	end)

	espObjects[p] = { highlight = hl, billboard = billboard, conn = conn }
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
		GUI:CreateNotify({ title = "ESP", description = "ESP Aktif ✅" })
	else
		for p in pairs(espObjects) do
			removeESP(p)
		end
		GUI:CreateNotify({ title = "ESP", description = "ESP Nonaktif ❌" })
	end
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		repeat task.wait() until p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if espEnabled then createESP(p) end
	end)
end)

GUI:CreateButton({
	parent = miscTab,
	text = "👁️ Toggle ESP",
	callback = function()
		toggleESP(not espEnabled)
	end
		
})

-- copy ava
-------------------------------------------------
GUI:CreateButton({
	parent = miscTab,
	text = "👔Copy Ava (Client)",
	callback = function()
		GUI:CreateNotify({
			title = "Copy Ava",
			description = "Mengaktifkan Copy Ava...",
		})
		-- Panggil script 
		loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/ScriptAuthorization%20Source"))()Ioad("65822cd66ccbd578d81dbea955b39bb0")
	end
})


-------------------------------------------------
-- 🏔️ Admin Tab (Gunung Maker)
-------------------------------------------------
local adminTab = GUI:CreateTab("Admin", "shield")
GUI:CreateSection({ parent = adminTab, text = "Gunung Maker Tools" })

GUI:CreateButton({
	parent = adminTab,
	text = "🏔️ Gunung Maker",
	callback = function()

		-------------------------------------------------
		-- 🏔️ Gunung Maker (Versi Rapi)
		-------------------------------------------------
		local Players = game:GetService("Players")
		local UserInputService = game:GetService("UserInputService")
		local player = Players.LocalPlayer
		local PlayerGui = player:WaitForChild("PlayerGui")

		-- Data utama
		local points = {}
		local cpCount = 0
		local minimized = false

		-- Format Vector3
		local function fmtVec3(v)
			return string.format("Vector3.new(%.3f, %.3f, %.3f)", v.X, v.Y, v.Z)
		end

		-- 💡 Fungsi Generate Output (versi rapi)
		local function generateOutpu(mountainName, icon)
			icon = icon or "🌋"
			mountainName = mountainName or "Gunung"

			local s = string.format("[\"%s\"] = {\n", mountainName)
			s = s .. string.format("    icon = \"%s\",\n", icon)
			s = s .. "    points = {\n"

			for _, p in ipairs(points) do
				s = s .. string.format(
					"        { name = \"%s\", pos = %s },\n",
					p.name,
					fmtVec3(p.pos)
				)
			end

			s = s .. "    }\n"
			s = s .. "},"
			return s
		end

		-- GUI utama
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "GunungMakerUI"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = PlayerGui

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 380, 0, 260)
		frame.Position = UDim2.new(0, 10, 0, 10)
		frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		frame.BorderSizePixel = 0
		frame.Parent = screenGui

		-- Tombol minimize & close
		local closeBtn = Instance.new("TextButton")
		closeBtn.Size = UDim2.new(0, 24, 0, 24)
		closeBtn.Position = UDim2.new(1, -28, 0, 6)
		closeBtn.Text = "X"
		closeBtn.Font = Enum.Font.GothamBold
		closeBtn.TextSize = 14
		closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
		closeBtn.TextColor3 = Color3.new(1, 1, 1)
		closeBtn.Parent = frame

		local minBtn = Instance.new("TextButton")
		minBtn.Size = UDim2.new(0, 24, 0, 24)
		minBtn.Position = UDim2.new(1, -56, 0, 6)
		minBtn.Text = "-"
		minBtn.Font = Enum.Font.GothamBold
		minBtn.TextSize = 18
		minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		minBtn.TextColor3 = Color3.new(1, 1, 1)
		minBtn.Parent = frame

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -70, 0, 28)
		title.Position = UDim2.new(0, 6, 0, 6)
		title.BackgroundTransparency = 1
		title.Text = "Checkpoint Recorder (Gunung Maker)"
		title.Font = Enum.Font.GothamBold
		title.TextSize = 14
		title.TextColor3 = Color3.fromRGB(230, 230, 230)
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = frame

		-- Input field dan tombol-tombol
		local nameLabel = Instance.new("TextLabel", frame)
		nameLabel.Size = UDim2.new(0, 80, 0, 22)
		nameLabel.Position = UDim2.new(0, 6, 0, 40)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = "Nama Gunung:"
		nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 12
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left

		local nameBox = Instance.new("TextBox", frame)
		nameBox.Size = UDim2.new(0, 160, 0, 22)
		nameBox.Position = UDim2.new(0, 92, 0, 40)
		nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		nameBox.TextColor3 = Color3.fromRGB(240, 240, 240)
		nameBox.Text = "Gunung Baru"
		nameBox.Font = Enum.Font.Gotham
		nameBox.TextSize = 14
		nameBox.ClearTextOnFocus = false

		local iconLabel = Instance.new("TextLabel", frame)
		iconLabel.Size = UDim2.new(0, 40, 0, 22)
		iconLabel.Position = UDim2.new(0, 6, 0, 68)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Text = "Icon:"
		iconLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		iconLabel.Font = Enum.Font.Gotham
		iconLabel.TextSize = 12
		iconLabel.TextXAlignment = Enum.TextXAlignment.Left

		local iconBox = Instance.new("TextBox", frame)
		iconBox.Size = UDim2.new(0, 80, 0, 22)
		iconBox.Position = UDim2.new(0, 92, 0, 68)
		iconBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		iconBox.TextColor3 = Color3.fromRGB(240, 240, 240)
		iconBox.Text = "🌋"
		iconBox.Font = Enum.Font.Gotham
		iconBox.TextSize = 14
		iconBox.ClearTextOnFocus = false

		-- Tombol fungsi utama
		local addBtn = Instance.new("TextButton", frame)
		addBtn.Size = UDim2.new(0, 100, 0, 28)
		addBtn.Position = UDim2.new(0, 6, 0, 100)
		addBtn.Text = "Add CP"
		addBtn.Font = Enum.Font.GothamBold
		addBtn.TextSize = 14
		addBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
		addBtn.TextColor3 = Color3.new(1, 1, 1)

		local removeBtn = Instance.new("TextButton", frame)
		removeBtn.Size = UDim2.new(0, 120, 0, 28)
		removeBtn.Position = UDim2.new(0, 112, 0, 100)
		removeBtn.Text = "Remove Last"
		removeBtn.Font = Enum.Font.Gotham
		removeBtn.TextSize = 14
		removeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
		removeBtn.TextColor3 = Color3.new(1, 1, 1)

		local generateBtn = Instance.new("TextButton", frame)
		generateBtn.Size = UDim2.new(0, 100, 0, 28)
		generateBtn.Position = UDim2.new(0, 6, 0, 136)
		generateBtn.Text = "Generate"
		generateBtn.Font = Enum.Font.GothamBold
		generateBtn.TextSize = 14
		generateBtn.BackgroundColor3 = Color3.fromRGB(45, 85, 160)
		generateBtn.TextColor3 = Color3.new(1, 1, 1)

		local copyBtn = Instance.new("TextButton", frame)
		copyBtn.Size = UDim2.new(0, 100, 0, 28)
		copyBtn.Position = UDim2.new(0, 112, 0, 136)
		copyBtn.Text = "Copy Text"
		copyBtn.Font = Enum.Font.GothamBold
		copyBtn.TextSize = 14
		copyBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
		copyBtn.TextColor3 = Color3.new(1, 1, 1)

		local clearBtn = Instance.new("TextButton", frame)
		clearBtn.Size = UDim2.new(0, 100, 0, 28)
		clearBtn.Position = UDim2.new(0, 220, 0, 136)
		clearBtn.Text = "Clear All"
		clearBtn.Font = Enum.Font.Gotham
		clearBtn.TextSize = 14
		clearBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		clearBtn.TextColor3 = Color3.new(1, 1, 1)

		local outBox = Instance.new("TextBox", frame)
		outBox.Size = UDim2.new(1, -12, 0, 70)
		outBox.Position = UDim2.new(0, 6, 0, 176)
		outBox.ClearTextOnFocus = false
		outBox.MultiLine = true
		outBox.TextWrapped = false
		outBox.TextXAlignment = Enum.TextXAlignment.Left
		outBox.TextYAlignment = Enum.TextYAlignment.Top
		outBox.Text = "-- hasil akan muncul di sini --"
		outBox.Font = Enum.Font.Code
		outBox.TextSize = 14
		outBox.TextColor3 = Color3.new(1, 1, 1)
		outBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		local infoLabel = Instance.new("TextLabel", frame)
		infoLabel.Size = UDim2.new(1, -12, 0, 14)
		infoLabel.Position = UDim2.new(0, 6, 0, 250)
		infoLabel.BackgroundTransparency = 1
		infoLabel.Text = "Tambahkan CP lalu tekan Generate → Copy Text"
		infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		infoLabel.Font = Enum.Font.Gotham
		infoLabel.TextSize = 11
		infoLabel.TextXAlignment = Enum.TextXAlignment.Left

		-- Tombol logic
		addBtn.MouseButton1Click:Connect(function()
			local char = player.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			cpCount += 1
			local name = "cp" .. cpCount
			table.insert(points, { name = name, pos = hrp.Position })
			outBox.Text = string.format("-- Added %s at %s", name, fmtVec3(hrp.Position))
		end)

		removeBtn.MouseButton1Click:Connect(function()
			if #points > 0 then
				local removed = table.remove(points)
				cpCount = math.max(0, cpCount - 1)
				outBox.Text = string.format("-- Removed %s", removed.name)
			else
				outBox.Text = "-- No points to remove"
			end
		end)

		clearBtn.MouseButton1Click:Connect(function()
			points = {}
			cpCount = 0
			outBox.Text = "-- All points cleared"
		end)

		generateBtn.MouseButton1Click:Connect(function()
			local s = generateOutput(nameBox.Text, iconBox.Text)
			outBox.Text = s
			infoLabel.Text = "✅ Generated dengan format rapi!"
		end)

		copyBtn.MouseButton1Click:Connect(function()
			if type(setclipboard) == "function" then
				local ok = pcall(function() setclipboard(outBox.Text) end)
				if ok then
					infoLabel.Text = "✅ Teks disalin ke clipboard!"
				else
					infoLabel.Text = "⚠️ Tidak bisa copy otomatis, salin manual."
				end
			else
				infoLabel.Text = "Clipboard tidak tersedia. Salin manual."
			end
		end)

		minBtn.MouseButton1Click:Connect(function()
			minimized = not minimized
			for _, v in ipairs(frame:GetChildren()) do
				if v ~= title and v ~= closeBtn and v ~= minBtn then
					v.Visible = not minimized
				end
			end
			frame.Size = minimized and UDim2.new(0, 200, 0, 36) or UDim2.new(0, 380, 0, 260)
		end)

		closeBtn.MouseButton1Click:Connect(function()
			screenGui:Destroy()
		end)

		-- Drag GUI
		local dragging, dragStart, startPos
		frame.Active = true
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if input.Position.Y - frame.AbsolutePosition.Y <= 32 then
					dragging = true
					dragStart = input.Position
					startPos = frame.Position
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragging = false
						end
					end)
				end
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end
})
-------------------------------------------------
-- ⚙️ Settings Tab
-------------------------------------------------
local settings = GUI:CreateTab("Settings", "settings")

GUI:CreateSection({
    parent = settings,  
    text = "Settings Section"
})

GUI:CreateButton({
    parent = settings,  
    text = "Reset Settings",  
    callback = function()
        GUI:CreateNotify({ title = "Settings Reset", text = "All settings have been reset to default."})
    end
})

GUI:CreateDivider({
    parent = settings
})

GUI:CreateButton({
    parent = settings,  
    text = "Reset 2",  
    callback = function()
        GUI:CreateNotify({ title = "Settings Reset", text = "All settings have been reset to default."})
    end
})













