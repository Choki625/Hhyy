-- ASUMSI:
-- Fish sudah didefinisikan sebagai bagian dari UI framework (misalnya, Tab atau Section).
-- v6 sudah didefinisikan (Remote Functions/Events untuk memancing).
-- _G.FishingDelay, _G.Reel, _G.FBlatant, SaveConfig(), dan chloex() sudah didefinisikan.

-- Pastikan variabel _G yang dibutuhkan memiliki nilai default jika belum ada (hanya untuk testing/kelengkapan)
if not _G.Reel then _G.Reel = 1.9 end
if not _G.FishingDelay then _G.FishingDelay = 1.1 end
if not _G.FBlatant then _G.FBlatant = false end
if not SaveConfig then SaveConfig = function() print("Config Saved") end end
if not chloex then chloex = function(msg) print("Notification: " .. msg) end end

-- Definisikan fungsi yang digunakan oleh Toggle
local selectedMode = "Fast";

local Fastest = function()
    -- upvalues: v6 (ref)
    task.spawn(function()
        -- upvalues: v6 (ref)
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Functions.Cancel:InvokeServer();
        end);
        local l_workspace_ServerTimeNow_0 = workspace:GetServerTimeNow();
        pcall(function()
            -- upvalues: v6 (ref), l_workspace_ServerTimeNow_0 (ref)
            v6.Functions.ChargeRod:InvokeServer(l_workspace_ServerTimeNow_0);
        end);
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Functions.StartMini:InvokeServer(-1, 0.999);
        end);
        task.wait(_G.FishingDelay);
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Events.REFishDone:FireServer();
        end);
    end);
end;

local RandomResult = function()
    -- upvalues: v6 (ref)
    task.spawn(function()
        -- upvalues: v6 (ref)
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Functions.Cancel:InvokeServer();
        end);
        local l_workspace_ServerTimeNow_1 = workspace:GetServerTimeNow();
        pcall(function()
            -- upvalues: v6 (ref), l_workspace_ServerTimeNow_1 (ref)
            v6.Functions.ChargeRod:InvokeServer(l_workspace_ServerTimeNow_1);
        end);
        task.wait(0.2);
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Functions.StartMini:InvokeServer(-1, 0.999);
        end);
        task.wait(_G.FishingDelay);
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Events.REFishDone:FireServer();
        end);
    end);
end;


-- MULAI PEMBUATAN UI

Fish:AddSubSection("Blatant Features [BETA]");

Fish:AddDropdown({
    Title = "Fishing Mode",
    Options = {
        "Fast",
        "Random Result"
    },
    Default = "Fast",
    Multi = false,
    Callback = function(v210)
        selectedMode = v210;
    end
});

Fish:AddInput({
    Title = "Delay Reel",
    Value = tostring(_G.Reel),
    Default = "1.9",
    Callback = function(v211)
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
    Callback = function(v213)
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
    Callback = function(v215)
        _G.FBlatant = v215;
        if v215 then
            task.spawn(function()
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
    Callback = function()
        -- upvalues: v6 (ref)
        pcall(function()
            -- upvalues: v6 (ref)
            v6.Functions.Cancel:InvokeServer();
            chloex("Recovery Successfully!");
        end);
    end
});
