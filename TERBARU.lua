--// AdyHub_Notify_PremiumProgress.lua
-- Dibuat oleh ChatGPT (GPT-5)
-- Notifikasi profesional + progress bar keren saat loading

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Fungsi animasi fade in/out
local function AnimateShow(frame)
	frame.Visible = true
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 380, 0, 220),
		BackgroundTransparency = 0,
	}):Play()
end

local function AnimateHide(frame)
	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine), { BackgroundTransparency = 1 }):Play()
	for _, v in pairs(frame:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			TweenService:Create(v, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
		elseif v:IsA("UIStroke") then
			TweenService:Create(v, TweenInfo.new(0.4), { Transparency = 1 }):Play()
		end
	end
	task.wait(0.45)
	frame.Parent:Destroy()
end

-- Fungsi pembuat box notifikasi
local function CreateNotify(headerText, bodyText, withButton)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AdyHub_Notify"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.Size = UDim2.new(0, 380, 0, 220)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	frame.Parent = screenGui

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
	}
	gradient.Rotation = 90
	gradient.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.2
	stroke.Parent = frame

	local header = Instance.new("TextLabel")
	header.Text = headerText
	header.Font = Enum.Font.GothamBold
	header.TextSize = 24
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.BackgroundTransparency = 1
	header.AnchorPoint = Vector2.new(0.5, 0)
	header.Position = UDim2.new(0.5, 0, 0, 15)
	header.Parent = frame

	local underline = Instance.new("Frame")
	underline.Size = UDim2.new(0.6, 0, 0, 2)
	underline.Position = UDim2.new(0.5, 0, 0, 45)
	underline.AnchorPoint = Vector2.new(0.5, 0)
	underline.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
	underline.BorderSizePixel = 0
	underline.Parent = frame

	local body = Instance.new("TextLabel")
	body.Text = bodyText
	body.Font = Enum.Font.Gotham
	body.TextSize = 18
	body.TextColor3 = Color3.fromRGB(220, 220, 220)
	body.BackgroundTransparency = 1
	body.TextWrapped = true
	body.Size = UDim2.new(0.9, 0, 0.4, 0)
	body.AnchorPoint = Vector2.new(0.5, 0)
	body.Position = UDim2.new(0.5, 0, 0, 60)
	body.Parent = frame

	-- Tombol opsional
	if withButton then
		local button = Instance.new("TextButton")
		button.Text = "Perbaharui"
		button.Font = Enum.Font.GothamBold
		button.TextSize = 18
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.Size = UDim2.new(0.5, 0, 0, 40)
		button.AnchorPoint = Vector2.new(0.5, 1)
		button.Position = UDim2.new(0.5, 0, 1, -20)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
		button.AutoButtonColor = false
		button.Parent = frame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 10)
		btnCorner.Parent = button

		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(70, 70, 255) }):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(50, 50, 255) }):Play()
		end)

		button.MouseButton1Click:Connect(function()
			AnimateHide(frame)

			-- Box kedua dengan progress bar
			local secondGui = Instance.new("ScreenGui")
			secondGui.Name = "AdyHub_Progress"
			secondGui.IgnoreGuiInset = true
			secondGui.ResetOnSpawn = false
			secondGui.Parent = PlayerGui

			local box = Instance.new("Frame")
			box.AnchorPoint = Vector2.new(0.5, 0.5)
			box.Position = UDim2.new(0.5, 0, 0.5, 0)
			box.Size = UDim2.new(0, 400, 0, 200)
			box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			box.Parent = secondGui

			local boxCorner = Instance.new("UICorner")
			boxCorner.CornerRadius = UDim.new(0, 14)
			boxCorner.Parent = box

			local header2 = Instance.new("TextLabel")
			header2.Text = "Ady Hub"
			header2.Font = Enum.Font.GothamBold
			header2.TextSize = 24
			header2.TextColor3 = Color3.fromRGB(255, 255, 255)
			header2.BackgroundTransparency = 1
			header2.AnchorPoint = Vector2.new(0.5, 0)
			header2.Position = UDim2.new(0.5, 0, 0, 15)
			header2.Parent = box

			local desc = Instance.new("TextLabel")
			desc.Text = "BOONGIN Tugguin Script lagi Loading...."
			desc.Font = Enum.Font.Gotham
			desc.TextSize = 18
			desc.TextColor3 = Color3.fromRGB(220, 220, 220)
			desc.BackgroundTransparency = 1
			desc.TextWrapped = true
			desc.Size = UDim2.new(0.9, 0, 0.3, 0)
			desc.AnchorPoint = Vector2.new(0.5, 0)
			desc.Position = UDim2.new(0.5, 0, 0, 60)
			desc.Parent = box

			-- Progress bar
			local progressFrame = Instance.new("Frame")
			progressFrame.Size = UDim2.new(0.8, 0, 0, 20)
			progressFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
			progressFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			progressFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			progressFrame.Parent = box

			local progressCorner = Instance.new("UICorner")
			progressCorner.CornerRadius = UDim.new(0, 10)
			progressCorner.Parent = progressFrame

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
			fill.Parent = progressFrame

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(0, 10)
			fillCorner.Parent = fill

			local percentText = Instance.new("TextLabel")
			percentText.Text = "0%"
			percentText.Font = Enum.Font.GothamBold
			percentText.TextSize = 16
			percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
			percentText.BackgroundTransparency = 1
			percentText.AnchorPoint = Vector2.new(0.5, 0.5)
			percentText.Position = UDim2.new(0.5, 0, 0.5, 0)
			percentText.Parent = progressFrame

			-- Animasi progress selama 10 detik
			for i = 1, 100 do
				TweenService:Create(fill, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
					Size = UDim2.new(i/100, 0, 1, 0)
				}):Play()
				percentText.Text = i .. "%"
				task.wait(0.1)
			end

			task.wait(0.5)
			secondGui:Destroy()

			-- Jalankan script raw kamu
			loadstring(game:HttpGet("https://raw.githubusercontent.com/adisetiadi64a/ADYRDP/refs/heads/main/TERBARU.lua"))()
		end)
	end

	AnimateShow(frame)
	return screenGui
end

-- Jalankan notifikasi pertama
CreateNotify("Ady Hub", "Script Sedang Update Tungguin Dan Pencet Perbaharui....", true)