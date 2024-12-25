-- Tải thư viện Rayfield từ URL và lưu trữ trong biến Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo cửa sổ chính của giao diện với các thiết lập cụ thể
local Window = Rayfield:CreateWindow({
   Name = "Skibidi Hub🤡",
   Icon = 0,
   LoadingTitle = "Skibidi hub🤡",
   LoadingSubtitle = "by Profess",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Hiển thị thông báo khi script được tải xong
Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Skibidi Hub🤡 đã sẵn sàng sử dụng!",
   Duration = 5,
   Image = nil
})

-- Tạo tab chính trong giao diện
local MainTab = Window:CreateTab("Home", nil)
local Section = MainTab:CreateSection("Main")

-- Biến kiểm soát trạng thái bay
local flying = false
local speed = 50 -- Tốc độ bay
local flyDirection = Vector3.zero -- Hướng di chuyển
local shiftLock = game.Players.LocalPlayer.DevEnableMouseLock -- Lưu trạng thái shift lock ban đầu

-- Kích hoạt chế độ Shift Lock
local function enableShiftLock()
   local player = game.Players.LocalPlayer
   player.DevEnableMouseLock = true
   player.DevComputerMovementMode = Enum.DevComputerMovementMode.KeyboardMouse
end

-- Vô hiệu hóa chế độ Shift Lock
local function disableShiftLock()
   local player = game.Players.LocalPlayer
   player.DevEnableMouseLock = shiftLock -- Khôi phục trạng thái shift lock ban đầu
end

-- Hàm bay
local function handleFly()
   local player = game.Players.LocalPlayer
   local character = player.Character or player.CharacterAdded:Wait()
   local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
   local userInputService = game:GetService("UserInputService")
   local touchEnabled = userInputService.TouchEnabled -- Kiểm tra nếu đang sử dụng mobile

   enableShiftLock() -- Bật Shift Lock khi bay

   spawn(function()
      while flying and humanoidRootPart do
         -- Xử lý di chuyển
         if touchEnabled then
            -- Mobile: Lấy hướng từ joystick
            local moveDirection = game:GetService("Players").LocalPlayer.DevTouchMovementMode
            if moveDirection then
               flyDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z)
            end
         else
            -- PC: Xử lý phím nhấn
            userInputService.InputBegan:Connect(function(input)
               if input.KeyCode == Enum.KeyCode.Space then
                  flyDirection = Vector3.new(0, 1, 0) -- Bay lên khi nhấn Space
               elseif input.KeyCode == Enum.KeyCode.W then
                  flyDirection = flyDirection + Vector3.new(0, 0, -1) -- Tiến
               elseif input.KeyCode == Enum.KeyCode.S then
                  flyDirection = flyDirection + Vector3.new(0, 0, 1) -- Lùi
               elseif input.KeyCode == Enum.KeyCode.A then
                  flyDirection = flyDirection + Vector3.new(-1, 0, 0) -- Trái
               elseif input.KeyCode == Enum.KeyCode.D then
                  flyDirection = flyDirection + Vector3.new(1, 0, 0) -- Phải
               end
            end)

            userInputService.InputEnded:Connect(function(input)
               if input.KeyCode == Enum.KeyCode.Space then
                  flyDirection = flyDirection - Vector3.new(0, 1, 0)
               elseif input.KeyCode == Enum.KeyCode.W then
                  flyDirection = flyDirection - Vector3.new(0, 0, -1)
               elseif input.KeyCode == Enum.KeyCode.S then
                  flyDirection = flyDirection - Vector3.new(0, 0, 1)
               elseif input.KeyCode == Enum.KeyCode.A then
                  flyDirection = flyDirection - Vector3.new(-1, 0, 0)
               elseif input.KeyCode == Enum.KeyCode.D then
                  flyDirection = flyDirection - Vector3.new(1, 0, 0)
               end
            end)
         end

         -- Cập nhật hướng và vận tốc
         humanoidRootPart.Velocity = flyDirection.Unit * speed
         wait(0.1)
      end

      -- Đặt lại vận tốc khi dừng bay
      if humanoidRootPart then
         humanoidRootPart.Velocity = Vector3.zero
      end
      disableShiftLock() -- Tắt Shift Lock khi ngừng bay
   end)
end

-- Thêm Toggle vào giao diện
local FlyToggle = MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(toggleValue)
      flying = toggleValue
      if flying then
         Rayfield:Notify({
            Title = "Flying Enabled",
            Content = "Bạn đang bay!",
            Duration = 5
         })
         handleFly() -- Gọi hàm bay
      else
         Rayfield:Notify({
            Title = "Flying Disabled",
            Content = "Bạn đã dừng bay!",
            Duration = 5
         })
      end
   end
})
