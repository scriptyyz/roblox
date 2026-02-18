-- CUSTOM UI: SCRIPTYYZ - THE ONE THAT WORKS
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
MainFrame.Size = UDim2.new(0, 250, 0, 270) 
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 270), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Escape Rising Lava For Brainrots" 
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 10

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)

local function createToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = txt .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
end

local function createButton(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        callback()
        task.wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
end

local function createSlider(txt, min, max, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 32)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. min
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.ZIndex = 2
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new(0, 0, 1, 0)
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
    sliderFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
    game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    game:GetService("RunService").RenderStepped:Connect(function() if dragging then move() end end)
end

-- 1. REMOVE LAVA (ORIGINAL WORKING METHOD)
local lavaToggle = false
createToggle("Remove Lava", function(state)
    lavaToggle = state
    task.spawn(function()
        while lavaToggle do
            local gl = workspace:FindFirstChild("GameLava")
            if gl then for _, c in pairs(gl:GetChildren()) do c:Destroy() end end
            for _, o in pairs(workspace:GetDescendants()) do
                if o:IsA("BasePart") and o.Name:lower():find("lava") then o:Destroy() end
            end
            task.wait(1)
        end
    end)
end)

-- 2. TELEPORTS
createButton("TP End Zone", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(82.684, -2645.274, -138.457) end
end)
createButton("TP Safe Zone", function()
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(84.253, -4.025, -72.663) end
end)

-- 3. COLLECT CASH
local autoCash = false
createToggle("Collect Cash", function(state)
    autoCash = state
    task.spawn(function()
        while autoCash do
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local oldPos = hrp.CFrame
                for _, plot in pairs(workspace.Plots:GetChildren()) do
                    if tonumber(plot.Name) then 
                        local dist = (hrp.Position - plot:GetPivot().Position).Magnitude
                        if dist < 60 then 
                            local collectFolder = plot:FindFirstChild("Collect")
                            if collectFolder then
                                for _, group in pairs(collectFolder:GetChildren()) do
                                    local btn = group:FindFirstChild("Button")
                                    if btn and btn:IsA("BasePart") then
                                        hrp.CFrame = btn.CFrame
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                end
                hrp.CFrame = oldPos
            end
            task.wait(5)
        end
    end)
end)

-- 4. WALKSPEED (BOTTOM)
createSlider("Walkspeed", 16, 250, function(val)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = val
    end
end)
