-- 🧭 Ady Hub - Teleport Box (Custom GUI, 1 Gunung Sumbing)

-- Hapus kalau sudah ada
if game.CoreGui:FindFirstChild("TeleportBox") then
	game.CoreGui.TeleportBox:Destroy()
end

-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportBox"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Frame utama
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 420)
main.Position = UDim2.new(0.5, -180, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧭 Teleport Menu - Ady Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 1, 0)
close.Position = UDim2.new(1, -40, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.Parent = header
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Scroll area
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

-- 🔹 Data Gunung Sumbing
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
	}
}

-- fungsi teleport
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function teleportTo(pos, label)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char:MoveTo(pos)
		game.StarterGui:SetCore("SendNotification", {
			Title = "✅ Teleport",
			Text = "Berhasil ke " .. label,
			Duration = 3
		})
	else
		game.StarterGui:SetCore("SendNotification", {
			Title = "⚠️ Gagal Teleport",
			Text = "Karakter tidak ditemukan!",
			Duration = 3
		})
	end
end

-- Buat tombol-tombol teleport
for gunungName, data in pairs(teleportData) do
	local titleFrame = Instance.new("Frame")
	titleFrame.Size = UDim2.new(1, -10, 0, 30)
	titleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	titleFrame.BorderSizePixel = 0
	titleFrame.Parent = scroll

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = data.icon .. " " .. gunungName
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.Parent = titleFrame

	for _, p in ipairs(data.points) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 28)
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btn.Text = "➡️ " .. p.name
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Parent = scroll

		btn.MouseButton1Click:Connect(function()
			teleportTo(p.pos, gunungName .. " - " .. p.name)
		end)
	end
end
