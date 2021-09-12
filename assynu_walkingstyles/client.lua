ESX = nil
local PlayerData = {}
local currentwalkingstyle = 'default'

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end


	Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
	if not binds then
		TriggerServerEvent('esx_animations:load')
	end
end)

RegisterCommand('walking-style', function()
  OpenWalkMenu()
end)

function OpenWalkMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Styl_chodzenia',
	{
		title    = 'Styl chodzenia',
		align    = 'bottom-right',
		elements = Config.Styles
	}, function(data, menu)
		setwalkstyle(data.current.value)
		TriggerServerEvent('assynu_animacje:stylchodzeniaserver', 'update', data.current.value)
		currentwalkingstyle = data.current.value
	end, function(data, menu)
		menu.close()
	end)
end

function setwalkstyle(anim)
	local playerped = PlayerPedId()

	if anim == 'default' then
		ResetPedMovementClipset(playerped)
		ResetPedWeaponMovementClipset(playerped)
		ResetPedStrafeClipset(playerped)
	else
		RequestAnimSet(anim)
		while not HasAnimSetLoaded(anim) do Citizen.Wait(0) end
		SetPedMovementClipset(playerped, anim)
		ResetPedWeaponMovementClipset(playerped)
		ResetPedStrafeClipset(playerped)
	end
end

Citizen.CreateThread(function()
	while true do
		local playerhp = GetEntityHealth(PlayerPedId())-100
		if (playerhp > 50) then
			setwalkstyle(currentwalkingstyle)
		else
			setwalkstyle('move_m@injured')
		end
		Wait(10000)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	TriggerServerEvent('assynu_animacje:stylchodzeniaserver', 'get')
end)  

RegisterNetEvent('assynu_animacje:stylchodzeniaclient')
AddEventHandler('assynu_animacje:stylchodzeniaclient', function(walkstyle)
	setwalkstyle(walkstyle)
	currentwalkingstyle = walkstyle
end)
