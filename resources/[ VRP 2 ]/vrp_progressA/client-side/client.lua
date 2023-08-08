RegisterNetEvent("Progress")
AddEventHandler("Progress",function(time,text)
	SendNUIMessage({ display = true, time = time, text = text })
end)