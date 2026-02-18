-- CUSTOM UI TEMPLATE: SCRIPTYYZ
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

_G.AutoFarm = false
_G.AutoBuyEgg = false
_G.SelectedEgg = "Basic Egg"
local MyCurrentPlot = nil

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- PRONALAŽENJE PLOTA
for _, plot in pairs(workspace.Plots:GetChildren()) do
    if plot:FindFirstChild("Box") and (root.Position - plot.Box:GetModelCFrame().Position).Magnitude < 100 then
        MyCurrentPlot = plot
        break
    end
end

-- GUI Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 280) -- Smanjen GUI da nema viška prostora
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 280), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "My Scamming Brainrots" -- Promenjeno po zahtevu
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

-- HELPERS
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

local function createDropdown(name, options)
    local dropBtn = Instance.new("TextButton", Container)
    dropBtn.Size = UDim2.new(1, 0, 0, 35)
    dropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropBtn.Text = name .. ": " .. _G.SelectedEgg
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.Font = Enum.Font.GothamBold
    dropBtn.TextSize = 14
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)
    
    local optFrame = Instance.new("Frame", Container)
    optFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    optFrame.Visible = false
    Instance.new("UIListLayout", optFrame)

    dropBtn.MouseButton1Click:Connect(function() optFrame.Visible = not optFrame.Visible end)

    for _, opt in pairs(options) do
        local oBtn = Instance.new("TextButton", optFrame)
        oBtn.Size = UDim2.new(1, 0, 0, 30)
        oBtn.Text = opt
        oBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        oBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        oBtn.MouseButton1Click:Connect(function()
            _G.SelectedEgg = opt
            dropBtn.Text = name .. ": " .. opt
            optFrame.Visible = false
        end)
    end
end

local function createSlider(txt, min, max, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 35)
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

-- REDOSLED FEATURA
createToggle("Auto Farm", function(v) _G.AutoFarm = v end)
createToggle("Auto Buy Egg", function(v) _G.AutoBuyEgg = v end)
createDropdown("Select Egg", {"Basic Egg", "Rare Egg", "ULTRA Rare Egg", "FrostBITE Egg", "Inferno Egg", "HELLFIRE Egg", "King Egg", "Obsidian Egg", "hAckeR_0101 eGg", "ERR_0R_01 Egg", "OP Lucky Egg", "legggion5"})
createSlider("Walkspeed", 16, 250, function(val) player.Character.Humanoid.WalkSpeed = val end)

-- LOGIKA: AUTO FARM
spawn(function()
    while true do
        if _G.AutoFarm and MyCurrentPlot then
            local b = MyCurrentPlot:FindFirstChild("Box")
            local s = MyCurrentPlot:FindFirstChild("Sell")
            if b and s then
                local bP = b:FindFirstChildWhichIsA("ProximityPrompt", true)
                local sP = s:FindFirstChildWhichIsA("ProximityPrompt", true)
                if bP and sP then
                    root.CFrame = b:GetModelCFrame()
                    task.wait(0.5)
                    fireproximityprompt(bP)
                    task.wait(0.4)
                    root.CFrame = sP.Parent.CFrame
                    task.wait(0.5)
                    fireproximityprompt(sP)
                    task.wait(0.4)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- LOGIKA: AUTO BUY EGG
spawn(function()
    while task.wait(0.01) do
        if _G.AutoBuyEgg and MyCurrentPlot then
            local eggsFolder = MyCurrentPlot:FindFirstChild("Conveyor") and MyCurrentPlot.Conveyor:FindFirstChild("Eggs")
            if eggsFolder then
                for _, egg in pairs(eggsFolder:GetChildren()) do
                    local eggNameLabel = egg:FindFirstChild("EggName", true)
                    if eggNameLabel and eggNameLabel.Text:lower():find(_G.SelectedEgg:lower()) then
                        local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            local oldPos = root.CFrame
                            while egg.Parent == eggsFolder and _G.AutoBuyEgg do
                                root.CFrame = egg:GetModelCFrame()
                                fireproximityprompt(prompt)
                                task.wait(0.05)
                            end
                            root.CFrame = oldPos
                            break
                        end
                    end
                end
            end
        end
    end
end)
