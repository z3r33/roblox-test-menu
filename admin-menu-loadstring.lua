-- Admin Test Menu for your own Roblox game/testing place.
-- This is a client-side test menu. For real game security, validate powers on the server.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminLoadstringMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(240, 210)
panel.Position = UDim2.fromOffset(24, 120)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
panel.BorderSizePixel = 0
panel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Test Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local state = {
	godmode = false,
	speed = false,
	jump = false,
}

local function getHumanoid()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:FindFirstChildOfClass("Humanoid")
end

local function applyGodmode()
	task.spawn(function()
		while state.godmode do
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.Health = humanoid.MaxHealth
			end
			task.wait(0.2)
		end
	end)
end

local function button(text, y, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, 34)
	b.Position = UDim2.fromOffset(10, y)
	b.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
	b.BorderSizePixel = 0
	b.Font = Enum.Font.GothamSemibold
	b.Text = text
	b.TextColor3 = Color3.fromRGB(10, 10, 10)
	b.TextSize = 15
	b.Parent = panel

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = b

	b.MouseButton1Click:Connect(callback)
	return b
end

button("Godmode: OFF", 55, function()
	state.godmode = not state.godmode
	local humanoid = getHumanoid()
	if humanoid and state.godmode then
		humanoid.Health = humanoid.MaxHealth
	end
	if state.godmode then
		applyGodmode()
	end
	panel:FindFirstChild("GodmodeButton").Text = state.godmode and "Godmode: ON" or "Godmode: OFF"
end).Name = "GodmodeButton"

button("Speed: OFF", 97, function()
	state.speed = not state.speed
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.WalkSpeed = state.speed and 40 or 16
	end
	panel:FindFirstChild("SpeedButton").Text = state.speed and "Speed: ON" or "Speed: OFF"
end).Name = "SpeedButton"

button("Jump: OFF", 139, function()
	state.jump = not state.jump
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.JumpPower = state.jump and 90 or 50
	end
	panel:FindFirstChild("JumpButton").Text = state.jump and "Jump: ON" or "Jump: OFF"
end).Name = "JumpButton"

button("Close", 181, function()
	screenGui:Destroy()
end)
