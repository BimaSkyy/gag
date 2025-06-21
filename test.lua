-- Grow A Garden Auto Buy Script with ImGui by ChatGPT (v2)
-- Feature: Buy all seed or specific, elegant UI, gear support, log display

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local BuySeedRemote = ReplicatedStorage.GameEvents:WaitForChild("BuySeedStock")
local BuyGearRemote = ReplicatedStorage.GameEvents:WaitForChild("BuyGearStock")

local ImGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua"))()
local PrefabId = "rbxassetid://17033442463"
ImGui:Init({ Prefabs = game:GetObjects(PrefabId)[1] })

local Window = ImGui:Window({ Title = "Auto Buyer", Size = UDim2.fromOffset(250, 160) })
local ShowSeedList = false
local ShowGearList = false

local BuyAllSeed = false
local BuySpecificSeed = false
local BuyAllGear = false
local BuySpecificGear = false
local SeedCheckboxes = {}
local GearCheckboxes = {}
local AutoBuyRunning = false
local LogMessages = {}

function NotifyLog(text)
    table.insert(LogMessages, 1, text)
    if #LogMessages > 10 then table.remove(LogMessages, #LogMessages) end
end

function GetStockList(category)
    local Shop = PlayerGui:FindFirstChild(category)
    if not Shop then return {} end
    local Ref = Shop:FindFirstChild("Blueberry", true) or Shop:FindFirstChild("Basic_Sprinkler", true)
    if not Ref then return {} end

    local stockList = {}
    for _, item in pairs(Ref.Parent:GetChildren()) do
        local Main = item:FindFirstChild("Main_Frame")
        if Main and Main:FindFirstChild("Stock_Text") then
            local count = tonumber(Main.Stock_Text.Text:match("%d+")) or 0
            stockList[item.Name] = count
        end
    end
    return stockList
end

function BuyAllItems(category, remote)
    local stockList = GetStockList(category)
    for name, count in pairs(stockList) do
        if count > 0 then
            for _ = 1, count do
                remote:FireServer(name)
            end
            NotifyLog("Bought ALL of " .. name)
        end
    end
end

function BuySpecific(category, remote, checks)
    local stockList = GetStockList(category)
    for name, count in pairs(stockList) do
        if checks[name] and count > 0 then
            for _ = 1, count do
                remote:FireServer(name)
            end
            NotifyLog("Bought specific: " .. name)
        end
    end
end

function StartLoop()
    if AutoBuyRunning then return end
    AutoBuyRunning = true
    coroutine.wrap(function()
        while AutoBuyRunning do
            if BuyAllSeed then BuyAllItems("Seed_Shop", BuySeedRemote) end
            if BuySpecificSeed then BuySpecific("Seed_Shop", BuySeedRemote, SeedCheckboxes) end
            if BuyAllGear then BuyAllItems("Gear_Shop", BuyGearRemote) end
            if BuySpecificGear then BuySpecific("Gear_Shop", BuyGearRemote, GearCheckboxes) end
            wait(2.5)
        end
    end)()
end

function StopLoop()
    AutoBuyRunning = false
end

-- UI Controls
Window:Checkbox({ Label = "Beli semua seed", Value = BuyAllSeed, Callback = function(_, v)
    BuyAllSeed = v
    if v then BuySpecificSeed = false end
    if v or BuySpecificSeed or BuyAllGear or BuySpecificGear then StartLoop() else StopLoop() end
end })

Window:Checkbox({ Label = "Beli seed spesifik", Value = BuySpecificSeed, Callback = function(_, v)
    BuySpecificSeed = v
    if v then BuyAllSeed = false end
    if v or BuyAllSeed or BuyAllGear or BuySpecificGear then StartLoop() else StopLoop() end
end })

Window:Button({ Text = "List seed", Callback = function()
    ShowSeedList = not ShowSeedList
end })

Window:Separator({ Text = "Gear" })

Window:Checkbox({ Label = "Beli semua gear", Value = BuyAllGear, Callback = function(_, v)
    BuyAllGear = v
    if v then BuySpecificGear = false end
    if v or BuySpecificGear or BuyAllSeed or BuySpecificSeed then StartLoop() else StopLoop() end
end })

Window:Checkbox({ Label = "Beli gear spesifik", Value = BuySpecificGear, Callback = function(_, v)
    BuySpecificGear = v
    if v then BuyAllGear = false end
    if v or BuyAllGear or BuyAllSeed or BuySpecificSeed then StartLoop() else StopLoop() end
end })

Window:Button({ Text = "List gear", Callback = function()
    ShowGearList = not ShowGearList
end })

Window:Separator({ Text = "Log" })
Window:List({ Items = LogMessages })

-- Seed List UI
coroutine.wrap(function()
    while RunService.RenderStepped:Wait() do
        if ShowSeedList then
            local list = ImGui:Window({ Title = "Pilih Seed", Size = UDim2.fromOffset(250, 300) })
            local seeds = GetStockList("Seed_Shop")
            for name in pairs(seeds) do
                SeedCheckboxes[name] = SeedCheckboxes[name] or false
                list:Checkbox({ Label = name, Value = SeedCheckboxes[name], Callback = function(_, v)
                    SeedCheckboxes[name] = v
                end })
            end
            list:Button({ Text = "Tutup", Callback = function()
                ShowSeedList = false
            end })
        end
    end
end)()

-- Gear List UI
coroutine.wrap(function()
    while RunService.RenderStepped:Wait() do
        if ShowGearList then
            local list = ImGui:Window({ Title = "Pilih Gear", Size = UDim2.fromOffset(250, 300) })
            local gears = GetStockList("Gear_Shop")
            for name in pairs(gears) do
                GearCheckboxes[name] = GearCheckboxes[name] or false
                list:Checkbox({ Label = name, Value = GearCheckboxes[name], Callback = function(_, v)
                    GearCheckboxes[name] = v
                end })
            end
            list:Button({ Text = "Tutup", Callback = function()
                ShowGearList = false
            end })
        end
    end
end)()
