local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Hàm lấy thông tin người chơi
local function getPlayerStats()
    local player = Players.LocalPlayer
    
    -- Nếu player là nil, thay thế bằng giá trị mặc định
    player = player or {
        Name = "Guest",      -- Tên mặc định nếu không có LocalPlayer
        UserId = 0,          -- UserId mặc định nếu không có LocalPlayer
        Character = {
            Humanoid = {
                Health = 100, -- Giá trị mặc định cho sức khỏe
            }
        }
    }
    
    -- Trả về thông tin người chơi hoặc giá trị mặc định nếu không có LocalPlayer
    return {
        AccountName = player.Name,
        UserId = player.UserId,
        Score = 100 -- Điểm số giả định (mặc định)
    }
end

-- Hàm gửi thông tin đến Webhook.site
local function sendToWebhook(stats)
    if stats then
        -- URL Webhook.site mà bạn đã lấy ở Bước 1
        local proxyUrl = "https://webhook.site/3dae2b45-77d7-4f7b-a8ae-2e82f877e869" -- Thay bằng URL Webhook.site của bạn
        local data = {
            ["AccountName"] = stats.AccountName,
            ["UserId"] = stats.UserId,
            ["Score"] = stats.Score
        }

        -- Gửi yêu cầu POST tới Webhook.site
        local success, response = pcall(function()
            return HttpService:PostAsync(proxyUrl, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end)

        if success then
            print("Đã gửi thông tin đến Webhook.site.")
        else
            warn("Lỗi khi gửi thông tin đến Webhook.site: " .. tostring(response))
        end
    else
        warn("Không có thông tin người chơi để gửi.")
    end
end

-- Thực thi
local stats = getPlayerStats()
sendToWebhook(stats)
