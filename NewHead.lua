local sky = Instance.new("Sky")
sky.Name = "CustomSky"

-- Заменяем стандартные текстуры на свои (можешь вставить другие ссылки)
sky.SkyboxBk = "rbxassetid://159454299"  -- Задняя сторона
sky.SkyboxDn = "rbxassetid://159454296"  -- Низ
sky.SkyboxFt = "rbxassetid://159454293"  -- Перед
sky.SkyboxLf = "rbxassetid://159454286"  -- Левая
sky.SkyboxRt = "rbxassetid://159454300"  -- Правая
sky.SkyboxUp = "rbxassetid://159454288"  -- Верх

-- Удаляем старое небо, если есть
local lighting = game:GetService("Lighting")
for _, v in pairs(lighting:GetChildren()) do
    if v:IsA("Sky") then
        v:Destroy()
    end
end

-- Устанавливаем новое небо
sky.Parent = lighting
