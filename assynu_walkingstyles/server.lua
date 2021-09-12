local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

RegisterServerEvent('assynu_animacje:stylchodzeniaserver')
AddEventHandler('assynu_animacje:stylchodzeniaserver', function(x, anim)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./walkingstyles.json")  
	local _source = source
	local chodzenie = {}
	local newchodzenie = {}
	local xPlayer = ESX.GetPlayerFromId(_source)
	local found = false
	chodzenie = json.decode(loadFile)
	if x == 'get' then
		if chodzenie ~= nil then
			for k,v in pairs(chodzenie) do
				if v.identifier == xPlayer.getIdentifier() and v.digit == xPlayer.digit then
					TriggerClientEvent('assynu_animacje:stylchodzeniaclient', _source, v.anim)
					found = true
				end
			end
			if not found then
				TriggerClientEvent('assynu_animacje:stylchodzeniaclient', _source, 'default')
			end
		end
	elseif x == 'update' then
		if chodzenie ~= nil then
			for k,v in pairs(chodzenie) do
				if v.identifier == xPlayer.getIdentifier() and v.digit == xPlayer.digit then
				else
					table.insert(newchodzenie, v)
				end
			end
		end
		if anim ~= 'default' then 
			local newstyle = {identifier = xPlayer.getIdentifier(), digit = xPlayer.digit, anim = anim}
			table.insert(newchodzenie, newstyle)
		end
		SaveResourceFile(GetCurrentResourceName(), "walkingstyles.json", json.encode(newchodzenie), -1)
	end
end)