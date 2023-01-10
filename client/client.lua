local function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('mxd-lift:start', function()
    for k, coords in pairs(Config.Locations["mxdlift"]) do
        local src = source
        local ped = PlayerPedId()
		local pos = GetEntityCoords(PlayerPedId(), true)
		local pos2 = vector3(coords.from.x, coords.from.y, coords.from.z)
		local dist2 = (pos2 - pos)

		if #(dist2)<3 then 
		
			DoScreenFadeOut(500)
			while not IsScreenFadedOut() do
				Wait(10)
			end
			
			SetEntityCoords(ped, coords.to.x, coords.to.y, coords.to.z, 0, 0, 0, false)
			SetEntityHeading(ped, coords.from.w)
			
			if (Config.playsound) then
				TriggerEvent("InteractSound_CL:PlayOnOne", "lift", 0.5)
			end
			
			Wait(100)
			DoScreenFadeIn(1000)
			break
		end  
    end
end)

if Config.usetarget then
	for k, coords in pairs(Config.Locations["mxdlift"]) do
		exports['qb-target']:AddBoxZone("mxdlift"..k, vector3(coords.from.x, coords.from.y, coords.from.z), 2.0, 2.0, {
			name = "mxdlift"..k,
			heading = coords.from.w,
			debugPoly = false,
			minZ = coords.from.z-1,
			maxZ = coords.from.z+1,
		}, {
			options = {
				{
					type = "client",
					event = "mxd-lift:start",
					icon = "fas fa-elevator",
					label = coords.label,
				},
			},
			distance = 2.5
		})
	end
else
	CreateThread(function()
		while true do
			for k, coords in pairs(Config.Locations["mxdlift"]) do
				local pos = GetEntityCoords(PlayerPedId())
				local dist = #(pos - vector3(coords.from.x, coords.from.y, coords.from.z))
				if dist < 1.5 then
					DrawText3D(coords.from.x, coords.from.y, coords.from.z, "~g~E~w~ - "..coords.label)
				end
				if IsControlJustReleased(0, 38) then
					TriggerEvent("mxd-lift:start")
				end
			end
			Wait(5)
		end
	end)
end
