-- CUSTOM UI TEMPLATE: SCRIPTYYZ
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
MainFrame.Size = UDim2.new(0, 250, 0, 250)
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 250), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "+1 Muscle Per Step"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0)

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper Functions
local function createToggle(text, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = text .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
end

local function createSlider(text, min, max, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. min
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 2
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
    
    -- Dugme preko celog slidera za hvatanje
    local dragButton = Instance.new("TextButton", sliderFrame)
    dragButton.Size = UDim2.new(1, 0, 1, 0)
    dragButton.BackgroundTransparency = 1
    dragButton.Text = ""
    dragButton.ZIndex = 3
    
    local dragging = false
    local function move(input)
        if not dragging then return end
        local mousePos = input.Position.X
        local percent = math.clamp((mousePos - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        label.Text = text .. ": " .. val
        callback(val)
    end
    
    dragButton.MouseButton1Down:Connect(function(input)
        dragging = true
        move(input)
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            move(input)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- =============================================
-- AUTO WIN
-- =============================================
local autoWinEnabled = false
local winPosition = Vector3.new(-3095.876708984375, 51.59377670288086, -23.75075912475586)

createToggle("Auto Win", function(state)
    autoWinEnabled = state
    if state then
        spawn(function()
            while autoWinEnabled do
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(winPosition)
                end
                wait(0.5)
            end
        end)
    end
end)

-- Manual Win Button
local manualWin = Instance.new("TextButton", Container)
manualWin.Size = UDim2.new(1, 0, 0, 35)
manualWin.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
manualWin.Text = "Manual Win"
manualWin.TextColor3 = Color3.fromRGB(255, 255, 255)
manualWin.Font = Enum.Font.GothamBold
manualWin.TextSize = 14
Instance.new("UICorner", manualWin).CornerRadius = UDim.new(0, 8)

manualWin.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(winPosition)
        manualWin.Text = "WIN!"
        manualWin.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        wait(0.5)
        manualWin.Text = "Manual Win"
        manualWin.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- =============================================
-- FLY + SPEED SLIDER
-- =============================================
local flyEnabled = false
local flySpeed = 50
local bv = nil
local bg = nil

createToggle("Fly", function(state)
    flyEnabled = state
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid then return end
    
    if state then
        humanoid.PlatformStand = true
        
        bv = Instance.new("BodyVelocity")
        bv.Parent = hrp
        bv.MaxForce = Vector3.new(10000, 10000, 10000)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        bg = Instance.new("BodyGyro")
        bg.Parent = hrp
        bg.MaxTorque = Vector3.new(10000, 10000, 10000)
        bg.P = 10000
        
        spawn(function()
            while flyEnabled and bv and bg do
                local camera = workspace.CurrentCamera
                local move = Vector3.new(0, 0, 0)
                local UIS = game:GetService("UserInputService")
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    move = move + camera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    move = move - camera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    move = move - camera.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    move = move + camera.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    move = move + Vector3.new(0, 1, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    move = move - Vector3.new(0, 1, 0)
                end
                
                if move.Magnitude > 0 then
                    bv.Velocity = move.Unit * flySpeed
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                
                bg.CFrame = camera.CFrame
                wait()
            end
        end)
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        humanoid.PlatformStand = false
    end
end)

-- Speed Slider (ISTI KO I RANIJE ALI NE POMERA GUI)
createSlider("Fly Speed", 10, 200, function(val)
    flySpeed = val
end)

print("GUI Loaded - +1 Muscle Per Step")
