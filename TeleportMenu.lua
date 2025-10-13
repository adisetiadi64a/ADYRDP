-- 🧭 Ady Hub - Teleport Box (Custom GUI + Collapse + Auto Teleport + Start CP)

if game.CoreGui:FindFirstChild("TeleportBox") then
	game.CoreGui.TeleportBox:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "TeleportBox"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Frame utama
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 480)
main.Position = UDim2.new(0.5, -190, 0.5, -240)
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

-- 🔹 Data Gunung
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
-- 🔸 Input pengaturan (Delay & Start CP)
-------------------------------------------------
local labelDelay = Instance.new("TextLabel")
labelDelay.Size = UDim2.new(1, -20, 0, 25)
labelDelay.Position = UDim2.new(0, 10, 0, 0)
labelDelay.BackgroundTransparency = 1
labelDelay.Text = "⏱️ Delay antar teleport (1–60 detik):"
labelDelay.TextColor3 = Color3.new(1, 1, 1)
labelDelay.Font = Enum.Font.Gotham
labelDelay.TextSize = 14
labelDelay.Parent = scroll

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0, 80, 0, 25)
delayBox.Position = UDim2.new(0, 10, 0, 25)
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.Font = Enum.Font.GothamBold
delayBox.TextSize = 14
delayBox.Text = "5"
delayBox.ClearTextOnFocus = false
delayBox.Parent = scroll

local labelStart = Instance.new("TextLabel")
labelStart.Size = UDim2.new(1, -20, 0, 25)
labelStart.Position = UDim2.new(0, 10, 0, 55)
labelStart.BackgroundTransparency = 1
labelStart.Text = "🏁 Mulai dari checkpoint (nomor):"
labelStart.TextColor3 = Color3.new(1, 1, 1)
labelStart.Font = Enum.Font.Gotham
labelStart.TextSize = 14
labelStart.Parent = scroll

local startBox = Instance.new("TextBox")
startBox.Size = UDim2.new(0, 80, 0, 25)
startBox.Position = UDim2.new(0, 10, 0, 80)
startBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
startBox.TextColor3 = Color3.new(1, 1, 1)
startBox.Font = Enum.Font.GothamBold
startBox.TextSize = 14
startBox.Text = "1"
startBox.ClearTextOnFocus = false
startBox.Parent = scroll

local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -10, 0, 2)
separator.Position = UDim2.new(0, 5, 0, 115)
separator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
separator.BorderSizePixel = 0
separator.Parent = scroll

-------------------------------------------------
-- 🔹 Gunung (Collapse + Auto Teleport)
-------------------------------------------------
for gunungName, data in pairs(teleportData) do
	local collapsed = true
	local buttons = {}

	local headerFrame = Instance.new("TextButton")
	headerFrame.Size = UDim2.new(1, -10, 0, 30)
	headerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	headerFrame.Text = data.icon .. " " .. gunungName .. " ▼"
	headerFrame.TextColor3 = Color3.new(1, 1, 1)
	headerFrame.Font = Enum.Font.GothamBold
	headerFrame.TextSize = 16
	headerFrame.Parent = scroll

	local autoBtn = Instance.new("TextButton")
	autoBtn.Size = UDim2.new(0, 160, 0, 25)
	autoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	autoBtn.TextColor3 = Color3.new(1, 1, 1)
	autoBtn.Font = Enum.Font.GothamBold
	autoBtn.TextSize = 14
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

		local delayTime = tonumber(delayBox.Text) or 5
		delayTime = math.clamp(delayTime, 1, 60)
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

		if collapsed then
			for _, b in ipairs(buttons) do b:Destroy() end
			buttons = {}
		else
			for _, p in ipairs(data.points) do
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, -10, 0, 25)
				btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
				btn.Text = "➡️ " .. p.name
				btn.TextColor3 = Color3.new(1, 1, 1)
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 14
				btn.Parent = scroll
				btn.MouseButton1Click:Connect(function()
					teleportTo(p.pos, gunungName .. " - " .. p.name)
				end)
				table.insert(buttons, btn)
			end
		end
	end)
end
