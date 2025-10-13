-- 🧭 Ady Hub - Teleport Menu (Integrasi langsung ke tab Gunung)
-- By Ady & ChatGPT

return function(gunungTab)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local function teleportTo(pos, label)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char:MoveTo(pos)
            gunungTab:CreateNotify({
                title = "✅ Teleport",
                description = "Berhasil ke " .. label
            })
        else
            gunungTab:CreateNotify({
                title = "⚠️ Gagal Teleport",
                description = "Karakter tidak ditemukan!"
            })
        end
    end

    -------------------------------------------------
    -- 🏔️ GUNUNG SUMBING
    -------------------------------------------------
    local sumbingSection = gunungTab:CreateSection({ text = "🏔️ Gunung Sumbing" })
    local sumbing = {
        { name = "Awal",   pos = Vector3.new(-391.71, 5.01, 245.32) },
        { name = "cp1",    pos = Vector3.new(-376.50, 425.01, 2182.94) },
        { name = "cp2",    pos = Vector3.new(-368.54, 830.67, 3123.00) },
        { name = "cp3",    pos = Vector3.new(-47.78, 1263.81, 4013.42) },
        { name = "cp5",    pos = Vector3.new(-989.67, 1896.13, 5426.57) },
    }
    for _, p in ipairs(sumbing) do
        gunungTab:CreateButton({
            parent = sumbingSection,
            text = "➡️ " .. p.name,
            callback = function()
                teleportTo(p.pos, "Gunung Sumbing - " .. p.name)
            end
        })
    end

    -------------------------------------------------
    -- 🌋 GUNUNG KAWAI
    -------------------------------------------------
    local kawaiSection = gunungTab:CreateSection({ text = "🌋 Gunung Kawai" })
    local kawai = {
        { name = "cp1", pos = Vector3.new(275.65, 84.73, 247.94) },
        { name = "cp3", pos = Vector3.new(1200.37, 273.29, 293.01) },
        { name = "cp5", pos = Vector3.new(1819.28, 325.01, -7.08) },
        { name = "cp8", pos = Vector3.new(3670.93, 494.24, 251.00) },
        { name = "finish", pos = Vector3.new(5139.54, 1147.29, 4713.37) },
    }
    for _, p in ipairs(kawai) do
        gunungTab:CreateButton({
            parent = kawaiSection,
            text = "➡️ " .. p.name,
            callback = function()
                teleportTo(p.pos, "Gunung Kawai - " .. p.name)
            end
        })
    end

    -------------------------------------------------
    -- 🌄 GUNUNG RINDARA
    -------------------------------------------------
    local rindaraSection = gunungTab:CreateSection({ text = "🌄 Gunung Rindara" })
    local rindara = {
        { name = "cp1", pos = Vector3.new(-6.942, 68.008, -45.782) },
        { name = "cp5", pos = Vector3.new(-612.847, 219.089, -1331.625) },
        { name = "cp10", pos = Vector3.new(-629.122, 362.349, -4072.554) },
        { name = "finish", pos = Vector3.new(1744.773, 1104.645, -5026.188) },
    }
    for _, p in ipairs(rindara) do
        gunungTab:CreateButton({
            parent = rindaraSection,
            text = "➡️ " .. p.name,
            callback = function()
                teleportTo(p.pos, "Gunung Rindara - " .. p.name)
            end
        })
    end

    -------------------------------------------------
    -- ℹ️ INFO
    -------------------------------------------------
    local infoSection = gunungTab:CreateSection({ text = "ℹ️ Tentang Menu Teleport" })
    gunungTab:CreateButton({
        parent = infoSection,
        text = "Informasi",
        callback = function()
            gunungTab:CreateNotify({
                title = "Teleport Menu",
                description = "Gunung Sumbing, Kawai, Rindara siap digunakan."
            })
        end
    })
end
