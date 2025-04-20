-- Roblox Lua Script (Executor)
-- Увеличение хитбокса головы у всех игроков (кроме тебя)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Настройки хитбокса
local HITBOX_SIZE = Vector3.new(5, 5, 5) -- Размер головы
local TRANSPARENCY = 0.5 -- Прозрачность головы
local MATERIAL = Enum.Material.ForceField -- Материал для визуала

-- Основная функция увеличения головы
local function enlargeHead(player)
    if player ~= LocalPlayer and player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            -- Убираем Mesh, если есть
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh:Destroy()
            end

            -- Изменяем параметры головы
            head.Size = HITBOX_SIZE
            head.Transparency = TRANSPARENCY
            head.Material = MATERIAL
            head.CanCollide = false

            -- Обновляем позиции привязанных вещей (например, аксессуаров)
            local welds = head:GetChildren()
            for _, weld in pairs(welds) do
                if weld:IsA("Weld") or weld:IsA("Motor6D") then
                    weld.Part0 = head
                end
            end
        end
    end
end

-- Цикл обновления
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            enlargeHead(player)
        end)
    end
end)
