do
	-- { Configuration Reset } --
	if shared.Gui then
		shared.Gui:Reset()
	elseif not shared.Gui then
		shared.Gui = {
			["UI"] = nil,
			["Anti_AFK"] = nil,
			["Functions"] = nil,
			["Reset"] = function()
				local env = shared.Gui
				if env.UI then
					env.UI:Destroy()
					env.UI = nil
				end
				if env.Functions then
					env.Functions:Disconnect()
					env.Functions = nil
				end
			end,
		}
	end

	-- { Load } --
	if not game:IsLoaded() then
		game.Loaded:wait()
	end
	local env = shared.Gui

	-- { Library } --
	local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"
	local lib = loadstring(game:HttpGet(repo .. "Library.lua"))()
	local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
	local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
	lib.AccentColor = Color3.fromRGB(62, 180, 137)
	lib.AccentColorDark = lib:GetDarkerColor(lib.AccentColor)
	lib:UpdateColorsUsingRegistry()

	-- { Variables } --
	local plrs = game:GetService("Players")
	local plr = plrs.LocalPlayer
	local rep = game:GetService("ReplicatedStorage")
	local rs = game:GetService("RunService")
	local wrk = game:GetService("Workspace")
	local lpg = plr:WaitForChild("PlayerGui")
	local crg = game:GetService("CoreGui")
	local vu = game:GetService("VirtualUser")

	-- { Anti-AFK } --
	plr.Idled:connect(function()
		vu:Button2Down(Vector2.new(0, 0), wrk.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0, 0), wrk.CurrentCamera.CFrame)
	end)

	-- { Anti-Error } --
	plr.PlayerGui.MainUI.Error.Visible = false

	-- { Remotes } --
	local Click = (ARLS_LOADED and get_separate_remote("Click3")) or rep:FindFirstChild("Click3", true)
	local Spin = (ARLS_LOADED and get_separate_remote("Spin")) or rep:FindFirstChild("Spin", true)
	local Chest = (ARLS_LOADED and get_separate_remote("Chest")) or rep:FindFirstChild("Chest", true)
	local Upgrade = (ARLS_LOADED and get_separate_remote("Upgrade")) or rep:FindFirstChild("Upgrade", true)
	local Potion = (ARLS_LOADED and get_separate_remote("Potion")) or rep:FindFirstChild("Potion", true)
	local Rebirth = (ARLS_LOADED and get_separate_remote("Rebirth")) or rep:FindFirstChild("Rebirth", true)
	local Unbox = (ARLS_LOADED and get_separate_remote("Unbox")) or rep:FindFirstChild("Unbox", true)
	
	-- { Functions } --
	local function Invite()
        if not isfolder('Mint') then
            makefolder('Mint')
        end
        if isfile('Mint.txt') == false then
            (syn and syn.request or http_request)({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    ['Origin'] = 'https://discord.com'
                },
                Body = game:GetService('HttpService'):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    args = {
                        code = 'JUEu7XFBXD'
                    },
                    nonce = game:GetService('HttpService'):GenerateGUID(false)
                }),
                writefile('Mint.txt', 'discord')
            })
        end
    end

	-- { Tables } --
	local function upgradesTable()
		local items = {}
		for i, v in pairs(plr.Upgrades:GetChildren()) do
			table.insert(items, v.Name)
		end
		return items
	end
	local function potionsTable()
		local items = {}
		for i, v in pairs(plr.Potions:GetChildren()) do
			table.insert(items, v.Name)
		end
		return items
	end
	local function rebirthsTable()
		local items = {}
		for i, v in pairs(lpg.MainUI.RebirthFrame.Top.Holder.ScrollingFrame:GetChildren()) do
			if v:IsA("ImageLabel") then
				table.insert(items, v.Name)
			end
		end
		return items
	end
	local function deleteTable()
		local items = {}
		for i, v in pairs(plr.AutoDelete:GetChildren()) do
			table.insert(items, v.Name)
		end
		return items
	end
	local function eggsTable()
		local items = {}
		for i, v in pairs(wrk.Scripts.Eggs:GetChildren()) do
			if not v.Name:find("Robux") then
				table.insert(items, v.Name)
			end
		end
		return items
	end

	-- { Elements } --
	local Window = lib:CreateWindow({
		Title = "Mint Hub",
		Center = true,
		AutoShow = true,
		Size = UDim2.fromOffset(520, 620),
	})
	local Tabs = {
		Main = Window:AddTab("Main"),
		Menu = Window:AddTab("Menu Settings"),
	}

	local lfFarm = Tabs.Main:AddLeftTabbox("Farming")
	local tFarm = lfFarm:AddTab("Farming")
	tFarm:AddToggle("click", { Text = "Auto click", Default = false })
	tFarm:AddToggle("wheel", { Text = "Auto spin wheel", Default = false })
	tFarm:AddDivider()
	tFarm:AddButton("Collect all chests", function()
		for i, v in pairs(wrk.Scripts.Chests:GetChildren()) do
			if v:IsA("Model") then
				Chest:FireServer(v.Name)
			end
		end
	end)
	tFarm:AddButton("Unlock some passes", function()
		for i, v in pairs(plr.Passes:GetChildren()) do
			v.Value = true
		end
	end)

	local lfUP = Tabs.Main:AddLeftTabbox("Upgrades")
	local tU = lfUP:AddTab("Upgrades")
	local tP = lfUP:AddTab("Potions")
	tU:AddDropdown("upgrades", { Values = upgradesTable(), Default = "---", Multi = true, Text = "Upgrades" })
	tU:AddToggle("upgrade", { Text = "Auto buy upgrades", Default = false })
	tP:AddDropdown("potions", { Values = potionsTable(), Default = "---", Multi = true, Text = "Potions" })
	tP:AddToggle("potion", { Text = "Auto buy potions", Default = false })

	local rUP = Tabs.Main:AddLeftTabbox("Rebirth")
	local rU = rUP:AddTab("Rebirths")
	rU:AddDropdown("rebirths", { Values = rebirthsTable(), Default = "1", Multi = false, Text = "Rebirths" })
	local Cost = rU:AddLabel("nil")
	rU:AddToggle("rebirth", { Text = "Auto rebirth", Default = false })

	local rHa = Tabs.Main:AddRightTabbox("Eggs")
	local rH = rHa:AddTab("Eggs")
	rH:AddDropdown("eggs", { Values = eggsTable(), Default = "---", Multi = false, Text = "Eggs" })
	rH:AddToggle("egg", { Text = "Auto hatch", Default = false })
	rH:AddToggle("egg3", { Text = "Auto x3 hatch", Default = false })
	rH:AddDivider()
	rH:AddDropdown("delete_settings", { Values = deleteTable(), Default = "---", Multi = true, Text = "Delete options" })
	rH:AddToggle("delete", { Text = "Auto delete", Default = false })
	rH:AddDivider()
	rH:AddToggle("auto_craft", { Text = "Auto craft", Default = false })

	local lfLP = Tabs.Main:AddLeftTabbox("Local Player")
	local tLP = lfLP:AddTab("Local Player")
	tLP:AddSlider("walkspeed", {Text = "Walkspeed value",Default = 16,Min = 16,Max = 200,Rounding = 0,Compact = false})
	tLP:AddSlider("jumppower", {Text = "Jumppower value",Default = 50,Min = 50,Max = 200,Rounding = 0,Compact = false})

	local lfMisc = Tabs.Main:AddLeftTabbox("Misc")
	local tMisc = lfMisc:AddTab("Misc.")
	tMisc:AddButton("Collect all codes", function()
        local codesTable = {'heaven', 'wow30000', 'magic', '20kthankyou', 'freeluckboost', 'CYBER', 'wow10klikesthanks',
                            'freeclicksomg', 'moon', '5klikesthanks', 'wow2500likes', 'already1500likes',
                            'thanks500likes', 'RELEASE', 'void', 'nuclear', 'spooky','75kthanks', 'cave','easter','100kthanks','easter2'}
        for _, v in pairs(codesTable) do
            rep.Events.Codes:FireServer(v)
        end
    end)
	tMisc:AddButton("Fix uglyness", function()
        game.Lighting.Brightness = 0
    end)

	local rtCredits = Tabs.Main:AddRightTabbox("Credits")
    local tCredits = rtCredits:AddTab("Credits")
	tCredits:AddLabel("Script: <font color='#3EB489'>Trustsense</font>")
    tCredits:AddLabel("Hot library: <font color='#ADD8E6'>wally</font>")

	local rtDisc = Tabs.Main:AddRightTabbox("Discord")
    local tDisc = rtDisc:AddTab("Discord")
	tDisc:AddButton("Copy discord invite", function() setclipboard("https://discord.gg/JUEu7XFBXD") end)
    local DiscButton = tDisc:AddButton("Open discord invite", function() Invite() end)
    DiscButton:AddTooltip("You need to have discord open.")

	-- Menu Settings
	local rtMenu=Tabs.Menu:AddLeftTabbox('Menu Settings');
	local tMenu=rtMenu:AddTab('Menu Settings');
	tMenu:AddButton('Unload Script',function()
		lib:Unload()
	end);
	tMenu:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {Default = 'End',NoUI = true,Text = 'Menu keybind'});
	lib.ToggleKeybind = Options.MenuKeybind
	ThemeManager:SetLibrary(lib)
	SaveManager:SetLibrary(lib)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({'MenuKeybind'})
	ThemeManager:SetFolder('MyScriptHub')
	SaveManager:SetFolder('MyScriptHub/collectallpets!')
	SaveManager:BuildConfigSection(Tabs.Menu)
	ThemeManager:ApplyToTab(Tabs.Menu)

	-- { Loops } --
	rs.RenderStepped:Connect(function()
		if Toggles.click.Value then
			Click:FireServer()
		end
		if Toggles.wheel.Value then
			if wrk.Scripts.DailySpin.Billboard.BillboardGui.Countdown.Text == "Ready to Claim!" then
				Spin:InvokeServer()
			end
		end
		if Toggles.upgrade.Value then
			for i, v in pairs(Options.upgrades.Value) do
				Upgrade:InvokeServer(i)
			end
		end
		if Toggles.potion.Value then
			for i, v in pairs(Options.potions.Value) do
				Potion:FireServer(i)
			end
		end
		Cost:SetText(lpg.MainUI.RebirthFrame.Top.Holder.ScrollingFrame[Options.rebirths.Value].Main.Label.Text)
		if Toggles.rebirth.Value then
			Rebirth:FireServer(tonumber(Options.rebirths.Value))
		end
		if Toggles.egg.Value then
			Unbox:InvokeServer(Options.eggs.Value, "Single")
		end
		if Toggles.egg3.Value then
			Unbox:InvokeServer(Options.eggs.Value, "Triple")
		end
		if Toggles.delete.Value then
			for i, v in pairs(Options.delete_settings.Value) do
				plr.AutoDelete[i].Value = true
			end
		else
			for i, v in pairs(Options.delete_settings.Value) do
				plr.AutoDelete[i].Value = false
			end
		end
		if Toggles.auto_craft.Value then
			rep.Functions.Request:InvokeServer('CraftAll', {})
		end
		plr.Character.Humanoid.WalkSpeed = Options.walkspeed.Value
		plr.Character.Humanoid.JumpHeight = Options.jumppower.Value
	end)
end
