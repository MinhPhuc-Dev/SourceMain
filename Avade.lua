local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Evade Hub🤡",
   Icon = 0,
   LoadingTitle = "Evade Hub🤡",
   LoadingSubtitle = "by Sigma_Male",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
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
   KeySystem = true,
   KeySettings = {
      Title = "Evade Hub | key",
      Subtitle = "Key System",
      Note = "Hub nay duoc lam boi sigma",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"12345"}
   }
})

local MainTab = Window:CreateTab("Home", nil) -- Title, Image
local Section = MainTab:CreateSection("Main") -- Đổi từ Tab thành MainTab

Rayfield:Notify({
   Title = "Successfully",
   Content = "Let him cook",
   Duration = 5,
   Image = nil,
})

local Button = MainTab:CreateButton({
   Name = "Fly",
   Callback = function()
      -- Thêm mã bay (fly code) vào đây
   end,
})
