-- 🧊 AntiLag.lua
-- Client-side performance optimizer (untuk game buatanmu sendiri)
-- Fitur:
--  ✅ Hide all players (kecuali diri sendiri)
--  ✅ Matikan efek berat (particle, trail, texture)
--  ✅ Hapus skybox, bloom, sunrays, atmosphere
--  ✅ Turunkan rendering quality
--  ✅ Pencahayaan ringan tapi tetap jelas

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-------------------------------------------------
-- ⚙️ Fungsi: Hide semua pemain lain
-------------------------------------------------
local function hideOtherPlayers()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			for _, obj in pairs(plr.Character:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Transparency = 1
					obj.CanCollide = false
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					obj.Transparency = 1
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
					obj.Enabled = false
				end
			end
		end
	end
end

-------------------------------------------------
-- 💨 Fungsi: Matikan efek berat di Workspace
-------------------------------------------------
local function disableHeavyEffects()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
			obj.Enabled = false
		elseif obj:IsA("Beam") then
			obj.Enabled = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 1
		end
	end
end

-------------------------------------------------
-- 🌌 Fungsi: Hapus langit-langit & efek lighting
-------------------------------------------------
local function removeSkyAndEffects()
	for _, obj in pairs(Lighting:GetChildren()) do
		if obj:IsA("Sky") or obj:IsA("BloomEffect") or obj:IsA("SunRaysEffect")
			or obj:IsA("ColorCorrectionEffect") or obj:IsA("Atmosphere") then
			obj:Destroy()
		end
	end

	-- Set pencahayaan ringan tapi tetap terang
	Lighting.GlobalShadows = false
	Lighting.Brightness = 1
	Lighting.FogEnd = 9e9
	Lighting.FogStart = 0
	Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
	Lighting.Ambient = Color3.fromRGB(200, 200, 200)
end

-------------------------------------------------
-- ⚙️ Fungsi: Turunkan kualitas rendering client
-------------------------------------------------
local function setLowGraphics()
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)
end

-------------------------------------------------
-- 🚀 Jalankan mode performa
-------------------------------------------------
local function enablePerformanceMode()
	print("[🧊 AntiLag] Mengaktifkan mode performa...")
	hideOtherPlayers()
	disableHeavyEffects()
	removeSkyAndEffects()
	setLowGraphics()
	print("[🧊 AntiLag] Semua optimasi aktif!")
end

-------------------------------------------------
-- 🔁 Auto-hide player baru
-------------------------------------------------
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.5)
		hideOtherPlayers()
	end)
end)

-------------------------------------------------
-- ▶️ Jalankan otomatis saat dimuat
-------------------------------------------------
enablePerformanceMode()
