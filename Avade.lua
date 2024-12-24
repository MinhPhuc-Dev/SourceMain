local HttpService = game:GetService("HttpService")
local url = "https://raw.githubusercontent.com/MinhPhuc-Dev/SourceMain/main/Avade.lua"

local success, response = pcall(function()
    return HttpService:GetAsync(url)
end)

if success then
    print("Script fetched successfully!")
    -- Kiểm tra nội dung trước khi thực thi
    if string.find(response, "game") or string.find(response, "HttpService") then
        warn("Script contains potentially unsafe operations!")
    else
        local scriptFunction, errorMessage = loadstring(response)
        if scriptFunction then
            scriptFunction()
        else
            warn("Error in script: ", errorMessage)
        end
    end
else
    warn("Failed to fetch script: ", response)
end
