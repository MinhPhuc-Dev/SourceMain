-- Tải thư viện giao diện Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "RielSick Hub",
    SubTitle = "by Dora",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 280),
    Acrylic = true,
    Theme = "Grey",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Misc = Window:AddTab({ Title = "Misc", Icon = "" }), -- Đổi tên tab Main thành Misc
    Main = Window:AddTab({ Title = "Main", Icon = "" }), -- Tạo tab Main mới
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Lấy tên người chơi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName
local GameWS = game.Workspace

-- Biến cấu hình tốc độ
local flyspeed = 100
local minSpeed, maxSpeed = 20, 500
local moveEnabled = false
local Aesp = false
local MiscTab = Tabs.Misc -- Sử dụng tab Misc thay vì Main

-- Thông báo khi script được tải
Fluent:Notify({
    Title = "Script Loaded!!",
    Content = "Welcome back, " .. PlayerName,
    Duration = 3
})

-- Tạo GUI trong StarterGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ToggleButtonGUI"
screenGui.Parent = playerGui

-- Tạo Frame chứa nút
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 150)
frame.Position = UDim2.new(0.5, -75, 0.5, -75)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 1 -- Làm trong suốt Frame
frame.Parent = screenGui

-- Tạo nút hình tròn
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30) -- kích thước bằng với kích thước logo roblox
toggleButton.Position = UDim2.new(0.5), 0, 30, 30) -- vị trí nút (x,y,z)
toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ mặc định
toggleButton.Text = nil
toggleButton.BorderSizePixel = 0
toggleButton.Parent = frame

-- Định dạng hình tròn
toggleButton.ClipsDescendants = true -- Bắt buộc để nút có dạng tròn
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0.5, 0) -- Hình tròn hoàn toàn
uicorner.Parent = toggleButton

-- Biến trạng thái bật/tắt
local isToggled = false

-- Hàm xử lý khi nút được nhấp
toggleButton.MouseButton1Click:Connect(function()
    isToggled = not isToggled -- Đổi trạng thái
    if isToggled then
        -- Kích thước to lên 1 tí
        toggleButton.Size = UDim2.new(0, 40, 0, 40)
        -- Tự động Bấm Phím LeftControl
        toggleButton.Text = "ON"
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    else
        -- Kích thước trở lại ban đầu
        toggleButton.Size = UDim2.new(0, 30, 0, 30)
        toggleButton.Text = "OFF"
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    end
end)

-- Thêm ô nhập để điều chỉnh tốc độ
Tabs.Misc:AddInput("SetSpeed", {
    Title = "Set Speed",
    Default = tostring(flyspeed),
    Placeholder = "Enter speed",
    Numeric = true,
    Callback = function(value)
        local speedInput = tonumber(value)
        if speedInput and speedInput >= minSpeed and speedInput <= maxSpeed then
            flyspeed = speedInput
            Fluent:Notify({
                Title = "Speed Set",
                Content = "Speed updated to " .. flyspeed,
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Invalid Value",
                Content = "Enter a value between " .. minSpeed .. " and " .. maxSpeed,
                Duration = 2
            })
        end
    end
})

-- Hàm điều khiển vị trí người chơi di chuyển theo hướng hiện tại
local function moveForward()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not hrp then return end

    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not moveEnabled then
            connection:Disconnect()
            return
        end
        
        if humanoid.MoveDirection.Magnitude > 0 then
            local currentDirection = humanoid.MoveDirection.Unit
            local speed = flyspeed

            hrp.CFrame = hrp.CFrame + currentDirection * speed * 0.1
        end
    end)
end

-- Thêm Toggle cho tính năng di chuyển thuận
Tabs.Misc:AddToggle("SpeedBoost", {
    Title = "Speed Boost",
    Default = false,
    Callback = function(toggleValue)
        moveEnabled = toggleValue
        if moveEnabled then
            moveForward()
            Fluent:Notify({
                Title = "Function on",
                Content = "Set Speed To " .. flyspeed,
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Auto Move Deactivated",
                Content = "Auto move has been disabled.",
                Duration = 2
            })
        end
    end
})

-- Function Esp player
local function EspPlayer()
    local Players = game:GetService("Players")
    local adornments = {}

    local function createBox(character)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = hrp.Size * 0.5
            box.Adornee = hrp
            box.Color3 = Color3.fromRGB(255, 50, 62)
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Transparency = 0.5
            box.Parent = hrp
            adornments[character] = box
        end
    end

    local function updateBoxes()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local box = adornments[character]
                        if not box then
                            createBox(character)
                        else
                            box.Size = hrp.Size * 0.5
                        end
                    end
                end
            end
        end
    end

    game:GetService("RunService").RenderStepped:Connect(updateBoxes)
end

-- Thêm Toggle cho tính năng Esp
Tabs.Misc:AddToggle("EspPlayer", {
    Title = "Esp player",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue

        if Aesp then
            EspPlayer()
            Fluent:Notify({
                Title = "Function on",
                Content = "Esp player has been enabled.",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Function off",
                Content = "Esp player has been disabled.",
                Duration = 2
            })
        end
    end
})


-- AddInput HealthPercent Value ( 20 - 50 )
Tabs.Main:AddInput("HealthPercent", {
    Title = "Health %",
    Default = "20",
    Placeholder = "Enter Health Percent",
    Numeric = true,
    Callback = function(value)
        HealhPercent = tonumber(value)
        if HealhPercent and HealhPercent >= 20 and HealhPercent <= 50 then
            Fluent:Notify({
                Title = "Health Percent Set",
                Content = "Health Percent updated to " .. HealhPercent,
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Invalid Value",
                Content = "Enter a value between 20 and 50",
                Duration = 2
            })
        end
    end
})


-- Function SafeModeWhenLowHealth
local function SafeModeWhenLowHealth()
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local HealthNow = humanoid.Health
    local HealthMax = humanoid.MaxHealth
    local LowHealth = HealthMax * HealhPercent/100
    
    if HealthNow <= LowHealth then
        Fluent:Notify({
            Title = "Safe Mode Notice!!",
            Content = "Player Low Health",
            Duration = 2
        })
    end
end

-- add toggle SafeModeWhenLowHealth

Tabs.Main:AddToggle("SafeModeWhenLowHealth", {
    Title = "Safe Mode When Low Health",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue
        if Aes[] then
            SafeModeWhenLowHealth()
            Fluent:Notify({
                Title = "Function on",
                Content = "Safe Mode When Low Health has been enabled.",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Function off",
                Content = "Safe Mode When Low Health has been disabled.",
                Duration = 2
            })
        end
    end
})



-- Addons:
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
