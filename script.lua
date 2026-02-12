local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- VARIABLE FÜR DEN STATUS
local isRunning = false

-- ### GUI ERSTELLUNG ###
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QuestAutoGui"
screenGui.Parent = pGui

-- Hauptfenster
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Quest Automator"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Der "Button" (Frame)
local actionFrame = Instance.new("Frame")
actionFrame.Size = UDim2.new(0, 180, 0, 40)
actionFrame.Position = UDim2.new(0.5, -90, 0.5, -10)
actionFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
actionFrame.Parent = mainFrame

local buttonText = Instance.new("TextLabel")
buttonText.Size = UDim2.new(1, 0, 1, 0)
buttonText.Text = "START / STOP"
buttonText.TextColor3 = Color3.new(1, 1, 1)
buttonText.BackgroundTransparency = 1
buttonText.Parent = actionFrame

-- Status Licht (Box)
local statusBox = Instance.new("Frame")
statusBox.Size = UDim2.new(0, 20, 0, 20)
statusBox.Position = UDim2.new(0.5, -10, 0.8, 0)
statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Startet Grün (Aus)
statusBox.Parent = mainFrame

-- ### FUNKTIONEN ###

-- Dragging Logik (Beweglichkeit)
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

-- Hilfsfunktion für Virtual Klicks
local function virtualClick(guiObject)
	if guiObject and guiObject.Visible then
		local x = guiObject.AbsolutePosition.X + (guiObject.AbsoluteSize.X / 2)
		local y = guiObject.AbsolutePosition.Y + (guiObject.AbsoluteSize.Y / 2) + 36 -- Offset für Topbar
		VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
		task.wait(0.05)
		VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
	end
end

-- HAUPT LOGIK
local function startQuestLoop()
	while isRunning do
		-- 1. GENSHIRO QUEST
		player.Character.HumanoidRootPart.CFrame = CFrame.new(-1735.232, 37.499, -2606.960)
		task.wait(1)
		fireproximityprompt(workspace.QuestNPCs.Genshiro.HumanoidRootPart["Main Quest"])
		
		for i = 1, 5 do
			if not isRunning then break end
			virtualClick(pGui.Quests.QuestUI.Continue)
			task.wait(0.5)
		end
		for i = 1, 5 do
			if not isRunning then break end
			virtualClick(pGui.Quests.QuestUI.Responds.QuestRespond)
			task.wait(0.5)
		end

		-- 2. HINA QUEST
		if not isRunning then break end
		player.Character.HumanoidRootPart.CFrame = CFrame.new(-1552.253, 4.378, -2796.724)
		task.wait(1)
		fireproximityprompt(workspace.QuestNPCs.Hina.HumanoidRootPart["Main Quest"])

		for i = 1, 5 do
			if not isRunning then break end
			virtualClick(pGui.Quests.QuestUI.Continue)
			task.wait(0.5)
		end
		for i = 1, 5 do
			if not isRunning then break end
			virtualClick(pGui.Quests.QuestUI.Responds.QuestRespond)
			task.wait(0.5)
		end
		
		task.wait(1) -- Kurze Pause vor Neustart der Schleife
	end
end

-- Klick Event für den Frame-"Button"
actionFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isRunning = not isRunning
		
		if isRunning then
			statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rot (An)
			task.spawn(startQuestLoop)
		else
			statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Grün (Aus)
		end
	end
end)
