-- DYLOX-EVADE | CUSTOM SCRIPTYYZ UI
-- CUSTOM UI TEMPLATE: SCRIPTYYZ + DYLOX FEATURES

-- UI ELEMENTS
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = false -- Disabled - enabling only through Title bar

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Youtube: Scriptyyz"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

-- ENABLE DRAGGING ONLY THROUGH TITLE BAR
local dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragInput = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInput = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 7)
MinimizeBtn.BackgroundTransparency = 1 
MinimizeBtn.Text = "▼"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 380), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Evade"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto resizing

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

--- VARIABLES AND SERVICES ---
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local settings = {
    speedValue = 25,
    jumpValue = 50,
    bhopEnabled = false,
    autoRevive = false,
    fullBright = false,
    playerEsp = false,
    nextbotEsp = false,
    originalBrightness = Lighting.Brightness,
    originalFog = Lighting.FogEnd,
    originalClock = Lighting.ClockTime
}

--- FORM ELEMENT HELPERS ---

-- Toggle that turns green when ON
local function createToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = txt .. (enabled and ": ON" or ": OFF")
        -- Green when ON, dark gray when OFF
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
end

-- Slider system (always active)
local function createSlider(txt, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 2
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
    
    local dragging = false
    local function move()
        local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
        local percent = math.clamp((mousePos - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        label.Text = txt .. ": " .. val
        callback(val)
    end
    
    sliderFrame.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = true 
            move() 
        end 
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false 
        end 
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function() 
        if dragging then 
            move() 
        end 
    end)
end

--- CREATING FEATURES ---

-- Auto Revive
createToggle("Auto Revive", function(state)
    settings.autoRevive = state
    task.spawn(function()
        while settings.autoRevive do
            for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    
                    if dist < 20 then
                        local reviveEvent = game:GetService("ReplicatedStorage").Events:FindFirstChild("Revive")
                        if reviveEvent then
                            reviveEvent:FireServer(v.Name)
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- Speed Slider (always active)
createSlider("Speed Boost", 0, 100, 25, function(val)
    settings.speedValue = val
end)

-- Jump Power Slider (always active)
createSlider("Jump Power", 0, 200, 50, function(val)
    settings.jumpValue = val
end)

-- Auto BHop
createToggle("Auto BHop", function(state)
    settings.bhopEnabled = state
end)

-- Full Bright
createToggle("Full Bright", function(state)
    settings.fullBright = state
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = settings.originalBrightness
        Lighting.FogEnd = settings.originalFog
        Lighting.ClockTime = settings.originalClock
    end
end)

-- Player ESP
createToggle("Player ESP", function(state)
    settings.playerEsp = state
end)

-- Nextbot ESP
createToggle("Nextbot ESP", function(state)
    settings.nextbotEsp = state
end)

--- MAIN LOOP (Movement & ESP) ---
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character.Humanoid
        
        -- Speed (always active)
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (settings.speedValue / 50))
        end
        
        -- Jump Power (always active)
        hum.JumpPower = settings.jumpValue
        hum.UseJumpPower = true
        
        -- Auto BHop
        if settings.bhopEnabled and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ESP Loop
RunService.RenderStepped:Connect(function()
    -- Players ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChild("PlayerHighlight")
            
            if settings.playerEsp then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerHighlight"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0
                    highlight.Adornee = char
                    highlight.Parent = char
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end

    -- Nextbots ESP
    local gameFolder = workspace:FindFirstChild("Game")
    local nextbots = gameFolder and gameFolder:FindFirstChild("Nextbots")
    
    if nextbots then
        for _, bot in pairs(nextbots:GetChildren()) do
            local highlight = bot:FindFirstChild("BotHighlight")
            if settings.nextbotEsp then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "BotHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = bot
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- Notification and H key bind
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.H then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Small notification that everything is loaded
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DyLox-Evade",
    Text = "Successfully loaded! Press H to open/close.",
    Duration = 3
})
