-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
-- OrionLib được tải từ nguồn trực tuyến và cung cấp các tính năng giao diện mạnh mẽ cho script.

-- Lấy tên người chơi
local Players = game:GetService("Players") -- Truy cập dịch vụ quản lý người chơi
local LocalPlayer = Players.LocalPlayer -- Lấy đối tượng người chơi hiện tại
local PlayerName = LocalPlayer.DisplayName -- Lấy tên hiển thị của người chơi

-- Tạo cửa sổ giao diện chính
local Window = OrionLib:MakeWindow({
    Name = "Rielsick Hub", -- Tên của cửa sổ giao diện
    HidePremium = false, -- Không ẩn các tính năng Premium
    SaveConfig = true, -- Lưu cấu hình của người chơi vào file
    ConfigFolder = "RielsickHub", -- Tên thư mục lưu cấu hình
    IntroEnabled = true, -- Bật màn hình giới thiệu
    IntroText = "Welcome to Rielsick Hub!", -- Nội dung màn hình giới thiệu
    MinimizeButton = true -- Cho phép thu nhỏ giao diện
})
-- OrionLib:MakeWindow giúp tạo một cửa sổ giao diện chính với các thuộc tính tùy chỉnh.

-- Hiển thị thông báo "Script Loaded!!"
OrionLib:MakeNotification({
    Name = "Script Loaded!!", -- Tiêu đề thông báo
    Content = "Welcome back!! " .. PlayerName, -- Nội dung thông báo kèm tên người chơi
    Image = "rbxassetid://4483345998", -- Icon hiển thị (sử dụng ID từ Roblox)
    Time = 5 -- Thời gian hiển thị thông báo (tính bằng giây)
})
-- Thông báo giúp người dùng biết rằng script đã được tải thành công.

-- Tạo tab chính trong giao diện
local MainTab = Window:MakeTab({
    Name = "Home", -- Tên tab
    Icon = "rbxassetid://4483345998", -- Icon của tab
    PremiumOnly = false -- Không giới hạn chỉ dành cho Premium
})
-- Tạo một tab trong giao diện để chứa các chức năng chính.

-- Biến toàn cục
local flying = false -- Xác định trạng thái bật/tắt bay
local platform -- Biến lưu giữ khối nâng nhân vật
local defaultHeight = 3 -- Độ cao mặc định của khối so với nhân vật
local flyDirection = Vector3.zero -- Hướng bay của nhân vật
local speed = 40 -- Tốc độ di chuyển theo phương ngang

-- Hàm tạo khối nền tảng
local function createPlatform()
    if not platform then -- Chỉ tạo khối nếu nó chưa tồn tại
        platform = Instance.new("Part") -- Tạo một khối mới
        platform.Size = Vector3.new(4, 1, 4) -- Kích thước của khối
        platform.Anchored = true -- Giữ khối cố định, không bị trọng lực tác động
        platform.CanCollide = true -- Khối có thể va chạm với nhân vật
        platform.Transparency = 1 -- Làm khối tàng hình để không ảnh hưởng trải nghiệm hình ảnh
        platform.Parent = workspace -- Thêm khối vào thế giới trò chơi
    end
end
-- Hàm này đảm bảo rằng khi bay, nhân vật có một khối tàng hình hỗ trợ bên dưới.

-- Hàm cập nhật vị trí của khối
local function updatePlatform()
    if platform then -- Kiểm tra xem khối đã tồn tại chưa
        local character = LocalPlayer.Character -- Lấy nhân vật của người chơi
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") -- Lấy phần trung tâm nhân vật
            if humanoidRootPart then
                platform.Position = humanoidRootPart.Position - Vector3.new(0, defaultHeight, 0) 
                -- Đặt khối bên dưới nhân vật, cách một khoảng bằng defaultHeight
            end
        end
    end
end
-- Hàm này liên tục di chuyển khối theo vị trí của nhân vật, giữ nhân vật bay ở độ cao cố định.

-- Bật/Tắt bay
MainTab:AddToggle({
    Name = "Enable Fly", -- Tên của toggle
    Default = false, -- Mặc định toggle ở trạng thái tắt
    Callback = function(toggleValue) -- Hàm callback được kích hoạt khi toggle thay đổi trạng thái
        flying = toggleValue -- Cập nhật trạng thái bay theo toggle
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
-- Cho phép bật/tắt chế độ bay thông qua toggle, với khối hỗ trợ bên dưới nhân vật.

-- Thay đổi độ cao khối khi nhấn phím
local userInputService = game:GetService("UserInputService") -- Dịch vụ nhận đầu vào từ bàn phím và chuột
userInputService.InputBegan:Connect(function(input) -- Lắng nghe sự kiện khi người dùng bắt đầu nhấn phím
    if input.KeyCode == Enum.KeyCode.Space then
        defaultHeight = defaultHeight + 1 -- Tăng độ cao khối khi nhấn Space
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        defaultHeight = defaultHeight - 1 -- Giảm độ cao khối khi nhấn LeftShift
    end
end)
-- Điều chỉnh độ cao của khối bằng phím Space (tăng) và LeftShift (giảm), giúp tùy chỉnh trải nghiệm bay.

-- Khởi tạo giao diện
OrionLib:Init()
-- Kích hoạt giao diện đã thiết lập.
