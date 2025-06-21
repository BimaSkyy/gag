local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Simpan state
local autoRunning = false
local selectedItems = {}  -- contoh: {["Apple Seed"] = true, ["Sprinkler Godly"] = true}

-- GUI Buat Checklist dan Start/Stop
local function createUI()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "AutoBuyerGUI"

    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0, 10, 0, 100)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local startButton = Instance.new("TextButton", frame)
    startButton.Size = UDim2.new(0, 280, 0, 40)
    startButton.Position = UDim2.new(0, 10, 0, 10)
    startButton.Text = "START"
    startButton.TextColor3 = Color3.new(1,1,1)
    startButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)

    -- List item akan ditambahkan di sini
    local itemList = {}

    -- fungsi toggle
    startButton.MouseButton1Click:Connect(function()
        autoRunning = not autoRunning
        startButton.Text = autoRunning and "STOP" or "START"
    end)

    return {
        gui = gui,
        addItem = function(itemName)
            if itemList[itemName] then return end
            local cb = Instance.new("TextButton", frame)
            cb.Size = UDim2.new(0, 280, 0, 25)
            cb.Position = UDim2.new(0, 10, 0, 50 + (#itemList * 30))
            cb.Text = "[ ] " .. itemName
            cb.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            cb.TextColor3 = Color3.new(1, 1, 1)

            local active = false
            cb.MouseButton1Click:Connect(function()
                active = not active
                cb.Text = (active and "[✔] " or "[ ] ") .. itemName
                selectedItems[itemName] = active
            end)

            itemList[itemName] = cb
        end
    }
end

-- Gerakkan player ke lokasi beli (simulasi)
local function goTo(pos)
    local hrp = Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(pos)
end

-- Fungsi pembelian
local function buyItem(itemName)
    print("Membeli:", itemName)
    -- Tambahkan call server remote beli di sini (biasanya FireServer)
    -- Contoh:
    -- game:GetService("ReplicatedStorage").RemoteEvents.BuyItem:FireServer(itemName)
end

-- Deteksi stok dan beli otomatis
local function watchStock(ui)
    local stockFolder = workspace:WaitForChild("Stock", 10)
    if not stockFolder then warn("Stock folder tidak ditemukan!") return end

    stockFolder.ChildAdded:Connect(function(child)
        task.wait(0.5)
        local name = child.Name

        -- Tambahkan ke GUI kalau item baru
        ui.addItem(name)

        if autoRunning and selectedItems[name] then
            if name:lower():find("seed") then
                goTo(Vector3.new(10, 0, 10)) -- posisi toko Seed
            elseif name:lower():find("sprinkler") then
                goTo(Vector3.new(50, 0, 50)) -- posisi toko Gear
            end

            task.wait(1.5)
            buyItem(name)
        end
    end)
end
