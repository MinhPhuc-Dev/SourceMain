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

-- Hàm điều khiển vị trí người chơi theo hướng đối diện với tốc độ tăng lên
local function movePlayer()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end

    -- Sử dụng RunService để kiểm tra sự di chuyển
    game:GetService("RunService").Heartbeat:Connect(function()
        -- Kiểm tra nếu nhân vật đang di chuyển
        if humanoid.MoveDirection.Magnitude > 0 then
            local currentDirection = -humanoid.MoveDirection.Unit -- Đảo ngược hướng di chuyển
            local speed = 100 -- Tăng tốc độ di chuyển (tăng từ 50 lên 100)

            -- Cập nhật vị trí của người chơi liên tục
            hrp.CFrame = hrp.CFrame + currentDirection * speed * 0.1 -- Cập nhật vị trí theo hướng đối diện
        end
    end)
end

-- Thêm Toggle cho tính năng thay đổi vị trí liên tục
MainTab:AddToggle({
    Name = "Auto Move Player",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            movePlayer()  -- Kích hoạt tính năng di chuyển liên tục
        end
    end
})

-- Khởi tạo giao diện
OrionLib:Init()

