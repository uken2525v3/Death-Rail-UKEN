local HttpsService = game:GetService("HttpService")
local ScreenGui = Instance.new("ScreenGui")
local weldb = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

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

function randomName(Instanc)
	return HttpsService:GenerateGUID(false)
end
function currentDrag()
	local a = game:GetService("ReplicatedStorage").Client.Handlers.DraggableItemHandlers.ClientDraggableObjectHandler.DragHighlight.Adornee
	return a:GetAttribute("IsBeingDragged") and a or nil
end
function weld(item)
	if item then
		local args = {
			item,
			workspace:WaitForChild("default"):WaitForChild("Platform"):WaitForChild("Base"):WaitForChild("Base")
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("RequestWeld"):FireServer(unpack(args))
		repeat wait() until item.PrimaryPart:FindFirstChild("DragWeldConstraint")
		local count = 0
		for i,v in pairs(item:GetDescendants()) do
			if v:IsA("WeldConstraint") then
				count+=1
			end
		end
		if count >= 2 then
			local args = {
				item
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemoteEvent"):WaitForChild("RequestUnweld"):FireServer(unpack(args))
		end
	end
end
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
weldb.MouseButton1Click:Connect(function()
	local item = currentDrag()
	if item then
		weld(item)
	end
end)
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
