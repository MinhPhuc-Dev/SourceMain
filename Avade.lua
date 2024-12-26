-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Lấy tên người chơi
local Players = game:GetService("Players") -- Lấy thông tin về người chơi
local LocalPlayer = Players.LocalPlayer-- Lấy thông tin người chơi đang chạy script
local PlayerName = LocalPlayer.DisplayName -- Lấy tên người chơi
local GameWS = game.Workspace -- Lấy thông tin về môi trường làm việc

-- Tạo cửa sổ giao diện chính
local Window = OrionLib:MakeWindow({
    Name = "Rielsick Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "Rielsick-Hub",
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
local moveEnabled = false -- Trạng thái di chuyển

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

    -- Sử dụng RunService để kiểm tra sự di chuyển
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not moveEnabled then
            connection:Disconnect()
            return
        end
        
        -- Kiểm tra nếu nhân vật đang di chuyển
        if humanoid.MoveDirection.Magnitude > 0 then
            local currentDirection = humanoid.MoveDirection.Unit -- Hướng di chuyển hiện tại
            local speed = flyspeed -- Tốc độ do người dùng nhập

            -- Cập nhật vị trí của người chơi liên tục theo hướng hiện tại
            hrp.CFrame = hrp.CFrame + currentDirection * speed * 0.1
        end
    end)
end

-- Thêm Toggle cho tính năng di chuyển thuận
MainTab:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(toggleValue)
        moveEnabled = toggleValue
        if moveEnabled then
            moveForward() -- Kích hoạt tính năng di chuyển
            OrionLib:MakeNotification({
                Name = "Function on",
                Content = "Set Speed To " .. flyspeed,
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Auto Move Deactivated",
                Content = "Auto move has been disabled.",
                Time = 2
            })
        end
    end
})

-- Function Esp player
local function EspPlayer()
    local Player = game.Players:GetService("Players")
    for _, player in pairs(Player:GetPlayers()) do
        if player ~= LocalPlayer then    
            
            
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid =  Character:FindFirstChild("Humanoid")
            local head = Humanoid:FindFirstChild("Head")

            if head then
                local headpos = head.Position
                if headpos then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = head.Size
                    box.Adornee = head -- Đặt vị trí của box
                    box.Color3 = Color3.fromRGB(255, 0, 0) -- Màu sắc của box
                    box.AlwaysOnTop = true
                    box.ZIndex = 5 -- Độ sâu của box
                    box.Parent = head -- Đặt box vào vị trí của head
                end
            end
        end
    end
end

-- Thêm Toggle cho tính năng Esp
MainTab:AddToggle({
    Name = "Esp player",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue

        EspPlayer()
        if Aesp then
            OrionLib:MakeNotification({
                Name = "Function on",
                Content = "Esp player has been enabled.",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Function off",
                Content = "Esp player has been disabled.",
                Time = 2
            })
        end
    end
})

-- Khởi tạo giao diện
OrionLib:Init()
