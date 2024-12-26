-- Tải thư viện giao diện Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "RielSick Hub",
    SubTitle = "by Dora",
    TabWidth = 160,
    Size = UDim2.fromOffset(380, 260),
    Acrylic = true,
    Theme = "Grey",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
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
local MainTab = Tabs.Main

-- Thông báo khi script được tải
Fluent:Notify({
    Title = "Script Loaded!!",
    Content = "Welcome back, " .. PlayerName,
    Duration = 3
})

-- toggle bat tat UI * Doc lap khong su dung Fluent* hinh tron
local function CreateToggleUi()
    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Size = UDim2.new(0, 50, 0, 50)
    Toggle.Position = UDim2.new(0, 0, 0, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = "ON/OFF"
    Toggle.BorderSizePixel = 0
    Toggle.AutoButtonColor = false
    Toggle.ZIndex = 2
    return Toggle
end

-- Thêm ô nhập để điều chỉnh tốc độ
Tabs.Main:AddInput("SetSpeed", {
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
Tabs.Main:AddToggle("SpeedBoost", {
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
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Character = player.Character or player.CharacterAdded:Wait()
            local head = Character:FindFirstChild("Head")

            if head then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = head.Size
                box.Adornee = head
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = head
            end
        end
    end
end

-- Thêm Toggle cho tính năng Esp
Tabs.Main:AddToggle("EspPlayer", {
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

local function AutocollectCandy()
    local GroupNames = {"Ticket1", "Ticket2", "Ticket3", "Ticket4", "Ticket5", "Ticket6", "Ticket7", "Ticket8", "Ticket9", "Ticket10"}
    for _, groupName in ipairs(GroupNames) do
        local Group = GameWS:FindFirstChild(groupName)
        if Group then
            for _, v in ipairs(Group:GetChildren()) do
                if v:IsA("BasePart") then
                    local TicketPos = v.Position
                    print("TicketPos: " .. tostring(TicketPos))
                end
            end
        else
            print("Không tìm thấy nhóm " .. groupName)
        end
    end
end

-- add toggle auto collect candy
Tabs.Main:AddToggle("AutoCollectCandy", {
    Title = "Auto Collect Candy",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue

        if Aesp then
            AutocollectCandy()
            Fluent:Notify({
                Title = "Function on",
                Content = "Auto collect candy has been enabled.",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Function off",
                Content = "Auto collect candy has been disabled.",
                Duration = 2
            })
        end
    end
})

SaveManager:LoadAutoloadConfig()
