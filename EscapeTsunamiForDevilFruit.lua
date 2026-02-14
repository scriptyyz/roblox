local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

local celestialCF = CFrame.new(5.30297709, -68.5009766, 2738.72485, -0.801761806, 7.7320067e-10, 0.597643673, 3.35634437e-11, 1, -1.2487219e-09, -0.597643673, -9.81118631e-10, -0.801761806)
local secretCF = CFrame.new(-2.54503226, -68.5009766, 2035.90503, -0.998539209, 1.07045324e-08, 0.0540315025, 1.24354944e-08, 1, 3.16999689e-08, -0.0540315025, 3.23255733e-08, -0.998539209)
local cosmicCF = CFrame.new(-12.2774057, -68.5009766, 1496.30371, -0.754017115, 1.57615094e-08, 0.656854808, 3.08174357e-08, 1, 1.13805427e-08, -0.656854808, 2.88237043e-08, -0.754017115)
local baseCF = CFrame.new(28.3152943, -61.2027321, 42.9576797, -0.999743819, -6.87211212e-08, 0.02263413, -6.70727687e-08, 1, 7.3585241e-08, -0.02263413, 7.20482589e-08, -0.999743819)
local autoWinCF = CFrame.new(-5.77818441, -60.9009705, 3017.97607, 0.999971867, 3.19098392e-09, 0.00749887573, -2.88872726e-09, 1, -4.03177545e-08, -0.00749887573, 4.02949567e-08, 0.999971867)

local AutoWinEnabled = false
local CollectMoneyEnabled = false

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 420)
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 420), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Escape Tsunami For Devil Fruits"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 8)

local function createSimpleButton(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggleButton(baseName, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = baseName .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and baseName .. ": ON" or baseName .. ": OFF"
        btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        callback(enabled)
    end)
end

createSimpleButton("Remove Tsunami", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:find("Tsunami") or v.Name:find("Water") then v:Destroy() end
    end
end)

createToggleButton("Collect Money", function(val)
    CollectMoneyEnabled = val
    task.spawn(function()
        while CollectMoneyEnabled do
            pcall(function()
                local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "CollectTouch" and v:IsA("BasePart") then
                        firetouchinterest(root, v, 0)
                        firetouchinterest(root, v, 1)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

createToggleButton("Auto Win", function(val)
    AutoWinEnabled = val
    task.spawn(function()
        while AutoWinEnabled do
            pcall(function()
                local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                if root and root.Position.Z < 500 then
                    root.CFrame = autoWinCF
                end
            end)
            task.wait(1)
        end
    end)
end)

local function createTP(txt, cf)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end)
end

createTP("TP Celestial", celestialCF)
createTP("TP Secret", secretCF)
createTP("TP Cosmic", cosmicCF)
createTP("TP Base", baseCF)

local sliderFrame = Instance.new("Frame", Container)
sliderFrame.Size = UDim2.new(1, 0, 0, 35)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

local label = Instance.new("TextLabel", sliderFrame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "Walkspeed: 16"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.TextSize = 14
label.ZIndex = 2

local fill = Instance.new("Frame", sliderFrame)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)

sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
            local percent = math.clamp((mousePos - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(16 + (484) * percent)
            label.Text = "Walkspeed: " .. val
            if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
            end
            if input.UserInputState == Enum.UserInputState.End then connection:Disconnect() end
        end)
    end
end)
