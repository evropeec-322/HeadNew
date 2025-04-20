local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "ESP OFF"
ToggleButton.Parent = ScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ToggleButton.Text = ESPEnabled and "ESP ON" or "ESP OFF"
end)

-- Создание ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local existing = player.Character:FindFirstChildOfClass("Highlight")
    if existing then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight_ESP"
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
end

-- Основной цикл
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local esp = player.Character:FindFirstChildOfClass("Highlight")
            if ESPEnabled and not esp then
                pcall(function()
                    CreateESP(player)
                end)
            elseif not ESPEnabled and esp then
                esp:Destroy()
            end
        end
    end
end)

-- Подключение новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        char:WaitForChild("HumanoidRootPart")
        wait(0.1)
        if ESPEnabled then
            pcall(function()
                CreateESP(player)
            end)
        end
    end)
end)
