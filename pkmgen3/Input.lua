Input = {
	mousetab = {},
	mousetab_prev = {}
}

function Input.update()
	Input.mousetab = input.getmouse()
	if Input.mousetab["Left"] and not Input.mousetab_prev["Left"] then
		local xmouse = Input.mousetab["X"]
		local ymouse = Input.mousetab["Y"] + GraphicConstants.UP_GAP
		Input.check(xmouse, ymouse)
	end
	Input.mousetab_prev = Input.mousetab
end

function Input.check(xmouse, ymouse)
	for i = 1, table.getn(Buttons), 1 do
		if Buttons[i].visible() then
			if Buttons[i].type == ButtonType.singleButton then
				if Input.isInRange(xmouse, ymouse, Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[3], Buttons[i].box[4]) then
					Buttons[i].onclick()
				end
			elseif Buttons[i].type == ButtonType.horizontalMenu then
				local itemcount = table.getn(LayoutSettings.menus[Buttons[i].model].items)
				local itemwidth = Buttons[i].box[3] / itemcount
				for j = 1, itemcount, 1 do
					if Input.isInRange(xmouse, ymouse, (j-1) * itemwidth + Buttons[i].box[1], Buttons[i].box[2], itemwidth, Buttons[i].box[4]) then
						LayoutSettings.menus[Buttons[i].model].selecteditem = j
					end
				end
			elseif Buttons[i].type == ButtonType.horizontalMenuBar then
				local itemcount = table.getn(LayoutSettings.menus[Buttons[i].model].items)
				local itemwidth = (Buttons[i].box[3] - (Buttons[i].box[4] * 2)) / Buttons[i].visibleitems
				if Input.isInRange(xmouse, ymouse, Buttons[i].box[1], Buttons[i].box[2], Buttons[i].box[4], Buttons[i].box[4]) then
					if Buttons[i].firstvisible > 1 then
						Buttons[i].firstvisible = Buttons[i].firstvisible - 1
					end
				end
				if Input.isInRange(xmouse, ymouse, Buttons[i].box[1] + Buttons[i].box[3] - Buttons[i].box[4], Buttons[i].box[2], Buttons[i].box[4], Buttons[i].box[4]) then
					if Buttons[i].firstvisible < itemcount - Buttons[i].visibleitems + 1 then
						Buttons[i].firstvisible = Buttons[i].firstvisible + 1
					end
				end
				for j = Buttons[i].firstvisible, Buttons[i].firstvisible + Buttons[i].visibleitems - 1, 1 do
					if Input.isInRange(xmouse, ymouse, (j-Buttons[i].firstvisible) * itemwidth + Buttons[i].box[1] + Buttons[i].box[4], Buttons[i].box[2], itemwidth, Buttons[i].box[4]) then
						LayoutSettings.menus[Buttons[i].model].selecteditem = j
					end
				end
			elseif Buttons[i].type == ButtonType.verticalMenu then
				local itemcount = table.getn(LayoutSettings.menus[Buttons[i].model].items)
				for j = 1, itemcount, 1 do
					if Input.isInRange(xmouse, ymouse, Buttons[i].box_first[1], Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4], Buttons[i].box_first[3], Buttons[i].box_first[4]) then
						LayoutSettings.menus[Buttons[i].model].selecteditem = j
					elseif LayoutSettings.menus[Buttons[i].model].accuracy and LayoutSettings.menus[Buttons[i].model].accuracy[j] ~= -1 then
						if Input.isInRange(xmouse, ymouse, Buttons[i].box_first[1] + Buttons[i].box_first[3], Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4], Buttons[i].box_first[4], Buttons[i].box_first[4]) then
							LayoutSettings.menus[Buttons[i].model].selecteditem = j
							LayoutSettings.menus[Buttons[i].model].accuracy[j] = LayoutSettings.menus[Buttons[i].model].accuracy[j] - LayoutSettings.menus[Buttons[i].model].accuracy_step
							if LayoutSettings.menus[Buttons[i].model].accuracy[j] < 0 then
								LayoutSettings.menus[Buttons[i].model].accuracy[j] = 0
							end
						elseif Input.isInRange(xmouse, ymouse, Buttons[i].box_first[1] + Buttons[i].box_first[3] + Buttons[i].box_first[4], Buttons[i].box_first[2] + (j-1) * Buttons[i].box_first[4], Buttons[i].box_first[4], Buttons[i].box_first[4]) then
							LayoutSettings.menus[Buttons[i].model].selecteditem = j
							LayoutSettings.menus[Buttons[i].model].accuracy[j] = LayoutSettings.menus[Buttons[i].model].accuracy[j] + LayoutSettings.menus[Buttons[i].model].accuracy_step
							if LayoutSettings.menus[Buttons[i].model].accuracy[j] > 100 then
								LayoutSettings.menus[Buttons[i].model].accuracy[j] = 100
							end
						end
					end
				end
			elseif Buttons[i].type == ButtonType.pokemonteamMenu then
				for j = 1, 6, 1 do
					if Input.isInRange(xmouse, ymouse, Buttons[i].position[1] + (j-1) * 39, Buttons[i].position[2], 36, 36) then
						LayoutSettings.pokemonIndex.player = Buttons[i].team
						LayoutSettings.pokemonIndex.slot = j
					end
				end
			elseif Buttons[i].type == ButtonType.rngViewButtons then
				local position = Buttons[i].position()
				if Input.isInRange(xmouse, ymouse, position[1] + 15, position[2], Buttons[i].buttonsize, Buttons[i].buttonsize) then
					LayoutSettings.rng.modulo = (LayoutSettings.rng.modulo % 3) + 1
				elseif Input.isInRange(xmouse, ymouse, position[1] + 50, position[2], Buttons[i].buttonsize, Buttons[i].buttonsize) then
					if LayoutSettings.rng.rows > LayoutSettings.rng.MINROWS then
						LayoutSettings.rng.rows = LayoutSettings.rng.rows - 1
					end
				elseif Input.isInRange(xmouse, ymouse, position[1] + 50 + Buttons[i].buttonsize, position[2], Buttons[i].buttonsize, Buttons[i].buttonsize) then
					if LayoutSettings.rng.rows < LayoutSettings.rng.MAXROWS then
						LayoutSettings.rng.rows = LayoutSettings.rng.rows + 1
					end
				end
			elseif Buttons[i].type == ButtonType.encounterSlots then
				local encountermode = LayoutSettings.menus[Buttons[i].model].selecteditem
				if Program.map.encounters[encountermode].encrate > 0 then
					for j = 1, Program.map.encounters[encountermode].SLOTS, 1 do
						if Input.isInRange(xmouse, ymouse, Buttons[i].box_first[1], Buttons[i].box_first[2] + j * (Buttons[i].box_first[4] + 2), Buttons[i].box_first[3], Buttons[i].box_first[4]) then
							LayoutSettings.selectedslot[j] = not LayoutSettings.selectedslot[j]
						end
					end
				end
			elseif Buttons[i].type == ButtonType.pickupData then
				for j = 1, table.getn(PickupData[GameSettings.version].rarity), 1 do
					if Input.isInRange(xmouse, ymouse, Buttons[i].box_first[1], Buttons[i].box_first[2] + j * (Buttons[i].box_first[4] + 2), Buttons[i].box_first[3], Buttons[i].box_first[4]) then
						LayoutSettings.selectedslot[j] = not LayoutSettings.selectedslot[j]
					end
				end
			elseif Buttons[i].type == ButtonType.catchData then
				local enabled = Buttons[i].enabled()
				for j = 1, table.getn(Buttons[i].text), 1 do
					if enabled[j] then
						if Input.isInRange(xmouse, ymouse, Buttons[i].box_first[1], Buttons[i].box_first[2] + j * Buttons[i].box_first[4], Buttons[i].box_first[3], Buttons[i].box_first[4]) then
							Buttons[i].onclick(j)
						end
					end
				end
			end
		end
	end	
end

function Input.isInRange(xmouse,ymouse,x,y,xregion,yregion)
	if xmouse >= x and xmouse <= x + xregion then
		if ymouse >= y and ymouse <= y + yregion then
			return true
		end
	end
	return false
end