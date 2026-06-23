-- Pro Admin Test Menu for your own Roblox game/testing place.
-- Use it to test your anti-cheat. Keep real permissions and validation server-side.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local state = {
	open = true,
	godmode = false,
	speed = false,
	jump = false,
	noclip = false,
	esp = false,
	fullbright = false,
}

local connections = {}
local espObjects = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminLoadstringMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(330, 360)
panel.Position = UDim2.fromOffset(32, 120)
panel.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 78)
stroke.Thickness = 1
stroke.Parent = panel

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
header.BorderSizePixel = 0
header.Parent = panel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -86, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Admin Test Kit"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local hint = Instance.new("TextLabel")
hint.Size = UDim2.fromOffset(74, 1)
hint.Position = UDim2.new(1, -116, 0, 24)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.Gotham
hint.Text = "K toggle"
hint.TextColor3 = Color3.fromRGB(170, 170, 178)
hint.TextSize = 12
hint.TextXAlignment = Enum.TextXAlignment.Right
hint.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Name = "Close"
closeButton.Size = UDim2.fromOffset(34, 30)
closeButton.Position = UDim2.new(1, -42, 0, 9)
closeButton.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, -24, 1, -68)
body.Position = UDim2.fromOffset(12, 58)
body.BackgroundTransparency = 1
body.Parent = panel

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, 0, 0, 24)
status.Position = UDim2.new(0, 0, 1, -24)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Text = "Pret - menu de test local"
status.TextColor3 = Color3.fromRGB(185, 185, 194)
status.TextSize = 13
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = body

local function getHumanoid()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:FindFirstChildOfClass("Humanoid")
end

local function setStatus(text)
	status.Text = text
end

local function setOpen(open)
	state.open = open
	panel.Visible = open
end

local function makeButton(name, label, y, callback)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0.5, -6, 0, 38)
	button.Position = UDim2.fromOffset((name:find("Right") and 156 or 0), y)
	button.BackgroundColor3 = Color3.fromRGB(238, 238, 242)
	button.BorderSizePixel = 0
	button.Font = Enum.Font.GothamSemibold
	button.Text = label
	button.TextColor3 = Color3.fromRGB(14, 14, 16)
	button.TextSize = 14
	button.Parent = body

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button

	button.MouseButton1Click:Connect(callback)
	return button
end

local function updateToggle(button, label, enabled)
	button.Text = label .. ": " .. (enabled and "ON" or "OFF")
	button.BackgroundColor3 = enabled and Color3.fromRGB(125, 220, 150) or Color3.fromRGB(238, 238, 242)
end

local godButton
local speedButton
local jumpButton
local noclipButton
local espButton
local brightButton

local function clearEsp()
	for _, objects in pairs(espObjects) do
		for _, object in ipairs(objects) do
			if object then
				object:Destroy()
			end
		end
	end
	table.clear(espObjects)
end

local function addEspFor(target)
	if target == player or espObjects[target] then
		return
	end

	local character = target.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "AdminTestESP"
	highlight.FillColor = Color3.fromRGB(255, 70, 70)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.65
	highlight.OutlineTransparency = 0
	highlight.Adornee = character
	highlight.Parent = character

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "AdminTestName"
	billboard.Size = UDim2.fromOffset(160, 32)
	billboard.StudsOffset = Vector3.new(0, 3.2, 0)
