-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Lấy tên người chơi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName

-- Lấy dịch vụ UserInputService
local userInputService = game:GetService("UserInputService")

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
    Image = "rbxassetid://4483345998",  -- Thêm hình ảnh cho thông báo (tuỳ chọn)
    Time = 3  -- Thời gian hiển thị thông báo, 5 giây
})

-- Tạo tab chính trong giao diện
local MainTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Biến và cấu hình bay
local flying = false
local flyspeed = 50
local flycontrol = {F = 0, R = 0, B = 0, L = 0, U = 0, D = 0}

-- Điều khiển bay với các phím
local controls = {
    front = "w",
    back = "s",
    right = "d",
    left = "a",
    up = "space",
    down = "leftcontrol"
}

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode.Name:lower()
    if key == controls.front then
        flycontrol.F = 1
    elseif key == controls.back then
        flycontrol.B = 1
    elseif key == controls.right then
        flycontrol.R = 1
    elseif key == controls.left then
        flycontrol.L = 1
    elseif key == controls.up then
        flycontrol.U = 1
    elseif key == controls.down then
        flycontrol.D = 1
    end
end)

userInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode.Name:lower()
    if key == controls.front then
        flycontrol.F = 0
    elseif key == controls.back then
        flycontrol.B = 0
    elseif key == controls.right then
        flycontrol.R = 0
    elseif key == controls.left then
        flycontrol.L = 0
    elseif key == controls.up then
        flycontrol.U = 0
    elseif key == controls.down then
        flycontrol.D = 0
    end
end)

-- Hàm thay đổi tốc độ di chuyển
local function speedControl()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end
    
    local currentSpeed = 16  -- Tốc độ ban đầu (có thể điều chỉnh)
    local maxSpeed = 100     -- Tốc độ tối đa
    local acceleration = 2    -- Tăng tốc độ mỗi giây
    
    -- Vòng lặp liên tục để tăng tốc độ khi nhân vật di chuyển
    game:GetService("RunService").Heartbeat:Connect(function()
        if humanoid.MoveDirection.Magnitude > 0 then
            -- Tăng tốc độ dần dần khi di chuyển
            currentSpeed = math.min(currentSpeed + acceleration, maxSpeed)
        else
            -- Giảm tốc độ khi không di chuyển
            currentSpeed = math.max(currentSpeed - acceleration, 16)
        end

        -- Cập nhật tốc độ di chuyển của nhân vật
        humanoid.WalkSpeed = currentSpeed
    end)
end

-- Thêm Toggle cho tính năng thay đổi tốc độ
MainTab:AddToggle({
    Name = "Auto Speed Control",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            speedControl()  -- Kích hoạt tính năng thay đổi tốc độ
        end
    end
})

-- Thêm input box cho Walk Speed
MainTab:AddTextbox({
    Name = "Walk Speed",
    Default = "16",  -- Giá trị mặc định
    TextDisappear = true,
    Callback = function(value)
        local speedValue = tonumber(value) or 16  -- Đảm bảo giá trị hợp lệ
        -- Điều chỉnh tốc độ của nhân vật nếu cần
        LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = speedValue
    end
})

-- Khởi tạo giao diện
OrionLib:Init()
