-- 🧭 Ady Hub - Compact Teleport Box (Modular + Collapse + Auto Teleport)
-- by Ady & GPT

if game.CoreGui:FindFirstChild("TeleportBox") then
	game.CoreGui.TeleportBox:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "TeleportBox"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Frame utama
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 360)
main.Position = UDim2.new(0.5, -150, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧭 Teleport Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 1, 0)
close.Position = UDim2.new(1, -35, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = header
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = scroll

-- 🔹 CONFIG DATA GUNUNG
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
}

-- 🧠 Fungsi teleport
local player = game:GetService("Players").LocalPlayer
local function teleportTo(pos, label)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char:MoveTo(pos)
		game.StarterGui:SetCore("SendNotification", {
			Title = "✅ Teleport",
			Text = "Berhasil ke " .. label,
			Duration = 2
		})
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "⚠️ Gagal Teleport",
			Text = "Karakter tidak ditemukan!",
			Duration = 2
		})
	end
end

-------------------------------------------------
-- 🕹️ PENGATURAN GLOBAL
-------------------------------------------------
local cfgFrame = Instance.new("Frame")
cfgFrame.Size = UDim2.new(1, -10, 0, 60)
cfgFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
cfgFrame.BorderSizePixel = 0
cfgFrame.Parent = scroll

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 70, 0, 25)
delayBox.Position = UDim2.new(0, 10, 0, 8)
delayBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.Font = Enum.Font.GothamBold
delayBox.Text = "5"
delayBox.TextSize = 13
delayBox.ClearTextOnFocus = false
delayBox.Parent = cfgFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 120, 0, 25)
delayLabel.Position = UDim2.new(0, 85, 0, 8)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay (1–60s)"
delayLabel.TextColor3 = Color3.new(1, 1, 1)
delayLabel.Font = Enum.Font.Gotham
delayLabel.TextSize = 13
delayLabel.Parent = cfgFrame

local startBox = Instance.new("TextBox")
startBox.Size = UDim2.new(0, 70, 0, 25)
startBox.Position = UDim2.new(0, 10, 0, 33)
startBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
startBox.TextColor3 = Color3.new(1, 1, 1)
startBox.Font = Enum.Font.GothamBold
startBox.Text = "1"
startBox.TextSize = 13
startBox.ClearTextOnFocus = false
startBox.Parent = cfgFrame

local startLabel = Instance.new("TextLabel")
startLabel.Size = UDim2.new(0, 120, 0, 25)
startLabel.Position = UDim2.new(0, 85, 0, 33)
startLabel.BackgroundTransparency = 1
startLabel.Text = "Mulai dari CP"
startLabel.TextColor3 = Color3.new(1, 1, 1)
startLabel.Font = Enum.Font.Gotham
startLabel.TextSize = 13
startLabel.Parent = cfgFrame

-------------------------------------------------
-- 🏔️ GUNUNG LIST
-------------------------------------------------
for gunungName, data in pairs(teleportData) do
	local collapsed = true
	local buttons = {}

	local headerFrame = Instance.new("TextButton")
	headerFrame.Size = UDim2.new(1, -10, 0, 28)
	headerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	headerFrame.Text = data.icon .. " " .. gunungName .. " ▼"
	headerFrame.TextColor3 = Color3.new(1, 1, 1)
	headerFrame.Font = Enum.Font.GothamBold
	headerFrame.TextSize = 14
	headerFrame.Parent = scroll

	local autoBtn = Instance.new("TextButton")
	autoBtn.Size = UDim2.new(0, 140, 0, 24)
	autoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	autoBtn.TextColor3 = Color3.new(1, 1, 1)
	autoBtn.Font = Enum.Font.GothamBold
	autoBtn.TextSize = 13
	autoBtn.Text = "▶️ Auto Teleport"
	autoBtn.Visible = false
	autoBtn.Parent = scroll

	local running = false
	autoBtn.MouseButton1Click:Connect(function()
		if running then
			running = false
			autoBtn.Text = "▶️ Auto Teleport"
			return
		end
		running = true
		autoBtn.Text = "⏸️ Stop Auto"

		local delayTime = math.clamp(tonumber(delayBox.Text) or 5, 1, 60)
		local startIndex = tonumber(startBox.Text) or 1
		spawn(function()
			while running do
				for i = startIndex, #data.points do
					if not running then break end
					local p = data.points[i]
					teleportTo(p.pos, gunungName .. " - " .. p.name)
					task.wait(delayTime)
				end
			end
		end)
	end)

	headerFrame.MouseButton1Click:Connect(function()
		collapsed = not collapsed
		headerFrame.Text = data.icon .. " " .. gunungName .. (collapsed and " ▼" or " ▲")
		autoBtn.Visible = not collapsed

		for _, b in ipairs(buttons) do b:Destroy() end
		buttons = {}

		if not collapsed then
			for _, p in ipairs(data.points) do
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -10, 0, 22)
				btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
				btn.Text = "➡️ " .. p.name
				btn.TextColor3 = Color3.new(1, 1, 1)
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				btn.Parent = scroll
				btn.MouseButton1Click:Connect(function()
					teleportTo(p.pos, gunungName .. " - " .. p.name)
				end)
				table.insert(buttons, btn)
			end
		end
	end)
end
