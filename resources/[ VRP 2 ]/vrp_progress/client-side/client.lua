RegisterNetEvent("Progress")
AddEventHandler("Progress",function(time,text)
	SendNUIMessage({ type = "ui", display = true, time = time, text = text })
end)