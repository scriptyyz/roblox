local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- CUSTOM UI SETUP
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
MainFrame.Size = UDim2.new(0, 250, 0, 210) -- Povećana visina za treći feature
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 210), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "War Tycoon"
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
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- UI ELEMENT FUNCTIONS
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
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
        callback(enabled)
    end)
end

local function createButton(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        callback()
    end)
end

-- AUTO FARM FUNCTIONS
local plr = Players.LocalPlayer
local originalPosition = nil
local farmingConnection = nil
local isFarming = false
local isProcessing = false

local Configuration = {
    Farm = {
        AutoBuy = false,
        RecupMonay = false,
        ModeRecupMonay = "Crate",
        CashTarget = 100000, 
        FallbackTeleports = loadstring(game:HttpGet("https://raw.githubusercontent.com/FacilityHUB/War-Tycoon/refs/heads/main/Positions"))(),
        SellPosition = nil,
        TeleportDelay = 2, 
        RecupCrate = 7,
        SellCrate = 7,
    },
    CapturePoint = Vector3.new(-503, 183, -1021),
    OilBarrels = {
        Vector3.new(-1938, 121, -3700),
        Vector3.new(-1208, 73, -881),
        Vector3.new(1705, 121, 3779)
    }
}

local capPointSavedPos = nil
local collectingBarrels = false

local function getRoot()
    local char = plr.Character or plr.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function getCurrentCash()
    local stats = plr:FindFirstChild("leaderstats")
    local cash = stats and stats:FindFirstChild("Cash")
    return cash and cash.Value or 0
end

local function findPlayerTycoon()
    for _, tycoon in ipairs(workspace.Tycoon.Tycoons:GetChildren()) do
        if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value == plr then
            return tycoon
        end
    end
    return nil
end

local function storeSellPosition()
    local tycoon = findPlayerTycoon()
    if not tycoon then return false end
    
    local oilCollector = tycoon:FindFirstChild("Essentials") and tycoon.Essentials:FindFirstChild("Oil Collector")
    if oilCollector then
        local collectorPart = oilCollector:FindFirstChild("Collector") and oilCollector.Collector:FindFirstChild("Plane")
        if collectorPart then
            Configuration.Farm.SellPosition = collectorPart.CFrame * CFrame.new(0, 3, 0)
            return true
        end
    end
    return false
end

local function collectBarrelsLoop()
    while collectingBarrels do
        for i, pos in ipairs(Configuration.OilBarrels) do
            if not collectingBarrels then break end
            
            local root = getRoot()
            root.CFrame = CFrame.new(pos)
            task.wait(Configuration.Farm.TeleportDelay)
            
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(Configuration.Farm.RecupCrate)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(1)
            
            if not Configuration.Farm.SellPosition then storeSellPosition() end
            
            if Configuration.Farm.SellPosition then
                root.CFrame = Configuration.Farm.SellPosition
                task.wait(Configuration.Farm.TeleportDelay)
                
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(Configuration.Farm.SellCrate)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(1)
            end
        end
        task.wait(1)
    end
end

local function isGreenButton(btn)
    local neon = btn:FindFirstChild("Neon") or btn:FindFirstChild("Button")
    if neon and neon:IsA("BasePart") then
        local color = neon.Color
        return (color.G > color.R and color.G > color.B)
    end
    return false
end

local function collectAndSellCrate()
    if isProcessing then return end
    isProcessing = true
    
    local crates = workspace:FindFirstChild("Game Systems") and workspace["Game Systems"]:FindFirstChild("Crate Workspace")
    local found = false
    
    if crates then
        for _, crate in ipairs(crates:GetChildren()) do
            if crate.Name:find("Crate") and crate:IsA("BasePart") then
                local owner = crate:GetAttribute("Owner")
                if owner and tostring(owner) == plr.Name then continue end
                
                local root = getRoot()
                root.CFrame = crate.CFrame * CFrame.new(3, 0, 0) 
                task.wait(2) 
                
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(Configuration.Farm.RecupCrate)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                
                task.wait(2)
                
                if not Configuration.Farm.SellPosition then storeSellPosition() end
                if Configuration.Farm.SellPosition then
                    root.CFrame = Configuration.Farm.SellPosition
                    task.wait(2)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(Configuration.Farm.SellCrate)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    task.wait(2)
                end
                found = true
                break
            end
        end
    end
    
    if not found then
        for _, pos in ipairs(Configuration.Farm.FallbackTeleports) do
            if not isFarming then break end
            getRoot().CFrame = pos
            task.wait(Configuration.Farm.TeleportDelay)
        end
    end
    isProcessing = false
end

local function startAutoFarm()
    if farmingConnection then return end
    isFarming = true
    originalPosition = getRoot().CFrame
    storeSellPosition()

    farmingConnection = RunService.Heartbeat:Connect(function()
        if not isFarming then 
            if farmingConnection then farmingConnection:Disconnect() farmingConnection = nil end
            return 
        end
        if isProcessing or collectingBarrels then return end

        local currentMoney = getCurrentCash()

        if Configuration.Farm.AutoBuy and currentMoney >= Configuration.Farm.CashTarget then
            local tycoon = findPlayerTycoon()
            local buttons = tycoon and tycoon:FindFirstChild("UnpurchasedButtons")
            
            if buttons then
                local targetButton = nil
                for _, btn in ipairs(buttons:GetChildren()) do
                    if isGreenButton(btn) then
                        targetButton = btn
                        break
                    end
                end

                if targetButton then
                    local neon = targetButton:FindFirstChild("Neon") or targetButton:FindFirstChild("Button")
                    getRoot().CFrame = neon.CFrame + Vector3.new(0, 5, 0)
                    task.wait(Configuration.Farm.TeleportDelay)
                else
                    collectAndSellCrate()
                end
            else
                collectAndSellCrate()
            end
        elseif Configuration.Farm.RecupMonay then
            collectAndSellCrate()
        end
    end)
end

-- CREATE UI ELEMENTS (SAMO 3 FEATURE-A)
-- Auto Farm Toggle (preimenovano)
createToggle("Auto Farm", function(state)
    Configuration.Farm.AutoBuy = state
    Configuration.Farm.RecupMonay = state
    if state then 
        startAutoFarm() 
    else 
        isFarming = false 
    end
end)

-- Auto Oil Barrels Toggle
createToggle("Auto Oil Barrels", function(state)
    collectingBarrels = state
    if state then
        task.spawn(collectBarrelsLoop)
    end
end)

-- TP to Capture Point Button
createButton("TP / Return Capture Point", function()
    local root = getRoot()
    if not capPointSavedPos then
        capPointSavedPos = root.CFrame
        root.CFrame = CFrame.new(Configuration.CapturePoint)
    else
        root.CFrame = capPointSavedPos
        capPointSavedPos = nil
    end
end)

print("Scriptyyz UI - War Tycoon Autofarm Loaded!")
