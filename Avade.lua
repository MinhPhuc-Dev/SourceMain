local HttpService = game:GetService("HttpService")

-- URL raw của file GitHub
local url = "https://raw.githubusercontent.com/MinhPhuc-Dev/SourceMain/main/Avade.lua"

-- Sử dụng loadstring để tải và thực thi script
local success, response = pcall(function()
    return HttpService:GetAsync(url)
end)

if success then
    local scriptFunction, errorMessage = loadstring(response)
    if scriptFunction then
        print("Script loaded successfully!")
        scriptFunction() -- Chạy script
    else
        warn("Error executing script: " .. errorMessage)
    end
else
    warn("Failed to fetch script: " .. response)
end
