-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Lấy tên người chơi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName

-- Tạo cửa sổ giao diện chính
local Window = OrionLib:MakeWindow({
    Name = "Rielsick Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RielsickHub",
    IntroEnabled = true,
    IntroText = "Welcome to Rielsick Hub!",
    MinimizeButton = true,
    DragToggle = true
})

OrionLib:MakeNotification({
    Name = "Script Loaded!!",
    Content = "Welcome back, " .. PlayerName,
    Image = "rbxassetid://4483345998", -- Thêm hình ảnh cho thông báo (tuỳ chọn)
    Time = 3 -- Thời gian hiển thị thông báo, 3 giây
})

-- Tạo tab chính trong giao diện
local MainTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Biến cấu hình tốc độ
local flyspeed = 100 -- Tốc độ mặc định
local minSpeed, maxSpeed = 20, 500 -- Giới hạn tốc độ

-- Thêm ô nhập để điều chỉnh tốc độ
MainTab:AddTextbox({
    Name = "Set Speed",
    Default = tostring(flyspeed),
    TextDisappear = true,
    Callback = function(value)
        local speedInput = tonumber(value)
        if speedInput and speedInput >= minSpeed and speedInput <= maxSpeed then
            flyspeed = speedInput
            OrionLib:MakeNotification({
                Name = "Speed Set",
                Content = "Speed updated to " .. flyspeed,
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Invalid Speed",
                Content = "Enter a value between " .. minSpeed .. " and " .. maxSpeed,
                Time = 2
            })
        end
    end
})

-- Thêm Toggle kích hoạt di chuyển nhanh (không còn di chuyển ngược)
MainTab:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            OrionLib:MakeNotification({
                Name = "Speed Boost Activated",
                Content = "Speed boost is now active at " .. flyspeed .. ".",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Speed Boost Deactivated",
                Content = "Speed boost has been disabled.",
                Time = 2
            })
        end
    end
})

-- Khởi tạo giao diện
OrionLib:Init()
