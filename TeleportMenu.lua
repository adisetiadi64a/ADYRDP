-- 🧭 Ady Hub - Teleport Menu (Ash-Libs Version)
-- By Ady & ChatGPT
-- Menggunakan framework Ash-Libs, bukan Instance bawaan Roblox

repeat task.wait() until game and game:IsLoaded()
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔧 Load GUI Framework Ash-Libs
local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodLetters/Ash-Libs/refs/heads/main/source.lua"))()

-------------------------------------------------
-- 🏠 Setup Window (kalau belum ada)
-------------------------------------------------
local window = GUI:CreateMain({
    Name = "Ady",
    title = "Ady HUB",
    ToggleUI = "K",
    WindowIcon = "home",
    Theme = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(50, 50, 60),
        NavBackground = Color3.fromRGB(20, 20, 30)
    }
})

-------------------------------------------------
-- ⛰️ Tab Gunung
-------------------------------------------------
local gunungTab = GUI:CreateTab("Gunung", "mountain")

-------------------------------------------------
-- ⚙️ Fungsi Teleport
-------------------------------------------------
local function teleportTo(pos, label)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(pos)
        GUI:CreateNotify({
            title = "✅ Teleport",
            description = "Berhasil ke " .. label
        })
    else
        GUI:CreateNotify({
            title = "⚠️ Gagal Teleport",
            description = "Karakter tidak ditemukan!"
        })
    end
end

-------------------------------------------------
-- 🏔️ Gunung Sumbing
-------------------------------------------------
GUI:CreateSection({ parent = gunungTab, text = "Gunung Sumbing" })

local gunungSumbing = {
    { name = "Awal",   pos = Vector3.new(-391.71, 5.01, 245.32) },
    { name = "cp1",    pos = Vector3.new(-376.50, 425.01, 2182.94) },
    { name = "cp2",    pos = Vector3.new(-368.54, 830.67, 3123.00) },
    { name = "cp3",    pos = Vector3.new(-47.78, 1263.81, 4013.42) },
    { name = "cp5",    pos = Vector3.new(-989.67, 1896.13, 5426.57) },
}

for _, point in ipairs(gunungSumbing) do
    GUI:CreateButton({
        parent = gunungTab,
        text = "➡️ " .. point.name,
        callback = function()
            teleportTo(point.pos, "Gunung Sumbing - " .. point.name)
        end
    })
end

-------------------------------------------------
-- 🌋 Gunung Kawai
-------------------------------------------------
GUI:CreateSection({ parent = gunungTab, text = "Gunung Kawai" })

local gunungKawai = {
    { name = "cp1", pos = Vector3.new(275.65, 84.73, 247.94) },
    { name = "cp3", pos = Vector3.new(1200.37, 273.29, 293.01) },
    { name = "cp5", pos = Vector3.new(1819.28, 325.01, -7.08) },
    { name = "cp8", pos = Vector3.new(3670.93, 494.24, 251.00) },
    { name = "finish", pos = Vector3.new(5139.54, 1147.29, 4713.37) },
}

for _, point in ipairs(gunungKawai) do
    GUI:CreateButton({
        parent = gunungTab,
        text = "➡️ " .. point.name,
        callback = function()
            teleportTo(point.pos, "Gunung Kawai - " .. point.name)
        end
    })
end

-------------------------------------------------
-- 🌄 Gunung Rindara
-------------------------------------------------
GUI:CreateSection({ parent = gunungTab, text = "Gunung Rindara" })

local gunungRindara = {
    { name = "cp1", pos = Vector3.new(-6.942, 68.008, -45.782) },
    { name = "cp5", pos = Vector3.new(-612.847, 219.089, -1331.625) },
    { name = "cp10", pos = Vector3.new(-629.122, 362.349, -4072.554) },
    { name = "finish", pos = Vector3.new(1744.773, 1104.645, -5026.188) },
}

for _, point in ipairs(gunungRindara) do
    GUI:CreateButton({
        parent = gunungTab,
        text = "➡️ " .. point.name,
        callback = function()
            teleportTo(point.pos, "Gunung Rindara - " .. point.name)
        end
    })
end

-------------------------------------------------
-- 🔔 Info
-------------------------------------------------
GUI:CreateSection({ parent = gunungTab, text = "Info" })
GUI:CreateButton({
    parent = gunungTab,
    text = "ℹ️ Tentang Menu Ini",
    callback = function()
        GUI:CreateNotify({
            title = "Teleport Menu",
            description = "Versi Ash-Libs. Tersedia 3 gunung: Sumbing, Kawai, Rindara."
        })
    end
})
