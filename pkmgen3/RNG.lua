RNG = {}

function RNG.update()
	Program.rng.previous = Program.rng.current
	Program.rng.current = Memory.readdword(GameSettings.rng)
	local rng = Program.rng.current
	local rng2
	for i = 1, LayoutSettings.rng.rows, 1 do
		Program.rng.grid[i] = {}
		for j = 1, LayoutSettings.rng.columns, 1 do
			Program.rng.grid[i][j] = -1
			local rngtop = Utils.gettop(rng)
			if LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.BATTLE then
				if LayoutSettings.menus.rngbattle.selecteditem == LayoutSettings.menus.rngbattle.CRITICALHIT then
					if rngtop%16 == 0 then
						if LayoutSettings.rng.modulo == 3 then
							rng2 = Utils.rngAdvanceMulti(rng, 10)
						else
							rng2 = Utils.rngAdvanceMulti(rng, 7)
						end
						if Utils.gettop(rng2)%16 == 0 then
							Program.rng.grid[i][j] = 0xFF0000FF
						else
							Program.rng.grid[i][j] = 0xFFFF0000 + (0x1000 * (Utils.gettop(rng2)%16))
						end
					end
				elseif LayoutSettings.menus.rngbattle.selecteditem == LayoutSettings.menus.rngbattle.DAMAGERANGE then
					if rngtop%16 == 0 then
						Program.rng.grid[i][j] = 0xFF0000FF
					else
						Program.rng.grid[i][j] = 0xFFFF0000 + (0x1000 * (rngtop%16))
					end
				elseif LayoutSettings.menus.rngbattle.selecteditem == LayoutSettings.menus.rngbattle.MISS then
					if rngtop%100 >= LayoutSettings.menus.rngbattle.accuracy[3] then
						Program.rng.grid[i][j] = 0xFF0000FF
					end
				elseif LayoutSettings.menus.rngbattle.selecteditem == LayoutSettings.menus.rngbattle.HIT then
					if rngtop%100 < LayoutSettings.menus.rngbattle.accuracy[4] then
						Program.rng.grid[i][j] = 0xFFFF0000
					end
				elseif LayoutSettings.menus.rngbattle.selecteditem == LayoutSettings.menus.rngbattle.QUICKCLAW then
					if rngtop < 0x3333 then
						Program.rng.grid[i][j] = 0xFF00FF00
					end
				elseif LayoutSettings.menus.rngbattle.selecteditem == LayoutSettings.menus.rngbattle.PARALYZED then
					if rngtop%4==0 then
						Program.rng.grid[i][j] = 0xFFFFFF00
					end
				end
			elseif LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.ENCOUNTER then
				local accum = 0
				local encountermode = LayoutSettings.menus.encounter.selecteditem
				for k = 1, Program.map.encounters[encountermode].SLOTS, 1 do
					accum = accum + Program.map.encounters[encountermode].RATES[k]
					if rngtop%100 < accum then
						if LayoutSettings.selectedslot[k] then
							Program.rng.grid[i][j] = GraphicConstants.SLOTCOLORS[k]
						end
						break
					end
				end
			elseif LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.PICKUP then
				if rngtop%10 == 0 then
					rng2 = Utils.rngAdvance(rng)
					local accum = 0
					local pickuprarity = PickupData[GameSettings.version].rarity
					for k = 1, table.getn(pickuprarity), 1 do
						accum = accum + pickuprarity[k]
						if Utils.gettop(rng2)%100 < accum then
							if LayoutSettings.selectedslot[k] then
								Program.rng.grid[i][j] = GraphicConstants.SLOTCOLORS[k]
							end
							break
						end
					end
				end
			elseif LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.CATCH then
				rng2 = rng
				local count = 0
				for k = 1,4,1 do
					if Utils.gettop(rng2) <= Program.catchdata.rng then
						count = count + 1
					end
					rng2 = Utils.rngDecrease(rng2)
				end
				if count == 4 then
					Program.rng.grid[i][j] = 0xFFFF0000
				end
			elseif LayoutSettings.menus.rng.selecteditem == LayoutSettings.menus.rng.OTHER then
				if LayoutSettings.menus.rngother.selecteditem == LayoutSettings.menus.rngother.POKERUS then
					if rngtop == 0x4000 or rngtop == 0x8000 or rngtop == 0xC000 then
						Program.rng.grid[i][j] = 0xFFFF0000
					end
				end
			end
			rng = Utils.rngAdvance(rng)
		end
	end
end