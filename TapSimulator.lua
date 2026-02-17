-- [[ TAP SIMULATOR - SCRIPTYYZ ]] --
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
MainFrame.Size = UDim2.new(0, 250, 0, 240)
MainFrame.Active = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)

-- Draggable Fix (Samo preko Title)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
end)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Youtube: Scriptyyz"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

-- Vracena Strelica
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundTransparency = 1 
MinimizeBtn.Text = "▼"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 240), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.Position = UDim2.new(0, 0, 1, -20)
Footer.BackgroundTransparency = 1
Footer.Text = "Tap Simulator"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -65)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- [[ SERVICES ]] --
local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

_G.AutoClick = false
_G.BypassActive = false
_G.FlyActive = false
_G.FlySpeed = 16

local Toggles = {}

-- [[ HELPERS ]] --
local function createToggle(name, txt, order, callback)
    local btn = Instance.new("TextButton", Container)
    btn.LayoutOrder = order
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": Off"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    local function updateBtn()
        btn.Text = txt .. (enabled and ": On" or ": Off")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
    end
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateBtn()
        callback(enabled)
    end)
    Toggles[name] = {Update = function(val) enabled = val updateBtn() end}
end

local function createSlider(txt, order, min, max, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.LayoutOrder = order
    sliderFrame.Size = UDim2.new(1, 0, 0, 35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. min
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 3
    
    local draggingSlider = false
    local function move()
        local mousePos = UIS:GetMouseLocation().X
        local relativeX = mousePos - sliderFrame.AbsolutePosition.X
        local percent = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        label.Text = txt .. ": " .. val
        callback(val)
    end
    sliderFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true move() end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end end)
    RunService.RenderStepped:Connect(function() if draggingSlider then move() end end)
end

-- [[ WASD FLY ]] --
local function StartFly()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    local bg = Instance.new("BodyGyro", root)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.Name = "FlyGyro"
    local bv = Instance.new("BodyVelocity", root)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9); bv.Name = "FlyVel"
    
    task.spawn(function()
        while _G.FlyActive do
            RunService.RenderStepped:Wait()
            local direction = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0,1,0) end
            bv.velocity = direction.Unit * _G.FlySpeed
            bg.CFrame = camera.CFrame
            if direction.Magnitude == 0 then bv.velocity = Vector3.new(0,0,0) end
        end
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end)
end

-- [[ FEATURES ]] --
createToggle("AutoTap", "Auto Tap (T)", 1, function(state) _G.AutoClick = state end)
createToggle("BypassAfk", "Bypass Afk", 2, function(state) _G.BypassActive = state end)
createToggle("Fly", "Fly", 3, function(state) _G.FlyActive = state if state then StartFly() end end)
createSlider("Fly Speed", 4, 16, 300, function(val) _G.FlySpeed = val end)

-- [[ CONTROLS ]] --
UIS.InputBegan:Connect(function(i, c)
    if c then return end
    if i.KeyCode == Enum.KeyCode.T then 
        _G.AutoClick = not _G.AutoClick
        if Toggles["AutoTap"] then Toggles["AutoTap"].Update(_G.AutoClick) end
    elseif i.KeyCode == Enum.KeyCode.Insert then 
        MainFrame.Visible = not MainFrame.Visible 
    end
end)

task.spawn(function()
    while true do
        if _G.AutoClick then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait(0.01)
    end
end)
