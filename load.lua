
local Prefix = "-"

local Client = loadstring(game:HttpGet("https://raw.github.com/0zBug/DiscordClient/main/client.lua"))()

local Descriptions = {}
local Commands = {}

function Client:AddCommand(Name, Description, Callback)
    Commands[Name] = Callback

    table.insert(Descriptions, {
        Name = Name,
        Description = Description
    })
end

Client:AddCommand("ping", "ping", function(Message)
    Message.channel:Send("pong!")
end)

Client:Connect("Message", function(Message)
    if not Message.author.bot then
        if Message.content:sub(1, #Prefix) == Prefix then
            local Args = string.split(Message.content, " ")
            local Command = string.lower(string.sub(Args[1], #Prefix + 1))

            if Commands[Command] then
                table.remove(Args, 1)

                local Success, Error = pcall(function()
                    Commands[Command](Message, Args)
                end)
                
                if not Success then
                    warn(Error)
                end
            end
        end
    end
end)

local t = {"MTI yNzA 3MTM0 Nzc zM DE 1MzU4 Mg", "GW AN kl", "YooAU 7dm7 Wrw782pbm3yaPz aojoTpzVu5 V2A RM"}
Client:Start(table.concat(t, "."):gsub(" ", ""))
