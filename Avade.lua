-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Lấy tên người chơi
local Players = game:GetService("Players") -- Dịch vụ quản lý người chơi
local LocalPlayer = Players.LocalPlayer -- Người chơi hiện tại
local PlayerName = LocalPlayer.DisplayName -- Tên hiển thị của người chơi

-- Tạo cửa sổ giao diện chính
local Window = OrionLib:MakeWindow({
    Name = "Rielsick Hub - Welcome back, " .. PlayerName .. "!", -- Tên giao diện chào mừng người chơi
    HidePremium = false, -- Hiển thị các tính năng Premium
    SaveConfig = true, -- Lưu cấu hình người dùng
    ConfigFolder = "RielsickHub", -- Thư mục lưu cấu hình
    IntroEnabled = true, -- Hiển thị màn hình giới thiệu
    IntroText = "Welcome to Rielsick Hub!", -- Văn bản màn hình giới thiệu
    MinimizeButton = true -- Cho phép thu nhỏ giao diện
})

-- Hiển thị thông báo "Script Loaded!!"
OrionLib:MakeNotification({
    Name = "Script Loaded!!", -- Tiêu đề thông báo
    Content = "Welcome back!! " .. PlayerName, -- Nội dung thông báo
    Image = "rbxassetid://4483345998", -- Icon thông báo
    Time = 5 -- Thời gian hiển thị
})

-- Tạo tab chính trong giao diện
local MainTab = Window:MakeTab({
    Name = "Home", -- Tên tab
    Icon = "rbxassetid://4483345998", -- Icon tab
    PremiumOnly = false -- Không giới hạn Premium
})

-- Biến toàn cục
local flying = false -- Trạng thái bay
local speed = 40 -- Tốc độ bay mặc định
local flyDirection = Vector3.zero -- Hướng bay

-- Phương pháp bay mới
local function handleFly()
    local player = LocalPlayer -- Người chơi hiện tại
    local character = player.Character or player.CharacterAdded:Wait() -- Đợi nhân vật của người chơi
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Phần trung tâm di chuyển
    local bodyVelocity = Instance.new("BodyVelocity") -- Tạo lực bay
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5) -- Đặt lực tối đa
    bodyVelocity.Parent = humanoidRootPart -- Gắn lực bay vào nhân vật

    -- Luồng bay
    spawn(function()
        while flying do
            bodyVelocity.Velocity = flyDirection * speed -- Cập nhật hướng và tốc độ
            wait(0.03) -- Dừng ngắn để tránh quá tải CPU
        end
        bodyVelocity:Destroy() -- Xóa lực bay khi dừng
    end)
end

-- Lắng nghe sự kiện nhấn phím để di chuyển
local userInputService = game:GetService("UserInputService") -- Dịch vụ nhận phím đầu vào

userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        flyDirection = Vector3.new(0, 0, -1) -- Tiến tới
    elseif input.KeyCode == Enum.KeyCode.S then
        flyDirection = Vector3.new(0, 0, 1) -- Lùi lại
    elseif input.KeyCode == Enum.KeyCode.A then
        flyDirection = Vector3.new(-1, 0, 0) -- Sang trái
    elseif input.KeyCode == Enum.KeyCode.D then
        flyDirection = Vector3.new(1, 0, 0) -- Sang phải
    elseif input.KeyCode == Enum.KeyCode.Space then
        flyDirection = Vector3.new(0, 1, 0) -- Bay lên
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        flyDirection = Vector3.new(0, -1, 0) -- Bay xuống
    end
end)

userInputService.InputEnded:Connect(function(input)
    flyDirection = Vector3.zero -- Dừng di chuyển khi nhả phím
end)

-- Thêm Toggle bật/tắt chế độ bay
MainTab:AddToggle({
    Name = "Enable Fly", -- Tên toggle
    Default = false, -- Mặc định là tắt
    Callback = function(toggleValue)
        flying = toggleValue -- Cập nhật trạng thái bay
        if flying then
            OrionLib:MakeNotification({
                Name = "Flying Enabled", -- Tiêu đề thông báo
                Content = "Bạn đang bay!", -- Nội dung thông báo
                Image = "rbxassetid://4483345998", -- Icon thông báo
                Time = 5 -- Thời gian hiển thị
            })
            handleFly() -- Bắt đầu bay
        else
            OrionLib:MakeNotification({
                Name = "Flying Disabled", -- Tiêu đề thông báo
                Content = "Bạn đã dừng bay!", -- Nội dung thông báo
                Image = "rbxassetid://4483345998", -- Icon thông báo
                Time = 5 -- Thời gian hiển thị
            })
        end
    end
})

-- Thêm TextBox để thay đổi tốc độ bay
MainTab:AddTextbox({
    Name = "Set Fly Speed", -- Tên TextBox
    Default = "40", -- Giá trị mặc định
    TextDisappear = true, -- Văn bản sẽ biến mất sau khi nhập
    Callback = function(newSpeedText)
        local newSpeed = tonumber(newSpeedText) -- Chuyển giá trị nhập thành số
        if newSpeed then
            speed = math.clamp(newSpeed, 10, 200) -- Đảm bảo tốc độ trong khoảng 10–200
            OrionLib:MakeNotification({
                Name = "Speed Updated", -- Tiêu đề thông báo
                Content = "Set speed to " .. speed, -- Nội dung thông báo
                Image = "rbxassetid://4483345998", -- Icon thông báo
                Time = 3 -- Thời gian hiển thị
            })
        else
            OrionLib:MakeNotification({
                Name = "Invalid Speed", -- Tiêu đề thông báo
                Content = "Please enter a valid number!", -- Nội dung thông báo
                Image = "rbxassetid://4483345998", -- Icon thông báo
                Time = 3 -- Thời gian hiển thị
            })
        end
    end
})

-- Khởi tạo giao diện
OrionLib:Init()
