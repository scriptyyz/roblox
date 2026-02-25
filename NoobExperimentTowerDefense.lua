-- CUSTOM UI TEMPLATE: SCRIPTYYZ
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
MainFrame.Size = UDim2.new(0, 250, 0, 140) -- Smanjena visina za jedan feature
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 140), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Noob Experiment Tower Defense" -- Promenjen naziv igre
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- Automatski se prilagođava

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

--- FORM ELEMENT HELPERS ---

-- Dugme koje aktivira skriptu jednim klikom
local function createActionButton(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    -- Hover efekat
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Kratka vizuelna povratna informacija
        btn.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        
        -- Izvrši callback
        callback()
    end)
end

-- INF Coins dugme
createActionButton("INF Coins", function()
    local args = {
        "CoinTwo",
        {
            cooldown = 1,
            amount = math.huge
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("JoinReward_Claim"):FireServer(unpack(args))
    
    -- Opcioni notifikacija (možeš ukloniti ako ne želiš)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "INF Coins",
        Text = "Coins added successfully!",
        Duration = 2
    })
end)
