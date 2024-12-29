-- Tải thư viện Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Tạo cửa sổ chính
local Window = Fluent:CreateWindow({
    Title = "RielSick Hub",
    SubTitle = "by Dora",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 400), -- Điều chỉnh kích thước để đảm bảo hiển thị
    Acrylic = true,
    Theme = "Dark", -- Dùng theme Dark để dễ nhìn
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Thêm các tab
local Tabs = {
    Misc = Window:AddTab({ Title = "Misc" }),
    Main = Window:AddTab({ Title = "Main" }),
    Settings = Window:AddTab({ Title = "Settings" })
}

-- Đảm bảo Fluent hoạt động
if not Tabs.Misc then
    error("Fluent: Failed to create Misc tab")
end
if not Tabs.Main then
    error("Fluent: Failed to create Main tab")
end

-- Cấu hình tốc độ
local flyspeed = 100
local minSpeed, maxSpeed = 20, 500
local moveEnabled = false
local Aesp = false

-- Thông báo khi script được tải
Fluent:Notify({
    Title = "Script Loaded",
    Content = "Welcome to RielSick Hub!",
    Duration = 3
})

-- Thêm toggle cho tính năng "Speed Boost" trong tab Misc
Tabs.Misc:AddToggle("SpeedBoost", {
    Title = "Speed Boost",
    Default = false,
    Callback = function(toggleValue)
        moveEnabled = toggleValue
        if moveEnabled then
            Fluent:Notify({
                Title = "Speed Boost Enabled",
                Content = "Set speed to " .. flyspeed,
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Speed Boost Disabled",
                Content = "Auto move has been disabled.",
                Duration = 2
            })
        end
    end
})

-- Thêm ô nhập tốc độ trong tab Misc
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
                Title = "Speed Updated",
                Content = "Speed set to " .. flyspeed,
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

-- Thêm toggle cho tính năng "ESP Player" trong tab Misc
Tabs.Misc:AddToggle("EspPlayer", {
    Title = "ESP Player",
    Default = false,
    Callback = function(toggleValue)
        Aesp = toggleValue
        if Aesp then
            Fluent:Notify({
                Title = "ESP Player Enabled",
                Content = "ESP has been enabled.",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "ESP Player Disabled",
                Content = "ESP has been disabled.",
                Duration = 2
            })
        end
    end
})

-- Thêm ô nhập phần trăm máu trong tab Main
Tabs.Main:AddInput("HealthPercent", {
    Title = "Health %",
    Default = "20",
    Placeholder = "Enter Health Percent",
    Numeric = true,
    Callback = function(value)
        local HealhPercent = tonumber(value)
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

-- Thêm toggle cho chế độ "Safe Mode When Low Health" trong tab Main
Tabs.Main:AddToggle("SafeModeWhenLowHealth", {
    Title = "Safe Mode When Low Health",
    Default = false,
    Callback = function(toggleValue)
        if toggleValue then
            Fluent:Notify({
                Title = "Safe Mode Enabled",
                Content = "Low Health Protection enabled.",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Safe Mode Disabled",
                Content = "Low Health Protection disabled.",
                Duration = 2
            })
        end
    end
})

-- Thêm cài đặt trong tab Settings
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Chọn tab đầu tiên mặc định
Window:SelectTab(1)

-- Thông báo cuối cùng
Fluent:Notify({
    Title = "RielSick Hub",
    Content = "Script loaded successfully.",
    Duration = 5
})
