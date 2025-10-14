-- LocalScript: ClientPerformanceMode.lua
-- Tempatkan di: StarterPlayer > StarterPlayerScripts
-- Fungsi:
--  - Menonaktifkan efek berat (particle, trail, shadow)
--  - Menurunkan kualitas rendering
--  - Menyembunyikan semua player lain untuk menghemat FPS (Hide All Players)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Fungsi: sembunyikan semua pemain lain (kecuali diri sendiri)
local function hideOtherPlayers()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			for _, obj in pairs(plr.Character:GetDescendants()) do
				if obj:IsA("BasePart") or obj:IsA("Decal") then
					obj.Transparency = 1
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
					obj.Enabled = false
				end
			end
		end
	end
end

-- Mode performa sederhana
local function enablePerformanceMode()
	pcall(function()
		Lighting.GlobalShadows = false
		if Lighting:FindFirstChild("Atmosphere") then
			Lighting.Atmosphere.Density = 0
		end
		Lighting.FogEnd = 1e6
	end)

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
			obj.Enabled = false
		end
	end

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)

	for _, gui in pairs(player:WaitForChild("PlayerGui"):GetDescendants()) do
		if gui:IsA("ParticleEmitter") then
			gui.Enabled = false
		end
	end

	hideOtherPlayers()
end

-- Update otomatis kalau ada pemain baru join
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(0.5)
		hideOtherPlayers()
	end)
end)

-- Jalankan
if player then
	player.CharacterAdded:Connect(function()
		wait(0.5)
		enablePerformanceMode()
	end)
	enablePerformanceMode()
end

print("✅ ClientPerformanceMode aktif: Partikel dimatikan dan semua player disembunyikan.")