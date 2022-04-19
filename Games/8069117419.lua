if not game:IsLoaded() then game.Loaded:wait() end

-- anti afk
local vu = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- variables
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local chr = plr.Character
local wrk = game:GetService("Workspace")
local rep = game:GetService("ReplicatedStorage")
local rs = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager")
local plrHead = chr:WaitForChild("Head")

-- tables
local function getZones()
    local zones = {}
    for _,v in next, wrk.GhostPos:GetChildren() do
        if v:IsA("Folder") then
            table.insert(zones, v.Name)
        end
    end
    return zones
end 

-- my ass tween, but it's good enough
local function tweenTo(time, pos)
    game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear), {
        CFrame = pos.CFrame
    }):Play()
    task.wait(time)
end

local function teleportTo(pos)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos.CFrame
end

-- invite shit 
local function Invite()
    local req = syn.request or http_request or request or http.request or nil
    if req ~= nil then
        for port = 6463, 6472, 1 do
            local inv = 'http://127.0.0.1:' .. tostring(port) .. '/rpc?v=1'
            local http = game:GetService('HttpService')
            local t = {
                cmd = 'INVITE_BROWSER',
                args = {
                    ['code'] = 'JUEu7XFBXD'
                },
                nonce = string.lower(http:GenerateGUID(false))
            }
            local post = http:JSONEncode(t)
            req({
                Url = inv,
                Method = 'POST',
                Body = post,
                Headers = {
                    ['Content-Type'] = 'application/json',
                    ['Origin'] = 'https://discord.com'
                }
            })
        end
    end
end

-- this should work
local function getClosest()
    local closest = nil
    local distance = math.huge
    for _,v in next, wrk.GhostPos[Options.area.Value]:GetChildren() do
        if v:IsA("Part") and v:FindFirstChildWhichIsA("Model") then
            local dist = (v.Position - chr.HumanoidRootPart.Position).magnitude
            if dist < distance then
                distance = dist
                closest = v
            end
        end
    end
    return closest
end

-- works I think
local function getClosestChest()
    local closest = nil
    local distance = math.huge
    for _,v in next, wrk.ChestPoints:GetDescendants() do
        if v:FindFirstChildWhichIsA("Model") then
            local dist = (v.Position - chr.HumanoidRootPart.Position).magnitude
            if dist < distance then
                distance = dist
                closest = v
            end
        end
    end
    return closest
end


do -- ui 
    local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

    local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
    local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
    local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

    local Window = Library:CreateWindow({ Title = 'Unknown Hub', Center = true, AutoShow = true })

    local Tabs = {
        Main = Window:AddTab('Main'), 
        ['UI Settings'] = Window:AddTab('UI Settings'),
    }

    local lfFarm = Tabs.Main:AddLeftTabbox("Farm")
	local tFarm = lfFarm:AddTab('Farming')

    tFarm:AddDropdown('area', { Values = getZones(), Default = "---",  Multi = false, Text = 'Areas' })
    tFarm:AddToggle('auto_farm', { Text = 'Autofarm', Default = false })
    tFarm:AddToggle('auto_swing', { Text = 'Autoswing', Default = false })
    tFarm:AddToggle('auto_soul', { Text = 'Auto collect souls', Default = false })
    tFarm:AddDivider()
    tFarm:AddToggle('auto_chests', { Text = 'Auto collect chests', Default = false })
    tFarm:AddToggle('auto_boss', { Text = 'Auto boss', Default = false })

    local lfSkills = Tabs.Main:AddLeftTabbox("Skills")
	local tSkills = lfSkills:AddTab('Auto Skills')

    tSkills:AddToggle('auto_q', { Text = 'Auto use "Q" skill', Default = false })
    tSkills:AddToggle('auto_e', { Text = 'Auto use "E" skill', Default = false })
    tSkills:AddToggle('auto_r', { Text = 'Auto use "R" skill', Default = false })

    local rtMisc = Tabs.Main:AddRightTabbox("Misc")
	local tMisc = rtMisc:AddTab('Misc.')

    tMisc:AddToggle('auto_wheel', { Text = 'Auto spin wheel', Default = false })
    tMisc:AddButton('Redeem all codes', function()
        local codes = {'Welcome', 'thanks3000likes', '1000likes', 'adou6000likes', 'liangzai20klikes', 'demon', 'demonsoul'}
        for _, v in next, codes do
            game:GetService('ReplicatedStorage').RemoteEvents.Code:FireServer(v)
        end
    end)
    tMisc:AddButton('Teleport to boss room', function()
        teleportTo(wrk.Maps.BossHouse.BossSpawnPos["BossRoomPos_1"])
    end)
    tMisc:AddDivider()
    tMisc:AddSlider('draw_times', { Text = 'Draws', Default = 1, Min = 1, Max = 50, Rounding = 0, Compact = false })
    tMisc:AddButton('Draw roles', function()
        for i=1,tonumber(Options.draw_times.Value) do
            game:GetService('ReplicatedStorage').RemoteEvents.DrawRole:FireServer(true)
            wait(2)
        end
    end)

    local rtPLR = Tabs.Main:AddLeftTabbox('Local Player')
    local tPLR = rtPLR:AddTab('Local Player')

    tPLR:AddSlider('walkspeed', { Text = 'Walkspeed value', Default = 16, Min = 16, Max = 200, Rounding = 0, Compact = false })
    tPLR:AddSlider('jumppower', { Text = 'Jumppower value', Default = 50, Min = 50, Max = 200, Rounding = 0, Compact = false })


    local rtCredits = Tabs.Main:AddRightTabbox('Credits')
    local tCredits = rtCredits:AddTab('Credits')

    tCredits:AddLabel('Script: Trustsense#8185')
    tCredits:AddLabel('Hot library: wally#6588')

    local rtDisc = Tabs.Main:AddRightTabbox('Discord')
    local tDisc = rtDisc:AddTab('Discord')

    tDisc:AddButton('Copy discord invite', function()
        setclipboard('https://discord.gg/JUEu7XFBXD')
    end)
    local DiscButton = tDisc:AddButton('Open discord invite', function()
        Invite()
    end)
    DiscButton:AddTooltip('You need to have discord open.')

    -- UI Settings 
    local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
	MenuGroup:AddButton('Unload', function() Library:Unload() end)
	MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
	Library.ToggleKeybind = Options.MenuKeybind 
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
	ThemeManager:SetFolder('MyScriptHub')
	SaveManager:SetFolder('MyScriptHub/collectallpets!')
	SaveManager:BuildConfigSection(Tabs['UI Settings'])
	ThemeManager:ApplyToTab(Tabs['UI Settings'])

end

do -- loops
    rs.Stepped:connect(function()
        if Toggles.auto_farm.Value then
            tweenTo(0.1, getClosest())
        end
        if Toggles.auto_swing.Value then
            game:GetService("ReplicatedStorage").RemoteEvents.GeneralAttack:FireServer()
        end
        if Toggles.auto_soul.Value then
            for _,v in next, wrk.Souls:GetChildren() do
                if v:IsA("Part") then
                    v.CFrame = chr.HumanoidRootPart.CFrame
                end
            end
        end
        if Toggles.auto_boss.Value then
            for _,v in next, game:GetService("Workspace").Maps:GetChildren() do
                if v.Name == "Boss_3" and v:FindFirstChild("HumanoidRootPart") then
                    tweenTo(0.1, v.HumanoidRootPart)
                end
            end
        end
        if Toggles.auto_q.Value then
            vim:SendKeyEvent(true,Enum.KeyCode.Q,false,game)
        end
        if Toggles.auto_e.Value then
            vim:SendKeyEvent(true,'E',false,game)
        end
        if Toggles.auto_r.Value then
            vim:SendKeyEvent(true,'R',false,game)
        end
        if Toggles.auto_wheel.Value then
            if plr.PlayerGui.MainUi.RouletteFrame.Rotate.CountDown.Text == "" then         
                game:GetService("ReplicatedStorage").RemoteEvents.Roulette:FireServer()
            end
        end
        if Toggles.auto_chests.Value then
            teleportTo(getClosestChest())
        end
        chr.Humanoid.WalkSpeed = tonumber(Options.walkspeed.Value)
        chr.Humanoid.JumpPower = tonumber(Options.jumppower.Value)
    end)
end
