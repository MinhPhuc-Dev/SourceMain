-- Tải thư viện giao diện Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Lấy tên người chơi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName
local GameWS = game.Workspace

-- Tạo cửa sổ giao diện chính
local Window = Fluent:CreateWindow({
    Name = "Rielsick Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "Rielsick-Hub",
    IntroEnabled = true,
    IntroText = "Welcome to Rielsick Hub!",
    MinimizeButton = true,
    DragToggle = true
})

Fluent:MakeNotification({
    Name = "Script Loaded!!",
    Content = "Welcome back, " .. PlayerName,
    Image = "rbxassetid://4483345998",
    Time = 3
})

-- Tạo tab chính trong giao diện
local MainTab = Window:CreateTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Biến cấu hình tốc độ
local flyspeed = 100
local minSpeed, maxSpeed = 20, 500
local moveEnabled = false
local Aesp = false

-- Thêm ô nhập để điều chỉnh tốc độ
MainTab:CreateTextbox({
    Name = "Set Speed",
    Default = tostring(flyspeed),
    TextDisappear = true,
    Callback = function(value)
        local speedInput = tonumber(value)
        if speedInput and speedInput >= minSpeed and speedInput <= maxSpeed then
            flyspeed = speedInput
            Fluent:MakeNotification({
                Name = "Speed Set",
                Content = "Speed updated to " .. flyspeed,
                Time = 2
            })
        else
            Fluent:MakeNotification({
                Name = "Invalid Value",
                Content = "Enter a value between " .. minSpeed .. " and " .. maxSpeed,
                Time = 2
            })
        end
    end
})

-- Hàm điều khiển vị trí người chơi di chuyển theo hướng hiện tại
local function moveForward()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end

    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not moveEnabled then
            connection:Disconnect()
            return
        end
        
        if humanoid.MoveDirection.Magnitude > 0 then
            local currentDirection = humanoid.MoveDirection.Unit
            local speed = flyspeed

            hrp.CFrame = hrp.CFrame + currentDirection * speed * 0.1
        end
    end)
end

-- Thêm Toggle cho tính năng di chuyển thuận
MainTab:CreateToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(toggleValue)
        moveEnabled = toggleValue
        if moveEnabled then
            moveForward()
            Fluent:MakeNotification({
                Name = "Function on",
                Content = "Set Speed To " .. flyspeed,
                Time = 2
            })
        else
            Fluent:MakeNotification({
                Name = "Auto Move Deactivated",
                Content = "Auto move has been disabled.",
                Time = 2
            })
        end
    end
})

-- Function Esp player
local function EspPlayer()
    local Players = game:GetService("Players")
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Character = player.Character or player.CharacterAdded:Wait()
            local head = Character:FindFirstChild("Head")

            if head then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = head.Size
                box.Adornee = head
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = head
            end
        end
    end
end

-- Thêm Toggle cho tính năng Esp
MainTab:CreateToggle({
    Name = "Esp player",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue

        if Aesp then
            EspPlayer()
            Fluent:MakeNotification({
                Name = "Function on",
                Content = "Esp player has been enabled.",
                Time = 2
            })
        else
            Fluent:MakeNotification({
                Name = "Function off",
                Content = "Esp player has been disabled.",
                Time = 2
            })
        end
    end
})

-- Khởi tạo giao diện
Fluent:Init()
