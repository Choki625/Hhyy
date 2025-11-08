-- Rayfield UI version of barulagi.lua
-- Features:
--  * Rayfield-based UI
--  * AutoFish toggle + Auto Tune
--  * TeleSell as TOGGLE (not loader)
--  * Minimize / Show Menu buttons (small always-on button)
-- Sources: original script + Rayfield library
-- (original file: https://raw.githubusercontent.com/purwocode/FISH-IT/refs/heads/main/barulagi.lua)

-- ===== Load Rayfield =====
local successRayfield, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
end)
if not successRayfield or type(Rayfield) ~= "table" then
    warn("[AutoFishRayfield] Failed to load Rayfield UI. Aborting.")
    return
end

-- ===== Services =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local plrGui = player:WaitForChild("PlayerGui")

-- ===== Remotes (adapted from original script) =====
local function safe_get_remote(path)
    local ok, val = pcall(function() return path end)
    if ok then return val end
    return nil
end

local RFChargeFishingRod = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"]
and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]

local RFStartMinigame = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"]
and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]

local REFishingCompleted = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"]
and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]

local RFCancelFishingInputs = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"]
and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/CancelFishingInputs"]

-- If any of remotes are missing, warn but still allow UI (some devs change names)
if not RFChargeFishingRod then warn("[AutoFishRayfield] RF/ChargeFishingRod not found (remote path may differ).") end
if not RFStartMinigame then warn("[AutoFishRayfield] RF/RequestFishingMinigameStarted not found.") end
if not REFishingCompleted then warn("[AutoFishRayfield] RE/FishingCompleted not found.") end
if not RFCancelFishingInputs then warn("[AutoFishRayfield] RF/CancelFishingInputs not found.") end

-- ===== State & config (same behavior as original) =====
local MIN_DELAY, MAX_DELAY = 0.05, 10
local config = {
    completeDelay = 0.3,
    cancelDelay = 0.2
}
local autoFish = false
local autoTune = false
local loopTask = nil
local successCount, errorCount = 0, 0

local function clamp(v, lo, hi) return math.clamp(v, lo, hi) end
local function safeSetConfig(key, val)
    local n = tonumber(val)
    if not n then return false end
    config[key] = clamp(n, MIN_DELAY, MAX_DELAY)
    return true
end
local function tuneDelay(up)
    if up then
        config.completeDelay = clamp(config.completeDelay + 0.1, MIN_DELAY, MAX_DELAY)
        config.cancelDelay   = clamp(config.cancelDelay + 0.05, MIN_DELAY, MAX_DELAY)
    else
        config.completeDelay = clamp(config.completeDelay - 0.05, MIN_DELAY, MAX_DELAY)
        config.cancelDelay   = clamp(config.cancelDelay - 0.03, MIN_DELAY, MAX_DELAY)
    end
end

-- ===== Fishing cycle implementation (core) =====
local function doFishingCycle()
    local ok = pcall(function()
        local args = { [4] = workspace:GetServerTimeNow() }
        if RFChargeFishingRod and type(RFChargeFishingRod.InvokeServer) == "function" then
            RFChargeFishingRod:InvokeServer(unpack(args, 1, table.maxn(args)))
        end
        if RFStartMinigame and type(RFStartMinigame.InvokeServer) == "function" then
            RFStartMinigame:InvokeServer(-1.233184814453125, 0.5949690465352809, 1762501523.357608)
        end
        task.wait(config.completeDelay)
        if REFishingCompleted and type(REFishingCompleted.FireServer) == "function" then
            REFishingCompleted:FireServer()
        end
        task.wait(config.cancelDelay)
        if RFCancelFishingInputs and type(RFCancelFishingInputs.InvokeServer) == "function" then
            RFCancelFishingInputs:InvokeServer()
        end
    end)
    if ok then
        successCount = successCount + 1
    else
        errorCount = errorCount + 1
    end
    if autoTune then
        if errorCount >= 3 then
            tuneDelay(true)
            errorCount = 0
            print(("[] Delay increased | Complete: %.2f | Cancel: %.2f"):format(config.completeDelay, config.cancelDelay))
        elseif successCount >= 10 then
            tuneDelay(false)
            successCount = 0
            print(("[⚡] Delay decreased | Complete: %.2f | Cancel: %.2f"):format(config.completeDelay, config.cancelDelay))
        end
    end
end

local function startLoop()
    if loopTask then return end
    autoFish = true
    loopTask = task.spawn(function()
        while autoFish do
            doFishingCycle()
        end
        loopTask = nil
    end)
end

local function stopLoop()
    autoFish = false
    loopTask = nil
    pcall(function()
        if RFCancelFishingInputs and type(RFCancelFishingInputs.InvokeServer) == "function" then
            RFCancelFishingInputs:InvokeServer()
        end
    end)
end

-- ===== TeleSell handling =====
-- We'll try to load telesell.lua, but we won't "auto-run" as loader. Instead we create a toggle:
local telesellURL = "https://raw.githubusercontent.com/purwocode/FISH-IT/main/telesell.lua"
local telesellModule = nil
do
    local ok, res = pcall(function()
        return loadstring(game:HttpGet(telesellURL))()
    end)
    if ok then
        telesellModule = res
        print("[AutoFishRayfield] telesell.lua loaded (module returned).")
    else
        warn("[AutoFishRayfield] Failed to load telesell.lua:", res)
        telesellModule = nil
    end
end

-- TeleSell runtime state
local telesellEnabled = false

local function setTeleSellEnabled(enable)
    if not telesellModule then
        warn("[AutoFishRayfield] telesell not available.")
        return
    end
    telesellEnabled = enable
    -- try common patterns: module table with Start/Stop, or module returns function
    if typeof(telesellModule) == "table" then
        if enable then
            if telesellModule.Start then pcall(telesellModule.Start) end
            if telesellModule.Enable then pcall(telesellModule.Enable) end
            if telesellModule.Toggle then pcall(function() telesellModule.Toggle(true) end) end
        else
            if telesellModule.Stop then pcall(telesellModule.Stop) end
            if telesellModule.Disable then pcall(telesellModule.Disable) end
            if telesellModule.Toggle then pcall(function() telesellModule.Toggle(false) end) end
        end
    elseif typeof(telesellModule) == "function" then
        -- If it's a function, call it only when enabling (best-effort)
        if enable then
            pcall(telesellModule)
        else
            -- can't reliably stop a function-style loader, so warn user
            warn("[AutoFishRayfield] telesell is function-only; cannot auto-stop reliably.")
        end
    end
end

-- ===== Build Rayfield UI =====
local Window = Rayfield:CreateWindow({
    Name = "Auto Fish (Rayfield)",
    LoadingTitle = "Auto Fish Rayfield",
    LoadingSubtitle = "by script converter",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- creates folder in Rayfield folder
        FileName = "AutoFishRayfieldConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Main tab & sections
local MainTab = Window:CreateTab("Main")
local ControlsSection = MainTab:CreateSection("Controls")
local SettingsSection = MainTab:CreateSection("Delay & Tune")
local MiscSection = MainTab:CreateSection("Misc")

-- AutoFish toggle
local autoFishToggle = ControlsSection:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFishToggle",
    Callback = function(val)
        if val then
            startLoop()
        else
            stopLoop()
        end
    end
})

-- Auto Tune toggle
local autoTuneToggle = ControlsSection:CreateToggle({
    Name = "Auto Tune",
    CurrentValue = false,
    Flag = "AutoTune",
    Callback = function(val)
        autoTune = val
    end
})

-- TeleSell toggle (user requested: "telesell tambahkan toggle jangan loader")
local telesellToggle = ControlsSection:CreateToggle({
    Name = "TeleSell (Toggle)",
    CurrentValue = false,
    Flag = "TeleSellToggle",
    Callback = function(val)
        setTeleSellEnabled(val)
    end
})

-- Complete Delay textbox
local completeBox = SettingsSection:CreateInput({
    Name = "Complete Delay (seconds)",
    Placeholder = tostring(config.completeDelay),
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if not safeSetConfig("completeDelay", text) then
            -- revert to current value as string
            Window:Notify({
                Title = "Invalid value",
                Content = "Complete delay must be a number between "..tostring(MIN_DELAY).." and "..tostring(MAX_DELAY),
                Duration = 3
            })
        end
    end
})

-- Cancel Delay textbox
local cancelBox = SettingsSection:CreateInput({
    Name = "Cancel Delay (seconds)",
    Placeholder = tostring(config.cancelDelay),
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        if not safeSetConfig("cancelDelay", text) then
            Window:Notify({
                Title = "Invalid value",
                Content = "Cancel delay must be a number between "..tostring(MIN_DELAY).." and "..tostring(MAX_DELAY),
                Duration = 3
            })
        end
    end
})

-- Quick buttons: Increase/Decrease delays (useful)
SettingsSection:CreateButton({
    Name = "Increase Delays",
    Callback = function()
        tuneDelay(true)
        completeBox:SetPlaceholder(tostring(config.completeDelay))
        cancelBox:SetPlaceholder(tostring(config.cancelDelay))
    end
})
SettingsSection:CreateButton({
    Name = "Decrease Delays",
    Callback = function()
        tuneDelay(false)
        completeBox:SetPlaceholder(tostring(config.completeDelay))
        cancelBox:SetPlaceholder(tostring(config.cancelDelay))
    end
})

-- Misc: Close / Destroy
MiscSection:CreateButton({
    Name = "Stop & Close",
    Callback = function()
        stopLoop()
        -- disable telesell if enabled
        if telesellEnabled then setTeleSellEnabled(false) end
        -- attempt to destroy Rayfield window (best-effort)
        pcall(function() Window:Destroy() end)
    end
})

-- ===== Minimize & Show Menu implementation =====
-- Rayfield has its own keybind to open (K by default), but we add a small always-on button:
local MINIMIZE_GUI_NAME = "AutoFish_MinimizeButton"
local function findExistingMinimize()
    return plrGui:FindFirstChild(MINIMIZE_GUI_NAME)
end

local function createMinimizeButton()
    if findExistingMinimize() then return end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = MINIMIZE_GUI_NAME
    screenGui.ResetOnSpawn = false
    screenGui.Parent = plrGui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 30)
    btn.Position = UDim2.new(0, 6, 0, 6)
    btn.AnchorPoint = Vector2.new(0, 0)
    btn.BackgroundTransparency = 0.2
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "Minimize UI"
    btn.Parent = screenGui

    local minimized = false
    local lastVisible = true

    local function setRayfieldVisible(v)
        -- Best-effort: find any ScreenGui instances that look like Rayfield UIs and toggle them.
        local function tryToggleIn(container)
            for _, obj in pairs(container:GetChildren()) do
                if obj:IsA("ScreenGui") and (string.find(obj.Name:lower(), "rayfield") or string.find(obj.Name:lower(), "rayfield_ui") or string.find(obj.Name:lower(), "interface")) then
                    pcall(function() obj.Enabled = v end)
                end
            end
        end
        pcall(function() tryToggleIn(plrGui) end)
        if game:GetService("CoreGui") then
            pcall(function() tryToggleIn(game:GetService("CoreGui")) end)
        end
    end

    btn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            btn.Text = "Show Menu"
            setRayfieldVisible(false)
        else
            btn.Text = "Minimize UI"
            setRayfieldVisible(true)
        end
    end)

    -- Right-click to completely destroy/hide the button if desired
    btn.MouseButton2Click:Connect(function()
        screenGui:Destroy()
    end)
end

createMinimizeButton()

-- ===== Auto-update inputs (reflect current values when autoTune changes) =====
task.spawn(function()
    while true do
        task.wait(1)
        if autoTune then
            pcall(function()
                completeBox:SetPlaceholder(string.format("%.2f", config.completeDelay))
                cancelBox:SetPlaceholder(string.format("%.2f", config.cancelDelay))
            end)
        end
    end
end)

-- Final message
print("[AutoFishRayfield] UI ready. Use the toggles to start/stop. TeleSell is a toggle (not loader).")

-- End of script
