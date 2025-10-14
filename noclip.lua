--// noclip.lua
-- Versi GUI-friendly (untuk AdyHub)
-- Tidak pakai keybind, hanya dikontrol lewat tombol GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local noclipEnabled = true
local stored = {}
local conn

local function enableNoclip()
	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			if stored[v] == nil then
				stored[v] = v.CanCollide
			end
			v.CanCollide = false
		end
	end
end

local function disableNoclip()
	if conn then conn:Disconnect() end
	for v, val in pairs(stored) do
		if v and v.Parent then
			v.CanCollide = val
		end
	end
	stored = {}
end

-- Loop
conn = RunService.Stepped:Connect(function()
	if not noclipEnabled then return end
	if character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Respawn handling
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	task.wait(0.5)
	if noclipEnabled then
		enableNoclip()
	end
end)

-- Untuk matikan dari GUI
_G.DisableNoclip = function()
	noclipEnabled = false
	disableNoclip()
end

-- Untuk hidupkan lagi (kalau mau manual)
_G.EnableNoclip = function()
	noclipEnabled = true
	enableNoclip()
end

enableNoclip()