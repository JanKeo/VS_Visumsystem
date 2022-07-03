local Spawn = false

AddEventHandler('playerSpawned', function()
	if Spawn == false then
		TriggerServerEvent('vs:onlogin')
		Spawn = true
	end
end)

RegisterCommand('playtime', function(source)
	TriggerServerEvent('vs:sendplaytime')
end, false)

RegisterCommand("visum", function(source)
	TriggerServerEvent("vs:sendvisum")
end)

RegisterNetEvent("vs:sendmsg1")
AddEventHandler("vs:sendmsg1", function(msg)
	notify(msg)
end)

function notify(msg)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, true)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		TriggerServerEvent("vs:updatev")
	end
end)