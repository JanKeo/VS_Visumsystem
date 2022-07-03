local playertime = {}
local playervisum = {}
local playercurrenttime = {}


MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM Visum", {}, function(result)	
        for i=1, #result, 1 do
            playertime[result[i].identifier] = result[i].time
            playervisum[result[i].identifier] = result[i].visumlevel
		end
    end)
end)



RegisterNetEvent("vs:onlogin")
AddEventHandler("vs:onlogin", function()
	local _source = source	
    local identifier = GetPlayerIdentifiers(_source)[1]
    local currenttime = os.time()
   
    if playertime[identifier] ~= nil then
        playercurrenttime[identifier] = currenttime
    else        
        playercurrenttime[identifier] = currenttime
        playertime[identifier] = 0
        playervisum[identifier] = 0
        MySQL.Async.execute("INSERT INTO Visum (identifier, time, visumlevel) VALUES (@identifier, @time, @visumlevel)",
            { ["identifier"] = identifier, ["time"] = 0, ["visumlevel"] = 0},
            function()
            end
        )
    end
end)

function ExchangefromSeconds(seconds)
    if seconds ~= nil then
        local seconds = tonumber(seconds)
        hours = string.format("%2.f", math.floor(seconds/3600))
        mins = string.format("%2.f", math.floor(seconds/60 - hours * 60));
        return " "..hours..":"..mins
    end
end

function updatev(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local currenttime = os.time()

        local time = tonumber(currenttime - playercurrenttime[identifier])
        local timeFormatted = ExchangefromSeconds(time)
        local Fulltime = time + playertime[identifier]
        CheckVisum(source, Fulltime)

        MySQL.Async.execute("UPDATE Visum SET time = @time WHERE identifier = @identifier",
            {["time"] = Fulltime, ["identifier"] = identifier},
            function()
            end
        )
        playertime[identifier] = Fulltime
        playercurrenttime[identifier] = currenttime
end

function CheckVisum(source, time)
    local _source = source 
    local Fulltime = tonumber(time)
    local identifier = GetPlayerIdentifiers(_source)[1]
    if playervisum[identifier] ~= math.floor(Fulltime/7200) then
        local visumlevel = math.floor(Fulltime/7200)
        MySQL.Async.execute("UPDATE Visum SET visumlevel = @visumlevel WHERE identifier = @identifier",
            {["visumlevel"] = visumlevel, ["identifier"] = identifier},
            function()
            end
        )
        playervisum[identifier] = visumlevel
        TriggerClientEvent("vs:sendmsg1", _source, "Du hast eine neue Visumstufe erreicht. Deine neue Visum Stufe beträgt: "..visumlevel)
    end


end


RegisterNetEvent("vs:sendplaytime")
AddEventHandler("vs:sendplaytime", function()
    local _source = source
    local identifier = GetPlayerIdentifiers(_source)[1]
    local Formattedplaytime = ExchangefromSeconds(playertime[identifier])
    TriggerClientEvent("vs:sendmsg1", _source, "Deine Spielzeit beträgt"..Formattedplaytime)
end)

RegisterNetEvent("vs:sendvisum")
AddEventHandler("vs:sendvisum", function()
    local _source = source
    local identifier = GetPlayerIdentifiers(_source)[1]
    local Formattedvisum = tonumber(playervisum[identifier])
    if playervisum[identifier] ~= nil then
        TriggerClientEvent("vs:sendmsg1", _source, "Deine Visum Stufe beträgt: "..Formattedvisum)
    else
        TriggerClientEvent("vs:sendmsg1", _source, "Du hast kein Visum!")
    end

end)

RegisterServerEvent("vs:updatev")
AddEventHandler("vs:updatev", function()
_source = source
updatev(_source)
end)



