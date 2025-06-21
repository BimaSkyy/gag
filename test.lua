local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockFolder = ReplicatedStorage:WaitForChild("StockFolder")

local function notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Stok Item",
        Text = text,
        Duration = 4
    })
end

for _, category in ipairs(StockFolder:GetChildren()) do
    for _, item in ipairs(category:GetChildren()) do
        local stock = item:FindFirstChild("Stock")
        if stock then
            notify(item.Name .. ": " .. stock.Value)
            wait(0.5)
        end
    end
end
