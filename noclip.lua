--// noclip.lua
-- Toggle pakai GUI, tanpa keybind

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclipEnabled = true
local stored = {}
local conn

-- aktifkan noclip
local function enable()
	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			if stored[v] == nil then
				stored[v] = v.CanCollide
			end
			v.CanCollide = false
		end
	end
end

-- matikan noclip
local function disable()
	if conn then conn:Disconnect() end
	for part, val in pairs(stored) do
		if part and part.Parent then
			part.CanCollide = val
		end
	end
	stored = {}
end

-- loop noclip
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

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	task.wait(0.3)
	if noclipEnabled then
		enable()
	end
end)

_G.DisableNoclip = function()
	noclipEnabled = false
	disable()
end

_G.EnableNoclip = function()
	noclipEnabled = true
	enable()
end

enable()
