local supportedGames = {}
local scriptID = {}
if premium then
    supportedGames = {
        [7436755782] = "https://api.luarmor.net/files/v4/loaders/483d639ad74a7814ff1057d68cec56c2.lua", -- Grow a Garden
        [7018190066] = "https://api.luarmor.net/files/v4/loaders/d3a76114c1ea182127b88170b6043d11.lua", -- Dead Rails
        [5750914919] = "https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/fisch.lua", -- Fisch
        [6325068386] = "https://api.luarmor.net/files/v4/loaders/a0ad31cf58a8bd98dd82fa1fb648290f.lua", -- BLR
        [4777817887] = "https://api.luarmor.net/files/v4/loaders/d53370331c9ca16ce3479c3ac6ae5a78.lua", -- Bladeball
        [7095682825] = "https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/beaks.lua", -- Beaks
        [994732206] = "https://api.luarmor.net/files/v4/loaders/446a745866c1abf8459657502b7818fc.lua" -- Blox Fruit
    }
    scriptID = {
        [7436755782] = "483d639ad74a7814ff1057d68cec56c2", -- Grow a Garden
        [7018190066] = "d3a76114c1ea182127b88170b6043d11", -- Dead Rails
        [6325068386] = "a0ad31cf58a8bd98dd82fa1fb648290f", -- BLR
        [4777817887] = "d53370331c9ca16ce3479c3ac6ae5a78", -- BB
        [994732206] = "446a745866c1abf8459657502b7818fc"
    }
else
    supportedGames = {
        [7436755782] = "https://api.luarmor.net/files/v4/loaders/65c66a87b33565a9dea1a54b798b6b2a.lua", -- Grow a Garden
        [7018190066] = "https://api.luarmor.net/files/v4/loaders/a3e99a8c1a465fc973e7aa0dda0e220c.lua", -- Dead Rails
        [5750914919] = "https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/fisch.lua", -- Fisch
        [6325068386] = "https://api.luarmor.net/files/v4/loaders/50ba70185011d66f3ed97e4e7f50bd11.lua", -- BLR
        [4777817887] = "https://api.luarmor.net/files/v4/loaders/6f48a7a95292a0885256d242900d81fb.lua", -- Bladeball
        [7095682825] = "https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/beaks.lua", -- Beaks
        [994732206] = "https://api.luarmor.net/files/v4/loaders/1ba7f8bc6888d119d65cdafbe3d78527.lua" -- Blox Fruit
    }
    scriptID = {
        --[7436755782] = "65c66a87b33565a9dea1a54b798b6b2a", -- Grow a Garden
        [7018190066] = "a3e99a8c1a465fc973e7aa0dda0e220c", -- Dead Rails
        [6325068386] = "50ba70185011d66f3ed97e4e7f50bd11", -- BLR
        [4777817887] = "6f48a7a95292a0885256d242900d81fb", -- BB
        [994732206] = "1ba7f8bc6888d119d65cdafbe3d78527"
    }
end
local gameNames = {
    [5750914919] = "Fisch", -- Fisch
    [7018190066] = "Dead Rails", -- Dead Rails
    [6325068386] = "Blue Lock Rivals", -- BLR
    [4777817887] = "Blade Ball", -- Blade Ball
    [7436755782] = "GaG", -- GaG
    [7095682825] = "Beaks", -- Beaks
    [994732206] = "Blox Fruit"
}
local gameId = game.GameId
if supportedGames[gameId] then
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "BmSky!",
            Text = gameNames[gameId] .. " Script Loaded!",
            Icon = "rbxassetid://99764942615873",
            Duration = 5
        }
    )
    if scriptID[gameId] then
        local auth_url =
            game:HttpGet("https://raw.githubusercontent.com/BimaSkyy/gag/refs/heads/main/key.lua")
        local auth = loadstring(auth_url)()
        local auth_status = auth(scriptID[gameId])
        repeat
            task.wait()
        until auth_status.validated
    end
    local game_url = game:HttpGet(supportedGames[gameId])
    loadstring(game_url)()
else
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title = "BmSky Error!",
            Text = "You Execute Non Supported Game",
            Icon = "rbxassetid://99764942615873",
            Duration = 5
        }
    )
end
