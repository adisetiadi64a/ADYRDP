-- 🧭 Ady Hub - Teleport Menu (Integrasi ke GUI utama)
-- By Ady & ChatGPT

return function(GUI)

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

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
    -- 🏔️ GUNUNG SUMBING
    -------------------------------------------------
    local sumbingSection = GUI:CreateSection({ text = "🏔️ Gunung Sumbing" })
    local sumbing = {
        { name = "Awal",   pos = Vector3.new(-391.71, 5.01, 245.32) },
        { name = "cp1",    pos = Vector3.new(-376.50, 425.01, 2182.94) },
        { name = "cp2",    pos = Vector3.new(-368.54, 830.67, 3123.00) },
        { name = "cp3",    pos = Vector3.new(-47.78, 1263.81, 4013.42) },
        { name = "cp5",    pos = Vector3.new(-989.67, 1896.13, 5426.57) },
    }
    for _, point in ipairs(sumbing) do
        GUI:CreateButton({
            parent = sumbingSection,
            text = "➡️ " .. point.name,
            callback = function()
                teleportTo(point.pos, "Gunung Sumbing - " .. point.name)
            end
        })
    end

    -------------------------------------------------
    -- 🌋 GUNUNG KAWAI
    -------------------------------------------------
    local kawaiSection = GUI:CreateSection({ text = "🌋 Gunung Kawai" })
    local kawai = {
        { name = "cp1", pos = Vector3.new(275.65, 84.73, 247.94) },
        { name = "cp3", pos = Vector3.new(1200.37, 273.29, 293.01) },
        { name = "cp5", pos = Vector3.new(1819.28, 325.01, -7.08) },
        { name = "cp8", pos = Vector3.new(3670.93, 494.24, 251.00) },
        { name = "finish", pos = Vector3.new(5139.54, 1147.29, 4713.37) },
    }
    for _, point in ipairs(kawai) do
        GUI:CreateButton({
            parent = kawaiSection,
            text = "➡️ " .. point.name,
            callback = function()
                teleportTo(point.pos, "Gunung Kawai - " .. point.name)
            end
        })
    end

    -------------------------------------------------
    -- 🌄 GUNUNG RINDARA
    -------------------------------------------------
    local rindaraSection = GUI:CreateSection({ text = "🌄 Gunung Rindara" })
    local rindara = {
        { name = "cp1", pos = Vector3.new(-6.942, 68.008, -45.782) },
        { name = "cp5", pos = Vector3.new(-612.847, 219.089, -1331.625) },
        { name = "cp10", pos = Vector3.new(-629.122, 362.349, -4072.554) },
        { name = "finish", pos = Vector3.new(1744.773, 1104.645, -5026.188) },
    }
    for _, point in ipairs(rindara) do
        GUI:CreateButton({
            parent = rindaraSection,
            text = "➡️ " .. point.name,
            callback = function()
                teleportTo(point.pos, "Gunung Rindara - " .. point.name)
            end
        })
    end

    -------------------------------------------------
    -- ℹ️ INFO
    -------------------------------------------------
    local infoSection = GUI:CreateSection({ text = "ℹ️ Tentang Menu Teleport" })
    GUI:CreateButton({
        parent = infoSection,
        text = "Informasi",
        callback = function()
            GUI:CreateNotify({
                title = "Teleport Menu",
                description = "Daftar gunung dimuat langsung di tab Gunung Ady Hub.\nGunung: Sumbing, Kawai, Rindara."
            })
        end
    })
end
