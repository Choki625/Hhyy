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

-- CATATAN PENTING:
-- Ganti ini dengan referensi objek RemoteFunction/RemoteEvent yang BENAR dalam game Anda.
local v6 = {
    Functions = {
        Cancel = nil, -- RemoteFunction
        ChargeRod = nil, -- RemoteFunction
        StartMini = nil, -- RemoteFunction
    },
    Events = {
        REFishDone = nil, -- RemoteEvent
    }
}
-- Asumsikan 'v6' sudah berisi referensi yang valid saat skrip dijalankan.

local function SaveConfig()
    print("Configuration saved (Placeholder). Reel:", _G.Reel, "FishingDelay:", _G.FishingDelay)
end

-- ====================================================================
-- CORE FISHING LOGIC
-- ====================================================================

local Fastest = function()
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

-- ====================================================================
-- RAYFIELD UI ELEMENTS
-- ====================================================================

local FishTab = Window:CreateTab("Fish", "rbxassetid://6820023607")

local BlatantSection = FishTab:CreateSection("Blatant Features [BETA]")

-- 1. Dropdown
BlatantSection:CreateDropdown({
    Name = "Fishing Mode",
    Options = {"Fast", "Random Result"},
    CurrentOption = selectedMode,
    Callback = function(mode)
        selectedMode = mode;
    end,
})

-- 2. Input Delay Reel
BlatantSection:CreateInput({
    Name = "Delay Reel",
    Placeholder = "Waktu jeda antar siklus pancing (1.9)",
    Default = tostring(_G.Reel),
    Callback = function(input)
        local num = tonumber(input);
        if num and num > 0 then
            _G.Reel = num;
        end;
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
        if num and num > 0 then
            _G.FishingDelay = num;
        end;
        SaveConfig();
    end,
})

-- 4. Toggle untuk Mengaktifkan Auto-Fishing (MODIFIKASI INI)
BlatantSection:CreateToggle({
    Name = "Blatant Fishing",
    Default = _G.FBlatant,
    Callback = function(state)
        _G.FBlatant = state;
        if state then
            -- === THREAD 1: Pancing Otomatis Utama ===
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
            
            -- === THREAD 2: Pancing Cepat Tambahan (Hanya Mode Fast) ===
            task.spawn(function()
                while _G.FBlatant do
                    if selectedMode == "Fast" then
                        -- Memanggil Fastest() lagi untuk thread kedua. 
                        -- Dapat menggunakan jeda yang sedikit berbeda untuk 'desync'.
                        Fastest(); 
                    end;
                    -- Menggunakan jeda Reel yang sama atau dimodifikasi, misalnya: _G.Reel - 0.1
                    task.wait(_G.Reel); 
                end;
            end);
        end;
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
