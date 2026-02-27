-- CUSTOM UI TEMPLATE: SCRIPTYYZ
-- HUNTING SEASON - FINAL VERSION WITH PROPER MAGIC BULLET

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Gui Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 320, 0, 400)
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
    MainFrame:TweenSize(minimized and UDim2.new(0, 320, 0, 45) or UDim2.new(0, 320, 0, 400), "Out", "Quart", 0.3, true)
    Container.Visible = not minimized
    Footer.Visible = not minimized
    MinimizeBtn.Text = minimized and "▲" or "▼"
end)

Footer.Parent = MainFrame
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Hunting Season"
Footer.TextColor3 = Color3.fromRGB(200, 200, 200)
Footer.Font = Enum.Font.GothamBold
Footer.TextSize = 11

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 2, 0)

UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- =================================
-- ORIGINAL LOGIC FROM RAYFIELD SCRIPT
-- =================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local workspaceRef = workspace

-- variables
local ESPData, DeadESPData = {}, {}
local animalESPEnabled, deadAnimalESPEnabled = false, false
local magicBulletEnabled = false
local magicHitboxSize = 15
local magicTransparency = 0.7
local magicColor = Color3.fromRGB(255, 0, 0)
local magicFolder = "Animals"
local maxEspDistance = 1000

local targetSpeed = 16
local speedUpdateConnection = nil
local espColor = Color3.fromRGB(255, 200, 50)
local deadEspColor = Color3.fromRGB(255, 100, 100)
local selectedAnimals = {}
local useConstantSpeed = false
local animalTeleportList = {}

-- helpers
local function findRootPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _, child in ipairs(model:GetDescendants()) do
        if child:IsA("BasePart") then return child end
    end
    return nil
end

local function getBestPart(model)
    local part = model:FindFirstChild("HumanoidRootPart")
    if not part then part = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso") end
    if not part then part = model:FindFirstChild("Head") end
    if not part then
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("BasePart") then part = child break end
        end
    end
    return part
end

-- MAGIC BULLET - PROPER LOGIC FROM RAYFIELD
local function updateMagicHitboxes()
    if not magicBulletEnabled then return end

    local folder = Workspace:FindFirstChild(magicFolder)
    if not folder then return end

    for _, model in ipairs(folder:GetDescendants()) do
        if model:IsA("Model") then
            local targetPart = getBestPart(model)

            if targetPart then
                targetPart.Size = Vector3.new(magicHitboxSize, magicHitboxSize, magicHitboxSize)
                targetPart.Transparency = magicTransparency
                targetPart.Color = magicColor
                targetPart.Material = Enum.Material.ForceField
                
                targetPart.CanCollide = false
                targetPart.Massless = true
            end
        end
    end
end

-- ESP
local function createESPForModel(model, isDead)
    if not model or not model:IsA("Model") then return end
    local dataTable = isDead and DeadESPData or ESPData
    if dataTable[model] then return end

    if not isDead and next(selectedAnimals) ~= nil and not selectedAnimals[model.Name] then return end

    local rootPart = findRootPart(model)
    if not rootPart then return end

    local billGui = Instance.new("BillboardGui")
    billGui.Name = isDead and "DeadAnimalESPBillboard" or "AnimalESPBillboard"
    billGui.Adornee = rootPart
    billGui.Size = UDim2.new(0, 140, 0, 30)
    billGui.StudsOffset = Vector3.new(0, 2.5, 0)
    billGui.AlwaysOnTop = true
    billGui.ResetOnSpawn = false
    billGui.Parent = model

    local label = Instance.new("TextLabel")
    label.Name = "ESPLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = isDead and deadEspColor or espColor
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0.3
    label.Font = Enum.Font.GothamBold
    label.TextScaled = false
    label.TextSize = 14
    label.Text = ""
    label.Parent = billGui

    dataTable[model] = { billGui = billGui, label = label, part = rootPart }
end

local function destroyESPForModel(model, isDead)
    local dataTable = isDead and DeadESPData or ESPData
    local data = dataTable[model]
    if not data then return end
    if data.billGui and data.billGui.Parent then data.billGui:Destroy() end
    dataTable[model] = nil
end

local function updateESPForModel(model, data, isDead)
    if not data.part or not data.label or not data.billGui then return end
    if not model:IsDescendantOf(workspaceRef) then destroyESPForModel(model, isDead) return end

    local playerRoot = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Head"))
    if not playerRoot then data.billGui.Enabled = false return end

    local dist = math.floor((playerRoot.Position - data.part.Position).Magnitude)
    if dist > maxEspDistance then data.billGui.Enabled = false return end

    local worldPos = data.part.Position + Vector3.new(0, 2.5, 0)
    local camera = workspace.CurrentCamera
    local _, onScreen = camera:WorldToViewportPoint(worldPos)
    if not onScreen then data.billGui.Enabled = false return end

    local prefix = isDead and "[DEAD] " or ""
    data.label.Text = prefix .. model.Name .. " [" .. tostring(dist) .. "m]"
    data.billGui.Enabled = isDead and deadAnimalESPEnabled or animalESPEnabled
end

local function scanAndCreateESP(isDead)
    local folderName = isDead and "DeadAnimals" or "Animals"
    local folder = workspaceRef:FindFirstChild(folderName)
    if folder then
        for _, c in ipairs(folder:GetChildren()) do if c:IsA("Model") then createESPForModel(c, isDead) end end
        for _, c in ipairs(folder:GetDescendants()) do if c:IsA("Model") then createESPForModel(c, isDead) end end
    end
end

-- Teleport functions
local function teleportToPosition(pos)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- speed
local function applySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = targetSpeed end
end

local function startSpeedUpdater()
    if speedUpdateConnection then speedUpdateConnection:Disconnect() end
    if useConstantSpeed then
        speedUpdateConnection = RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= targetSpeed then hum.WalkSpeed = targetSpeed end
        end)
    end
end

local function onCharacterAdded(character)
    local hum = character:WaitForChild("Humanoid", 5)
    if not hum then return end
    hum.WalkSpeed = targetSpeed
    if useConstantSpeed then
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if hum.WalkSpeed ~= targetSpeed then hum.WalkSpeed = targetSpeed end
        end)
        hum.StateChanged:Connect(function() task.wait() hum.WalkSpeed = targetSpeed end)
    end
end

-- events
Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then task.spawn(function() onCharacterAdded(LocalPlayer.Character) end) end

RunService.Heartbeat:Connect(updateMagicHitboxes)

local lastESPUpdate = 0
RunService.Heartbeat:Connect(function()
    local currentTime = tick()
    if currentTime - lastESPUpdate >= 0.2 then
        lastESPUpdate = currentTime
        if animalESPEnabled then for m, d in pairs(ESPData) do updateESPForModel(m, d, false) end end
        if deadAnimalESPEnabled then for m, d in pairs(DeadESPData) do updateESPForModel(m, d, true) end end
    end
end)

-- bindings
local function onAnimalAdded(child, isDead)
    if child:IsA("Model") then
        local enabled = isDead and deadAnimalESPEnabled or animalESPEnabled
        if enabled then createESPForModel(child, isDead) end
    end
end

local function onAnimalRemoved(child, isDead)
    if child:IsA("Model") then destroyESPForModel(child, isDead) end
end

local function bindAnimalFolder(folder, isDead)
    folder.ChildAdded:Connect(function(ch) onAnimalAdded(ch, isDead) end)
    folder.DescendantAdded:Connect(function(desc) if desc:IsA("Model") then local enabled = isDead and deadAnimalESPEnabled or animalESPEnabled if enabled then createESPForModel(desc, isDead) end end end)
    folder.ChildRemoved:Connect(function(ch) onAnimalRemoved(ch, isDead) end)
    folder.DescendantRemoving:Connect(function(desc) if desc:IsA("Model") then destroyESPForModel(desc, isDead) end end)
end

local animalsFolder = workspaceRef:FindFirstChild("Animals")
local deadAnimalsFolder = workspaceRef:FindFirstChild("DeadAnimals")
if animalsFolder then bindAnimalFolder(animalsFolder, false) end
if deadAnimalsFolder then bindAnimalFolder(deadAnimalsFolder, true) end
workspaceRef.ChildAdded:Connect(function(ch)
    if ch:IsA("Folder") and ch.Name=="Animals" then bindAnimalFolder(ch,false) end
    if ch:IsA("Folder") and ch.Name=="DeadAnimals" then bindAnimalFolder(ch,true) end
end)

applySpeed()

-- =================================
-- UI FUNCTIONS
-- =================================

local function createSection(title)
    local section = Instance.new("TextLabel", Container)
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundTransparency = 1
    section.Text = title
    section.TextColor3 = Color3.fromRGB(200, 200, 200)
    section.Font = Enum.Font.GothamBold
    section.TextSize = 16
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.LayoutOrder = #Container:GetChildren() + 100
    return section
end

local function createToggle(txt, callback, defaultValue)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
    btn.Text = txt .. (defaultValue and ": ON" or ": OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = #Container:GetChildren() + 100
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local enabled = defaultValue or false
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
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = #Container:GetChildren() + 100
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
end

local function createSlider(txt, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame", Container)
    sliderFrame.Size = UDim2.new(1, 0, 0, 35)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.LayoutOrder = #Container:GetChildren() + 100
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = txt .. ": " .. defaultValue
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 2
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new((defaultValue-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
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

-- =================================
-- CREATE ALL OPTIONS
-- =================================

createToggle("Live Animal ESP", function(v)
    animalESPEnabled = v
    if not v then
        for m,_ in pairs(ESPData) do destroyESPForModel(m,false) end
    else
        scanAndCreateESP(false)
    end
end, false)

createToggle("Dead Animal ESP", function(v)
    deadAnimalESPEnabled = v
    if not v then
        for m,_ in pairs(DeadESPData) do destroyESPForModel(m,true) end
    else
        scanAndCreateESP(true)
    end
end, false)

createSlider("ESP Distance", 100, 5000, 1000, function(v)
    maxEspDistance = v
end)

createToggle("Magic Bullet", function(v)
    magicBulletEnabled = v
end, false)

createSlider("Hitbox Size", 1, 50, 15, function(v)
    magicHitboxSize = v
end)

createSlider("Speed", 1, 100, 16, function(v)
    targetSpeed = v
    useConstantSpeed = true
    startSpeedUpdater()
    applySpeed()
end)

createSection("TELEPORT LOCATIONS")

createButton("Sage Armory", function() teleportToPosition(Vector3.new(-1312.83, -522.89, -1239.84)) end)
createButton("Smolov's Guns and Ammo", function() teleportToPosition(Vector3.new(1461.17, -554.26, 2241.36)) end)
createButton("Pinewood", function() teleportToPosition(Vector3.new(-1262.16, -553.75, 1738.19)) end)
createButton("Sage Camping", function() teleportToPosition(Vector3.new(-1299.60, -524.24, -1206.62)) end)
createButton("Theodores Lodge", function() teleportToPosition(Vector3.new(2412.29, -369.75, -1028.58)) end)
createButton("Valentino", function() teleportToPosition(Vector3.new(1563.82, -553.75, 2214.23)) end)
createButton("Hunting Tower #1", function() teleportToPosition(Vector3.new(2170.05, -527.23, 1874.78)) end)
createButton("Hunting Tower #2", function() teleportToPosition(Vector3.new(994.57, -475.48, -426.43)) end)
createButton("Hunting Tower #3", function() teleportToPosition(Vector3.new(-361.78, -551.48, 1524.88)) end)
createButton("Hunting Tower #4", function() teleportToPosition(Vector3.new(169.32, -480.48, 566.80)) end)
createButton("Discover All Locations", function()
    local locs = {
        Vector3.new(-1262.16, -553.75, 1738.19),
        Vector3.new(-1299.60, -524.24, -1206.62),
        Vector3.new(2412.29, -369.75, -1028.58),
        Vector3.new(1563.82, -553.75, 2214.23)
    }
    for i, l in ipairs(locs) do task.spawn(function() task.wait(0.4*i) teleportToPosition(l) end) end
end)

createButton("Destroy GUI", function()
    for m,_ in pairs(ESPData) do destroyESPForModel(m,false) end
    for m,_ in pairs(DeadESPData) do destroyESPForModel(m,true) end
    if speedUpdateConnection then speedUpdateConnection:Disconnect() end
    ScreenGui:Destroy()
end)

-- Initial scan
task.wait(1)
scanAndCreateESP(false)
scanAndCreateESP(true)
