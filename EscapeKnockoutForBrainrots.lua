local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Pozicije i mete
local HOME = CFrame.new(359.73, 212.41, -443.08)
local TARGETS = {
    ["Six Seven"] = true,
    ["Strawberry Elephant"] = true,
    ["La Grande Combinasion"] = true
}

-- Varijable za auto farm
local autoFarming = false
local autoFarmLoop = nil

-- UI Setup (Tvoj template)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI Setup
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.Name = "AutoFarmGUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 120) -- Visina za jedan feature
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 250, 0, 45) or UDim2.new(0, 250, 0, 120), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Escape Knockout For Brainrots" -- Izmenjeno po tvom zahtevu
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
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

--- FUNKCIJE ZA AUTO FARM ---

-- Interakcija sa promptom
local function interact(p)
    p.HoldDuration = 0
    fireproximityprompt(p)
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Glavna auto farm funkcija
local function startAutoFarm()
    autoFarmLoop = task.spawn(function()
        while autoFarming do
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")

            if root and hum and hum.Health > 0 then
                local folder = Workspace:FindFirstChild("SpawnedItems")
                if folder then
                    for _, item in pairs(folder:GetChildren()) do
                        if TARGETS[item.Name] then
                            local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            local part = item:FindFirstChildWhichIsA("BasePart")

                            if p and part then
                                root.CFrame = part.CFrame * CFrame.new(0, 15, 0)
                                task.wait(0.5)
                                interact(p)
                                root.CFrame = HOME
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
            task.wait(1)
        end
    end)
end

-- Zaustavi auto farm
local function stopAutoFarm()
    if autoFarmLoop then
        task.cancel(autoFarmLoop)
        autoFarmLoop = nil
    end
end

--- KREIRANJE FEATURE-A ---

-- Auto Farm Toggle (Feature se zove "Auto Farm")
local autoFarmBtn = Instance.new("TextButton", Container)
autoFarmBtn.Size = UDim2.new(1, 0, 0, 45) -- Malo veci dugme za jedan feature
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
autoFarmBtn.Text = "AUTO FARM: OFF"
autoFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmBtn.Font = Enum.Font.GothamBold
autoFarmBtn.TextSize = 16
Instance.new("UICorner", autoFarmBtn).CornerRadius = UDim.new(0, 8)

autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarming = not autoFarming

    if autoFarming then
        autoFarmBtn.Text = "AUTO FARM: ON"
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Zeleno
        startAutoFarm()
    else
        autoFarmBtn.Text = "AUTO FARM: OFF"
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Tamno siva
        stopAutoFarm()
    end
end)
