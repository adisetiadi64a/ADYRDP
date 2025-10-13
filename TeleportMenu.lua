-- 🧭 Ady Hub - Teleport Menu (standalone window)
-- Dibuka dari tombol di tab Gunung

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AshLibs/UI/main/source.lua"))()
local TeleportGUI = Library:CreateMain({
    projName = "Ady Hub - Teleport Menu",
    theme = "Dark"
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- fungsi teleport
local function teleportTo(pos, label)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(pos)
        Library:Notify({
            title = "✅ Teleport",
            description = "Berhasil ke " .. label
        })
    else
        Library:Notify({
            title = "⚠️ Gagal Teleport",
            description = "Karakter tidak ditemukan!"
        })
    end
end

-------------------------------------------------
-- 🏔️ TAB: Gunung Sumbing
-------------------------------------------------
local sumbingTab = TeleportGUI:CreateTab("Sumbing", "mountain")
local sumbing = {
    { name = "Awal",   pos = Vector3.new(-391.71, 5.01, 245.32) },
    { name = "cp1",    pos = Vector3.new(-376.50, 425.01, 2182.94) },
    { name = "cp2",    pos = Vector3.new(-368.54, 830.67, 3123.00) },
    { name = "cp3",    pos = Vector3.new(-47.78, 1263.81, 4013.42) },
    { name = "cp4",    pos = Vector3.new(-1014.69, 1553.01, 4823.71) },
    { name = "cp5",    pos = Vector3.new(-989.67, 1896.13, 5426.57) },
}

for _, p in ipairs(sumbing) do
    TeleportGUI:CreateButton({
        parent = sumbingTab,
        text = "➡️ " .. p.name,
        callback = function()
            teleportTo(p.pos, "Gunung Sumbing - " .. p.name)
        end
    })
end

-------------------------------------------------
-- 🌋 TAB: Gunung Kawai
-------------------------------------------------
local kawaiTab = TeleportGUI:CreateTab("Kawai", "mountain")
local kawai = {
    { name = "cp1", pos = Vector3.new(275.65, 84.73, 247.94) },
    { name = "cp3", pos = Vector3.new(1200.37, 273.29, 293.01) },
    { name = "cp5", pos = Vector3.new(1819.28, 325.01, -7.08) },
    { name = "cp8", pos = Vector3.new(3670.93, 494.24, 251.00) },
    { name = "finish", pos = Vector3.new(5139.54, 1147.29, 4713.37) },
}

for _, p in ipairs(kawai) do
    TeleportGUI:CreateButton({
        parent = kawaiTab,
        text = "➡️ " .. p.name,
        callback = function()
            teleportTo(p.pos, "Gunung Kawai - " .. p.name)
        end
    })
end

-------------------------------------------------
-- 🌄 TAB: Gunung Rindara
-------------------------------------------------
local rindaraTab = TeleportGUI:CreateTab("Rindara", "mountain")
local rindara = {
    { name = "cp1", pos = Vector3.new(-6.942, 68.008, -45.782) },
    { name = "cp5", pos = Vector3.new(-612.847, 219.089, -1331.625) },
    { name = "cp10", pos = Vector3.new(-629.122, 362.349, -4072.554) },
    { name = "finish", pos = Vector3.new(1744.773, 1104.645, -5026.188) },
}

for _, p in ipairs(rindara) do
    TeleportGUI:CreateButton({
        parent = rindaraTab,
        text = "➡️ " .. p.name,
        callback = function()
            teleportTo(p.pos, "Gunung Rindara - " .. p.name)
        end
    })
end

-------------------------------------------------
-- ℹ️ INFO TAB
-------------------------------------------------
local infoTab = TeleportGUI:CreateTab("Info", "info")
TeleportGUI:CreateSection({ parent = infoTab, text = "Tentang Teleport Menu" })
TeleportGUI:CreateButton({
    parent = infoTab,
    text = "Informasi",
    callback = function()
        Library:Notify({
            title = "Teleport Menu",
            description = "Gunung: Sumbing, Kawai, Rindara.\nBuka dari tab Gunung di Ady Hub."
        })
    end
})
