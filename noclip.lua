--// noclip.lua
-- Dibuat oleh ChatGPT (GPT-5)
-- Versi fix: bisa diaktifkan/dimatikan dari GUI AdyHub
-- Tidak perlu tombol keyboard, hanya lewat GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- gunakan global variable biar bisa diakses dari tombol GUI
_G._NoclipData = _G._NoclipData or {}
local data = _G._NoclipData

data.Enabled = true
data.Stored = data.Stored or {}
data.Connection = data.Connection

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function applyNoclip()
	local char = getCharacter()
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			if data.Stored[v] == nil then
				data.Stored[v] = v.CanCollide
			end
			v.CanCollide = false
		end
	end
end

local function restoreParts()
	for part, val in pairs(data.Stored) do
		if part and part.Parent then
			pcall(function()
				part.CanCollide = val
			end)
		end
	end
	data.Stored = {}
end

-- jalankan loop
if data.Connection then
	data.Connection:Disconnect()
end

data.Connection = RunService.Stepped:Connect(function()
	if not data.Enabled then return end
	local char = getCharacter()
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end)

-- update karakter baru
player.CharacterAdded:Connect(function(char)
	task.wait(0.3)
	if data.Enabled then
		applyNoclip()
	end
end)

-- fungsi global buat tombol GUI
_G.DisableNoclip = function()
	data.Enabled = false
	restoreParts()
	game.StarterGui:SetCore("SendNotification", {
		Title = "AdyHub",
		Text = "Noclip Dimatikan ❌",
		Duration = 2
	})
end

_G.EnableNoclip = function()
	data.Enabled = true
	applyNoclip()
	game.StarterGui:SetCore("SendNotification", {
		Title = "AdyHub",
		Text = "Noclip Aktif ✅",
		Duration = 2
	})
end

applyNoclip()
game.StarterGui:SetCore("SendNotification", {
	Title = "AdyHub",
	Text = "Noclip Diaktifkan ✅ (klik tombol lagi untuk OFF)",
	Duration = 2
})
