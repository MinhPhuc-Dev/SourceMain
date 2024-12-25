-- Tải thư viện giao diện Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Lấy tên người chơi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName

-- Lấy dịch vụ UserInputService để xử lý đầu vào từ người chơi
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
local platform
local defaultHeight = 3
local speed = 40

-- Hàm tạo khối nền tảng
local function createPlatform()
    if not platform then
        platform = Instance.new("Part")
        platform.Size = Vector3.new(4, 1, 4)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Transparency = 1
        platform.Parent = workspace
    end
end

-- Hàm cập nhật vị trí của khối
local function updatePlatform()
    if platform then
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoidRootPart and humanoid then
                local moveDirection = humanoid.MoveDirection
                local verticalAdjustment = 0
                -- Điều chỉnh độ cao theo trạng thái phím nhảy/cúi
                if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                    verticalAdjustment = 1
                elseif userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    verticalAdjustment = -1
                end
                platform.Position = humanoidRootPart.Position 
                    + Vector3.new(moveDirection.X, verticalAdjustment, moveDirection.Z) * speed * 0.03
            end
        end
    end
end

-- Bật/Tắt bay
MainTab:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(toggleValue)
        flying = toggleValue
        if flying then
            createPlatform()
            spawn(function()
                while flying do
                    updatePlatform()
                    wait(0.03)
                end
                if platform then
                    platform:Destroy()
                    platform = nil
                end
            end)
        else
            if platform then
                platform:Destroy()
                platform = nil
            end
        end
    end
})

-- Xóa thông báo quảng cáo "new update" của UI
local UISettings = OrionLib.UISettings
if UISettings and UISettings.NewUpdateNotification then
    UISettings.NewUpdateNotification = nil
end

-- Khởi tạo giao diện
OrionLib:Init()
