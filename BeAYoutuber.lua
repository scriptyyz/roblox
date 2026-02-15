-- SPEED ESCAPE FOR BRAINROTS - COMPACT VERSION [2026-02-15]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI SETUP (REDUCED SIZE TO REMOVE EXTRA SPACE)
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 360) -- Smanjeno sa 450 na 360
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Youtube: Scriptyyz"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.BackgroundTransparency = 1 
MinimizeBtn.Text = "▼"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Be a Youtuber"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -75)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto resize canvas
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(txt, order, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 32) -- Malo tanji dugmići da uštedimo prostor
    btn.LayoutOrder = order
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- VARIABLES
_G.AutoCollect = false
_G.AutoUpload = false
_G.AutoClaim = false
_G.AutoRebirth = false
_G.AutoUpgrades = false
_G.AutoBuy = false
_G.SelectedYoutuber = ""

local player = game.Players.LocalPlayer
local events = game:GetService("ReplicatedStorage"):WaitForChild("events")

-- FEATURES IN ORDER
createButton("Auto Collect: OFF", 1, function(btn) 
    _G.AutoCollect = not _G.AutoCollect 
    btn.Text = _G.AutoCollect and "Auto Collect: ON" or "Auto Collect: OFF" 
    if _G.AutoCollect then task.spawn(function() while _G.AutoCollect do for _, p in pairs(workspace.Plots:GetChildren()) do local builds = p:FindFirstChild("Builds") if builds then for _, item in pairs(builds:GetDescendants()) do if _G.AutoCollect and item:IsA("TouchTransmitter") then local part = item.Parent if part and part:IsA("BasePart") then firetouchinterest(player.Character.HumanoidRootPart, part, 0) task.wait(0.05) firetouchinterest(player.Character.HumanoidRootPart, part, 1) end end end end end task.wait(0.8) end end) end 
end)

createButton("Auto Upload: OFF", 2, function(btn) 
    _G.AutoUpload = not _G.AutoUpload 
    btn.Text = _G.AutoUpload and "Auto Upload: ON" or "Auto Upload: OFF" 
    if _G.AutoUpload then task.spawn(function() while _G.AutoUpload do pcall(function() events.uploadAll:FireServer() end) task.wait(3) end end) end 
end)

createButton("Auto Claim: OFF", 3, function(btn) 
    _G.AutoClaim = not _G.AutoClaim 
    btn.Text = _G.AutoClaim and "Auto Claim: ON" or "Auto Claim: OFF" 
    if _G.AutoClaim then task.spawn(function() while _G.AutoClaim do pcall(function() events.claimAll:FireServer() end) task.wait(3) end end) end 
end)

createButton("Auto Rebirth: OFF", 4, function(btn) 
    _G.AutoRebirth = not _G.AutoRebirth 
    btn.Text = _G.AutoRebirth and "Auto Rebirth: ON" or "Auto Rebirth: OFF" 
    if _G.AutoRebirth then task.spawn(function() while _G.AutoRebirth do pcall(function() events.rebirth:FireServer() end) task.wait(5) end end) end 
end)

local upgradeList = {"views", "luck", "viralChance", "rebirthButtons", "uploadTime"}
createButton("Auto Upgrades: OFF", 5, function(btn) 
    _G.AutoUpgrades = not _G.AutoUpgrades 
    btn.Text = _G.AutoUpgrades and "Auto Upgrades: ON" or "Auto Upgrades: OFF" 
    if _G.AutoUpgrades then task.spawn(function() while _G.AutoUpgrades do for _, upg in pairs(upgradeList) do if not _G.AutoUpgrades then break end pcall(function() events.buyUpgrade:FireServer(upg) end) task.wait(1) end task.wait(5) end end) end 
end)

createButton("Auto Buy: OFF", 6, function(btn)
    _G.AutoBuy = not _G.AutoBuy
    btn.Text = _G.AutoBuy and "Auto Buy: ON" or "Auto Buy: OFF"
    if _G.AutoBuy then task.spawn(function() while _G.AutoBuy do if _G.SelectedYoutuber ~= "" then pcall(function() events.buyYoutuber:FireServer(_G.SelectedYoutuber) end) end task.wait(2) end end) end
end)

-- INPUT BOX (DIRECTLY BELOW AUTO BUY)
local Input = Instance.new("TextBox", Container)
Input.LayoutOrder = 7
Input.Size = UDim2.new(1, 0, 0, 32)
Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Input.PlaceholderText = "Enter Youtuber ID..."
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.GothamBold
Input.TextSize = 13
Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 8)

Input.Changed:Connect(function()
    _G.SelectedYoutuber = Input.Text
end)

-- MINIMIZE
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 360), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)
