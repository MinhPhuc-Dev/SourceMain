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
    Time = 3  -- Thời gian hiển thị thông báo, 3 giây
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
local function speed(Wp)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Wp
        print("Speed set to", Wp)
    else
        print("Can't find Humanoid")
    end
end

-- Thêm input box cho Walk Speed
MainTab:AddTextbox({
    Name = "Walk Speed",
    Default = "16",  -- Giá trị mặc định
    TextDisappear = true,
    Callback = function(value)
        local speedValue = tonumber(value) or 16  -- Đảm bảo giá trị hợp lệ
        speed(speedValue)
    end
})

-- Thêm toggle thay đổi tốc độ di chuyển
MainTab:AddToggle({
    Name = "Speed",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            local speedValue = 100  -- Tốc độ cao
            speed(speedValue)
        else
            local speedValue = 16 -- Tốc độ mặc định
            speed(speedValue)
        end
    end
})

-- Khởi tạo giao diện
OrionLib:Init()
