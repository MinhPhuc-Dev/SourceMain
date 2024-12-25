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
    MinimizeButton = true
})

-- Hiển thị thông báo "Script Loaded!!"
OrionLib:MakeNotification({
    Name = "Script Loaded!!",
    Content = "Welcome back!! " .. PlayerName,
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Tạo tab chính trong giao diện
local MainTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Biến toàn cục
local flying = false
local speed = 40
local platform

-- Hàm tạo nền tảng tàng hình
local function createPlatform()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    platform = Instance.new("Part")
    platform.Size = Vector3.new(4, 1, 4) -- Kích thước khối
    platform.Anchored = true -- Giữ cố định
    platform.CanCollide = true -- Có thể va chạm
    platform.Transparency = 1 -- Tàng hình
    platform.Parent = workspace -- Thêm vào không gian làm việc
end

-- Hàm cập nhật vị trí nền tảng
local function updatePlatform()
    if not platform then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        platform.Position = humanoidRootPart.Position - Vector3.new(0, 3, 0) -- Đặt nền tảng bên dưới nhân vật
    end
end

-- Thêm Toggle bật/tắt chế độ bay
MainTab:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(toggleValue)
        flying = toggleValue
        if flying then
            OrionLib:MakeNotification({
                Name = "Flying Enabled",
                Content = "Bạn đang bay!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            createPlatform() -- Tạo nền tảng
            spawn(function()
                while flying do
                    updatePlatform() -- Cập nhật vị trí nền tảng
                    wait(0.03)
                end
                platform:Destroy() -- Xóa nền tảng khi tắt bay
            end)
        else
            OrionLib:MakeNotification({
                Name = "Flying Disabled",
                Content = "Bạn đã dừng bay!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            if platform then
                platform:Destroy()
            end
        end
    end
})

-- Thêm TextBox để thay đổi tốc độ bay
MainTab:AddTextbox({
    Name = "Set Fly Speed",
    Default = "40",
    TextDisappear = true,
    Callback = function(newSpeedText)
        local newSpeed = tonumber(newSpeedText)
        if newSpeed then
            speed = math.clamp(newSpeed, 10, 200)
            OrionLib:MakeNotification({
                Name = "Speed Updated",
                Content = "Set speed to " .. speed,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Invalid Speed",
                Content = "Please enter a valid number!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Lắng nghe sự kiện nhấn phím để di chuyển
local userInputService = game:GetService("UserInputService")
local flyDirection = Vector3.zero

userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        flyDirection = flyDirection + Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then
        flyDirection = flyDirection + Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then
        flyDirection = flyDirection + Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        flyDirection = flyDirection + Vector3.new(1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.Space then
        flyDirection = flyDirection + Vector3.new(0, 1, 0)
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        flyDirection = flyDirection + Vector3.new(0, -1, 0)
    end
end)

userInputService.InputEnded:Connect(function(input)
    flyDirection = Vector3.zero -- Dừng di chuyển khi nhả phím
end)

-- Cập nhật vị trí bay theo hướng và tốc độ
spawn(function()
    while true do
        if flying and platform then
            platform.CFrame = platform.CFrame + flyDirection * speed * 0.03
        end
        wait(0.03)
    end
end)

-- Khởi tạo giao diện
OrionLib:Init()
