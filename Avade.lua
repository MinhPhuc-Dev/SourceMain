-- Tải thư viện giao diện Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Tạo cửa sổ chính
local Window = Fluent:CreateWindow({
    Title = "RielSick Hub",
    SubTitle = "by Dora",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 280),
    Acrylic = true,
    Theme = "Grey",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tạo các tab
local Tabs = {
    Misc = Window:AddTab({ Title = "Misc" }),
    Main = Window:AddTab({ Title = "Main" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Biến cấu hình
local flyspeed = 100
local minSpeed, maxSpeed = 20, 500
local moveEnabled = false
local Aesp = false
local HealhPercent = 20

-- Lấy tên người chơi
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerName = LocalPlayer.DisplayName

-- Thông báo khi script được tải
Fluent:Notify({
    Title = "Script Loaded!!",
    Content = "Welcome back, " .. PlayerName,
    Duration = 3
})

-- Thêm Input để chỉnh tốc độ di chuyển
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

-- Toggle di chuyển nhanh
Tabs.Misc:AddToggle("SpeedBoost", {
    Title = "Speed Boost",
    Default = false,
    Callback = function(toggleValue)
        moveEnabled = toggleValue
        if moveEnabled then
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

-- Thêm Toggle cho ESP Player
Tabs.Misc:AddToggle("EspPlayer", {
    Title = "ESP Player",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue
        if Aesp then
            Fluent:Notify({
                Title = "Function on",
                Content = "ESP Player has been enabled.",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Function off",
                Content = "ESP Player has been disabled.",
                Duration = 2
            })
        end
    end
})

-- Thêm Input HealthPercent
Tabs.Main:AddInput("HealthPercent", {
    Title = "Health %",
    Default = tostring(HealhPercent),
    Placeholder = "Enter Health Percent",
    Numeric = true,
    Callback = function(value)
        local healthInput = tonumber(value)
        if healthInput and healthInput >= 20 and healthInput <= 50 then
            HealhPercent = healthInput
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

-- SafeModeWhenLowHealth
Tabs.Main:AddToggle("SafeModeWhenLowHealth", {
    Title = "Safe Mode When Low Health",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
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

-- Thêm các phần cấu hình
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
