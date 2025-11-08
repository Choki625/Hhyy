-- Full Rayfield UI script: Auto Fish + Perfect Cast + Smart Mode + Teleport +
-- Sell All + Auto Buy Weather + Minimize (Window:Hide()/Window:Show()) +
-- Restore button + Hotkey RightCtrl+M
-- Paste into your executor. Adjust remote names if necessary.

-- Load Rayfield (update URL if you use another Rayfield build)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Wait & find remotes (adjust path if your game organizes differently)
local successNet, net = pcall(function()
    return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0").net
end)
if not successNet then
    warn("Could not locate net package under ReplicatedStorage.Packages._Index. Check path.")
    net = ReplicatedStorage -- fallback so FindFirstChild calls below won't error
end

-- Try-find remotes safely (some games use different naming or placement)
local function findRemote(name)
    if type(net) == "table" or typeof(net) == "Instance" then
        local ok, v = pcall(function() return net:FindFirstChild(name) end)
        if ok and v then return v end
    end
    -- fallback search in ReplicatedStorage root
    local ok2, v2 = pcall(function() return ReplicatedStorage:FindFirstChild(name) end)
    if ok2 and v2 then return v2 end
    return nil
end

local chargeRodRemote       = findRemote("RF/ChargeFishingRod") or findRemote("ChargeFishingRod")
local miniGameRemote        = findRemote("RF/RequestFishingMinigameStarted") or findRemote("RequestFishingMinigameStarted")
local fishingCompletedRemote= findRemote("RE/FishingCompleted") or findRemote("FishingCompleted")
local equipRemote           = findRemote("RE/EquipToolFromHotbar") or findRemote("EquipToolFromHotbar")
local REFishCaught          = findRemote("RE/FishCaught") or findRemote("FishCaught")
local RFSellAllItems        = findRemote("RF/SellAllItems") or findRemote("SellAllItems")
local RFPurchaseWeather     = findRemote("RF/PurchaseWeatherEvent") or findRemote("PurchaseWeatherEvent")

-- State variables
local autoFish = false
local perfectCast = false
local smartMode = false
local autoRecastDelay = 0.5
local loopTask = nil

local autoBuyWeather = false
local weatherTask = nil

local isMinimized = false

-- Teleport points (customize if needed)
local teleportPoints = {
    ["CRYSTAL FALL"] = Vector3.new(-1957.25 , -440.00, 7385.86),
    ["CRYSTAL CAVERN"] = Vector3.new(-1609.50, -447.75, 7238.00),
    ["Sisyphus STATUE"] = Vector3.new(-3705.79, -135.24, -1021.82),
    ["Mount Hallow"] = Vector3.new(1796.60, 2.67, 3066.99),
    ["KOHANA"] = Vector3.new(-651.95, 17.25, 497.16),
    ["KOHANA VOLCANO"] = Vector3.new(-632.30, 55.56, 199.26),
    ["FISHERMAN ISLAND"] = Vector3.new(99.53, 9.53, 2792.58),
    ["ANCIENT JUNGLE"] = Vector3.new(1307.63, 5.83, -155.62),
    ["Sacred Temple"] = Vector3.new(1465.62, -21.88, -637.75)
}

local function teleportTo(location)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(location + Vector3.new(0,5,0))
    end
end

local function safeInvoke(remote, ...)
    if not remote then return end
    -- prefer :InvokeServer if present, else :Invoke, else :FireServer / :Fire
    local ok
    pcall(function()
        if remote.InvokeServer then
            remote:InvokeServer(...)
        elseif remote.Invoke then
            remote:Invoke(...)
        elseif remote.FireServer then
            remote:FireServer(...)
        elseif remote.Fire then
            remote:Fire(...)
        end
    end)
end

local function safeFire(remote, ...)
    if not remote then return end
    pcall(function()
        if remote.FireServer then
            remote:FireServer(...)
        elseif remote.Fire then
            remote:Fire(...)
        elseif remote.InvokeServer then
            remote:InvokeServer(...)
        elseif remote.Invoke then
            remote:Invoke(...)
        end
    end)
end

local function equipRodFast()
    if equipRemote then
        pcall(function() 
            if equipRemote.FireServer then equipRemote:FireServer(1) 
            else equipRemote:Invoke(1) end
        end)
    end
end

-- When fish caught: re-equip (keeps loop stable)
if REFishCaught then
    pcall(function()
        if REFishCaught.OnClientEvent then
            REFishCaught.OnClientEvent:Connect(function(fishName, fishData)
                if autoFish then
                    equipRodFast()
                end
            end)
        end
    end)
end

-- Auto Fish loop (uses perfect cast values if active)
local function startLoop()
    if loopTask then return end
    loopTask = task.spawn(function()
        while autoFish do
            pcall(function()
                if equipRemote then
                    equipRodFast()
                    task.wait(0.1)
                end

                local timestamp = perfectCast and 9999999999 or (tick() + math.random())
                safeInvoke(chargeRodRemote, timestamp)
                task.wait(0.1)

                local x = perfectCast and -1.238 or (math.random(-1000,1000)/1000)
                local y = perfectCast and 0.969 or (math.random(0,1000)/1000)
                safeInvoke(miniGameRemote, x, y)

                task.wait(1.3)
                safeFire(fishingCompletedRemote)
            end)
            task.wait(autoRecastDelay)
        end
        loopTask = nil
    end)
end

local function stopLoop()
    autoFish = false
    loopTask = nil
end

-- Auto Buy Weather
local weathers = {
    { Name = "Wind" },
    { Name = "Snow" },
    { Name = "Cloudy" },
    { Name = "Storm" },
    { Name = "Shark Hunt" }
}

local function startAutoBuyWeather()
    if weatherTask then return end
    weatherTask = task.spawn(function()
        while autoBuyWeather do
            for _, w in ipairs(weathers) do
                if not autoBuyWeather then break end
                pcall(function()
                    safeInvoke(RFPurchaseWeather, w.Name)
                end)
                task.wait(1.5)
            end
            task.wait(10)
        end
        weatherTask = nil
    end)
end

local function stopAutoBuyWeather()
    autoBuyWeather = false
    weatherTask = nil
end

-- === Rayfield Window ===
local Window = Rayfield:CreateWindow({
    Name = "Fish-IT (Rayfield)",
    LoadingTitle = "Fish-IT",
    LoadingSubtitle = "Auto Fish + Weather",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "fishit_config"
    }
})

-- === Auto Fish Tab ===
local autoTab = Window:CreateTab("Auto Fish")
autoTab:CreateParagraph({ Title = "Auto Fish Settings", Content = "Toggle Auto Fish / Perfect Cast / Smart Mode. Use Minimize to hide UI." })

local autoToggle = autoTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFishToggle",
    Callback = function(val)
        autoFish = val
        if autoFish then startLoop() else stopLoop() end
        -- If smartMode was on but user turns Auto Fish off manually, disable smartMode
        if not autoFish and smartMode then
            smartMode = false
            Rayfield:Notify({Title="Smart Mode", Content="Smart Mode disabled (Auto Fish OFF)", Duration=2})
        end
    end
})

local perfectToggle = autoTab:CreateToggle({
    Name = "✨ Perfect Cast",
    CurrentValue = false,
    Flag = "PerfectCastToggle",
    Callback = function(val)
        perfectCast = val
        if not perfectCast and smartMode then
            smartMode = false
            Rayfield:Notify({Title="Smart Mode", Content="Smart Mode disabled (Perfect Cast OFF)", Duration=2})
        end
    end
})

local smartToggle = autoTab:CreateToggle({
    Name = "🤖 Smart Mode (Auto + Perfect)",
    CurrentValue = false,
    Flag = "SmartModeToggle",
    Callback = function(val)
        smartMode = val
        if smartMode then
            perfectCast = true
            autoFish = true
            -- attempt to update toggles visuals (Rayfield may or may not expose API for this)
            pcall(function()
                autoToggle:SetValue(true)
                perfectToggle:SetValue(true)
            end)
            startLoop()
            Rayfield:Notify({Title="Smart Mode", Content="Smart Mode enabled", Duration=2})
        else
            perfectCast = false
            autoFish = false
            pcall(function()
                autoToggle:SetValue(false)
                perfectToggle:SetValue(false)
            end)
            stopLoop()
            Rayfield:Notify({Title="Smart Mode", Content="Smart Mode disabled", Duration=2})
        end
    end
})

autoTab:CreateSlider({
    Name = "⏱️ Auto Recast Delay (seconds)",
    Range = {0.1, 3},
    Increment = 0.05,
    CurrentValue = autoRecastDelay,
    Flag = "AutoRecastDelay",
    Callback = function(val)
        autoRecastDelay = val
    end
})

autoTab:CreateButton({
    Name = "Sell All Fish",
    Callback = function()
        pcall(function()
            safeInvoke(RFSellAllItems)
            Rayfield:Notify({Title="Sell", Content="Sell all invoked", Duration=2})
        end)
    end
})

-- === Minimize/Restore helpers & UI ===
-- Create a small ScreenGui restore button that remains visible when main window is hidden.
local restoreGui = Instance.new("ScreenGui")
restoreGui.Name = "FishIT_RestoreGui"
restoreGui.ResetOnSpawn = false
restoreGui.Parent = CoreGui
restoreGui.Enabled = false -- only enabled when minimized

-- Styling: simple dark box top-right
local restoreBtn = Instance.new("TextButton")
restoreBtn.Name = "RestoreButton"
restoreBtn.Size = UDim2.new(0, 140, 0, 40)
restoreBtn.Position = UDim2.new(1, -160, 0, 18) -- top-right small inset
restoreBtn.AnchorPoint = Vector2.new(0, 0)
restoreBtn.BackgroundTransparency = 0.18
restoreBtn.BackgroundColor3 = Color3.fromRGB(24,24,24)
restoreBtn.BorderSizePixel = 0
restoreBtn.TextColor3 = Color3.fromRGB(255,255,255)
restoreBtn.Font = Enum.Font.GothamSemibold
restoreBtn.TextSize = 14
restoreBtn.Text = "Show Fish-IT"
restoreBtn.Parent = restoreGui

-- Optional small icon (rounded)
local corner = Instance.new("UICorner", restoreBtn)
corner.CornerRadius = UDim.new(0, 8)

local function minimizeWindow()
    pcall(function() Window:Hide() end)
    isMinimized = true
    restoreGui.Enabled = true
    -- try updating Minimize toggle visual to true
    pcall(function() 
        local t = autoTab:Get("MinimizeToggle") -- if your Rayfield supports Get by Flag
        if t then t:SetValue(true) end
    end)
end

local function restoreWindow()
    pcall(function() Window:Show() end)
    isMinimized = false
    restoreGui.Enabled = false
    -- try updating Minimize toggle visual to false
    pcall(function() 
        local t = autoTab:Get("MinimizeToggle")
        if t then t:SetValue(false) end
    end)
end

-- Hook restore button
restoreBtn.MouseButton1Click:Connect(function()
    restoreWindow()
    pcall(function() Rayfield:Notify({Title="Fish-IT", Content="UI Restored", Duration=2}) end)
end)

-- Minimize toggle in UI: when ON => hide, OFF => show
autoTab:CreateToggle({
    Name = "🪟 Minimize UI",
    CurrentValue = false,
    Flag = "MinimizeToggle",
    Callback = function(val)
        if val then
            minimizeWindow()
            Rayfield:Notify({Title="Fish-IT", Content="UI Minimized", Duration=1.5})
        else
            restoreWindow()
            Rayfield:Notify({Title="Fish-IT", Content="UI Restored", Duration=1.5})
        end
    end
})

-- Hotkey: RightControl + M to toggle hide/show
local hotkey1 = Enum.KeyCode.RightControl
local hotkey2 = Enum.KeyCode.M
local hotkeyDown = {}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        hotkeyDown[input.KeyCode] = true
        if hotkeyDown[hotkey1] and hotkeyDown[hotkey2] then
            if isMinimized then
                restoreWindow()
                pcall(function() Rayfield:Notify({Title="Fish-IT", Content="UI Restored (Hotkey)", Duration=1.5}) end)
            else
                minimizeWindow()
                pcall(function() Rayfield:Notify({Title="Fish-IT", Content="UI Minimized (Hotkey)", Duration=1.5}) end)
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        hotkeyDown[input.KeyCode] = nil
    end
end)

-- === Teleport Tab ===
local tpTab = Window:CreateTab("Teleport")
tpTab:CreateSection("Locations")
local tpNames = {}
for name, _ in pairs(teleportPoints) do table.insert(tpNames, name) end
table.sort(tpNames)

local selectedTP = tpNames[1] or nil
tpTab:CreateDropdown({
    Name = "Select Location",
    Options = tpNames,
    CurrentOption = selectedTP,
    Flag = "TeleportDropdown",
    Callback = function(opt) selectedTP = opt end
})

tpTab:CreateButton({
    Name = "Teleport",
    Callback = function()
        if selectedTP and teleportPoints[selectedTP] then
            teleportTo(teleportPoints[selectedTP])
            Rayfield:Notify({Title="Teleport", Content="Teleported to "..selectedTP, Duration=1.5})
        else
            Rayfield:Notify({Title="Teleport", Content="No location selected", Duration=1.5})
        end
    end
})

tpTab:CreateSection("Quick Teleports")
for _, name in ipairs(tpNames) do
    tpTab:CreateButton({
        Name = name,
        Callback = (function(n)
            return function()
                teleportTo(teleportPoints[n])
                Rayfield:Notify({Title="Teleport", Content="Teleported to "..n, Duration=1.2})
            end
        end)(name)
    })
end

-- === Buy Weather Tab ===
local buyWeatherTab = Window:CreateTab("Buy Weather")
buyWeatherTab:CreateParagraph({ Title = "Weather Purchase", Content = "Auto Buy attempts to purchase each weather event in sequence." })

buyWeatherTab:CreateToggle({
    Name = "Auto Buy All Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeatherToggle",
    Callback = function(val)
        autoBuyWeather = val
        if autoBuyWeather then startAutoBuyWeather() else stopAutoBuyWeather() end
    end
})

for _, w in ipairs(weathers) do
    buyWeatherTab:CreateButton({
        Name = "Buy "..w.Name,
        Callback = (function(name)
            return function()
                pcall(function() safeInvoke(RFPurchaseWeather, name) end)
                Rayfield:Notify({Title="Weather", Content="Attempted purchase: "..name, Duration=1.5})
            end
        end)(w.Name)
    })
end

-- Final print
print("[✅] Fish-IT Rayfield UI loaded: AutoFish, PerfectCast, SmartMode, Teleport, BuyWeather, Minimize/Restore/Hotkey")
