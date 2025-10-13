-- 🧭 Ady Hub - Teleport Menu (modular version)
-- Original base from myproject.lua by Ady & ChatGPT

repeat task.wait() until game and game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-------------------------------------------------
-- 📦 Data Gunung
-------------------------------------------------
local teleportData = {
	["Gunung Sumbing"] = {
		icon = "⛰️",
		points = {
			{ name = "Awal", pos = Vector3.new(-391.71, 5.01, 245.32) },
			{ name = "cp1", pos = Vector3.new(-376.50, 425.01, 2182.94) },
			{ name = "cp2", pos = Vector3.new(-368.54, 830.67, 3123.00) },
			{ name = "cp3", pos = Vector3.new(-47.78, 1263.81, 4013.42) },
			{ name = "finish", pos = Vector3.new(-989.67, 1896.13, 5426.57) },
		}
	},
	["Gunung Kawai"] = {
		icon = "🌋",
		points = {
			{ name = "cp1", pos = Vector3.new(275.65, 84.73, 247.94) },
			{ name = "cp8", pos = Vector3.new(3670.93, 494.24, 251.00) },
			{ name = "finish", pos = Vector3.new(5139.54, 1147.29, 4713.37) },
		}
	},
	["Gunung Rindara"] = {
		icon = "🌄",
		points = {
			{ name = "cp1", pos = Vector3.new(-6.942, 68.008, -45.782) },
			{ name = "cp5", pos = Vector3.new(-612.847, 219.089, -1331.625) },
			{ name = "finish", pos = Vector3.new(1744.773, 1104.645, -5026.188) },
		}
	}
}

-------------------------------------------------
-- ⚙️ Teleport Function
-------------------------------------------------
local function teleportTo(position)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char:MoveTo(position)
	end
end

-------------------------------------------------
-- 🧭 Simple GUI (built with Instance)
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportMenu"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.5, -130, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "🧭 TELEPORT MENU"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(170,40,40)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-------------------------------------------------
-- 📋 Generate Button List
-------------------------------------------------
local function makeBtn(text, color)
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

for gunungName, data in pairs(teleportData) do
	local btn = makeBtn((data.icon or "").." "..gunungName, Color3.fromRGB(50,50,80))
	btn.Parent = scroll
	btn.MouseButton1Click:Connect(function()
		scroll:ClearAllChildren()
		layout.Parent = scroll
		title.Text = data.icon.." "..gunungName

		for _, point in ipairs(data.points) do
			local pBtn = makeBtn("➡️ "..point.name, Color3.fromRGB(80,80,80))
			pBtn.Parent = scroll
			pBtn.MouseButton1Click:Connect(function()
				teleportTo(point.pos)
				game.StarterGui:SetCore("SendNotification", {
					Title = "✅ Teleport",
					Text = "Berhasil ke "..gunungName.." - "..point.name,
					Duration = 2
				})
			end)
		end

		local back = makeBtn("⬅️ Kembali", Color3.fromRGB(170,40,40))
		back.Parent = scroll
		back.MouseButton1Click:Connect(function()
			scroll:ClearAllChildren()
			layout.Parent = scroll
			for gName, gData in pairs(teleportData) do
				local gBtn = makeBtn((gData.icon or "").." "..gName, Color3.fromRGB(50,50,80))
				gBtn.Parent = scroll
				gBtn.MouseButton1Click:Connect(function()
					btn.MouseButton1Click:Fire()
				end)
			end
		end)
	end)
end

task.wait(0.05)
scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)