
BJCore = nil
isLoggedIn = false

CreateThread(function()
    while BJCore == nil do
        TriggerEvent('BJCore:GetObject', function(obj) BJCore = obj end)
        Wait(200)
    end
end)

CreateThread(function() -- Loop don't touch if you don't know what you doing
	while true do
		GLOBAL_PED = PlayerPedId()
		GLOBAL_PLYID = PlayerId()
		GLOBAL_SRVID = GetPlayerServerId(GLOBAL_PLYID)
		Wait(5000)
	end
end)

CreateThread(function() -- Loop don't touch if you don't know what you doing
    while true do
        if GLOBAL_PED then
            GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED)
        end
        Wait(200)
    end
end)

--[[ Citizen.CreateThread(function()
	while true do
		--GLOBAL_PEDINVEH = IsPedInAnyVehicle(GLOBAL_PED, false)
		if IsPedInAnyVehicle(GLOBAL_PED, false) then
			GLOBAL_PEDVEH = GetVehiclePedIsIn(GLOBAL_PED, false)
		end
		Wait(500)
	end
end) ]]

RegisterNetEvent('BJCore:Client:OnPlayerLoaded')
AddEventHandler('BJCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = BJCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('BJCore:Client:OnPlayerUnload')
AddEventHandler('BJCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('BJCore:Client:OnJobUpdate')
AddEventHandler('BJCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)



CreateThread(function() -- Loop don't touch if you don't know what you doing
	while GLOBAL_COORDS == nil do Wait(100); end
    while true do
	local active = false
	local sleep = 7
	if isLoggedIn and BJCore ~= nil then
		for k, v in pairs(Config.Locations["entercoke"]) do
			local takeAway = vector3(v.x, v.y, v.z)
			local dist = #(GLOBAL_COORDS - takeAway)
			if dist <= 1.5 then
				active = true
				DrawText3D(takeAway.x, takeAway.y, takeAway.z, "~g~E~w~ - To enter coke lab")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Wait(10)
					end

					cokelab = k

					local coords = Config.Locations["exitcoke"][cokelab]
					SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), coords.h)

					Wait(100)

					DoScreenFadeIn(1000)
				end
			end
		end
		
		for k, v in pairs(Config.Locations["exitcoke"]) do
			local takeAway = vector3(v.x, v.y, v.z)
			local dist = #(GLOBAL_COORDS - takeAway)
			if dist <= 1.5 then
				active = true
				DrawText3D(takeAway.x, takeAway.y, takeAway.z, "~g~E~w~ - Exit coke lab")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Wait(10)
					end

					currentHospital = k

					local coords = Config.Locations["entercoke"][currentHospital]
					SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), coords.h)

					Wait(100)

					DoScreenFadeIn(1000)
				end
			end
		end

		for k, v in pairs(Config.Locations["entermeth"]) do
			local takeAway = vector3(v.x, v.y, v.z)
			local dist = #(GLOBAL_COORDS - takeAway)
			if dist <= 1.5 then
				active = true
				DrawText3D(takeAway.x, takeAway.y, takeAway.z, "~g~E~w~ - To enter meth lab")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Wait(10)
					end

					currentHospital = k

					local coords = Config.Locations["exitmeth"][currentHospital]
					SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), coords.h)

					Wait(100)

					DoScreenFadeIn(1000)
				end
			end
		end
		
		for k, v in pairs(Config.Locations["exitmeth"]) do
			local takeAway = vector3(v.x, v.y, v.z)
			local dist = #(GLOBAL_COORDS - takeAway)
			if dist <= 1.5 then
				active = true
				DrawText3D(takeAway.x, takeAway.y, takeAway.z, "~g~E~w~ - Exit meth lab")
				if IsControlJustReleased(0, Keys["E"]) then
					DoScreenFadeOut(500)
					while not IsScreenFadedOut() do
						Wait(10)
					end

					currentHospital = k

					local coords = Config.Locations["entermeth"][currentHospital]
					SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, 0, 0, 0, false)
					SetEntityHeading(PlayerPedId(), coords.h)

					Wait(100)

					DoScreenFadeIn(1000)
				end
			end
		end

		local checkin = vector3(Config.Locations["checking"].x, Config.Locations["checking"].y, Config.Locations["checking"].z)
		local checkindis = #(GLOBAL_COORDS - checkin)
		if checkindis <= 1.5 then
			active = true
			BJCore.Functions.DrawText3D(checkin.x, checkin.y, checkin.z, "[E] - Call doctor")
			if IsControlJustReleased(0, Keys["E"]) then
				BJCore.Functions.Progressbar("hospital_checkin", "Checking in..", 2000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					local bedId = GetAvailableBed()
					if bedId ~= nil then 
						TriggerServerEvent("hospital:server:SendToBed", bedId, true)
					else
						TriggerEvent("DoShortHudText", "Beds are occupied..", 2)
					end
				end, function() -- Cancel
					TriggerEvent("DoShortHudText", "Checking in failed!", 2)
				end)
			end
		end

	end
	if not active then
		sleep = 1000
	end

	Wait(sleep)
    end
end) -- end of loop


function DrawText3D(x, y, z, text)
	SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
