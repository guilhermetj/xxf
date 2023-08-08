local locale = {}

locale['en'] = {
	invalid_command   = '[~r~ERROR~s~] Missing argument. Usage: /%s emote_id',
	invalid_command_2 = '[~r~ERROR~s~] %s is not a valid emote.',
	off_vehicle_only  = '[~r~ERROR~s~] You can\'t perform this animation while inside a vehicle.',
	keymapping_hint	  = 'Stop sensual/private dance',
	poledance_hint    = '~p~[E]~w~  DANCE',
	poledance_hint_2  = 'CHOOSE A STYLE: ~p~[1]~w~ ~p~[2]~w~ ~p~[3]~w~',
	poledance_hint_3  = 'CHOOSE A STYLE: ~p~[1]~w~ ~p~[2]~w~',
	scene_not_found   = '[~r~ERROR~s~] This style is not available for this map.'
}

locale['br'] = {
	invalid_command   = '[~r~ERRO~s~] Argumento faltando. Uso correto: /%s id_do_emote',
	invalid_command_2 = '[~r~ERRO~s~] %s não é um emote válido.',
	off_vehicle_only  = '[~r~ERRO~s~] Você não pode fazer essa animação de dentro de um veículo.',
	keymapping_hint	  = 'Parar dança sensual/privada',
	poledance_hint    = '~p~[E]~w~  DANÇAR',
	poledance_hint_2  = 'ESCOLHA UM ESTILO: ~p~[1]~w~ ~p~[2]~w~ ~p~[3]~w~',
	poledance_hint_3  = 'ESCOLHA UM ESTILO: ~p~[1]~w~ ~p~[2]~w~',
	scene_not_found   = '[~r~ERRO~s~] Esse estilo não está disponível para esse mapa.'
}

function _s(index, ...)
	local lang = locale[Config.Locale]
	if not lang then
		print('^1Locale [^7' .. Config.Locale .. '^1] does not exist, setting to default language.^7')
		Config.Locale = 'en'
		return _s(index)
	end

	if not lang[index] then return '' end
	if not {...} then return lang[index] else return (lang[index]):format(...) end
end