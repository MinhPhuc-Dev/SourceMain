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

-- Biến kiểm soát trạng thái bay và tốc độ bay
local flying = false
local speed = 50 -- Tốc độ bay mặc định
local flyDirection = Vector3.zero -- Hướng di chuyển
local isJumping = false -- Kiểm tra nếu người chơi giữ phím nhảy
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
         -- Cập nhật hướng di chuyển dựa trên trạng thái
         if isJumping then
            flyDirection = Vector3.new(0, 1, 0) -- Bay lên
         else
            flyDirection = Vector3.new(0, 0, 0) -- Không thay đổi chiều cao
         end

         -- Xử lý phím di chuyển
         if not touchEnabled then
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
               flyDirection = flyDirection + Vector3.new(0, 0, -1) -- Tiến
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
               flyDirection = flyDirection + Vector3.new(0, 0, 1) -- Lùi
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
               flyDirection = flyDirection + Vector3.new(-1, 0, 0) -- Trái
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
               flyDirection = flyDirection + Vector3.new(1, 0, 0) -- Phải
            end
         end

         -- Cập nhật vận tốc bay
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

-- Lắng nghe sự kiện nhấn và nhả phím
local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input)
   if flying and input.KeyCode == Enum.KeyCode.Space then
      isJumping = true -- Người chơi đang nhảy
   end
end)

userInputService.InputEnded:Connect(function(input)
   if flying and input.KeyCode == Enum.KeyCode.Space then
      isJumping = false -- Người chơi ngừng nhảy
   end
end)

-- Thêm Toggle Fly vào giao diện
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

-- Thêm TextBox nhập tốc độ bay
local SpeedTextBox = MainTab:CreateTextBox({
   Name = "Speed Fly",
   Text = "50", -- Giá trị mặc định
   PlaceholderText = "Nhập tốc độ bay",
   ClearTextOnFocus = true,
   Callback = function(newSpeedText)
      local newSpeed = tonumber(newSpeedText)
      if newSpeed then
         speed = math.clamp(newSpeed, 10, 200) -- Đảm bảo tốc độ trong phạm vi hợp lệ
         Rayfield:Notify({
            Title = "Speed Updated",
            Content = "Tốc độ bay đã được đặt thành " .. speed,
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Invalid Input",
            Content = "Vui lòng nhập một số hợp lệ.",
            Duration = 3
         })
      end
   end
})
