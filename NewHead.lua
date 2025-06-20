local LocalPlayer = Players.LocalPlayerAdd commentMore actions
local ESPEnabled = true

-- UI Toggle (по желанию)
-- UI Toggle
local gui = Instance.new("ScreenGui", game.CoreGui)
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "ESP ON"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0

button.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    button.Text = ESPEnabled and "ESP ON" or "ESP OFF"
end)

-- Создание Highlight
-- Функция создания Highlight
local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    if player.Character:FindFirstChildOfClass("Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight_ESP"
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    local function apply()
        if player.Character and not player.Character:FindFirstChildOfClass("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight_ESP"
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
        end
    end
    apply()
    -- Если Character ещё не загружен
    if not player.Character then
        player.CharacterAdded:Once(function()
            wait(1)
            apply()
        end)
    end
end

-- Проверка видимости через Raycast
local function IsVisible(targetPart)
local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Blacklist
    ray.FilterDescendantsInstances = {LocalPlayer.Character}
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, ray)
    if result and result.Instance:IsDescendantOf(targetPart.Parent) then
        return true -- виден
    local result = workspace:Raycast(origin, direction, params)
    if result and result.Instance:IsDescendantOf(part.Parent) then
        return true
    end
    return false -- за стенкой
    return false
end

-- Обновление ESP и цвета
-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local esp = p.Character:FindFirstChildOfClass("Highlight")
                if esp then esp.Enabled = false end
            end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local esp = player.Character:FindFirstChildOfClass("Highlight")
            if not esp then
                CreateESP(player)
                esp = player.Character:FindFirstChildOfClass("Highlight")
            end
            if esp then
                esp.Enabled = true
                local head = player.Character:FindFirstChild("Head")
                if IsVisible(head) then
                    esp.FillColor = Color3.new(0, 1, 0) -- зелёный (виден)
                else
                    esp.FillColor = Color3.new(1, 0, 0) -- красный (за стеной)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("Head") then
                local esp = player.Character:FindFirstChildOfClass("Highlight")
                if not esp and ESPEnabled then
                    CreateESP(player)
                    esp = player.Character:FindFirstChildOfClass("Highlight")
                end
                if esp then
                    esp.Enabled = ESPEnabled
                    local head = player.Character:FindFirstChild("Head")
                    if ESPEnabled and head then
                        local visible = IsVisible(head)
                        esp.FillColor = visible and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    end
                end
            end
        end
    end
end)

-- На новых игроков
-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
@@ -87,3 +91,10 @@ Players.PlayerAdded:Connect(function(player)
        end
    end)
end)

-- Инициализация всех текущих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer thenAdd commentMore actions
        CreateESP(player)
    end
end
