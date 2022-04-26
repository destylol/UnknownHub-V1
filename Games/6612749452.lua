do
    --Config
    if shared.Gui then
        shared.Gui:Reset()
    elseif not(shared.Gui)then
        shared.Gui={
            ['UI']=nil;
            ['Anti_AFK']=nil;
            ['Functions']=nil;
            ['Reset']=function()
                local env=shared.Gui
                if env.UI then
                    env.UI:Destroy()
                    env.UI=nil;
                end;
                if env.Functions then
                    env.Functions:Disconnect()
                    env.Functions=nil;
                end;
            end;
        }
    end;

    --loaded
    if not game:IsLoaded() then game.Loaded:wait()end
    local env=shared.Gui

    -- library
    local repo='https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
    local lib=loadstring(game:HttpGet(repo..'Library.lua'))()
    local ThemeManager=loadstring(game:HttpGet(repo..'addons/ThemeManager.lua'))()
    local SaveManager=loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()

    lib.AccentColor = Color3.fromRGB(62, 180, 137)
    lib.AccentColorDark = lib:GetDarkerColor(lib.AccentColor);
    lib:UpdateColorsUsingRegistry()

    -- varbs
    local pl=game:GetService'Players'.LocalPlayer;
    local rs=game:GetService'ReplicatedStorage';
    local ws=game:GetService'Workspace';
    local r=game:GetService'RunService';
    local vu=game:GetService'VirtualUser';
    local HTTP=game:GetService('HttpService');

    local pg=pl:WaitForChild'PlayerGui';
    local pc=pl.Character;
    local backpack_equip;
    --remote
    local Mine=(ARLS_LOADED and get_separate_remote('MineOre'))or
                rs:FindFirstChild('MineOre',true);
    local Update=(ARLS_LOADED and get_separate_remote('Update'))or
                rs.Remotes.Worker:FindFirstChild('Update',true);
    local buy_plot=(ARLS_LOADED and get_separate_remote('PurchasePlot'))or
                rs:FindFirstChild('PurchasePlot',true);
    local plot=ws.PlayerWorlds[tostring(pl:FindFirstChild'CurrentWorld'.Value)];
    local Sell_remote=(ARLS_LOADED and get_separate_remote('SellLoot'))or
                rs.Remotes:FindFirstChild('SellLoot',true);
    local PurchasePlot=(ARLS_LOADED and get_separate_remote('PurchasePlot'))or
                rs.Remotes:FindFirstChild('PurchasePlot',true);
    local RequestBuyPickaxe=(ARLS_LOADED and get_separate_remote('RequestBuyPickaxe'))or
                rs.Remotes:FindFirstChild('RequestBuyPickaxe',true);
    local RequestBuyBackpack=(ARLS_LOADED and get_separate_remote('RequestBuyBackpack'))or
                rs.Remotes:FindFirstChild('RequestBuyBackpack',true);
    local RequestUnlock=(ARLS_LOADED and get_separate_remote('RequestUnlock'))or
                rs.Remotes.Worker:FindFirstChild('RequestUnlock',true);
    local RequestUpgrade=(ARLS_LOADED and get_separate_remote('RequestUpgrade'))or
                rs.Remotes.Worker:FindFirstChild('RequestUpgrade',true);
    -- anti afk
    if env.Anti_AFK~=true then
        pl.Idled:connect(function()
            vu:Button2Down(Vector2.new(0, 0), wrk.CurrentCamera.CFrame);
            wait(1);
            vu:Button2Up(Vector2.new(0, 0), wrk.CurrentCamera.CFrame);
        end);
        env.Anti_AFK=true;
    end;

    pl.CharacterAdded:connect(function(char)pc=char;end);
    for i,_ in next,pc:GetChildren() do
        if _.Name:find'Backpack' then
            backpack_equip=_.Name:match('%d');
        end;
    end;
    -- functions
    function Invite()
        if not isfolder('Mint') then
            makefolder('Mint');
        end;
        if isfile('Mint.txt') == false then
            (arls_request or syn and syn.request or http_request)({
                Url='http://127.0.0.1:6463/rpc?v=1';
                Method='POST';
                Headers={
                    ['Content-Type']='application/json';
                    ['Origin']='https://discord.com';
                };
                Body=HTTP:JSONEncode({
                    cmd='INVITE_BROWSER';
                    args={code='mithub'};
                    nonce=HTTP:GenerateGUID(false);
                });
                writefile('Mint.txt','discord')
            })
        end
    end

    function get_numbers(txt)
        local str = ""
        string.gsub(txt,"%d+",function(e)str=str..e;end)
        return tonumber(str);
    end
    -- ui
    local Window=lib:CreateWindow({
        Title=os.date'%x':sub(1,5)=='04/01'and'Anotherlass'or'Mint Hub',
        Center = true,
        AutoShow = true,
        Size=UDim2.fromOffset(570, 620),
    })
    env.UI=Window.Holder.Parent
    do
        local Tabs = {
            Main = Window:AddTab'Main',
            ['UI Settings'] = Window:AddTab'UI Settings'
        }
        
        local lfFarm = Tabs.Main:AddLeftTabbox'Farming'
        local tFarm = lfFarm:AddTab'Farming'
        local rtBuy = Tabs.Main:AddLeftTabbox'Buy'
        local tBuy = rtBuy:AddTab'Buy'

        local rtPLR = Tabs.Main:AddLeftTabbox'Local Player'
        local tPLR = rtPLR:AddTab'Local Player'
        local rtCredits = Tabs.Main:AddRightTabbox'Credits'
        local tCredits = rtCredits:AddTab'Credits'
        local rtDisc = Tabs.Main:AddRightTabbox'Discord'
        local tDisc = rtDisc:AddTab'Discord'
        do -- Farm
            tFarm:AddToggle('miner',{Text='Auto mine',Default=false})
            tFarm:AddToggle('sell',{Text='Auto sell',Default=false})
        end

        do -- Buy
            tBuy:AddToggle('pickaxes',{Text='Auto buy pickaxes',Default=false})
            tBuy:AddToggle('backpacks',{Text='Auto buy backpacks',Default=false})
            tBuy:AddButton('Buy workers',function()
                RequestUnlock:FireServer()
            end)
            tBuy:AddToggle('u_work',{Text='Auto upgrade workers',Default=false})
            tBuy:AddToggle('expand_plot',{Text='Auto expand plot',Default=false})
        end

        do -- local player
            tPLR:AddSlider('walkspeed', {Text = 'Walkspeed value',Default = 16,Min = 16,Max = 200,Rounding = 0,Compact = false})
            tPLR:AddSlider('jumppower', {Text = 'Jumppower value',Default = 50,Min = 50,Max = 200,Rounding = 0,Compact = false})
        end

        do -- Credits
            tCredits:AddLabel'Script: <font color=\'#2a4d73\'>Anotherlass</font>'
            tCredits:AddLabel'Hot library: <font color=\'#ADD8E6\'>wally</font>'
        end
        do
            tDisc:AddButton('Copy discord invite', function() setclipboard'https://discord.gg/JUEu7XFBXD' end)
            local DiscButton = tDisc:AddButton('Open discord invite', function() Invite() end)
            DiscButton:AddTooltip'You need to have discord open.'
        end
        do -- Ui settings
            local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox'Menu'
            MenuGroup:AddButton('Unload', function() lib:Unload() end)
            MenuGroup:AddLabel'Menu bind':AddKeyPicker('MenuKeybind', {Default = 'End',NoUI = true,Text = 'Menu keybind'})
            lib.ToggleKeybind = Options.MenuKeybind
            ThemeManager:SetLibrary(lib)
            SaveManager:SetLibrary(lib)
            SaveManager:IgnoreThemeSettings()
            SaveManager:SetIgnoreIndexes({'MenuKeybind'})
            ThemeManager:SetFolder'MyScriptHub'
            SaveManager:SetFolder'MyScriptHub/collectallpets!'
            SaveManager:BuildConfigSection(Tabs['UI Settings'])
            ThemeManager:ApplyToTab(Tabs['UI Settings'])
        end
    end;
    looping=r.Stepped:Connect(function()
        if Toggles.miner.Value or Toggles.expand_plot.Value then
            for i,_ in next,plot:GetChildren()do
                if _:FindFirstChild('OreHolder',true)and
                #_:FindFirstChild('OreHolder',true):GetChildren()==1 and
                Toggles.miner.Value then
                    Mine:FireServer(_.Name)
                end;
                if _:FindFirstChild('Locked')and Toggles.expand_plot.Value then
                    local txt=_:FindFirstChild('Locked'):FindFirstChild('TextLabel',true).Text
                    local coin=pg:FindFirstChild('CurrencyText',true).Text
                    if get_numbers(txt)<=get_numbers(coin)then
                        PurchasePlot:FireServer(_.Name)
                    end
                end;
            end;
        end;
        if Toggles.sell.Value then
            if tonumber(pg:FindFirstChild('OreText',true).Text:match('%d+'))~=0 then
                Sell_remote:FireServer()
            end;
        end;
        if Toggles.pickaxes.Value then
            wait(2)
            for i=1,11 do
                RequestBuyPickaxe:FireServer(i)
            end;
        end;
        if Toggles.backpacks.Value then
            wait(2)
            for i=1,5 do
                RequestBuyBackpack:FireServer(i)
            end;
        end;
        if Toggles.u_work.Value then
            wait(2)
            for i=1,3 do
                RequestUpgrade:FireServer(i)
            end;
        end;
        local hum=pc.Humanoid
        if hum.WalkSpeed~=Options.walkspeed.Value then
            hum.WalkSpeed = Options.walkspeed.Value;
        end;
        if hum.JumpHeight~=Options.jumppower.Value then
            hum.JumpHeight = Options.jumppower.Value;
        end;
	end)
    env.Functions=looping
end;
