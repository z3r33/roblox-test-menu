	updateToggle(speedButton, "Speed", state.speed)
	setStatus("WalkSpeed = " .. (state.speed and "40" or "16"))
end)

jumpButton = makeButton("JumpLeft", "Jump: OFF", 48, function()
	state.jump = not state.jump
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.JumpPower = state.jump and 90 or 50
	end
	updateToggle(jumpButton, "Jump", state.jump)
	setStatus("JumpPower = " .. (state.jump and "90" or "50"))
end)

noclipButton = makeButton("NoclipRight", "Noclip: OFF", 48, function()
	state.noclip = not state.noclip
	updateToggle(noclipButton, "Noclip", state.noclip)
	setStatus("Noclip " .. (state.noclip and "active" or "desactive"))
end)

espButton = makeButton("EspLeft", "ESP: OFF", 96, function()
	state.esp = not state.esp
	updateToggle(espButton, "ESP", state.esp)
	refreshEsp()
	setStatus("ESP " .. (state.esp and "active" or "desactive"))
end)

brightButton = makeButton("BrightRight", "Fullbright: OFF", 96, function()
	state.fullbright = not state.fullbright
	updateToggle(brightButton, "Fullbright", state.fullbright)
	setStatus("Fullbright " .. (state.fullbright and "active" or "desactive"))
end)

makeButton("HealLeft", "Heal", 144, function()
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.Health = humanoid.MaxHealth
	end
	setStatus("Vie remise au maximum")
end)

makeButton("ResetRight", "Reset", 144, function()
	state.godmode = false
	state.speed = false
	state.jump = false
	state.noclip = false
	state.esp = false
	state.fullbright = false

	local humanoid = getHumanoid()
	if humanoid then
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
	end

	clearEsp()
	updateToggle(godButton, "Godmode", false)
	updateToggle(speedButton, "Speed", false)
	updateToggle(jumpButton, "Jump", false)
	updateToggle(noclipButton, "Noclip", false)
	updateToggle(espButton, "ESP", false)
	updateToggle(brightButton, "Fullbright", false)
	setStatus("Options reset")
end)

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPosition = panel.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

closeButton.MouseButton1Click:Connect(function()
	setOpen(false)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.K then
		setOpen(not state.open)
	end
end)

table.insert(connections, RunService.Heartbeat:Connect(function()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid and state.godmode and humanoid.Health < humanoid.MaxHealth then
		humanoid.Health = humanoid.MaxHealth
	end

	if character and state.noclip then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end

	if state.fullbright then
		game:GetService("Lighting").Brightness = 3
		game:GetService("Lighting").ClockTime = 14
		game:GetService("Lighting").FogEnd = 100000
	end
end))

Players.PlayerAdded:Connect(function(target)
	target.CharacterAdded:Connect(function()
		task.wait(1)
		if state.esp then
			refreshEsp()
		end
	end)
end)

Players.PlayerRemoving:Connect(function(target)
	if espObjects[target] then
		for _, object in ipairs(espObjects[target]) do
			object:Destroy()
		end
		espObjects[target] = nil
	end
end)

for _, target in ipairs(Players:GetPlayers()) do
	target.CharacterAdded:Connect(function()
		task.wait(1)
		if state.esp then
			refreshEsp()
		end
	end)
end
