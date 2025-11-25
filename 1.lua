-- ====================================================================
--  LOAD RAYFIELD UI LIBRARY
-- ====================================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ====================================================================
--  0. GLOBAL CONFIGURATION & INITIALIZATION
-- ====================================================================
local Config = {
    AutoFish = false,       -- Status utama Auto Fish
    BlatantMode = true,     -- Status Blatant Mode default aktif
    FishDelay = 1.0,        -- Waktu tunggu gigitan (detik)
    CatchDelay = 2.0        -- Waktu cooldown setelah catch (detik)
}

-- Variabel status
local isFishing = false     -- Status apakah script sedang dalam siklus fishing
local fishingActive = false -- Status yang dikontrol oleh UI Toggle
local currentLoopThread = nil -- Untuk mengontrol thread loop saat ini

-- ====================================================================
--  1. CRITICAL DEPENDENCY VALIDATION
-- ====================================================================
local services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
}

local success, errorMsg = pcall(function()
    for serviceName, service in pairs(services) do
        if not service then
            error("Critical service missing: " .. serviceName)
        end
    end
    
    services.LocalPlayer = services.Players.LocalPlayer
    if not services.LocalPlayer then
        error("LocalPlayer not available")
    end
    
    if not task.wait or not task.spawn then
        error("Modern task scheduler missing")
    end
end)

if not success then
    error("❌ [Auto Fish] Critical dependency check failed: " .. tostring(errorMsg))
    return
end

-- ====================================================================
--  2. CORE SERVICES & EVENTS (PASTIKAN NAMA EVENT INI BENAR)
-- ====================================================================
local ReplicatedStorage = services.ReplicatedStorage
local LocalPlayer = services.LocalPlayer

-- GANTI PATH/NAMA REMOTE EVENT INI SESUAI DENGAN GAME TARGET
local Events = {
    equip = ReplicatedStorage:FindFirstChild("RemoteEquipEvent"), 
    charge = ReplicatedStorage:FindFirstChild("RemoteChargeEvent"), 
    minigame = ReplicatedStorage:FindFirstChild("RemoteMinigameEvent"), 
    fishing = ReplicatedStorage:FindFirstChild("RemoteFishingEvent") 
}

for eventName, event in pairs(Events) do
    if not event then
        warn("⚠️ RemoteEvent missing: " .. eventName .. ". Script might not work!")
    end
end

-- ====================================================================
--  3. CORE LOGIC (Blatant Fishing Loop)
-- ====================================================================

-- Fungsi utilitas untuk memanggil event dengan aman
local function safeFire(event, ...)
    if event and event:IsA("RemoteEvent") then
        pcall(event.FireServer, event, ...)
    end
end

-- Fungsi utilitas untuk memanggil InvokeServer dengan aman
local function safeInvoke(event, ...)
    if event and event:IsA("RemoteFunction") then
        local success, result = pcall(event.InvokeServer, event, ...)
        return success, result
    end
    return false, nil
end

local function blatantFishingLoop()
    -- Pastikan loop berhenti jika status fishingActive berubah
    while fishingActive and Config.BlatantMode do
        if not isFishing then
            isFishing = true
            
            -- STEP 1: Rapid fire casts (Menggunakan InvokeServer yang lebih aman)
            
            -- Equip Rod
            safeFire(Events.equip, 1)
            task.wait(0.01)
            
            -- Cast 1 (Parallel)
            task.spawn(function()
                safeInvoke(Events.charge, 1755848498.4834)
                task.wait(0.01)
                safeInvoke(Events.minigame, 1.2854545116425, 1)
            end)
            
            task.wait(0.05)
            
            -- Cast 2 (Overlapping/Parallel)
            task.spawn(function()
                safeInvoke(Events.charge, 1755848498.4834)
                task.wait(0.01)
                safeInvoke(Events.minigame, 1.2854545116425, 1)
            end)
            
            -- STEP 2: Wait for fish to bite
            task.wait(Config.FishDelay)
            
            -- STEP 3: Spam reel 5x to instant catch
            for i = 1, 5 do
                safeFire(Events.fishing) 
                task.wait(0.01)
            end
            
            -- STEP 4: Short cooldown
            local cooldown = Config.CatchDelay * 0.5
            task.wait(cooldown)
            
            isFishing = false
            print("[Blatant] ⚡ Fast cycle complete. Cooldown: " .. string.format("%.2f", cooldown) .. "s")
        else
            -- Menambahkan timeout yang aman jika isFishing tidak pernah false (potensi bug)
            task.wait(0.01) 
        end
    end
end

-- Fungsi kontrol loop yang dioptimasi
local function setFishingActive(active)
    fishingActive = active
    
    -- Hentikan thread loop lama jika ada (untuk clean start/stop)
    if currentLoopThread then
        task.cancel(currentLoopThread)
        currentLoopThread = nil
    end
    
    if active and Config.BlatantMode then
        print("🎣 Auto Fish Started! (Blatant Mode)")
        -- Mulai loop baru dan simpan referensi thread-nya
        currentLoopThread = task.spawn(blatantFishingLoop)
    elseif active and not Config.BlatantMode then
        print("🎣 Auto Fish Started! (Normal Mode - Using Blatant Loop)")
        -- Mulai loop baru untuk mode normal (jika ada)
        currentLoopThread = task.spawn(blatantFishingLoop)
    else
        print("🛑 Auto Fish Stopped.")
    end
end


-- ====================================================================
--  4. RAYFIELD UI SCRIPT
-- ====================================================================
if not Rayfield then
    warn("⚠️ Rayfield not loaded! UI will not be displayed.")
else
    local Window = Rayfield:CreateWindow({
        Name = "🐟 Auto Fish - Rayfield UI",
        LoadingTitle = "Initializing Auto Fish",
        LoadingSubtitle = "Setting up configurations...",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AutoFishScript",
            FileName = "Config"
        },
    })

    -- --- MAIN TAB ---
    local MainTab = Window:CreateTab("Main", "rbxassetid://15448359409") 

    -- Toggle Auto Fish Utama
    MainTab:CreateToggle({
        Name = "Activate Auto Fish",
        CurrentValue = Config.AutoFish,
        Callback = function(Value)
            Config.AutoFish = Value
            setFishingActive(Value)
        end,
        Sections = {
            "Toggles",
            "Controls the main fishing loop. Toggle OFF to stop."
        }
    })

    -- Toggle Blatant Mode
    MainTab:CreateToggle({
        Name = "⚡ Blatant Mode (Speed)",
        CurrentValue = Config.BlatantMode,
        Callback = function(Value)
            Config.BlatantMode = Value
            -- Re-trigger loop untuk menerapkan mode baru jika sudah aktif
            if Config.AutoFish then
                setFishingActive(true) -- Cukup panggil true untuk menghentikan thread lama dan memulai yang baru
            end
        end,
        Sections = {
            "Toggles",
            "Uses double cast and instant reel spam (High Risk)."
        }
    })
    
    -- --- SETTINGS TAB ---
    local SettingsTab = Window:CreateTab("Settings", "rbxassetid://15448356980") 

    SettingsTab:CreateSlider({
        Name = "Fish Delay (Wait for Bite)",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = Config.FishDelay,
        Callback = function(Value)
            Config.FishDelay = Value
        },
        Sections = {
            "Timing",
            "Time (in seconds) the script waits after casting before spamming the reel."
        }
    })

    SettingsTab:CreateSlider({
        Name = "Catch Cooldown (Loop Wait)",
        Range = {0.5, 5},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = Config.CatchDelay,
        Callback = function(Value)
            Config.CatchDelay = Value
        },
        Sections = {
            "Timing",
            "This value is halved when Blatant Mode is active. Cooldown before next cast."
        }
    })
    
    -- --- UTILITY ---
    SettingsTab:CreateButton({
        Name = "Save Configuration",
        Callback = function()
            Rayfield:SaveConfiguration()
            print("💾 Configuration saved!")
        end,
        Sections = {
            "Utility",
            "Manually save your current settings to be loaded next time."
        }
    })
end

-- ====================================================================
--  5. SCRIPT EXECUTION START
-- ====================================================================
print("✅ [Auto Fish] Script loaded successfully.")
