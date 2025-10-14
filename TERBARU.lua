--// AdyHub_Notify_PremiumUltra.lua
-- Dibuat oleh ChatGPT (GPT-5)
-- Versi ultra-premium: efek blur, gradasi lembut, dan partikel bercahaya

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Efek blur background global
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting
TweenService:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Sine), { Size = 20 }):Play()

-- GUI utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdyHub_UltraPremium"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = PlayerGui

-- 🌈 Background gradasi mewah
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 0
bg.ZIndex = 0
bg.Parent = screenGui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 60, 120)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
}
gradient.Rotation = 45
gradient.Parent = bg

-- Efek partikel bercahaya lembut
for i = 1, 20 do
	local glow = Instance.new("Frame")
	glow.Size = UDim2.new(0, math.random(60, 120), 0, math.random(60, 120))
	glow.Position = UDim2.new(math.random(), 0, math.random(), 0)
	glow.BackgroundColor3 = Color3.fromRGB(math.random(100,255), math.random(100,255), 255)
	glow.BackgroundTransparency = 0.9
	glow.ZIndex = 1

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = glow
	glow.Parent = bg

	task.spawn(function()
		while glow.Parent do
			local newPos = UDim2.new(math.random(), 0, math.random(), 0)
			local newTrans = math.random(7, 9) / 10
			local tween = TweenService:Create(glow, TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = newPos,
				BackgroundTransparency = newTrans
			})
			tween:Play()
			tween.Completed:Wait()
		end
	end)
end

-- Fade-in background
bg.BackgroundTransparency = 1
TweenService:Create(bg, TweenInfo.new(1, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 }):Play()

-- 🔳 Box utama notifikasi
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(0, 380, 0, 220)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 1
frame.ZIndex = 10
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(160, 180, 255)
stroke.Transparency = 0.5
stroke.Parent = frame

local glowEffect = Instance.new("UIGradient")
glowEffect.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))
}
glowEffect.Rotation = 90
glowEffect.Parent = frame

-- Fade-in animasi box
frame.Visible = true
TweenService:Create(frame, TweenInfo.new(0.7, Enum.EasingStyle.Back), { BackgroundTransparency = 0 }):Play()

-- 📝 Header
local header = Instance.new("TextLabel")
header.Text = "Ady Hub"
header.Font = Enum.Font.GothamBold
header.TextSize = 26
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.BackgroundTransparency = 1
header.AnchorPoint = Vector2.new(0.5, 0)
header.Position = UDim2.new(0.5, 0, 0, 18)
header.ZIndex = 11
header.Parent = frame

local underline = Instance.new("Frame")
underline.Size = UDim2.new(0.5, 0, 0, 2)
underline.Position = UDim2.new(0.5, 0, 0, 50)
underline.AnchorPoint = Vector2.new(0.5, 0)
underline.BackgroundColor3 = Color3.fromRGB(120, 130, 255)
underline.ZIndex = 11
underline.Parent = frame

-- 🧾 Body text
local body = Instance.new("TextLabel")
body.Text = "Script Sedang Update, Tungguin dan Pencet Perbaharui..."
body.Font = Enum.Font.Gotham
body.TextSize = 18
body.TextColor3 = Color3.fromRGB(220, 220, 220)
body.BackgroundTransparency = 1
body.TextWrapped = true
body.Size = UDim2.new(0.9, 0, 0.4, 0)
body.AnchorPoint = Vector2.new(0.5, 0)
body.Position = UDim2.new(0.5, 0, 0, 70)
body.ZIndex = 11
body.Parent = frame

-- 🔘 Tombol
local button = Instance.new("TextButton")
button.Text = "Perbaharui"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Size = UDim2.new(0.5, 0, 0, 40)
button.AnchorPoint = Vector2.new(0.5, 1)
button.Position = UDim2.new(0.5, 0, 1, -20)
button.BackgroundColor3 = Color3.fromRGB(100, 110, 255)
button.AutoButtonColor = false
button.ZIndex = 12
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = button

button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(140, 150, 255) }):Play()
end)
button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(100, 110, 255) }):Play()
end)

-- 🧩 Aksi saat tombol diklik
button.MouseButton1Click:Connect(function()
	-- Animasi hilang frame
	TweenService:Create(frame, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
	for _, v in pairs(frame:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			TweenService:Create(v, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
		end
	end
	task.wait(0.5)
	frame:Destroy()

	-- Progress bar box
	local box = Instance.new("Frame")
	box.AnchorPoint = Vector2.new(0.5, 0.5)
	box.Position = UDim2.new(0.5, 0, 0.5, 0)
	box.Size = UDim2.new(0, 400, 0, 200)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	box.ZIndex = 15
	box.Parent = screenGui

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 16)
	boxCorner.Parent = box

	local header2 = Instance.new("TextLabel")
	header2.Text = "Ady Hub"
	header2.Font = Enum.Font.GothamBold
	header2.TextSize = 24
	header2.TextColor3 = Color3.fromRGB(255, 255, 255)
	header2.BackgroundTransparency = 1
	header2.AnchorPoint = Vector2.new(0.5, 0)
	header2.Position = UDim2.new(0.5, 0, 0, 15)
	header2.ZIndex = 16
	header2.Parent = box

	local desc = Instance.new("TextLabel")
	desc.Text = "BOONGIN Tungguin Script lagi Loading..."
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 18
	desc.TextColor3 = Color3.fromRGB(220, 220, 220)
	desc.BackgroundTransparency = 1
	desc.TextWrapped = true
	desc.Size = UDim2.new(0.9, 0, 0.3, 0)
	desc.AnchorPoint = Vector2.new(0.5, 0)
	desc.Position = UDim2.new(0.5, 0, 0, 60)
	desc.ZIndex = 16
	desc.Parent = box

	local progressFrame = Instance.new("Frame")
	progressFrame.Size = UDim2.new(0.8, 0, 0, 22)
	progressFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
	progressFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	progressFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	progressFrame.ZIndex = 16
	progressFrame.Parent = box

	local progressCorner = Instance.new("UICorner")
	progressCorner.CornerRadius = UDim.new(0, 12)
	progressCorner.Parent = progressFrame

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(120, 130, 255)
	fill.ZIndex = 17
	fill.Parent = progressFrame

	local glow = Instance.new("UIGradient")
	glow.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 160, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 200, 255))
	}
	glow.Rotation = 0
	glow.Parent = fill

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 12)
	fillCorner.Parent = fill

	local percentText = Instance.new("TextLabel")
	percentText.Text = "0%"
	percentText.Font = Enum.Font.GothamBold
	percentText.TextSize = 16
	percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentText.BackgroundTransparency = 1
	percentText.AnchorPoint = Vector2.new(0.5, 0.5)
	percentText.Position = UDim2.new(0.5, 0, 0.5, 0)
	percentText.ZIndex = 18
	percentText.Parent = progressFrame

	for i = 1, 100 do
		TweenService:Create(fill, TweenInfo.new(0.04, Enum.EasingStyle.Linear), {
			Size = UDim2.new(i / 100, 0, 1, 0)
		}):Play()
		percentText.Text = i .. "%"
		task.wait(0.04)
	end

	-- Fade out semua
	task.wait(0.5)
	TweenService:Create(bg, TweenInfo.new(0.8), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(blur, TweenInfo.new(0.8), { Size = 0 }):Play()
	task.wait(0.8)
	screenGui:Destroy()
	blur:Destroy()

	-- Jalankan script utama
	loadstring(game:HttpGet("https://raw.githubusercontent.com/adisetiadi64a/ADYRDP/refs/heads/main/Mainnya.lua"))()
end)