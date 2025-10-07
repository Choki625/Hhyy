-- shoutout discord.gg/nilhub
local CollectionService = game:GetService("CollectionService")
local Remote = game:GetService("ReplicatedStorage").packages.Net["RE/SpearFishing/Minigame"]
local Player = game.Players.LocalPlayer

-- Teleport ke lokasi target
Player.Character.HumanoidRootPart.CFrame = CFrame.new(-2585, 144, -1942)

-- Fungsi untuk membuat delay acak antara 5–10 detik
local function randomDelay()
	return math.random(5, 10)
end

while task.wait(randomDelay()) do
	for _, v in next, CollectionService:GetTagged("SpearfishingZone") do
		local Zone = v.ZoneFish
		for _, Fish in next, Zone:GetChildren() do
			task.spawn(function()
				Remote:FireServer(Fish:GetAttribute("UID"))
				task.wait(0.5) -- delay kecil antara dua tembakan
				Remote:FireServer(Fish:GetAttribute("UID"), true)
			end)
			task.wait(randomDelay()) -- delay acak antar ikan
		end
	end
end
