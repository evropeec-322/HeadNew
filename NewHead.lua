local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = true

-- UI Toggle (по желанию)
local gui = Instance.new("ScreenGui", game.CoreGui)
local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "ESP ON"
button.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    button.Text = ESPEnabled and "ESP ON" or "ESP OFF"
end)

-- Создание Highlight
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
end

-- Проверка видимости через Raycast
local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Blacklist
    ray.FilterDescendantsInstances = {LocalPlayer.Character}

    local result = workspace:Raycast(origin, direction, ray)
    if result and result.Instance:IsDescendantOf(targetPart.Parent) then
        return true -- виден
    end
    return false -- за стенкой
end

-- Обновление ESP и цвета
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
                end
            end
        end
    end
end)

-- На новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)
