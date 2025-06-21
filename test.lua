local ReplicatedStorage = game:GetService("ReplicatedStorage")
local seedRemote = ReplicatedStorage:FindFirstChild("Give_Seed")
local gearRemote = ReplicatedStorage:FindFirstChild("Give_Gear")

if seedRemote then
    seedRemote:FireServer("AppleSeed", 1)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Coba Beli",
        Text = "Coba beli AppleSeed via Give_Seed",
        Duration = 5
    })
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Gagal",
        Text = "Remote Give_Seed tidak ditemukan!",
        Duration = 5
    })
end

wait(3)

if gearRemote then
    gearRemote:FireServer("SprinklerBasic", 1)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Coba Beli",
        Text = "Coba beli SprinklerBasic via Give_Gear",
        Duration = 5
    })
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Gagal",
        Text = "Remote Give_Gear tidak ditemukan!",
        Duration = 5
    })
end
