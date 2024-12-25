-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
-- Tải thư viện giao diện từ URL chính thức.
-- `game:HttpGet` tải mã nguồn từ URL.
-- `loadstring` chuyển đổi mã tải về thành hàm Lua, giúp sử dụng thư viện OrionLib.

-- Tạo cửa sổ giao diện chính
local Window = OrionLib:MakeWindow({
    Name = "Rielsick Hub", -- Tên giao diện sẽ hiển thị trên thanh tiêu đề
    HidePremium = false, -- Hiển thị hoặc ẩn các tính năng Premium
    SaveConfig = true, -- Lưu cấu hình của người dùng (bật/tắt toggle, v.v.)
    ConfigFolder = "RielsickHub", -- Thư mục lưu cấu hình (nếu SaveConfig = true)
    IntroEnabled = true, -- Bật màn hình giới thiệu
    IntroText = "Welcome to Rielsick Hub!" -- Văn bản hiển thị trên màn hình giới thiệu
})
-- `MakeWindow` tạo cửa sổ chính của giao diện Orion.
-- Các thiết lập này định cấu hình giao diện như tên, lưu cấu hình, hoặc ẩn tính năng cao cấp.

-- Tạo tab chính cho giao diện
local MainTab = Window:MakeTab({
    Name = "Home", -- Tên tab hiển thị trong giao diện
    Icon = "rbxassetid://4483345998", -- Icon đại diện của tab (có thể thay asset ID)
    PremiumOnly = false -- Không giới hạn cho người dùng không Premium
})
-- `MakeTab` tạo một tab trong giao diện.
-- Tab này có thể chứa các mục con như Toggle, Button, TextBox.

-- Biến toàn cục
local flying = false -- Biến kiểm soát trạng thái bay (true/false)
local speed = 40 -- Tốc độ bay mặc định
local isJumping = false -- Kiểm tra nếu người chơi nhấn phím nhảy (Space)

-- Hàm xử lý cơ chế bay
local function handleFly()
    local player = game.Players.LocalPlayer -- Lấy người chơi hiện tại
    local character = player.Character or player.CharacterAdded:Wait() -- Đợi nhân vật của người chơi
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Phần trung tâm để điều khiển chuyển động
    local userInputService = game:GetService("UserInputService") -- Dịch vụ đầu vào (bàn phím, chuột)

    spawn(function() -- Tạo luồng xử lý song song
        while flying and humanoidRootPart do -- Lặp trong khi đang bay và nhân vật tồn tại
            local velocity = Vector3.zero -- Vận tốc mặc định là 0
            if isJumping then
                velocity = velocity + Vector3.new(0, speed, 0) -- Bay lên nếu nhấn Space
            end
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + humanoidRootPart.CFrame.LookVector * speed -- Tiến tới
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - humanoidRootPart.CFrame.LookVector * speed -- Lùi lại
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - humanoidRootPart.CFrame.RightVector * speed -- Sang trái
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + humanoidRootPart.CFrame.RightVector * speed -- Sang phải
            end

            humanoidRootPart.Velocity = velocity -- Cập nhật vận tốc của nhân vật
            wait(0.03) -- Dừng ngắn để giảm tải CPU
        end

        if humanoidRootPart then
            humanoidRootPart.Velocity = Vector3.zero -- Dừng nhân vật khi tắt chế độ bay
        end
    end)
end

-- Lắng nghe sự kiện nhấn phím
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input)
    if flying and input.KeyCode == Enum.KeyCode.Space then
        isJumping = true -- Đặt trạng thái nhảy nếu nhấn Space
    end
end)

userInputService.InputEnded:Connect(function(input)
    if flying and input.KeyCode == Enum.KeyCode.Space then
        isJumping = false -- Tắt trạng thái nhảy nếu nhả Space
    end
end)

-- Thêm toggle bật/tắt chế độ bay vào giao diện
MainTab:AddToggle({
    Name = "Enable Fly", -- Tên của toggle
    Default = false, -- Trạng thái mặc định là tắt
    Callback = function(toggleValue)
        flying = toggleValue -- Cập nhật biến trạng thái bay
        if flying then
            OrionLib:MakeNotification({
                Name = "Flying Enabled", -- Tiêu đề thông báo
                Content = "Bạn đang bay!", -- Nội dung thông báo
                Image = "rbxassetid://4483345998", -- Icon thông báo
                Time = 5 -- Thời gian hiển thị
            })
            handleFly() -- Gọi hàm bay
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

-- Thêm TextBox để nhập tốc độ bay
MainTab:AddTextbox({
    Name = "Set Fly Speed", -- Tên của TextBox
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
                Content = "Please enter a valid number!", -- Thông báo nếu nhập sai
                Image = "rbxassetid://4483345998", -- Icon thông báo
                Time = 3 -- Thời gian hiển thị
            })
        end
    end
})

-- Bắt buộc khởi tạo giao diện
OrionLib:Init()
-- `Init` khởi tạo toàn bộ giao diện đã cấu hình trước đó.
-- Nếu không gọi hàm này, giao diện sẽ không hiển thị.
