--// =========================
--// ANTI AFK
--// =========================

local VirtualUser = game:GetService("VirtualUser")
local plr = game.Players.LocalPlayer

plr.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


--// =========================
--// SETTINGS
--// =========================

local bossData = {

["Ogre Lord"] = Vector3.new(4563,255,6680),

["Monarch Statue"] = Vector3.new(7787, 263, 9251)

}

local selectedBoss = nil

local function getReturnPos()

return bossData[selectedBoss]

end


--// =========================
--// SERVICES
--// =========================

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")


--// =========================
--// VARIABLES
--// =========================

local farming = false
local menuOpen = true

local char, root


--// =========================
--// CHARACTER SYSTEM
--// =========================

local function setupChar(c)

char = c
root = c:WaitForChild("HumanoidRootPart")

if farming and selectedBoss then

task.wait(1)

root.CFrame = CFrame.new(getReturnPos())

end

end

setupChar(plr.Character or plr.CharacterAdded:Wait())

plr.CharacterAdded:Connect(setupChar)


--// =========================
--// GUI
--// =========================

local playerGui = plr:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui",playerGui)

gui.ResetOnSpawn = false


local frame = Instance.new("Frame", gui)

frame.Size = UDim2.new(0,240,0,180)
frame.Position = UDim2.new(0,100,0,100)

frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.3

frame.Active = true
frame.Draggable = true

Instance.new("UICorner",frame)


local title = Instance.new("TextLabel", frame)

title.Size = UDim2.new(1,0,0,30)
title.Text = "AUTO FARM BOSS"

title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

title.Font = Enum.Font.SourceSansBold
title.TextSize = 18


-- OGRE BUTTON

local ogreBtn = Instance.new("TextButton", frame)

ogreBtn.Size = UDim2.new(0,140,0,40)
ogreBtn.Position = UDim2.new(0,10,0,50)

ogreBtn.Text = "Ogre Lord"

ogreBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ogreBtn.BackgroundTransparency = 0.3

ogreBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",ogreBtn)


local ogreFarmBtn = Instance.new("TextButton", frame)

ogreFarmBtn.Size = UDim2.new(0,60,0,40)
ogreFarmBtn.Position = UDim2.new(0,170,0,50)

ogreFarmBtn.Text = "OFF"

Instance.new("UICorner",ogreFarmBtn)



-- MONARCH STATUE BUTTON

local monBtn = Instance.new("TextButton", frame)

monBtn.Size = UDim2.new(0,140,0,40)
monBtn.Position = UDim2.new(0,10,0,100)

monBtn.Text = "Monarch Statue"

monBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
monBtn.BackgroundTransparency = 0.3

monBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",monBtn)


local monFarmBtn = Instance.new("TextButton", frame)

monFarmBtn.Size = UDim2.new(0,60,0,40)
monFarmBtn.Position = UDim2.new(0,170,0,100)

monFarmBtn.Text = "OFF"

Instance.new("UICorner",monFarmBtn)



-- MENU BUTTON

local menuBtn = Instance.new("TextButton", gui)

menuBtn.Size = UDim2.new(0,70,0,30)
menuBtn.Position = UDim2.new(0,10,0,100)

menuBtn.Text = "MENU"

menuBtn.Active = true
menuBtn.Draggable = true

Instance.new("UICorner",menuBtn)



-- MENU TOGGLE

menuBtn.MouseButton1Click:Connect(function()

menuOpen = not menuOpen
frame.Visible = menuOpen

end)


UIS.InputBegan:Connect(function(input,gp)

if gp then return end

if input.KeyCode == Enum.KeyCode.LeftControl then

menuOpen = not menuOpen
frame.Visible = menuOpen

end

end)



-- FIND BOSS

local function getBoss()

for _,v in pairs(workspace:GetDescendants()) do

if v.Name == selectedBoss
and v:FindFirstChild("Humanoid")
and v:FindFirstChild("HumanoidRootPart")
and v.Humanoid.Health > 0 then

return v

end
end

end



-- COMBAT

local function skill(key)

VIM:SendKeyEvent(true,key,false,game)
task.wait(0.05)
VIM:SendKeyEvent(false,key,false,game)

end


local function attack()

VIM:SendMouseButtonEvent(0,0,0,true,game,0)
task.wait(0.03)
VIM:SendMouseButtonEvent(0,0,0,false,game,0)

end


local function combat()

skill("One")
skill("Two")
skill("Three")

attack()

end



-- FARM FUNCTION

local function startFarm(bossName, button)

button.MouseButton1Click:Connect(function()

farming = not farming

selectedBoss = bossName

button.Text = farming and "ON" or "OFF"


task.spawn(function()

while farming do

char = plr.Character
root = char and char:FindFirstChild("HumanoidRootPart")

if not root then task.wait(1) continue end


local boss = getBoss()


if boss then

root.CFrame =
boss.HumanoidRootPart.CFrame
* CFrame.new(0,0,3)

combat()

else

root.CFrame = CFrame.new(getReturnPos())

end


task.wait(0.1)

end

end)

end)

end



-- ENABLE BOTH BUTTONS

startFarm("Ogre Lord", ogreFarmBtn)

startFarm("Monarch Statue", monFarmBtn)
