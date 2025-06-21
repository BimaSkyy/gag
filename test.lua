local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StockFolder = ReplicatedStorage:WaitForChild("StockFolder")

for _, category in ipairs(StockFolder:GetChildren()) do
    for _, item in ipairs(category:GetChildren()) do
        local stock = item:FindFirstChild("Stock")
        if stock then
            print("[STOK] " .. item.Name .. ": " .. stock.Value)
        end
    end
end

game.StarterGui:SetCore("SendNotification", {
    Title = "Cek Stok";
    Text = "Stok berhasil ditampilkan di console (F9)";
    Duration = 5;
})
