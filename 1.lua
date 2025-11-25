-- ====================================================================
--  0. GLOBAL CONFIGURATION & INITIALIZATION (Dapat dimuat/disimpan oleh Rayfield)
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

-- ====================================================================
--  1. CRITICAL DEPENDENCY VALIDATION
-- ====================================================================
local services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    HttpService = game:GetService("HttpService"), -- Mungkin tidak diperlukan, tapi dipertahankan
    VirtualUser = game:GetService("VirtualUser") -- Dipertahankan
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
    
    -- Cek ketersediaan task library (Roblox modern)
    if not task.wait or not task.spawn then
        error("Modern task scheduler missing")
    end
end)

if not success then
    error("❌ [Auto Fish] Critical dependency check failed: " .. tostring(errorMsg))
    return
end

-- ====================================================================
--  2. CORE SERVICES & EVENTS
-- ====================================================================
local Players = services.Players
local RunService = services.RunService
local ReplicatedStorage = services.ReplicatedStorage
local LocalPlayer = services.LocalPlayer

-- ASUMSI: Events berada di ReplicatedStorage atau lokasi lain
-- Ganti path berikut dengan lokasi RemoteEvent yang sebenarnya di game
local Events = {
    equip = ReplicatedStorage:FindFirstChild("RemoteEquipEvent"), -- Ganti jika perlu
    charge = ReplicatedStorage:FindFirstChild("RemoteChargeEvent"), -- Ganti jika perlu
    minigame = ReplicatedStorage:FindFirstChild("RemoteMinigameEvent"), -- Ganti jika perlu
    fishing = ReplicatedStorage:FindFirstChild("RemoteFishingEvent") -- Ganti jika perlu (Spam Reel)
}

-- Validasi Events
for eventName, event in pairs(Events) do
    if not event then
        warn("⚠️ RemoteEvent missing: " .. eventName .. ". Script might not work!")
    end
end

-- ====================================================================
--  3. CORE LOGIC (Blatant Fishing Loop)
-- ====================================================================

-- Fungsi utama yang menjalankan siklus fishing
local function blatantFishingLoop()
    -- Loop berjalan hanya jika diaktifkan (fishingActive) dan BlatantMode aktif
    while fishingActive and Config.BlatantMode do
        -- Pastikan siklus sebelumnya sudah selesai
        if not isFishing then
            isFishing = true
            
            pcall(function()
                
                -- Pastikan event ada sebelum diakses
                if Events.equip then
                    Events.equip:FireServer(1) -- Equip Rod
                    task.wait(0.01)
                end
                
                -- Cast 1 (Parallel)
                task.spawn(function()
                    if Events.charge and Events.minigame then
                        -- Angka Charge/Minigame (1755848498.4834, 1.2854545116425) ASUMSI fixed value
                        -- Sesuaikan jika game memerlukan input dinamis
                        Events.charge:InvokeServer(1755848498.4834)
                        task.wait(0.01)
                        Events.minigame:InvokeServer(1.2854545116425, 1)
                    end
                end)
                
                task.wait(0.05)
                
                -- Cast 2 (Overlapping/Parallel)
                task.spawn(function()
                    if Events.charge and Events.minigame then
                        Events.charge:InvokeServer(1755848498.4834)
                        task.wait(0.01)
                        Events.minigame:InvokeServer(1.2854545116425, 1)
                    end
                end)
            end)
            
            -- Step 2: Wait for fish to bite
            task.wait(Config.FishDelay)
            
            -- Step 3: Spam reel 5x to instant catch (Jika minigame berhasil di-skip/dipalsukan)
            for i = 1, 5 do
                pcall(function() 
                    if Events.fishing then
                        Events.fishing:FireServer() -- Reel/Catch Event
                    end
                end)
                task.wait(0.01)
            end
            
            -- Step 4: Short cooldown (50% faster)
            local cooldown = Config.CatchDelay * 0.5
            task.wait(cooldown)
            
            isFishing = false
            print("[Blatant] ⚡ Fast cycle complete. Cooldown: " .. string.format("%.2f", cooldown) .. "s")
        else
            task.wait(0.01) -- Tunggu sebentar jika sedang dalam proses
        end
    end
end

-- Fungsi kontrol untuk Toggle UI
local function setFishingActive(active)
    fishingActive = active
    if active and Config.BlatantMode then
        print("🎣 Auto Fish Started! (Blatant Mode)")
        -- Mulai loop utama di thread baru
        task.spawn(blatantFishingLoop)
    elseif active and not Config.BlatantMode then
        print("🎣 Auto Fish Started! (Normal Mode - Blatant Loop is currently the only logic implemented)")
        -- Jika Anda memiliki loop normal, panggil di sini.
        -- Untuk saat ini, hanya menggunakan loop blatant (Anda dapat menyesuaikannya)
        task.spawn(blatantFishingLoop)
    else
        print("🛑 Auto Fish Stopped.")
    end
end


-- ====================================================================
--  4. RAYFIELD UI SCRIPT
-- ====================================================================
if not Rayfield then
    warn("⚠️ Rayfield not loaded! UI will not be displayed. Script is running in background.")
    -- Script utama akan tetap berjalan jika Rayfield tidak ada.
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
            -- Jika sedang aktif, re-trigger loop agar menggunakan mode baru
            if Config.AutoFish then
                setFishingActive(false)
                setFishingActive(true)
            end
        end,
        Sections = {
            "Toggles",
            "Uses double cast and instant reel spam (High Risk)."
        }
    })
    
    ---

    -- --- SETTINGS TAB ---
    local SettingsTab = Window:CreateTab("Settings", "rbxassetid://15448356980") 

    -- Fish Delay Slider
    SettingsTab:CreateSlider({
        Name = "Fish Delay (Wait for Bite)",
        Range = {0.1, 5},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = Config.FishDelay,
        Callback = function(Value)
            Config.FishDelay = Value
            print("⚙️ FishDelay set to: " .. Value .. "s")
        end,
        Sections = {
            "Timing",
            "Time (in seconds) the script waits after casting before spamming the reel."
        }
    })

    -- Catch Delay Slider
    SettingsTab:CreateSlider({
        Name = "Catch Cooldown (Loop Wait)",
        Range = {0.5, 5},
        Increment = 0.1,
        Suffix = "s",
        CurrentValue = Config.CatchDelay,
        Callback = function(Value)
            Config.CatchDelay = Value
            print("⚙️ CatchDelay set to: " .. Value .. "s")
        end,
        Sections = {
            "Timing",
            "This value is halved when Blatant Mode is active. Cooldown before next cast."
        }
    })
    
    ---
    
    -- --- EXTRA ---
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
