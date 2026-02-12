local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- VARIABLEN FÜR DEN STATUS
local active = false
local scriptRunning = false

----------------------------------------------------------------
-- 1. GUI ERSTELLEN
----------------------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomActionGui"
screenGui.Parent = pGui

-- Hauptfenster (Beweglich)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true -- Ermöglicht das Bewegen
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Action Controller"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Der "Button" (Frame statt Button)
local startFrame = Instance.new("Frame")
startFrame.Name = "StartToggle"
startFrame.Size = UDim2.new(0, 150, 0, 40)
startFrame.Position = UDim2.new(0.5, -75, 0.4, 0)
startFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
startFrame.Parent = mainFrame

local startText = Instance.new("TextLabel")
startText.Size = UDim2.new(1, 0, 1, 0)
startText.Text = "START / STOP"
startText.TextColor3 = Color3.new(1, 1, 1)
startText.BackgroundTransparency = 1
startText.Parent = startFrame

-- Status Anzeige (Box)
local statusBox = Instance.new("Frame")
statusBox.Size = UDim2.new(0, 20, 0, 20)
statusBox.Position = UDim2.new(0.5, -10, 0.75, 0)
statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Startet Rot (Aus)
statusBox.Parent = mainFrame

----------------------------------------------------------------
-- 2. LOGIK FUNKTIONEN
----------------------------------------------------------------

local function simulateClick(guiObject)
	local x = guiObject.AbsolutePosition.X + (guiObject.AbsoluteSize.X / 2)
	local y = guiObject.AbsolutePosition.Y + (guiObject.AbsoluteSize.Y / 2)
	VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
	VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function runMainLoop()
	while active do
		-- 1. Teleport
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = CFrame.new(-1735.232, 37.5, -2606.961)
		end
		
		task.wait(1)
		
		-- 2. Proximity Prompt feuern
		local npcPart = workspace:FindFirstChild("QuestNPCs") and workspace.QuestNPCs.Genshiro.HumanoidRootPart:FindFirstChild("Main Quest")
		if npcPart then
			fireproximityprompt(npcPart)
		end
		
		-- 3. Continue Klicks (5 mal, 500ms)
		for i = 1, 5 do
			if not active then break end
			local continueBtn = pGui:FindFirstChild("Quests") and pGui.Quests.QuestUI:FindFirstChild("Continue")
			if continueBtn then
				simulateClick(continueBtn)
			end
			task.wait(0.5)
		end
		
		-- 4. Respond Klicks (5 mal, 500ms)
		for i = 1, 5 do
			if not active then break end
			local respondBtn = pGui:FindFirstChild("Quests") and pGui.Quests.QuestUI.Responds:FindFirstChild("QuestRespond")
			if respondBtn then
				simulateClick(respondBtn)
			end
			task.wait(0.5)
		end
		
		task.wait(1) -- Kurze Pause vor nächstem Durchlauf
	end
end

----------------------------------------------------------------
-- 3. CLICK EVENT (FRAME ALS BUTTON)
----------------------------------------------------------------

startFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		active = not active
		
		if active then
			statusBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Grün wenn AN
			print("Script gestartet")
			runMainLoop()
		else
			statusBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rot wenn AUS
			print("Script gestoppt")
		end
	end
end)
