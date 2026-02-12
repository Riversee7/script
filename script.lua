local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local scriptActive = false

-- UI Setup (Identisch zu deiner Anforderung)
local screenGui = Instance.new("ScreenGui", pGui)
screenGui.Name = "DeltaQuestUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true -- Delta unterstützt Draggable meistens nativ

local corner = Instance.new("UICorner", mainFrame)

-- Status Box (Rot = Aus, Grün = An)
local statusBox = Instance.new("Frame", mainFrame)
statusBox.Size = UDim2.new(0, 15, 0, 15)
statusBox.Position = UDim2.new(0.85, 0, 0.1, 0)
statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", statusBox).CornerRadius = UDim.new(1, 0)

-- Start/Stop Frame (Dein Button-Ersatz)
local actionFrame = Instance.new("Frame", mainFrame)
actionFrame.Size = UDim2.new(0.8, 0, 0, 40)
actionFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
actionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local btnText = Instance.new("TextLabel", actionFrame)
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.BackgroundTransparency = 1
btnText.Text = "START"
btnText.TextColor3 = Color3.new(1, 1, 1)
btnText.Font = Enum.Font.GothamBold

--- FUNKTIONEN ---

-- Diese Funktion simuliert einen echten Klick auf Delta
local function deltaClick(guiElement)
    if not guiElement or not guiElement.Visible then return end
    
    -- Weg 1: Direktes Feuern der Verbindung (Beste Methode für Delta)
    local connections = getconnections(guiElement.MouseButton1Click)
    if #connections > 0 then
        for _, con in pairs(connections) do
            con:Fire()
        end
    else
        -- Weg 2: VirtualInputManager als Backup mit exakten Koordinaten
        local x = guiElement.AbsolutePosition.X + (guiElement.AbsoluteSize.X / 2)
        local y = guiElement.AbsolutePosition.Y + (guiElement.AbsoluteSize.Y / 2) + 58 -- Topbar Offset
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end
end

local function startLoop()
    while scriptActive do
        -- 1. Genshiro
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-1735.23, 37.5, -2606.96)
            task.wait(1)
            fireproximityprompt(workspace.QuestNPCs.Genshiro.HumanoidRootPart["Main Quest"])
            task.wait(1)
        end

        -- 5x Quest Klicks
        for i = 1, 5 do
            if not scriptActive then break end
            pcall(function()
                local qUI = pGui.Quests.QuestUI
                deltaClick(qUI.Continue)
                task.wait(1)
                deltaClick(qUI.Responds.QuestRespond)
            end)
            task.wait(1)
        end

        -- 2. Hina
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(-1552.25, 4.38, -2796.72)
            task.wait(1)
            fireproximityprompt(workspace.QuestNPCs.Hina.HumanoidRootPart["Main Quest"])
            task.wait(1)
        end
        task.wait(1)
    end
end

-- Input Event für den Frame
actionFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        scriptActive = not scriptActive
        
        if scriptActive then
            statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            btnText.Text = "STOP"
            task.spawn(startLoop)
        else
            statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            btnText.Text = "START"
        end
    end
end)
