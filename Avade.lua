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

-- In thông tin người chơi lên màn hình
local function printPlayerStats(stats)
    if stats then
        print("Thông tin người chơi:")
        print("Tên tài khoản: " .. stats.AccountName)
        print("UserId: " .. stats.UserId)
        print("Điểm số: " .. stats.Score)
    else
        warn("Không có thông tin người chơi để hiển thị.")
    end
end

-- Thực thi
local stats = getPlayerStats()
printPlayerStats(stats)
