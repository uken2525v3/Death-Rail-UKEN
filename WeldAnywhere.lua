--[[

⚠️ FOR EDUCATIONAL PURPOSE ONLY; PLEASE DON'T USE THIS IN THE REAL GAME. ⚠️
	THIS SCRIPT HAS NOT BEEN TESTED FOR A LONG TIME, SO IT'S GONNA BE
	RISKY TO USE.

]]

--// Services //--
local HttpsService = game:GetService("HttpService")
local ScreenGui = Instance.new("ScreenGui")
local weldb = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

--// UserInterface //--
ScreenGui.Parent = game:FindFirstChild("CoreGui") and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

weldb.Name = "weldb"
weldb.Parent = ScreenGui
weldb.AnchorPoint = Vector2.new(0.5, 0.5)
weldb.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
weldb.BorderColor3 = Color3.fromRGB(0, 0, 0)
weldb.BorderSizePixel = 0
weldb.Position = UDim2.new(0.0767584145, 0, 0.593659818, 0)
weldb.Size = UDim2.new(0.0611620806, 0, 0.108843535, 0)
weldb.Font = Enum.Font.Highway
weldb.Text = "Weld"
weldb.TextColor3 = Color3.fromRGB(255, 255, 255)
weldb.TextScaled = true
weldb.TextSize = 14.000
weldb.TextStrokeTransparency = 0.000
weldb.TextWrapped = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = weldb

UIAspectRatioConstraint.Parent = weldb

--// Functions //--
function randomName(Instanc) -- Generate Unique Id, idk why.
	return HttpsService:GenerateGUID(false)
end
function currentDrag() -- Getting the current object that being dragging.
	local a = game:GetService("ReplicatedStorage").Client.Handlers.DraggableItemHandlers.ClientDraggableObjectHandler.DragHighlight.Adornee
	return a:GetAttribute("IsBeingDragged") and a or nil
end
function weld(item) -- Weld the object (Most important).
	if item then
		-- Sent infomation to weld with a part in a train.
		local args = {
			item,
			workspace:WaitForChild("default"):WaitForChild("Platform"):WaitForChild("Base"):WaitForChild("Base")
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("RequestWeld"):FireServer(unpack(args))

		-- Yielding until the server weld the object
		repeat wait() until item.PrimaryPart:FindFirstChild("DragWeldConstraint")

		-- Fixing weld stacking (In case the object has the WeldConstraint more than one). 
		-- Counting all class and add count when it detected WeldConstraint (Basically counting the WeldConstraint class).
		local count = 0
		for i,v in pairs(item:GetDescendants()) do
			if v:IsA("WeldConstraint") then
				count+=1
			end
		end

		-- If the WeldConstraint have more than one, it's gonna unwelding by sending unweld event to sever by RemoteEvent.
		if count >= 2 then
			local args = {
				item
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("RequestUnweld"):FireServer(unpack(args))
		end
	end
end

--// Key Pressing System
local UIS = game:GetService("UserInputService")
local Key = Enum.KeyCode.Z
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Key then
		local item = currentDrag()
		if item then
			weld(item)
		end
	end
end)

--// Button Clicking System
weldb.MouseButton1Click:Connect(function()
	local item = currentDrag()
	if item then
		weld(item)
	end
end)

--// Random Gui's name (Always make the gui name random. you can remove this line).
spawn(function()
	while wait() do
		ScreenGui.Name = randomName()
		if UIS.TouchEnabled then
			weldb.Visible = true
		else
			weldb.Visible = false
		end
	end
end)
