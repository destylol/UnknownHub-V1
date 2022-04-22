do
    -- loading
    if not game:IsLoaded() then game.Loaded:wait()end

    -- library imports
    local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/';
    local lib = loadstring(game:HttpGet(repo .. 'Library.lua'))();
    local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))();
    local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))();

    lib.AccentColor = Color3.fromRGB(62, 180, 137)
    lib.AccentColorDark = lib:GetDarkerColor(lib.AccentColor);
    lib:UpdateColorsUsingRegistry()

	-- variables
    local wrk=game:GetService'Workspace';
    local crg=game:GetService'CoreGui';
    local plrs=game:GetService'Players';
    local lp=plrs.LocalPlayer;
    local chr=lp.Character;
    local hum=chr:WaitForChild'Humanoid';
    local hump=chr:WaitForChild'HumanoidRootPart';
    local r=game:GetService'RunService';
    local rs=game:GetService'ReplicatedStorage';
    local ts=game:GetService'TweenService';
    local lpg=lp.PlayerGui;
    local badgeMod=require(rs.DB.BadgeRequirements);
    local vu = game:GetService'VirtualUser';
    -- anti afk
	lp.Idled:connect(function()
		vu:Button2Down(Vector2.new(0, 0), wrk.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0, 0), wrk.CurrentCamera.CFrame)
	end)

    -- tables
    function GetAreas()
        local Areas={}
        for _,v in next,wrk.Crystals:GetChildren() do
            if string.find(v.Name, "%d") then
                table.insert(Areas,v.Name)
            end;
        end;
        function FixAreas(NewTable)
            local NewAreas={}
            local num=1
            while not(#NewAreas==#NewTable)do
                table.foreach(NewTable,function(_,v)
                    if tonumber(v:match("%d"))==num then
                        table.insert(NewAreas,v)
                        num=num+1
                    end;
                end);
            end;
            return NewAreas
        end;
        return FixAreas(Areas)
    end;
    function GetBadges()
        local badges={}
        for i,v in next, badgeMod do
            table.insert(badges,i)
        end;
        return badges
    end;
    function GetUpgdrades()
        local upgrades={}
        for _,v in next,wrk.StatIncreaseShops:GetChildren()do
            local Newname = v.Name:split("_")
            table.insert(upgrades,Newname[2])
        end;
        return upgrades
    end;
    function getEggs()
		local eggs = {}
		for _,v in next,wrk.EggShops:GetChildren()do
            local Newname=v.Name:split("_")
			if not table.find(eggs,Newname[2])then
				table.insert(eggs,Newname[2])
			end;
		end;
		return eggs
	end;

	-- functions
    function tweenTo(speed, pos)
        ts:Create(hump, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = pos.CFrame}):Play()
        task.wait(speed)
    end;
    function teleportTo(pos)
        hump.CFrame=CFrame.new(pos.Position + Vector3.new(0, 5, 0))
    end;
    function ClosestCrystal()
        local closest=nil;
        local dist=math.huge
        for _,v in next,wrk.Crystals[Options.Area.Value]:GetChildren()do
            if v:IsA("MeshPart") then
                local magn=(v.Position-hump.Position).magnitude
                if magn<dist then
                    dist=magn
                    closest=v
                end;
            end;
        end;
        return closest
    end;
    function ClosestCoin()
        local closest=nil
        local dist=math.huge
        for _,v in next,wrk.Drops:GetChildren()do
            local part=v:FindFirstChildWhichIsA('Part')
            if part then
                local magn=(part.Position - hump.Position).magnitude
                if magn<dist then
                    dist=magn
                    closest=part
                end;
            end;
        end;
        return closest
    end;
    function CollectQuest()
        local quest=lpg.ScreenGui.Main.Top.QuestFrame.Progress.TextLabel
        local number=quest.Text:split(' / ')
        local enough,max=number[1],number[2]
        if enough==max then
            rs.Remotes.ClaimQuestReward:FireServer()
        end
    end;
    function DeleteComma(str)
        local newStr=''
        for i=1,#str do
            if str:sub(i,i)~=',' then
                newStr=newStr..str:sub(i,i)
            end;
        end;
        return newStr:match'<.+>(.+)<.+>'
    end;
    function Invite()
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

	do -- Library
        local win=lib:CreateWindow({Title='Unknown Hub | Collect All Pets',Size=UDim2.fromOffset(550, 600),Center=false,AutoShow=true});
        local Tabs={Main=win:AddTab('Main'),Menu=win:AddTab('Menu Settings')};

        local FarmBox=Tabs.Main:AddLeftTabbox('Farm');
        local tFarm=FarmBox:AddTab('Farming Utility');
        tFarm:AddDropdown('Area',{Values=GetAreas(),Default = 'nil',Multi = false,Text = 'Farming areas'});
        tFarm:AddToggle('autofarm',{Text='Autofarm',Default = false});
        tFarm:AddDivider();
        tFarm:AddToggle('autocoins',{Text='Auto collect coins',Default = false});
        tFarm:AddToggle('autoquest',{Text='Auto collect quests',Default = false});

        local BUBox=Tabs.Main:AddLeftTabbox('Farm');
        local Br=BUBox:AddTab('Auto Badges');
        local Ur=BUBox:AddTab('Auto Upgrades');
        Br:AddDropdown('badges',{Values=GetBadges(),Default = 'nil',Multi = true,Text = 'Badges'});
        Br:AddToggle('autobadge',{Text='Auto claim badges',Default = false});
        Ur:AddDropdown('upgrades',{Values=GetUpgdrades(),Default = 'nil',Multi = true,Text = 'Upgrades'});
        Ur:AddToggle('autoupgrade',{Text='Auto upgrade',Default = false});

        local HatchBox=Tabs.Main:AddRightTabbox('Hatching Utility');
        local tHatch=HatchBox:AddTab('Hatching Utility');
        tHatch:AddDropdown('egg',{Values=getEggs(),Default = 'nil',Multi = false,Text = 'Eggs'});
        tHatch:AddToggle('autohatch',{Text='Auto hatch',Default = false});

        local rtTP=Tabs.Main:AddRightTabbox('Teleportation');
		local tTP=rtTP:AddTab('Teleportation');
        for _,v in next,GetAreas()do
            tTP:AddButton(v,function()
                teleportTo(wrk.Areas[v])
            end)
        end;

        local rtPLR=Tabs.Main:AddLeftTabbox('Local Player')
		local tPLR=rtPLR:AddTab('Local Player')
        tPLR:AddSlider('walkspeed', {Text = 'Walkspeed value',Default = 16,Min = 16,Max = 200,Rounding = 0,Compact = false});
        tPLR:AddSlider('jumpheight', {Text = 'Jumpheight value',Default = 50,Min = 50,Max = 200,Rounding = 0,Compact = false});

        local rtMisc=Tabs.Main:AddLeftTabbox('Misc')
		local tMisc=rtMisc:AddTab('Misc.')
        tMisc:AddButton('Collect all codes',function()
            local codes = {'4815162342','Taikatalvi','HorseWithNoName','Erdentempel','Click','Brrrrr','SecretCodeWasHere','IfYouAintFirst','FirstCodeEver','MemoryLeak','Groupie','Orion','TillFjalls','TreeSauce','PillarsOfCreation','TheGreatCodeInTheSky'};
            for _,v in next,codes do
                rs.Remotes.RedeemCode:FireServer(v)
            end
        end);
        tMisc:AddButton('Collect hidden eggs',function()
            for _,v in next,wrk.HiddenEggs:GetChildren()do
                local touch=v:FindFirstChild('TouchInterest')
                firetouchinterest(chr.Head,v,0)
                wait()
                firetouchinterest(chr.Head,v,1)
            end
        end);
        
        local rtCredits=Tabs.Main:AddRightTabbox('Credits');
		local tCredits=rtCredits:AddTab('Credits');
        tCredits:AddLabel('Script: <font color="#3EB489">Trustsense</font>');
		tCredits:AddLabel('Hot library: <font color="#ADD8E6">wally</font>');

        local rtDisc=Tabs.Main:AddRightTabbox('Discord');
		local tDisc=rtDisc:AddTab('Discord');
        tDisc:AddButton('Copy discord invite',function()
            setclipboard('https://discord.gg/JUEu7XFBXD')
        end)
        local DiscButton=tDisc:AddButton('Open discord invite',function()
            Invite()
        end)
        DiscButton:AddTooltip('You need to have discord open.')

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
    end;
    
    do -- loop
        r.RenderStepped:Connect(function()
            if Toggles.autofarm.Value then
                tweenTo(0.1,ClosestCrystal())
            end;
            if Toggles.autocoins.Value then
                teleportTo(ClosestCoin())
            end;
            if Toggles.autoquest.Value then
                CollectQuest()
            end;
            if Toggles.autobadge.Value then
                for i,k in next,Options.badges.Value do
                    for _,v in next,lpg.ScreenGui.Main.Stats.ScrollingFrame:GetChildren() do
                        if v.Name==i then
                            local button=v:FindFirstChildWhichIsA'ImageButton'
                            if button.BackgroundColor3==Color3.fromRGB(106, 255, 186) then
                                rs.Remotes.UnlockBadge:FireServer(v.Name)
                            end
                        end;
                    end;
                end
            end;
            if Toggles.autoupgrade.Value then
                for p,z in next, Options.upgrades.Value do
                    for i,v in next,wrk.StatIncreaseShops:GetChildren()do
                        local text=v.Name:split('_')
                        if text[2]==p then
                            local GuiPart=v:FindFirstChild'GuiPart'
                            local SurfaceUI=GuiPart:FindFirstChildWhichIsA'SurfaceGui'
                            local price=SurfaceUI:FindFirstChild'PriceLabel'
                            if tonumber(DeleteComma(price.Text))<=tonumber(lp.Gold.Value)then
                                rs.Remotes.BuyStatIncrease:FireServer(tostring(text[2]))
                            end;
                        end;
                    end;
                end;
            end;
            if Toggles.autohatch.Value then
                for _,v in next, wrk.EggShops:GetChildren() do
                    local name=v.Name:split('_')
                    if name[2]==Options.egg.Value then
                        local GuiPart=v:FindFirstChild'GuiPart'
                        local SurfaceUI=GuiPart:FindFirstChildWhichIsA'SurfaceGui'
                        local price=SurfaceUI:FindFirstChild'PriceLabel'
                        local inv=lpg.ScreenGui.Main.Pets.PetsShownLabel
                        local fixinv=string.gsub(inv.Text, " pets shown", "")
                        local space=fixinv:split(' / ')
                        local enough=tonumber(space[1])
                        if tonumber(DeleteComma(price.Text))<=tonumber(lp.Gold.Value) then
                            if enough<188 then
                            local eggRar=v.Rarity.Value
                            rs.Remotes.BuyEgg:FireServer(tonumber(eggRar))
                            end
                        end;
                    end;
                end
            end;
            hum.WalkSpeed = Options.walkspeed.Value;
		hum.JumpHeight = Options.jumpheight.Value;
        end);
    end;
end;
