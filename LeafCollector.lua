-- CUSTOM UI FOR YOUTUBE: SCRIPTYYZ
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local invokeRemote = remotes and remotes:WaitForChild("LifecycleInvokeServerFunctionFunction", 5)

-- State Variables
local autoEnabled = false
local sessionKey = "Session::" .. player.UserId

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "SpeedEscapeBrainrotsGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 180) -- Smanjena visina (nema viška prostora)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 15)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Youtube: Scriptyyz" -- Na vrhu ide tvoje ime
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 180), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Leaf Collector" -- Na dnu samo ime igrice
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -85)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0 -- Sklonjen scrollbar radi lepšeg izgleda

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)

-- Pomocne Funkcije
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
        callback(btn)
    end)
    return btn
end

local function createSlider(txt, min, max, callback)
    local sliderBtn = Instance.new("Frame", Container)
    sliderBtn.Size = UDim2.new(1, 0, 0, 35)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", sliderBtn)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. min
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 2
    
    local fill = Instance.new("Frame", sliderBtn)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)
    
    local dragging = false
    local function move()
        local mousePos = UserInputService:GetMouseLocation().X
        local percent = math.clamp((mousePos - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        label.Text = txt .. ": " .. val
        callback(val)
    end
    sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true move() end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.RenderStepped:Connect(function() if dragging then move() end end)
end

-- LEAF COLLECTOR LOGIC
local function createSpamCoroutine()
    task.spawn(function()
        while autoEnabled do
            if not invokeRemote then break end
            pcall(function()
                invokeRemote:InvokeServer(sessionKey, "CollectLeafBatch", {})
            end)
            for i = 1, 15 do
                local fakeBatch = {}
                for j = 1, math.random(5, 10) do
                    table.insert(fakeBatch, math.random(1, 2000000))
                end
                pcall(function()
                    invokeRemote:InvokeServer(sessionKey, "CollectLeafBatch", fakeBatch)
                end)
            end
            task.wait(0.01)
        end
    end)
end

-- UI FEATURES
createButton("Auto Farm: OFF", function(self)
    autoEnabled = not autoEnabled
    if autoEnabled then
        self.Text = "Auto Farm: ON"
        self.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        for i = 1, 5 do
            createSpamCoroutine()
        end
    else
        self.Text = "Auto Farm: OFF"
        self.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

createSlider("WalkSpeed", 16, 250, function(v)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = v
    end
end)
