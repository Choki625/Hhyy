-- ====================================================================
-- RAYFIELD UI SETUP
-- ====================================================================

-- Memuat Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Inisialisasi Window
local Window = Rayfield:CreateWindow({
    Name = "OGhub V1",
    LoadingTitle = "OGhub - LOADING ALL SYSTEMS",
    LoadingSubtitle = "PLENGER TEAM",
    ConfigurationSaving = { Enabled = false },
})

-- ====================================================================
-- GLOBAL STATE AND INITIALIZATION
-- ====================================================================

_G.Reel = _G.Reel or 1.9
_G.FishingDelay = _G.FishingDelay or 1.1
_G.FBlatant = _G.FBlatant or false 

local selectedMode = "Fast";
local AutoFishingThread = nil -- Variabel untuk mengontrol thread utama auto-fishing

-- Asumsikan 'v5' didefinisikan di tempat lain dalam lingkungan eksekusi.
local v6 = {
    Functions = {
        Cancel = v5.Net["RF/CancelFishingInputs"], -- RemoteFunction
        ChargeRod = v5.Net["RF/ChargeFishingRod"], -- RemoteFunction
        StartMini = v5.Net["RF/RequestFishingMinigameStarted"], -- RemoteFunction
    },
    Events = {
        REFishDone =  v5.Net["RE/FishingCompleted"], -- RemoteEvent
    }
}

local function SaveConfig()
    print("Configuration saved (Placeholder). Reel:", _G.Reel, "FishingDelay:", _G.FishingDelay)
end

-- ====================================================================
-- CORE FISHING LOGIC
-- ====================================================================

local Fastest = function()
    -- [Kode Fastest sama seperti sebelumnya]
    task.spawn(function()
        pcall(function()
            v6.Functions.Cancel:InvokeServer();
        end);
        local l_workspace_ServerTimeNow_0 = workspace:GetServerTimeNow();
        pcall(function()
            v6.Functions.ChargeRod:InvokeServer(l_workspace_ServerTimeNow_0);
        end);
        pcall(function()
            v6.Functions.StartMini:InvokeServer(-1, 0.999);
        end);
        task.wait(_G.FishingDelay);
        pcall(function()
            v6.Events.REFishDone:FireServer();
        end);
    end);
end;

local RandomResult = function()
    -- [Kode RandomResult sama seperti sebelumnya]
    task.spawn(function()
        pcall(function()
            v6.Functions.Cancel:InvokeServer();
        end);
        local l_workspace_ServerTimeNow_1 = workspace:GetServerTimeNow();
        pcall(function()
            v6.Functions.ChargeRod:InvokeServer(l_workspace_ServerTimeNow_1);
        end);
        task.wait(0.2); 
        pcall(function()
            v6.Functions.StartMini:InvokeServer(-1, 0.999);
        end);
        task.wait(_G.FishingDelay);
        pcall(function()
            v6.Events.REFishDone:FireServer();
        end);
    end);
end;

-- Variabel untuk memastikan UI hanya dibuat sekali
local UIInitialized = false
local FishTab = nil

---
## 🚀 Main Initialization & Auto-Fishing Control Function
---

local function Main()
    -- === 1. Inisialisasi UI (Hanya dilakukan sekali) ===
    if not UIInitialized then
        -- DEKLARASI FISH TAB DIPINDAH DI SINI
        FishTab = Window:CreateTab("Fish", "rbxassetid://6820023607")

        local BlatantSection = FishTab:CreateSection("Blatant Features [BETA]")

        -- 1. Dropdown
        BlatantSection:CreateDropdown({
            Name = "Fishing Mode",
            Options = {"Fast", "Random Result"},
            CurrentOption = selectedMode,
            Callback = function(mode)
                selectedMode = mode;
                if _G.FBlatant then Main() end -- Panggil Main() untuk memperbarui mode loop
            end,
        })

        -- 2. Input Delay Reel
        BlatantSection:CreateInput({
            Name = "Delay Reel",
            Placeholder = "Waktu jeda antar siklus pancing (1.9)",
            Default = tostring(_G.Reel),
            Callback = function(input)
                local num = tonumber(input);
                if num and num > 0 then _G.Reel = num; end;
                SaveConfig();
            end,
        })

        -- 3. Input Delay Fishing
        BlatantSection:CreateInput({
            Name = "Delay Fishing",
            Placeholder = "Waktu jeda internal dalam siklus (1.1)",
            Default = tostring(_G.FishingDelay),
            Callback = function(input)
                local num = tonumber(input);
                if num and num > 0 then _G.FishingDelay = num; end;
                SaveConfig();
            end,
        })

        -- 4. Toggle untuk Mengaktifkan Auto-Fishing
        BlatantSection:CreateToggle({
            Name = "Blatant Fishing",
            Default = _G.FBlatant,
            Callback = function(state)
                _G.FBlatant = state;
                Main(); -- Panggil Main() untuk memulai/menghentikan loop
            end,
        })

        -- 5. Button untuk Recovery
        BlatantSection:CreateButton({
            Name = "Recovery Fishing",
            Callback = function()
                pcall(function()
                    v6.Functions.Cancel:InvokeServer();
                    Rayfield:Notify({
                        Title = "Fishing System",
                        Content = "Recovery Successfully!",
                        Duration = 5,
                        Image = 4483362458
                    })
                end);
            end,
        })
        
        UIInitialized = true
    end

    -- === 2. Kontrol Auto-Fishing Thread ===
    
    -- Selalu batalkan thread lama jika ada, untuk menghindari duplikasi
    if AutoFishingThread then 
        task.cancel(AutoFishingThread)
        AutoFishingThread = nil
    end

    if _G.FBlatant then
        AutoFishingThread = task.spawn(function()
            while _G.FBlatant do
                if selectedMode == "Fast" then
                    Fastest();
                elseif selectedMode == "Random Result" then
                    RandomResult();
                end;
                task.wait(_G.Reel);
            end;
        end);
    end
end

-- ====================================================================
-- EKSEKUSI
-- ====================================================================

-- Panggil Main() di akhir skrip untuk:
-- 1. Menginisialisasi seluruh UI (termasuk FishTab) hanya sekali.
-- 2. Memastikan loop Auto-Fishing dimulai jika _G.FBlatant sudah True secara default.
Main()
