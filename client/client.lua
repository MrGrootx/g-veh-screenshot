-- RegisterCommand("screenshotcar", function(source, args, rawCommand)
-- 	-- cam = CreateCamWithParams(
-- 	-- 	"DEFAULT_SCRIPTED_CAMERA",
-- 	-- 	-33.3211,
-- 	-- 	-1133.9908,
-- 	-- 	26.5944,
-- 	-- 	81.1619,
-- 	-- 	0.00,
-- 	-- 	0.00,
-- 	-- 	60.00,
-- 	-- 	false,
-- 	-- 	0
-- 	-- )
-- 	-- PointCamAtCoord(cam, -33.3211, -1133.9908, 26.5944)
-- 	-- SetCamActive(cam, true)
-- 	-- SetCamFov(cam, 45.0)
-- 	-- SetCamRot(cam, -15.0, 0.0, 252.063)
-- 	-- RenderScriptCams(true, true, 1, true, true)
-- 	-- SetFocusPosAndVel(-33.3211, -1133.9908, 26.5944, 0.0, 0.0, 0.0)
-- 	-- DisplayHud(false)
-- 	-- DisplayRadar(false)

-- 	TriggerEvent("justgroot:takevehphoto")
-- end, false)

RegisterCommand("screenshotcar", function(source, args, rawCommand)
	TriggerEvent("justgroot:takevehphoto")
end, false)

RegisterNetEvent("justgroot:takevehphoto")
AddEventHandler("justgroot:takevehphoto", function()
	DisplayHud(false)
	DisplayRadar(false)
	FreezeEntityPosition(PlayerPedId(), true)

	-- Create the camera
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

	-- Coordinates for the camera to be positioned relative to the vehicle
	local vehicleCoords = Config.Veh.displaycars[1].coord
	local camX = vehicleCoords.x + 5.0 -- 5 units behind the vehicle
	local camY = vehicleCoords.y + 5.0 -- 5 units to the side of the vehicle
	local camZ = vehicleCoords.z + 3.0 -- 3 units above the vehicle

	-- Set the camera coordinates and activate it
	SetCamCoord(cam, camX, camY, camZ)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 0, true, false)

	-- Get the vehicle model and create the vehicle
	local model = Config.Veh.displaycars[1].model
	local hash = GetHashKey(model)

	if IsModelInCdimage(hash) and IsModelValid(hash) then
		if not HasModelLoaded(hash) then
			RequestModel(hash)
			while not HasModelLoaded(hash) do
				Wait(0)
			end
		end

		local vehicle =
			CreateVehicle(hash, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, vehicleCoords.w, false, true)
		SetModelAsNoLongerNeeded(hash)
		FreezeEntityPosition(vehicle, true)

		-- Point the camera at the vehicle
		PointCamAtEntity(cam, vehicle, 0.0, 0.0, 0.0, true)
		SetFocusEntity(vehicle)

		Wait(500)

		exports["screenshot-basic"]:requestScreenshot(function(data)
			local response = json.decode(data)
			print(response)
			TriggerEvent(
				"chat:addMessage",
				{ template = '<img src="{0}" style="max-width: 300px;" />', args = { data } }
			)
		end)

		
	end

	-- Wait before cleaning up to ensure the screenshot is taken
	Wait(2000)

	-- Cleanup and restore player state
	ClearFocus()
	DisplayHud(true)
	DisplayRadar(true)
	FreezeEntityPosition(PlayerPedId(), false)
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(cam, false)
	SetCamActive(cam, false)
end)
