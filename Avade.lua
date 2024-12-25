-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Lấy tên người chơi
local Players = game:GetService("Players") -- Dịch vụ quản lý người chơi
local LocalPlayer = Players.LocalPlayer -- Người chơi hiện tại
local PlayerName = LocalPlayer.DisplayName -- Tên hiển thị của người chơi

-- Tạo cửa sổ giao diện chính
local Window = OrionLib:MakeWindow({
    Name = "Rielsick Hub", -- Tên giao diện chính
    HidePremium = false, -- Hiển thị các tính năng Premium
    SaveConfig = true, -- Lưu cấu hình người dùng
    ConfigFolder = "RielsickHub", -- Thư mục lưu cấu hình
    IntroEnabled = true, -- Hiển thị màn hình giới thiệu
    IntroText = "Welcome to Rielsick Hub!", -- Văn bản giới thiệu
    MinimizeButton = true, -- Cho phép thu nhỏ giao diện
    DragToggle = true -- Bật tính năng kéo UI khi thu nhỏ
})
-- Tính năng `DragToggle` cho phép người dùng di chuyển giao diện khi thu nhỏ.

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
local flying = false -- Trạng thái bật/tắt bay
local platform -- Biến lưu giữ khối nâng nhân vật
local defaultHeight = 3 -- Độ cao mặc định của khối so với nhân vật
local speed = 40 -- Tốc độ di chuyển theo phương ngang

-- Hàm tạo khối nền tảng
local function createPlatform()
    if not platform then -- Chỉ tạo khối nếu nó chưa tồn tại
        platform = Instance.new("Part") -- Tạo một khối mới
        platform.Size = Vector3.new(4, 1, 4) -- Kích thước của khối
        platform.Anchored = true -- Giữ khối cố định
        platform.CanCollide = true -- Khối có thể va chạm với nhân vật
        platform.Transparency = 1 -- Làm khối tàng hình
        platform.Parent = workspace -- Thêm khối vào thế giới trò chơi
    end
end

-- Hàm cập nhật vị trí của khối
local function updatePlatform()
    if platform then -- Kiểm tra xem khối đã tồn tại chưa
        local character = LocalPlayer.Character -- Lấy nhân vật của người chơi
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") -- Lấy phần trung tâm nhân vật
            if humanoidRootPart then
                platform.Position = humanoidRootPart.Position - Vector3.new(0, defaultHeight, 0) 
                -- Đặt khối bên dưới nhân vật
            end
        end
    end
end

-- Bật/Tắt bay
MainTab:AddToggle({
    Name = "Enable Fly", -- Tên của toggle
    Default = false, -- Mặc định toggle ở trạng thái tắt
    Callback = function(toggleValue) -- Hàm callback được kích hoạt khi toggle thay đổi trạng thái
        flying = toggleValue -- Cập nhật trạng thái bay
        if flying then
            createPlatform() -- Tạo khối nếu bật bay
            spawn(function() -- Chạy một luồng riêng để xử lý liên tục
                while flying do
                    updatePlatform() -- Cập nhật vị trí khối liên tục khi bay
                    wait(0.03) -- Giảm tải CPU bằng cách thêm thời gian chờ
                end
                if platform then
                    platform:Destroy() -- Xóa khối nếu tắt bay
                    platform = nil
                end
            end)
        else
            if platform then
                platform:Destroy() -- Xóa khối nếu toggle bị tắt
                platform = nil
            end
        end
    end
})

-- Điều chỉnh độ cao cho người dùng di động và bàn phím
local userInputService = game:GetService("UserInputService") -- Dịch vụ nhận đầu vào từ bàn phím và chuột
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end -- Không xử lý đầu vào đã được game sử dụng
    if input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        -- Tăng độ cao khi nhấn Space hoặc chạm màn hình
        defaultHeight = defaultHeight + 1
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        -- Giảm độ cao khi nhấn LeftShift
        defaultHeight = defaultHeight - 1
    end
end)

-- Xóa thông báo quảng cáo "new update" của UI
local UISettings = OrionLib.UISettings
if UISettings and UISettings.NewUpdateNotification then
    UISettings.NewUpdateNotification = nil -- Xóa phần tử thông báo
end

-- Khởi tạo giao diện
OrionLib:Init()
