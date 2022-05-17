local QBCore = exports['qb-core']:GetCoreObject()

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
			Wait(100)
			DoScreenFadeIn(1000)
			break
		end  
    end
end)

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
				label = "Take Lift",
			},
		},
		distance = 2.5
	})
end
