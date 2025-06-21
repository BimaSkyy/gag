-- AUTO BUY GROW A GARDEN (BY CHATGPT)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local BuyRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("BuyItem")

-- LIST STOK YANG AKAN DIBELI
local config = {
    Seeds = true,
    Sprinkler_Basic = true,
    Sprinkler_Advance = true,
    Sprinkler_Godly = true,
    Sprinkler_Master = true,
}

-- CEK DAN BELI STOK YANG ADA
local function autoBuy()
    for _, folder in pairs(ReplicatedStorage:WaitForChild("StockFolder"):GetChildren()) do
        for _, item in pairs(folder:GetChildren()) do
            local itemName = item.Name
            local stock = item:FindFirstChild("Stock") and item.Stock.Value or 0

            if stock > 0 and config[itemName] then
                print("[AUTO BUY] Membeli:", itemName, "jumlah:", stock)
                BuyRemote:FireServer(itemName, stock)
            end
        end
    end
end

-- PERIKSA SETIAP 5 DETIK
while true do
    pcall(autoBuy)
    task.wait(5)
end
