local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local isRunning = false

-- ### MODERN GUI SETUP ###
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernQuestGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = pGui

-- Hauptfenster (Main Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 160)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Titel Leiste
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Text = "QUEST MANAGER v2"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = mainFrame

-- Trennlinie
local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 1)
line.Position = UDim2.new(0.05, 0, 0, 35)
line.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
line.BorderSizePixel = 0
line.Parent = mainFrame

-- Der "Button" Frame
local actionButtonFrame = Instance.new("Frame")
actionButtonFrame.Size = UDim2.new(0, 200, 0, 45)
actionButtonFrame.Position = UDim2.new(0.5, -100, 0.5, -5)
actionButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
actionButtonFrame.BorderSizePixel = 0
actionButtonFrame.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = actionButtonFrame

local btnText = Instance.new("TextLabel")
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.Text = "TOGGLE SCRIPT"
btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
btnText.Font = Enum.Font.GothamSemibold
btnText.BackgroundTransparency = 1
btnText.Parent = actionButtonFrame

-- Status Licht (Box)
local statusIndicator = Instance.new("Frame")
statusIndicator.Size = UDim2.new(0, 12, 0, 12)
statusIndicator.Position = UDim2.new(0.5, -6, 0.85, 0)
statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 120) -- Start: Grün (Aus)
statusIndicator.BorderSizePixel = 0
statusIndicator.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0) -- Macht die Box rund für ein LED-Look
statusCorner.Parent = statusIndicator

-- ### LOGIK ###

-- Dragging Funktion
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Klick Simulation
local function simulateClick(target)
    if target and target.Visible then
        local pos = target.AbsolutePosition
        local size = target.AbsoluteSize
        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, true, game, 1)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, false, game, 1)
    end
end

-- Quest Ablauf
local function runQuests()
    while isRunning do
        -- GENSHIRO
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-1735.232, 37.499, -2606.960)
            task.wait(1)
            fireproximityprompt(workspace.QuestNPCs.Genshiro.HumanoidRootPart["Main Quest"])
            
            for i = 1, 5 do
                if not isRunning then break end
                simulateClick(pGui.Quests.QuestUI.Continue)
                task.wait(0.5)
            end
            for i = 1, 5 do
                if not isRunning then break end
                simulateClick(pGui.Quests.QuestUI.Responds.QuestRespond)
                task.wait(0.5)
            end
        end

        -- HINA
        if not isRunning then break end
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-1552.253, 4.378, -2796.724)
            task.wait(1)
            fireproximityprompt(workspace.QuestNPCs.Hina.HumanoidRootPart["Main Quest"])

            for i = 1, 5 do
                if not isRunning then break end
                simulateClick(pGui.Quests.QuestUI.Continue)
                task.wait(0.5)
            end
            for i = 1, 5 do
                if not isRunning then break end
                simulateClick(pGui.Quests.QuestUI.Responds.QuestRespond)
                task.wait(0.5)
            end
        end
        task.wait(2)
    end
end

-- Button Action
actionButtonFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isRunning = not isRunning
        
        if isRunning then
            statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Rot (Aktiv)
            actionButtonFrame.BackgroundColor3 = Color3.fromRGB(70, 60, 60)
            task.spawn(runQuests)
        else
            statusIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 120) -- Grün (Inaktiv)
            actionButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
    end
end)
