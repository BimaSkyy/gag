-- Grow a Garden Auto-Buy UI with Bulk Purchase
-- Author: AkunMl + ChatGPT

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer

-- Load Dear ReGui
local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()
local PrefabsId = "rbxassetid://" .. ReGui.PrefabsId
ReGui:Init({
	Prefabs = InsertService:LoadLocalAsset(PrefabsId)
})

-- Tema
ReGui:DefineTheme("BuyTheme", {
	WindowBg = Color3.fromRGB(25, 25, 25),
	TitleBarBg = Color3.fromRGB(34, 139, 34),
	TitleBarBgActive = Color3.fromRGB(60, 179, 113),
	ResizeGrab = Color3.fromRGB(34, 139, 34),
	FrameBg = Color3.fromRGB(34, 139, 34),
	CollapsingHeaderBg = Color3.fromRGB(46, 204, 113),
	ButtonsBg = Color3.fromRGB(46, 204, 113),
	CheckMark = Color3.fromRGB(255, 255, 255),
	SliderGrab = Color3.fromRGB(255, 255, 255)
})

-- Remote
local BuySeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

-- Storage
local SelectedSeeds = {}
local AutoBuy = false
local BuyAll = false

-- UI Window
local Window = ReGui:Window({
	Title = "Auto Buy Seeds 🌱",
	Theme = "BuyTheme",
	Size = UDim2.fromOffset(250, 200),
	Collapsible = true
})

-- Checkbox seed list
local function GetSeedStockList()
	local ShopUI = PlayerGui:FindFirstChild("Seed_Shop")
	if not ShopUI then return {} end

	local Root = ShopUI:FindFirstChild("Blueberry", true)
	if not Root then return {} end

	local stockList = {}
	for _, item in pairs(Root.Parent:GetChildren()) do
		local Main = item:FindFirstChild("Main_Frame")
		if Main and Main:FindFirstChild("Stock_Text") then
			local stock = tonumber(Main.Stock_Text.Text:match("%d+")) or 0
			stockList[item.Name] = stock
		end
	end
	return stockList
end

-- Buy seed immediately
local function BuyAllSeeds()
	local seeds = GetSeedStockList()
	for name, count in pairs(seeds) do
		if count > 0 then
			for i = 1, count do
				BuySeedRemote:FireServer(name)
			end
		end
	end
end

-- Buy selected only
local function BuySelectedSeeds()
	local seeds = GetSeedStockList()
	for name, count in pairs(seeds) do
		if count > 0 and SelectedSeeds[name] then
			for i = 1, count do
				BuySeedRemote:FireServer(name)
			end
		end
	end
end

-- UI Build
Window:Checkbox({
	Label = "Buy All Seeds",
	Value = BuyAll,
	Callback = function(_, value)
		BuyAll = value
	end
})

Window:Checkbox({
	Label = "Auto Buy Enabled",
	Value = AutoBuy,
	Callback = function(_, value)
		AutoBuy = value
	end
})

Window:Separator({Text = "Choose Seeds"})

-- Dynamic seed list
task.spawn(function()
	while true do
		if Window.Visible then
			local stockList = GetSeedStockList()
			for name in pairs(stockList) do
				if SelectedSeeds[name] == nil then
					SelectedSeeds[name] = false
					Window:Checkbox({
						Label = name,
						Value = false,
						Callback = function(_, v)
							SelectedSeeds[name] = v
						end
					})
				end
			end
		end
		task.wait(3)
	end
end)

-- Auto-buy loop
task.spawn(function()
	while true do
		if AutoBuy then
			if BuyAll then
				BuyAllSeeds()
			else
				BuySelectedSeeds()
			end
		end
		task.wait(3)
	end
end)
