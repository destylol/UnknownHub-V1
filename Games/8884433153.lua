do
    -- library
	local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
	local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
	local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
	local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
	Library:Notify('Anti-AFK loaded!')
    -- anti afk
	local vu = game:GetService("VirtualUser")
	game:GetService("Players").LocalPlayer.Idled:connect(function()
		vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)

    -- varbs
	local players = game:GetService("Players")
	local plr = players.LocalPlayer
	local rs = game:GetService("RunService")
	local wrk = game:GetService("Workspace")
	local rep = game:GetService("ReplicatedStorage")

    -- tables
	local function getAreas()
		local args = {}
		for i, v in next, wrk.Crystals:GetChildren() do
			if string.find(v.Name, '%d+') then
				table.insert(args, v.Name)
			end
		end
		local function fixed(tablex)
			local new = {}
			local number = 1
			while not (#new == #tablex) do
				table.foreach(tablex, function(i, _)
					if tonumber(_:match('%d')) == number then
						table.insert(new, _)
						number = number + 1
					end
				end)
			end
			return new
		end
		return fixed(args)
	end
	local function getBadges()
		local badges = {}
		for _, v in next, plr.PlayerGui.ScreenGui.Main.Stats.ScrollingFrame:GetChildren() do
			if v:IsA('Frame') and v.DataCost > 20 then
				table.insert(badges, v.Name)
			end
		end
		return badges
	end
	local upgrades = {
		'Speed',
		'Damage',
		'DropCollectionRange',
		'DropRate'
	}
	local function getEggs()
		local eggs = {}
		for _, v in next, wrk.EggShops:GetChildren() do
			if not table.find(eggs, v.Name) then
				table.insert(eggs, v.Name)
			end
		end
		return eggs
	end

    -- functions
	local function closestEnemy()
		local closest = nil
		local dist = math.huge
		for i, v in next, wrk.Crystals[Options.farm_area.Value]:GetChildren() do
			if v:IsA('MeshPart') then
				local tempDist = (v.Position - plr.Character.HumanoidRootPart.Position).magnitude
				if tempDist < dist then
					dist = tempDist
					closest = v
				end
			end
		end
		return closest
	end
	local function Invite()
		local req = syn.request or http_request or request or http.request or nil
		if req ~= nil then
			for port = 6463, 6472, 1 do
				local inv = "http://127.0.0.1:" .. tostring(port) .. "/rpc?v=1"
				local http = game:GetService("HttpService")
				local t = {
					cmd = "INVITE_BROWSER",
					args = {
						["code"] = "JUEu7XFBXD"
					},
					nonce = string.lower(http:GenerateGUID(false))
				}
				local post = http:JSONEncode(t)
				req({
					Url = inv,
					Method = "POST",
					Body = post,
					Headers = {
						["Content-Type"] = "application/json",
						["Origin"] = "https://discord.com"
					}
				})
			end
		end
	end
	local function getClosestCoin()
		local closest = nil
		local dist = math.huge
		for _, v in next, wrk.Drops:GetChildren() do
			local part = v:FindFirstChildWhichIsA('Part')
			if part then
				local tempDist = (part.Position - plr.Character.HumanoidRootPart.Position).magnitude
				if tempDist < dist then
					dist = tempDist
					closest = part
				end
			end
		end
		return closest
	end
	local function teleportTo(pos)
		plr.Character.HumanoidRootPart.CFrame = pos.CFrame + Vector3.new(0, 5, 0)
	end
	local function tweenTo(time, pos)
		game:GetService('TweenService'):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(time, Enum.EasingStyle.Linear), {
			CFrame = pos.CFrame
		}):Play()
		task.wait(time)
	end

    -- UI
	local Window = Library:CreateWindow({
		Title = 'Unknown Hub',
		Size = UDim2.fromOffset(520, 565),
		Center = true,
		AutoShow = true
	})
	do
		local Tabs = {
			Main = Window:AddTab('Main'),
			['UI Settings'] = Window:AddTab('UI Settings')
		}
		local lfFarn = Tabs.Main:AddLeftTabbox("Farm")
		local tFarm = lfFarn:AddTab('Farming')
		local rtBadges = Tabs.Main:AddLeftTabbox("Badges & Upgrades")
		local tBadges = rtBadges:AddTab('Badges')
		local tUpgrades = rtBadges:AddTab('Upgrades')
		local rtHatch = Tabs.Main:AddRightTabbox("Hatch")
		local tHatch = rtHatch:AddTab('Hatching')
		local rtTP = Tabs.Main:AddRightTabbox("Teleportation")
		local tTP = rtTP:AddTab('Teleportation')
		local rtPLR = Tabs.Main:AddLeftTabbox("Local Player")
		local tPLR = rtPLR:AddTab('Local Player')
		local rtMisc = Tabs.Main:AddLeftTabbox("Misc")
		local tMisc = rtMisc:AddTab('Misc.')
		local rtCredits = Tabs.Main:AddRightTabbox("Credits")
		local tCredits = rtCredits:AddTab('Credits')
		local rtDisc = Tabs.Main:AddRightTabbox("Discord")
		local tDisc = rtDisc:AddTab('Discord')
		do
			tFarm:AddDropdown('farm_area', {
				Values = getAreas(),
				Default = "~~~",
				Multi = false,
				Text = 'Farming areas'
			})
			tFarm:AddToggle('autofarm', {
				Text = 'Autofarm',
				Default = false
			})
			tFarm:AddDivider()
			tFarm:AddToggle('autocoins', {
				Text = 'Auto collect coins',
				Default = false
			})
			tFarm:AddToggle('autoquests', {
				Text = 'Auto collect quests',
				Default = false
			})
		end
		do
			tBadges:AddDropdown('badge', {
				Values = getBadges(),
				Default = "~~~",
				Multi = false,
				Text = 'Badges'
			})
			tBadges:AddToggle('autobadges', {
				Text = "Auto claim badge",
				Default = false
			})
			tUpgrades:AddDropdown('upgrade', {
				Values = upgrades,
				Default = "~~~",
				Multi = false,
				Text = 'Upgrades'
			})
			tUpgrades:AddToggle('autoupgrade', {
				Text = "Auto upgrade",
				Default = false
			})
		end
		do
			tHatch:AddDropdown('egg', {
				Values = getEggs(),
				Default = "~~~",
				Multi = false,
				Text = 'Eggs'
			})
			tHatch:AddToggle('autohatch', {
				Text = "Auto hatch",
				Default = false
			})
		end
		do
			for i, v in next, getAreas() do
				tTP:AddButton(v, function()
					teleportTo(wrk.Areas[v])
				end)
			end
		end
		do
			tPLR:AddSlider('walkspeed', {
				Text = 'Walkspeed value',
				Default = 16,
				Min = 16,
				Max = 200,
				Rounding = 0,
				Compact = false
			})
			tPLR:AddSlider('jumpheight', {
				Text = 'Jumpheight value',
				Default = 50,
				Min = 50,
				Max = 200,
				Rounding = 0,
				Compact = false
			})
		end
		do
			tMisc:AddButton("Collect all codes", function()
				local codes = {
					'4815162342',
					'Taikatalvi',
					'HorseWithNoName',
					'Erdentempel',
					'Click',
					'Brrrrr',
					'SecretCodeWasHere',
					'IfYouAintFirst',
					'FirstCodeEver',
					'MemoryLeak',
					'Groupie',
					'Orion',
					'TillFjalls',
					'TreeSauce',
					'PillarsOfCreation',
					'TheGreatCodeInTheSky'
				}
				for _, v in next, codes do
					rep.Remotes.RedeemCode:FireServer(v)
				end
			end)
			tMisc:AddButton("Collect all hidden eggs", function()
				for _, v in next, wrk.HiddenEggs:GetChildren() do
					local touch = v:FindFirstChild('TouchInterest')
					firetouchinterest(plr.Character.Head, v, 0)
					wait()
					firetouchinterest(plr.Character.Head, v, 1)
				end
			end)
		end
		do
			tCredits:AddLabel('Script: Trustsense#8185')
			tCredits:AddLabel('Hot library: wally#6588')
		end
		do
			tDisc:AddButton('Copy discord invite', function()
				setclipboard("https://discord.gg/JUEu7XFBXD")
			end)
			local DiscButton = tDisc:AddButton('Open discord invite', function()
				Invite()
			end)
			DiscButton:AddTooltip('You need to have discord open.')
		end
		do
			local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
			MenuGroup:AddButton('Unload', function()
				Library:Unload()
			end)
			MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
				Default = 'End',
				NoUI = true,
				Text = 'Menu keybind'
			})
			Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu
			ThemeManager:SetLibrary(Library)
			SaveManager:SetLibrary(Library)
			SaveManager:IgnoreThemeSettings()
			SaveManager:SetIgnoreIndexes({
				'MenuKeybind'
			})
			ThemeManager:SetFolder('MyScriptHub')
			SaveManager:SetFolder('MyScriptHub/collectallpets!')
			SaveManager:BuildConfigSection(Tabs['UI Settings'])
			ThemeManager:ApplyToTab(Tabs['UI Settings'])
		end
	end
	do
		rs.Stepped:Connect(function()
			if Toggles.autofarm.Value then
				local closest = closestEnemy()
				if closest then
					tweenTo(0.5, closest)
				end
			end
			if Toggles.autocoins.Value then
				local closest = getClosestCoin()
				if closest then
					teleportTo(closest)
				end
			end
			if Toggles.autoquests.Value then
				local quest = plr.PlayerGui.ScreenGui.Main.Top.QuestFrame.Progress.TextLabel
				local number = quest.Text:split(' / ')
				local enough, max = number[1], number[2]
				if enough == max then
					rep.Remotes.ClaimQuestReward:FireServer()
				end
			end
			if Toggles.autobadges.Value then
				rep.Remotes.UnlockBadge:FireServer(Options.badge.Value)
			end
			if Toggles.autoupgrade.Value then
				rep.Remotes.BuyStatIncrease:FireServer(Options.upgrade.Value)
			end
			if Toggles.autohatch.Value then
				local eggRar = wrk.EggShops[Options.egg.Value].Rarity.Value
				rep.Remotes.BuyEgg:FireServer(tonumber(eggRar))
			end
			plr.Character.Humanoid.WalkSpeed = Options.walkspeed.Value
			plr.Character.Humanoid.JumpHeight = Options.jumpheight.Value
		end)
	end
end
