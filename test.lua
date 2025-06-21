-- ✅ FINAL AUTO-BUY SCRIPT FOR GROW A GARDEN (WITH GUI)
-- WORKS ON DELTA EXECUTOR VIA loadstring()
-- Creator: ChatGPT for BimaSkyy

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [CONFIGURABLE REMOTE] (Ganti sesuai game jika berbeda)
local BuyRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("BuyItem")
local StockFolder = ReplicatedStorage:WaitForChild("StockFolder")

-- [STATE]
local autoBuyEnabled = false
local selectedItems = {} -- dictionary: ["itemName"] = true/false

-- [CREATE GUI]
local function createAutoBuyGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "GrowAutoBuyGUI"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0, 10, 0.5, -150)
    frame.Size = UDim2.new(0, 280, 0, 300)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", frame)
    title.Text = "Grow Auto Buyer"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Position = UDim2.new(0, 10, 0, 40)
    scroll.Size = UDim2.new(1, -20, 1, -80)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4

    local toggle = Instance.new("TextButton", frame)
    toggle.Position = UDim2.new(0, 10, 1, -35)
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Text = "[ START AUTO BUY ]"
    toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14

    toggle.MouseButton1Click:Connect(function()
        autoBuyEnabled = not autoBuyEnabled
        toggle.Text = autoBuyEnabled and "[ STOP AUTO BUY ]" or "[ START AUTO BUY ]"
        toggle.BackgroundColor3 = autoBuyEnabled and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
    end)

    local function addCheckbox(itemName)
        if scroll:FindFirstChild(itemName) then return end
        local cb = Instance.new("TextButton", scroll)
        cb.Name = itemName
        cb.Size = UDim2.new(1, -4, 0, 25)
        cb.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        cb.TextColor3 = Color3.new(1, 1, 1)
        cb.Text = "[ ] " .. itemName
        cb.Font = Enum.Font.Gotham
        cb.TextSize = 14

        local active = false
        cb.MouseButton1Click:Connect(function()
            active = not active
            cb.Text = (active and "[✔] " or "[ ] ") .. itemName
            selectedItems[itemName] = active
        end)
    end

    return addCheckbox
end

-- [AUTOBUY LOOP]
local function autoBuyLoop()
    while true do
        if autoBuyEnabled then
            for _, category in ipairs(StockFolder:GetChildren()) do
                for _, item in ipairs(category:GetChildren()) do
                    local stock = item:FindFirstChild("Stock")
                    if stock and stock.Value > 0 and selectedItems[item.Name] then
                        BuyRemote:FireServer(item.Name, stock.Value)
                        print("[AUTO BUY] ", item.Name, stock.Value)
                    end
                end
            end
        end
        wait(3)
    end
end

-- [INIT]
local addCheckbox = createAutoBuyGUI()

-- Deteksi semua item yang tersedia & tampilkan checkbox-nya
for _, category in ipairs(StockFolder:GetChildren()) do
    for _, item in ipairs(category:GetChildren()) do
        addCheckbox(item.Name)
    end
end

-- Jalankan loop utama
spawn(autoBuyLoop)

print("[✅ AUTO BUY SCRIPT LOADED]")
