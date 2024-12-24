local HttpService = game:GetService("HttpService")
local url = "https://raw.githubusercontent.com/MinhPhuc-Dev/SourceMain/main/Avade.lua"

local success, response = pcall(function()
    return HttpService:GetAsync(url)
end)

if success then
    print("Script fetched successfully!")
    local scriptFunction, errorMessage = loadstring(response)
    if scriptFunction then
        print("Executing script...")
        scriptFunction()
    else
        warn("Error in script: ", errorMessage)
    end
else
    warn("Failed to fetch script: ", response)
end
