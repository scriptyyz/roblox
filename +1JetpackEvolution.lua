-- Youtube: Scriptyyz
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
MainFrame.Size = UDim2.new(0, 200, 0, 120)
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 200, 0, 45) or UDim2.new(0, 200, 0, 120), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "+1 Jetpack Evolution"
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

--- AUTO WIN FEATURE ---
local player = game.Players.LocalPlayer
local autoWinEnabled = false
local WIN_CFRAME = CFrame.new(-6077, 52.5, -6033)

local function teleportToWin()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = WIN_CFRAME
    end
end

local function startAutoWin()
    while autoWinEnabled do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            teleportToWin()
            task.wait(1.2)
        else
            task.wait(0.5)
        end
    end
end

player.CharacterAdded:Connect(function(character)
    if autoWinEnabled then
        character:WaitForChild("HumanoidRootPart")
        task.wait(0.2)
        teleportToWin()
    end
end)

-- Auto Win Button
local autoWinBtn = Instance.new("TextButton", Container)
autoWinBtn.Size = UDim2.new(1, 0, 0, 35)
autoWinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
autoWinBtn.Text = "Auto Win: OFF"
autoWinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoWinBtn.Font = Enum.Font.GothamBold
autoWinBtn.TextSize = 14
Instance.new("UICorner", autoWinBtn).CornerRadius = UDim.new(0, 8)

autoWinBtn.MouseButton1Click:Connect(function()
    autoWinEnabled = not autoWinEnabled
    autoWinBtn.Text = autoWinEnabled and "Auto Win: ON" or "Auto Win: OFF"
    autoWinBtn.BackgroundColor3 = autoWinEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
    
    if autoWinEnabled then
        task.spawn(startAutoWin)
        task.wait(0.1)
        teleportToWin()
    end
end)
