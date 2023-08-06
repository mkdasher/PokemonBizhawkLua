Program = {
	selectedPokemon = {},
	trainerPokemonTeam = {},
	enemyPokemonTeam = {},
	trainerInfo = {}
}
Program.rng = {
	current = 0,
	previous = 0,
	grid = {}
}
Program.map = {
	id = 0,
	encounters = {
		{
			encrate = -1,
			SLOTS = 12,
			RATES = {20,20,10,10,10,10,5,5,4,4,1,1}
		},
		{
			encrate = -1,
			SLOTS = 5,
			RATES = {60,30,5,4,1}
		},
		{
			encrate = -1,
			SLOTS = 5,
			RATES = {60,30,5,4,1}
		}
	}
}
Program.catchdata = {
	pokemon = 1,
	curHP = 20,
	maxHP = 20,
	level = 5,
	ball = 4,
	status = 0,
	rng = 0,
	rate = 0
}

function Program.main()
	Input.update()
	Program.trainerPokemonTeam = Program.getTrainerData(1)
	Program.enemyPokemonTeam = Program.getTrainerData(2)
	Program.trainerInfo = Program.getTrainerInfo()
	if LayoutSettings.showRightPanel then
		local pokemonaux = Program.getPokemonData(LayoutSettings.pokemonIndex)
		if Program.validPokemonData(pokemonaux) then
			Program.selectedPokemon = pokemonaux
		end
		Drawing.drawPokemonView()
		Drawing.drawGeneralInfo()
	end
	if LayoutSettings.menus.main.selecteditem == LayoutSettings.menus.main.RNG then
		if LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.ENCOUNTER then
			local mapid = Memory.readword(GameSettings.mapbank)
			if (mapid ~= Program.map.id) then
				Program.map.id = mapid
				Program.updateEncounterData()
			end
		elseif LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.CATCH then
			Program.updateCatchData()
			Drawing.drawCatchRate()
		end
		RNG.update()
		Drawing.drawRNGPanel()
	elseif LayoutSettings.menus.main.selecteditem == LayoutSettings.menus.main.MAP then
		Drawing.drawMap()
	end
	Drawing.drawButtons()
	Drawing.drawLayout()
end

function Program.getTrainerInfo()
	local trainer = Memory.readdword(GameSettings.trainerpointer)
	if Memory.readbyte(trainer) == 0 then
		return {
			gender = -1,
			tid = 0,
			sid = 0
		}
	else
		return {
			gender = Memory.readbyte(trainer + 8),
			tid = Memory.readword(trainer + 10),
			sid = Memory.readword(trainer + 12)
		}
	end
end

function Program.updateCatchData()
	if LayoutSettings.menus.catch.selecteditem == LayoutSettings.menus.catch.AUTO then
		local pokemonaux = Program.getPokemonData({player = 2, slot = 1})
		if Program.validPokemonData(pokemonaux) then
			Program.catchdata.pokemon = pokemonaux.pokemonID
			Program.catchdata.curHP = pokemonaux.curHP 
			Program.catchdata.maxHP = pokemonaux.maxHP 
			Program.catchdata.level = pokemonaux.level
			Program.catchdata.status = pokemonaux.status
		end
	end
	
	local m = Program.catchdata.maxHP
	local h = Program.catchdata.curHP
	local c = PokemonData.catchrate[Program.catchdata.pokemon + 1]
	
	local s = 1
	if Program.catchdata.status == 1 or Program.catchdata.status == 4 then
		s = 2
	elseif Program.catchdata.status > 1 then
		s = 1.5
	end
	
	local b = 1
	if Program.catchdata.ball == 2 then
	elseif Program.catchdata.ball == 2 then
		b = 1.5
	elseif Program.catchdata.ball == 3 then
		b = 1.5
	elseif Program.catchdata.ball == 5 then
		b = 1.5
	end
	
	local x = math.floor((3 * m - 2 * h) * math.floor(c * b))
	x = math.floor(x / (3*m))
	x = math.floor(x * s)
	
	local y = 65536
	if (x < 255 and Program.catchdata.ball > 1) then		
		y = math.floor(math.sqrt(16711680 / x))
		y = math.floor(math.sqrt(y))
		y = math.floor(1048560 / y)
	end
	Program.catchdata.rng = y
	Program.catchdata.rate = (y/65536) * (y/65536) * (y/65536) * (y/65536)
end

function Program.updateEncounterData()
	-- Search map in ROM's table
	if Program.map.id == 0 then
		Program.map.encounters[1].encrate = -1
		Program.map.encounters[2].encrate = -1
		Program.map.encounters[3].encrate = -1
		return
	end
	local mapid_aux = Memory.readword(GameSettings.encountertable)
	local index = 0
	while mapid_aux ~= Program.map.id do
		index = index + 1
		mapid_aux = Memory.readword(GameSettings.encountertable + 20*index)
		if mapid_aux == 0xFFFF then
			Program.map.encounters[1].encrate = -1
			Program.map.encounters[2].encrate = -1
			Program.map.encounters[3].encrate = -1
			return
		end
	end
	
	-- Search encounter data
	for i=1,3,1 do
		local minl = {}
		local maxl = {}
		local pkm = {}
		local pointer = Memory.readdword(GameSettings.encountertable + 20*index + 4*i)
		if pointer == 0 then
			Program.map.encounters[i].encrate = -1
		else
			local ratio = Memory.readword(pointer)
			if ratio == 0xFFFF then
				Program.map.encounters[i].encrate = -1
			else
				Program.map.encounters[i].encrate = ratio
				Program.map.encounters[i].pokemon = {}
				pointer = Memory.readdword(pointer + 4)
				for j = 1, Program.map.encounters[i].SLOTS,1 do
					local pkmdata = Memory.readdword(pointer + (j-1)*4)
					Program.map.encounters[i].pokemon[j] = {
						minlevel = Utils.getbits(pkmdata, 0, 8),
						maxlevel = Utils.getbits(pkmdata, 8, 8),
						id = Utils.getbits(pkmdata, 16, 16)
					}
				end
			end
		end
	end
end

function Program.getTrainerData(index)
	local trainerdata = {}
	local st = 0
	if index == 1 then
		st = GameSettings.pstats
	else
		st = GameSettings.estats
	end
	for i = 1,6,1 do
		local start = st + 100 * (i - 1)
		local personality = Memory.readdword(start)
		local magicword = (personality ~ Memory.readdword(start + 4))
		local growthoffset = (TableData.growth[(personality % 24) + 1] - 1) * 12
		local growth = (Memory.readdword(start + 32 + growthoffset) ~ magicword)
		trainerdata[i] = {
			pkmID = Utils.getbits(growth, 0, 16),
			curHP = Memory.readword(start + 86),
			maxHP = Memory.readword(start + 88),
			level = Memory.readbyte(start + 84)
		}
	end
	return trainerdata
end

function Program.getPokemonData(index)
	local start
	if index.player == 1 then
		start = GameSettings.pstats + 100 * (index.slot - 1)
	else
		start = GameSettings.estats + 100 * (index.slot - 1)
	end
	
	local personality = Memory.readdword(start)
	local otid = Memory.readdword(start + 4)
	local magicword = (personality ~ otid)
	
	local aux = personality % 24
	local growthoffset = (TableData.growth[aux+1] - 1) * 12
	local attackoffset = (TableData.attack[aux+1] - 1) * 12
	local effortoffset = (TableData.effort[aux+1] - 1) * 12
	local miscoffset   = (TableData.misc[aux+1]   - 1) * 12
	
	local growth1 = (Memory.readdword(start+32+growthoffset) ~   magicword)
	local growth2 = (Memory.readdword(start+32+growthoffset+4) ~ magicword)
	local growth3 = (Memory.readdword(start+32+growthoffset+8) ~ magicword)
	local attack1 = (Memory.readdword(start+32+attackoffset) ~   magicword)
	local attack2 = (Memory.readdword(start+32+attackoffset+4) ~ magicword)
	local attack3 = (Memory.readdword(start+32+attackoffset+8) ~ magicword)
	local effort1 = (Memory.readdword(start+32+effortoffset) ~   magicword)
	local effort2 = (Memory.readdword(start+32+effortoffset+4) ~ magicword)
	local effort3 = (Memory.readdword(start+32+effortoffset+8) ~ magicword)
	local misc1   = (Memory.readdword(start+32+miscoffset) ~     magicword)
	local misc2   = (Memory.readdword(start+32+miscoffset+4) ~   magicword)
	local misc3   = (Memory.readdword(start+32+miscoffset+8) ~   magicword)
	
	local cs = Utils.addhalves(growth1) + Utils.addhalves(growth2) + Utils.addhalves(growth3)
	         + Utils.addhalves(attack1) + Utils.addhalves(attack2) + Utils.addhalves(attack3)
			 + Utils.addhalves(effort1) + Utils.addhalves(effort2) + Utils.addhalves(effort3)
			 + Utils.addhalves(misc1)   + Utils.addhalves(misc2)   + Utils.addhalves(misc3)
	cs = cs % 65536
	
	local status_aux = Memory.readdword(start+80)
	local sleep_turns_result = 0
	local status_result = 0
	if status_aux == 0 then
		status_result = 0
	elseif status_aux < 8 then
		sleep_turns_result = status_aux
		status_result = 1
	elseif status_aux == 8 then
		status_result = 2	
	elseif status_aux == 16 then
		status_result = 3	
	elseif status_aux == 32 then
		status_result = 4	
	elseif status_aux == 64 then
		status_result = 5	
	elseif status_aux == 128 then
		status_result = 6	
	end
	
	return {
		pokemonID = Utils.getbits(growth1, 0, 16),
		heldItem = Utils.getbits(growth1, 16, 16),
		pokerus = Utils.getbits(misc1, 0, 8),
		tid = Utils.getbits(otid, 0, 16),
		sid = Utils.getbits(otid, 16, 16),
		iv = misc2,
		ev1 = effort1,
		ev2 = effort2,
		level = Memory.readbyte(start + 84),
		nature = personality % 25,
		pp = attack3,
		move1 = Utils.getbits(attack1, 0, 16),
		move2 = Utils.getbits(attack1, 16, 16),
		move3 = Utils.getbits(attack2, 0, 16),
		move4 = Utils.getbits(attack2, 16, 16),
		curHP = Memory.readword(start + 86),
		maxHP = Memory.readword(start + 88),
		atk = Memory.readword(start + 90),
		def = Memory.readword(start + 92),  
		spe = Memory.readword(start + 94),
		spa = Memory.readword(start + 96),
		spd = Memory.readword(start + 98),
		status = status_result,
		sleep_turns = sleep_turns_result
	}
end

function Program.validPokemonData(pokemonData)
	if pokemonData["pokemonID"] < 0 or pokemonData["pokemonID"] > 412 or pokemonData["heldItem"] < 0 or pokemonData["heldItem"] > 376 then
		return false
	elseif pokemonData["move1"] < 0 or pokemonData["move2"] < 0 or pokemonData["move3"] < 0 or pokemonData["move4"] < 0 then		
		return false
	elseif pokemonData["move1"] > 354 or pokemonData["move2"] > 354 or pokemonData["move3"] > 354 or pokemonData["move4"] > 354 then
		return false
	else
		return true
	end
end