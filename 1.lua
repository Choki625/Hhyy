local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local StarterPack = game:GetService("StarterPack")
local player = Players.LocalPlayer

local StartRemote = ReplicatedStorage:WaitForChild("FishingStart")
local ReelRemote = ReplicatedStorage:WaitForChild("FishingReel")
local NotifyRemote = ReplicatedStorage:WaitForChild("FishingNotify")

local DEV = {
    autoFish = true,
    autoPerfection = true,
    speedMultiplier = 1.0,
    instantCatch = true,
    superFast = 0,
    delayMode = 1.0,
    autoEquipRadar = true,
    animationEnabled = false,
}

local screen = Instance.new("ScreenGui")
screen.Name = "FishingUI_v3"
screen.ResetOnSpawn = false
screen.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 380, 0, 220)
main.Position = UDim2.new(0, 12, 0, 12)
main.BackgroundColor3 = Color3.fromRGB(12,12,12)
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0,0)
main.Parent = screen

local border = Instance.new("UIStroke")
border.Parent = main
border.Color = Color3.fromRGB(190,30,30)
border.Thickness = 2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 30)
title.Position = UDim2.new(0,12,0,8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "Fishing System v3"
title.TextColor3 = Color3.fromRGB(230,80,80)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -24, 0, 18)
subtitle.Position = UDim2.new(0,12,0,34)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Debug • For your own game"
subtitle.TextColor3 = Color3.fromRGB(160,160,160)
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -24, 0, 22)
status.Position = UDim2.new(0,12,0,54)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(220,220,220)
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local progressHolder = Instance.new("Frame")
progressHolder.Size = UDim2.new(1, -24, 0, 14)
progressHolder.Position = UDim2.new(0,12,0,82)
progressHolder.BackgroundColor3 = Color3.fromRGB(30,30,30)
progressHolder.Parent = main

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0,0,0,0)
progressBar.BackgroundColor3 = Color3.fromRGB(200,60,60)
progressBar.Parent = progressHolder

local btnStyle = function(btn)
    btn.BackgroundColor3 = Color3.fromRGB(22,22,22)
    btn.BorderSizePixel = 0
    local stroke = Instance.new("UIStroke")
    stroke.Parent = btn
    stroke.Color = Color3.fromRGB(140,20,20)
    stroke.Thickness = 1
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.TextSize = 14
end

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 150, 0, 36)
startBtn.Position = UDim2.new(0,12,0,110)
startBtn.Text = "Start Fishing"
startBtn.Parent = main
btnStyle(startBtn)

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0, 90, 0, 28)
autoBtn.Position = UDim2.new(0,174,0,114)
autoBtn.Text = "Auto: Off"
autoBtn.Parent = main
btnStyle(autoBtn)

local perfBtn = Instance.new("TextButton")
perfBtn.Size = UDim2.new(0, 90, 0, 28)
perfBtn.Position = UDim2.new(0,174,0,148)
perfBtn.Text = "Perfect: Off"
perfBtn.Parent = main
btnStyle(perfBtn)

local superBtn = Instance.new("TextButton")
superBtn.Size = UDim2.new(0, 90, 0, 28)
superBtn.Position = UDim2.new(0,286,0,114)
superBtn.Text = "Super: Off"
superBtn.Parent = main
btnStyle(superBtn)

local delayBtn = Instance.new("TextButton")
delayBtn.Size = UDim2.new(0, 90, 0, 28)
delayBtn.Position = UDim2.new(0,286,0,148)
delayBtn.Text = "Delay: Off"
delayBtn.Parent = main
btnStyle(delayBtn)

local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0, 180, 0, 28)
equipBtn.Position = UDim2.new(0,12,0,156)
equipBtn.Text = "Auto-Equip Radar: Off"
equipBtn.Parent = main
btnStyle(equipBtn)

local animBtn = Instance.new("TextButton")
animBtn.Size = UDim2.new(0, 120, 0, 28)
animBtn.Position = UDim2.new(0,200,0,182)
animBtn.Text = "Animation: On"
animBtn.Parent = main
btnStyle(animBtn)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 80, 0, 18)
speedLabel.Position = UDim2.new(0,200,0,156)
speedLabel.Text = "Speed: 1.0x"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(220,220,220)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 12
speedLabel.Parent = main

local speedInc = Instance.new("TextButton")
speedInc.Size = UDim2.new(0, 40, 0, 18)
speedInc.Position = UDim2.new(0,286,0,156)
speedInc.Text = "+0.5"
speedInc.Parent = main
btnStyle(speedInc)

local speedDec = Instance.new("TextButton")
speedDec.Size = UDim2.new(0, 40, 0, 18)
speedDec.Position = UDim2.new(0,330,0,156)
speedDec.Text = "-0.5"
speedDec.Parent = main
btnStyle(speedDec)

local isFishing = false
local startTick = 0
local biteTick = nil

local function setStatus(text)
    status.Text = text or ""
end

local function setProgress(p)
    p = math.clamp(p, 0, 1)
    progressBar.Size = UDim2.new(p, 0, 1, 0)
end

local function tryAutoEquipRadar()
    if not DEV.autoEquipRadar then return end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        local tool = backpack:FindFirstChild("FishingRadar")
        if tool and tool:IsA("Tool") then
            player.CharacterAdded:Wait()
            local character = player.Character
            if character and character.Parent then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                    setStatus("Radar auto-equipped.")
                end
            end
            return
        end
    end
    local sp = StarterPack:FindFirstChild("FishingRadar")
    if sp and sp:IsA("Tool") then
        local clone = sp:Clone()
        clone.Parent = player:FindFirstChild("Backpack") or player:WaitForChild("Backpack")
        setStatus("Radar added to Backpack and equipped.")
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(clone)
        end
    end
end

startBtn.MouseButton1Click:Connect(function()
    if isFishing then
        setStatus("Already fishing...")
        return
    end
    isFishing = true
    startTick = tick()
    setStatus("Casting...")
    setProgress(0)
    local req = { speed = DEV.speedMultiplier * (DEV.superFast > 0 and DEV.superFast or 1), delay = DEV.delayMode }
    StartRemote:FireServer(startTick, req)
    tryAutoEquipRadar()
end)

autoBtn.MouseButton1Click:Connect(function()
    DEV.autoFish = not DEV.autoFish
    autoBtn.Text = "Auto: " .. (DEV.autoFish and "On" or "Off")
end)

perfBtn.MouseButton1Click:Connect(function()
    DEV.autoPerfection = not DEV.autoPerfection
    perfBtn.Text = "Perfect: " .. (DEV.autoPerfection and "On" or "Off")
end)

superBtn.MouseButton1Click:Connect(function()
    if DEV.superFast == 0 then
        DEV.superFast = 8
    elseif DEV.superFast == 8 then
        DEV.superFast = 10
    else
        DEV.superFast = 0
    end
    superBtn.Text = (DEV.superFast == 0) and "Super: Off" or ("Super: " .. tostring(DEV.superFast) .. "x")
    speedLabel.Text = "Speed: " .. tostring(DEV.speedMultiplier * (DEV.superFast > 0 and DEV.superFast or 1)) .. "x"
end)

delayBtn.MouseButton1Click:Connect(function()
    if DEV.delayMode == 1.0 then
        DEV.delayMode = 2.0
        delayBtn.Text = "Delay: 2x"
    else
        DEV.delayMode = 1.0
        delayBtn.Text = "Delay: Off"
    end
end)

equipBtn.MouseButton1Click:Connect(function()
    DEV.autoEquipRadar = not DEV.autoEquipRadar
    equipBtn.Text = "Auto-Equip Radar: " .. (DEV.autoEquipRadar and "On" or "Off")
    if DEV.autoEquipRadar then tryAutoEquipRadar() end
end)

animBtn.MouseButton1Click:Connect(function()
    DEV.animationEnabled = not DEV.animationEnabled
    animBtn.Text = "Animation: " .. (DEV.animationEnabled and "On" or "Off")
end)

speedInc.MouseButton1Click:Connect(function()
    DEV.speedMultiplier = math.floor((DEV.speedMultiplier + 0.5) * 10) / 10
    speedLabel.Text = "Speed: " .. tostring(DEV.speedMultiplier * (DEV.superFast > 0 and DEV.superFast or 1)) .. "x"
end)

speedDec.MouseButton1Click:Connect(function()
    DEV.speedMultiplier = math.max(0.1, math.floor((DEV.speedMultiplier - 0.5) * 10) / 10)
    speedLabel.Text = "Speed: " .. tostring(DEV.speedMultiplier * (DEV.superFast > 0 and DEV.superFast or 1)) .. "x"
end)

NotifyRemote.OnClientEvent:Connect(function(payload)
    if not payload or not payload.event then return end
    if payload.event == "Started" then
        setStatus("Waiting for bite...")
        local target = (payload.when or tick())
        spawn(function()
            while isFishing and tick() < target do
                local total = math.max(0.01, (target - startTick))
                local elapsed = tick() - startTick
                setProgress(elapsed / total)
                wait(0.03)
            end
        end)
    elseif payload.event == "Bite" then
        biteTick = payload.serverTime or tick()
        if DEV.animationEnabled then
            setStatus("Fish is biting! Press E or 'Start Fishing' to reel.")
        else
            setStatus("Fish is biting! (animation off)")
        end
        setProgress(1)
        if DEV.instantCatch then
            ReelRemote:FireServer(0)
        elseif DEV.autoPerfection then
            local perfect = 3.0 / math.max(DEV.speedMultiplier * (DEV.superFast > 0 and DEV.superFast or 1), 0.01)
            delay(perfect, function()
                if isFishing then
                    local elapsed = tick() - startTick
                    ReelRemote:FireServer(elapsed)
                end
            end)
        elseif DEV.autoFish then
            local elapsed = 3.0 / math.max(DEV.speedMultiplier * (DEV.superFast > 0 and DEV.superFast or 1), 0.01)
            ReelRemote:FireServer(elapsed)
        end
    elseif payload.event == "Result" then
        local res = payload.result or {}
        setStatus("Result: " .. (res.quality or "Unknown") .. " +" .. tostring(res.reward or 0))
        isFishing = false
        biteTick = nil
        wait(2)
        setStatus("Ready")
        setProgress(0)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E and isFishing then
        local elapsed = tick() - startTick
        ReelRemote:FireServer(elapsed)
    end
end)

spawn(function()
    while true do
        if DEV.autoFish and not isFishing then
            startBtn:Activate()
        end
        wait(0.6)
    end
end)

print("FishingClient v3 loaded (Elegant UI).")
