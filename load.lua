local SearchTable = function(Table)
	local Search = {}
	local Metatable = {}

	if Table then
		for Index, Value in next, Table do
			rawset(Metatable, Index, Value)
			local Characters = string.split(string.lower(tostring(Index)), "")

			local Table = Search
			for _, Character in next, Characters do
				rawset(Table, Character, rawget(Table, Character) or {Value})
				Table = rawget(Table, Character)
			end

			local Children = rawget(Table, 2)

			if Children then
				rawset(Children, #Children + 1, Value)
			else
				rawset(Table, 2, {Value})
			end
		end
	end

	return setmetatable(Metatable, {
		__call = function(self, Index)
			local Characters = string.split(string.lower(tostring(Index)), "")
			local Value = Search

			for _, Character in next, Characters do
				if rawget(Value, Character) then
					Value = rawget(Value, Character)
				else
					return nil
				end
			end

			return Value[2]
		end,
		__index = function(self, Index)
			local Characters = string.split(string.lower(tostring(Index)), "")

			local Value = Search

			for _, Character in next, Characters do
				if rawget(Value, Character) then
					Value = rawget(Value, Character)
				else
					return nil
				end
			end

			return Value[1]
		end,
		__newindex = function(self, Index, Value)
			rawset(self, tostring(Index), Value)
			local Characters = string.split(string.lower(tostring(Index)), "")

			local Table = Search
			for _, Character in next, Characters do
				rawset(Table, Character, rawget(Table, Character) or {Value})
				Table = rawget(Table, Character)

				local Children = rawget(Table, 2)

				if Children then
					rawset(Children, #Children + 1, Value)
				else
					rawset(Table, 2, {Value})
				end
			end
		end
	})
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Attack = ReplicatedStorage.RemoteEvents.HitPlayer
local Chat = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest

local Player = SearchTable()

for _, Instance in Players:GetPlayers() do
	Player[Instance.Name] = Instance
	Player[Instance.DisplayName] = Instance
end

Players.PlayerAdded:Connect(function(Instance)
	Player[Instance.Name] = Instance
	Player[Instance.DisplayName] = Instance
end)

local function Assassinate(Caller, Name)
	local Player = Player[Name]

	if Player == LocalPlaer then return end

	local Start = os.clock()

	repeat
		LocalPlayer.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame
		
		Attack:FireServer(Player.Character)

		task.wait()
	until Player.Character.Humanoid.Health <= 0 or (os.clock() - Start) >= 8

	if Player.Character.Humanoid.Health <= 0 then
		Chat:FireServer(string.format("/w %s TARGET ELIMINATED", Caller.Name), "All")
	end
end

local Whitelist = {
	["catalogizes"] = true,
	["Forekara"] = true,
	["4DBug"] = true
}

local function Chatted(Player)
	if Whitelist[Player.Name] then
		Player.Chatted:Connect(function(Message)
			local Args = string.split(Message, " ")
			print(table.concat(Args, ","))

			if (Args[1] == "/e" and Args[2] == "assassinate") then
				Assassinate(Player, Args[3])
			elseif Args[1] == "/w" then
				Assassinate(Player, Args[2])
			end
		end)
	end
end

for _, Player in Players:GetPlayers() do
	Chatted(Player)
end

Players.PlayerAdded:Connect(Chatted)
