local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- Status Variable
local scriptActive = false

-- UI Erstellung
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomQuestGui"
screenGui.Parent = pGui
screenGui.ResetOnSpawn = false

-- Hauptfenster (Beweglich)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Einfache Methode für Beweglichkeit
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Quest Automator"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Status Licht (Indikator)
local statusLight = Instance.new("Frame")
statusLight.Size = UDim2.new(0, 20, 0, 20)
statusLight.Position = UDim2.new(0.85, 0, 0.1, 0)
statusLight.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Startet Rot (Aus)
statusLight.Parent = mainFrame

local lightCorner = Instance.new("UICorner")
lightCorner.CornerRadius = UDim.new(1, 0)
lightCorner.Parent = statusLight

-- Der "Button" Frame
local startFrame = Instance.new("Frame")
startFrame.Name = "StartButton"
startFrame.Size = UDim2.new(0.8, 0, 0, 50)
startFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
startFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
startFrame.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = startFrame

local btnText = Instance.new("TextLabel")
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.BackgroundTransparency = 1
btnText.Text = "START"
btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
btnText.Font = Enum.Font.GothamSemibold
btnText.TextSize = 16
btnText.Parent = startFrame

--- FUNKTIONEN ---

local function simulateClick(uiElement)
    if uiElement and uiElement:IsA("GuiObject") then
        local x = uiElement.AbsolutePosition.X + (uiElement.AbsoluteSize.X / 2)
        local y = uiElement.AbsolutePosition.Y + (uiElement.AbsoluteSize.Y / 2) + 36 -- Offset für Roblox Topbar
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end
end

local function runQuestLoop()
    while scriptActive do
        -- 1. Genshiro Quest
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-1735.23, 37.5, -2606.96)
            task.wait(1)
            fireproximityprompt(workspace.QuestNPCs.Genshiro.HumanoidRootPart["Main Quest"])
            task.wait(1)
        end

        -- 2. Quest UI Klicks (5 mal)
        for i = 1, 5 do
            if not scriptActive then break end
            local continueBtn = pGui.Quests.QuestUI.Continue
            local respondBtn = pGui.Quests.QuestUI.Responds.QuestRespond
            
            simulateClick(continueBtn)
            task.wait(1)
            simulateClick(respondBtn)
            task.wait(1)
        end

        -- 3. Hina Quest
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-1552.25, 4.38, -2796.72)
            task.wait(1)
            fireproximityprompt(workspace.QuestNPCs.Hina.HumanoidRootPart["Main Quest"])
            task.wait(1)
        end
        
        task.wait(1)
    end
end

-- Button Logik (Frame Interaction)
startFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        scriptActive = not scriptActive
        
        if scriptActive then
            -- Einschalten
            statusLight.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Grün
            btnText.Text = "STOP"
            startFrame.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
            task.spawn(runQuestLoop)
        else
            -- Ausschalten
            statusLight.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rot
            btnText.Text = "START"
            startFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end
end)
