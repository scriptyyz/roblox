-- CUSTOM UI TEMPLATE: SCRIPTYYZ + INFINITE GRASS & POOP (ENGLISH)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Variables for controls
local grassEnabled = false
local poopEnabled = false
local grassLoop = nil
local poopLoop = nil

-- GUI Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 160) -- Height for 2 features
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 160), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Grass Incremental" -- CHANGED TO Grass Incremental
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 82) -- 2 * 35px + 12px padding

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

--- FEATURE FUNCTIONS ---

-- Stop grass loop
local function stopGrass()
    if grassLoop then
        grassLoop:Disconnect()
        grassLoop = nil
    end
end

-- Start grass loop
local function startGrass()
    stopGrass() -- Stop existing if any
    grassLoop = game:GetService("RunService").Heartbeat:Connect(function()
        local args = {
            {
                normal = 100,
                ruby = 100,
                silver = 100,
                golden = 100,
                diamond = 100
            }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GrassCollect"):FireServer(unpack(args))
    end)
end

-- Stop poop loop
local function stopPoop()
    if poopLoop then
        poopLoop:Disconnect()
        poopLoop = nil
    end
end

-- Start poop loop
local function startPoop()
    stopPoop() -- Stop existing if any
    poopLoop = game:GetService("RunService").Heartbeat:Connect(function()
        local args = {
            false
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("IncreasePop"):FireServer(unpack(args))
    end)
end

--- CREATE TOGGLE BUTTONS ---

-- Function to create toggle button
local function createToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = #Container:GetChildren()
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = txt .. (enabled and ": ON" or ": OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
    
    return btn
end

-- Create Grass toggle (Infinite Grass)
createToggle("Infinite Grass", function(state)
    grassEnabled = state
    if state then
        startGrass()
    else
        stopGrass()
    end
end)

-- Create Poop toggle (Infinite Poop)
createToggle("Infinite Poop", function(state)
    poopEnabled = state
    if state then
        startPoop()
    else
        stopPoop()
    end
end)

-- Cleanup when GUI is destroyed
ScreenGui.Destroying:Connect(function()
    stopGrass()
    stopPoop()
end)
