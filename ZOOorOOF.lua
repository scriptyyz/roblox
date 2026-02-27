-- =============================================
-- ZOO VS OOF - PoopUnderGr0und (Scriptyyz UI)
-- =============================================

-- Load required services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Load game data
local TauntData = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("TauntData"))
local CrouchData = require(ReplicatedStorage:WaitForChild("Data"):WaitForChild("CrouchData"))
local Animals = ReplicatedStorage:WaitForChild("Data"):WaitForChild("AnimalData"):WaitForChild("Animals")
local Event = require(ReplicatedStorage:WaitForChild("Event"))
local ShootButton = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MobileController"):WaitForChild("Shoot")

-- =============================================
-- STATE VARIABLES
-- =============================================
local ESPEnabled = false
local AutoAimEnabled = false
local NoclipEnabled = false
local AutoKillEnabled = false
local AutoFarmEnabled = false
local AntiDelayEnabled = false
local GlobalSpeed = 16

-- =============================================
-- CUSTOM UI TEMPLATE: SCRIPTYYZ
-- =============================================
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
MainFrame.Size = UDim2.new(0, 250, 0, 350) -- Just a little bit more height (was 300, now 350)
MainFrame.Active = true
MainFrame.Draggable = true

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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 350), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "ZOO or OOF"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6) -- Back to original padding
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- =============================================
-- UI HELPER FUNCTIONS
-- =============================================

-- Toggle button that turns green when ON
local function createToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35) -- Back to original height
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
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
end

-- Slider system
local function createSlider(txt, min, max, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 35) -- Back to original height
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. min
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 2
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
    
    local dragging = false
    local function move()
        local mousePos = UserInputService:GetMouseLocation().X
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
    
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false 
        end 
    end)
    
    RunService.RenderStepped:Connect(function() 
        if dragging then 
            move() 
        end 
    end)
end

-- Regular button (no toggle)
local function createButton(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35) -- Back to original height
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- =============================================
-- CREATE ALL FEATURES
-- =============================================

-- Auto Farm (Taunt 10M)
createToggle("AUTO FARM", function(state)
    AutoFarmEnabled = state
    TauntData.tauntReward = (state and 10000000) or 2
    TauntData.cooldown = (state and 0) or 3
end)

-- Anti Delay Crouch
createToggle("ANTI DELAY CROUCH", function(state)
    AntiDelayEnabled = state
    CrouchData.cooldownOn = (state and 0) or 1
    CrouchData.cooldownOff = (state and 0) or 5
end)

-- ESP Animals
createToggle("ESP ANIMALS", function(state)
    ESPEnabled = state
end)

-- Auto Kill / Aim
createToggle("AUTO KILL / AIM", function(state)
    AutoKillEnabled = state
    AutoAimEnabled = state
end)

-- Noclip
createToggle("NOCLIP", function(state)
    NoclipEnabled = state
end)

-- Speed Slider
createSlider("SPEED", 16, 250, function(val)
    GlobalSpeed = val
    -- Update all animals speed
    for _, animalModule in pairs(Animals:GetChildren()) do
        if animalModule:IsA("ModuleScript") then
            pcall(function()
                local animalData = require(animalModule)
                animalData.walkspeed = GlobalSpeed
                animalData.gravity = 170
            end)
        end
    end
end)

-- Hide = Teleport button
createButton("HIDE = TELEPORT", function()
    pcall(function()
        local teleportTarget = workspace.Lobby.Lobby.Visual.Props.Visual:GetChildren()[29]
        if (teleportTarget and LocalPlayer.Character) then
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetPos = (teleportTarget:IsA("BasePart") and teleportTarget.Position) or teleportTarget:GetPivot().Position
            rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
        end
    end)
end)

-- =============================================
-- MAIN LOOP (Heartbeat)
-- =============================================
RunService.Heartbeat:Connect(function()
    -- Auto Farm
    if AutoFarmEnabled then
        pcall(function()
            Event.Taunt.play()
        end)
    end
    
    -- Auto Kill
    if AutoKillEnabled then
        pcall(function()
            local gameplay = workspace:FindFirstChild("Gameplay")
            local animals = gameplay and gameplay.Dynamic:FindFirstChild("Animals")
            
            if animals then
                for _, animal in pairs(animals:GetChildren()) do
                    local rootPart = animal:FindFirstChild("HumanoidRootPart") or animal:FindFirstChildWhichIsA("BasePart")
                    if rootPart then
                        local screenPos, visible = Camera:WorldToViewportPoint(rootPart.Position)
                        if visible then
                            ShootButton.Size = UDim2.fromScale(0.8, 0.8)
                            Event.Shooting.shotPlayer(
                                Camera.CFrame.Position,
                                rootPart.Position,
                                animal,
                                rootPart.Name,
                                rootPart.CFrame:ToObjectSpace(CFrame.new(rootPart.Position))
                            )
                            task.wait()
                            ShootButton.Size = UDim2.fromScale(1, 1)
                        end
                    end
                end
            end
        end)
    end
end)

-- =============================================
-- RENDER LOOP (RenderStepped)
-- =============================================
RunService.RenderStepped:Connect(function()
    -- Player speed and noclip
    if (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) then
        LocalPlayer.Character.Humanoid.WalkSpeed = GlobalSpeed
        
        if NoclipEnabled then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
    
    -- Auto Aim
    if AutoAimEnabled then
        local closestTarget = nil
        local closestDistance = math.huge
        
        local animals = workspace:FindFirstChild("Gameplay") and workspace.Gameplay.Dynamic:FindFirstChild("Animals")
        
        if animals then
            for _, animal in pairs(animals:GetChildren()) do
                local targetPart = animal:FindFirstChild("HumanoidRootPart") or animal:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    local screenPos, visible = Camera:WorldToViewportPoint(targetPart.Position)
                    if visible then
                        local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if (distance < closestDistance) then
                            closestDistance = distance
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end
        
        if closestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
        end
    end
    
    -- ESP
    if ESPEnabled then
        local animals = workspace:FindFirstChild("Gameplay") and workspace.Gameplay.Dynamic:FindFirstChild("Animals")
        if animals then
            for _, animal in pairs(animals:GetChildren()) do
                local highlight = animal:FindFirstChild("OOF_ESP") or Instance.new("Highlight", animal)
                highlight.Name = "OOF_ESP"
                highlight.FillColor = Color3.fromRGB(255, 60, 0)
                highlight.Enabled = true
            end
        end
    end
end)

-- =============================================
-- LOADING CONFIRMATION
-- =============================================
print("Zoo VS Oof Loaded Successfully with Scriptyyz UI!")
