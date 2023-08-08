Config = {}
Config.Locale = 'en'

Config.ItemName = 'ficha' -- The chip item in DB

Config.PrintClient = false -- Print on client's console the spins in case of object bug
Config.Offset = false -- Adicione 30% de propabilidade para parar os giros na posição errada

Config.HideUI = false
Config.HideUIEvent = 'pma-voice:toggleui'
Config.ShowUIEvent = 'pma-voice:toggleui'

Config.Mult = { -- Multipliers based on GTA:ONLINE
	['1'] = 25,	
	['2'] = 35,
	['3'] = 45,
	['4'] = 55,
	['5'] = 65,
	['6'] = 70,
	['7'] = 100,
}

Config.Slots = {
	[1] = { -- Diamonds
		pos = vector3(1114.69, 236.03, -49.84),		-- Slot's position
		bet = 2500,									-- Hou much chips will take for each spin
		prop = 'vw_prop_casino_slot_01a',			-- The name of the spin object
		prop1 = 'vw_prop_casino_slot_01a_reels',	-- The name of the reel inside the slot
		prop2 = 'vw_prop_casino_slot_01b_reels',	-- The name of the blur reel inside the slot
	},
	[2] = { -- Diamonds
		pos = vector3(1102.58, 231.89, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_07a',
		prop1 = 'vw_prop_casino_slot_07a_reels',
		prop2 = 'vw_prop_casino_slot_07b_reels',
	},
	[3] = { -- Diamonds
		pos = vector3(1107.23, 233.77, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_07a',
		prop1 = 'vw_prop_casino_slot_07a_reels',
		prop2 = 'vw_prop_casino_slot_07b_reels',
	},
	[4] = { -- Diamonds
		pos = vector3(1116.82, 228.12, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_07a',
		prop1 = 'vw_prop_casino_slot_07a_reels',
		prop2 = 'vw_prop_casino_slot_07b_reels',
	},
	
	
	
	
	[5] = { -- Fortune And Glory
		pos = vector3(1103.44, 231.21, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_05a',
		prop1 = 'vw_prop_casino_slot_05a_reels',
		prop2 = 'vw_prop_casino_slot_05b_reels',
	},
	[6] = { -- Fortune And Glory
		pos = vector3(1118.61, 229.42, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_05a',
		prop1 = 'vw_prop_casino_slot_05a_reels',
		prop2 = 'vw_prop_casino_slot_05b_reels',
	},
	[7] = { -- Fortune And Glory
		pos = vector3(1112.83, 233.48, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_04a',
		prop1 = 'vw_prop_casino_slot_04a_reels',
		prop2 = 'vw_prop_casino_slot_04b_reels',
	},
	[8] = { -- Fortune And Glory
		pos = vector3(1109.79, 234.25, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_05a',
		prop1 = 'vw_prop_casino_slot_05a_reels',
		prop2 = 'vw_prop_casino_slot_05b_reels',
	},
	
	
	
	[9] = { -- Have A Stab
		pos = vector3(1105.48, 228.53, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_03a',
		prop1 = 'vw_prop_casino_slot_03a_reels',
		prop2 = 'vw_prop_casino_slot_03b_reels',
	},
	[10] = { -- Have A Stab
		pos = vector3(1109.71, 233.92, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_06a',
		prop1 = 'vw_prop_casino_slot_06a_reels',
		prop2 = 'vw_prop_casino_slot_06b_reels',
	},
	[11] = { -- Have A Stab
		pos = vector3(1113.52, 238.25, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_06a',
		prop1 = 'vw_prop_casino_slot_06a_reels',
		prop2 = 'vw_prop_casino_slot_06b_reels',
	},
	[12] = { -- Have A Stab
		pos = vector3(1102.58, 231.89, -49.84),
		bet = 2500,
		prop = 'vw_prop_casino_slot_06a',
		prop1 = 'vw_prop_casino_slot_06a_reels',
		prop2 = 'vw_prop_casino_slot_06b_reels',
	},
	
	
}




Config.Wins = { -- DO NOT TOUCH IT
	[1] = '2',
	[2] = '3',
	[3] = '6',
	[4] = '2',
	[5] = '4',
	[6] = '1',
	[7] = '6',
	[8] = '5',
	[9] = '2',
	[10] = '1',
	[11] = '3',
	[12] = '6',
	[13] = '7',
	[14] = '1',
	[15] = '4',
	[16] = '5',
}