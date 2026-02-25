-- CUSTOM UI TEMPLATE: SCRIPTYYZ
-- Game: Star Fishing [ALPHA] - Auto Fish, Instant Reel, TP Sell, Anti-AFK, Walkspeed

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
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 300), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Star Fishing"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

--- FORM ELEMENT HELPERS ---

-- Toggle that turns green when ON
local function createToggle(txt, order, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order
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

-- Simple button for TP Sell (click only, no ON/OFF)
local function createTPButton(txt, order, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        -- Change color briefly to show it worked
        btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        btn.Text = "✔ Teleported!"
        callback()
        task.wait(0.8)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = txt
    end)
    
    return btn
end

-- Your slider system (at the bottom)
local function createSlider(txt, min, max, order, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.LayoutOrder = order
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
        local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
        local percent = math.clamp((mousePos - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        label.Text = txt .. ": " .. val
        callback(val)
    end
    
    sliderFrame.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end 
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end 
    end)
    game:GetService("RunService").RenderStepped:Connect(function() 
        if dragging then move() end 
    end)
end

-- =====================
-- STAR FISHING LOGIC
-- =====================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Client = Players.LocalPlayer
local Connections = {}
local Flags = { Farm = 'Self' }

-- Root and Humanoid helpers
local function GetRoot(Character) return Character and Character:FindFirstChild('HumanoidRootPart') end
local function GetHumanoid(Character) return Character and Character:FindFirstChild('Humanoid') end

-- Cast fishing rod (Auto Fish)
local function Cast()
    local Character = Client.Character
    if not Character then return end
    local Humanoid = GetHumanoid(Character)
    local Root = GetRoot(Character)
    if not Root then return end

    local Rod = Character:FindFirstChild('Rod')
    if not Rod then return end

    local Farming = Flags.Farm == 'Self' and Root or workspace.Galaxies:FindFirstChild(Flags.Farm) or Root
    local FarmType = {Farming:GetPivot().Position + Vector3.new(0, 5, 0), Farming:GetPivot().LookVector}
    local CastArguments = {
        Humanoid,
        FarmType[1],
        FarmType[2],
        Rod.Model.Nodes.RodTip.Attachment
    }

    local Cast = ReplicatedStorage.Events.Global.Cast
    Cast:FireServer(table.unpack(CastArguments))

    local WithdrawBobber = ReplicatedStorage.Events.Global.WithdrawBobber
    WithdrawBobber:FireServer(Client.Character.Humanoid)
end

-- Instant Reel logic
local ClientRecieveItems = ReplicatedStorage.Events.Global.ClientRecieveItems
local confirmConnection = nil

local function setupInstantReel(enabled)
    if confirmConnection then
        confirmConnection:Disconnect()
        confirmConnection = nil
    end

    if enabled then
        confirmConnection = ClientRecieveItems.OnClientEvent:Connect(function(...)
            local Data = {...}
            local Info = Data[4] or {}
            local TimingTbl = Data[6] or {}

            for Index, StarData in Info do
                local Id = StarData['id']
                if Id then
                    task.wait(TimingTbl[Index] or 3)
                    local ClientItemConfirm = ReplicatedStorage.Events.Global.ClientItemConfirm
                    ClientItemConfirm:FireServer(Id)
                end
            end
        end)
    end
end

-- Auto Fish loop
local autoFishLoop = nil
local function setupAutoFish(enabled)
    if autoFishLoop then
        autoFishLoop:Disconnect()
        autoFishLoop = nil
    end

    if enabled then
        autoFishLoop = RunService.Heartbeat:Connect(function()
            if not _G.autoFishEnabled then return end
            local Character = Client.Character
            local Root = GetRoot(Character)
            if not Root then return end
            Cast()
            task.wait(0.1)
        end)
    end
end

-- Anti-AFK logic
local antiAfkConnection = nil
local function setupAntiAfk(enabled)
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    
    if enabled then
        antiAfkConnection = RunService.Heartbeat:Connect(function()
            if not _G.antiAfkEnabled then return end
            local character = Client.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:Move(Vector3.new(0.001, 0, 0), true)
                end
            end
            task.wait(60)
        end)
    end
end

-- TP Sell function (click only)
local sellX, sellY, sellZ = 14.22, 36.84, -264.06

local function teleportToSell()
    local character = Client.Character
    if not character then
        print("❌ No character!")
        return
    end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        print("❌ No HumanoidRootPart!")
        return
    end
    
    root.CFrame = CFrame.new(sellX, sellY, sellZ)
    print("✅ Teleported to sell location: " .. sellX .. ", " .. sellY .. ", " .. sellZ)
end

-- Walkspeed function
local function setWalkspeed(speed)
    local character = Client.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

-- =====================
-- CREATE BUTTONS (IN ORDER)
-- =====================

-- 1. Auto Fish Toggle
createToggle("Auto Fish", 1, function(state)
    _G.autoFishEnabled = state
    setupAutoFish(state)
    print("Auto Fish " .. (state and "ON" or "OFF"))
end)

-- 2. Instant Reel Toggle
createToggle("Instant Reel", 2, function(state)
    setupInstantReel(state)
    print("Instant Reel " .. (state and "ON" or "OFF"))
end)

-- 3. TP Sell Button (click only, same color as toggles)
createTPButton("TP Sell", 3, function()
    teleportToSell()
end)

-- 4. Anti-AFK Toggle
createToggle("Anti-AFK", 4, function(state)
    _G.antiAfkEnabled = state
    setupAntiAfk(state)
    print("Anti-AFK " .. (state and "ON" or "OFF"))
end)

-- 5. Walkspeed Slider (at the bottom)
createSlider("Walkspeed", 16, 120, 5, function(val)
    setWalkspeed(val)
    print("Walkspeed set to: " .. val)
end)

-- Cleanup connections on exit
game:BindToClose(function()
    if confirmConnection then
        confirmConnection:Disconnect()
    end
    if autoFishLoop then
        autoFishLoop:Disconnect()
    end
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
    end
end)

-- Starting message
print("✅ GUI loaded! 5 features ready - TP Sell is click only.")
