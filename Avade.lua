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

-- Xóa thông báo quảng cáo "new update" của UI
local UISettings = OrionLib.UISettings
if UISettings and UISettings.NewUpdateNotification then
    UISettings.NewUpdateNotification = nil
end

-- Biến và cấu hình bay
local flying = false
local flyspeed = 50
local flycontrol = {F = 0, R = 0, B = 0, L = 0, U = 0, D = 0}

local function Fly()
    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    flying = true

    -- Tạo BodyVelocity và BodyGyro
    local bv = Instance.new("BodyVelocity")
    local bg = Instance.new("BodyGyro")

    bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)  -- Tăng sức mạnh tối đa của lực đẩy.
    bg.CFrame = hrp.CFrame
    bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)  -- Tăng sức mạnh tối đa của mô-men xoắn.
    bg.P = 9e4
    bv.Parent = hrp
    bg.Parent = hrp

    -- Cập nhật chuyển động và góc quay
    local con = game:GetService("RunService").Stepped:Connect(function(_, dt)
        if not flying then
            con:Disconnect()
            bv:Destroy()
            bg:Destroy()
        end
        
        -- Điều khiển di chuyển và quay
        bv.Velocity = (workspace.CurrentCamera.CFrame.LookVector * ((flycontrol.F - flycontrol.B) * flyspeed)) +
                      (workspace.CurrentCamera.CFrame.RightVector * ((flycontrol.R - flycontrol.L) * flyspeed)) +
                      (workspace.CurrentCamera.CFrame.UpVector * ((flycontrol.U - flycontrol.D) * flyspeed))
        bg.CFrame = workspace.CurrentCamera.CFrame
    end)
end

-- Tạo toggle cho chức năng bay trong giao diện
MainTab:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            Fly()  -- Kích hoạt chức năng bay khi bật toggle
        else
            flying = false  -- Dừng bay khi tắt toggle
        end
    end
})

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

    -- Kiểm tra các phím để di chuyển khi bay
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
    
    -- Kiểm tra khi người chơi ngừng nhấn phím
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

local function speed(Wp)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:wait()
    local humanoid = Character.FindFirstChildOfClass(Humanoid)
    Speed = true
    if humanoid then 
        print("Founded Humanoid")
        humanoid.Walkspeed = Wp
    else
        print("Can't find Humanoid")
    end        
end
MainTab:AddToggle({
    Name = "Speed",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            Wp = 100
            speed(Wp)
        else
            Wp = 16
            speed(Wp)
})
-- Khởi tạo giao diện
OrionLib:Init()
