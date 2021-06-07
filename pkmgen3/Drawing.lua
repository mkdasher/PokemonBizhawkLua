Drawing = {}

function Drawing.drawLayout()
	gui.drawRectangle(
		GraphicConstants.SCREEN_WIDTH,
		0,
		GraphicConstants.RIGHT_GAP - 1,
		GraphicConstants.UP_GAP +  GraphicConstants.DOWN_GAP + GraphicConstants.SCREEN_HEIGHT - 1,
		GameSettings.gamecolor,
		0x00000000
	)
	gui.drawRectangle(
		0,
		GraphicConstants.SCREEN_HEIGHT + GraphicConstants.UP_GAP,
		GraphicConstants.SCREEN_WIDTH,
		GraphicConstants.DOWN_GAP - 1,
		GameSettings.gamecolor,
		0x00000000
	)
	gui.drawRectangle(
		0,
		0,
		GraphicConstants.SCREEN_WIDTH,
		GraphicConstants.UP_GAP,
		GameSettings.gamecolor,
		GameSettings.gamecolor - 0x80000000
	)
	gui.drawText(
		GraphicConstants.SCREEN_WIDTH / 2 - ((string.len(GameSettings.gamename)+6) * 3),
		3,
		"Game: " .. GameSettings.gamename,
		"white",
		0x00000000,
		10,
		"Lucida Console"
	)
end

function Drawing.drawPokemonIcon(id, x, y, selectedPokemon)
	if id < 0 or id > 412 then
		id = 0
	end
	if selectedPokemon then
		gui.drawRectangle(x,y,36,36, GraphicConstants.SELECTEDCOLOR[1], GraphicConstants.SELECTEDCOLOR[2])
	else
		gui.drawRectangle(x,y,36,36, GraphicConstants.NONSELECTEDCOLOR, 0xFF222222)
	end
	gui.drawImage(DATA_FOLDER .. "/images/pokemon/" .. id .. ".gif", x+2, y+2, 32, 32)
end

function Drawing.drawText(x, y, text, color)
	gui.drawText( x, y, text, color, null, 9, "Franklin Gothic Medium")
end

function Drawing.drawTriangleRight(x, y, size, color)
	gui.drawRectangle(x, y, size, size, color)
	gui.drawPolygon({{4+x,4+y},{4+x,y+size-4},{x+size-4,y+size/2}}, color, color)
end
function Drawing.drawTriangleLeft(x, y, size, color)
	gui.drawRectangle(x, y, size, size, color)
	gui.drawPolygon({{x+size-4,4+y},{x+size-4,y+size-4},{4+x,y+size/2}}, color, color)
end

function Drawing.drawGeneralInfo()
	local currng = Memory.readdword(GameSettings.rng)
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 5, GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT + GraphicConstants.DOWN_GAP - 40, "RNG seed:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT + GraphicConstants.DOWN_GAP - 40, GameSettings.rngseed .. " (" .. Utils.tohex(GameSettings.rngseed) .. ")", "yellow")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 5, GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT + GraphicConstants.DOWN_GAP - 30, "RNG frame:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT + GraphicConstants.DOWN_GAP - 30, Utils.getRNGDistance(GameSettings.rngseed, currng), "yellow")
end

function Drawing.drawPokemonView()
	Drawing.drawPokemonIcon(Program.selectedPokemon["pokemonID"], GraphicConstants.SCREEN_WIDTH + 5, 5)
	local colorbar = "white"

	if Program.selectedPokemon["curHP"] / Program.selectedPokemon["maxHP"] <= 0.2 then
		colorbar = "red"
	elseif Program.selectedPokemon["curHP"] / Program.selectedPokemon["maxHP"] <= 0.5 then
		colorbar = "yellow"
	end
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 45, 7, PokemonData.name[Program.selectedPokemon["pokemonID"] + 1])
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 45, 17, "HP:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 17, Program.selectedPokemon["curHP"] .. " / " .. Program.selectedPokemon["maxHP"], colorbar)
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 45, 27, "Level: " .. Program.selectedPokemon["level"])
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 5, 43, "Item:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 42, 43, PokemonData.item[Program.selectedPokemon["heldItem"] + 1], "yellow")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 5, 53, "PKRS:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 42, 53, Program.selectedPokemon["pokerus"], "yellow")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 5, 63, "OT ID:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 42, 63, Program.selectedPokemon["tid"], "yellow")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 75, 63, "OT SID:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 112, 63, Program.selectedPokemon["sid"], "yellow")
	
	gui.drawRectangle(GraphicConstants.SCREEN_WIDTH + 5, 75, GraphicConstants.RIGHT_GAP - 11, 85,0xFFAAAAAA, 0xFF222222)
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 80, "Stat", "white")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 80, "IV", "white")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 80, "EV", "white")
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 95, "HP", Utils.getNatureColor("hp", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 105, "Attack", Utils.getNatureColor("atk", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 115, "Defense", Utils.getNatureColor("def", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 125, "Sp. Atk", Utils.getNatureColor("spa", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 135, "Sp. Def", Utils.getNatureColor("spd", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 145, "Speed", Utils.getNatureColor("spe", Program.selectedPokemon["nature"]))
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 95, Program.selectedPokemon["maxHP"], Utils.getNatureColor("hp", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 105, Program.selectedPokemon["atk"], Utils.getNatureColor("atk", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 115, Program.selectedPokemon["def"], Utils.getNatureColor("def", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 125, Program.selectedPokemon["spa"], Utils.getNatureColor("spa", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 135, Program.selectedPokemon["spd"], Utils.getNatureColor("spd", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 60, 145, Program.selectedPokemon["spe"], Utils.getNatureColor("spe", Program.selectedPokemon["nature"]))

	local hpiv = Utils.getbits(Program.selectedPokemon["iv"], 0, 5)
	local atkiv = Utils.getbits(Program.selectedPokemon["iv"], 5, 5)
	local defiv = Utils.getbits(Program.selectedPokemon["iv"], 10, 5)
	local speiv = Utils.getbits(Program.selectedPokemon["iv"], 15, 5)
	local spaiv = Utils.getbits(Program.selectedPokemon["iv"], 20, 5)
	local spdiv = Utils.getbits(Program.selectedPokemon["iv"], 25, 5)
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 95, hpiv, Utils.getNatureColor("hp", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 105, atkiv, Utils.getNatureColor("atk", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 115, defiv, Utils.getNatureColor("def", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 125, spaiv, Utils.getNatureColor("spa", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 135, spdiv, Utils.getNatureColor("spd", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 145, speiv, Utils.getNatureColor("spe", Program.selectedPokemon["nature"]))
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 95, Utils.getbits(Program.selectedPokemon["ev1"], 0, 8), Utils.getNatureColor("hp", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 105, Utils.getbits(Program.selectedPokemon["ev1"], 8, 8), Utils.getNatureColor("atk", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 115, Utils.getbits(Program.selectedPokemon["ev1"], 16, 8), Utils.getNatureColor("def", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 125, Utils.getbits(Program.selectedPokemon["ev2"], 0, 8), Utils.getNatureColor("spa", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 135, Utils.getbits(Program.selectedPokemon["ev2"], 8, 8), Utils.getNatureColor("spd", Program.selectedPokemon["nature"]))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 120, 145, Utils.getbits(Program.selectedPokemon["ev1"], 24, 8), Utils.getNatureColor("spe", Program.selectedPokemon["nature"]))
	
	local hptype = math.floor(((hpiv%2 + 2*(atkiv%2) + 4*(defiv%2) + 8*(speiv%2) + 16*(spaiv%2) + 32*(spdiv%2))*15)/63)
    local hppower = math.floor(((Utils.getbits(hpiv,1,1) + 2*Utils.getbits(atkiv,1,1) + 4*Utils.getbits(defiv,1,1) + 8*Utils.getbits(speiv,1,1) + 16*Utils.getbits(spaiv,1,1) + 32*Utils.getbits(spdiv,1,1))*40)/63 + 30)
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 15, 162, "Nature:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 80, 162, PokemonData.nature[Program.selectedPokemon["nature"] + 1], "yellow")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 15, 172, "Hidden Power:")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 80, 172, PokemonData.type[hptype + 1] .. "  " .. hppower, "yellow")
	
	gui.drawRectangle(GraphicConstants.SCREEN_WIDTH + 5, 185, GraphicConstants.RIGHT_GAP - 11, 65,0xFFAAAAAA, 0xFF222222)
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 205, PokemonData.move[Program.selectedPokemon["move1"] + 1])
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 215, PokemonData.move[Program.selectedPokemon["move2"] + 1])
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 225, PokemonData.move[Program.selectedPokemon["move3"] + 1])
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 10, 235, PokemonData.move[Program.selectedPokemon["move4"] + 1])
	
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 190, "PP")
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 205, Utils.getbits(Program.selectedPokemon["pp"], 0, 8))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 215, Utils.getbits(Program.selectedPokemon["pp"], 8, 8))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 225, Utils.getbits(Program.selectedPokemon["pp"], 16, 8))
	Drawing.drawText(GraphicConstants.SCREEN_WIDTH + 90, 235, Utils.getbits(Program.selectedPokemon["pp"], 24, 8))
end

function Drawing.drawMap()
	gui.drawImage(DATA_FOLDER .. "/images/map/" .. Map.file .. ".png", 1, GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT + 17, GraphicConstants.SCREEN_WIDTH - 1, 167)
	local position = {-7, GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT}
	local tilesize = 8
	local coords = Map.findCoords(Memory.readbyte(GameSettings.mapid))
	
	local roameraddr = Memory.readdword(GameSettings.trainerpointer) + GameSettings.roamerpokemonoffset
	local roameravailable = Memory.readbyte(roameraddr + 19)
	local roamermapid = Memory.readbyte(GameSettings.mapbank + 7)
	if GameSettings.version == GameSettings.VERSIONS.FRLG then
		if roamermapid > 0x28 then
			roamermapid = roamermapid + 0x51
		else
			roamermapid = roamermapid + 0x52
		end
	end
	if roameravailable == 1 and roamermapid > 0 then
		local roamerid = Memory.readword(roameraddr + 8)
		local roamercoords = Map.findCoords(roamermapid)
		gui.drawImage(DATA_FOLDER .. "/images/pokemon/" .. roamerid .. ".gif", position[1] + (roamercoords[1] - 1)*8 - 8, position[2] + (roamercoords[2] - 1)*8 - 12, 32, 32)
	end
	
	if Program.trainerInfo.gender >= 0 then
		local gender = 'girl'
		if Program.trainerInfo.gender == 0 then
			gender = 'boy'
		end
		if GameSettings.version == GameSettings.VERSIONS.E then
			gender = gender .. '-e'
		elseif GameSettings.version == GameSettings.VERSIONS.RS then
			gender = gender .. '-rs'
		else --frlg
			gender = gender .. '-frlg'
		end
		gui.drawImage(DATA_FOLDER .. "/images/player/" .. gender .. ".png", position[1] + (coords[1] - 1)*8, position[2] + (coords[2] - 1)*8, 16, 16)
	end
	gui.drawText(
		2,
		GraphicConstants.UP_GAP + GraphicConstants.SCREEN_HEIGHT + 19,
		PokemonData.map[Memory.readbyte(GameSettings.mapid) + 1],
		"white",
		0x00000000,
		9,
		"Lucida Console"
	)
end

function Drawing.drawButtons()
	for i = 1, table.getn(Buttons), 1 do
		if Buttons[i].visible() then
			if Buttons[i].type == ButtonType.singleButton then
				gui.drawRectangle(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4], Buttons[i].backgroundcolor[1], Buttons[i].backgroundcolor[2])
				Drawing.drawText(Buttons[i].box[1] + 2, Buttons[i].box[2] + (Buttons[i].box[4] - 12) / 2 + 1, Buttons[i].text, Buttons[i].textcolor)
			elseif Buttons[i].type == ButtonType.horizontalMenu then
				local selecteditem = LayoutSettings.menus[Buttons[i].model].selecteditem
				local menuitems = LayoutSettings.menus[Buttons[i].model].items
				local itemcount = table.getn(menuitems)
				local itemwidth = Buttons[i].box[3] / itemcount
				for j = 1, itemcount, 1 do
					gui.drawRectangle((j-1) * itemwidth + Buttons[i].box[1], Buttons[i].box[2], itemwidth, Buttons[i].box[4], GraphicConstants.NONSELECTEDCOLOR)
					Drawing.drawText((j-1) * itemwidth + Buttons[i].box[1] + 2, Buttons[i].box[2] + (Buttons[i].box[4] - 12) / 2 + 1, menuitems[j], GraphicConstants.NONSELECTEDCOLOR)
				end
				gui.drawRectangle((selecteditem-1) * itemwidth + Buttons[i].box[1], Buttons[i].box[2], itemwidth, Buttons[i].box[4], GraphicConstants.SELECTEDCOLOR[1], GraphicConstants.SELECTEDCOLOR[2])
				Drawing.drawText((selecteditem-1) * itemwidth + Buttons[i].box[1] + 2, Buttons[i].box[2] + (Buttons[i].box[4] - 12) / 2 + 1, menuitems[selecteditem], GraphicConstants.SELECTEDCOLOR[1])
			elseif Buttons[i].type == ButtonType.horizontalMenuBar then
				local selecteditem = LayoutSettings.menus[Buttons[i].model].selecteditem
				local menuitems = LayoutSettings.menus[Buttons[i].model].items
				local itemcount = table.getn(menuitems)
				local itemwidth = (Buttons[i].box[3] - (Buttons[i].box[4] * 2)) / Buttons[i].visibleitems
				gui.drawRectangle(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[4], Buttons[i].box[4], GraphicConstants.NONSELECTEDCOLOR)
				if Buttons[i].firstvisible > 1 then
					Drawing.drawTriangleLeft(Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[4], GraphicConstants.NONSELECTEDCOLOR)
				end
				gui.drawRectangle(Buttons[i].box[1] + Buttons[i].box[3] - Buttons[i].box[4], Buttons[i].box[2], Buttons[i].box[4], Buttons[i].box[4], GraphicConstants.NONSELECTEDCOLOR)
				if Buttons[i].firstvisible < itemcount - Buttons[i].visibleitems + 1 then
					Drawing.drawTriangleRight(Buttons[i].box[1] + Buttons[i].box[3] - Buttons[i].box[4], Buttons[i].box[2], Buttons[i].box[4], GraphicConstants.NONSELECTEDCOLOR)
				end
				for j = Buttons[i].firstvisible, Buttons[i].firstvisible + Buttons[i].visibleitems - 1, 1 do
					gui.drawRectangle((j-Buttons[i].firstvisible) * itemwidth + Buttons[i].box[1] + Buttons[i].box[4], Buttons[i].box[2], itemwidth, Buttons[i].box[4], GraphicConstants.NONSELECTEDCOLOR)
					Drawing.drawText((j-Buttons[i].firstvisible) * itemwidth + Buttons[i].box[1] + Buttons[i].box[4] + 2, Buttons[i].box[2] + (Buttons[i].box[4] - 12) / 2 + 1, menuitems[j], GraphicConstants.NONSELECTEDCOLOR)
				end
				local selecteditemposition = selecteditem - Buttons[i].firstvisible
				if selecteditemposition >= 0 and selecteditemposition < Buttons[i].visibleitems then 
					gui.drawRectangle(selecteditemposition * itemwidth + Buttons[i].box[1] + Buttons[i].box[4], Buttons[i].box[2], itemwidth, Buttons[i].box[4], GraphicConstants.SELECTEDCOLOR[1], GraphicConstants.SELECTEDCOLOR[2])
					Drawing.drawText(selecteditemposition * itemwidth + Buttons[i].box[1] + Buttons[i].box[4] + 2, Buttons[i].box[2] + (Buttons[i].box[4] - 12) / 2 + 1, menuitems[selecteditem], GraphicConstants.SELECTEDCOLOR[1])
				end
			elseif Buttons[i].type == ButtonType.verticalMenu then
				local selecteditem = LayoutSettings.menus[Buttons[i].model].selecteditem
				local menuitems = LayoutSettings.menus[Buttons[i].model].items
				local itemcount = table.getn(menuitems)
				for j = 1, itemcount, 1 do
					gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4], Buttons[i].box_first[3], Buttons[i].box_first[4], GraphicConstants.NONSELECTEDCOLOR)
					local itemtext = menuitems[j]
					if LayoutSettings.menus[Buttons[i].model].accuracy and LayoutSettings.menus[Buttons[i].model].accuracy[j] ~= -1 then
						itemtext = menuitems[j] .. ' (' .. LayoutSettings.menus[Buttons[i].model].accuracy[j] .. '% acc.)'
						gui.drawRectangle(Buttons[i].box_first[1] + Buttons[i].box_first[3], Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4], Buttons[i].box_first[4], Buttons[i].box_first[4], GraphicConstants.NONSELECTEDCOLOR)
						gui.drawRectangle(Buttons[i].box_first[1] + Buttons[i].box_first[3] + Buttons[i].box_first[4], Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4], Buttons[i].box_first[4], Buttons[i].box_first[4], GraphicConstants.NONSELECTEDCOLOR)
						Drawing.drawText(Buttons[i].box_first[1] + Buttons[i].box_first[3] + 3, Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4] + (Buttons[i].box_first[4] - 12) / 2 + 1, '-', GraphicConstants.NONSELECTEDCOLOR)
						Drawing.drawText(Buttons[i].box_first[1] + Buttons[i].box_first[3] + Buttons[i].box_first[4] + 3, Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4] + (Buttons[i].box_first[4] - 12) / 2 + 1, '+', GraphicConstants.NONSELECTEDCOLOR)
					end
					Drawing.drawText(Buttons[i].box_first[1] + 2, Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4] + (Buttons[i].box_first[4] - 12) / 2 + 1, itemtext, GraphicConstants.NONSELECTEDCOLOR)
				end
				gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + (selecteditem-1) * Buttons[i].box_first[4], Buttons[i].box_first[3], Buttons[i].box_first[4], GraphicConstants.SELECTEDCOLOR[1], GraphicConstants.SELECTEDCOLOR[2])
				local itemtext = menuitems[selecteditem]
				if LayoutSettings.menus[Buttons[i].model].accuracy and LayoutSettings.menus[Buttons[i].model].accuracy[selecteditem] ~= -1 then
					itemtext = menuitems[selecteditem] .. ' (' .. LayoutSettings.menus[Buttons[i].model].accuracy[selecteditem] .. '% acc.)'
					gui.drawRectangle(Buttons[i].box_first[1] + Buttons[i].box_first[3], Buttons[i].box_first[2] + (selecteditem-1) * Buttons[i].box_first[4], Buttons[i].box_first[4], Buttons[i].box_first[4], GraphicConstants.SELECTEDCOLOR[1], GraphicConstants.SELECTEDCOLOR[2])
					gui.drawRectangle(Buttons[i].box_first[1] + Buttons[i].box_first[3] + Buttons[i].box_first[4], Buttons[i].box_first[2] + (selecteditem-1) * Buttons[i].box_first[4], Buttons[i].box_first[4], Buttons[i].box_first[4], GraphicConstants.SELECTEDCOLOR[1], GraphicConstants.SELECTEDCOLOR[2])
					Drawing.drawText(Buttons[i].box_first[1] + Buttons[i].box_first[3] + 3, Buttons[i].box_first[2] + (selecteditem-1) * Buttons[i].box_first[4] + (Buttons[i].box_first[4] - 12) / 2 + 1, '-', GraphicConstants.SELECTEDCOLOR[1])
					Drawing.drawText(Buttons[i].box_first[1] + Buttons[i].box_first[3] + Buttons[i].box_first[4] + 3, Buttons[i].box_first[2] + (selecteditem-1) * Buttons[i].box_first[4] + (Buttons[i].box_first[4] - 12) / 2 + 1, '+', GraphicConstants.SELECTEDCOLOR[1])
				end
				Drawing.drawText(Buttons[i].box_first[1] + 2, Buttons[i].box_first[2] + (selecteditem-1) * Buttons[i].box_first[4] + (Buttons[i].box_first[4] - 12) / 2 + 1, itemtext, GraphicConstants.SELECTEDCOLOR[1])
			elseif Buttons[i].type == ButtonType.pokemonteamMenu then
				local team = Program.trainerPokemonTeam
				if Buttons[i].team == 2 then
					team = Program.enemyPokemonTeam
				end
				gui.drawText(Buttons[i].position[1] + 4, Buttons[i].position[2] - 13, Buttons[i].text, 'cyan', null, 10, 'Arial')
				for j = 1,6,1 do
					Drawing.drawPokemonIcon(team[j]['pkmID'], Buttons[i].position[1] + (j-1) * 39, Buttons[i].position[2], LayoutSettings.pokemonIndex.player == Buttons[i].team and LayoutSettings.pokemonIndex.slot == j)
					if team[j]['pkmID'] > 0 then
						local colorbar = 'white'
						if team[j]['curHP'] / team[j]['maxHP'] <= 0.2 then
							colorbar = 'red'
						elseif team[j]['curHP'] / team[j]['maxHP'] <= 0.2 then
							colorbar = 'yellow'
						end
						Drawing.drawText(Buttons[i].position[1] + (j-1) * 39, Buttons[i].position[2] + 36, "Lv. " .. team[j]['level'])
						Drawing.drawText(Buttons[i].position[1] + (j-1) * 39 - 1, Buttons[i].position[2] + 46, team[j]['curHP'] .. "/" .. team[j]['maxHP'], colorbar)
					end
				end
			elseif Buttons[i].type == ButtonType.rngViewButtons then
				local position = Buttons[i].position()
				gui.drawRectangle(position[1] + 15, position[2], Buttons[i].buttonsize, Buttons[i].buttonsize)
				gui.drawRectangle(position[1] + 50, position[2], Buttons[i].buttonsize, Buttons[i].buttonsize)
				gui.drawRectangle(position[1] + 50 + Buttons[i].buttonsize, position[2], Buttons[i].buttonsize, Buttons[i].buttonsize)
				Drawing.drawText(position[1] + 18, position[2] + 1, LayoutSettings.rng.modulo)
				Drawing.drawText(position[1] + 53, position[2] + 1, '-')
				Drawing.drawText(position[1] + 53 + Buttons[i].buttonsize, position[2] + 1, '+')
			elseif Buttons[i].type == ButtonType.encounterSlots then
				local encountermode = LayoutSettings.menus[Buttons[i].model].selecteditem
				if Program.map.encounters[encountermode].encrate > 0 then
					for j = 1, Program.map.encounters[encountermode].SLOTS, 1 do
						local levelstr = Program.map.encounters[encountermode].pokemon[j].minlevel
						if Program.map.encounters[encountermode].pokemon[j].minlevel ~= Program.map.encounters[encountermode].pokemon[j].maxlevel then
							levelstr = levelstr .. '-' .. Program.map.encounters[encountermode].pokemon[j].maxlevel
						end
						if LayoutSettings.selectedslot[j] then
							gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + j * (Buttons[i].box_first[4] + 2), Buttons[i].box_first[4], Buttons[i].box_first[4], 'white', GraphicConstants.SLOTCOLORS[j])
							Drawing.drawText(Buttons[i].box_first[1] + 10, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), "Slot " .. j .. " (" .. Program.map.encounters[encountermode].RATES[j] .. "%):")
							Drawing.drawText(Buttons[i].box_first[1] + 61, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), PokemonData.name[Program.map.encounters[encountermode].pokemon[j].id + 1] .. " Lv. " .. levelstr)
						else
							gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + j * (Buttons[i].box_first[4] + 2), Buttons[i].box_first[4], Buttons[i].box_first[4], 'gray', GraphicConstants.SLOTCOLORS[j])
							Drawing.drawText(Buttons[i].box_first[1] + 10, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), "Slot " .. j .. " (" .. Program.map.encounters[encountermode].RATES[j] .. "%):", "gray")
							Drawing.drawText(Buttons[i].box_first[1] + 61, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), PokemonData.name[Program.map.encounters[encountermode].pokemon[j].id + 1] .. " Lv. " .. levelstr, "gray")
						end
					end
				else
					Drawing.drawText(Buttons[i].box_first[1] + 10, Buttons[i].box_first[2] + 7, 'No encounters')
				end
			elseif Buttons[i].type == ButtonType.pickupData then
				local pickupitem = PickupData[GameSettings.version].item
				local pickuprarity = PickupData[GameSettings.version].rarity
				if GameSettings.version == GameSettings.VERSIONS.E then
					pickupitem = pickupitem[LayoutSettings.menus.pickuplevel.selecteditem]
				end
				for j = 1, table.getn(pickupitem), 1 do
					if LayoutSettings.selectedslot[j] then
						gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + j * (Buttons[i].box_first[4] + 2), Buttons[i].box_first[4], Buttons[i].box_first[4], 'white', GraphicConstants.SLOTCOLORS[j])
						Drawing.drawText(Buttons[i].box_first[1] + 10, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), "(" .. pickuprarity[j] .. "%):")
						Drawing.drawText(Buttons[i].box_first[1] + 40, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), PokemonData.item[pickupitem[j] + 1])
					else
						gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + j * (Buttons[i].box_first[4] + 2), Buttons[i].box_first[4], Buttons[i].box_first[4], 'gray', GraphicConstants.SLOTCOLORS[j])
						Drawing.drawText(Buttons[i].box_first[1] + 10, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), "(" .. pickuprarity[j] .. "%):", 'gray')
						Drawing.drawText(Buttons[i].box_first[1] + 40, Buttons[i].box_first[2] - 2 + j * (Buttons[i].box_first[4] + 2), PokemonData.item[pickupitem[j] + 1], 'gray')
					end
				end
			elseif Buttons[i].type == ButtonType.catchData then
				local enabled = Buttons[i].enabled()
				local data = Buttons[i].data()
				for j = 1, table.getn(Buttons[i].text), 1 do
					local itemcolor = GraphicConstants.NONSELECTEDCOLOR
					if enabled[j] then
						itemcolor = 'white'
					end
					gui.drawRectangle(Buttons[i].box_first[1], Buttons[i].box_first[2] + j * Buttons[i].box_first[4], Buttons[i].box_first[3], Buttons[i].box_first[4], GraphicConstants.NONSELECTEDCOLOR)
					Drawing.drawText(Buttons[i].box_first[1] + 2 - 50, Buttons[i].box_first[2] + j * Buttons[i].box_first[4] + 1, Buttons[i].text[j], GraphicConstants.NONSELECTEDCOLOR)
					Drawing.drawText(Buttons[i].box_first[1] + 2, Buttons[i].box_first[2] + j * Buttons[i].box_first[4] + 1, data[j], itemcolor)
				end
			end
		end
	end
end

function Drawing.drawCatchRate()
	Drawing.drawText(102, 306, 'RNG:', GraphicConstants.NONSELECTEDCOLOR)
	Drawing.drawText(102, 319, 'Catch rate:', GraphicConstants.NONSELECTEDCOLOR)
	Drawing.drawText(152, 306, Program.catchdata.rng .. " / 65536", GraphicConstants.SELECTEDCOLOR[1])
	Drawing.drawText(152, 319, (Program.catchdata.rate * 100) .. "%", GraphicConstants.SELECTEDCOLOR[1])	
end

function Drawing.drawRNGPanel()
	local position = {4, GraphicConstants.SCREEN_HEIGHT + GraphicConstants.UP_GAP * 2 + 20}
	
	local textstart = position[2] + LayoutSettings.rng.rows * LayoutSettings.rng.squaresize + 20
	local distancelast = Utils.getRNGDistance(Program.rng.previous, Program.rng.current)
	
	-- DRAW RNG GRID LAYOUT --
	local bglinecolor
	local borderlinecolor
	if distancelast <= LayoutSettings.rng.modulo then
		borderlinecolor = 'white'
		bglinecolor = 0xFF000000
	else
		borderlinecolor = 'red'
		bglinecolor = 0xFF555500
	end
	gui.drawRectangle(position[1], position[2], LayoutSettings.rng.columns * LayoutSettings.rng.squaresize + 2, LayoutSettings.rng.rows * LayoutSettings.rng.squaresize + 2, borderlinecolor, bglinecolor)
	for j = 0, LayoutSettings.rng.columns - 1, 1 do
		local clr = 0xFF606060
		if j % LayoutSettings.rng.modulo == 0 then
			clr = 0xFFB0B0B0
		end
		gui.drawRectangle(j*LayoutSettings.rng.squaresize + position[1] + 2, position[2] + 2, LayoutSettings.rng.squaresize - 2, LayoutSettings.rng.rows * LayoutSettings.rng.squaresize - 2, clr, clr)
	end
	for i = 0, LayoutSettings.rng.rows - 1, 2 do
		gui.drawRectangle(position[1]+1, i*LayoutSettings.rng.squaresize + position[2] + 1, LayoutSettings.rng.columns * LayoutSettings.rng.squaresize, LayoutSettings.rng.squaresize, bglinecolor)
	end
	
	-- DRAW RNG SQUARES --
	for i = 1, LayoutSettings.rng.rows, 1 do
		for j = 1, LayoutSettings.rng.columns, 1 do
			if Program.rng.grid[i][j] ~= -1 then
				if Program.rng.grid[i][j] ~= -1 then
					gui.drawRectangle((j-1)*LayoutSettings.rng.squaresize + position[1] + 2, (i-1)*LayoutSettings.rng.squaresize + position[2] + 2, LayoutSettings.rng.squaresize - 2, LayoutSettings.rng.squaresize - 2, Program.rng.grid[i][j], Program.rng.grid[i][j])
				end
			end
		end
	end
	
	Drawing.drawText(2,  textstart, "RNG value:")
	Drawing.drawText(50, textstart, Utils.tohex(Program.rng.current), "yellow")
	Drawing.drawText(2,  textstart + 10, "RNG prev:")
	Drawing.drawText(50, textstart + 10, Utils.tohex(Program.rng.previous), "yellow")
	Drawing.drawText(2,  textstart + 20, "Dist. last:")
	Drawing.drawText(50, textstart + 20, distancelast, "yellow")
	Drawing.drawText(2,  textstart + 30, "RNG frame:")
	Drawing.drawText(50, textstart + 30, Utils.getRNGDistance(GameSettings.rngseed, Program.rng.current), "yellow")
end
