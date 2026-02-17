-- CUSTOM UI: +1 SPEED CAR TSUNAMI ESCAPE
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 240) -- Smanjena visina da nema viška prostora
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 240), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "+1 Speed Car Tsunami Escape"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -85)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)

--- HELPERS ---

local function createToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
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
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

--- FUNCTIONS ---

local function teleportToWinStage()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local targetPart = Workspace:FindFirstChild("WinStages") and Workspace.WinStages:FindFirstChild("Stage 17") and Workspace.WinStages["Stage 17"]:FindFirstChild("Return") and Workspace.WinStages["Stage 17"].Return:FindFirstChild("Touch")
    
    if targetPart and root then
        root.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
        firetouchinterest(root, targetPart, 0)
        task.wait(0.1)
        firetouchinterest(root, targetPart, 1)
    end
end

local function teleportToTreadmill()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local treadmills = Workspace:FindFirstChild("Treadmills")
    if treadmills and root then
        local targetModel = treadmills:GetChildren()[11]
        if targetModel then
            local targetPart = targetModel:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                root.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
end

--- FEATURES ---

createToggle("Auto Win Farming", function(state)
    _G.AutoWin = state
    while _G.AutoWin do
        pcall(teleportToWinStage)
        task.wait(0.5)
    end
end)

createToggle("Speed Farming", function(state)
    _G.SpeedFarm = state
    while _G.SpeedFarm do
        pcall(teleportToTreadmill)
        task.wait(5)
    end
end)

createButton("Unlock VIP", function()
    if Workspace:FindFirstChild("vipDoors") then
        Workspace.vipDoors:Destroy()
    end
end)

createButton("Disable Waves", function()
    -- Brisanje trenutnih talasa
    if Workspace:FindFirstChild("Tsunamis") then Workspace.Tsunamis:Destroy() end
    if Workspace:FindFirstChild("Tsunamis2") then Workspace.Tsunamis2:Destroy() end
    
    -- Trajno sprečavanje spawnovanja (kao što je traženo)
    Workspace.ChildAdded:Connect(function(child)
        if child.Name == "Tsunamis" or child.Name == "Tsunamis2" then
            task.wait()
            child:Destroy()
        end
    end)
end)
