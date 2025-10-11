--[[
🎣 Fish It Logger by ChafidhChoki
Versi: 4.0 (Pilih Mode Kirim + Discord + Telegram)

✨ Fitur:
- Pilihan mode kirim (Discord / Telegram / Kedua-duanya)
- Embed Discord profesional dan elegan
- Pesan Telegram rapi (Markdown)
- Menu GUI untuk konfigurasi
--]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Variabel global konfigurasi
getgenv().WebhookURL = nil
getgenv().TelegramToken = nil
getgenv().TelegramChatID = nil
getgenv().SendMode = "BOTH" -- Pilihan: "DISCORD", "TELEGRAM", "BOTH"

-- Fungsi notifikasi di layar
local function Notify(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title;
			Text = text;
			Duration = duration or 4;
		})
	end)
end

-- Fungsi kirim ke Discord
local function SendDiscordEmbed(fishName, rarity, size, value)
	if not getgenv().WebhookURL then return end

	local rarityColors = {
		Common = 0x95A5A6,
		Uncommon = 0x2ECC71,
		Rare = 0x3498DB,
		Epic = 0x9B59B6,
		Legendary = 0xF1C40F,
		Mythic = 0xE67E22
	}

	local embed = {
		embeds = {{
			["title"] = string.format("🎣 %s Menangkap Ikan!", player.Name),
			["description"] = string.format(
				"**🐟 Nama Ikan:** %s\n**🌈 Rarity:** %s\n**📏 Ukuran:** %.2f cm\n**💰 Nilai:** %s coins",
				fishName, rarity, size, tostring(value)
			),
			["color"] = rarityColors[rarity] or 0xFFFFFF,
			["fields"] = {
				{
					["name"] = "🕒 Waktu",
					["value"] = os.date("%Y-%m-%d %H:%M:%S"),
					["inline"] = false
				}
			},
			["footer"] = { ["text"] = "Fish It Logger by ChafidhChoki" },
			["timestamp"] = DateTime.now():ToIsoDate()
		}}
	}

	pcall(function()
		syn.request({
			Url = getgenv().WebhookURL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(embed)
		})
	end)
end

-- Fungsi kirim ke Telegram
local function SendTelegramMessage(fishName, rarity, size, value)
	if not (getgenv().TelegramToken and getgenv().TelegramChatID) then return end

	local message = string.format(
		"🎣 *%s menangkap ikan!*\n\n🐟 *Nama:* %s\n🌈 *Rarity:* %s\n📏 *Ukuran:* %.2f cm\n💰 *Nilai:* %s coins\n🕒 *Waktu:* %s\n\n_Fish It Logger by ChafidhChoki_",
		player.Name, fishName, rarity, size, tostring(value), os.date("%Y-%m-%d %H:%M:%S")
	)

	local url = string.format("https://api.telegram.org/bot%s/sendMessage", getgenv().TelegramToken)
	local data = {
		chat_id = getgenv().TelegramChatID,
		text = message,
		parse_mode = "Markdown"
	}

	pcall(function()
		syn.request({
			Url = url,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(data)
		})
	end)
end

-- Fungsi utama kirim log
local function LogCatch(fishName, rarity, size, value)
	local mode = string.upper(getgenv().SendMode)

	if mode == "DISCORD" then
		SendDiscordEmbed(fishName, rarity, size, value)
		Notify("📤 Discord", "Terkirim ke Discord!", 3)

	elseif mode == "TELEGRAM" then
		SendTelegramMessage(fishName, rarity, size, value)
		Notify("📤 Telegram", "Terkirim ke Telegram!", 3)

	elseif mode == "BOTH" then
		SendDiscordEmbed(fishName, rarity, size, value)
		SendTelegramMessage(fishName, rarity, size, value)
		Notify("📤 Discord + Telegram", "Terkirim ke kedua platform!", 3)

	else
		Notify("❌ Error", "Mode pengiriman tidak valid!", 3)
	end
end

-- GUI untuk pengaturan Webhook & Mode Kirim
local function OpenSettingsMenu()
	local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
	local Frame = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local DiscordBox = Instance.new("TextBox")
	local TelegramTokenBox = Instance.new("TextBox")
	local TelegramChatBox = Instance.new("TextBox")
	local ModeLabel = Instance.new("TextLabel")
	local ModeDropdown = Instance.new("TextButton")
	local Save = Instance.new("TextButton")

	ScreenGui.Name = "FishItSettings"
	ScreenGui.ResetOnSpawn = false

	Frame.Parent = ScreenGui
	Frame.Size = UDim2.new(0, 360, 0, 320)
	Frame.Position = UDim2.new(0.5, -180, 0.5, -160)
	Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Frame.Active = true
	Frame.Draggable = true

	Title.Parent = Frame
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.Text = "⚙️ Fish It Logger Settings"
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 18

	DiscordBox.Parent = Frame
	DiscordBox.PlaceholderText = "Discord Webhook URL"
	DiscordBox.Size = UDim2.new(1, -20, 0, 30)
	DiscordBox.Position = UDim2.new(0, 10, 0, 50)
	DiscordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	DiscordBox.TextColor3 = Color3.new(1, 1, 1)
	DiscordBox.Text = getgenv().WebhookURL or ""

	TelegramTokenBox.Parent = Frame
	TelegramTokenBox.PlaceholderText = "Telegram Bot Token"
	TelegramTokenBox.Size = UDim2.new(1, -20, 0, 30)
	TelegramTokenBox.Position = UDim2.new(0, 10, 0, 100)
	TelegramTokenBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TelegramTokenBox.TextColor3 = Color3.new(1, 1, 1)
	TelegramTokenBox.Text = getgenv().TelegramToken or ""

	TelegramChatBox.Parent = Frame
	TelegramChatBox.PlaceholderText = "Telegram Chat ID"
	TelegramChatBox.Size = UDim2.new(1, -20, 0, 30)
	TelegramChatBox.Position = UDim2.new(0, 10, 0, 150)
	TelegramChatBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TelegramChatBox.TextColor3 = Color3.new(1, 1, 1)
	TelegramChatBox.Text = getgenv().TelegramChatID or ""

	ModeLabel.Parent = Frame
	ModeLabel.Text = "🧭 Mode Kirim:"
	ModeLabel.Position = UDim2.new(0, 10, 0, 200)
	ModeLabel.Size = UDim2.new(0, 120, 0, 25)
	ModeLabel.BackgroundTransparency = 1
	ModeLabel.TextColor3 = Color3.new(1, 1, 1)
	ModeLabel.TextSize = 16
	ModeLabel.Font = Enum.Font.SourceSansBold

	ModeDropdown.Parent = Frame
	ModeDropdown.Size = UDim2.new(0, 150, 0, 30)
	ModeDropdown.Position = UDim2.new(0, 140, 0, 198)
	ModeDropdown.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	ModeDropdown.TextColor3 = Color3.new(1, 1, 1)
	ModeDropdown.TextSize = 16
	ModeDropdown.Font = Enum.Font.SourceSansBold
	ModeDropdown.Text = getgenv().SendMode

	-- Klik untuk ubah mode
	local modes = {"DISCORD", "TELEGRAM", "BOTH"}
	local currentIndex = table.find(modes, getgenv().SendMode) or 3
	ModeDropdown.MouseButton1Click:Connect(function()
		currentIndex = currentIndex + 1
		if currentIndex > #modes then currentIndex = 1 end
		getgenv().SendMode = modes[currentIndex]
		ModeDropdown.Text = modes[currentIndex]
	end)

	Save.Parent = Frame
	Save.Text = "💾 Simpan"
	Save.Size = UDim2.new(0.5, 0, 0, 40)
	Save.Position = UDim2.new(0.25, 0, 0, 250)
	Save.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	Save.TextColor3 = Color3.new(1, 1, 1)
	Save.Font = Enum.Font.SourceSansBold
	Save.TextSize = 16

	Save.MouseButton1Click:Connect(function()
		getgenv().WebhookURL = DiscordBox.Text ~= "" and DiscordBox.Text or nil
		getgenv().TelegramToken = TelegramTokenBox.Text ~= "" and TelegramTokenBox.Text or nil
		getgenv().TelegramChatID = TelegramChatBox.Text ~= "" and TelegramChatBox.Text or nil
		Notify("✅ Disimpan", "Konfigurasi berhasil disimpan!", 4)
		ScreenGui:Destroy()
	end)
end

-- Tombol utama GUI
local MainGUI = Instance.new("ScreenGui", game.CoreGui)
local Button = Instance.new("TextButton")
Button.Parent = MainGUI
Button.Size = UDim2.new(0, 160, 0, 40)
Button.Position = UDim2.new(0, 20, 0.8, 0)
Button.Text = "⚙️ Webhook Settings"
Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 16
Button.Active = true
Button.Draggable = true
Button.MouseButton1Click:Connect(OpenSettingsMenu)

-- 🔧 Contoh tes manual:
-- LogCatch("Golden Tuna", "Legendary", 65.4, 4200)
