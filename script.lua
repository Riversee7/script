local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local scriptActive = false

-- UI Erstellung
local screenGui = Instance.new("ScreenGui", pGui)
screenGui.Name = "DeltaQuestAutoV3"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true 
Instance.new("UICorner", mainFrame)

local statusBox = Instance.new("Frame", mainFrame)
statusBox.Size = UDim2.new(0, 15, 0, 15)
statusBox.Position = UDim2.new(0.85, 0, 0.1, 0)
statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", statusBox).CornerRadius = UDim.new(1, 0)

local actionFrame = Instance.new("Frame", mainFrame)
actionFrame.Size = UDim2.new(0.8, 0, 0, 40)
actionFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
actionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", actionFrame)

local btnText = Instance.new("TextLabel", actionFrame)
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.BackgroundTransparency = 1
btnText.Text = "START"
btnText.TextColor3 = Color3.new(1, 1, 1)
btnText.Font = Enum.Font.GothamBold

--- FUNKTIONEN ---

local function deltaClick(guiElement)
    if guiElement and guiElement.Visible then
        local connections = getconnections(guiElement.MouseButton1Click)
        if #connections > 0 then
            for _, v in pairs(connections) do v:Fire() end
        else
            local x = guiElement.AbsolutePosition.X + (guiElement.AbsoluteSize.X / 2)
            local y = guiElement.AbsolutePosition.Y + (guiElement.AbsoluteSize.Y / 2) + 58
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
        end
        return true
    end
    return false
end

-- Diese Funktion klickt nur, solange die GUI auch wirklich offen ist
local function handleQuestUI()
    for i = 1, 5 do
        if not scriptActive then break end
        
        local questUI = pGui:FindFirstChild("Quests") and pGui.Quests:FindFirstChild("QuestUI")
        
        -- Wenn die Haupt-GUI gar nicht mehr sichtbar ist, brechen wir die 5er-Schleife ab!
        if not questUI or questUI.Visible == false then
            print("Quest GUI geschlossen, gehe zum nächsten Schritt.")
            break 
        end

        local continueBtn = questUI:FindFirstChild("Continue")
        local respondBtn = questUI:FindFirstChild("Responds") and questUI.Responds:FindFirstChild("QuestRespond")
        
        local clicked = false
        if continueBtn and continueBtn.Visible then
            deltaClick(continueBtn)
            clicked = true
        end
        
        task.wait(1)
        
        if respondBtn and respondBtn.Visible then
            deltaClick(respondBtn)
            clicked = true
        end

        -- Falls kein Button sichtbar war, beende die Schleife vorzeitig
        if not clicked and i > 1 then break end
        
        task.wait(1)
    end
end

local function runMainScript()
    while scriptActive do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- 1. GENSHIRO
            print("Teleport zu Genshiro")
            root.CFrame = CFrame.new(-1735.232, 37.499, -2606.96)
            task.wait(1.5)
            
            local genshiro = workspace.QuestNPCs:FindFirstChild("Genshiro")
            if genshiro then
                fireproximityprompt(genshiro.HumanoidRootPart["Main Quest"])
                task.wait(1.5)
                handleQuestUI() -- Klickt max. 5 mal oder bis GUI weg ist
            end
            
            task.wait(1)
            if not scriptActive then break end

            -- 2. HINA
            print("Teleport zu Hina")
            root.CFrame = CFrame.new(-1552.253, 4.378, -2796.724)
            task.wait(1.5)
            
            local hina = workspace.QuestNPCs:FindFirstChild("Hina")
            if hina then
                fireproximityprompt(hina.HumanoidRootPart["Main Quest"])
                task.wait(1.5)
                handleQuestUI()
            end
        end
        task.wait(2) -- Kurze Pause vor dem nächsten Durchlauf
    end
end

-- Button Logik
actionFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        scriptActive = not scriptActive
        if scriptActive then
            statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            btnText.Text = "STOP"
            task.spawn(runMainScript)
        else
            statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            btnText.Text = "START"
        end
    end
end)
