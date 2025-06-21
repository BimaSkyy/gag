return function(script_id)
    if not script_id then return end

    local function saveKey(key)
        if writefile and makefolder then
            makefolder("NatHub")
            writefile("NatHub/key.txt", key)
        end
    end

    local function loadKey()
        if readfile and isfile and isfile("NatHub/key.txt") then
            return readfile("NatHub/key.txt")
        end
        return nil
    end

    local api_url = game:HttpGet("https://raw.githubusercontent.com/BimaSkyy/gag/refs/heads/main/lib.lua")
    local api = loadstring(api_url)()
    local self = { validated = false }
    api.script_id = script_id
    local LocalPlayer = game:GetService("Players").LocalPlayer

    local function check_key(key)
        script_key = key
        local status = api.check_key(script_key)
        if (status.code == "KEY_VALID") then
            self.validated = true
            return true
        else
            LocalPlayer:Kick("[" .. status.code .. "]" .. "\n" .. status.message)
            return
        end
    end

    local savedKey = loadKey()
    if savedKey then
        script_key = savedKey
        local status = api.check_key(script_key)
        if status.code == "KEY_VALID" then
            game.StarterGui:SetCore("SendNotification",{
                Title = "Saved Key",
                Text = "Saved key valid!",
                Duration = 5
            })
            self.validated = true
            return self
        end
    end

    local gui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local textbox = Instance.new("TextBox")
    local button = Instance.new("TextButton")

    gui.Name = "SimpleKeyUI"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    frame.Parent = gui
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    textbox.Parent = frame
    textbox.Size = UDim2.new(0, 280, 0, 30)
    textbox.Position = UDim2.new(0, 10, 0, 10)
    textbox.PlaceholderText = "Enter Key..."
    textbox.TextColor3 = Color3.new(1, 1, 1)
    textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textbox.Text = ""

    button.Parent = frame
    button.Size = UDim2.new(0, 280, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 50)
    button.Text = "Check Key"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

    textbox:GetPropertyChangedSignal("Text"):Connect(function()
        script_key = textbox.Text
    end)

    button.MouseButton1Click:Connect(function()
        if script_key == "" then return end
        local result = check_key(script_key)
        if result then
            frame:Destroy()
            gui:Destroy()
            saveKey(script_key)
        end
    end)

    return self
end
