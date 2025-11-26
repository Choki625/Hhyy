local v0 = {
    Players = game:GetService("Players"), 
    RunService = game:GetService("RunService"), 
    HttpService = game:GetService("HttpService"), 
    RS = game:GetService("ReplicatedStorage"), 
    VIM = game:GetService("VirtualInputManager"), 
    PG = game:GetService("Players").LocalPlayer.PlayerGui, 
    Camera = workspace.CurrentCamera, 
    GuiService = game:GetService("GuiService"), 
    CoreGui = game:GetService("CoreGui")
};
_G.httpRequest = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request;
if not _G.httpRequest then
    return;
else
    local l_LocalPlayer_0 = v0.Players.LocalPlayer;
    if not l_LocalPlayer_0.Character or not l_LocalPlayer_0.Character:WaitForChild("HumanoidRootPart") then
        local _ = l_LocalPlayer_0.CharacterAdded:Wait():WaitForChild("HumanoidRootPart");
    end;
    local v3 = "Chloe X/FishIt" .. "/Position.json";
    local v4 = {
        MerchantRoot = v0.PG.Merchant.Main.Background, 
        ItemsFrame = v0.PG.Merchant.Main.Background.Items.ScrollingFrame, 
        RefreshMerchant = v0.PG.Merchant.Main.Background.RefreshLabel
    };
    local v5 = {
        Net = v0.RS.Packages._Index["sleitnick_net@0.2.0"].net, 
        Replion = require(v0.RS.Packages.Replion), 
        FishingController = require(v0.RS.Controllers.FishingController), 
        TradingController = require(v0.RS.Controllers.ItemTradingController), 
        ItemUtility = require(v0.RS.Shared.ItemUtility), 
        VendorUtility = require(v0.RS.Shared.VendorUtility), 
        PlayerStatsUtility = require(v0.RS.Shared.PlayerStatsUtility), 
        Effects = require(v0.RS.Shared.Effects), 
        NotifierFish = require(v0.RS.Controllers.TextNotificationController)
    };
    local v6 = {
        Events = {
            RECutscene = v5.Net["RE/ReplicateCutscene"], 
            REStop = v5.Net["RE/StopCutscene"], 
            REFav = v5.Net["RE/FavoriteItem"], 
            REFavChg = v5.Net["RE/FavoriteStateChanged"], 
            REFishDone = v5.Net["RE/FishingCompleted"], 
            REFishGot = v5.Net["RE/FishCaught"], 
            RENotify = v5.Net["RE/TextNotification"], 
            REEquip = v5.Net["RE/EquipToolFromHotbar"], 
            REEquipItem = v5.Net["RE/EquipItem"], 
            REAltar = v5.Net["RE/ActivateEnchantingAltar"], 
            REAltar2 = v5.Net["RE/ActivateSecondEnchantingAltar"], 
            UpdateOxygen = v5.Net["URE/UpdateOxygen"], 
            REPlayFishEffect = v5.Net["RE/PlayFishingEffect"], 
            RETextEffect = v5.Net["RE/ReplicateTextEffect"], 
            REEvReward = v5.Net["RE/ClaimEventReward"], 
            Totem = v5.Net["RE/SpawnTotem"], 
            REObtainedNewFishNotification = v5.Net["RE/ObtainedNewFishNotification"], 
            FishingMinigameChanged = v5.Net["RE/FishingMinigameChanged"], 
            FishingStopped = v5.Net["RE/FishingStopped"]
        }, 
        Functions = {
            Trade = v5.Net["RF/InitiateTrade"], 
            BuyRod = v5.Net["RF/PurchaseFishingRod"], 
            BuyBait = v5.Net["RF/PurchaseBait"], 
            BuyWeather = v5.Net["RF/PurchaseWeatherEvent"], 
            ChargeRod = v5.Net["RF/ChargeFishingRod"], 
            StartMini = v5.Net["RF/RequestFishingMinigameStarted"], 
            UpdateRadar = v5.Net["RF/UpdateFishingRadar"], 
            Cancel = v5.Net["RF/CancelFishingInputs"], 
            Dialogue = v5.Net["RF/SpecialDialogueEvent"], 
            Done = v5.Net["RF/RequestFishingMinigameStarted"]
        }
    };
    local v7 = {
        Data = v5.Replion.Client:WaitReplion("Data"), 
        Items = v0.RS:WaitForChild("Items"), 
        PlayerStat = require(v0.RS.Packages._Index:FindFirstChild("ytrev_replion@2.0.0-rc.3").replion)
    };
    local v8 = {
        autoInstant = false, 
        selectedEvents = {}, 
        autoWeather = false, 
        autoSellEnabled = false, 
        autoFavEnabled = false, 
        autoEventActive = false, 
        canFish = true, 
        savedCFrame = nil, 
        sellMode = "Delay", 
        sellDelay = 60, 
        inputSellCount = 50, 
        selectedName = {}, 
        selectedRarity = {}, 
        selectedVariant = {}, 
        rodDataList = {}, 
        rodDisplayNames = {}, 
        baitDataList = {}, 
        baitDisplayNames = {}, 
        selectedRodId = nil, 
        selectedBaitId = nil, 
        rods = {}, 
        baits = {}, 
        weathers = {}, 
        lcc = 0, 
        player = l_LocalPlayer_0, 
        stats = l_LocalPlayer_0:WaitForChild("leaderstats"), 
        caught = l_LocalPlayer_0:WaitForChild("leaderstats"):WaitForChild("Caught"), 
        char = l_LocalPlayer_0.Character or l_LocalPlayer_0.CharacterAdded:Wait(), 
        vim = v0.VIM, 
        cam = v0.Camera, 
        offs = {
            ["Worm Hunt"] = 25
        }, 
        curCF = nil, 
        origCF = nil, 
        flt = false, 
        con = nil, 
        Instant = false, 
        CancelWaitTime = 3, 
        ResetTimer = 0.5, 
        hasTriggeredBug = false, 
        lastFishTime = 0, 
        fishConnected = false, 
        lastCancelTime = 0, 
        hasFishingEffect = false, 
        trade = {
            selectedPlayer = nil, 
            selectedItem = nil, 
            tradeAmount = 1, 
            targetCoins = 0, 
            trading = false, 
            awaiting = false, 
            lastResult = nil, 
            successCount = 0, 
            failCount = 0, 
            totalToTrade = 0, 
            sentCoins = 0, 
            successCoins = 0, 
            failCoins = 0, 
            totalReceived = 0, 
            currentGrouped = {}, 
            TotemActive = false
        }, 
        ignore = {
            Cloudy = true, 
            Day = true, 
            ["Increased Luck"] = true, 
            Mutated = true, 
            Night = true, 
            Snow = true, 
            ["Sparkling Cove"] = true, 
            Storm = true, 
            Wind = true, 
            UIListLayout = true, 
            ["Admin - Shocked"] = true, 
            ["Admin - Super Mutated"] = true, 
            Radiant = true
        }, 
        notifConnections = {}, 
        defaultHandlers = {}, 
        disabledCons = {}, 
        CEvent = true
    };
    _G.Celestial = _G.Celestial or {};
    _G.Celestial.DetectorCount = _G.Celestial.DetectorCount or 0;
    _G.Celestial.InstantCount = _G.Celestial.InstantCount or 0;
    getFishCount = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        local l_BagSize_0 = v8.player.PlayerGui:WaitForChild("Inventory"):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Options"):WaitForChild("Fish"):WaitForChild("Label"):WaitForChild("BagSize");
        return tonumber((l_BagSize_0.Text or "0/???"):match("(%d+)/")) or 0;
    end;
    clickCenter = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        local l_ViewportSize_0 = v8.cam.ViewportSize;
        v8.vim:SendMouseButtonEvent(l_ViewportSize_0.X / 2, l_ViewportSize_0.Y / 2, 0, true, nil, 0);
        v8.vim:SendMouseButtonEvent(l_ViewportSize_0.X / 2, l_ViewportSize_0.Y / 2, 0, false, nil, 0);
    end;
    local v11 = {};
    for _, v13 in ipairs(v7.Items:GetChildren()) do
        if v13:IsA("ModuleScript") then
            local l_status_0, l_result_0 = pcall(require, v13);
            if l_status_0 and l_result_0.Data and l_result_0.Data.Type == "Fish" then
                table.insert(v11, l_result_0.Data.Name);
            end;
        end;
    end;
    table.sort(v11);
    _G.TierFish = {
        [1] = " ", 
        [2] = "Uncommon", 
        [3] = "Rare", 
        [4] = "Epic", 
        [5] = "Legendary", 
        [6] = "Mythic", 
        [7] = "Secret"
    };
    _G.WebhookRarities = _G.WebhookRarities or {};
    _G.WebhookNames = _G.WebhookNames or {};
    _G.Variant = {
        "Galaxy", 
        "Corrupt", 
        "Gemstone", 
        "Ghost", 
        "Lightning", 
        "Fairy Dust", 
        "Gold", 
        "Midnight", 
        "Radioactive", 
        "Stone", 
        "Holographic", 
        "Albino", 
        "Bloodmoon", 
        "Sandy", 
        "Acidic", 
        "Color Burn", 
        "Festive", 
        "Frozen"
    };
    toSet = function(v16) --[[ Line: 0 ]] --[[ Name:  ]]
        local v17 = {};
        if type(v16) == "table" then
            for _, v19 in ipairs(v16) do
                v17[v19] = true;
            end;
            for v20, v21 in pairs(v16) do
                if v21 then
                    v17[v20] = true;
                end;
            end;
        end;
        return v17;
    end;
    local v22 = {};
    v6.Events.REFavChg.OnClientEvent:Connect(function(v23, v24) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v22 (ref)
        rawset(v22, v23, v24);
    end);
    checkAndFavorite = function(v25) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v5 (ref), v22 (ref), v6 (ref)
        if not v8.autoFavEnabled then
            return;
        else
            local v26 = v5.ItemUtility.GetItemDataFromItemType("Items", v25.Id);
            if not v26 or v26.Data.Type ~= "Fish" then
                return;
            else
                local v27 = _G.TierFish[v26.Data.Tier];
                local l_Name_0 = v26.Data.Name;
                local v29 = v25.Metadata and v25.Metadata.VariantId or "None";
                local v30 = v8.selectedName[l_Name_0];
                local v31 = v8.selectedRarity[v27];
                local v32 = v8.selectedVariant[v29];
                local v33 = rawget(v22, v25.UUID);
                if v33 == nil then
                    v33 = v25.Favorited;
                end;
                local v34 = false;
                if next(v8.selectedVariant) ~= nil and next(v8.selectedName) ~= nil then
                    v34 = v30 and v32;
                else
                    v34 = v30 or v31;
                end;
                if v34 and not v33 then
                    v6.Events.REFav:FireServer(v25.UUID);
                    rawset(v22, v25.UUID, true);
                end;
                return;
            end;
        end;
    end;
    scanInventory = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v7 (ref)
        if not v8.autoFavEnabled then
            return;
        else
            for _, v36 in ipairs(v7.Data:GetExpect({
                "Inventory", 
                "Items"
            })) do
                checkAndFavorite(v36);
            end;
            return;
        end;
    end;
    for _, v38 in ipairs(v0.RS.Items:GetChildren()) do
        if v38:IsA("ModuleScript") and v38.Name:match("Rod") then
            local l_status_1, l_result_1 = pcall(require, v38);
            if l_status_1 and typeof(l_result_1) == "table" and l_result_1.Data then
                local v41 = l_result_1.Data.Name or "Unknown";
                local v42 = l_result_1.Data.Id or "Unknown";
                local v43 = l_result_1.Price or 0;
                local v44 = v41:gsub("^!!!%s*", "");
                local v45 = v44 .. " ($" .. v43 .. ")";
                local v46 = {
                    Name = v44, 
                    Id = v42, 
                    Price = v43, 
                    Display = v45
                };
                v8.rods[v42] = v46;
                v8.rods[v44] = v46;
                table.insert(v8.rodDisplayNames, v45);
            end;
        end;
    end;
    BaitsFolder = v0.RS:WaitForChild("Baits");
    for _, v48 in ipairs(BaitsFolder:GetChildren()) do
        if v48:IsA("ModuleScript") then
            local l_status_2, l_result_2 = pcall(require, v48);
            if l_status_2 and typeof(l_result_2) == "table" and l_result_2.Data then
                local v51 = l_result_2.Data.Name or "Unknown";
                local v52 = l_result_2.Data.Id or "Unknown";
                local v53 = l_result_2.Price or 0;
                local v54 = v51 .. " ($" .. v53 .. ")";
                local v55 = {
                    Name = v51, 
                    Id = v52, 
                    Price = v53, 
                    Display = v54
                };
                v8.baits[v52] = v55;
                v8.baits[v51] = v55;
                table.insert(v8.baitDisplayNames, v54);
            end;
        end;
    end;
    _cleanName = function(v56) --[[ Line: 0 ]] --[[ Name:  ]]
        if type(v56) ~= "string" then
            return tostring(v56);
        else
            return v56:match("^(.-) %(") or v56;
        end;
    end;
    SavePosition = function(v57) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v3 (ref), v0 (ref)
        local v58 = {
            v57:GetComponents()
        };
        writefile(v3, v0.HttpService:JSONEncode(v58));
    end;
    LoadPosition = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v3 (ref), v0 (ref)
        if isfile(v3) then
            local l_status_3, l_result_3 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v0 (ref), v3 (ref)
                return v0.HttpService:JSONDecode(readfile(v3));
            end);
            if l_status_3 and typeof(l_result_3) == "table" then
                return CFrame.new(unpack(l_result_3));
            end;
        end;
        return nil;
    end;
    TeleportLastPos = function(v61) --[[ Line: 0 ]] --[[ Name:  ]]
        task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v61 (ref)
            local l_HumanoidRootPart_1 = v61:WaitForChild("HumanoidRootPart");
            local v63 = LoadPosition();
            if v63 then
                task.wait(2);
                l_HumanoidRootPart_1.CFrame = v63;
                chloex("Teleported to your last position...");
            end;
        end);
    end;
    l_LocalPlayer_0.CharacterAdded:Connect(TeleportLastPos);
    if l_LocalPlayer_0.Character then
        TeleportLastPos(l_LocalPlayer_0.Character);
    end;
    ignore = {
        Cloudy = true, 
        Day = true, 
        ["Increased Luck"] = true, 
        Mutated = true, 
        Night = true, 
        Snow = true, 
        ["Sparkling Cove"] = true, 
        Storm = true, 
        Wind = true, 
        UIListLayout = true, 
        ["Admin - Shocked"] = true, 
        ["Admin - Super Mutated"] = true, 
        Radiant = true
    };
    local function v65(v64) --[[ Line: 0 ]] --[[ Name:  ]]
        return v64 and (v64:FindFirstChild("HumanoidRootPart") or v64:FindFirstChildWhichIsA("BasePart"));
    end;
    local function v70(v66, v67) --[[ Line: 0 ]] --[[ Name:  ]]
        if not v66 then
            return;
        else
            for _, v69 in ipairs(v66:GetDescendants()) do
                if v69:IsA("BasePart") then
                    v69.Anchored = v67;
                end;
            end;
            return;
        end;
    end;
    local function v81(v71, v72, v73) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v0 (ref)
        if v8.flt and v8.con then
            v8.con:Disconnect();
        end;
        v8.flt = v73 or false;
        if v73 then
            local v74 = v71:FindFirstChild("FloatPart") or Instance.new("Part");
            local v75 = "FloatPart";
            local v76 = Vector3.new(3, 0.2, 3);
            local v77 = 1;
            local v78 = true;
            v74.CanCollide = true;
            v74.Anchored = v78;
            v74.Transparency = v77;
            v74.Size = v76;
            v74.Name = v75;
            v74.Parent = v71;
            do
                local l_v74_0 = v74;
                v8.con = v0.RunService.Heartbeat:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v71 (ref), v72 (ref), l_v74_0 (ref)
                    if v71 and v72 and l_v74_0 then
                        l_v74_0.CFrame = v72.CFrame * CFrame.new(0, -3.1, 0);
                    end;
                end);
            end;
        else
            local v80 = v71 and v71:FindFirstChild("FloatPart");
            if v80 then
                v80:Destroy();
            end;
        end;
    end;
    local function v87() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        local v82 = {};
        local l_Events_0 = v8.player:WaitForChild("PlayerGui"):FindFirstChild("Events");
        if l_Events_0 then
            l_Events_0 = l_Events_0:FindFirstChild("Frame") and l_Events_0.Frame:FindFirstChild("Events");
        end;
        if l_Events_0 then
            for _, v85 in ipairs(l_Events_0.GetChildren(l_Events_0)) do
                local v86 = v85:IsA("Frame") and v85:FindFirstChild("DisplayName") and v85.DisplayName.Text or v85.Name;
                if typeof(v86) == "string" and v86 ~= "" and not v8.ignore[v86] then
                    table.insert(v82, (v86:gsub("^Admin %- ", "")));
                end;
            end;
        end;
        return v82;
    end;
    local function v106(v88) --[[ Line: 0 ]] --[[ Name:  ]]
        if not v88 then
            return;
        elseif v88 == "Megalodon Hunt" then
            local l_workspace_FirstChild_0 = workspace:FindFirstChild("!!! MENU RINGS");
            if l_workspace_FirstChild_0 then
                for _, v91 in ipairs(l_workspace_FirstChild_0:GetChildren()) do
                    local l_v91_FirstChild_0 = v91:FindFirstChild("Megalodon Hunt");
                    local v93 = l_v91_FirstChild_0 and l_v91_FirstChild_0:FindFirstChild("Megalodon Hunt");
                    if v93 and v93:IsA("BasePart") then
                        return v93;
                    end;
                end;
            end;
            return;
        else
            local v94 = {
                workspace:FindFirstChild("Props")
            };
            local l_workspace_FirstChild_1 = workspace:FindFirstChild("!!! MENU RINGS");
            if l_workspace_FirstChild_1 then
                for _, v97 in ipairs(l_workspace_FirstChild_1:GetChildren()) do
                    if v97.Name:match("^Props") then
                        table.insert(v94, v97);
                    end;
                end;
            end;
            for _, v99 in ipairs(v94) do
                for _, v101 in ipairs(v99:GetChildren()) do
                    for _, v103 in ipairs(v101:GetDescendants()) do
                        if v103:IsA("TextLabel") and v103.Name == "DisplayName" and (v103.ContentText ~= "" and v103.ContentText or v103.Text):lower() == v88:lower() then
                            local l_v103_FirstAncestorOfClass_0 = v103:FindFirstAncestorOfClass("Model");
                            local v105 = l_v103_FirstAncestorOfClass_0 and l_v103_FirstAncestorOfClass_0:FindFirstChild("Part") or v101:FindFirstChild("Part");
                            if v105 and v105:IsA("BasePart") then
                                return v105;
                            end;
                        end;
                    end;
                end;
            end;
            return;
        end;
    end;
    local function v108(v107) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        if v8.lastState ~= v107 then
            chloex(v107);
            v8.lastState = v107;
        end;
    end;
    v8.loop = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v106 (ref), v65 (ref), v81 (ref), v70 (ref), v108 (ref)
        while v8.autoEventActive do
            local v109 = nil;
            local v110 = nil;
            if v8.priorityEvent then
                local v111 = v106(v8.priorityEvent);
                if v111 then
                    local l_v111_0 = v111;
                    v110 = v8.priorityEvent;
                    v109 = l_v111_0;
                end;
            end;
            if not v109 and #v8.selectedEvents > 0 then
                for _, v114 in ipairs(v8.selectedEvents) do
                    local v115 = v106(v114);
                    if v115 then
                        local l_v115_0 = v115;
                        v110 = v114;
                        v109 = l_v115_0;
                        break;
                    end;
                end;
            end;
            local v117 = v65(v8.player.Character);
            if v109 and v117 then
                if not v8.origCF then
                    v8.origCF = v117.CFrame;
                end;
                if (v117.Position - v109.Position).Magnitude > 40 then
                    v8.curCF = v109.CFrame + Vector3.new(0, v8.offs[v110] or 7, 0);
                    v8.player.Character:PivotTo(v8.curCF);
                    v81(v8.player.Character, v117, true);
                    task.wait(1);
                    v70(v8.player.Character, true);
                    v108("Event! " .. v110);
                end;
            elseif v109 == nil and v8.curCF and v117 then
                v70(v8.player.Character, false);
                v81(v8.player.Character, nil, false);
                if v8.origCF then
                    v8.player.Character:PivotTo(v8.origCF);
                    v108("Event end \226\134\146 Back");
                    v8.origCF = nil;
                end;
                v8.curCF = nil;
            elseif not v8.curCF then
                v108("Idle");
            end;
            task.wait(0.2);
        end;
        v70(v8.player.Character, false);
        v81(v8.player.Character, nil, false);
        if v8.origCF and v8.player.Character then
            v8.player.Character:PivotTo(v8.origCF);
            v108("Auto Event off");
        end;
        local l_v8_0 = v8;
        local l_v8_1 = v8;
        local v120 = nil;
        l_v8_1.curCF = nil;
        l_v8_0.origCF = v120;
    end;
    v8.player.CharacterAdded:Connect(function(v121) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v81 (ref), v70 (ref)
        if v8.autoEventActive then
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v121 (ref), v8 (ref), v81 (ref), v70 (ref)
                local v122 = v121:WaitForChild("HumanoidRootPart", 5);
                task.wait(0.3);
                if v122 then
                    if v8.curCF then
                        v121:PivotTo(v8.curCF);
                        v81(v121, v122, true);
                        task.wait(0.5);
                        v70(v121, true);
                        chloex("Respawn \226\134\146 Back");
                    elseif v8.origCF then
                        v121:PivotTo(v8.origCF);
                        v70(v121, false);
                        v81(v121, v122, true);
                        chloex("Back to farm");
                    end;
                end;
            end);
        end;
    end);
    local function v126() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref), l_LocalPlayer_0 (ref)
        local v123 = {};
        for _, v125 in ipairs(v0.Players:GetPlayers()) do
            if v125 ~= l_LocalPlayer_0 then
                table.insert(v123, v125.Name);
            end;
        end;
        return v123;
    end;
    local v127 = {
        ["Treasure Room"] = Vector3.new(-3602.01, -266.57, -1577.18), 
        ["Sisyphus Statue"] = Vector3.new(-3703.69, -135.57, -1017.17), 
        ["Crater Island Top"] = Vector3.new(1011.29, 22.68, 5076.27), 
        ["Crater Island Ground"] = Vector3.new(1079.57, 3.64, 5080.35), 
        ["Coral Reefs SPOT 1"] = Vector3.new(-3031.88, 2.52, 2276.36), 
        ["Coral Reefs SPOT 2"] = Vector3.new(-3270.86, 2.5, 2228.1), 
        ["Coral Reefs SPOT 3"] = Vector3.new(-3136.1, 2.61, 2126.11), 
        ["Lost Shore"] = Vector3.new(-3737.97, 5.43, -854.68), 
        ["Weather Machine"] = Vector3.new(-1524.88, 2.87, 1915.56), 
        ["Kohana Volcano"] = Vector3.new(-561.81, 21.24, 156.72), 
        ["Kohana SPOT 1"] = Vector3.new(-367.77, 6.75, 521.91), 
        ["Kohana SPOT 2"] = Vector3.new(-623.96, 19.25, 419.36), 
        ["Stingray Shores"] = Vector3.new(44.41, 28.83, 3048.93), 
        ["Tropical Grove"] = Vector3.new(-2018.91, 9.04, 3750.59), 
        ["Ice Sea"] = Vector3.new(2164, 7, 3269), 
        ["Tropical Grove Cave 1"] = Vector3.new(-2151, 3, 3671), 
        ["Tropical Grove Cave 2"] = Vector3.new(-2018, 5, 3756), 
        ["Tropical Grove Highground"] = Vector3.new(-2139, 53, 3624), 
        ["Fisherman Island Underground"] = Vector3.new(-62, 3, 2846), 
        ["Fisherman Island Mid"] = Vector3.new(33, 3, 2764), 
        ["Fisherman Island Rift Left"] = Vector3.new(-26, 10, 2686), 
        ["Fisherman Island Rift Right"] = Vector3.new(95, 10, 2684), 
        ["Secred Temple"] = Vector3.new(1475, -22, -632), 
        ["Ancient Jungle Outside"] = Vector3.new(1488, 8, -392), 
        ["Ancient Jungle"] = Vector3.new(1274, 8, -184), 
        ["Underground Cellar"] = Vector3.new(2136, -91, -699), 
        ["Crystaline Pessage"] = Vector3.new(6051, -539, 4386), 
        ["Ancient Ruin"] = Vector3.new(6090, -586, 4634)
    };
    locationNames = {};
    for v128 in pairs(v127) do
        table.insert(locationNames, v128);
    end;
    table.sort(locationNames, function(v129, v130) --[[ Line: 0 ]] --[[ Name:  ]]
        return v129:lower() < v130:lower();
    end);
    local function v135() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v5 (ref), v8 (ref)
        for _, v132 in ipairs({
            v5.Net["RE/ObtainedNewFishNotification"], 
            v5.Net["RE/TextNotification"], 
            v5.Net["RE/ClaimNotification"]
        }) do
            for _, v134 in ipairs(getconnections(v132.OnClientEvent)) do
                v134:Disconnect();
                table.insert(v8.notifConnections, v134);
            end;
        end;
    end;
    local function v136() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        v8.notifConnections = {};
    end;
    local v137 = loadstring(game:HttpGet("https://raw.githubusercontent.com/TesterX14/XXXX/refs/heads/main/Library"))():Window({
        Title = "OGHub |", 
        Footer = "Version 2.0.0", 
        Image = "132435516080103", 
        Color = Color3.fromRGB(0, 208, 255), 
        Theme = 9542022979, 
        Version = 3
    });
    if v137 then
        chloex("Window loaded!");
    end;
    local v138 = {
        Info = v137:AddTab({
            Name = "Info", 
            Icon = "player"
        }), 
        Main = v137:AddTab({
            Name = "Fishing", 
            Icon = "rbxassetid://97167558235554"
        }), 
        Auto = v137:AddTab({
            Name = "Automatically", 
            Icon = "next"
        }), 
        Trade = v137:AddTab({
            Name = "Trading", 
            Icon = "rbxassetid://114581487428395"
        }), 
        Farm = v137:AddTab({
            Name = "Menu", 
            Icon = "rbxassetid://140165584241571"
        }), 
        Quest = v137:AddTab({
            Name = "Quest", 
            Icon = "scroll"
        }), 
        Tele = v137:AddTab({
            Name = "Teleport", 
            Icon = "rbxassetid://18648122722"
        }), 
        Webhook = v137:AddTab({
            Name = "Webhook", 
            Icon = "rbxassetid://137601480983962"
        }), 
        Misc = v137:AddTab({
            Name = "Misc", 
            Icon = "rbxassetid://6034509993"
        })
    };
    local v139 = "https://raw.githubusercontent.com/ChloeRewite/test/refs/heads/main/2.lua";
    local l_status_4, l_result_4 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v139 (ref)
        local v140 = game:HttpGet(v139);
        local v141, v142 = loadstring(v140);
        if not v141 then
            error(v142);
        end;
        return v141();
    end);
    if l_status_4 and type(l_result_4) == "function" then
        pcall(l_result_4, v137, v138);
    end;
    Fish = v138.Main:AddSection("Fishing Features");
    DetectorParagraph = Fish:AddParagraph({
        Title = "Detector Stuck", 
        Content = "Status = Idle\nTime = 0.0s\nBag = 0"
    });
    Fish:AddSlider({
        Title = "Wait (s)", 
        Default = 15, 
        Min = 10, 
        Max = 25, 
        Rounding = 0, 
        Callback = function(v145) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.stuckThreshold = v145;
        end
    });
    Fish:AddToggle({
        Title = "Start Detector", 
        Content = "Detector if fishing got stuck! this feature helpful", 
        Default = false, 
        Callback = function(v146) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            v8.supportEnabled = v146;
            if v146 then
                v8.char = v8.player.Character or v8.player.CharacterAdded:Wait();
                v8.savedCFrame = v8.char:WaitForChild("HumanoidRootPart").CFrame;
                _G.Celestial.DetectorCount = getFishCount();
                local l_v8_2 = v8;
                local l_v8_3 = v8;
                local v149 = 0;
                l_v8_3.equipTimer = 0;
                l_v8_2.fishingTimer = v149;
                l_v8_2 = "Idle";
                l_v8_3 = "255,255,255";
                v149 = 0;
                do
                    local l_l_v8_2_0, l_l_v8_3_0, l_v149_0 = l_v8_2, l_v8_3, v149;
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v8 (ref), l_v149_0 (ref), l_l_v8_2_0 (ref), l_l_v8_3_0 (ref), v6 (ref)
                        while v8.supportEnabled do
                            local l_status_5, l_result_5 = pcall(getFishCount);
                            if not l_status_5 or not l_result_5 then
                                DetectorParagraph:SetContent("<font color='rgb(255,69,0)'>Status = Error Reading Count</font>\nTime = 0.0s\nBag = 0");
                                task.wait(1);
                                v8.fishingTimer = 0;
                            else
                                task.wait(0.1);
                                l_v149_0 = l_v149_0 + 1;
                                v8.equipTimer = v8.equipTimer + 0.1;
                                v8.fishingTimer = v8.fishingTimer + 0.1;
                                if l_v149_0 % 30000 == 0 then
                                    task.wait(5);
                                    collectgarbage("collect");
                                    l_v149_0 = 0;
                                end;
                                if not v8.char or not v8.char.Parent then
                                    v8.char = v8.player.Character or v8.player.CharacterAdded:Wait();
                                end;
                                if _G.Celestial.DetectorCount < l_result_5 then
                                    _G.Celestial.DetectorCount = l_result_5;
                                    v8.fishingTimer = 0;
                                    l_l_v8_2_0 = "Fishing Normaly";
                                    l_l_v8_3_0 = "0,255,127";
                                elseif l_result_5 < _G.Celestial.DetectorCount then
                                    _G.Celestial.DetectorCount = l_result_5;
                                    l_l_v8_2_0 = "Bag Update";
                                    l_l_v8_3_0 = "173,216,230";
                                elseif v8.fishingTimer >= (v8.stuckThreshold or 10) then
                                    l_l_v8_2_0 = "STUCK! Resetting...";
                                    l_l_v8_3_0 = "255,69,0";
                                    chloex("Fishing Stuck! Resetting...", 3);
                                    local v155 = v8.char and v8.char:FindFirstChild("HumanoidRootPart");
                                    if v155 then
                                        v8.savedCFrame = v155.CFrame;
                                    end;
                                    v8.player.Character:BreakJoints();
                                    v8.char = v8.player.CharacterAdded:Wait();
                                    v8.char:WaitForChild("HumanoidRootPart").CFrame = v8.savedCFrame;
                                    task.wait(0.2);
                                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: v6 (ref)
                                        v6.Events.REEquip:FireServer(1);
                                    end);
                                    v8.fishingTimer = 0;
                                    _G.Celestial.DetectorCount = getFishCount();
                                    l_l_v8_2_0 = "Idle";
                                    l_l_v8_3_0 = "255,255,255";
                                end;
                                DetectorParagraph:SetContent(string.format("<font color='rgb(%s)'>Status = %s</font>\n<font color='rgb(0,191,255)'>Time = %.1fs</font>\n<font color='rgb(173,216,230)'>Bag = %d</font>", l_l_v8_3_0, l_l_v8_2_0, v8.fishingTimer, l_result_5));
                            end;
                        end;
                        DetectorParagraph:SetContent("<font color='rgb(200,200,200)'>Status = Detector Offline</font>\nTime = 0.0s\nBag = 0");
                    end);
                end;
            else
                DetectorParagraph:SetContent("<font color='rgb(200,200,200)'>Status = Detector Offline</font>\nTime = 0.0s\nBag = 0");
            end;
        end
    });
    Fish:AddDivider();
    Fish:AddInput({
        Title = "Legit Delay", 
        Content = "Delay complete fishing!", 
        Value = tostring(_G.Delay), 
        Callback = function(v156) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v5 (ref), v6 (ref)
            local v157 = tonumber(v156);
            if v157 and v157 > 0 then
                _G.Delay = v157;
                SaveConfig();
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v5 (ref), v6 (ref)
                    print("Started");
                    while true do
                        if v5.FishingController and v5.FishingController._autoLoop then
                            local l_FishingController_0 = v5.FishingController;
                            if l_FishingController_0:GetCurrentGUID() then
                                print("Waiting", _G.Delay);
                                task.wait(_G.Delay);
                                while true do
                                    local l_status_6, l_result_6 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: v6 (ref)
                                        v6.Events.REFishDone:FireServer();
                                    end);
                                    if l_status_6 then
                                        print("Successfully");
                                    else
                                        warn("Failed to Fire REFishDone:", l_result_6);
                                    end;
                                    task.wait(0.05);
                                    if not l_FishingController_0:GetCurrentGUID() or not l_FishingController_0._autoLoop then
                                        print("loop ended");
                                        break;
                                    end;
                                end;
                            end;
                        end;
                        task.wait(0.05);
                    end;
                end);
            else
                warn("Invalid fishing delay input");
            end;
        end
    });
    shakeDelay = 0;
    Fish:AddInput({
        Title = "Shake Delay", 
        Value = tostring(shakeDelay), 
        Callback = function(v161) --[[ Line: 0 ]] --[[ Name:  ]]
            local v162 = tonumber(v161);
            if v162 and v162 >= 0 then
                shakeDelay = v162;
            end;
        end
    });
    userId = tostring(v0.Players.LocalPlayer.UserId);
    local v163 = nil;
    local l_status_7, l_result_7 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
        return workspace:FindFirstChild("CosmeticFolder");
    end);
    if l_status_7 and l_result_7 then
        v163 = l_result_7;
    end;
    Fish:AddDropdown({
        Title = "Legit Mode", 
        Options = {
            "Always Perfect", 
            "Normal"
        }, 
        Default = "Always Perfect", 
        Multi = false, 
        Callback = function(v166) --[[ Line: 0 ]] --[[ Name:  ]]
            selectedMode = v166;
        end
    });
    tryCast = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref), v5 (ref)
        local l_PG_0 = v0.PG;
        local l_Camera_0 = v0.Camera;
        local l_VIM_0 = v0.VIM;
        local l_LocalPlayer_1 = game:GetService("Players").LocalPlayer;
        local v171 = Vector2.new(l_Camera_0.ViewportSize.X / 2, l_Camera_0.ViewportSize.Y / 2);
        local v172 = nil;
        while v5.FishingController._autoLoop do
            if v5.FishingController:GetCurrentGUID() then
                task.wait(0.05);
            else
                l_VIM_0:SendMouseButtonEvent(v171.X, v171.Y, 0, true, game, 1);
                task.wait(0.05);
                local l_Bar_0 = l_PG_0:WaitForChild("Charge"):WaitForChild("Main"):WaitForChild("CanvasGroup"):WaitForChild("Bar");
                local v174 = tick();
                while l_Bar_0:IsDescendantOf(l_PG_0) and l_Bar_0.Size.Y.Scale < 0.95 do
                    task.wait(0.001);
                    if tick() - v174 > 1 then
                        break;
                    end;
                end;
                l_VIM_0:SendMouseButtonEvent(v171.X, v171.Y, 0, false, game, 1);
                local v175 = tick();
                local v176 = false;
                while tick() - v175 < 3 do
                    local l_CurrentGUID_0 = v5.FishingController:GetCurrentGUID();
                    if l_CurrentGUID_0 and l_CurrentGUID_0 ~= v172 then
                        v176 = true;
                        print("[DEBUG] Shake detected! GUID:", l_CurrentGUID_0);
                        v172 = l_CurrentGUID_0;
                        break;
                    else
                        task.wait(0.05);
                    end;
                end;
                if v176 then
                    local v178 = l_LocalPlayer_1.leaderstats and l_LocalPlayer_1.leaderstats.Caught.Value or 0;
                    local v179 = tick();
                    while tick() - v179 < 8 and (not l_LocalPlayer_1.leaderstats or v178 >= l_LocalPlayer_1.leaderstats.Caught.Value) and v5.FishingController:GetCurrentGUID() do
                        task.wait(0.1);
                    end;
                    while v5.FishingController:GetCurrentGUID() do
                        task.wait(0.05);
                    end;
                    task.wait(1.3);
                end;
            end;
            task.wait(0.05);
        end;
    end;
    Fish:AddToggle({
        Title = "Legit Fishing", 
        Content = "Auto fishing with animation", 
        Default = false, 
        Callback = function(v180) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v5 (ref), v163 (ref), v6 (ref), v0 (ref)
            local l_FishingController_1 = v5.FishingController;
            local l_v163_0 = v163;
            local l_userId_0 = userId;
            local l_v180_0 = v180;
            l_FishingController_1._autoLoop = v180;
            if v180 then
                if selectedMode == "Always Perfect" then
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v180_0 (ref), l_FishingController_1 (ref), l_v163_0 (ref), l_userId_0 (ref), v6 (ref)
                        local v185 = false;
                        while l_v180_0 and l_FishingController_1._autoLoop do
                            if not l_v163_0:FindFirstChild(l_userId_0) then
                                repeat
                                    tryCast();
                                    task.wait(0.1);
                                until l_v163_0:FindFirstChild(l_userId_0) or not l_FishingController_1._autoLoop;
                            end;
                            while l_v163_0:FindFirstChild(l_userId_0) and l_FishingController_1._autoLoop do
                                if l_FishingController_1:GetCurrentGUID() then
                                    local v186 = tick();
                                    while l_FishingController_1:GetCurrentGUID() and l_FishingController_1._autoLoop do
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: l_FishingController_1 (ref)
                                            l_FishingController_1:RequestFishingMinigameClick();
                                        end);
                                        if tick() - v186 >= _G.Delay then
                                            task.wait(_G.Delay);
                                            repeat
                                                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                                    -- upvalues: v6 (ref)
                                                    v6.Events.REFishDone:FireServer();
                                                end);
                                                task.wait(0.05);
                                                v185 = not l_FishingController_1:GetCurrentGUID() or not l_FishingController_1._autoLoop;
                                            until v185;
                                        else
                                            task.wait();
                                        end;
                                        if v185 then
                                            break;
                                        end;
                                    end;
                                end;
                                v185 = false;
                                task.wait(0.2);
                            end;
                            repeat
                                task.wait(0.1);
                            until not l_v163_0:FindFirstChild(l_userId_0) or not l_FishingController_1._autoLoop;
                            if l_FishingController_1._autoLoop then
                                task.wait(0.2);
                                tryCast();
                            end;
                            task.wait(0.2);
                        end;
                    end);
                elseif selectedMode == "Normal" then
                    if not l_FishingController_1._oldGetPower then
                        l_FishingController_1._oldGetPower = l_FishingController_1._getPower;
                    end;
                    l_FishingController_1._getPower = function() --[[ Line: 0 ]] --[[ Name:  ]]
                        return 0.999;
                    end;
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v180_0 (ref), l_FishingController_1 (ref), v6 (ref), v0 (ref)
                        while l_v180_0 and l_FishingController_1._autoLoop do
                            if _G.ShakeEnabled and l_FishingController_1:GetCurrentGUID() then
                                local v187 = tick();
                                while l_FishingController_1:GetCurrentGUID() and l_FishingController_1._autoLoop and _G.ShakeEnabled do
                                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: l_FishingController_1 (ref)
                                        l_FishingController_1:RequestFishingMinigameClick();
                                    end);
                                    if tick() - v187 >= (_G.Delay or 1) then
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref)
                                            v6.Events.REFishDone:FireServer();
                                        end);
                                        task.wait(0.1);
                                        if not l_FishingController_1:GetCurrentGUID() or not l_FishingController_1._autoLoop or not _G.ShakeEnabled then
                                            break;
                                        end;
                                    end;
                                    task.wait(0.1);
                                end;
                            elseif not l_FishingController_1:GetCurrentGUID() then
                                local v188 = Vector2.new(v0.Camera.ViewportSize.X / 2, v0.Camera.ViewportSize.Y / 2);
                                do
                                    local l_v188_0 = v188;
                                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: l_FishingController_1 (ref), l_v188_0 (ref)
                                        l_FishingController_1:RequestChargeFishingRod(l_v188_0, true);
                                    end);
                                    task.wait(0.25);
                                end;
                            end;
                            task.wait(0.05);
                        end;
                    end);
                end;
            else
                l_FishingController_1._autoLoop = false;
                if l_FishingController_1._oldGetPower then
                    l_FishingController_1._getPower = l_FishingController_1._oldGetPower;
                    l_FishingController_1._oldGetPower = nil;
                end;
            end;
        end
    });
    Fish:AddToggle({
        Title = "Auto Shake", 
        Content = "Spam click during fishing (only legit)", 
        Default = false, 
        Callback = function(v190) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v5 (ref), v0 (ref)
            v5._autoShake = v190;
            local l_FirstChild_0 = v0.PG:FindFirstChild("!!! Click Effect");
            if v190 then
                if l_FirstChild_0 then
                    l_FirstChild_0.Enabled = false;
                end;
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v5 (ref)
                    while v5._autoShake do
                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: v5 (ref)
                            v5.FishingController:RequestFishingMinigameClick();
                        end);
                        task.wait(shakeDelay);
                    end;
                end);
            elseif l_FirstChild_0 then
                l_FirstChild_0.Enabled = true;
            end;
        end
    });
    Fish:AddDivider();
    Fish:AddInput({
        Title = "Delay Complete", 
        Value = tostring(_G.DelayComplete), 
        Callback = function(v192) --[[ Line: 0 ]] --[[ Name:  ]]
            local v193 = tonumber(v192);
            if v193 and v193 >= 0 then
                _G.DelayComplete = v193;
                SaveConfig();
            end;
        end
    });
    Fish:AddToggle({
        Title = "Instant Fishing", 
        Content = "Auto instantly catch fish", 
        Default = false, 
        Callback = function(v194) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            v8.autoInstant = v194;
            if v194 then
                _G.Celestial.InstantCount = getFishCount();
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v8 (ref), v6 (ref)
                    while v8.autoInstant do
                        if v8.canFish then
                            v8.canFish = false;
                            local v195, _, v197 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                -- upvalues: v6 (ref)
                                return v6.Functions.ChargeRod:InvokeServer(workspace:GetServerTimeNow());
                            end);
                            do
                                local l_v197_0 = v197;
                                if v195 and typeof(l_v197_0) == "number" then
                                    local v199 = -1;
                                    local v200 = 0.999;
                                    task.wait(0.3);
                                    do
                                        local l_v199_0, l_v200_0 = v199, v200;
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref), l_v199_0 (ref), l_v200_0 (ref), l_v197_0 (ref)
                                            v6.Functions.StartMini:InvokeServer(l_v199_0, l_v200_0, l_v197_0);
                                        end);
                                        local v203 = tick();
                                        repeat
                                            task.wait(0.05);
                                        until _G.FishMiniData and _G.FishMiniData.LastShift or tick() - v203 > 1;
                                        task.wait(_G.DelayComplete);
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref)
                                            v6.Events.REFishDone:FireServer();
                                        end);
                                        local v204 = getFishCount();
                                        local v205 = tick();
                                        repeat
                                            task.wait(0.05);
                                        until v204 < getFishCount() or tick() - v205 > 1;
                                    end;
                                end;
                                v8.canFish = true;
                            end;
                        end;
                        task.wait(0.05);
                    end;
                end);
            end;
        end
    });
    if MiniEvent then
        if _G._MiniEventConn then
            _G._MiniEventConn:Disconnect();
        end;
        _G._MiniEventConn = MiniEvent.OnClientEvent:Connect(function(v206, v207) --[[ Line: 0 ]] --[[ Name:  ]]
            if v206 and v207 then
                _G.FishMiniData = v207;
            end;
        end);
    end;
    Fish:AddSubSection("Blatant Features [BETA]");
    Fastest = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v6 (ref)
        task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v6 (ref)
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Functions.Cancel:InvokeServer();
            end);
            local l_workspace_ServerTimeNow_0 = workspace:GetServerTimeNow();
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref), l_workspace_ServerTimeNow_0 (ref)
                v6.Functions.ChargeRod:InvokeServer(l_workspace_ServerTimeNow_0);
            end);
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Functions.StartMini:InvokeServer(-1, 0.999);
            end);
            task.wait(_G.FishingDelay);
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Events.REFishDone:FireServer();
            end);
        end);
    end;
    RandomResult = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v6 (ref)
        task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v6 (ref)
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Functions.Cancel:InvokeServer();
            end);
            local l_workspace_ServerTimeNow_1 = workspace:GetServerTimeNow();
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref), l_workspace_ServerTimeNow_1 (ref)
                v6.Functions.ChargeRod:InvokeServer(l_workspace_ServerTimeNow_1);
            end);
            task.wait(0.2);
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Functions.StartMini:InvokeServer(-1, 0.999);
            end);
            task.wait(_G.FishingDelay);
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Events.REFishDone:FireServer();
            end);
        end);
    end;
    selectedMode = "Fast";
    Fish:AddDropdown({
        Title = "Fishing Mode", 
        Options = {
            "Fast", 
            "Random Result"
        }, 
        Default = "Fast", 
        Multi = false, 
        Callback = function(v210) --[[ Line: 0 ]] --[[ Name:  ]]
            selectedMode = v210;
        end
    });
    Fish:AddInput({
        Title = "Delay Reel", 
        Value = tostring(_G.Reel), 
        Default = "1.9", 
        Callback = function(v211) --[[ Line: 0 ]] --[[ Name:  ]]
            local v212 = tonumber(v211);
            if v212 and v212 > 0 then
                _G.Reel = v212;
            end;
            SaveConfig();
        end
    });
    Fish:AddInput({
        Title = "Delay Fishing", 
        Value = tostring(_G.FishingDelay), 
        Default = "1.1", 
        Callback = function(v213) --[[ Line: 0 ]] --[[ Name:  ]]
            local v214 = tonumber(v213);
            if v214 and v214 > 0 then
                _G.FishingDelay = v214;
            end;
            SaveConfig();
        end
    });
    Fish:AddToggle({
        Title = "Blatant Fishing", 
        Default = _G.FBlatant, 
        Callback = function(v215) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.FBlatant = v215;
            if v215 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    while _G.FBlatant do
                        if selectedMode == "Fast" then
                            Fastest();
                        elseif selectedMode == "Random Result" then
                            RandomResult();
                        end;
                        task.wait(_G.Reel);
                    end;
                end);
            end;
        end
    });
    Fish:AddButton({
        Title = "Recovery Fishing", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v6 (ref)
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref)
                v6.Functions.Cancel:InvokeServer();
                chloex("Recovery Successfully!");
            end);
        end
    });
    Fish:AddSubSection("Utility Player");
    Fish:AddToggle({
        Title = "Auto Equip Rod", 
        Content = "Automatically equip your fishing rod", 
        Default = false, 
        Callback = function(v216) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v7 (ref), v5 (ref), v6 (ref)
            v8.autoEquipRod = v216;
            local function v221() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v7 (ref), v5 (ref)
                local v217 = v7.Data:Get("EquippedId");
                if not v217 then
                    return false;
                else
                    local l_ItemFromInventory_0 = v5.PlayerStatsUtility:GetItemFromInventory(v7.Data, function(v218) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v217 (ref)
                        return v218.UUID == v217;
                    end);
                    if not l_ItemFromInventory_0 then
                        return false;
                    else
                        local l_ItemData_0 = v5.ItemUtility:GetItemData(l_ItemFromInventory_0.Id);
                        return l_ItemData_0 and l_ItemData_0.Data.Type == "Fishing Rods";
                    end;
                end;
            end;
            local function v222() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v221 (ref), v6 (ref)
                if not v221() then
                    v6.Events.REEquip:FireServer(1);
                end;
            end;
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref), v222 (ref)
                while v8.autoEquipRod do
                    v222();
                    task.wait(1);
                end;
            end);
        end
    });
    Fish:AddToggle({
        Title = "No Fishing Animations", 
        Default = false, 
        Callback = function(v223) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: l_LocalPlayer_0 (ref), v8 (ref)
            local l_Animator_0 = (l_LocalPlayer_0.Character or l_LocalPlayer_0.CharacterAdded:Wait()):WaitForChild("Humanoid"):FindFirstChildOfClass("Animator");
            if not l_Animator_0 then
                return;
            else
                if v223 then
                    v8.stopAnimHookEnabled = true;
                    for _, v226 in ipairs(l_Animator_0:GetPlayingAnimationTracks()) do
                        v226:Stop(0);
                    end;
                    v8.stopAnimConn = l_Animator_0.AnimationPlayed:Connect(function(v227) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v8 (ref)
                        if v8.stopAnimHookEnabled then
                            task.defer(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                -- upvalues: v227 (ref)
                                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                    -- upvalues: v227 (ref)
                                    v227:Stop(0);
                                end);
                            end);
                        end;
                    end);
                else
                    v8.stopAnimHookEnabled = false;
                    if v8.stopAnimConn then
                        v8.stopAnimConn:Disconnect();
                        v8.stopAnimConn = nil;
                    end;
                end;
                return;
            end;
        end
    });
    local v228 = false;
    local v229 = nil;
    local v230 = nil;
    local v231 = -1.8;
    do
        local l_v228_0, l_v229_0, l_v230_0, l_v231_0 = v228, v229, v230, v231;
        Fish:AddToggle({
            Title = "Walk on Water", 
            Default = false, 
            Callback = function(v236) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: l_v228_0 (ref), l_LocalPlayer_0 (ref), l_v229_0 (ref), l_v230_0 (ref), v0 (ref), l_v231_0 (ref)
                l_v228_0 = v236;
                local l_HumanoidRootPart_2 = (l_LocalPlayer_0.Character or l_LocalPlayer_0.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart");
                if v236 then
                    l_v229_0 = Instance.new("Part");
                    l_v229_0.Name = "WW_Part";
                    l_v229_0.Size = Vector3.new(15, 1, 15);
                    l_v229_0.Anchored = true;
                    l_v229_0.CanCollide = false;
                    l_v229_0.Transparency = 1;
                    l_v229_0.Material = Enum.Material.SmoothPlastic;
                    l_v229_0.Parent = workspace;
                    l_v230_0 = v0.RunService.Heartbeat:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v228_0 (ref), l_v229_0 (ref), l_HumanoidRootPart_2 (ref), l_v231_0 (ref)
                        if not l_v228_0 or not l_v229_0 or not l_HumanoidRootPart_2 then
                            return;
                        else
                            l_v229_0.Position = Vector3.new(l_HumanoidRootPart_2.Position.X, l_v231_0, l_HumanoidRootPart_2.Position.Z);
                            l_v229_0.CanCollide = l_HumanoidRootPart_2.Position.Y > l_v231_0;
                            return;
                        end;
                    end);
                else
                    if l_v230_0 then
                        l_v230_0:Disconnect();
                        l_v230_0 = nil;
                    end;
                    if l_v229_0 then
                        l_v229_0:Destroy();
                        l_v229_0 = nil;
                    end;
                end;
            end
        });
    end;
    Fish:AddToggle({
        Title = "Freeze Player", 
        Content = "Freeze only if rod is equipped", 
        Default = false, 
        Callback = function(v238) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v7 (ref), v5 (ref), v6 (ref)
            v8.frozen = v238;
            local l_Character_0 = v8.player.Character;
            local function v244() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v7 (ref), v5 (ref)
                local v240 = v7.Data:Get("EquippedId");
                if not v240 then
                    return false;
                else
                    local l_ItemFromInventory_1 = v5.PlayerStatsUtility:GetItemFromInventory(v7.Data, function(v241) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v240 (ref)
                        return v241.UUID == v240;
                    end);
                    if not l_ItemFromInventory_1 then
                        return false;
                    else
                        local l_ItemData_1 = v5.ItemUtility:GetItemData(l_ItemFromInventory_1.Id);
                        return l_ItemData_1 and l_ItemData_1.Data.Type == "Fishing Rods";
                    end;
                end;
            end;
            local function v245() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v244 (ref), v6 (ref)
                if not v244() then
                    v6.Events.REEquip:FireServer(1);
                    task.wait(0.5);
                end;
            end;
            local function v250(v246, v247) --[[ Line: 0 ]] --[[ Name:  ]]
                if not v246 then
                    return;
                else
                    for _, v249 in ipairs(v246:GetDescendants()) do
                        if v249:IsA("BasePart") then
                            v249.Anchored = v247;
                        end;
                    end;
                    return;
                end;
            end;
            local function v252(v251) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref), v245 (ref), v244 (ref), v250 (ref)
                if v8.frozen then
                    v245();
                    if v244() then
                        v250(v251, true);
                    end;
                else
                    v250(v251, false);
                end;
            end;
            v252(l_Character_0);
            v8.player.CharacterAdded:Connect(function(v253) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v252 (ref)
                task.wait(1);
                v252(v253);
            end);
        end
    });
    v228 = v138.Main:AddSection("Panel Support Features");
    v228:AddToggle({
        Title = "Show Fishing Panel", 
        Default = false, 
        Callback = function(v254) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            if v254 then
                local l_LocalPlayer_2 = game:GetService("Players").LocalPlayer;
                if game.CoreGui:FindFirstChild("ChloeX_FishingPanel") then
                    game.CoreGui:FindFirstChild("ChloeX_FishingPanel"):Destroy();
                end;
                local l_ScreenGui_0 = Instance.new("ScreenGui");
                l_ScreenGui_0.Name = "ChloeX_FishingPanel";
                l_ScreenGui_0.IgnoreGuiInset = true;
                l_ScreenGui_0.ResetOnSpawn = false;
                l_ScreenGui_0.ZIndexBehavior = Enum.ZIndexBehavior.Global;
                l_ScreenGui_0.Parent = game.CoreGui;
                local v257 = Instance.new("Frame", l_ScreenGui_0);
                v257.Size = UDim2.new(0, 400, 0, 210);
                v257.AnchorPoint = Vector2.new(0.5, 0.5);
                v257.Position = UDim2.new(0.5, 0, 0.5, 0);
                v257.BackgroundColor3 = Color3.fromRGB(20, 22, 35);
                v257.BorderSizePixel = 0;
                v257.BackgroundTransparency = 0.05;
                v257.Active = true;
                v257.Draggable = true;
                local v258 = Instance.new("UIStroke", v257);
                v258.Thickness = 2;
                v258.Color = Color3.fromRGB(80, 150, 255);
                v258.Transparency = 0.35;
                Instance.new("UICorner", v257).CornerRadius = UDim.new(0, 14);
                local v259 = Instance.new("ImageLabel", v257);
                v259.Size = UDim2.new(0, 28, 0, 28);
                v259.Position = UDim2.new(0, 10, 0, 6);
                v259.BackgroundTransparency = 1;
                v259.Image = "rbxassetid://100076212630732";
                v259.ScaleType = Enum.ScaleType.Fit;
                local v260 = Instance.new("TextLabel", v257);
                v260.Size = UDim2.new(1, -40, 0, 36);
                v260.Position = UDim2.new(0, 45, 0, 5);
                v260.BackgroundTransparency = 1;
                v260.Font = Enum.Font.GothamBold;
                v260.Text = "CHLOEX PANEL FISHING";
                v260.TextSize = 22;
                v260.TextColor3 = Color3.fromRGB(255, 255, 255);
                v260.TextXAlignment = Enum.TextXAlignment.Left;
                local v261 = Instance.new("UIGradient", v260);
                v261.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 220, 255)), 
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 120, 255)), 
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 220, 255))
                });
                v261.Rotation = 45;
                local v262 = Instance.new("TextLabel", v257);
                v262.Position = UDim2.new(0, 15, 0, 55);
                v262.Size = UDim2.new(1, -30, 0, 22);
                v262.Font = Enum.Font.GothamBold;
                v262.TextSize = 18;
                v262.BackgroundTransparency = 1;
                v262.TextColor3 = Color3.fromRGB(140, 200, 255);
                v262.Text = "INVENTORY COUNT:";
                local v263 = Instance.new("TextLabel", v257);
                v263.Position = UDim2.new(0, 15, 0, 75);
                v263.Size = UDim2.new(1, -30, 0, 22);
                v263.Font = Enum.Font.Gotham;
                v263.TextSize = 18;
                v263.BackgroundTransparency = 1;
                v263.TextColor3 = Color3.fromRGB(255, 255, 255);
                v263.Text = "Fish: 0/0";
                local v264 = Instance.new("TextLabel", v257);
                v264.Position = UDim2.new(0, 15, 0, 105);
                v264.Size = UDim2.new(1, -30, 0, 22);
                v264.Font = Enum.Font.GothamBold;
                v264.TextSize = 18;
                v264.BackgroundTransparency = 1;
                v264.TextColor3 = Color3.fromRGB(140, 200, 255);
                v264.Text = "TOTAL FISH CAUGHT:";
                local v265 = Instance.new("TextLabel", v257);
                v265.Position = UDim2.new(0, 15, 0, 125);
                v265.Size = UDim2.new(1, -30, 0, 22);
                v265.Font = Enum.Font.Gotham;
                v265.TextSize = 18;
                v265.BackgroundTransparency = 1;
                v265.TextColor3 = Color3.fromRGB(255, 255, 255);
                v265.Text = "Value: 0";
                local v266 = Instance.new("TextLabel", v257);
                v266.Position = UDim2.new(0.5, 0, 0, 165);
                v266.AnchorPoint = Vector2.new(0.5, 0);
                v266.Size = UDim2.new(0.8, 0, 0, 30);
                v266.Font = Enum.Font.GothamBold;
                v266.TextSize = 22;
                v266.Text = "FISHING NORMAL";
                v266.BackgroundTransparency = 1;
                v266.TextColor3 = Color3.fromRGB(0, 255, 100);
                local l_Value_0 = l_LocalPlayer_2.leaderstats.Caught.Value;
                local v268 = tick();
                local v269 = false;
                v8.fishingPanelRunning = true;
                do
                    local l_l_LocalPlayer_2_0, l_v263_0, l_v265_0, l_v266_0, l_l_Value_0_0, l_v268_0, l_v269_0 = l_LocalPlayer_2, v263, v265, v266, l_Value_0, v268, v269;
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v8 (ref), l_l_LocalPlayer_2_0 (ref), l_v263_0 (ref), l_v265_0 (ref), l_l_Value_0_0 (ref), l_v268_0 (ref), l_v269_0 (ref), l_v266_0 (ref)
                        while v8.fishingPanelRunning and task.wait(1) do
                            local v277 = "";
                            do
                                local l_v277_0 = v277;
                                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                    -- upvalues: l_v277_0 (ref), l_l_LocalPlayer_2_0 (ref)
                                    l_v277_0 = l_l_LocalPlayer_2_0.PlayerGui.Inventory.Main.Top.Options.Fish.Label.BagSize.Text;
                                end);
                                local l_Value_1 = l_l_LocalPlayer_2_0.leaderstats.Caught.Value;
                                l_v263_0.Text = "Fish: " .. (l_v277_0 or "0/0");
                                l_v265_0.Text = "Value: " .. tostring(l_Value_1);
                                if l_l_Value_0_0 < l_Value_1 then
                                    l_l_Value_0_0 = l_Value_1;
                                    l_v268_0 = tick();
                                    if l_v269_0 then
                                        l_v269_0 = false;
                                        l_v266_0.Text = "FISHING NORMAL";
                                        l_v266_0.TextColor3 = Color3.fromRGB(0, 255, 100);
                                    end;
                                end;
                                if not l_v269_0 and tick() - l_v268_0 >= 10 then
                                    l_v269_0 = true;
                                    l_v266_0.Text = "FISHING STUCK";
                                    l_v266_0.TextColor3 = Color3.fromRGB(255, 70, 70);
                                end;
                            end;
                        end;
                    end);
                end;
            else
                v8.fishingPanelRunning = false;
                local l_ChloeX_FishingPanel_0 = game.CoreGui:FindFirstChild("ChloeX_FishingPanel");
                if l_ChloeX_FishingPanel_0 then
                    l_ChloeX_FishingPanel_0:Destroy();
                end;
            end;
        end
    });
    v228:AddToggle({
        Title = "Blackscreen Support", 
        Default = false, 
        Callback = function(v281) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_CoreGui_0 = game:GetService("CoreGui");
            local l_TweenService_0 = game:GetService("TweenService");
            if v281 then
                if l_CoreGui_0:FindFirstChild("ChloeX_BlackScreen") then
                    l_CoreGui_0.ChloeX_BlackScreen:Destroy();
                end;
                local l_ScreenGui_1 = Instance.new("ScreenGui");
                l_ScreenGui_1.Name = "ChloeX_BlackScreen";
                l_ScreenGui_1.IgnoreGuiInset = true;
                l_ScreenGui_1.ResetOnSpawn = false;
                l_ScreenGui_1.ZIndexBehavior = Enum.ZIndexBehavior.Global;
                l_ScreenGui_1.DisplayOrder = 100;
                l_ScreenGui_1.Parent = l_CoreGui_0;
                local v285 = Instance.new("Frame", l_ScreenGui_1);
                v285.Name = "Dim";
                v285.Size = UDim2.new(1, 0, 1, 0);
                v285.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v285.BackgroundTransparency = 1;
                v285.BorderSizePixel = 0;
                v285.ZIndex = 999;
                l_TweenService_0:Create(v285, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0
                }):Play();
                local v286 = {
                    "ChloeX_FishingPanel", 
                    "Chloeex", 
                    "ToggleUIButton"
                };
                for _, v288 in ipairs(v286) do
                    local l_l_CoreGui_0_FirstChild_0 = l_CoreGui_0:FindFirstChild(v288);
                    if l_l_CoreGui_0_FirstChild_0 then
                        if l_l_CoreGui_0_FirstChild_0:IsA("ScreenGui") then
                            l_l_CoreGui_0_FirstChild_0.DisplayOrder = 999;
                            l_l_CoreGui_0_FirstChild_0.ZIndexBehavior = Enum.ZIndexBehavior.Global;
                        end;
                        for _, v291 in ipairs(l_l_CoreGui_0_FirstChild_0:GetDescendants()) do
                            if v291:IsA("GuiObject") then
                                v291.ZIndex = 1000;
                            end;
                        end;
                    end;
                end;
                for _, v293 in ipairs(v286) do
                    local l_l_CoreGui_0_FirstChild_1 = l_CoreGui_0:FindFirstChild(v293);
                    if l_l_CoreGui_0_FirstChild_1 then
                        l_l_CoreGui_0_FirstChild_1.Parent = l_CoreGui_0;
                    end;
                end;
                v8.focusOverlay = l_ScreenGui_1;
            elseif v8.focusOverlay and v8.focusOverlay.Parent then
                local l_Dim_0 = v8.focusOverlay:FindFirstChild("Dim");
                if l_Dim_0 then
                    l_TweenService_0:Create(l_Dim_0, TweenInfo.new(0.4), {
                        BackgroundTransparency = 1
                    }):Play();
                    task.wait(0.4);
                end;
                v8.focusOverlay:Destroy();
                v8.focusOverlay = nil;
            end;
        end
    });
    v229 = v138.Main:AddSection("Selling Features");
    v229:AddDropdown({
        Options = {
            "Delay", 
            "Count"
        }, 
        Default = "Delay", 
        Title = "Select Sell Mode", 
        Callback = function(v296) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.sellMode = v296;
            SaveConfig();
        end
    });
    v229:AddInput({
        Default = "60", 
        Title = "Set Value", 
        Content = "Delay = Time Count | Count = Backpack Count", 
        Placeholder = "Input Here", 
        Callback = function(v297) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local v298 = tonumber(v297) or 1;
            if v8.sellMode == "Delay" then
                v8.sellDelay = v298;
            else
                v8.inputSellCount = v298;
            end;
            SaveConfig();
        end
    });
    v229:AddToggle({
        Title = "Start Selling", 
        Default = false, 
        Callback = function(v299) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v5 (ref), l_LocalPlayer_0 (ref)
            v8.autoSellEnabled = v299;
            if v299 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v5 (ref), v8 (ref), l_LocalPlayer_0 (ref)
                    local v300 = v5.Net["RF/SellAllItems"];
                    while v8.autoSellEnabled do
                        local l_BagSize_1 = l_LocalPlayer_0:WaitForChild("PlayerGui"):WaitForChild("Inventory").Main.Top.Options.Fish.Label:FindFirstChild("BagSize");
                        local v302 = 0;
                        local v303 = 0;
                        if l_BagSize_1 and l_BagSize_1:IsA("TextLabel") then
                            local v304, v305 = (l_BagSize_1.Text or ""):match("(%d+)%s*/%s*(%d+)");
                            local v306 = tonumber(v304) or 0;
                            v303 = tonumber(v305) or 0;
                            v302 = v306;
                        end;
                        if v8.sellMode == "Delay" then
                            v300:InvokeServer();
                            task.wait(v8.sellDelay);
                        elseif v8.sellMode == "Count" then
                            if (tonumber(v8.inputSellCount) or v303) <= v302 then
                                v300:InvokeServer();
                                task.wait(0);
                            else
                                task.wait(0);
                            end;
                        end;
                    end;
                end);
            end;
        end
    });
    v230 = v138.Main:AddSection("Favorite Features");
    v230:AddDropdown({
        Options = #v11 > 0 and v11 or {
            "No Fish Found"
        }, 
        Content = "Favorite By Name Fish (Recommended)", 
        Multi = true, 
        Title = "Name", 
        Callback = function(v307) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.selectedName = toSet(v307);
        end
    });
    v230:AddDropdown({
        Options = {
            "Common", 
            "Uncommon", 
            "Rare", 
            "Epic", 
            "Legendary", 
            "Mythic", 
            "Secret"
        }, 
        Content = "Favorite By Rarity (Optional)", 
        Multi = true, 
        Title = "Rarity", 
        Callback = function(v308) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.selectedRarity = toSet(v308);
        end
    });
    v230:AddDropdown({
        Options = _G.Variant, 
        Content = "Favorite By Variant (Only works with Name)", 
        Multi = true, 
        Title = "Variant", 
        Callback = function(v309) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            if next(v8.selectedName) ~= nil then
                v8.selectedVariant = toSet(v309);
            else
                v8.selectedVariant = {};
                warn("Pilih Name dulu sebelum memilih Variant.");
            end;
        end
    });
    v230:AddToggle({
        Title = "Auto Favorite", 
        Default = false, 
        Callback = function(v310) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v7 (ref)
            v8.autoFavEnabled = v310;
            if v310 then
                scanInventory();
                v7.Data:OnChange({
                    "Inventory", 
                    "Items"
                }, scanInventory);
            end;
        end
    });
    v230:AddButton({
        Title = "Unfavorite Fish", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v7 (ref), v22 (ref), v6 (ref)
            for _, v312 in ipairs(v7.Data:GetExpect({
                "Inventory", 
                "Items"
            })) do
                local v313 = rawget(v22, v312.UUID);
                if v313 == nil then
                    v313 = v312.Favorited;
                end;
                if v313 then
                    v6.Events.REFav:FireServer(v312.UUID);
                    rawset(v22, v312.UUID, false);
                end;
            end;
        end
    });
    v231 = v138.Auto:AddSection("Shop Features");
    ShopParagraph = v231:AddParagraph({
        Title = "MERCHANT STOCK PANEL", 
        Content = "Loading..."
    });
    v231:AddButton({
        Title = "Open/Close Merchant", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref)
            local l_Merchant_0 = v0.PG:FindFirstChild("Merchant");
            if l_Merchant_0 then
                l_Merchant_0.Enabled = not l_Merchant_0.Enabled;
            end;
        end
    });
    UPX = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v4 (ref)
        local v315 = {};
        for _, v317 in ipairs(v4.ItemsFrame:GetChildren()) do
            if v317:IsA("ImageLabel") and v317.Name ~= "Frame" then
                local l_Frame_0 = v317:FindFirstChild("Frame");
                if l_Frame_0 and l_Frame_0:FindFirstChild("ItemName") then
                    local l_Text_0 = l_Frame_0.ItemName.Text;
                    if not string.find(l_Text_0, "Mystery") then
                        table.insert(v315, "- " .. l_Text_0);
                    end;
                end;
            end;
        end;
        if #v315 == 0 then
            ShopParagraph:SetContent("No items found\n" .. v4.RefreshMerchant.Text);
        else
            ShopParagraph:SetContent(table.concat(v315, "\n") .. "\n\n" .. v4.RefreshMerchant.Text);
        end;
    end;
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        while task.wait(1) do
            pcall(UPX);
        end;
    end);
    v231:AddSubSection("Buy Rod");
    v231:AddDropdown({
        Title = "Select Rod", 
        Options = v8.rodDisplayNames, 
        Callback = function(v320) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            if not v320 then
                return;
            else
                local v321 = _cleanName(v320);
                local v322 = v8.rods[v321];
                if v322 then
                    v8.selectedRodId = v322.Id;
                end;
                return;
            end;
        end
    });
    v231:AddButton({
        Title = "Buy Selected Rod", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            if not v8.selectedRodId then
                return;
            else
                local v323 = v8.rods[v8.selectedRodId] or v8.rods[_cleanName(v8.selectedRodId)];
                if not v323 then
                    return;
                else
                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v6 (ref), v323 (ref)
                        v6.Functions.BuyRod:InvokeServer(v323.Id);
                    end);
                    return;
                end;
            end;
        end
    });
    v231:AddSubSection("Buy Baits");
    v231:AddDropdown({
        Title = "Select Bait", 
        Options = v8.baitDisplayNames, 
        Callback = function(v324) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            if not v324 then
                return;
            else
                local v325 = _cleanName(v324);
                local v326 = v8.baits[v325];
                if v326 then
                    v8.selectedBaitId = v326.Id;
                end;
                return;
            end;
        end
    });
    v231:AddButton({
        Title = "Buy Selected Bait", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            if not v8.selectedBaitId then
                return;
            else
                local v327 = v8.baits[v8.selectedBaitId] or v8.baits[_cleanName(v8.selectedBaitId)];
                if not v327 then
                    return;
                else
                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v6 (ref), v327 (ref)
                        v6.Functions.BuyBait:InvokeServer(v327.Id);
                    end);
                    return;
                end;
            end;
        end
    });
    v231:AddSubSection("Buy Weather");
    local v332 = v231:AddDropdown({
        Title = "Select Weather", 
        Multi = true, 
        Options = {
            "Cloudy ($10000)", 
            "Wind ($10000)", 
            "Snow ($15000)", 
            "Storm ($35000)", 
            "Radiant ($50000)", 
            "Shark Hunt ($300000)"
        }, 
        Callback = function(v328) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.selectedEvents = {};
            if type(v328) == "table" then
                for _, v330 in ipairs(v328) do
                    local v331 = v330:match("^(.-) %(") or v330;
                    table.insert(v8.selectedEvents, v331);
                end;
            end;
            SaveConfig();
        end
    });
    v231:AddToggle({
        Title = "Auto Buy Weather", 
        Default = false, 
        Callback = function(v333) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref), v332 (ref)
            v8.autoBuyWeather = v333;
            if not v6.Functions.BuyWeather then
                return;
            else
                if v333 then
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v8 (ref), v332 (ref), v6 (ref)
                        while v8.autoBuyWeather do
                            local v334 = v332.Value or v332.Selected or {};
                            local v335 = {};
                            if type(v334) == "table" then
                                for _, v337 in ipairs(v334) do
                                    local v338 = v337:match("^(.-) %(") or v337;
                                    table.insert(v335, v338);
                                end;
                            elseif type(v334) == "string" then
                                local v339 = v334:match("^(.-) %(") or v334;
                                table.insert(v335, v339);
                            end;
                            if #v335 > 0 then
                                local v340 = {};
                                local l_Weather_0 = workspace:FindFirstChild("Weather");
                                if l_Weather_0 then
                                    for _, v343 in ipairs(l_Weather_0:GetChildren()) do
                                        table.insert(v340, string.lower(v343.Name));
                                    end;
                                end;
                                for _, v345 in ipairs(v335) do
                                    local v346 = string.lower(v345);
                                    do
                                        local l_v345_0 = v345;
                                        if not table.find(v340, v346) then
                                            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                                -- upvalues: v6 (ref), l_v345_0 (ref)
                                                v6.Functions.BuyWeather:InvokeServer(l_v345_0);
                                            end);
                                            task.wait(0.05);
                                        end;
                                    end;
                                end;
                            end;
                            task.wait(0.1);
                        end;
                    end);
                end;
                return;
            end;
        end
    });
    local v348 = v138.Auto:AddSection("Save position Features");
    v348:AddParagraph({
        Title = "Guide Teleport", 
        Content = "\r\n<b><font color=\"rgb(0,162,255)\">AUTO TELEPORT?</font></b>\r\nClick <b><font color=\"rgb(0,162,255)\">Save Position</font></b> to save your current position!\r\n\r\n<b><font color=\"rgb(0,162,255)\">HOW TO LOAD?</font></b>\r\nThis feature will auto-sync your last position when executed, so you will teleport automatically!\r\n\r\n<b><font color=\"rgb(0,162,255)\">HOW TO RESET?</font></b>\r\nClick <b><font color=\"rgb(0,162,255)\">Reset Position</font></b> to clear your saved position.\r\n    "
    });
    v348:AddButton({
        Title = "Save Position", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: l_LocalPlayer_0 (ref)
            local l_Character_1 = l_LocalPlayer_0.Character;
            local v350 = l_Character_1 and l_Character_1:FindFirstChild("HumanoidRootPart");
            if v350 then
                SavePosition(v350.CFrame);
                chloex("Position saved successfully!");
            end;
        end, 
        SubTitle = "Reset Position", 
        SubCallback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v3 (ref)
            if isfile(v3) then
                delfile(v3);
            end;
            chloex("Last position has been reset.");
        end
    });
    local v351 = v138.Auto:AddSection("Enchant Features");
    local function v370(v352) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref), v5 (ref)
        local v353 = false;
        local v354 = "None";
        local v355 = "None";
        local v356 = 0;
        local v357 = {};
        local v358 = v7.Data:Get("EquippedItems") or {};
        local v359 = v7.Data:Get({
            "Inventory", 
            "Fishing Rods"
        }) or {};
        for _, v361 in pairs(v358) do
            for _, v363 in ipairs(v359) do
                if v363.UUID == v361 then
                    local l_ItemData_2 = v5.ItemUtility:GetItemData(v363.Id);
                    v354 = l_ItemData_2 and l_ItemData_2.Data.Name or v363.ItemName or "None";
                    if v363.Metadata and v363.Metadata.EnchantId then
                        local l_EnchantData_0 = v5.ItemUtility:GetEnchantData(v363.Metadata.EnchantId);
                        if l_EnchantData_0 then
                            local l_Name_1 = l_EnchantData_0.Data.Name;
                            if l_Name_1 then
                                v355 = l_Name_1;
                                v353 = true;
                            end;
                        end;
                        if not v353 then
                            v355 = "None";
                        end;
                    end;
                end;
                v353 = false;
            end;
        end;
        for _, v368 in pairs(v7.Data:GetExpect({
            "Inventory", 
            "Items"
        })) do
            local l_ItemData_3 = v5.ItemUtility:GetItemData(v368.Id);
            if l_ItemData_3 and l_ItemData_3.Data.Type == "Enchant Stones" and v368.Id == v352 then
                v356 = v356 + 1;
                table.insert(v357, v368.UUID);
            end;
        end;
        return v354, v355, v356, v357;
    end;
    local v371 = v351:AddParagraph({
        Title = "Enchant Status", 
        Content = "Current Rod : None\nCurrent Enchant : None\nEnchant Stones Left : 0"
    });
    v351:AddButton({
        Title = "Click Enchant", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v370 (ref), v371 (ref), v7 (ref), v6 (ref)
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v370 (ref), v371 (ref), v7 (ref), v6 (ref)
                local v372, v373, v374, v375 = v370(10);
                if v372 == "None" or v374 <= 0 then
                    v371:SetContent(("Current Rod : <font color='rgb(0,170,255)'>%s</font>\nCurrent Enchant : <font color='rgb(0,170,255)'>%s</font>\nEnchant Stones Left : <font color='rgb(0,170,255)'>%d</font>"):format(v372, v373, v374));
                    return;
                else
                    local v376 = nil;
                    local v377 = tick();
                    while tick() - v377 < 5 do
                        local l_pairs_0 = pairs;
                        local v379 = v7.Data:Get("EquippedItems") or {};
                        for v380, v381 in l_pairs_0(v379) do
                            if v381 == v375[1] then
                                v376 = v380;
                            end;
                        end;
                        if not v376 then
                            v6.Events.REEquipItem:FireServer(v375[1], "Enchant Stones");
                            task.wait(0.3);
                        else
                            break;
                        end;
                    end;
                    if not v376 then
                        return;
                    else
                        v6.Events.REEquip:FireServer(v376);
                        task.wait(0.2);
                        v6.Events.REAltar:FireServer();
                        task.wait(1.5);
                        local _, v383 = v370(10);
                        v371:SetContent(("Current Rod : <font color='rgb(0,170,255)'>%s</font>\nCurrent Enchant : <font color='rgb(0,170,255)'>%s</font>\nEnchant Stones Left : <font color='rgb(0,170,255)'>%d</font>"):format(v372, v383, v374 - 1));
                        return;
                    end;
                end;
            end);
        end
    });
    v351:AddButton({
        Title = "Teleport Enchant Altar", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local v384 = v8.player.Character or v8.player.CharacterAdded:Wait();
            local l_HumanoidRootPart_3 = v384:FindFirstChild("HumanoidRootPart");
            local l_Humanoid_0 = v384:FindFirstChildOfClass("Humanoid");
            if l_HumanoidRootPart_3 and l_Humanoid_0 then
                l_HumanoidRootPart_3.CFrame = CFrame.new(Vector3.new(3258, -1301, 1391));
                l_Humanoid_0:ChangeState(Enum.HumanoidStateType.Physics);
                task.wait(0.1);
                l_Humanoid_0:ChangeState(Enum.HumanoidStateType.Running);
            end;
        end
    });
    v351:AddDivider();
    v351:AddButton({
        Title = "Click Double Enchant", 
        Content = "Starting Double Enchanting", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v370 (ref), v371 (ref), v7 (ref), v6 (ref)
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v370 (ref), v371 (ref), v7 (ref), v6 (ref)
                local v387, v388, v389, v390 = v370(246);
                if v387 == "None" or v389 <= 0 then
                    v371:SetContent(("Current Rod : <font color='rgb(0,170,255)'>%s</font>\nCurrent Enchant : <font color='rgb(0,170,255)'>%s</font>\nEnchant Stones Left : <font color='rgb(0,170,255)'>%d</font>"):format(v387, v388, v389));
                    return;
                else
                    local v391 = nil;
                    local v392 = tick();
                    while tick() - v392 < 5 do
                        local l_pairs_1 = pairs;
                        local v394 = v7.Data:Get("EquippedItems") or {};
                        for v395, v396 in l_pairs_1(v394) do
                            if v396 == v390[1] then
                                v391 = v395;
                            end;
                        end;
                        if not v391 then
                            v6.Events.REEquipItem:FireServer(v390[1], "Enchant Stones");
                            task.wait(0.3);
                        else
                            break;
                        end;
                    end;
                    if not v391 then
                        return;
                    else
                        v6.Events.REEquip:FireServer(v391);
                        task.wait(0.2);
                        v6.Events.REAltar2:FireServer();
                        task.wait(1.5);
                        local _, v398 = v370(246);
                        v371:SetContent(("Current Rod : <font color='rgb(0,170,255)'>%s</font>\nCurrent Enchant : <font color='rgb(0,170,255)'>%s</font>\nEnchant Stones Left : <font color='rgb(0,170,255)'>%d</font>"):format(v387, v398, v389 - 1));
                        return;
                    end;
                end;
            end);
        end
    });
    v351:AddButton({
        Title = "Teleport Second Enchant Altar", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local v399 = v8.player.Character or v8.player.CharacterAdded:Wait();
            local l_HumanoidRootPart_4 = v399:FindFirstChild("HumanoidRootPart");
            local l_Humanoid_1 = v399:FindFirstChildOfClass("Humanoid");
            if l_HumanoidRootPart_4 and l_Humanoid_1 then
                l_HumanoidRootPart_4.CFrame = CFrame.new(Vector3.new(1480, 128, -593));
                l_Humanoid_1:ChangeState(Enum.HumanoidStateType.Physics);
                task.wait(0.1);
                l_Humanoid_1:ChangeState(Enum.HumanoidStateType.Running);
            end;
        end
    });
    local v402 = v138.Auto:AddSection("Totem Features");
    TotemPanel = v402:AddParagraph({
        Title = "Panel Activated Totem", 
        Content = "Scanning Totems..."
    });
    HeaderPanel = v402:AddParagraph({
        Title = "Auto Totem Status", 
        Content = "Idle."
    });
    GetTT = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        local v403 = v8.char and v8.char:FindFirstChild("HumanoidRootPart") and v8.char.HumanoidRootPart.Position or Vector3.zero;
        local v404 = {};
        for _, v406 in pairs(workspace.Totems:GetChildren()) do
            if v406:IsA("Model") then
                local l_Handle_0 = v406:FindFirstChild("Handle");
                local v408 = l_Handle_0 and l_Handle_0:FindFirstChild("Overhead");
                local v409 = v408 and v408:FindFirstChild("Content");
                local v410 = v409 and v409:FindFirstChild("Header");
                local v411 = v409 and v409:FindFirstChild("TimerLabel");
                local l_Magnitude_0 = (v403 - v406:GetPivot().Position).Magnitude;
                local v413 = v411 and v411.Text or "??";
                local v414 = v410 and v410.Text or "??";
                table.insert(v404, {
                    Name = v414, 
                    Distance = l_Magnitude_0, 
                    TimeLeft = v413
                });
            end;
        end;
        return v404;
    end;
    UpdTT = function() --[[ Line: 0 ]] --[[ Name:  ]]
        local v415 = GetTT();
        if #v415 == 0 then
            TotemPanel:SetContent("No active totems detected.");
            return;
        else
            local v416 = {};
            for _, v418 in ipairs(v415) do
                table.insert(v416, string.format("%s \226\128\162 %.1f studs \226\128\162 %s", v418.Name, v418.Distance, v418.TimeLeft));
            end;
            TotemPanel:SetContent(table.concat(v416, "\n"));
            return;
        end;
    end;
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        while task.wait(1) do
            pcall(UpdTT);
        end;
    end);
    GetTTUUID = function(v419) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v5 (ref)
        if not Data then
            Data = v5.Replion.Client:WaitReplion("Data");
            if not Data then
                return nil;
            end;
        end;
        if not Totems then
            Totems = require(game:GetService("ReplicatedStorage"):WaitForChild("Totems"));
            if not Totems then
                return nil;
            end;
        end;
        local v420 = Data:GetExpect({
            "Inventory", 
            "Totems"
        }) or {};
        for _, v422 in ipairs(v420) do
            local v423 = "Unknown Totem";
            if typeof(Totems) == "table" then
                for _, v425 in pairs(Totems) do
                    if v425.Data and v425.Data.Id == v422.Id then
                        v423 = v425.Data.Name;
                        break;
                    end;
                end;
            end;
            if v423 == v419 then
                return v422.UUID, v423;
            end;
        end;
        return nil;
    end;
    local function v426() --[[ Line: 0 ]] --[[ Name:  ]]
        if RealTotemPanel and RealTotemPanel.Show then
            RealTotemPanel:Show();
        end;
    end;
    local function v430(v427) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v6 (ref)
        if not v427 then
            return;
        else
            local l_status_8, l_result_8 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref), v427 (ref)
                v6.Events.Totem:FireServer(v427);
            end);
            if not l_status_8 then
                warn("[Chloe X] Totem spawn failed:", tostring(l_result_8));
            end;
            return;
        end;
    end;
    v402:AddButton({
        Title = "Teleport To Nearest Totem", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local v431 = v8.char and v8.char:FindFirstChild("HumanoidRootPart");
            if not v431 then
                return;
            else
                local v432 = GetTT();
                if #v432 == 0 then
                    return;
                else
                    table.sort(v432, function(v433, v434) --[[ Line: 0 ]] --[[ Name:  ]]
                        return v433.Distance < v434.Distance;
                    end);
                    local v435 = v432[1];
                    for _, v437 in pairs(workspace.Totems:GetChildren()) do
                        if v437:IsA("Model") then
                            local l_Position_0 = v437:GetPivot().Position;
                            if math.abs((l_Position_0 - v431.Position).Magnitude - v435.Distance) < 1 then
                                v431.CFrame = CFrame.new(l_Position_0 + Vector3.new(0, 3, 0));
                                break;
                            end;
                        end;
                    end;
                    return;
                end;
            end;
        end
    });
    TotemsFolder = v0.RS:WaitForChild("Totems");
    v8.Totems = v8.Totems or {};
    v8.TotemDisplayName = v8.TotemDisplayName or {};
    for _, v440 in ipairs(TotemsFolder:GetChildren()) do
        if v440:IsA("ModuleScript") then
            local l_status_9, l_result_9 = pcall(require, v440);
            if l_status_9 and typeof(l_result_9) == "table" and l_result_9.Data then
                local v443 = l_result_9.Data.Name or "Unknown";
                local v444 = l_result_9.Data.Id or "Unknown";
                local v445 = {
                    Name = v443, 
                    Id = v444
                };
                v8.Totems[v444] = v445;
                v8.Totems[v443] = v445;
                table.insert(v8.TotemDisplayName, v443);
            end;
        end;
    end;
    selectedTotem = nil;
    TotemDropdown = v402:AddDropdown({
        Title = "Select Totem to Auto Place", 
        Options = v8.TotemDisplayName or {
            "No Totems Found"
        }, 
        Default = v8.TotemDisplayName and v8.TotemDisplayName[1] or "No Totems Found", 
        Callback = function(v446) --[[ Line: 0 ]] --[[ Name:  ]]
            selectedTotem = v446;
        end
    });
    v402:AddToggle({
        Title = "Auto Place Totem (Beta)", 
        Content = "Place Totem every 60 minutes automatically.", 
        Default = false, 
        Callback = function(v447) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v430 (ref), v426 (ref)
            TotemActive = v447;
            if v447 then
                if not selectedTotem then
                    HeaderPanel:SetContent("Please select a Totem first.");
                    TotemActive = false;
                    return;
                else
                    local v448, v449 = GetTTUUID(selectedTotem);
                    if not v448 then
                        HeaderPanel:SetContent("You don't own any Totem.");
                        TotemActive = false;
                        return;
                    else
                        HeaderPanel:SetContent(("Auto Totem Enabled [%s] \226\128\162 Waiting 60m loop..."):format(selectedTotem));
                        do
                            local l_v448_0, l_v449_0 = v448, v449;
                            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                -- upvalues: v430 (ref), l_v448_0 (ref), v426 (ref), l_v449_0 (ref)
                                local v452 = 0;
                                while TotemActive do
                                    v430(l_v448_0);
                                    if v452 < 3 then
                                        HeaderPanel:SetContent(("Totem Used [%s] \226\128\162 Next in 60m"):format(selectedTotem));
                                        v452 = v452 + 1;
                                    elseif v452 == 3 then
                                        v452 = v452 + 1;
                                        task.wait(1);
                                        HeaderPanel:SetContent("Reverting to Real Totem Panel...");
                                        task.wait(0.5);
                                        v426();
                                    end;
                                    for _ = 3600, 1, -1 do
                                        if TotemActive then
                                            task.wait(1);
                                        else
                                            break;
                                        end;
                                    end;
                                    local v454, v455 = GetTTUUID(selectedTotem);
                                    l_v449_0 = v455;
                                    l_v448_0 = v454;
                                    if not l_v448_0 then
                                        HeaderPanel:SetContent("Totem not found in inventory anymore.");
                                        TotemActive = false;
                                        break;
                                    end;
                                end;
                                HeaderPanel:SetContent("Auto Totem Disabled.");
                            end);
                        end;
                    end;
                end;
            else
                HeaderPanel:SetContent("Auto Totem Disabled.");
                v426();
            end;
        end
    });
    Potion = v138.Auto:AddSection("Potions Features");
    PotionsFolder = v0.RS:WaitForChild("Potions");
    v8.Potions = v8.Potions or {};
    v8.PotionDisplayName = v8.PotionDisplayName or {};
    for _, v457 in ipairs(PotionsFolder:GetChildren()) do
        if v457:IsA("ModuleScript") then
            local l_status_10, l_result_10 = pcall(require, v457);
            if l_status_10 and typeof(l_result_10) == "table" and l_result_10.Data then
                local v460 = l_result_10.Data.Name or "Unknown";
                local v461 = l_result_10.Data.Id or "Unknown";
                if not string.find(string.lower(v460), "totem") then
                    local v462 = {
                        Name = v460, 
                        Id = v461
                    };
                    v8.Potions[v461] = v462;
                    v8.Potions[v460] = v462;
                    table.insert(v8.PotionDisplayName, v460);
                end;
            end;
        end;
    end;
    selectedPotions = {};
    Potion:AddDropdown({
        Title = "Select Potions", 
        Multi = true, 
        Options = v8.PotionDisplayName, 
        Callback = function(v463) --[[ Line: 0 ]] --[[ Name:  ]]
            selectedPotions = v463;
        end
    });
    Potion:AddToggle({
        Title = "Auto Use Potions", 
        Default = false, 
        Callback = function(v464) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v7 (ref), v8 (ref), v5 (ref)
            _G.AutoUsePotions = v464;
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v7 (ref), v8 (ref), v5 (ref)
                while _G.AutoUsePotions do
                    task.wait(1);
                    local v465 = v7.Data:GetExpect({
                        "Inventory", 
                        "Potions"
                    }) or {};
                    for _, v467 in ipairs(selectedPotions) do
                        local v468 = v8.Potions[v467];
                        if v468 then
                            for _, v470 in ipairs(v465) do
                                if v470.Id == v468.Id then
                                    do
                                        local l_v470_0 = v470;
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v5 (ref), l_v470_0 (ref)
                                            v5.Net["RF/ConsumePotion"]:InvokeServer(l_v470_0.UUID, 1);
                                        end);
                                    end;
                                    break;
                                else
                                    --[[ close >= 10 ]]
                                end;
                            end;
                        end;
                    end;
                end;
            end);
        end
    });
    local v472 = v138.Auto:AddSection("Event Features");
    v472:AddDropdown({
        Options = v87() or {}, 
        Multi = false, 
        Title = "Priority Event", 
        Callback = function(v473) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.priorityEvent = v473;
        end
    });
    v472:AddDropdown({
        Options = v87() or {}, 
        Multi = true, 
        Title = "Select Event", 
        Callback = function(v474) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.selectedEvents = {};
            for _, v476 in pairs(v474) do
                table.insert(v8.selectedEvents, v476);
            end;
            v8.curCF = nil;
            if v8.autoEventActive and (#v8.selectedEvents > 0 or v8.priorityEvent) then
                task.spawn(v8.loop);
            end;
        end
    });
    v472:AddToggle({
        Title = "Auto Event", 
        Default = false, 
        Callback = function(v477) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v65 (ref), l_LocalPlayer_0 (ref)
            v8.autoEventActive = v477;
            if v477 and (#v8.selectedEvents > 0 or v8.priorityEvent) then
                v8.origCF = v8.origCF or v65(l_LocalPlayer_0.Character).CFrame;
                task.spawn(v8.loop);
            else
                if v8.origCF then
                    l_LocalPlayer_0.Character:PivotTo(v8.origCF);
                    chloex("Auto Event Off");
                end;
                local l_v8_4 = v8;
                local l_v8_5 = v8;
                local v480 = nil;
                l_v8_5.curCF = nil;
                l_v8_4.origCF = v480;
            end;
        end
    });
    getGroupedByType = function(v481) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref), v5 (ref)
        local l_Expect_0 = v7.Data:GetExpect({
            "Inventory", 
            "Items"
        });
        local v483 = {};
        local v484 = {};
        for _, v486 in ipairs(l_Expect_0) do
            local v487 = v5.ItemUtility.GetItemDataFromItemType("Items", v486.Id);
            if v487 and v487.Data.Type == v481 and not v486.Favorited then
                local l_Name_2 = v487.Data.Name;
                v483[l_Name_2] = v483[l_Name_2] or {
                    count = 0, 
                    uuids = {}
                };
                v483[l_Name_2].count = v483[l_Name_2].count + (v486.Quantity or 1);
                table.insert(v483[l_Name_2].uuids, v486.UUID);
            end;
        end;
        for v489, v490 in pairs(v483) do
            table.insert(v484, ("%s x%d"):format(v489, v490.count));
        end;
        return v483, v484;
    end;
    local v491 = v138.Trade:AddSection("Trading Fish Features");
    local v492 = v138.Trade:AddSection("Trading Coin Features");
    local v493 = v491:AddParagraph({
        Title = "Panel Name Trading", 
        Content = "\r\nPlayer : ???\r\nItem   : ???\r\nAmount : 0\r\nStatus : Idle\r\nSuccess: 0 / 0\r\n"
    });
    local v494 = v492:AddParagraph({
        Title = "Panel Coin Trading", 
        Content = "\r\nPlayer   : ???\r\nTarget   : 0\r\nProgress : 0 / 0\r\nStatus   : Idle\r\nResult   : Success : 0 | Received : 0\r\n"
    });
    _G.safeSetContent = function(v495, v496) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref)
        v0.RunService.Heartbeat:Once(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v495 (ref), v496 (ref)
            if v495 then
                v495:SetContent(v496);
            end;
        end);
    end;
    local function v501(v497) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v493 (ref)
        local l_trade_0 = v8.trade;
        local v499 = "200,200,200";
        if v497 and v497:lower():find("send") then
            v499 = "51,153,255";
        elseif v497 and v497:lower():find("complete") then
            v499 = "0,204,102";
        elseif v497 and v497:lower():find("time") then
            v499 = "255,69,0";
        end;
        local v500 = string.format("\r\n<font color='rgb(173,216,230)'>Player : %s</font>\r\n<font color='rgb(173,216,230)'>Item   : %s</font>\r\n<font color='rgb(173,216,230)'>Amount : %d</font>\r\n<font color='rgb(%s)'>Status : %s</font>\r\n<font color='rgb(173,216,230)'>Success: %d / %d</font>\r\n", l_trade_0.selectedPlayer or "???", l_trade_0.selectedItem or "???", l_trade_0.tradeAmount or 0, v499, v497 or "Idle", l_trade_0.successCount or 0, l_trade_0.totalToTrade or 0);
        _G.safeSetContent(v493, v500);
    end;
    local function v506(v502) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v494 (ref)
        local l_trade_1 = v8.trade;
        local v504 = "200,200,200";
        if v502 and v502:lower():find("send") then
            v504 = "51,153,255";
        elseif v502 and v502:lower():find("progress") then
            v504 = "255,215,0";
        elseif v502 and v502:lower():find("complete") then
            v504 = "0,204,102";
        elseif v502 and v502:lower():find("time") then
            v504 = "255,69,0";
        end;
        local v505 = string.format("\r\n<font color='rgb(173,216,230)'>Player   : %s</font>\r\n<font color='rgb(173,216,230)'>Target   : %d</font>\r\n<font color='rgb(173,216,230)'>Progress : %d / %d</font>\r\n<font color='rgb(%s)'>Status   : %s</font>\r\n<font color='rgb(173,216,230)'>Result   : Success : %d | Received : %d</font>\r\n", l_trade_1.selectedPlayer or "???", l_trade_1.targetCoins or 0, l_trade_1.successCoins or 0, l_trade_1.targetCoins or 0, v504, v502 or "Idle", l_trade_1.successCoins or 0, l_trade_1.totalReceived or 0);
        _G.safeSetContent(v494, v505);
    end;
    local function v510(v507) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref)
        for _, v509 in ipairs(v7.Data:GetExpect({
            "Inventory", 
            "Items"
        })) do
            if v509.UUID == v507 then
                return true;
            end;
        end;
        return false;
    end;
    local function v519(v511, v512, v513, v514) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v0 (ref), v501 (ref), v506 (ref), v6 (ref), v510 (ref)
        local l_trade_2 = v8.trade;
        local v516 = true;
        l_trade_2.lastResult = nil;
        l_trade_2.awaiting = v516;
        v516 = false;
        local l_FirstChild_1 = v0.Players:FindFirstChild(v511);
        if not l_FirstChild_1 then
            l_trade_2.trading = false;
            v501("<font color='#ff3333'>Player not found</font>");
            v506("<font color='#ff3333'>Player not found</font>");
            return false;
        else
            if v513 then
                v501("Sending");
                chloex("Sending " .. v513);
            else
                v506("Sending");
                chloex("Sending fish for coins");
            end;
            if not pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref), l_FirstChild_1 (ref), v512 (ref)
                v6.Functions.Trade:InvokeServer(l_FirstChild_1.UserId, v512);
            end) then
                return false;
            else
                local v518 = tick();
                while true do
                    if l_trade_2.trading and not v516 then
                        if not v510(v512) then
                            v516 = true;
                            if v513 then
                                l_trade_2.successCount = l_trade_2.successCount + 1;
                                v501("Completed");
                            else
                                l_trade_2.successCoins = l_trade_2.successCoins + (v514 or 0);
                                l_trade_2.totalReceived = l_trade_2.successCoins;
                                v506("Progress");
                            end;
                        elseif tick() - v518 > 10 then
                            return false;
                        end;
                        task.wait(0.2);
                    else
                        return v516;
                    end;
                end;
            end;
        end;
    end;
    local function v526(v520, v521, v522, v523) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v519 (ref)
        local l_trade_3 = v8.trade;
        local v525 = 0;
        while true do
            if v525 < 3 and l_trade_3.trading then
                if v519(v520, v521, v522, v523) then
                    task.wait(2.5);
                    return true;
                else
                    v525 = v525 + 1;
                    task.wait(1);
                end;
            else
                return false;
            end;
        end;
    end;
    startTradeByName = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v501 (ref), v526 (ref)
        local l_trade_4 = v8.trade;
        if l_trade_4.trading then
            return;
        elseif not l_trade_4.selectedPlayer or not l_trade_4.selectedItem then
            return chloex("Select player & item first!");
        else
            l_trade_4.trading = true;
            l_trade_4.successCount = 0;
            chloex("Starting trade with " .. l_trade_4.selectedPlayer);
            local v528 = l_trade_4.currentGrouped[l_trade_4.selectedItem];
            if not v528 then
                l_trade_4.trading = false;
                v501("<font color='#ff3333'>Item not found</font>");
                return chloex("Item not found");
            else
                l_trade_4.totalToTrade = math.min(l_trade_4.tradeAmount, #v528.uuids);
                local v529 = 1;
                while l_trade_4.trading and l_trade_4.successCount < l_trade_4.totalToTrade do
                    v526(l_trade_4.selectedPlayer, v528.uuids[v529], l_trade_4.selectedItem);
                    v529 = v529 + 1;
                    if #v528.uuids < v529 then
                        v529 = 1;
                    end;
                    task.wait(2);
                end;
                l_trade_4.trading = false;
                v501("<font color='#66ccff'>All trades finished</font>");
                chloex("All trades finished");
                return;
            end;
        end;
    end;
    chooseFishesByRange = function(v530, v531) --[[ Line: 0 ]] --[[ Name:  ]]
        table.sort(v530, function(v532, v533) --[[ Line: 0 ]] --[[ Name:  ]]
            return v532.Price > v533.Price;
        end);
        local v534 = {};
        local v535 = 0;
        for _, v537 in ipairs(v530) do
            if v535 + v537.Price <= v531 then
                table.insert(v534, v537);
                v535 = v535 + v537.Price;
            end;
            if v531 <= v535 then
                break;
            end;
        end;
        if v535 < v531 and #v530 > 0 then
            table.insert(v534, v530[#v530]);
        end;
        return v534, v535;
    end;
    startTradeByCoin = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v506 (ref), v0 (ref), v5 (ref), v7 (ref), v526 (ref)
        local l_trade_5 = v8.trade;
        if l_trade_5.trading then
            return;
        elseif not l_trade_5.selectedPlayer or l_trade_5.targetCoins <= 0 then
            return chloex("\226\154\160 Select player & coin target first!");
        else
            l_trade_5.trading = true;
            local v539 = 0;
            local v540 = 0;
            l_trade_5.totalReceived = 0;
            l_trade_5.successCoins = v540;
            l_trade_5.sentCoins = v539;
            v506("<font color='#ffaa00'>Starting...</font>");
            chloex("Starting coin trade with " .. l_trade_5.selectedPlayer);
            v539 = v0.Players.LocalPlayer;
            v540 = v5.PlayerStatsUtility:GetPlayerModifiers(v539);
            local v541 = {};
            local l_Expect_1 = v7.Data:GetExpect({
                "Inventory", 
                "Items"
            });
            for _, v544 in ipairs(l_Expect_1) do
                if not v544.Favorited then
                    local l_ItemData_4 = v5.ItemUtility:GetItemData(v544.Id);
                    if l_ItemData_4 and l_ItemData_4.Data and l_ItemData_4.Data.Type == "Fish" then
                        local v546 = v5.VendorUtility:GetSellPrice(v544) or l_ItemData_4.SellPrice or 0;
                        local v547 = math.ceil(v546 * (v540 and v540.CoinMultiplier or 1));
                        if v547 > 0 then
                            table.insert(v541, {
                                UUID = v544.UUID, 
                                Name = l_ItemData_4.Data.Name or "Unknown", 
                                Price = v547
                            });
                        end;
                    end;
                end;
            end;
            if #v541 == 0 then
                l_trade_5.trading = false;
                v506("<font color='#ff3333'>No fishes found</font>");
                chloex("\226\154\160 No fishes found in inventory");
                return;
            else
                local v548, v549 = chooseFishesByRange(v541, l_trade_5.targetCoins);
                if #v548 == 0 then
                    l_trade_5.trading = false;
                    v506("<font color='#ff3333'>No valid fishes for target</font>");
                    return;
                else
                    l_trade_5.totalToTrade = #v548;
                    l_trade_5.targetCoins = v549;
                    if not v0.Players:FindFirstChild(l_trade_5.selectedPlayer) then
                        l_trade_5.trading = false;
                        v506("<font color='#ff3333'>Player not found</font>");
                        return;
                    else
                        for _, v551 in ipairs(v548) do
                            if l_trade_5.trading then
                                l_trade_5.sentCoins = l_trade_5.sentCoins + v551.Price;
                                v506(string.format("<font color='#ffaa00'>Progress : %d / %d</font>", l_trade_5.sentCoins, l_trade_5.targetCoins));
                                v526(l_trade_5.selectedPlayer, v551.UUID, nil, v551.Price);
                                l_trade_5.successCoins = l_trade_5.sentCoins;
                                task.wait(2);
                            else
                                break;
                            end;
                        end;
                        l_trade_5.trading = false;
                        v506(string.format("<font color='#66ccff'>Coin trade finished (Target: %d, Received: %d)</font>", l_trade_5.targetCoins, l_trade_5.successCoins));
                        chloex(string.format("Coin trade finished (Target: %d, Received: %d)", l_trade_5.targetCoins, l_trade_5.successCoins));
                        return;
                    end;
                end;
            end;
        end;
    end;
    local v553 = v491:AddDropdown({
        Options = {}, 
        Multi = false, 
        Title = "Select Item", 
        Callback = function(v552) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v501 (ref)
            v8.trade.selectedItem = v552 and (v552:match("^(.-) x") or v552);
            v501();
        end
    });
    v491:AddButton({
        Title = "Refresh Fish", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v553 (ref)
            local v554, v555 = getGroupedByType("Fish");
            v8.trade.currentGrouped = v554;
            v553:SetValues(v555 or {});
        end, 
        SubTitle = "Refresh Stone", 
        SubCallback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v553 (ref)
            local v556, v557 = getGroupedByType("Enchant Stones");
            v8.trade.currentGrouped = v556;
            v553:SetValues(v557 or {});
        end
    });
    v491:AddInput({
        Title = "Amount to Trade", 
        Default = "1", 
        Callback = function(v558) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v501 (ref)
            v8.trade.tradeAmount = tonumber(v558) or 1;
            v501();
        end
    });
    local v560 = v491:AddDropdown({
        Options = {}, 
        Multi = false, 
        Title = "Select Player", 
        Callback = function(v559) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v501 (ref)
            v8.trade.selectedPlayer = v559;
            v501();
        end
    });
    v491:AddButton({
        Title = "Refresh Player", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref), v8 (ref), v560 (ref)
            local v561 = {};
            for _, v563 in ipairs(v0.Players:GetPlayers()) do
                if v563 ~= v8.player then
                    table.insert(v561, v563.Name);
                end;
            end;
            v560:SetValues(v561 or {});
        end
    });
    v491:AddToggle({
        Title = "Start By Name", 
        Default = false, 
        Callback = function(v564) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v501 (ref)
            if v564 then
                task.spawn(startTradeByName);
            else
                v8.trade.trading = false;
                v501();
            end;
        end
    });
    local v566 = v492:AddDropdown({
        Options = {}, 
        Multi = false, 
        Title = "Select Player", 
        Callback = function(v565) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v506 (ref)
            v8.trade.selectedPlayer = v565;
            v506();
        end
    });
    v492:AddButton({
        Title = "Refresh Player", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref), v8 (ref), v566 (ref)
            local v567 = {};
            for _, v569 in ipairs(v0.Players:GetPlayers()) do
                if v569 ~= v8.player then
                    table.insert(v567, v569.Name);
                end;
            end;
            v566:SetValues(v567 or {});
        end
    });
    v492:AddInput({
        Title = "Target Coin", 
        Default = "0", 
        Callback = function(v570) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v506 (ref)
            v8.trade.targetCoins = tonumber(v570) or 0;
            v506();
        end
    });
    v492:AddToggle({
        Title = "Start By Coin", 
        Default = false, 
        Callback = function(v571) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            if v571 then
                task.spawn(startTradeByCoin);
            else
                v8.trade.trading = false;
            end;
        end
    });
    TradeByRarity = v138.Trade:AddSection("Trading Rarity Features");
    Rarity_Monitor = TradeByRarity:AddParagraph({
        Title = "Panel Rarity Trading", 
        Content = "\r\nPlayer  : ???\r\nRarity  : ???\r\nCount   : 0\r\nStatus  : Idle\r\nSuccess : 0 / 0\r\n"
    });
    local function v576(v572) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref)
        local l_trade_6 = v8.trade;
        local v574 = "200,200,200";
        if v572 and v572:lower():find("send") then
            v574 = "51,153,255";
        elseif v572 and v572:lower():find("complete") then
            v574 = "0,204,102";
        elseif v572 and v572:lower():find("time") then
            v574 = "255,69,0";
        end;
        local v575 = string.format("\r\n<font color='rgb(173,216,230)'>Player  : %s</font>\r\n<font color='rgb(173,216,230)'>Rarity  : %s</font>\r\n<font color='rgb(173,216,230)'>Count   : %d</font>\r\n<font color='rgb(%s)'>Status  : %s</font>\r\n<font color='rgb(173,216,230)'>Success : %d / %d</font>\r\n", l_trade_6.selectedPlayer or "???", l_trade_6.selectedRarity or "???", l_trade_6.totalToTrade or 0, v574, v572 or "Idle", l_trade_6.successCount or 0, l_trade_6.totalToTrade or 0);
        _G.safeSetContent(Rarity_Monitor, v575);
    end;
    TradeByRarity:AddDropdown({
        Options = {
            "Common", 
            "Uncommon", 
            "Rare", 
            "Epic", 
            "Legendary", 
            "Mythic", 
            "Secret"
        }, 
        Multi = false, 
        Title = "Select Rarity", 
        Callback = function(v577) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v576 (ref)
            v8.trade.selectedRarity = v577;
            v576("Selected rarity: " .. (v577 or "???"));
        end
    });
    rarityPlayerDropdown = TradeByRarity:AddDropdown({
        Options = {}, 
        Multi = false, 
        Title = "Select Player", 
        Callback = function(v578) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v576 (ref)
            v8.trade.selectedPlayer = v578;
            v576();
        end
    });
    TradeByRarity:AddButton({
        Title = "Refresh Player", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref), v8 (ref)
            local v579 = {};
            for _, v581 in ipairs(v0.Players:GetPlayers()) do
                if v581 ~= v8.player then
                    table.insert(v579, v581.Name);
                end;
            end;
            rarityPlayerDropdown:SetValues(v579 or {});
        end
    });
    TradeByRarity:AddInput({
        Title = "Amount to Trade", 
        Default = "1", 
        Callback = function(v582) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v576 (ref)
            v8.trade.rarityAmount = tonumber(v582) or 1;
            v576("Set amount: " .. tostring(v8.trade.rarityAmount));
        end
    });
    startTradeByRarity = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v8 (ref), v576 (ref), v7 (ref), v5 (ref), v526 (ref)
        local l_trade_7 = v8.trade;
        if l_trade_7.trading then
            return;
        elseif not l_trade_7.selectedPlayer or not l_trade_7.selectedRarity then
            return chloex("\226\154\160 Select player & rarity first!");
        else
            l_trade_7.trading = true;
            l_trade_7.successCount = 0;
            chloex("Starting rarity trade (" .. l_trade_7.selectedRarity .. ") with " .. l_trade_7.selectedPlayer);
            v576("<font color='#ffaa00'>Scanning " .. l_trade_7.selectedRarity .. " fishes...</font>");
            local v584 = {};
            for _, v586 in ipairs(v7.Data:GetExpect({
                "Inventory", 
                "Items"
            })) do
                if not v586.Favorited then
                    local v587 = v5.ItemUtility.GetItemDataFromItemType("Items", v586.Id);
                    if v587 and v587.Data.Type == "Fish" and _G.TierFish[v587.Data.Tier] == l_trade_7.selectedRarity then
                        table.insert(v584, {
                            UUID = v586.UUID, 
                            Name = v587.Data.Name
                        });
                    end;
                end;
            end;
            if #v584 == 0 then
                l_trade_7.trading = false;
                v576("<font color='#ff3333'>No " .. l_trade_7.selectedRarity .. " fishes found</font>");
                return chloex("No " .. l_trade_7.selectedRarity .. " fishes found");
            else
                l_trade_7.totalToTrade = math.min(#v584, l_trade_7.rarityAmount or #v584);
                v576(string.format("Sending %d %s fishes...", l_trade_7.totalToTrade, l_trade_7.selectedRarity));
                local v588 = 1;
                while l_trade_7.trading and v588 <= l_trade_7.totalToTrade do
                    local v589 = v584[v588];
                    if v526(l_trade_7.selectedPlayer, v589.UUID, v589.Name) then
                        l_trade_7.successCount = l_trade_7.successCount + 1;
                        v576(string.format("Progress: %d / %d (%s)", l_trade_7.successCount, l_trade_7.totalToTrade, l_trade_7.selectedRarity));
                    end;
                    v588 = v588 + 1;
                    task.wait(2.5);
                end;
                l_trade_7.trading = false;
                v576("<font color='#66ccff'>Rarity trade finished</font>");
                chloex("Rarity trade finished (" .. l_trade_7.selectedRarity .. ")");
                return;
            end;
        end;
    end;
    TradeByRarity:AddToggle({
        Title = "Start By Rarity", 
        Default = false, 
        Callback = function(v590) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v576 (ref)
            if v590 then
                task.spawn(startTradeByRarity);
            else
                v8.trade.trading = false;
                v576("Idle");
            end;
        end
    });
    AcceptTrade = v138.Trade:AddSection("Auto Accept Features");
    AcceptTrade:AddToggle({
        Title = "Auto Accept Trade", 
        Default = _G.AutoAccept, 
        Callback = function(v591) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.AutoAccept = v591;
        end
    });
    spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        while true do
            task.wait(1);
            if _G.AutoAccept then
                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    local l_Prompt_0 = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Prompt");
                    if l_Prompt_0 and l_Prompt_0:FindFirstChild("Blackout") then
                        local l_Blackout_0 = l_Prompt_0.Blackout;
                        if l_Blackout_0:FindFirstChild("Options") then
                            local l_Yes_0 = l_Blackout_0.Options:FindFirstChild("Yes");
                            if l_Yes_0 then
                                local l_VirtualInputManager_0 = game:GetService("VirtualInputManager");
                                local l_AbsolutePosition_0 = l_Yes_0.AbsolutePosition;
                                local l_AbsoluteSize_0 = l_Yes_0.AbsoluteSize;
                                local v598 = l_AbsolutePosition_0.X + l_AbsoluteSize_0.X / 2;
                                local v599 = l_AbsolutePosition_0.Y + l_AbsoluteSize_0.Y / 2 + 50;
                                l_VirtualInputManager_0:SendMouseButtonEvent(v598, v599, 0, true, game, 1);
                                task.wait(0.03);
                                l_VirtualInputManager_0:SendMouseButtonEvent(v598, v599, 0, false, game, 1);
                            end;
                        end;
                    end;
                end);
            end;
        end;
    end);
    ThresholdSec = v138.Farm:AddSection("Threshold Features");
    ThresholdParagraph = ThresholdSec:AddParagraph({
        Title = "Farm Threshold Panel", 
        Content = "\r\nCurrent : 0\r\nTarget : 0\r\nProgress : 0%\r\n"
    });
    local v600 = "";
    local v601 = "";
    local v602 = 0;
    local v603 = 0;
    ThresholdTotalBase = 0;
    ThresholdBase = v603;
    ThresholdTarget = v602;
    ThresholdPos2 = v601;
    ThresholdPos1 = v600;
    ThresholdSec:AddInput({
        Title = "Position 1", 
        Callback = function(v604) --[[ Line: 0 ]] --[[ Name:  ]]
            ThresholdPos1 = v604 == "" and "" or v604;
        end
    });
    ThresholdSec:AddInput({
        Title = "Position 2", 
        Callback = function(v605) --[[ Line: 0 ]] --[[ Name:  ]]
            ThresholdPos2 = v605 == "" and "" or v605;
        end
    });
    ThresholdSec:AddButton({
        Title = "Copy Current Position", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref)
            local l_LocalPlayer_3 = v0.Players.LocalPlayer;
            local l_HumanoidRootPart_5 = (l_LocalPlayer_3.Character or l_LocalPlayer_3.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_5 then
                local v608 = string.format("%.1f, %.1f, %.1f", l_HumanoidRootPart_5.Position.X, l_HumanoidRootPart_5.Position.Y, l_HumanoidRootPart_5.Position.Z);
                if setclipboard then
                    setclipboard(v608);
                end;
                chloex("Successfully copied your position to clipboard!");
            end;
        end
    });
    ThresholdSec:AddInput({
        Title = "Target Fish Caught", 
        Callback = function(v609) --[[ Line: 0 ]] --[[ Name:  ]]
            ThresholdTarget = tonumber(v609) or 0;
        end
    });
    ThresholdSec:AddToggle({
        Title = "Enable Threshold Farm", 
        Default = false, 
        Callback = function(v610) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v7 (ref)
            _G.ThresholdFarm = v610;
            if v610 then
                ThresholdBase = (v7.Data:Get({
                    "Statistics"
                }) or {}).FishCaught or 0;
                ThresholdTotalBase = ThresholdBase;
            end;
        end
    });
    CoinSec = v138.Farm:AddSection("Coin Features");
    CoinParagraph = CoinSec:AddParagraph({
        Title = "Coin Farm Panel", 
        Content = "\r\nCurrent : 0\r\nTarget : 0\r\nProgress : 0%\r\n"
    });
    v600 = 0;
    CoinBase = 0;
    CoinTarget = v600;
    CoinSpotOptions = {
        ["Kohana Volcano"] = Vector3.new(-552, 19, 183), 
        ["Tropical Grove"] = Vector3.new(-2084, 3, 3700)
    };
    CoinSec:AddDropdown({
        Title = "Coin Location", 
        Options = {
            "Kohana Volcano", 
            "Tropical Grove"
        }, 
        Multi = false, 
        Callback = function(v611) --[[ Line: 0 ]] --[[ Name:  ]]
            SelectedCoinSpot = CoinSpotOptions[v611];
        end
    });
    CoinSec:AddInput({
        Title = "Target Coin", 
        Placeholder = "Enter coin target...", 
        Callback = function(v612) --[[ Line: 0 ]] --[[ Name:  ]]
            local v613 = tonumber(v612);
            if v613 then
                CoinTarget = v613;
            end;
        end
    });
    CoinSec:AddToggle({
        Title = "Enable Coin Farm", 
        Default = false, 
        Callback = function(v614) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v7 (ref)
            _G.CoinFarm = v614;
            if v614 then
                repeat
                    task.wait();
                until v7.Data;
                CoinBase = v7.Data:Get({
                    "Coins"
                }) or 0;
            end;
        end
    });
    EnchantSec = v138.Farm:AddSection("Enchant Stone Features");
    v371 = EnchantSec:AddParagraph({
        Title = "Enchant Stone Farm Panel", 
        Content = "\r\nCurrent : 0\r\nTarget : 0\r\nProgress : 0%\r\n"
    });
    v600 = 0;
    EnchantBase = 0;
    EnchantTarget = v600;
    EnchantSpotOptions = {
        ["Tropical Grove"] = Vector3.new(-2084, 3, 3700), 
        ["Esoteric Depths"] = Vector3.new(3272, -1302, 1404)
    };
    EnchantSec:AddDropdown({
        Title = "Enchant Stone Location", 
        Options = {
            "Tropical Grove", 
            "Esoteric Depths"
        }, 
        Multi = false, 
        Callback = function(v615) --[[ Line: 0 ]] --[[ Name:  ]]
            SelectedEnchantSpot = EnchantSpotOptions[v615];
        end
    });
    EnchantSec:AddInput({
        Title = "Target Enchant Stone", 
        Placeholder = "Enter enchant stone target...", 
        Callback = function(v616) --[[ Line: 0 ]] --[[ Name:  ]]
            local v617 = tonumber(v616);
            if v617 then
                EnchantTarget = v617;
            end;
        end
    });
    EnchantSec:AddToggle({
        Title = "Enable Enchant Farm", 
        Default = false, 
        Callback = function(v618) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v7 (ref)
            _G.EnchantFarm = v618;
            if v618 then
                local v619 = v7.Data:Get({
                    "Inventory", 
                    "Items"
                }) or {};
                local v620 = 0;
                for _, v622 in ipairs(v619) do
                    if v622.Id == 10 then
                        local v623 = v620 + v622.Amount;
                        if not v623 then
                            v620 = 1;
                        else
                            v620 = v623;
                        end;
                    end;
                end;
                EnchantBase = v620;
            end;
        end
    });
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref), v0 (ref), v371 (ref)
        local v624 = false;
        local v625 = nil;
        local v626 = 0;
        while task.wait(1) do
            local l_Data_0 = v7.Data;
            do
                local l_l_Data_0_0 = l_Data_0;
                if l_l_Data_0_0 then
                    local l_Character_2 = v0.Players.LocalPlayer.Character;
                    local v630 = l_Character_2 and l_Character_2:FindFirstChild("HumanoidRootPart");
                    if v630 and not v625 then
                        v625 = v630.CFrame;
                    end;
                    do
                        local l_v630_0 = v630;
                        if _G.ThresholdFarm then
                            local v632 = (l_l_Data_0_0:Get({
                                "Statistics"
                            }) or {}).FishCaught or 0;
                            if v626 == 0 then
                                v626 = ThresholdBase;
                            end;
                            local v633 = v632 - ThresholdBase;
                            local v634 = ThresholdTarget > 0 and math.min(v633 / ThresholdTarget * 100, 100) or 0;
                            ThresholdParagraph:SetContent(string.format("Current : %s\nTarget : %s\nProgress : %.1f%%", v633, ThresholdTarget, v634));
                            do
                                local l_v632_0 = v632;
                                if l_v630_0 and ThresholdPos1 ~= "" and ThresholdPos2 ~= "" and not v624 then
                                    v624 = true;
                                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: l_v632_0 (ref), l_l_Data_0_0 (ref), l_v630_0 (ref), v624 (ref)
                                        local v636 = Vector3.new(unpack(string.split(ThresholdPos1, ",")));
                                        local v637 = Vector3.new(unpack(string.split(ThresholdPos2, ",")));
                                        local v638 = l_v632_0 + ThresholdTarget;
                                        while _G.ThresholdFarm do
                                            repeat
                                                task.wait(1);
                                                l_v632_0 = (l_l_Data_0_0:Get({
                                                    "Statistics"
                                                }) or {}).FishCaught or 0;
                                            until v638 <= l_v632_0 or not _G.ThresholdFarm;
                                            if _G.ThresholdFarm then
                                                l_v630_0.CFrame = CFrame.new(v637 + Vector3.new(0, 3, 0));
                                                ThresholdBase = l_v632_0;
                                                v638 = l_v632_0 + ThresholdTarget;
                                                repeat
                                                    task.wait(1);
                                                    l_v632_0 = (l_l_Data_0_0:Get({
                                                        "Statistics"
                                                    }) or {}).FishCaught or 0;
                                                until v638 <= l_v632_0 or not _G.ThresholdFarm;
                                                if _G.ThresholdFarm then
                                                    l_v630_0.CFrame = CFrame.new(v636 + Vector3.new(0, 3, 0));
                                                    ThresholdBase = l_v632_0;
                                                    v638 = l_v632_0 + ThresholdTarget;
                                                else
                                                    break;
                                                end;
                                            else
                                                break;
                                            end;
                                        end;
                                        v624 = false;
                                    end);
                                end;
                            end;
                        end;
                        if _G.CoinFarm then
                            local v639 = (l_l_Data_0_0:Get({
                                "Coins"
                            }) or 0) - CoinBase;
                            local v640 = CoinTarget > 0 and math.min(v639 / CoinTarget * 100, 100) or 0;
                            CoinParagraph:SetContent(string.format("Current : %s\nTarget : %s\nProgress : %.1f%%", v639, CoinTarget, v640));
                            if SelectedCoinSpot and l_v630_0 then
                                if v639 < CoinTarget then
                                    if (l_v630_0.Position - SelectedCoinSpot).Magnitude > 10 then
                                        l_v630_0.CFrame = CFrame.new(SelectedCoinSpot + Vector3.new(0, 3, 0));
                                    end;
                                else
                                    if v625 then
                                        l_v630_0.CFrame = v625;
                                    end;
                                    _G.CoinFarm = false;
                                end;
                            end;
                        end;
                        if _G.EnchantFarm then
                            local v641 = l_l_Data_0_0:Get({
                                "Inventory", 
                                "Items"
                            }) or {};
                            local v642 = 0;
                            for _, v644 in ipairs(v641) do
                                if v644.Id == 10 then
                                    local v645 = v642 + v644.Amount;
                                    if not v645 then
                                        v642 = 1;
                                    else
                                        v642 = v645;
                                    end;
                                end;
                            end;
                            local v646 = v642 - EnchantBase;
                            local v647 = EnchantTarget > 0 and math.min(v646 / EnchantTarget * 100, 100) or 0;
                            v371:SetContent(string.format("Current : %s\nTarget : %s\nProgress : %.1f%%", v646, EnchantTarget, v647));
                            if SelectedEnchantSpot and l_v630_0 then
                                if v646 < EnchantTarget then
                                    if (l_v630_0.Position - SelectedEnchantSpot).Magnitude > 10 then
                                        l_v630_0.CFrame = CFrame.new(SelectedEnchantSpot + Vector3.new(0, 3, 0));
                                    end;
                                else
                                    if v625 then
                                        l_v630_0.CFrame = v625;
                                    end;
                                    _G.EnchantFarm = false;
                                end;
                            end;
                        end;
                    end;
                else
                    task.wait(1);
                end;
            end;
        end;
    end);
    XAdm = v138.Farm:AddSection("Event Features");
    countdownParagraph = XAdm:AddParagraph({
        Title = "Ancient Lochness Monster Countdown", 
        Content = "<font color='#ff4d4d'><b>waiting for ... for joined event!</b></font>"
    });
    v8.FarmPosition = v8.FarmPosition or nil;
    v8.autoCountdownUpdate = false;
    XAdm:AddToggle({
        Title = "Auto Admin Event", 
        Default = false, 
        Callback = function(v648) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_LocalPlayer_4 = game:GetService("Players").LocalPlayer;
            v8.autoCountdownUpdate = v648;
            local function v652() --[[ Line: 0 ]] --[[ Name:  ]]
                local l_status_11, l_result_11 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    return workspace["!!! MENU RINGS"]["Event Tracker"].Main.Gui.Content.Items.Countdown.Label;
                end);
                return l_status_11 and l_result_11 or nil;
            end;
            local function v654(v653) --[[ Line: 0 ]] --[[ Name:  ]]
                v653.CFrame = CFrame.new(Vector3.new(6063, -586, 4715));
            end;
            local function v656(v655) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref)
                if v8.FarmPosition then
                    v655.CFrame = v8.FarmPosition;
                    countdownParagraph:SetContent("<font color='#00ff99'><b>\226\156\133 Returned to saved farm position!</b></font>");
                else
                    countdownParagraph:SetContent("<font color='#ff4d4d'><b>\226\157\140 No saved farm position found!</b></font>");
                end;
            end;
            if v648 then
                local v657 = (l_LocalPlayer_4.Character or l_LocalPlayer_4.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5);
                if v657 then
                    v8.FarmPosition = v657.CFrame;
                    countdownParagraph:SetContent(string.format("<font color='#00ff99'><b>Farm position saved!</b></font>"));
                end;
                local v658 = v652();
                if not v658 then
                    countdownParagraph:SetContent("<font color='#ff4d4d'><b>Label not found!</b></font>");
                    return;
                else
                    do
                        local l_v658_0 = v658;
                        task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: v8 (ref), l_v658_0 (ref), l_LocalPlayer_4 (ref), v654 (ref), v656 (ref), v652 (ref)
                            local v660 = false;
                            while v8.autoCountdownUpdate do
                                task.wait(1);
                                local v661 = "";
                                do
                                    local l_v661_0 = v661;
                                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: l_v661_0 (ref), l_v658_0 (ref)
                                        l_v661_0 = l_v658_0.Text or "";
                                    end);
                                    if l_v661_0 == "" then
                                        countdownParagraph:SetContent("<font color='#ff4d4d'><b>Waiting for countdown...</b></font>");
                                    else
                                        countdownParagraph:SetContent(string.format("<font color='#4de3ff'><b>Timer: %s</b></font>", l_v661_0));
                                        local v663 = (l_LocalPlayer_4.Character or l_LocalPlayer_4.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5);
                                        if not v663 then
                                            countdownParagraph:SetContent("<font color='#ff4d4d'><b>\226\154\160\239\184\143 HRP not found, retrying...</b></font>");
                                        else
                                            local v664, v665, v666 = l_v661_0:match("(%d+)H%s*(%d+)M%s*(%d+)S");
                                            local v667 = tonumber(v664);
                                            local v668 = tonumber(v665);
                                            v666 = tonumber(v666);
                                            v665 = v668;
                                            v664 = v667;
                                            if v664 == 3 and v665 == 59 and v666 == 59 and not v660 then
                                                countdownParagraph:SetContent("<font color='#00ff99'><b>Event started! Teleporting...</b></font>");
                                                v654(v663);
                                                v660 = true;
                                            elseif v664 == 3 and v665 == 49 and v666 == 59 and v660 then
                                                countdownParagraph:SetContent("<font color='#ffaa00'><b>Event ended! Returning...</b></font>");
                                                v656(v663);
                                                v660 = false;
                                            end;
                                        end;
                                    end;
                                    if not l_v658_0 or not l_v658_0.Parent then
                                        l_v658_0 = v652();
                                        if not l_v658_0 then
                                            countdownParagraph:SetContent("<font color='#ff4d4d'><b>Label lost. Reconnecting...</b></font>");
                                            task.wait(2);
                                            l_v658_0 = v652();
                                        end;
                                    end;
                                end;
                            end;
                        end);
                    end;
                end;
            else
                local v669 = (l_LocalPlayer_4.Character or l_LocalPlayer_4.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5);
                if v669 then
                    v656(v669);
                end;
                countdownParagraph:SetContent("<font color='#ff4d4d'><b>Auto Admin Event disabled.</b></font>");
            end;
        end
    });
    v228 = v138.Farm:AddSection("Semi Kaitun [BETA]");
    RS = game:GetService("ReplicatedStorage");
    ItemsFolder = RS:WaitForChild("Items");
    BaitsFolder = RS:WaitForChild("Baits");
    l_LocalPlayer_0 = v0.Players.LocalPlayer;
    SellEvent = v5.Net["RF/SellAllItems"];
    _G.SelectedFarmLocation = "Kohana Volcano";
    _G.DeepSeaDone = _G.DeepSeaDone or false;
    _G.ArtifactDone = _G.ArtifactDone or false;
    _G.LastArtifactTP = _G.LastArtifactTP or 0;
    getItemNameFromFolder = function(v670, v671, v672) --[[ Line: 0 ]] --[[ Name:  ]]
        for _, v674 in ipairs(v670:GetChildren()) do
            if v674:IsA("ModuleScript") then
                local l_status_12, l_result_12 = pcall(require, v674);
                if l_status_12 and l_result_12 and l_result_12.Data then
                    local l_Data_1 = l_result_12.Data;
                    if l_Data_1.Id == v671 and (not v672 or l_Data_1.Type == v672) then
                        if l_result_12.IsSkin then
                            return nil;
                        else
                            return l_Data_1.Name;
                        end;
                    end;
                end;
            end;
        end;
        return nil;
    end;
    Locations = {
        ["Kohana Volcano"] = Vector3.new(-552, 19, 183), 
        ["Tropical Grove"] = Vector3.new(-2084, 3, 3700), 
        DeepSea_Start = Vector3.new(-3599, -276, -1641), 
        DeepSea_2 = Vector3.new(-3699, -135, -890), 
        ["Arrow Artifact"] = CFrame.new(875, 3, -368) * CFrame.Angles(0, math.rad(90), 0), 
        ["Crescent Artifact"] = CFrame.new(1403, 3, 123) * CFrame.Angles(0, math.rad(180), 0), 
        ["Hourglass Diamond Artifact"] = CFrame.new(1487, 3, -842) * CFrame.Angles(0, math.rad(180), 0), 
        ["Diamond Artifact"] = CFrame.new(1844, 3, -287) * CFrame.Angles(0, math.rad(-90), 0), 
        Element_Stage1 = CFrame.new(1484, 3, -336) * CFrame.Angles(0, math.rad(180), 0), 
        Element_Stage2 = CFrame.new(1453, -22, -636), 
        Element_Final = CFrame.new(1480, 128, -593)
    };
    orderList = {
        "Arrow Artifact", 
        "Crescent Artifact", 
        "Hourglass Diamond Artifact", 
        "Diamond Artifact"
    };
    tp = function(v678) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: l_LocalPlayer_0 (ref)
        local l_HumanoidRootPart_6 = (l_LocalPlayer_0.Character or l_LocalPlayer_0.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart");
        if l_HumanoidRootPart_6 then
            l_HumanoidRootPart_6.CFrame = CFrame.new(v678);
        end;
    end;
    hasRod = function(v680) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref)
        local v681 = v7.Data:Get({
            "Inventory"
        }) or {};
        local l_ipairs_0 = ipairs;
        local v683 = v681["Fishing Rods"] or {};
        for _, v685 in l_ipairs_0(v683) do
            if getItemNameFromFolder(ItemsFolder, v685.Id, "Fishing Rods") == v680 then
                return true;
            end;
        end;
        return false;
    end;
    hasBait = function(v686) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref)
        local v687 = v7.Data:Get({
            "Inventory"
        }) or {};
        local l_ipairs_1 = ipairs;
        local v689 = v687.Baits or {};
        for _, v691 in l_ipairs_1(v689) do
            if getItemNameFromFolder(BaitsFolder, v691.Id) == v686 then
                return true;
            end;
        end;
        return false;
    end;
    hasArtifactWorld = function(v692) --[[ Line: 0 ]] --[[ Name:  ]]
        local l_workspace_FirstChild_2 = workspace:FindFirstChild("JUNGLE INTERACTIONS");
        if not l_workspace_FirstChild_2 then
            return false;
        else
            local v694 = v692:lower():gsub(" artifact", "");
            for _, v696 in ipairs(l_workspace_FirstChild_2:GetDescendants()) do
                if v696:IsA("Model") and v696.Name == "TempleLever" and tostring(v696:GetAttribute("Type") or ""):lower():find(v694) then
                    return (v696:FindFirstChild("RootPart") and v696.RootPart:FindFirstChildWhichIsA("ProximityPrompt")) == nil;
                end;
            end;
            return false;
        end;
    end;
    readTracker = function(v697) --[[ Line: 0 ]] --[[ Name:  ]]
        local l_FirstChild_2 = workspace["!!! MENU RINGS"]:FindFirstChild(v697);
        if not l_FirstChild_2 then
            return "";
        else
            local v699 = l_FirstChild_2:FindFirstChild("Board") and l_FirstChild_2.Board:FindFirstChild("Gui") and l_FirstChild_2.Board.Gui:FindFirstChild("Content");
            if not v699 then
                return "";
            else
                local v700 = {};
                local v701 = 1;
                for _, v703 in ipairs(v699:GetChildren()) do
                    if v703:IsA("TextLabel") and v703.Name ~= "Header" then
                        table.insert(v700, v701 .. ". " .. v703.Text);
                        v701 = v701 + 1;
                    end;
                end;
                return table.concat(v700, "\n");
            end;
        end;
    end;
    hasArtifactInv = function(v704) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref)
        local v705 = {
            ["Arrow Artifact"] = 265, 
            ["Crescent Artifact"] = 266, 
            ["Diamond Artifact"] = 267, 
            ["Hourglass Diamond Artifact"] = 271
        };
        local v706 = (v7.Data:Get({
            "Inventory"
        }) or {}).Items or {};
        local v707 = v705[v704];
        if not v707 then
            return false;
        else
            for _, v709 in ipairs(v706) do
                if v709.Id == v707 then
                    return true;
                end;
            end;
            return false;
        end;
    end;
    tp = function(v710) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: l_LocalPlayer_0 (ref)
        local l_HumanoidRootPart_7 = (l_LocalPlayer_0.Character or l_LocalPlayer_0.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart");
        if not l_HumanoidRootPart_7 then
            return;
        else
            if typeof(v710) == "Vector3" then
                l_HumanoidRootPart_7.CFrame = CFrame.new(v710);
            else
                l_HumanoidRootPart_7.CFrame = v710;
            end;
            return;
        end;
    end;
    getLeverStatus = function() --[[ Line: 0 ]] --[[ Name:  ]]
        local l_workspace_FirstChild_3 = workspace:FindFirstChild("JUNGLE INTERACTIONS");
        if not l_workspace_FirstChild_3 then
            return {};
        else
            local v713 = {};
            local v714 = 1;
            for _, v716 in ipairs(l_workspace_FirstChild_3:GetDescendants()) do
                if v716:IsA("Model") and v716.Name == "TempleLever" then
                    local v717 = v716:FindFirstChild("RootPart") and v716.RootPart:FindFirstChildWhichIsA("ProximityPrompt");
                    v713[v716:GetAttribute("Type") or "Lever" .. v714] = v717 == nil;
                    v714 = v714 + 1;
                end;
            end;
            return v713;
        end;
    end;
    s = getLeverStatus();
    seg = function(v718, v719) --[[ Line: 0 ]] --[[ Name:  ]]
        return ("%s : <b><font color=\"rgb(%s)\">%s</font></b>"):format(v718 == "Hourglass Diamond Artifact" and "Hourglass Diamond" or v718 == "Arrow Artifact" and "Arrow" or v718 == "Crescent Artifact" and "Crescent" or "Diamond", v719 and "0,255,0" or "255,0,0", v719 and "ACTIVE" or "DISABLE");
    end;
    triggerLever = function(v720) --[[ Line: 0 ]] --[[ Name:  ]]
        local l_workspace_FirstChild_4 = workspace:FindFirstChild("JUNGLE INTERACTIONS");
        if not l_workspace_FirstChild_4 then
            return;
        else
            local v722 = string.match(v720, "^(%w+)");
            for _, v724 in ipairs(l_workspace_FirstChild_4:GetDescendants()) do
                if v724:IsA("Model") and v724.Name == "TempleLever" then
                    local l_v724_Attribute_0 = v724:GetAttribute("Type");
                    local v726 = v724:FindFirstChild("RootPart") and v724.RootPart:FindFirstChildWhichIsA("ProximityPrompt");
                    if l_v724_Attribute_0 and string.find(l_v724_Attribute_0:lower(), v722:lower()) and v726 then
                        print("[AUTO] Triggering lever:", l_v724_Attribute_0);
                        do
                            local l_v726_0 = v726;
                            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                -- upvalues: l_v726_0 (ref)
                                fireproximityprompt(l_v726_0);
                            end);
                        end;
                        break;
                    else
                        --[[ close >= 8 ]]
                    end;
                end;
            end;
            return;
        end;
    end;
    v228:AddDropdown({
        Title = "Farming Location", 
        Options = {
            "Kohana Volcano", 
            "Tropical Grove"
        }, 
        Default = "Kohana Volcano", 
        Callback = function(v728) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.SelectedFarmLocation = v728;
        end
    });
    v228:AddToggle({
        Title = "Start Kaitun", 
        Default = false, 
        Callback = function(v729) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref), v7 (ref), v6 (ref)
            _G.KaitunPanel = v729;
            if v729 then
                if v0.CoreGui:FindFirstChild("ChloeX_KaitunPanel") then
                    v0.CoreGui:FindFirstChild("ChloeX_KaitunPanel"):Destroy();
                end;
                local l_ScreenGui_2 = Instance.new("ScreenGui");
                l_ScreenGui_2.Name = "ChloeX_KaitunPanel";
                l_ScreenGui_2.IgnoreGuiInset = true;
                l_ScreenGui_2.ResetOnSpawn = false;
                l_ScreenGui_2.ZIndexBehavior = Enum.ZIndexBehavior.Global;
                l_ScreenGui_2.Parent = v0.CoreGui;
                local v731 = Instance.new("Frame", l_ScreenGui_2);
                v731.Size = UDim2.new(0, 500, 0, 250);
                v731.AnchorPoint = Vector2.new(0.5, 0.5);
                v731.Position = UDim2.new(0.5, 0, 0.5, 0);
                v731.BackgroundColor3 = Color3.fromRGB(20, 22, 35);
                v731.BorderSizePixel = 0;
                v731.Active = true;
                v731.Draggable = true;
                local v732 = Instance.new("TextLabel", v731);
                v732.Size = UDim2.new(1, -20, 0, 36);
                v732.Position = UDim2.new(0, 10, 0, 8);
                v732.BackgroundTransparency = 1;
                v732.Font = Enum.Font.GothamBold;
                v732.Text = "CHLOEX KAITUN PANEL";
                v732.TextSize = 22;
                v732.TextColor3 = Color3.fromRGB(255, 255, 255);
                v732.TextXAlignment = Enum.TextXAlignment.Center;
                local v733 = Instance.new("UIGradient", v732);
                v733.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)), 
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 90, 255)), 
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
                });
                v733.Rotation = 0;
                local v734 = Instance.new("UIStroke", v731);
                v734.Thickness = 2;
                v734.Color = Color3.fromRGB(80, 150, 255);
                v734.Transparency = 0.35;
                Instance.new("UICorner", v731).CornerRadius = UDim.new(0, 14);
                local l_UserInputService_0 = game:GetService("UserInputService");
                local l_TweenService_1 = game:GetService("TweenService");
                local v737 = false;
                local v738 = false;
                local v739 = nil;
                local v740 = nil;
                local v741 = nil;
                local l_ImageButton_0 = Instance.new("ImageButton");
                l_ImageButton_0.Name = "ResizeHandle";
                l_ImageButton_0.Parent = v731;
                l_ImageButton_0.Size = UDim2.new(0, 24, 0, 24);
                l_ImageButton_0.AnchorPoint = Vector2.new(1, 1);
                l_ImageButton_0.Position = UDim2.new(1, -6, 1, -6);
                l_ImageButton_0.Image = "rbxassetid://6153965696";
                l_ImageButton_0.BackgroundTransparency = 1;
                l_ImageButton_0.ZIndex = 10;
                l_ImageButton_0.Active = true;
                local function v744(v743) --[[ Line: 0 ]] --[[ Name:  ]]
                    return v743.UserInputType == Enum.UserInputType.MouseButton1 or v743.UserInputType == Enum.UserInputType.Touch;
                end;
                do
                    local l_v731_0, l_l_UserInputService_0_0, l_l_TweenService_1_0, l_v737_0, l_v738_0, l_v739_0, l_v740_0, l_v741_0, l_v744_0 = v731, l_UserInputService_0, l_TweenService_1, v737, v738, v739, v740, v741, v744;
                    local function v762(_, v755) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_l_UserInputService_0_0 (ref), l_v737_0 (ref), l_v739_0 (ref), l_v731_0 (ref), l_v740_0 (ref), l_v738_0 (ref), l_v741_0 (ref), l_l_TweenService_1_0 (ref)
                        local v756 = nil;
                        v756 = l_l_UserInputService_0_0.InputChanged:Connect(function(v757) --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: v755 (ref), l_v737_0 (ref), l_v739_0 (ref), l_v731_0 (ref), l_v740_0 (ref), l_v738_0 (ref), l_v741_0 (ref), l_l_TweenService_1_0 (ref), v756 (ref)
                            if v757.UserInputType == Enum.UserInputType.MouseMovement or v757.UserInputType == Enum.UserInputType.Touch then
                                if v755 == "drag" and l_v737_0 then
                                    local v758 = v757.Position - l_v739_0;
                                    l_v731_0.Position = UDim2.new(l_v740_0.X.Scale, l_v740_0.X.Offset + v758.X, l_v740_0.Y.Scale, l_v740_0.Y.Offset + v758.Y);
                                elseif v755 == "resize" and l_v738_0 then
                                    local v759 = v757.Position - l_v739_0;
                                    local v760 = math.clamp(l_v741_0.X.Offset + v759.X, 350, 700);
                                    local v761 = math.clamp(l_v741_0.Y.Offset + v759.Y, 250, 900);
                                    l_l_TweenService_1_0:Create(l_v731_0, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                                        Size = UDim2.new(0, v760, 0, v761)
                                    }):Play();
                                else
                                    v756:Disconnect();
                                end;
                            end;
                        end);
                    end;
                    l_v731_0.InputBegan:Connect(function(v763) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v744_0 (ref), l_v738_0 (ref), l_v737_0 (ref), l_v739_0 (ref), l_v740_0 (ref), l_v731_0 (ref), v762 (ref)
                        if l_v744_0(v763) and not l_v738_0 then
                            l_v737_0 = true;
                            l_v739_0 = v763.Position;
                            l_v740_0 = l_v731_0.Position;
                            v762(v763, "drag");
                        end;
                    end);
                    l_v731_0.InputEnded:Connect(function(v764) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v744_0 (ref), l_v737_0 (ref)
                        if l_v744_0(v764) then
                            l_v737_0 = false;
                        end;
                    end);
                    l_ImageButton_0.InputBegan:Connect(function(v765) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v744_0 (ref), l_v738_0 (ref), l_v741_0 (ref), l_v731_0 (ref), l_v739_0 (ref), v762 (ref)
                        if l_v744_0(v765) then
                            l_v738_0 = true;
                            l_v741_0 = l_v731_0.Size;
                            l_v739_0 = v765.Position;
                            v762(v765, "resize");
                        end;
                    end);
                    l_ImageButton_0.InputEnded:Connect(function(v766) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v744_0 (ref), l_v738_0 (ref)
                        if l_v744_0(v766) then
                            l_v738_0 = false;
                        end;
                    end);
                    local v767 = Instance.new("ScrollingFrame", l_v731_0);
                    v767.Position = UDim2.new(0, 0, 0, 50);
                    v767.Size = UDim2.new(1, 0, 1, -60);
                    v767.BackgroundTransparency = 1;
                    v767.ScrollBarThickness = 0;
                    v767.ScrollingDirection = Enum.ScrollingDirection.Y;
                    v767.AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    v767.CanvasSize = UDim2.new(0, 0, 0, 0);
                    v767.VerticalScrollBarInset = Enum.ScrollBarInset.Always;
                    local v768 = Instance.new("UIListLayout", v767);
                    v768.Padding = UDim.new(0, 10);
                    v768.SortOrder = Enum.SortOrder.LayoutOrder;
                    local function v774(v769, v770) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v767 (ref)
                        local v771 = Instance.new("TextLabel", v767);
                        v771.Size = UDim2.new(1, -30, 0, 25);
                        v771.Font = Enum.Font.GothamBold;
                        v771.TextSize = 18;
                        v771.BackgroundTransparency = 1;
                        v771.TextColor3 = Color3.fromRGB(140, 200, 255);
                        v771.Text = v769;
                        v771.TextXAlignment = Enum.TextXAlignment.Left;
                        local v772 = Instance.new("Frame", v767);
                        v772.Size = UDim2.new(1, -30, 0, v770 or 80);
                        v772.BackgroundTransparency = 1;
                        local v773 = Instance.new("TextLabel", v772);
                        v773.Size = UDim2.new(1, 0, 1, 0);
                        v773.Font = Enum.Font.Gotham;
                        v773.TextSize = 16;
                        v773.BackgroundTransparency = 1;
                        v773.TextColor3 = Color3.fromRGB(255, 255, 255);
                        v773.TextXAlignment = Enum.TextXAlignment.Left;
                        v773.TextYAlignment = Enum.TextYAlignment.Top;
                        v773.TextWrapped = true;
                        v773.Text = "Loading...";
                        v773.RichText = true;
                        return v773;
                    end;
                    local v775 = v774("OWNED RODS", 50);
                    local v776 = v774("OWNED BAITS", 50);
                    local v777 = v774("FARMING PROGRESS", 40);
                    local v778 = v774("COINS", 30);
                    local v779 = v774("DEEP SEA QUEST", 120);
                    local v780 = v774("ARTIFACT QUEST", 120);
                    local v781 = v774("ELEMENT QUEST", 120);
                    local v782 = v774("FLOW STATUS", 50);
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        while _G.KaitunPanel do
                            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                SellEvent:InvokeServer();
                            end);
                            task.wait(1);
                        end;
                    end);
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v7 (ref), v778 (ref), v775 (ref), v776 (ref), v779 (ref), v781 (ref), v780 (ref), v782 (ref), v6 (ref), v777 (ref)
                        while _G.KaitunPanel do
                            task.wait(1);
                            local l_Data_2 = v7.Data;
                            if not l_Data_2 then
                                task.wait(1);
                            else
                                local v784 = l_Data_2:Get({
                                    "Coins"
                                }) or 0;
                                v778.Text = "$" .. tostring(v784);
                                local v785 = l_Data_2:Get({
                                    "Inventory"
                                }) or {};
                                local v786 = {};
                                local v787 = {};
                                local l_ipairs_2 = ipairs;
                                local v789 = v785["Fishing Rods"] or {};
                                for _, v791 in l_ipairs_2(v789) do
                                    local v792 = getItemNameFromFolder(ItemsFolder, v791.Id, "Fishing Rods");
                                    if v792 then
                                        table.insert(v786, v792);
                                    end;
                                end;
                                l_ipairs_2 = ipairs;
                                v789 = v785.Baits or {};
                                for _, v794 in l_ipairs_2(v789) do
                                    local v795 = getItemNameFromFolder(BaitsFolder, v794.Id);
                                    if v795 then
                                        table.insert(v787, v795);
                                    end;
                                end;
                                v775.Text = #v786 > 0 and table.concat(v786, ", ") or "No rods found.";
                                v776.Text = #v787 > 0 and table.concat(v787, ", ") or "No baits found.";
                                v779.Text = readTracker("Deep Sea Tracker");
                                v781.Text = readTracker("Element Tracker");
                                seg = function(v796) --[[ Line: 0 ]] --[[ Name:  ]]
                                    local v797 = hasArtifactWorld(v796);
                                    local v798 = v796 == "Hourglass Diamond Artifact" and "Hourglass Diamond" or v796 == "Arrow Artifact" and "Arrow" or v796 == "Crescent Artifact" and "Crescent" or "Diamond";
                                    local v799 = v797 and "0,255,0" or "255,0,0";
                                    return string.format("%s : <b><font color='rgb(%s)'>%s</font></b>", v798, v799, v797 and "ACTIVE" or "DISABLE");
                                end;
                                v780.Text = table.concat({
                                    seg("Arrow Artifact"), 
                                    seg("Crescent Artifact"), 
                                    seg("Hourglass Diamond Artifact"), 
                                    seg("Diamond Artifact")
                                }, "\n");
                                if not hasRod("Midnight Rod") then
                                    v782.Text = "Status: Buying Midnight Rod";
                                    if v784 >= 53000 then
                                        task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref)
                                            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                                -- upvalues: v6 (ref)
                                                v6.Functions.BuyRod:InvokeServer(80);
                                            end);
                                            task.wait(2);
                                            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                                -- upvalues: v6 (ref)
                                                v6.Functions.BuyBait:InvokeServer(3);
                                            end);
                                        end);
                                    else
                                        v777.Text = "Farming coins... (" .. v784 .. "/53000)";
                                        v782.Text = "Status: Farming";
                                        tp(Locations[_G.SelectedFarmLocation or "Kohana Volcano"]);
                                    end;
                                elseif hasRod("Midnight Rod") and not hasRod("Astral Rod") and v784 >= 1000000 then
                                    v782.Text = "Status: Buying Astral Rod";
                                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: v6 (ref)
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref)
                                            v6.Functions.BuyRod:InvokeServer(5);
                                        end);
                                        task.wait(2);
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref)
                                            v6.Functions.BuyBait:InvokeServer(15);
                                        end);
                                    end);
                                elseif hasRod("Astral Rod") and not hasBait("Floral Bait") and v784 >= 4000000 then
                                    v782.Text = "Status: Buying Floral Bait";
                                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: v6 (ref)
                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                            -- upvalues: v6 (ref)
                                            v6.Functions.BuyBait:InvokeServer(20);
                                        end);
                                    end);
                                elseif hasRod("Midnight Rod") and not _G.DeepSeaDone then
                                    v782.Text = "Status: Deep Sea Quest";
                                    l_ipairs_2 = nil;
                                    _G.DeepSeaDone = false;
                                    while _G.KaitunPanel and not _G.DeepSeaDone do
                                        v779.Text = readTracker("Deep Sea Tracker");
                                        v789 = v779.Text:lower();
                                        print("[DEBUG Deep Sea Text]\n" .. v789);
                                        local v800 = string.find(v789, "catch 1 secret fish at sisyphus statue %- 100%%");
                                        local v801 = string.find(v789, "catch 3 mythic fish at sisyphus statue %- 100%%");
                                        local v802 = string.find(v789, "treasure room %- 100%%");
                                        local v803 = string.find(v789, "earn 1m coins %- 100%%");
                                        if v802 and (v800 or v801) and v803 then
                                            _G.DeepSeaDone = true;
                                            break;
                                        else
                                            if v802 and not v800 and not v801 then
                                                if l_ipairs_2 ~= "DeepSea_2" then
                                                    print("[DEBUG] Teleporting to Sisyphus (DeepSea_2)");
                                                    tp(Locations.DeepSea_2);
                                                    l_ipairs_2 = "DeepSea_2";
                                                end;
                                            elseif not v802 and l_ipairs_2 ~= "DeepSea_Start" then
                                                print("[DEBUG] Teleporting to Treasure Room (DeepSea_Start)");
                                                tp(Locations.DeepSea_Start);
                                                l_ipairs_2 = "DeepSea_Start";
                                            end;
                                            task.wait(1);
                                        end;
                                    end;
                                elseif _G.DeepSeaDone and not _G.ArtifactDone then
                                    v782.Text = "Status: Artifact Quest";
                                    _G.ArtifactDone = false;
                                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                        -- upvalues: v782 (ref)
                                        while _G.KaitunPanel and not _G.ArtifactDone do
                                            for _, v805 in ipairs(orderList) do
                                                if not hasArtifactWorld(v805) then
                                                    v782.Text = "Status: Collecting " .. v805;
                                                    tp(Locations[v805]);
                                                    repeat
                                                        task.wait(2);
                                                    until hasArtifactInv(v805) or hasArtifactWorld(v805) or not _G.KaitunPanel;
                                                    if hasArtifactInv(v805) or hasArtifactWorld(v805) then
                                                        v782.Text = "Status: Triggering " .. v805;
                                                        triggerLever(v805);
                                                        local v806 = tick();
                                                        repeat
                                                            task.wait(1);
                                                        until hasArtifactWorld(v805) or tick() - v806 > 10 or not _G.KaitunPanel;
                                                    end;
                                                end;
                                            end;
                                            if hasArtifactWorld("Arrow Artifact") and hasArtifactWorld("Crescent Artifact") and hasArtifactWorld("Hourglass Diamond Artifact") and hasArtifactWorld("Diamond Artifact") then
                                                _G.ArtifactDone = true;
                                                v782.Text = "Status: Artifact Quest Complete \226\156\133";
                                            end;
                                            task.wait(3);
                                        end;
                                    end);
                                elseif not _G.ElementDone then
                                    v782.Text = "Status: Element Quest";
                                    _G.ElementDone = false;
                                    l_ipairs_2 = nil;
                                    while _G.KaitunPanel and not _G.ElementDone do
                                        v781.Text = readTracker("Element Tracker");
                                        v789 = v781.Text:lower();
                                        print("[DEBUG Element Text]\n" .. v789);
                                        local v807 = v789:find("catch 1 secret fish at sacred temple %- 100%%");
                                        local v808 = v789:find("catch 1 secret fish at ancient jungle %- 100%%");
                                        local v809 = v789:find("create 3 transcended stones %- 100%%");
                                        if v807 and v808 and v809 then
                                            _G.ElementDone = true;
                                            v782.Text = "Status: Element Quest Complete \226\156\133";
                                            break;
                                        else
                                            if not v808 then
                                                if l_ipairs_2 ~= "Element_Stage1" then
                                                    tp(Locations.Element_Stage1);
                                                    l_ipairs_2 = "Element_Stage1";
                                                end;
                                            elseif v808 and not v807 then
                                                if l_ipairs_2 ~= "Element_Stage2" then
                                                    tp(Locations.Element_Stage2);
                                                    l_ipairs_2 = "Element_Stage2";
                                                end;
                                            elseif v808 and v807 and not v809 and l_ipairs_2 ~= "Element_Final" then
                                                tp(Locations.Element_Final);
                                                l_ipairs_2 = "Element_Final";
                                            end;
                                            task.wait(1);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end);
                end;
            else
                _G.KaitunPanel = false;
                local l_ChloeX_KaitunPanel_0 = v0.CoreGui:FindFirstChild("ChloeX_KaitunPanel");
                if l_ChloeX_KaitunPanel_0 then
                    l_ChloeX_KaitunPanel_0:Destroy();
                end;
            end;
        end
    });
    v228:AddToggle({
        Title = "Hide Kaitun Panel", 
        Default = false, 
        Callback = function(v811) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref)
            local l_ChloeX_KaitunPanel_1 = v0.CoreGui:FindFirstChild("ChloeX_KaitunPanel");
            if l_ChloeX_KaitunPanel_1 then
                local v813 = l_ChloeX_KaitunPanel_1:FindFirstChild("MainCard") or l_ChloeX_KaitunPanel_1:FindFirstChildWhichIsA("Frame");
                if v813 then
                    v813.Visible = not v811;
                end;
            end;
        end
    });
    RodPriority = {
        "Element Rod", 
        "Ghostfin Rod", 
        "Bambo Rod", 
        "Angler Rod", 
        "Ares Rod", 
        "Hazmat Rod", 
        "Astral Rod", 
        "Midnight Rod"
    };
    equipBestRod = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref), v6 (ref)
        local l_Data_3 = v7.Data;
        if not l_Data_3 then
            return;
        else
            local v815 = (l_Data_3:Get({
                "Inventory"
            }) or {})["Fishing Rods"] or {};
            local v816 = (l_Data_3:Get({
                "EquippedItems"
            }) or {})["Fishing Rods"];
            local l_huge_0 = math.huge;
            local v818 = nil;
            local v819 = nil;
            for _, v821 in ipairs(v815) do
                local v822 = getItemNameFromFolder(ItemsFolder, v821.Id, "Fishing Rods");
                if v822 and v821.UUID then
                    for v823, v824 in ipairs(RodPriority) do
                        if string.find(v822, v824) and v823 < l_huge_0 then
                            l_huge_0 = v823;
                            v818 = v822;
                            v819 = v821.UUID;
                        end;
                    end;
                end;
            end;
            if not v819 or v816 == v819 then
                return;
            else
                print("[AUTO EQUIP] Equipping best rod:", v818);
                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v6 (ref), v819 (ref)
                    v6.Functions.Cancel:InvokeServer();
                    task.wait(0.3);
                    v6.Events.REEquipItem:FireServer(v819, "Fishing Rods");
                end);
                return;
            end;
        end;
    end;
    v228:AddToggle({
        Title = "Auto Equip Best Rod", 
        Default = false, 
        Callback = function(v825) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v7 (ref), v6 (ref)
            _G.AutoEquipBestRod = v825;
            if not v825 then
                return;
            else
                local l_Data_4 = v7.Data;
                if not l_Data_4 then
                    return;
                else
                    local v827 = (l_Data_4:Get({
                        "Inventory"
                    }) or {})["Fishing Rods"] or {};
                    local v828 = (l_Data_4:Get({
                        "EquippedItems"
                    }) or {})["Fishing Rods"];
                    local l_huge_1 = math.huge;
                    local v830 = nil;
                    local v831 = nil;
                    for _, v833 in ipairs(v827) do
                        local v834 = getItemNameFromFolder(ItemsFolder, v833.Id, "Fishing Rods");
                        if v834 and v833.UUID then
                            for v835, v836 in ipairs(RodPriority) do
                                if string.find(v834, v836) and v835 < l_huge_1 then
                                    l_huge_1 = v835;
                                    v830 = v834;
                                    v831 = v833.UUID;
                                end;
                            end;
                        end;
                    end;
                    if v831 and v828 ~= v831 then
                        print("[AUTO EQUIP] Equipping best rod:", v830);
                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: v6 (ref), v831 (ref)
                            v6.Functions.Cancel:InvokeServer();
                            task.wait(0.3);
                            v6.Events.REEquipItem:FireServer(v831, "Fishing Rods");
                            task.wait(0.3);
                            v6.Events.REEquip:FireServer(1);
                        end);
                    else
                        print("[AUTO EQUIP] Already using best rod or none found.");
                    end;
                    return;
                end;
            end;
        end
    });
    v600 = v138.Quest:AddSection("Artifact Lever Location");
    v601 = workspace:WaitForChild("JUNGLE INTERACTIONS");
    v602 = 1;
    v603 = false;
    local v837 = nil;
    local v838 = "0,255,0";
    local v839 = "255,0,0";
    _G.artifactPositions = {
        ["Arrow Artifact"] = CFrame.new(875, 3, -368) * CFrame.Angles(0, math.rad(90), 0), 
        ["Crescent Artifact"] = CFrame.new(1403, 3, 123) * CFrame.Angles(0, math.rad(180), 0), 
        ["Hourglass Diamond Artifact"] = CFrame.new(1487, 3, -842) * CFrame.Angles(0, math.rad(180), 0), 
        ["Diamond Artifact"] = CFrame.new(1844, 3, -287) * CFrame.Angles(0, math.rad(-90), 0)
    };
    local v840 = {
        "Arrow Artifact", 
        "Crescent Artifact", 
        "Hourglass Diamond Artifact", 
        "Diamond Artifact"
    };
    local function v844() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v601 (ref)
        local v841 = {};
        for _, v843 in ipairs(v601:GetDescendants()) do
            if v843:IsA("Model") and v843.Name == "TempleLever" then
                v841[v843:GetAttribute("Type")] = not v843:FindFirstChild("RootPart") or not v843.RootPart:FindFirstChildWhichIsA("ProximityPrompt");
            end;
        end;
        return v841;
    end;
    local function v849(v845) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v838 (ref), v839 (ref)
        local function v848(v846, v847) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v838 (ref), v839 (ref)
            return ("%s : <b><font color=\"rgb(%s)\">%s</font></b>"):format(v846 == "Hourglass Diamond Artifact" and "Hourglass Diamond" or v846 == "Arrow Artifact" and "Arrow" or v846 == "Crescent Artifact" and "Crescent" or "Diamond", v847 and v838 or v839, v847 and "ACTIVE" or "DISABLE");
        end;
        ArtifactParagraph:SetContent(table.concat({
            v848("Arrow Artifact", v845["Arrow Artifact"]), 
            v848("Crescent Artifact", v845["Crescent Artifact"]), 
            v848("Hourglass Diamond Artifact", v845["Hourglass Diamond Artifact"]), 
            v848("Diamond Artifact", v845["Diamond Artifact"])
        }, "\n"));
    end;
    local function v854(v850) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v601 (ref)
        for _, v852 in ipairs(v601:GetDescendants()) do
            if v852:IsA("Model") and v852.Name == "TempleLever" and v852:GetAttribute("Type") == v850 then
                local v853 = v852:FindFirstChild("RootPart") and v852.RootPart:FindFirstChildWhichIsA("ProximityPrompt");
                if v853 then
                    fireproximityprompt(v853);
                    break;
                else
                    break;
                end;
            end;
        end;
    end;
    ArtifactParagraph = v600:AddParagraph({
        Title = "Panel Progress Artifact", 
        Content = "\r\nArrow : <b><font color=\"rgb(255,0,0)\">DISABLE</font></b>\r\nCrescent : <b><font color=\"rgb(255,0,0)\">DISABLE</font></b>\r\nHourglass Diamond : <b><font color=\"rgb(255,0,0)\">DISABLE</font></b>\r\nDiamond : <b><font color=\"rgb(255,0,0)\">DISABLE</font></b>\r\n"
    });
    v6.Events.REFishGot.OnClientEvent:Connect(function(v855) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v603 (ref), v837 (ref), v854 (ref)
        if not v603 or not v837 then
            return;
        else
            local v856 = string.split(v837, " ")[1];
            if v856 and string.find(v855, v856, 1, true) then
                task.wait(0);
                v854(v837);
                v837 = nil;
            end;
            return;
        end;
    end);
    v600:AddToggle({
        Title = "Artifact Progress", 
        Default = false, 
        Callback = function(v857) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v603 (ref), v844 (ref), v849 (ref), v840 (ref), v837 (ref), l_LocalPlayer_0 (ref), v602 (ref)
            v603 = v857;
            if v857 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v603 (ref), v844 (ref), v849 (ref), v840 (ref), v837 (ref), l_LocalPlayer_0 (ref), v602 (ref)
                    local v858 = false;
                    while v603 do
                        local v859 = v844();
                        local v860 = true;
                        for _, v862 in pairs(v859) do
                            if not v862 then
                                v860 = false;
                                break;
                            end;
                        end;
                        v849(v859);
                        if v860 then
                            v603 = false;
                            break;
                        else
                            for _, v864 in ipairs(v840) do
                                if not v859[v864] then
                                    v837 = v864;
                                    local l_HumanoidRootPart_8 = (l_LocalPlayer_0.Character or l_LocalPlayer_0.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart");
                                    if l_HumanoidRootPart_8 and _G.artifactPositions[v864] then
                                        l_HumanoidRootPart_8.CFrame = _G.artifactPositions[v864];
                                    end;
                                    repeat
                                        task.wait(v602);
                                        v858 = not v837 or not v603;
                                    until v858;
                                end;
                                if v858 then
                                    break;
                                end;
                            end;
                            v858 = false;
                            task.wait(v602);
                        end;
                    end;
                end);
            end;
        end
    });
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v602 (ref), v849 (ref), v844 (ref)
        while task.wait(v602) do
            v849(v844());
        end;
    end);
    v600:AddButton({
        Title = "Arrow", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_9 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_9 then
                l_HumanoidRootPart_9.CFrame = _G.artifactPositions["Arrow Artifact"];
            end;
        end, 
        SubTitle = "Hourglass Diamond", 
        SubCallback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_10 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_10 then
                l_HumanoidRootPart_10.CFrame = _G.artifactPositions["Hourglass Diamond Artifact"];
            end;
        end
    });
    v600:AddButton({
        Title = "Crescent", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_11 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_11 then
                l_HumanoidRootPart_11.CFrame = _G.artifactPositions["Crescent Artifact"];
            end;
        end, 
        SubTitle = "Diamond", 
        SubCallback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_12 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_12 then
                l_HumanoidRootPart_12.CFrame = _G.artifactPositions["Diamond Artifact"];
            end;
        end
    });
    local v870 = v138.Quest:AddSection("Sisyphus Statue Quest");
    local v871 = v870:AddParagraph({
        Title = "Deep Sea Panel", 
        Content = ""
    });
    v870:AddDivider();
    v870:AddToggle({
        Title = "Auto Deep Sea Quest", 
        Content = "Automatically complete Deep Sea Quest!", 
        Default = false, 
        Callback = function(v872) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.autoDeepSea = v872;
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref)
                while v8.autoDeepSea do
                    local l_workspace_FirstChild_5 = workspace:FindFirstChild("!!! MENU RINGS");
                    local v874 = l_workspace_FirstChild_5 and l_workspace_FirstChild_5:FindFirstChild("Deep Sea Tracker");
                    if v874 then
                        local v875 = v874:FindFirstChild("Board") and v874.Board:FindFirstChild("Gui") and v874.Board.Gui:FindFirstChild("Content");
                        if v875 then
                            local v876 = nil;
                            for _, v878 in ipairs(v875:GetChildren()) do
                                if v878:IsA("TextLabel") and v878.Name ~= "Header" then
                                    v876 = v878;
                                    break;
                                end;
                            end;
                            if v876 then
                                local v879 = string.lower(v876.Text);
                                local v880 = v8.player.Character and v8.player.Character:FindFirstChild("HumanoidRootPart");
                                if v880 then
                                    if string.find(v879, "100%%") then
                                        v880.CFrame = CFrame.new(-3763, -135, -995) * CFrame.Angles(0, math.rad(180), 0);
                                    else
                                        v880.CFrame = CFrame.new(-3599, -276, -1641);
                                    end;
                                end;
                            end;
                        end;
                    end;
                    task.wait(1);
                end;
            end);
        end
    });
    v870:AddButton({
        Title = "Treasure Room", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_13 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_13 then
                l_HumanoidRootPart_13.CFrame = CFrame.new(-3601, -283, -1611);
            end;
        end, 
        SubTitle = "Sisyphus Statue", 
        SubCallback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_14 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_14 then
                l_HumanoidRootPart_14.CFrame = CFrame.new(-3698, -135, -1008);
            end;
        end
    });
    local v883 = v138.Quest:AddSection("Element Quest");
    local v884 = v883:AddParagraph({
        Title = "Element Panel", 
        Content = ""
    });
    v883:AddDivider();
    v883:AddToggle({
        Title = "Auto Element Quest", 
        Content = "Automatically teleport through Element quest stages.", 
        Default = false, 
        Callback = function(v885) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v884 (ref)
            v8.autoElement = v885;
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref), v884 (ref)
                local v886 = false;
                while v8.autoElement and not v886 do
                    local l_workspace_FirstChild_6 = workspace:FindFirstChild("!!! MENU RINGS");
                    local v888 = l_workspace_FirstChild_6 and l_workspace_FirstChild_6:FindFirstChild("Element Tracker");
                    if v888 then
                        local v889 = v888:FindFirstChild("Board") and v888.Board:FindFirstChild("Gui") and v888.Board.Gui:FindFirstChild("Content");
                        if v889 then
                            local v890 = {};
                            for _, v892 in ipairs(v889:GetChildren()) do
                                if v892:IsA("TextLabel") and v892.Name ~= "Header" then
                                    table.insert(v890, string.lower(v892.Text));
                                end;
                            end;
                            local v893 = v8.player.Character and v8.player.Character:FindFirstChild("HumanoidRootPart");
                            if v893 and #v890 >= 4 then
                                local v894 = v890[2];
                                local v895 = v890[4];
                                if not string.find(v895, "100%%") then
                                    v893.CFrame = CFrame.new(1484, 3, -336) * CFrame.Angles(0, math.rad(180), 0);
                                elseif string.find(v895, "100%%") and not string.find(v894, "100%%") then
                                    v893.CFrame = CFrame.new(1453, -22, -636);
                                elseif string.find(v894, "100%%") then
                                    v893.CFrame = CFrame.new(1480, 128, -593);
                                    v886 = true;
                                    v8.autoElement = false;
                                    if v884 and v884.SetContent then
                                        v884:SetContent("Element Quest Completed!");
                                    end;
                                end;
                            end;
                        end;
                    end;
                    task.wait(2);
                end;
            end);
        end
    });
    v883:AddButton({
        Title = "Secred Temple", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_15 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_15 then
                l_HumanoidRootPart_15.CFrame = CFrame.new(1453, -22, -636);
            end;
        end, 
        SubTitle = "Underground Cellar", 
        SubCallback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_16 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_16 then
                l_HumanoidRootPart_16.CFrame = CFrame.new(2136, -91, -701);
            end;
        end
    });
    v883:AddButton({
        Title = "Transcended Stones", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            local l_HumanoidRootPart_17 = (v8.player.Character or v8.player.CharacterAdded:Wait()):FindFirstChild("HumanoidRootPart");
            if l_HumanoidRootPart_17 then
                l_HumanoidRootPart_17.CFrame = CFrame.new(1480, 128, -593);
            end;
        end
    });
    local function v906(v899) --[[ Line: 0 ]] --[[ Name:  ]]
        local l_FirstChild_3 = workspace["!!! MENU RINGS"]:FindFirstChild(v899);
        if not l_FirstChild_3 then
            return "";
        else
            local v901 = l_FirstChild_3:FindFirstChild("Board") and l_FirstChild_3.Board:FindFirstChild("Gui") and l_FirstChild_3.Board.Gui:FindFirstChild("Content");
            if not v901 then
                return "";
            else
                local v902 = {};
                local v903 = 1;
                for _, v905 in ipairs(v901:GetChildren()) do
                    if v905:IsA("TextLabel") and v905.Name ~= "Header" then
                        table.insert(v902, v903 .. ". " .. v905.Text);
                        v903 = v903 + 1;
                    end;
                end;
                return table.concat(v902, "\n");
            end;
        end;
    end;
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v884 (ref), v906 (ref), v871 (ref)
        while task.wait(2) do
            v884:SetContent(v906("Element Tracker"));
            v871:SetContent(v906("Deep Sea Tracker"));
        end;
    end);
    QuestSec = v138.Quest:AddSection("Auto Progress Quest Features");
    QuestProgress = QuestSec:AddParagraph({
        Title = "Progress Quest Panel", 
        Content = "Waiting for start..."
    });
    QuestSec:AddToggle({
        Title = "Auto Teleport Quest", 
        Default = false, 
        Callback = function(v907) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), l_LocalPlayer_0 (ref), v844 (ref)
            v8.autoQuestFlow = v907;
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref), l_LocalPlayer_0 (ref), v844 (ref)
                local v908 = false;
                local v909 = false;
                local v910 = false;
                local v911 = {
                    Deep = false, 
                    Lever = false, 
                    Element = false
                };
                updateParagraph = function(v912) --[[ Line: 0 ]] --[[ Name:  ]]
                    if QuestProgress and QuestProgress.SetContent then
                        QuestProgress:SetContent(v912);
                    end;
                end;
                while v8.autoQuestFlow and (not v908 or not v909 or not v910) do
                    if not v908 then
                        local l_workspace_FirstChild_7 = workspace:FindFirstChild("!!! MENU RINGS");
                        local v914 = l_workspace_FirstChild_7 and l_workspace_FirstChild_7:FindFirstChild("Deep Sea Tracker");
                        local v915 = v914 and v914:FindFirstChild("Board") and v914.Board:FindFirstChild("Gui") and v914.Board.Gui:FindFirstChild("Content");
                        local v916 = true;
                        local v917 = 0;
                        local v918 = 0;
                        if v915 then
                            for _, v920 in ipairs(v915:GetChildren()) do
                                if v920:IsA("TextLabel") and v920.Name ~= "Header" then
                                    v918 = v918 + 1;
                                    if string.find(v920.Text, "100%%") then
                                        v917 = v917 + 1;
                                    else
                                        v916 = false;
                                    end;
                                end;
                            end;
                        end;
                        local v921 = v918 > 0 and math.floor(v917 / v918 * 100) or 0;
                        updateParagraph(string.format("Doing objective on Deep Sea Quest...\nProgress now %d%%.", v921));
                        if not v916 and not v911.Deep then
                            local v922 = l_LocalPlayer_0.Character and l_LocalPlayer_0.Character:FindFirstChild("HumanoidRootPart");
                            if v922 then
                                v922.CFrame = CFrame.new(-3599, -276, -1641);
                                v911.Deep = true;
                            end;
                        elseif v916 then
                            v908 = true;
                            updateParagraph("Deep Sea Quest Completed!\nProceeding to Artifact Lever...");
                        end;
                        task.wait(1);
                    end;
                    if v908 and not v909 and v8.autoQuestFlow then
                        local _ = workspace:FindFirstChild("JUNGLE INTERACTIONS");
                        local v924 = v844();
                        local v925 = true;
                        for _, v927 in pairs(v924) do
                            if not v927 then
                                v925 = false;
                                break;
                            end;
                        end;
                        if not v925 and not v911.Lever then
                            local v928 = l_LocalPlayer_0.Character and l_LocalPlayer_0.Character:FindFirstChild("HumanoidRootPart");
                            if v928 and _G.artifactPositions["Arrow Artifact"] then
                                v928.CFrame = _G.artifactPositions["Arrow Artifact"];
                                v911.Lever = true;
                            end;
                            updateParagraph("Doing objective on Artifact Lever...\nProgress now 75%.");
                        elseif v925 then
                            v909 = true;
                            updateParagraph("Artifact Lever Completed!\nProceeding to Element Quest...");
                        end;
                        task.wait(1);
                    end;
                    if v908 and v909 and not v910 and v8.autoQuestFlow then
                        local l_workspace_FirstChild_9 = workspace:FindFirstChild("!!! MENU RINGS");
                        local v930 = l_workspace_FirstChild_9 and l_workspace_FirstChild_9:FindFirstChild("Element Tracker");
                        local v931 = v930 and v930:FindFirstChild("Board") and v930.Board:FindFirstChild("Gui") and v930.Board.Gui:FindFirstChild("Content");
                        if v931 then
                            local v932 = {};
                            for _, v934 in ipairs(v931:GetChildren()) do
                                if v934:IsA("TextLabel") and v934.Name ~= "Header" then
                                    table.insert(v932, v934.Text);
                                end;
                            end;
                            local v935 = v932[2] and string.lower(v932[2]) or "";
                            local v936 = v932[4] and string.lower(v932[4]) or "";
                            local v937 = l_LocalPlayer_0.Character and l_LocalPlayer_0.Character:FindFirstChild("HumanoidRootPart");
                            if not string.find(v935, "100%%") or not string.find(v936, "100%%") then
                                if not v911.Element and v937 then
                                    v937.CFrame = CFrame.new(1484, 3, -336) * CFrame.Angles(0, math.rad(180), 0);
                                    v911.Element = true;
                                end;
                                if not string.find(v936, "100%%") then
                                    updateParagraph("Doing objective on Element Quest...\nProgress now 50%.");
                                elseif string.find(v936, "100%%") and not string.find(v935, "100%%") then
                                    v937.CFrame = CFrame.new(1453, -22, -636);
                                    updateParagraph("Doing objective on Element Quest...\nProgress now 75%.");
                                end;
                            else
                                v910 = true;
                                updateParagraph("All Quest Completed Successfully! :3");
                                v8.autoQuestFlow = false;
                            end;
                        end;
                        task.wait(1);
                    end;
                end;
            end);
        end
    });
    local v938 = v138.Quest:AddSection("Auto Door Ancient Ruin Features");
    local l_workspace_FirstChild_10 = workspace:FindFirstChild("RUIN INTERACTIONS");
    local v940 = {
        "Rare", 
        "Epic", 
        "Legendary", 
        "Mythic"
    };
    FishTargetIDs = {
        Rare = 284, 
        Epic = 270, 
        Legendary = 283, 
        Mythic = 263
    };
    PromptParagraph = v938:AddParagraph({
        Title = "Panel Ancient Ruin", 
        Content = "Checking..."
    });
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: l_workspace_FirstChild_10 (ref)
        while task.wait(1) do
            if l_workspace_FirstChild_10 and l_workspace_FirstChild_10:FindFirstChild("PressurePlates") then
                local l_PressurePlates_0 = l_workspace_FirstChild_10.PressurePlates;
                local v942 = l_PressurePlates_0:FindFirstChild("Rare") and l_PressurePlates_0.Rare.Part:FindFirstChild("ProximityPrompt");
                local v943 = l_PressurePlates_0:FindFirstChild("Epic") and l_PressurePlates_0.Epic.Part:FindFirstChild("ProximityPrompt");
                local v944 = l_PressurePlates_0:FindFirstChild("Legendary") and l_PressurePlates_0.Legendary.Part:FindFirstChild("ProximityPrompt");
                local v945 = l_PressurePlates_0:FindFirstChild("Mythic") and l_PressurePlates_0.Mythic.Part:FindFirstChild("ProximityPrompt");
                PromptParagraph:SetContent(string.format("Rare : %s\nEpic : %s\nLegendary : %s\nMythic : %s", v942 and "<b>Disable</b>" or "<b>Active</b>", v943 and "<b>Disable</b>" or "<b>Active</b>", v944 and "<b>Disable</b>" or "<b>Active</b>", v945 and "<b>Disable</b>" or "<b>Active</b>"));
            else
                PromptParagraph:SetContent("<font color='rgb(255,69,0)'>PressurePlates folder not found!</font>");
            end;
        end;
    end);
    v938:AddToggle({
        Title = "Auto Ancient Ruin", 
        Default = false, 
        Callback = function(v946) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v7 (ref), l_workspace_FirstChild_10 (ref), v940 (ref)
            v8.triggerRuin = v946;
            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref), v7 (ref), l_workspace_FirstChild_10 (ref), v940 (ref)
                while v8.triggerRuin do
                    local l_Expect_2 = v7.Data:GetExpect({
                        "Inventory", 
                        "Items"
                    });
                    if l_workspace_FirstChild_10 and l_workspace_FirstChild_10:FindFirstChild("PressurePlates") then
                        local l_PressurePlates_1 = l_workspace_FirstChild_10.PressurePlates;
                        for _, v950 in ipairs(v940) do
                            local v951 = FishTargetIDs[v950];
                            local v952 = false;
                            for _, v954 in ipairs(l_Expect_2) do
                                if v954.Id == v951 then
                                    v952 = true;
                                    break;
                                end;
                            end;
                            if v952 then
                                local l_l_PressurePlates_1_FirstChild_0 = l_PressurePlates_1:FindFirstChild(v950);
                                local v956 = l_l_PressurePlates_1_FirstChild_0 and l_l_PressurePlates_1_FirstChild_0:FindFirstChild("Part");
                                local v957 = v956 and v956:FindFirstChild("ProximityPrompt");
                                if v957 then
                                    fireproximityprompt(v957);
                                end;
                            end;
                        end;
                    end;
                    task.wait(1);
                end;
            end);
        end
    });
    local v958 = v138.Tele:AddSection("Teleport To Player");
    local v960 = v958:AddDropdown({
        Title = "Select Player to Teleport", 
        Content = "Choose target player", 
        Options = v126(), 
        Default = {}, 
        Callback = function(v959) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.trade.teleportTarget = v959;
        end
    });
    v958:AddButton({
        Title = "Refresh Player List", 
        Content = "Refresh list!", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v960 (ref), v126 (ref)
            v960:SetValues(v126());
            chloex("Player list refreshed!");
        end
    });
    v958:AddButton({
        Title = "Teleport to Player", 
        Content = "Teleport to selected player from dropdown", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v0 (ref), l_LocalPlayer_0 (ref)
            local l_teleportTarget_0 = v8.trade.teleportTarget;
            if not l_teleportTarget_0 then
                chloex("Please select a player first!");
                return;
            else
                local l_FirstChild_4 = v0.Players:FindFirstChild(l_teleportTarget_0);
                if l_FirstChild_4 and l_FirstChild_4.Character and l_FirstChild_4.Character:FindFirstChild("HumanoidRootPart") then
                    local v963 = l_LocalPlayer_0.Character and l_LocalPlayer_0.Character:FindFirstChild("HumanoidRootPart");
                    if v963 then
                        v963.CFrame = l_FirstChild_4.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0);
                        chloex("Teleported to " .. l_FirstChild_4.Name);
                    else
                        chloex("Your HumanoidRootPart not found.");
                    end;
                else
                    chloex("Target not found or not loaded.");
                end;
                return;
            end;
        end
    });
    local v964 = v138.Tele:AddSection("Location");
    v964:AddDropdown({
        Title = "Select Location", 
        Options = locationNames, 
        Default = locationNames[1], 
        Callback = function(v965) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.teleportTarget = v965;
        end
    });
    v964:AddButton({
        Title = "Teleport to Location", 
        Content = "Teleport to selected location", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v127 (ref)
            local l_teleportTarget_1 = v8.teleportTarget;
            if not l_teleportTarget_1 then
                chloex("Please select a location first!");
                return;
            else
                local v967 = v127[l_teleportTarget_1];
                if v967 then
                    local l_HumanoidRootPart_18 = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
                    if l_HumanoidRootPart_18 then
                        l_HumanoidRootPart_18.CFrame = CFrame.new(v967 + Vector3.new(0, 3, 0));
                        chloex("Teleported to " .. l_teleportTarget_1);
                    end;
                end;
                return;
            end;
        end
    });
    local v969 = v138.Misc:AddSection("Miscellaneous");
    v969:AddToggle({
        Title = "Anti Staff", 
        Content = "Auto kick if staff/developer joins the server.", 
        Default = false, 
        Callback = function(v970) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.AntiStaff = v970;
            if v970 then
                local v971 = 35102746;
                local v972 = {
                    [2] = "OG", 
                    [3] = "Tester", 
                    [4] = "Moderator", 
                    [75] = "Community Staff", 
                    [79] = "Analytics", 
                    [145] = "Divers / Artist", 
                    [250] = "Devs", 
                    [252] = "Partner", 
                    [254] = "Talon", 
                    [255] = "Wildes", 
                    [55] = "Swimmer", 
                    [30] = "Contrib", 
                    [35] = "Contrib 2", 
                    [100] = "Scuba", 
                    [76] = "CC"
                };
                do
                    local l_v971_0, l_v972_0 = v971, v972;
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v971_0 (ref), l_v972_0 (ref)
                        while true do
                            if _G.AntiStaff then
                                for _, v976 in ipairs(game:GetService("Players"):GetPlayers()) do
                                    if v976 ~= game.Players.LocalPlayer and l_v972_0[v976:GetRankInGroup(l_v971_0)] then
                                        game.Players.LocalPlayer:Kick("Chloe Detected Staff, Automatically Kicked!");
                                        return;
                                    end;
                                end;
                                task.wait(1);
                            else
                                return;
                            end;
                        end;
                    end);
                end;
            end;
        end
    });
    v969:AddToggle({
        Title = "Bypass Radar", 
        Default = false, 
        Callback = function(v977) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v6 (ref)
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v6 (ref), v977 (ref)
                v6.Functions.UpdateRadar:InvokeServer(v977);
            end);
        end
    });
    v969:AddSubSection("Hide Identifier");
    local l_LocalPlayer_5 = game:GetService("Players").LocalPlayer;
    local v979 = false;
    local v980 = nil;
    local v981 = nil;
    local v982 = nil;
    local v983 = nil;
    local v984 = nil;
    local v985 = nil;
    local v986 = nil;
    do
        local l_l_LocalPlayer_5_0, l_v979_0, l_v980_0, l_v981_0, l_v982_0, l_v983_0, l_v984_0, l_v985_0, l_v986_0 = l_LocalPlayer_5, v979, v980, v981, v982, v983, v984, v985, v986;
        local function v997() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: l_l_LocalPlayer_5_0 (ref)
            local v996 = (l_l_LocalPlayer_5_0.Character or l_l_LocalPlayer_5_0.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5);
            if not v996 then
                return nil;
            else
                repeat
                    task.wait();
                until v996:FindFirstChild("Overhead");
                return v996:WaitForChild("Overhead", 5);
            end;
        end;
        local function v1003() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v997 (ref), l_v982_0 (ref), l_v983_0 (ref), l_v984_0 (ref), l_v985_0 (ref), l_v986_0 (ref), l_v980_0 (ref), l_v981_0 (ref)
            local v998 = v997();
            if not v998 then
                warn("[HideIdent] Overhead not found.");
                return;
            else
                local v999 = v998:FindFirstChild("TitleContainer") and v998.TitleContainer:FindFirstChild("Label");
                local v1000 = v998:FindFirstChild("Content") and v998.Content:FindFirstChild("Header");
                local v1001 = v998:FindFirstChild("LevelContainer") and v998.LevelContainer:FindFirstChild("Label");
                local v1002 = v999 and v999:FindFirstChildOfClass("UIGradient");
                if not v999 or not v1000 or not v1001 then
                    warn("[HideIdent] Missing UI components in Overhead.");
                    return;
                else
                    if not v1002 then
                        v1002 = Instance.new("UIGradient", v999);
                    end;
                    _G.hideident = {
                        overhead = v998, 
                        titleLabel = v999, 
                        gradient = v1002, 
                        header = v1000, 
                        levelLabel = v1001
                    };
                    l_v982_0 = v999.Text;
                    l_v983_0 = v1000.Text;
                    l_v984_0 = v1001.Text;
                    l_v985_0 = v1002.Color;
                    l_v986_0 = v1002.Rotation;
                    l_v980_0 = l_v980_0 or l_v983_0;
                    l_v981_0 = l_v981_0 or l_v984_0;
                    return;
                end;
            end;
        end;
        local function v1005() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: l_v980_0 (ref), l_v981_0 (ref)
            local l_hideident_0 = _G.hideident;
            if not l_hideident_0 or not l_hideident_0.overhead or not l_hideident_0.titleLabel then
                return;
            else
                l_hideident_0.overhead.TitleContainer.Visible = true;
                l_hideident_0.titleLabel.Text = "Chloe X";
                l_hideident_0.gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 85, 255)), 
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(145, 186, 255)), 
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 243, 255))
                });
                l_hideident_0.gradient.Rotation = 0;
                l_hideident_0.header.Text = l_v980_0 ~= "" and l_v980_0 or "Chloe Rawr";
                l_hideident_0.levelLabel.Text = l_v981_0 ~= "" and l_v981_0 or "???";
                return;
            end;
        end;
        v1003();
        l_l_LocalPlayer_5_0.CharacterAdded:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v1003 (ref), l_v979_0 (ref), v1005 (ref)
            task.wait(2);
            v1003();
            if l_v979_0 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: l_v979_0 (ref), v1005 (ref)
                    while l_v979_0 do
                        v1005();
                        task.wait(1);
                    end;
                end);
            end;
        end);
        v969:AddInput({
            Title = "Name Changer", 
            Placeholder = "Enter header text...", 
            Default = l_v983_0 or "", 
            Callback = function(v1006) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: l_v980_0 (ref)
                l_v980_0 = v1006;
                SaveConfig();
            end
        });
        v969:AddInput({
            Title = "Lvl Changer", 
            Placeholder = "Enter level text...", 
            Default = l_v984_0 or "", 
            Callback = function(v1007) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: l_v981_0 (ref)
                l_v981_0 = v1007;
                SaveConfig();
            end
        });
        v969:AddToggle({
            Title = "Start Hide Identifier", 
            Default = false, 
            Callback = function(v1008) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: l_v979_0 (ref), v1005 (ref), l_v982_0 (ref), l_v983_0 (ref), l_v984_0 (ref), l_v985_0 (ref), l_v986_0 (ref)
                l_v979_0 = v1008;
                if v1008 then
                    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_v979_0 (ref), v1005 (ref)
                        while l_v979_0 do
                            local l_status_13, l_result_13 = pcall(v1005);
                            if not l_status_13 then
                                warn("[HideIdent] Error:", l_result_13);
                            end;
                            task.wait(1);
                        end;
                    end);
                else
                    local l_hideident_1 = _G.hideident;
                    if not l_hideident_1 or not l_hideident_1.overhead then
                        return;
                    else
                        l_hideident_1.overhead.TitleContainer.Visible = false;
                        l_hideident_1.titleLabel.Text = l_v982_0;
                        l_hideident_1.header.Text = l_v983_0;
                        l_hideident_1.levelLabel.Text = l_v984_0;
                        l_hideident_1.gradient.Color = l_v985_0;
                        l_hideident_1.gradient.Rotation = l_v986_0;
                    end;
                end;
            end
        });
    end;
    v969:AddSubSection("Halloween Event");
    v969:AddToggle({
        Title = "Auto Claim Halloween Event", 
        Default = v8.CEvent, 
        Callback = function(v1012) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v0 (ref), v6 (ref)
            v8.CEvent = v1012;
            if v1012 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v0 (ref), v8 (ref), v6 (ref)
                    local l_JungleEvent_0 = v0.PG:FindFirstChild("JungleEvent");
                    if not l_JungleEvent_0 or not l_JungleEvent_0:FindFirstChild("Frame") then
                        return;
                    else
                        local l_Body_0 = l_JungleEvent_0.Frame:FindFirstChild("Body");
                        if not l_Body_0 then
                            return;
                        else
                            local l_Main_0 = l_Body_0:FindFirstChild("Main");
                            if not l_Main_0 then
                                return;
                            else
                                local l_Track_0 = l_Main_0:FindFirstChild("Track");
                                if not l_Track_0 or not l_Track_0:FindFirstChild("Frame") then
                                    return;
                                else
                                    local l_Frame_1 = l_Track_0.Frame;
                                    while v8.CEvent do
                                        for v1018 = 1, 13 do
                                            local l_l_Frame_1_FirstChild_0 = l_Frame_1:FindFirstChild(tostring(v1018));
                                            do
                                                local l_v1018_0 = v1018;
                                                if l_l_Frame_1_FirstChild_0 then
                                                    local l_Inside_0 = l_l_Frame_1_FirstChild_0:FindFirstChild("Inside");
                                                    local v1022 = l_Inside_0 and l_Inside_0:FindFirstChild("Claim");
                                                    if v1022 and v1022:IsA("ImageButton") and v1022.Visible and l_Inside_0.Visible and l_l_Frame_1_FirstChild_0.Visible and v1022.Active then
                                                        pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                                            -- upvalues: v6 (ref), l_v1018_0 (ref)
                                                            v6.Events.REEvReward:FireServer(l_v1018_0);
                                                            chloex(string.format("Claimed Reward #%d", l_v1018_0));
                                                        end);
                                                        task.wait(0.7);
                                                    end;
                                                end;
                                            end;
                                        end;
                                        task.wait(5);
                                    end;
                                    return;
                                end;
                            end;
                        end;
                    end;
                end);
            end;
        end
    });
    v969:AddToggle({
        Title = "Auto Claim Halloween NPC", 
        Default = false, 
        Callback = function(v1023) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            v8.autoClaimNPC = v1023;
            if v1023 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v8 (ref), v6 (ref)
                    local v1024 = {
                        "Headless Horseman", 
                        "Hallow Guardian", 
                        "Zombified Doge", 
                        "Pumpkin Bandit", 
                        "Scientist", 
                        "Ghost", 
                        "Witch"
                    };
                    while v8.autoClaimNPC do
                        for _, v1026 in ipairs(v1024) do
                            do
                                local l_v1026_0 = v1026;
                                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                    -- upvalues: v6 (ref), l_v1026_0 (ref)
                                    v6.Functions.Dialogue:InvokeServer(l_v1026_0, "TrickOrTreat");
                                end);
                                task.wait(1.5);
                            end;
                        end;
                        task.wait(5);
                    end;
                end);
            end;
        end
    });
    v969:AddToggle({
        Title = "Auto Claim Halloween House", 
        Default = false, 
        Callback = function(v1028) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            v8.autoClaimHouse = v1028;
            if v1028 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v8 (ref), v6 (ref)
                    local v1029 = {
                        "Talon", 
                        "Kenny", 
                        "OutOfOrderFoxy", 
                        "Terror", 
                        "RequestingBlox", 
                        "Mac", 
                        "Wildes", 
                        "Tapiobag", 
                        "nthnth", 
                        "Jixxio", 
                        "Relukt"
                    };
                    while v8.autoClaimHouse do
                        for _, v1031 in ipairs(v1029) do
                            do
                                local l_v1031_0 = v1031;
                                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                    -- upvalues: v6 (ref), l_v1031_0 (ref)
                                    v6.Functions.Dialogue:InvokeServer(l_v1031_0, "TrickOrTreatHouse");
                                end);
                                task.wait(1.5);
                            end;
                        end;
                        task.wait(5);
                    end;
                end);
            end;
        end
    });
    v969:AddSubSection("Boost Player");
    l_LocalPlayer_5 = nil;
    v979 = nil;
    v980 = nil;
    v981, v982 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref)
        return require(v0.RS.Controllers.CutsceneController);
    end);
    if v981 and v982 then
        l_LocalPlayer_5 = v982;
        v979 = l_LocalPlayer_5.Play;
        v980 = l_LocalPlayer_5.Stop;
    end;
    v981 = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v6 (ref), l_LocalPlayer_5 (ref)
        if v6.Events.RECutscene then
            v6.Events.RECutscene.OnClientEvent:Connect(function(...) --[[ Line: 0 ]] --[[ Name:  ]]
                warn("[CELESTIAL] Cutscene blocked (ReplicateCutscene)", ...);
            end);
        end;
        if v6.Events.REStop then
            v6.Events.REStop.OnClientEvent:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]
                warn("[CELESTIAL] Cutscene blocked (StopCutscene)");
            end);
        end;
        if l_LocalPlayer_5 then
            l_LocalPlayer_5.Play = function() --[[ Line: 0 ]] --[[ Name:  ]]
                warn("[CELESTIAL] Cutscene skipped!");
            end;
            l_LocalPlayer_5.Stop = function() --[[ Line: 0 ]] --[[ Name:  ]]
                warn("[CELESTIAL] Cutscene stop skipped");
            end;
        end;
        warn("[CELESTIAL] All cutscenes disabled successfully!");
    end;
    v982 = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: l_LocalPlayer_5 (ref), v979 (ref), v980 (ref)
        if l_LocalPlayer_5 and v979 and v980 then
            l_LocalPlayer_5.Play = v979;
            l_LocalPlayer_5.Stop = v980;
            warn("[CELESTIAL] Cutscenes restored to default");
        end;
    end;
    v969:AddToggle({
        Title = "Disable Cutscene", 
        Default = true, 
        Callback = function(v1033) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v981 (ref), v982 (ref)
            v8.skipCutscene = v1033;
            if v1033 then
                v981();
            else
                v982();
            end;
        end
    });
    v969:AddToggle({
        Title = "Disable Obtained Fish", 
        Default = false, 
        Callback = function(v1034) --[[ Line: 0 ]] --[[ Name:  ]]
            local l_FirstChild_5 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Small Notification");
            if l_FirstChild_5 and l_FirstChild_5:FindFirstChild("Display") then
                l_FirstChild_5.Display.Visible = not v1034;
            end;
        end
    });
    v969:AddToggle({
        Title = "Disable Notification", 
        Content = "Disable All Notification! Fish/Admin Annoucement/Event Spawned!", 
        Default = false, 
        Callback = function(v1036) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v135 (ref), v136 (ref)
            v8.disableNotifs = v1036;
            if v1036 then
                v135();
            else
                v136();
            end;
        end
    });
    v969:AddToggle({
        Title = "Disable Char Effect", 
        Default = false, 
        Callback = function(v1037) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v6 (ref)
            if v1037 then
                v8.dummyCons = {};
                for _, v1039 in ipairs({
                    v6.Events.REPlayFishEffect, 
                    v6.Events.RETextEffect
                }) do
                    for _, v1041 in ipairs(getconnections(v1039.OnClientEvent)) do
                        v1041:Disconnect();
                    end;
                    local v1042 = v1039.OnClientEvent:Connect(function() --[[ Line: 0 ]] --[[ Name:  ]]

                    end);
                    table.insert(v8.dummyCons, v1042);
                end;
            else
                if v8.dummyCons then
                    for _, v1044 in ipairs(v8.dummyCons) do
                        v1044:Disconnect();
                    end;
                end;
                v8.dummyCons = {};
            end;
        end
    });
    v969:AddToggle({
        Title = "Delete Fishing Effects", 
        Content = "This Feature irivisible! delete any effect on rod", 
        Default = false, 
        Callback = function(v1045) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.DelEffects = v1045;
            if v1045 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v8 (ref)
                    while v8.DelEffects do
                        local l_CosmeticFolder_0 = workspace:FindFirstChild("CosmeticFolder");
                        if l_CosmeticFolder_0 then
                            l_CosmeticFolder_0:Destroy();
                        end;
                        task.wait(60);
                    end;
                end);
            end;
        end
    });
    v969:AddToggle({
        Title = "Hide Rod On Hand", 
        Content = "This feature irivisible! and hide other player too.", 
        Default = false, 
        Callback = function(v1047) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            v8.IrRod = v1047;
            if v1047 then
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v8 (ref)
                    while v8.IrRod do
                        for _, v1049 in ipairs(workspace.Characters:GetChildren()) do
                            local l_v1049_FirstChild_0 = v1049:FindFirstChild("!!!EQUIPPED_TOOL!!!");
                            if l_v1049_FirstChild_0 then
                                l_v1049_FirstChild_0:Destroy();
                            end;
                        end;
                        task.wait(1);
                    end;
                end);
            end;
        end
    });
    _G.WebhookFlags = {
        FishCaught = {
            Enabled = false, 
            URL = "https://discord.com/api/webhooks/1432777124607164418/0aGoA5XSsDCpO82T0bR8UYt1vFDv74qXst6AJQLcl-RSN-ujAp4GmIV7QIzrM3yfoGVV"
        }, 
        Stats = {
            Enabled = false, 
            URL = "", 
            Delay = 5
        }, 
        Disconnect = {
            Enabled = false, 
            URL = "https://discord.com/api/webhooks/1428340333510398013/1L4UNrQmJXLgiNjO8PvZVc2TSxX60Xvg8BFpGyz8VANNL95DRfwKBPzyx9-mgZYLKw6_"
        }
    };
    _G.WebhookURLs = _G.WebhookURLs or {};
    v983 = {};
    buildFishDatabase = function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v7 (ref), v983 (ref)
        local l_Items_0 = v7.Items;
        if not l_Items_0 then
            return;
        else
            for _, v1053 in ipairs(l_Items_0:GetChildren()) do
                local l_status_14, l_result_14 = pcall(require, v1053);
                if l_status_14 and type(l_result_14) == "table" and l_result_14.Data and l_result_14.Data.Type == "Fish" then
                    local l_Data_5 = l_result_14.Data;
                    if l_Data_5.Id and l_Data_5.Name then
                        v983[l_Data_5.Id] = {
                            Name = l_Data_5.Name, 
                            Tier = l_Data_5.Tier, 
                            Icon = l_Data_5.Icon, 
                            SellPrice = l_result_14.SellPrice
                        };
                    end;
                end;
            end;
            return;
        end;
    end;
    getThumbnailURL = function(v1057) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref)
        local v1058 = v1057:match("rbxassetid://(%d+)");
        if not v1058 then
            return nil;
        else
            local v1059 = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&type=Asset&size=420x420&format=Png", v1058);
            local l_status_15, l_result_15 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v0 (ref), v1059 (ref)
                return v0.HttpService:JSONDecode(game:HttpGet(v1059));
            end);
            return l_status_15 and l_result_15 and l_result_15.data and l_result_15.data[1] and l_result_15.data[1].imageUrl;
        end;
    end;
    sendWebhook = function(v1062, v1063) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v0 (ref)
        if not _G.httpRequest or not v1062 or v1062 == "" then
            return;
        elseif _G._WebhookLock and _G._WebhookLock[v1062] then
            return;
        else
            _G._WebhookLock = _G._WebhookLock or {};
            _G._WebhookLock[v1062] = true;
            task.delay(0.25, function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v1062 (ref)
                _G._WebhookLock[v1062] = nil;
            end);
            pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v1062 (ref), v0 (ref), v1063 (ref)
                _G.httpRequest({
                    Url = v1062, 
                    Method = "POST", 
                    Headers = {
                        ["Content-Type"] = "application/json"
                    }, 
                    Body = v0.HttpService:JSONEncode(v1063)
                });
            end);
            return;
        end;
    end;
    sendNewFishWebhook = function(v1064) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v983 (ref)
        if not _G.WebhookFlags.FishCaught.Enabled then
            return;
        else
            local l_URL_0 = _G.WebhookFlags.FishCaught.URL;
            if not l_URL_0 or not l_URL_0:match("discord.com/api/webhooks") then
                return;
            else
                local v1066 = v983[v1064.Id];
                if not v1066 then
                    return;
                else
                    local v1067 = _G.TierFish and _G.TierFish[v1066.Tier] or "Unknown";
                    if _G.WebhookRarities and #_G.WebhookRarities > 0 and not table.find(_G.WebhookRarities, v1067) then
                        return;
                    elseif _G.WebhookNames and #_G.WebhookNames > 0 and not table.find(_G.WebhookNames, v1066.Name) then
                        return;
                    else
                        local v1068 = v1064.Metadata and v1064.Metadata.Weight and string.format("%.2f Kg", v1064.Metadata.Weight) or "N/A";
                        local v1069 = v1064.Metadata and v1064.Metadata.VariantId and tostring(v1064.Metadata.VariantId) or "None";
                        local v1070 = v1066.SellPrice and "$" .. string.format("%d", v1066.SellPrice):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") or "N/A";
                        local v1071 = {
                            embeds = {
                                {
                                    title = "Chloe X Webhook | Fish Caught", 
                                    url = "https://discord.gg/PaPvGUE8UC", 
                                    description = string.format("\226\156\166\239\184\142 Congratulations!! **%s** You have obtained a new **%s** fish!", _G.WebhookCustomName ~= "" and _G.WebhookCustomName or game.Players.LocalPlayer.Name, v1067), 
                                    color = 52221, 
                                    fields = {
                                        {
                                            name = "\227\128\162Fish Name :", 
                                            value = "```\226\157\175 " .. v1066.Name .. "```"
                                        }, 
                                        {
                                            name = "\227\128\162Fish Tier :", 
                                            value = "```\226\157\175 " .. v1067 .. "```"
                                        }, 
                                        {
                                            name = "\227\128\162Weight :", 
                                            value = "```\226\157\175 " .. v1068 .. "```"
                                        }, 
                                        {
                                            name = "\227\128\162Mutation :", 
                                            value = "```\226\157\175 " .. v1069 .. "```"
                                        }, 
                                        {
                                            name = "\227\128\162Sell Price :", 
                                            value = "```\226\157\175 " .. v1070 .. "```"
                                        }
                                    }, 
                                    image = {
                                        url = getThumbnailURL(v1066.Icon) or "https://i.imgur.com/WltO8IG.png"
                                    }, 
                                    footer = {
                                        text = "Chloe X Webhook", 
                                        icon_url = "https://i.imgur.com/WltO8IG.png"
                                    }, 
                                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
                                }
                            }, 
                            username = "Chloe X Notification!", 
                            avatar_url = "https://i.imgur.com/9afHGRy.jpeg"
                        };
                        sendWebhook(l_URL_0, v1071);
                        return;
                    end;
                end;
            end;
        end;
    end;
    buildFishDatabase();
    v984 = {};
    for _, v1073 in pairs(v983) do
        table.insert(v984, v1073.Name);
    end;
    table.sort(v984);
    task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v5 (ref), v8 (ref)
        repeat
            REObtainedNewFishNotification = v5.Net["RE/ObtainedNewFishNotification"];
            task.wait(1);
        until REObtainedNewFishNotification;
        if not _G.FishWebhookConnected then
            _G.FishWebhookConnected = true;
            REObtainedNewFishNotification.OnClientEvent:Connect(function(v1074, v1075) --[[ Line: 0 ]] --[[ Name:  ]]
                -- upvalues: v8 (ref)
                if v8.autoWebhook then
                    local v1076 = {
                        Id = v1074, 
                        Metadata = {
                            Weight = v1075 and v1075.Weight, 
                            VariantId = v1075 and v1075.VariantId
                        }
                    };
                    sendNewFishWebhook(v1076);
                end;
            end);
        end;
    end);
    webhook = v138.Webhook:AddSection("Webhook Fish Caught");
    webhook:AddInput({
        Title = "Webhook URL", 
        Default = "", 
        Callback = function(v1077) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.WebhookURLs = _G.WebhookURLs or {};
            _G.WebhookURLs.FishCaught = v1077;
            if _G.WebhookFlags and _G.WebhookFlags.FishCaught then
                _G.WebhookFlags.FishCaught.URL = v1077;
            end;
            if v1077 and v1077:match("discord.com/api/webhooks") then
                SaveConfig();
            end;
        end
    });
    webhook:AddDropdown({
        Title = "Tier Filter", 
        Multi = true, 
        Options = {
            "Common", 
            "Uncommon", 
            "Rare", 
            "Epic", 
            "Legendary", 
            "Mythic", 
            "Secret"
        }, 
        Default = {
            "Mythic", 
            "Secret"
        }, 
        Callback = function(v1078) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.WebhookRarities = v1078;
            SaveConfig();
        end
    });
    webhook:AddDropdown({
        Title = "Name Filter", 
        Multi = true, 
        Options = v984, 
        Default = {}, 
        Callback = function(v1079) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.WebhookNames = v1079;
            SaveConfig();
        end
    });
    webhook:AddInput({
        Title = "Hide Identity", 
        Content = "Protect your name for sending webhook to discord", 
        Default = _G.WebhookCustomName or "", 
        Callback = function(v1080) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.WebhookCustomName = v1080;
            SaveConfig();
        end
    });
    webhook:AddToggle({
        Title = "Send Fish Webhook", 
        Default = _G.WebhookFlags.FishCaught.Enabled, 
        Callback = function(v1081) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref)
            _G.WebhookFlags.FishCaught.Enabled = v1081;
            v8.autoWebhook = v1081;
            SaveConfig();
        end
    });
    webhook:AddButton({
        Title = "Test Webhook Connection", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v0 (ref)
            local l_URL_1 = _G.WebhookFlags.FishCaught.URL;
            if not l_URL_1 or not l_URL_1:match("discord.com/api/webhooks") then
                warn("[Webhook Test] \226\157\140 Invalid or missing webhook URL.");
                return;
            else
                local v1083 = {
                    content = nil, 
                    embeds = {
                        {
                            color = 44543, 
                            author = {
                                name = "Ding dongggg! Webhook is connected :3"
                            }, 
                            image = {
                                url = "https://media.tenor.com/KJDqZ0H6Gb4AAAAC/gawr-gura-gura.gif"
                            }
                        }
                    }, 
                    username = "Chloe X Notification!", 
                    avatar_url = "https://i.imgur.com/9afHGRy.jpeg", 
                    attachments = {}
                };
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: l_URL_1 (ref), v0 (ref), v1083 (ref)
                    local l_status_16, l_result_16 = pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_URL_1 (ref), v0 (ref), v1083 (ref)
                        return _G.httpRequest({
                            Url = l_URL_1, 
                            Method = "POST", 
                            Headers = {
                                ["Content-Type"] = "application/json"
                            }, 
                            Body = v0.HttpService:JSONEncode(v1083)
                        });
                    end);
                    if l_status_16 then
                        chloex("Successfully sent test message!");
                    else
                        chloex("Failed to send webhook:", l_result_16);
                    end;
                end);
                return;
            end;
        end
    });
    v985 = v138.Webhook:AddSection("Webhook Statistic Player");
    v985:AddInput({
        Title = "Statistic Webhook URL", 
        Default = _G.WebhookFlags.Stats.URL, 
        Placeholder = "Paste your stats webhook here...", 
        Callback = function(v1086) --[[ Line: 0 ]] --[[ Name:  ]]
            if v1086 and v1086:match("discord.com/api/webhooks") then
                _G.WebhookFlags.Stats.URL = v1086;
                SaveConfig();
            end;
        end
    });
    v985:AddInput({
        Title = "Delay (Minutes)", 
        Default = tostring(_G.WebhookFlags.Stats.Delay), 
        Placeholder = "Delay between data sends...", 
        Numeric = true, 
        Callback = function(v1087) --[[ Line: 0 ]] --[[ Name:  ]]
            local v1088 = tonumber(v1087);
            if v1088 and v1088 >= 1 then
                _G.WebhookFlags.Stats.Delay = v1088;
                SaveConfig();
            end;
        end
    });
    v985:AddToggle({
        Title = "Send Webhook Statistic", 
        Content = "Automatically send player stats, inventory, utility, and quest info to Discord.", 
        Default = _G.WebhookFlags.Stats.Enabled or false, 
        Callback = function(v1089) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v8 (ref), v0 (ref), v7 (ref)
            v8.autoWebhookStats = v1089;
            _G.WebhookFlags.Stats.Enabled = v1089;
            SaveConfig();
            if not v1089 then
                return;
            else
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v0 (ref), v7 (ref), v8 (ref)
                    local l_RS_0 = v0.RS;
                    local l_HttpService_0 = v0.HttpService;
                    local l_Data_6 = v7.Data;
                    local l_Items_1 = l_RS_0:WaitForChild("Items");
                    local l_Baits_0 = l_RS_0:WaitForChild("Baits");
                    local l_Totems_0 = l_RS_0:WaitForChild("Totems");
                    local v1096 = {};
                    local v1097 = {
                        Fish = {
                            folders = {
                                l_Items_1
                            }, 
                            expectType = "Fish"
                        }, 
                        ["Fishing Rods"] = {
                            folders = {
                                l_Items_1
                            }, 
                            expectType = "Fishing Rods"
                        }, 
                        Baits = {
                            folders = {
                                l_Baits_0
                            }, 
                            expectType = "Baits"
                        }, 
                        Totems = {
                            folders = {
                                l_Totems_0
                            }, 
                            expectType = "Totems"
                        }, 
                        Items = {
                            folders = {
                                l_Items_1
                            }, 
                            expectType = nil
                        }
                    };
                    local function v1101(v1098) --[[ Line: 0 ]] --[[ Name:  ]]
                        local l_status_17, l_result_17 = pcall(require, v1098);
                        if l_status_17 and type(l_result_17) == "table" and l_result_17.Data then
                            return l_result_17;
                        else
                            return;
                        end;
                    end;
                    local function v1113(v1102, v1103) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v1096 (ref), v1101 (ref)
                        local v1104 = (v1103.expectType or "ANY") .. ":" .. tostring(v1102);
                        if v1096[v1104] ~= nil then
                            return v1096[v1104];
                        else
                            for _, v1106 in ipairs(v1103.folders) do
                                for _, v1108 in ipairs(v1106:GetDescendants()) do
                                    if v1108:IsA("ModuleScript") then
                                        local v1109 = v1101(v1108);
                                        if v1109 and v1109.Data and v1109.Data.Id == v1102 and (not v1103.expectType or v1109.Data.Type == v1103.expectType) then
                                            v1096[v1104] = v1109;
                                            return v1109;
                                        end;
                                    else
                                        local v1110 = v1108.GetAttribute and v1108:GetAttribute("Id");
                                        if v1110 == v1102 then
                                            local v1111 = v1108.GetAttribute and v1108:GetAttribute("Type");
                                            if not v1103.expectType or v1111 == v1103.expectType then
                                                local v1112 = {
                                                    Data = {
                                                        Id = v1110, 
                                                        Type = v1111, 
                                                        Name = v1108:GetAttribute("Name"), 
                                                        Tier = v1108:GetAttribute("Rarity")
                                                    }
                                                };
                                                v1096[v1104] = v1112;
                                                return v1112;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                            v1096[v1104] = false;
                            return nil;
                        end;
                    end;
                    local function v1115(v1114) --[[ Line: 0 ]] --[[ Name:  ]]
                        if v1114 >= 1000000000 then
                            return string.format("%.1fB", v1114 / 1000000000);
                        elseif v1114 >= 1000000 then
                            return string.format("%.1fM", v1114 / 1000000);
                        elseif v1114 >= 1000 then
                            return string.format("%.1fk", v1114 / 1000);
                        else
                            return tostring(v1114);
                        end;
                    end;
                    local function v1118(v1116) --[[ Line: 0 ]] --[[ Name:  ]]
                        local v1117 = v1116 and v1116.Data and v1116.Data.Tier;
                        return _G.TierFish[v1117] or v1117 and tostring(v1117) or "Unknown";
                    end;
                    local function v1131(v1119, v1120, v1121) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v1113 (ref), v1097 (ref)
                        local v1122 = {};
                        if typeof(v1119) == "table" then
                            for _, v1124 in ipairs(v1119) do
                                local v1125 = v1113(v1124.Id, v1097[v1120] or v1097.Items);
                                local v1126 = v1125 and v1125.Data and v1125.Data.Name or "Unknown";
                                v1122[v1126] = (v1122[v1126] or 0) + (v1124.Amount or 1);
                            end;
                        end;
                        local v1127 = {};
                        local v1128 = 1;
                        for v1129, v1130 in pairs(v1122) do
                            if v1121 then
                                table.insert(v1127, string.format("%d. %s | x%s", v1128, v1129, v1130));
                            else
                                table.insert(v1127, string.format("%d. %s", v1128, v1129));
                            end;
                            v1128 = v1128 + 1;
                        end;
                        return table.concat(v1127, "\n");
                    end;
                    local function v1141() --[[ Line: 0 ]] --[[ Name:  ]]
                        local v1132 = {
                            DeepSea = {}, 
                            Element = {}
                        };
                        local l_workspace_FirstChild_11 = workspace:FindFirstChild("!!! MENU RINGS");
                        if not l_workspace_FirstChild_11 then
                            return v1132;
                        else
                            local v1134 = {
                                DeepSea = l_workspace_FirstChild_11:FindFirstChild("Deep Sea Tracker"), 
                                Element = l_workspace_FirstChild_11:FindFirstChild("Element Tracker")
                            };
                            for v1135, v1136 in pairs(v1134) do
                                local v1137 = v1136 and v1136:FindFirstChild("Board") and v1136.Board:FindFirstChild("Gui");
                                local v1138 = v1137 and v1137:FindFirstChild("Content");
                                if v1138 then
                                    for _, v1140 in ipairs(v1138:GetChildren()) do
                                        if v1140:IsA("TextLabel") and v1140.Name:match("Label") then
                                            table.insert(v1132[v1135], string.format("%d. %s", #v1132[v1135] + 1, v1140.Text));
                                        end;
                                    end;
                                end;
                            end;
                            return v1132;
                        end;
                    end;
                    local function v1143() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: l_Data_6 (ref)
                        local v1142 = l_Data_6:Get({
                            "Statistics"
                        }) or {};
                        return {
                            Coins = l_Data_6:Get({
                                "Coins"
                            }) or 0, 
                            FishCaught = v1142.FishCaught or 0, 
                            XP = l_Data_6:Get({
                                "XP"
                            }) or 0
                        };
                    end;
                    local function v1179(v1144, v1145) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v1131 (ref), v1141 (ref), v1113 (ref), v1097 (ref), v1118 (ref), v1115 (ref), l_HttpService_0 (ref)
                        local v1146 = _G.WebhookFlags and _G.WebhookFlags.Stats.URL or "";
                        if v1146 == "" then
                            warn("[Webhook Stats] \226\157\140 Please set your Webhook URL first!");
                            return;
                        else
                            local l_LocalPlayer_6 = game.Players.LocalPlayer;
                            local v1148 = l_LocalPlayer_6 and l_LocalPlayer_6.Name or "Unknown";
                            local v1149 = v1131(v1145["Fishing Rods"], "Fishing Rods", false);
                            local v1150 = v1131(v1145.Baits, "Baits", false);
                            local v1151 = v1131(v1145.Totems, "Totems", true);
                            local v1152 = {};
                            local l_ipairs_3 = ipairs;
                            local v1154 = v1145.Items or {};
                            for _, v1156 in l_ipairs_3(v1154) do
                                if v1156.Id == 10 then
                                    v1152["Enchant Stone"] = (v1152["Enchant Stone"] or 0) + (v1156.Amount or 1);
                                elseif v1156.Id == 125 then
                                    v1152["Super Enchant Stone"] = (v1152["Super Enchant Stone"] or 0) + (v1156.Amount or 1);
                                elseif v1156.Id == 246 then
                                    v1152["Transcended Stone"] = (v1152["Transcended Stone"] or 0) + (v1156.Amount or 1);
                                end;
                            end;
                            l_ipairs_3 = {};
                            v1154 = 1;
                            for v1157, v1158 in pairs(v1152) do
                                table.insert(l_ipairs_3, string.format("%d. %s | x%s", v1154, v1157, v1158));
                                v1154 = v1154 + 1;
                            end;
                            local v1159 = next(v1152) and table.concat(l_ipairs_3, "\n") or "(None)";
                            local v1160 = v1141();
                            local v1161 = #v1160.DeepSea > 0 and table.concat(v1160.DeepSea, "\n") or "(No Deep Sea Quest Found)";
                            local v1162 = #v1160.Element > 0 and table.concat(v1160.Element, "\n") or "(No Element Quest Found)";
                            local v1163 = v1145.Items or {};
                            local v1164 = {};
                            for _, v1166 in ipairs(v1163) do
                                local v1167 = v1113(v1166.Id, v1097.Fish);
                                if v1167 and v1167.Data and v1167.Data.Type == "Fish" then
                                    local v1168 = v1118(v1167);
                                    local v1169 = v1167.Data.Name or "Unknown";
                                    v1164[v1168] = v1164[v1168] or {};
                                    v1164[v1168][v1169] = (v1164[v1168][v1169] or 0) + (v1166.Amount or 1);
                                end;
                            end;
                            local v1170 = {};
                            for _, v1172 in ipairs({
                                "Uncommon", 
                                "Common", 
                                "Rare", 
                                "Epic", 
                                "Legendary", 
                                "Mythic", 
                                "Secret"
                            }) do
                                local v1173 = v1164[v1172];
                                if v1173 then
                                    table.insert(v1170, string.format("\227\128\162**%s :**", v1172));
                                    local v1174 = 1;
                                    for v1175, v1176 in pairs(v1173) do
                                        table.insert(v1170, string.format("%d. %s | x%s", v1174, v1175, v1176));
                                        v1174 = v1174 + 1;
                                    end;
                                end;
                            end;
                            local v1177 = #v1170 > 0 and table.concat(v1170, "\n") or "(No Fishes Found)";
                            local v1178 = {
                                username = "Chloe X Notification!", 
                                avatar_url = "https://i.imgur.com/9afHGRy.jpeg", 
                                embeds = {
                                    {
                                        title = "\227\128\162Chloe X Webhook | Player Info", 
                                        color = 52479, 
                                        fields = {
                                            {
                                                name = "\227\128\162Player Data", 
                                                value = string.format("**\226\157\175 NAME:** %s\n**\226\157\175 COINS:** $%s\n**\226\157\175 FISH CAUGHT:** %s", v1148, v1115(v1144.Coins), v1144.FishCaught)
                                            }, 
                                            {
                                                name = "\227\128\162Inventory", 
                                                value = string.format("**Totems:**\n%s\n**Rods:**\n%s\n**Baits:**\n%s", v1151, v1149, v1150)
                                            }
                                        }
                                    }, 
                                    {
                                        title = "Utility & Quest Data", 
                                        color = 26367, 
                                        fields = {
                                            {
                                                name = "\227\128\162Utility Data", 
                                                value = string.format("**\226\157\175 Fishes:**\n%s\n**\226\157\175 Enchant Stones:**\n%s", v1177, v1159)
                                            }, 
                                            {
                                                name = "\227\128\162Quest Data", 
                                                value = string.format("**\226\157\175 Deep Sea Quest:**\n%s\n**\226\157\175 Element Quest:**\n%s", v1161, v1162)
                                            }
                                        }, 
                                        footer = {
                                            text = string.format("Chloe X Auto Sync | Every %dm", _G.WebhookFlags.Stats.Delay or 5), 
                                            icon_url = "https://i.imgur.com/WltO8IG.png"
                                        }, 
                                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
                                    }
                                }
                            };
                            task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                -- upvalues: v1146 (ref), l_HttpService_0 (ref), v1178 (ref)
                                pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                                    -- upvalues: v1146 (ref), l_HttpService_0 (ref), v1178 (ref)
                                    _G.httpRequest({
                                        Url = v1146, 
                                        Method = "POST", 
                                        Headers = {
                                            ["Content-Type"] = "application/json"
                                        }, 
                                        Body = l_HttpService_0:JSONEncode(v1178)
                                    });
                                end);
                            end);
                            return;
                        end;
                    end;
                    while v8.autoWebhookStats do
                        v1179(v1143(), l_Data_6:Get({
                            "Inventory"
                        }) or {});
                        task.wait((_G.WebhookFlags.Stats.Delay or 5) * 60);
                    end;
                end);
                return;
            end;
        end
    });
    v986 = "";
    local v1180 = false;
    local v1181 = false;
    SendDisconnectWebhook = function(v1182) --[[ Line: 0 ]] --[[ Name:  ]]
        -- upvalues: v1180 (ref), v986 (ref), v0 (ref)
        if not v1180 then
            return;
        else
            local v1183 = _G.WebhookURLs.Disconnect or _G.WebhookFlags and _G.WebhookFlags.Disconnect.URL or "";
            if v1183 == "" or not v1183:match("discord") then
                return;
            else
                local l_LocalPlayer_7 = game.Players.LocalPlayer;
                local v1185 = "Unknown";
                if _G.DisconnectCustomName and _G.DisconnectCustomName ~= "" then
                    v1185 = _G.DisconnectCustomName;
                elseif l_LocalPlayer_7 and l_LocalPlayer_7.Name then
                    v1185 = l_LocalPlayer_7.Name;
                end;
                local v1186 = os.date("*t");
                local v1187 = v1186.hour > 12 and v1186.hour - 12 or v1186.hour;
                local v1188 = v1186.hour >= 12 and "PM" or "AM";
                local v1189 = string.format("%02d/%02d/%04d %02d.%02d %s", v1186.day, v1186.month, v1186.year, v1187, v1186.min, v1188);
                local v1190 = v986 ~= "" and v986 or "Anonymous";
                local v1191 = v1182 and v1182 ~= "" and v1182 or "Disconnected from server";
                local v1192 = {
                    content = "Ding Dongg Ding Dongggg, Hello! " .. v1190 .. " your account got disconnected from server!", 
                    embeds = {
                        {
                            title = "DETAIL ACCOUNT", 
                            color = 36863, 
                            fields = {
                                {
                                    name = "\227\128\162Username :", 
                                    value = "> " .. v1185
                                }, 
                                {
                                    name = "\227\128\162Time got disconnected :", 
                                    value = "> " .. v1189
                                }, 
                                {
                                    name = "\227\128\162Reason :", 
                                    value = "> " .. v1191
                                }
                            }, 
                            thumbnail = {
                                url = "https://media.tenor.com/rx88bhLtmyUAAAAC/gawr-gura.gif"
                            }
                        }
                    }, 
                    username = "Chloe X Notification!", 
                    avatar_url = "https://i.imgur.com/9afHGRy.jpeg"
                };
                task.spawn(function() --[[ Line: 0 ]] --[[ Name:  ]]
                    -- upvalues: v1183 (ref), v0 (ref), v1192 (ref)
                    pcall(function() --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v1183 (ref), v0 (ref), v1192 (ref)
                        _G.httpRequest({
                            Url = v1183, 
                            Method = "POST", 
                            Headers = {
                                ["Content-Type"] = "application/json"
                            }, 
                            Body = v0.HttpService:JSONEncode(v1192)
                        });
                    end);
                end);
                return;
            end;
        end;
    end;
    local v1193 = v138.Webhook:AddSection("Webhook Alert");
    v1193:AddInput({
        Title = "Disconnect Alert Webhook URL", 
        Default = "", 
        Callback = function(v1194) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.WebhookURLs = _G.WebhookURLs or {};
            _G.WebhookURLs.Disconnect = v1194;
            if _G.WebhookFlags and _G.WebhookFlags.Disconnect then
                _G.WebhookFlags.Disconnect.URL = v1194;
            end;
        end
    });
    v1193:AddInput({
        Title = "Discord ID", 
        Default = "", 
        Callback = function(v1195) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v986 (ref)
            if v1195 and v1195 ~= "" then
                v986 = "<@" .. v1195:gsub("%D", "") .. ">";
            else
                v986 = "";
            end;
            SaveConfig();
        end
    });
    v1193:AddInput({
        Title = "Hide Identity", 
        Placeholder = "Enter custom name (leave blank for default)", 
        Default = _G.DisconnectCustomName or "", 
        Callback = function(v1196) --[[ Line: 0 ]] --[[ Name:  ]]
            _G.DisconnectCustomName = v1196;
            SaveConfig();
        end
    });
    v1193:AddToggle({
        Title = "Send Webhook On Disconnect", 
        Content = "Notify your Discord when account disconnected and auto rejoin.", 
        Default = _G.WebhookFlags.Disconnect.Enabled or false, 
        Callback = function(v1197) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v1180 (ref), v1181 (ref), v0 (ref)
            if v1197 and (not _G.DisconnectCustomName or _G.DisconnectCustomName == "") then
                chloex("Invalid! Input Hide Identity first.");
                if _G.WebhookFlags and _G.WebhookFlags.Disconnect then
                    _G.WebhookFlags.Disconnect.Enabled = false;
                end;
                v1180 = false;
                return;
            else
                v1180 = v1197;
                if _G.WebhookFlags and _G.WebhookFlags.Disconnect then
                    _G.WebhookFlags.Disconnect.Enabled = v1197;
                end;
                SaveConfig();
                if v1197 then
                    v1181 = false;
                    local function v1202(v1198) --[[ Line: 0 ]] --[[ Name:  ]]
                        -- upvalues: v1181 (ref), v1180 (ref)
                        if not v1181 and v1180 then
                            v1181 = true;
                            local v1199 = v1198 or "Disconnected from server";
                            SendDisconnectWebhook(v1199);
                            task.wait(2);
                            local l_TeleportService_0 = game:GetService("TeleportService");
                            local l_LocalPlayer_8 = game:GetService("Players").LocalPlayer;
                            l_TeleportService_0:Teleport(game.PlaceId, l_LocalPlayer_8);
                        end;
                    end;
                    do
                        local l_v1202_0 = v1202;
                        v0.GuiService.ErrorMessageChanged:Connect(function(v1204) --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: l_v1202_0 (ref)
                            if v1204 and v1204 ~= "" then
                                l_v1202_0(v1204);
                            end;
                        end);
                        game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(v1205) --[[ Line: 0 ]] --[[ Name:  ]]
                            -- upvalues: l_v1202_0 (ref)
                            if v1205.Name == "ErrorPrompt" then
                                task.wait(1);
                                local l_v1205_FirstChildWhichIsA_0 = v1205:FindFirstChildWhichIsA("TextLabel", true);
                                local v1207 = l_v1205_FirstChildWhichIsA_0 and l_v1205_FirstChildWhichIsA_0.Text or "Disconnected";
                                l_v1202_0(v1207);
                            end;
                        end);
                    end;
                end;
                return;
            end;
        end
    });
    v1193:AddButton({
        Title = "Test Disconnected Player", 
        Content = "Kick yourself, send webhook, and auto rejoin.", 
        Callback = function() --[[ Line: 0 ]] --[[ Name:  ]]
            chloex("Kicking player...");
            task.wait(1);
            SendDisconnectWebhook("Test Successfully :3");
            task.wait(2);
            local l_TeleportService_1 = game:GetService("TeleportService");
            local l_LocalPlayer_9 = game:GetService("Players").LocalPlayer;
            l_TeleportService_1:Teleport(game.PlaceId, l_LocalPlayer_9);
        end
    });
    local v1210 = loadstring(game:HttpGet("https://raw.githubusercontent.com/MajestySkie/Chloe-X/refs/heads/main/Addons/2.lua"))();
    local v1211 = v138.Webhook:AddSection("Webhook Event Settings");
    v1211:AddInput({
        Title = "Set Hunt Webhook", 
        Content = "Input webhook link for Hunt", 
        Callback = function(v1212) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v1210 (ref)
            if v1212 and v1212:match("^https://discord.com/api/webhooks/") then
                v1210.Links.Hunt = v1212;
                chloex("Hunt webhook updated!");
            end;
        end
    });
    v1211:AddInput({
        Title = "Set Luck Webhook", 
        Content = "Input webhook link for Server Luck", 
        Callback = function(v1213) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v1210 (ref)
            if v1213 and v1213:match("^https://discord.com/api/webhooks/") then
                v1210.Links.ServerLuck = v1213;
                chloex("Server Luck webhook updated!");
            end;
        end
    });
    v1211:AddToggle({
        Title = "Auto Send Webhook", 
        Default = true, 
        Callback = function(v1214) --[[ Line: 0 ]] --[[ Name:  ]]
            -- upvalues: v1210 (ref)
            if v1214 then
                _G.WebhookDisabled = false;
                if not _G.WebhookStarted then
                    _G.WebhookStarted = true;
                    v1210.Start();
                end;
            else
                _G.WebhookDisabled = true;
            end;
        end
    });
    return;
end;
