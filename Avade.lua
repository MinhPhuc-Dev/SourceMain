-- Tải thư viện Rayfield từ URL và lưu trữ trong biến Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo cửa sổ chính của giao diện với các thiết lập cụ thể
local Window = Rayfield:CreateWindow({
   Name = "Skibidi Hub🤡", -- Tên của cửa sổ giao diện
   Icon = 0, -- Biểu tượng cho cửa sổ (0 nghĩa là không có biểu tượng)
   LoadingTitle = "Skibidi hub🤡", -- Tiêu đề hiển thị khi đang tải giao diện
   LoadingSubtitle = "by Profess", -- Phụ đề hiển thị khi tải giao diện
   Theme = "Default", -- Chủ đề của giao diện
   DisableRayfieldPrompts = false, -- Không tắt các thông báo của Rayfield
   DisableBuildWarnings = false, -- Không tắt cảnh báo xây dựng giao diện
   ConfigurationSaving = { -- Thiết lập lưu cấu hình giao diện
      Enabled = true, -- Bật lưu cấu hình
      FolderName = nil, -- Thư mục để lưu (nil dùng mặc định)
      FileName = "Big Hub" -- Tên file lưu cấu hình
   },
   Discord = { -- Tích hợp Discord (nếu có)
      Enabled = false, -- Tắt tích hợp Discord
      Invite = "noinvitelink", -- Link mời Discord (để trống)
      RememberJoins = true -- Ghi nhớ các lần tham gia Discord
   },
   KeySystem = false, -- Tắt hệ thống yêu cầu nhập Key
   KeySettings = { -- Thiết lập hệ thống Key (nếu bật)
      Title = "Evade Hub | key", -- Tiêu đề cửa sổ nhập Key
      Subtitle = "Key System", -- Phụ đề cửa sổ nhập Key
      Note = "Hub nay duoc lam boi sigma", -- Ghi chú cho hệ thống Key
      FileName = "Key", -- Tên file lưu Key
      SaveKey = true, -- Lưu Key sau khi nhập
      GrabKeyFromSite = false, -- Không lấy Key từ website
      Key = {"12345"} -- Danh sách các Key hợp lệ
   }
})

-- Hiển thị thông báo khi script được tải xong
Rayfield:Notify({
   Title = "Script Loaded", -- Tiêu đề thông báo
   Content = "Skibidi Hub🤡 đã sẵn sàng sử dụng!", -- Nội dung thông báo
   Duration = 5, -- Thời gian hiển thị thông báo (giây)
   Image = nil, -- Không hiển thị hình ảnh
})

-- Tạo tab chính trong giao diện
local MainTab = Window:CreateTab("Home", nil) -- Tên Tab: "Home", không có hình ảnh

-- Tạo một phần (Section) trong tab chính
local Section = MainTab:CreateSection("Main") -- Tên của phần: "Main"

-- Hiển thị thông báo khác
Rayfield:Notify({
   Title = "Successfully", -- Tiêu đề thông báo
   Content = "Let him cook", -- Nội dung thông báo
   Duration = 5, -- Thời gian hiển thị thông báo (giây)
   Image = nil -- Không hiển thị hình ảnh
})

-- Biến để kiểm soát trạng thái bay
local flying = false
local speed = 50 -- Tốc độ bay của nhân vật

-- Thêm nút "Fly" vào giao diện
local Button = MainTab:CreateButton({
   Name = "Fly", -- Tên nút: "Fly"
   Callback = function()
      -- Kiểm tra trạng thái bay
      flying = not flying -- Đảo trạng thái (bật/tắt bay)

      -- Lấy nhân vật của người chơi
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

      -- Nếu trạng thái là bật bay
      if flying then
         Rayfield:Notify({
            Title = "Flying Enabled",
            Content = "You are flying!",
            Duration = 5,
         })

         -- Vòng lặp để giữ nhân vật bay
         spawn(function()
            while flying and humanoidRootPart do
               humanoidRootPart.Velocity = Vector3.new(0, speed, 0) -- Đẩy nhân vật lên
               wait(0.1) -- Giảm tải CPU
            end
         end)
      else
         Rayfield:Notify({
            Title = "Flying Disabled",
            Content = "Flying Disabled now",
            Duration = 5,
         })

         -- Tắt bay, đặt lại vận tốc
         if humanoidRootPart then
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
         end
      end
   end,
})
