local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local scriptActive = false

-- UI Erstellung (wie gehabt)
local screenGui = Instance.new("ScreenGui", pGui)
screenGui.Name = "DeltaQuestFix"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
actionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local btnText = Instance.new("TextLabel", actionFrame)
btnText.Size = UDim2.new(1, 0, 1, 0)
btnText.BackgroundTransparency = 1
btnText.Text = "START"
btnText.TextColor3 = Color3.new(1, 1, 1)
btnText.Font = Enum.Font.GothamBold

--- HELFER FUNKTIONEN ---

local function safeClick(guiElement)
    if guiElement and guiElement.Visible then
        -- Versuche erst getconnections (Delta spezial)
        local success, err = pcall(function()
            local cons = getconnections(guiElement.MouseButton1Click)
            if #cons > 0 then
                for _, v in pairs(cons) do v:Fire() end
            else
                -- Fallback auf VIM
                local x = guiElement.AbsolutePosition.X + (guiElement.AbsoluteSize.X / 2)
                local y = guiElement.AbsolutePosition.Y + (guiElement.AbsoluteSize.Y / 2) + 58
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
            end
        end)
    end
end

local function handleQuestUI()
    -- Diese Schleife klickt 5 mal, wie gewünscht
    for i = 1, 5 do
        if not scriptActive then break end
        
        local questUI = pGui:FindFirstChild("Quests") and pGui.Quests:FindFirstChild("QuestUI")
        if questUI then
            local continueBtn = questUI:FindFirstChild("Continue")
            local respondBtn = questUI:FindFirstChild("Responds") and questUI.Responds:FindFirstChild("QuestRespond")
            
            if continueBtn and continueBtn.Visible then
                safeClick(continueBtn)
            end
            task.wait(1)
            if respondBtn and respondBtn.Visible then
                safeClick(respondBtn)
            end
        end
        task.wait(1)
    end
end

local function runMainScript()
    while scriptActive do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            -- SCHRITT 1: Genshiro Quest
            root.CFrame = CFrame.new(-1735.23, 37.5, -2606.96)
            task.wait(1.5) -- Kurz warten bis NPC geladen
            
            local genshiro = workspace.QuestNPCs:FindFirstChild("Genshiro")
            if genshiro and genshiro:FindFirstChild("HumanoidRootPart") then
                fireproximityprompt(genshiro.HumanoidRootPart:FindFirstChild("Main Quest"))
                task.wait(1)
                handleQuestUI() -- Die 5 Klicks
            end
            
            task.wait(2) -- Pause zwischen den Quests

            -- SCHRITT 2: Hina Quest
            root.CFrame = CFrame.new(-1552.25, 4.38, -2796.72)
            task.wait(1.5)
            
            local hina = workspace.QuestNPCs:FindFirstChild("Hina")
            if hina and hina:FindFirstChild("HumanoidRootPart") then
                fireproximityprompt(hina.HumanoidRootPart:FindFirstChild("Main Quest"))
                task.wait(1)
                handleQuestUI() -- Die 5 Klicks
            end
        end
        task.wait(1)
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
