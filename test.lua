local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockFolder = ReplicatedStorage:WaitForChild("StockFolder")

local function notify(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

local count = 0
for _, category in ipairs(StockFolder:GetChildren()) do
    for _, item in ipairs(category:GetChildren()) do
        local stock = item:FindFirstChild("Stock")
        if stock then
            count += 1
            task.delay(count * 0.5, function()
                notify("[STOK] " .. item.Name, "Jumlah: " .. stock.Value)
            end)
        end
    end
end

notify("Cek Stok", "Menampilkan semua stok item...")
