local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = true

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

-- Функция создания Highlight
local function CreateESP(player)
    if player == LocalPlayer then return end
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
local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, params)
    if result and result.Instance:IsDescendantOf(part.Parent) then
        return true
    end
    return false
end

-- Основной цикл ESP
RunService.RenderStepped:Connect(function()
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

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

-- Инициализация всех текущих игроков
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end
