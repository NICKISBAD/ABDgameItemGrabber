-- Functions
function GrabItems()
	for i,obj in pairs(game.Workspace:GetDescendants()) do
		if obj:IsA("Tool") then
			local primarypart = obj:FindFirstChild("Cover") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildWhichIsA("Part") or obj:FindFirstChildWhichIsA("MeshPart")
			if primarypart.CFrame then
				primarypart.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
			elseif not primarypart.CFrame and primarypart.Position then
				primarypart.Position = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
            end
        end
    end
end

function TPtoItems()
	for i,obj in pairs(game.Workspace:GetDescendants()) do
		if obj:IsA("Tool") then
			local primarypart = obj:FindFirstChild("Cover") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildWhichIsA("Part") or obj:FindFirstChildWhichIsA("MeshPart")
			if primarypart.CFrame and not primarypart.Position then
				game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = primarypart.CFrame
				wait(.5)
			elseif not primarypart.CFrame and primarypart.Position then
				game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position = primarypart.Position
				wait(.5)
			end
		end
	end
end

-- Tables
local IgnoredItems = {}
local RareItems = {}

-- Toggles
local ItemGrabbing = false
local ItemTPing = false
local BlacklistApplied = false

-- Main GUI
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NICKISBAD/Nick-s-Modded-KAVO-Lib/main/Nick'sModdedKavoLib.lua"))()
local Window = Lib.CreateLib("ABD Game Item Grabber", "DarkTheme")
local Tab = Window:NewTab("Main GUI")
local Section1 = Tab:NewSection("Item Grabber")

Section1:NewToggle("Item Grabber", "Grabs all items in the map", function(value)
    ItemGrabbing = value
end)

spawn(function()
	game.RunService.RenderStepped:Connect(function()
		if ItemGrabbing and not BlacklistApplied then
			GrabItems()
		elseif ItemGrabbing and BlacklistApplied then
			for i,obj in pairs(game.Workspace:GetDescendants()) do
				if obj:IsA("Tool") and not table.find(IgnoredItems, obj.Name) then
					local primarypart = obj:FindFirstChild("Cover") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildWhichIsA("Part") or obj:FindFirstChildWhichIsA("MeshPart")
					if primarypart.CFrame then
						primarypart.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
					elseif not primarypart.CFrame and primarypart.Position then
						primarypart.Position = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
					end
				end
			end
		end
	end)
end)

local Section2 = Tab:NewSection("Item TPer")

Section2:NewToggle("Item TPer", "Tps to all items in the map", function(value)
    ItemTPing = value
end)

spawn(function()
	game.RunService.RenderStepped:Connect(function()
		if ItemTPing and not BlacklistApplied then
			TptoItems()
		elseif ItemTPing and BlacklistApplied then
			for i,obj in pairs(game.Workspace:GetDescendants()) do
				if obj:IsA("Tool") and not table.find(IgnoredItems, obj.Name) then
					local primarypart = obj:FindFirstChild("Cover") or obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChildWhichIsA("Part") or obj:FindFirstChildWhichIsA("MeshPart")
					if primarypart.CFrame then
						game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = primarypart.CFrame
					elseif not primarypart.CFrame and primarypart.Position then
						game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position = primarypart.Position
					end
				end
			end
		end
	end)
end)

local Section3 = Tab:NewSection("--Settings--")

Section3:NewTextBox("Blacklist Items", "Adds an Item to blacklist for itemtping/itemgrabbing", function(value)
	table.insert(IgnoredItems, value)
end)

Section3:NewTextBox("Remove Blacklist Items", "Removes an Item to blacklist for itemtping/itemgrabbing", function(value)
	if IgnoredItems[value] then
		table.remove(IgnoredItems, value)
	elseif not IgnoredItems[value] then
		game.StarterGui:SetCore("SendNotification",{
			Title = "Error",
			Text = value .. " was not found in blacklisted items!",
			Duration = 5
		})
	end
end)

local BlacklistedItemsLabel = Section3:NewLabel("BlacklistedItems: ")

spawn(function()
	while wait() do
		for _,v in ipairs(IgnoredItems) do
			BlacklistedItemsLabel:UpdateLabel("BlacklistedItems: " .. v)
		end
	end
end)

Section3:NewToggle("Blacklisting Active", "Activates/Deactivates item blacklist", function(v)
	IgnoredItems = v
end)
