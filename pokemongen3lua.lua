-- Lua Script made by MKDasher
-- Based on FractalFusion's VBA-rr lua scripts, with some extra features.

-- NOTE: On Bizhawk, go to Config / Display... Then uncheck Stretch pixels by integers only.

local DATA_FOLDER = "pokemongen3lua_data" -- if you want to rename this folder, make sure you rename it here too.
dofile (DATA_FOLDER .. "/pkmdata.lua")

--------------------------
--------- MENUS ----------
--------------------------

local BOTTOM_MENU_ITEMS = {"TRAINER", "RNG", "MISC"}
local RNGBATTLEMODE_ITEMS = {"Crit. Hit / dmg. range", "Damage range", "Miss", "Hit", "Quick claw", "Fully Paralyzed"}
local RNGCATCHMODE_ITEMS = {"AUTO", "MANUAL"}
local RNGOTHERMODE_ITEMS = {"Pokerus", "Test"}
local RNGMODE_ITEMS = {"BATTLE", "ENCOU.", "CATCH", "OTHER"}
local RNGENCMODE_ITEMS = {"GRASS", "WATER", "R.SMASH"}

--------------------------
------- CONSTANTS --------
--------------------------

local DOWN_GAP = 160
local UP_GAP = 15
local RIGHT_GAP = 150
local SCREEN_X = 240
local SCREEN_Y = 160
local PKM_ICON_SIZE = 32

local SELECTEDCOLOR = {"yellow", 0xFF555500}
local NONSELECTEDCOLOR = 0xFFAAAAAA

local TRAINER_PKM_POS = {4, SCREEN_Y + UP_GAP + 30}
local ENEMY_PKM_DIST = 70
local RNG_SQUARE_POS = {4, SCREEN_Y + UP_GAP * 2 + 4}
local CHANGESEED_POS = {SCREEN_X + RIGHT_GAP / 2 - 30, SCREEN_Y + DOWN_GAP - 2}
local CHANGESEED_SIZE = {60, 13}

local RNGSUBMENU_SIZE = {90, 13}
local RNGSUBMENU_POS = {100, SCREEN_Y + UP_GAP * 2 + 20}

local RNGMODE_SIZE = {136,13}
local RNGMODE_POS = {100, UP_GAP*2 + SCREEN_Y + 4}

local RNGCATCHITEM_POS = {150, SCREEN_Y + UP_GAP * 2 + 20}
local RNGCATCHITEM_SIZE = {80, 13}

--------------------------
-- GAME DEPENDENT VARS ---
--------------------------

local pstats = {0x3004360, 0x20244EC, 0x2024284, 0x3004290, 0x2024190, 0x20241E4} -- Player stats
local estats = {0x30045C0, 0x2024744, 0x202402C, 0x30044F0, 0x20243E8, 0x2023F8C} -- Enemy stats
local rng    = {0x3004818, 0x3005D80, 0x3005000, 0x3004748, 0x3005AE0, 0x3005040}
local rng2   = {0x0000000, 0x0000000, 0x20386D0, 0x0000000, 0x0000000, 0x203861C} -- FRLG only
local wram	 = {0x0000000, 0x2020000, 0x2020000, 0x0000000, 0x0000000, 0x201FF4C}

local mapbank = {0x20392FC, 0x203BC80, 0x203F3A8, 0x2038FF4, 0x203B94C, 0x203F31C}

local gamename
local game
local encountertable

--------------------------
---- GLOBAL VARIABLES ----
--------------------------

--input
local mousetab = {}
local mousetabprev = {}

--pokemon & trainer data tables
local pokemondata = {}
local trainerdata = {}
local enemydata = {}

--menu data
local showrightmenu = 1
local bottommenuindex = 1

--submenudata
local playerindex = 1
local pokemonindex = 1

--rngdata
local currng = 0
local rngmod = 2
local rngseed = 0
local rngmode = 1
local rngbattlemode = 1
local rngcatchmode = 1
local rngothermode = 1
local rngrate = {-1,-1,90,50,-1,-1}
local rngcols = 12

--catchdata
local catchdata = {
	pokemon = 1,
	curHP = 20,
	maxHP = 20,
	level = 5,
	ball = 4,
	status = 0,
	rng = 0,
	rate = 0
}

--encounterdata
local currentmap = 0
local encountermode = 1
local encounterdata = {{encrate=-1},{encrate=-1},{encrate=-1}}
local slots = {{20,20,10,10,10,10,5,5,4,4,1,1},{60,30,5,4,1},{60,30,5,4,1}}
local numslots = {12,5,5}

local slotcolors = {"red","blue","orange","purple","green","yellow","pink","cyan",0xFF66FF66,0xFF660000,0xFF000066,"black"}
local selectedslot = {true,false,false,false,false,false,false,false,false,false,false,false}

--forms
local formhandle
local texthandle
local dropdownhandle

--------------------------
----- AUX  FUNCTIONS -----
--------------------------

function getbits(a,b,d)
	return bit.rshift(a,b) % bit.lshift(1,d)
end

-- Used for RNG purposes
function gettop(a)
	return bit.rshift(a,16)
end

-- Used for RNG purposes
function memread(addr, size)
	mem = ""
	memdomain = bit.rshift(addr, 24)
	if memdomain == 0 then
		mem = "BIOS"
	elseif memdomain == 2 then
		mem = "EWRAM"
	elseif memdomain == 3 then
		mem = "IWRAM"
	elseif memdomain == 8 then
		mem = "ROM"
	end
	addr = bit.band(addr, 0xFFFFFF)
	if size == 1 then
		return memory.read_u8(addr,mem)
	elseif size == 2 then
		return memory.read_u16_le(addr,mem)
	elseif size == 3 then
		return memory.read_u24_le(addr,mem)
	else
		return memory.read_u32_le(addr,mem)
	end 
end

function mdword(addr)
	return memread(addr, 4)
end

function mword(addr)
	return memread(addr, 2)
end

function mbyte(addr)
	return memread(addr, 1)
end

-- 32-bit multiplication
function mult32(a,b)
	local c = bit.rshift(a,16)
	local d = a % 0x10000
	local e = bit.rshift(b,16)
	local f = b % 0x10000
	local g = (c*f + d*e) % 0x10000
	local h = d*f
	local i = g*0x10000 + h
	return i
end

-- Add halves; Used for checksum purposes
function ah(a)
	b = getbits(a,0,16)
	c = getbits(a,16,16)
	return b + c
end

function rngDecrease(a)
	return (mult32(a,0xEEB9EB65) + 0x0A3561A1) % 0x100000000
end

function rngAdvance(a)
	return (mult32(a,0x41C64E6D) + 0x6073) % 0x100000000
end

function rngAdvanceMulti(a, n) -- TODO, use tables to make this in O(logn) time
	for i = 1, n, 1 do
		a = mult32(a,0x41C64E6D) + 0x6073
	end
	return a
end

function rng2Advance(a)
	return mult32(a,0x41C64E6D) + 0x3039
end

function getRNGDistance(b,a)
    distseed=0
    for j=0,31,1 do
		if getbits(a,j,1)~=getbits(b,j,1) then
			b=mult32(b,multspa[j+1])+multspb[j+1]
			distseed=distseed+bit.lshift(1,j)
			if j==31 then
				distseed=distseed+0x100000000
			end
		end
    end
	return distseed
end

function tohex(a)
	mystr = bizstring.hex(a)
	while string.len(mystr) < 8 do
		mystr = "0" .. mystr
	end
	return mystr
end

--------------------------
----- DRAW FUNCTIONS -----
--------------------------

function text(x,y,text,color)
	gui.drawText(x,y,text,color,null,9,"Franklin Gothic Medium")
end

function drawTriangle(x,y,direction,color)
	gui.drawRectangle(x,y,UP_GAP,UP_GAP,color, 0x00000000)
	if direction == "right" then
		gui.drawPolygon({{4+x,3+y},{4+x,12+y},{11+x,8+y}},color, color)
	else
		gui.drawPolygon({{11+x,3+y},{11+x,12+y},{4+x,8+y}},color, color)
	end
end

function drawPokemonIcon(id, x, y, selectedPokemon)
	if id < 0 or id > 412 then
		id = 0
	end
	if selectedPokemon then
		gui.drawRectangle(x,y,36,36,SELECTEDCOLOR[1], SELECTEDCOLOR[2])
	else
		gui.drawRectangle(x,y,36,36,0xFFAAAAAA, 0xFF222222)
	end
	gui.drawImage(DATA_FOLDER .. "/Image/Pokemon/" .. id .. ".gif", x+2,y+2,32,32)
end

function drawRNGsquare(x, y, color)
	gui.drawRectangle(x*5 + RNG_SQUARE_POS[1] + 2, y*5 + RNG_SQUARE_POS[2] + 2, 3, 3, color, color)
end

--------------------------
------- WIN FORMS --------
--------------------------

function getTableValueIndex(myvalue, mytable)
	for i=1,table.getn(mytable),1 do
		if myvalue == mytable[i] then
			return i
		end
	end
	return 1
end

function onChangeSeedClick()
	rngseed = tonumber(forms.gettext(texthandle),16)
	forms.destroy(formhandle)
end

function changeSeedForm()
	forms.destroyall()
	formhandle = forms.newform(250,130,"Change Seed")
	texthandle = forms.textbox(formhandle, bizstring.hex(rngseed), 80, 30, "HEX", 75, 15)
	forms.button(formhandle, "Accept", onChangeSeedClick, 75, 50, 80, 30)
end

function onChangeCatchPokemonClick()
	catchdata["pokemon"] = getTableValueIndex(forms.gettext(dropdownhandle), pokemonName) - 1
	forms.destroy(formhandle)
end
function onChangeCatchCurHPClick()
	catchdata["curHP"] = tonumber(forms.gettext(texthandle))
	if catchdata["curHP"] < 1 then
		catchdata["curHP"] = 1
	elseif catchdata["curHP"] > 999 then
		catchdata["curHP"] = 999
	end
	forms.destroy(formhandle)
end
function onChangeCatchMaxHPClick()
	catchdata["maxHP"] = tonumber(forms.gettext(texthandle))
	if catchdata["maxHP"] < 1 then
		catchdata["maxHP"] = 1
	elseif catchdata["maxHP"] > 999 then
		catchdata["maxHP"] = 999
	end
	forms.destroy(formhandle)
end
function onChangeCatchStatusClick()
	catchdata["status"] = getTableValueIndex(forms.gettext(dropdownhandle), statusName) - 1
	forms.destroy(formhandle)
end
function onChangeCatchBallClick()
	ballaux = forms.gettext(dropdownhandle)
	if ballaux == "Master Ball" then
		catchdata["ball"] = 1
	elseif ballaux == "Ultra Ball" then
		catchdata["ball"] = 2
	elseif ballaux == "Great Ball" then
		catchdata["ball"] = 3
	elseif ballaux == "Safari Ball" then
		catchdata["ball"] = 5
	else
		catchdata["ball"] = 4
	end
	forms.destroy(formhandle)
end

function changeCatchForm(param)
	forms.destroyall()
	if param == "pokemon" then
		formhandle = forms.newform(250,130,"Change Pokemon")
		dropdownhandle = forms.dropdown(formhandle, pokemonName, 75, 15, 80, 30)
		forms.button(formhandle, "Accept", onChangeCatchPokemonClick, 75, 50, 80, 30)
	elseif param == "curHP" then
		formhandle = forms.newform(250,130,"Change Cur. HP")
		texthandle = forms.textbox(formhandle, catchdata["curHP"], 80, 30, "UNSIGNED", 75, 15)
		forms.button(formhandle, "Accept", onChangeCatchCurHPClick, 75, 50, 80, 30)
	elseif param == "maxHP" then
		formhandle = forms.newform(250,130,"Change Max. HP")
		texthandle = forms.textbox(formhandle, catchdata["maxHP"], 80, 30, "UNSIGNED", 75, 15)
		forms.button(formhandle, "Accept", onChangeCatchMaxHPClick, 75, 50, 80, 30)
	elseif param == "status" then
		formhandle = forms.newform(250,130,"Change status")
		dropdownhandle = forms.dropdown(formhandle, statusName, 75, 15, 80, 30)
		forms.button(formhandle, "Accept", onChangeCatchStatusClick, 75, 50, 80, 30)
	elseif param == "ball" then
		formhandle = forms.newform(250,130,"Change Ball")
		dropdownhandle = forms.dropdown(formhandle, {"Master Ball", "Ultra Ball", "Great Ball", "Poke Ball", "Safari Ball"}, 75, 15, 80, 30)
		forms.button(formhandle, "Accept", onChangeCatchBallClick, 75, 50, 80, 30)
	end
end

--------------------------
----- INPUT FUNCTIONS ----
--------------------------

function isInRange(xmouse,ymouse,x,y,xregion,yregion)
	if xmouse >= x and xmouse <= x + xregion then
		if ymouse >= y and ymouse <= y + yregion then
			return true
		end
	end
	return false
end

function inputCheck()
	mousetab = input.getmouse()
	if mousetab["Left"] and not mousetabprev["Left"] then
		xmouse = mousetab["X"]
		ymouse = mousetab["Y"] + UP_GAP
		-- Right menu
		if showrightmenu == 1 and isInRange(xmouse,ymouse, RIGHT_GAP + SCREEN_X - UP_GAP, 0, UP_GAP, UP_GAP) then
			showrightmenu = 0
			client.SetGameExtraPadding(0,UP_GAP,0,DOWN_GAP)
		elseif showrightmenu == 0 and isInRange(xmouse,ymouse, SCREEN_X - UP_GAP, 0, UP_GAP, UP_GAP) then
			showrightmenu = 1
			client.SetGameExtraPadding(0,UP_GAP,RIGHT_GAP,DOWN_GAP)
		end
		-- Bottom menu
		for i = 1,table.getn(BOTTOM_MENU_ITEMS),1 do
			if isInRange(xmouse,ymouse, (i-1)*(SCREEN_X/table.getn(BOTTOM_MENU_ITEMS)), UP_GAP + SCREEN_Y, SCREEN_X / table.getn(BOTTOM_MENU_ITEMS), UP_GAP) then
				bottommenuindex = i
			end
		end
		-- Trainer submenu
		if bottommenuindex == 1 then
			for i = 1,6,1 do
				if isInRange(xmouse,ymouse, TRAINER_PKM_POS[1] + (i-1) * 39, TRAINER_PKM_POS[2], 36, 36) then
					pokemonindex = i
					playerindex = 1
				end
				if isInRange(xmouse,ymouse, TRAINER_PKM_POS[1] + (i-1) * 39, TRAINER_PKM_POS[2] + ENEMY_PKM_DIST, 36, 36) then
					pokemonindex = i
					playerindex = 2
				end
			end
		end
		-- RNG submenu
		if bottommenuindex == 2 then	
			-- Left buttons
			if isInRange(xmouse, ymouse, 19, RNG_SQUARE_POS[2] + rngcols*5+5,RNGSUBMENU_SIZE[2],RNGSUBMENU_SIZE[2]) then
				rngmod = (rngmod % 3) + 1
			elseif isInRange(xmouse, ymouse, 59, RNG_SQUARE_POS[2] + rngcols*5+5,RNGSUBMENU_SIZE[2],RNGSUBMENU_SIZE[2]) then
				if rngcols > 2 then
					rngcols = rngcols - 1
				end
			elseif isInRange(xmouse, ymouse, 67, RNG_SQUARE_POS[2] + rngcols*5+5,RNGSUBMENU_SIZE[2],RNGSUBMENU_SIZE[2]) then
				if rngcols < 20 then
					rngcols = rngcols + 1
				end
			end
			
			-- RNG menu
			for i=1,table.getn(RNGMODE_ITEMS),1 do
				if isInRange(xmouse, ymouse, RNGMODE_POS[1] + (i-1) * RNGMODE_SIZE[1] / table.getn(RNGMODE_ITEMS), RNGMODE_POS[2], RNGMODE_SIZE[1] / table.getn(RNGMODE_ITEMS), RNGMODE_SIZE[2]) then
					rngmode=i
				end
			end
			
			-- RNG Battle mode
			if rngmode == 1 then
				for i = 1,table.getn(RNGBATTLEMODE_ITEMS),1 do
					if isInRange(xmouse, ymouse, RNGSUBMENU_POS[1], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[1], RNGSUBMENU_SIZE[2]) then
						rngbattlemode = i
					elseif rngrate[i] >= 0 then
						if isInRange(xmouse, ymouse, RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2]) then
							rngbattlemode = i
							if rngrate[i] > 0 then
								rngrate[i] = rngrate[i] - 5
							end
						elseif isInRange(xmouse, ymouse, RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + RNGSUBMENU_SIZE[2], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2]) then
							rngbattlemode = i
							if rngrate[i] < 100 then
								rngrate[i] = rngrate[i] + 5
							end
						end
					end
				end
			-- RNG Encounter Mode
			elseif rngmode == 2 then
				-- Menu
				for i=1,table.getn(RNGENCMODE_ITEMS),1 do
					if isInRange(xmouse, ymouse, RNGMODE_POS[1] + (i-1) * RNGMODE_SIZE[1] / table.getn(RNGENCMODE_ITEMS), RNGMODE_POS[2]+16, RNGMODE_SIZE[1] / table.getn(RNGENCMODE_ITEMS), RNGMODE_SIZE[2]) then
						encountermode=i
					end
				end
				-- Slots
				if encounterdata[encountermode]["encrate"] > 0 then
					for i=1,numslots[encountermode],1 do
						if isInRange(xmouse,ymouse,100, 217+i*9, 135, 7) then
							selectedslot[i] = not selectedslot[i]
						end
					end
				end
			-- RNG Catch mode
			elseif rngmode == 3 then
				-- Menu
				for i = 1,table.getn(RNGCATCHMODE_ITEMS),1 do
					if isInRange(xmouse, ymouse, RNGMODE_POS[1] + (i-1) * RNGMODE_SIZE[1] / table.getn(RNGCATCHMODE_ITEMS), RNGMODE_POS[2]+16, RNGMODE_SIZE[1] / table.getn(RNGCATCHMODE_ITEMS), RNGMODE_SIZE[2]) then
						rngcatchmode=i
					end
				end
				-- Items
				if rngcatchmode == 2 then
					if isInRange(xmouse, ymouse, RNGCATCHITEM_POS[1], RNGCATCHITEM_POS[2] + 1*RNGCATCHITEM_SIZE[2] + 3, RNGCATCHITEM_SIZE[1], RNGCATCHITEM_SIZE[2]) then
						changeCatchForm('pokemon')
					elseif isInRange(xmouse, ymouse, RNGCATCHITEM_POS[1], RNGCATCHITEM_POS[2] + 2*RNGCATCHITEM_SIZE[2] + 3, RNGCATCHITEM_SIZE[1], RNGCATCHITEM_SIZE[2]) then
						changeCatchForm('curHP')
					elseif isInRange(xmouse, ymouse, RNGCATCHITEM_POS[1], RNGCATCHITEM_POS[2] + 3*RNGCATCHITEM_SIZE[2] + 3, RNGCATCHITEM_SIZE[1], RNGCATCHITEM_SIZE[2]) then
						changeCatchForm('maxHP')
					elseif isInRange(xmouse, ymouse, RNGCATCHITEM_POS[1], RNGCATCHITEM_POS[2] + 4*RNGCATCHITEM_SIZE[2] + 3, RNGCATCHITEM_SIZE[1], RNGCATCHITEM_SIZE[2]) then
						changeCatchForm('status')
					end	
				end
				if isInRange(xmouse, ymouse, RNGCATCHITEM_POS[1], RNGCATCHITEM_POS[2] + 5*RNGCATCHITEM_SIZE[2] + 3, RNGCATCHITEM_SIZE[1], RNGCATCHITEM_SIZE[2]) then
					changeCatchForm('ball')	
				end
				
			-- RNG Other mode
			elseif rngmode == 4 then
				for i = 1,table.getn(RNGOTHERMODE_ITEMS),1 do
					if isInRange(xmouse, ymouse, RNGSUBMENU_POS[1], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[1], RNGSUBMENU_SIZE[2]) then
						rngothermode = i
					end
				end
			end
		end
		-- Change seed
		if showrightmenu == 1 and isInRange(xmouse,ymouse,CHANGESEED_POS[1],CHANGESEED_POS[2],CHANGESEED_SIZE[1],CHANGESEED_SIZE[2]) then
			changeSeedForm()
		end
	end
	mousetabprev = mousetab
end

--------------------------
------- FUNCTIONS --------
--------------------------

function getGame()
	a = memory.read_u32_be(0x0000AC, "ROM")
	if a == 0x41585645 then
		game = 1
		gamename = "Pokemon Ruby (U)"
		encountertable = 0x839D454
	elseif a == 0x41585045 then
		game = 1
		gamename = "Pokemon Sapphire (U)"
		encountertable = 0x839D29C
	elseif a == 0x42504545 then
		game = 2
		gamename = "Pokemon Emerald (U)"
		encountertable = 0x8552D48
	elseif a == 0x42505245 then
		game = 3
		gamename = "Pokemon FireRed (U)"
		encountertable = 0x83C9CB8
	elseif a == 0x42504745 then
		game = 3
		gamename = "Pokemon LeafGreen (U)"
		encountertable = 0x83C9AF4
	elseif a == 0x4158564A then
		game = 4
		gamename = "Pokemon Ruby (J)"
		encountertable = 0x8379304
	elseif a == 0x4158504A then
		game = 4
		gamename = "Pokemon Sapphire (J)"
		encountertable = 0x83792FC
	elseif a == 0x4250454A then
		game = 5
		gamename = "Pokemon Emerald (J)"
		encountertable = 0x852D9F4
	elseif a == 0x4250524A then
		game = 6
		gamename = "Pokemon FireRed (J)"
		encountertable = 0x8390B34
	elseif a == 0x4250474A then
		game = 6
		gamename = "Pokemon LeafGreen (J)"
		encountertable = 0x83909A4
	else
		game = 0
		gamename = "Invalid game"
	end
	
	if game % 3 == 1 then
	rngseed = 0x5A0
	else
		rngseed = mword(wram[game])
	end
end

function getPokemonData(index, pokemonIndex)
	if index == 2 then
		start = estats[game] + 100 * (pokemonIndex - 1)
	else -- index = 2
		start = pstats[game] + 100 * (pokemonIndex - 1)
	end
	personality = mdword(start)
	otid = mdword(start + 4)
	magicword = bit.bxor(personality, otid)
	
	aux = personality % 24
	growthoffset=(growthtbl[aux+1]-1)*12
	attackoffset=(attacktbl[aux+1]-1)*12
	effortoffset=(efforttbl[aux+1]-1)*12
	miscoffset=(misctbl[aux+1]-1)*12
	
	growth1=bit.bxor(mdword(start+32+growthoffset),magicword)
	growth2=bit.bxor(mdword(start+32+growthoffset+4),magicword)
	growth3=bit.bxor(mdword(start+32+growthoffset+8),magicword)
	
	attack1=bit.bxor(mdword(start+32+attackoffset),magicword)
	attack2=bit.bxor(mdword(start+32+attackoffset+4),magicword)
	attack3=bit.bxor(mdword(start+32+attackoffset+8),magicword)
	
	effort1=bit.bxor(mdword(start+32+effortoffset),magicword)
	effort2=bit.bxor(mdword(start+32+effortoffset+4),magicword)
	effort3=bit.bxor(mdword(start+32+effortoffset+8),magicword)
	
	misc1=bit.bxor(mdword(start+32+miscoffset),magicword)
	misc2=bit.bxor(mdword(start+32+miscoffset+4),magicword)
	misc3=bit.bxor(mdword(start+32+miscoffset+8),magicword)
	
	cs=ah(growth1)+ah(growth2)+ah(growth3)+ah(attack1)+ah(attack2)
	  +ah(attack3)+ah(effort1)+ah(effort2)+ah(effort3)+ah(misc1)
	  +ah(misc2)+ah(misc3)
	cs=cs%65536
	
	pkmi=getbits(growth1,0,16)
    hitem=getbits(growth1,16,16)
    pkrs=getbits(misc1,0,8)

	m1=getbits(attack1,0,16)
	m2=getbits(attack1,16,16)
	m3=getbits(attack2,0,16)
	m4=getbits(attack2,16,16)
	
	status_aux = mdword(start+80)
	sleepturns = 0
	status_result = 0
	if status_aux == 0 then
		status_result = 0
	elseif status_aux < 8 then
		sleepturns = status_aux
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
	
	return {pokemonID=pkmi, heldItem=hitem, pokerus=pkrs, tid=getbits(otid, 0, 16),
		sid=getbits(otid, 16, 16), iv=misc2, ev1=effort1, ev2=effort2,
		status=status_result, level=mbyte(start+84), nature=personality%25,
		pp=attack3, move1=m1, move2=m2, move3=m3, move4=m4, curHP=mword(start+86),
		maxHP=mword(start+88), atk=mword(start+90), def=mword(start+92),
		spe=mword(start+94), spa=mword(start+96), spd=mword(start+98),
		sleep_turns=sleepturns}
end

function getTrainerData(index)
	pkmi = {}
	cHP = {}
	mHP = {}
	lvl = {}
	if index == 2 then
		st = estats[game]
	else -- index = 2
		st = pstats[game]
	end
	for i=1,6,1 do
		start = st + 100 * (i - 1)
		pkmi[i]=getbits(growth1,0,16)
		personality = mdword(start)
		magicword = bit.bxor(personality, mdword(start + 4))
		aux = personality % 24
		growthoffset=(growthtbl[(personality % 24)+1]-1)*12
		growth1=bit.bxor(mdword(start+32+growthoffset),magicword)
		pkmi[i]=getbits(growth1,0,16)
		lvl[i] = mbyte(start+84)
		cHP[i] = mword(start+86)
		mHP[i] = mword(start+88)
	end
return {pkmID=pkmi, curHP=cHP, maxHP=mHP, level=lvl}
end

function getEncounterData()
	-- Search map in ROM's table
	if currentmap == 0 then
		return {{encrate = -10},{encrate = -10}, {encrate = -10}}
	end	
	comparemap = mword(encountertable)
	index = 0
	while comparemap ~= currentmap do
		index = index + 1
		comparemap = mword(encountertable + 20*index)
		if comparemap == 0xFFFF then
			return {{encrate = -1},{encrate = -1}, {encrate = -1}}
		end
	end
	
	-- Search encounter data
	newdata = {}
	for i=1,3,1 do
		minl = {}
		maxl = {}
		pkm = {}
		pointer = mdword(encountertable + 20*index + 4*i)
		if pointer == 0 then
			newdata[i] = {encrate = -2}
		else
			pointer2 = pointer
			ratio = mword(pointer)
			if ratio == 0xFFFF then
				newdata[i] = {encrate = -3}
			else
				pointer = mdword(pointer + 4)
				for j = 1,numslots[i],1 do
					pkmdata = mdword(pointer + (j-1)*4)
					minl[j] = getbits(pkmdata, 0, 8)
					maxl[j] = getbits(pkmdata, 8, 8)
					pkm[j] = getbits(pkmdata, 16, 16)
				end
				newdata[i] = {encrate=ratio, pokemon=pkm, minlevel=minl, maxlevel=maxl}
			end
		end
	end
	
	return newdata
end

-- Check if data is valid to avoid data fluctuation
function validPokemonData(pkmdaux)
	if pkmdaux["pokemonID"] < 0 or pkmdaux["pokemonID"] > 412 or pkmdaux["heldItem"] < 0 or pkmdaux["heldItem"] > 376 then
		return false
	elseif pkmdaux["move1"] < 0 or pkmdaux["move2"] < 0 or pkmdaux["move3"] < 0 or pkmdaux["move4"] < 0 then		
		return false
	elseif pkmdaux["move1"] > 354 or pkmdaux["move2"] > 354 or pkmdaux["move3"] > 354 or pkmdaux["move4"] > 354 then
		return false
	else
		return true
	end
end

function drawLayout()
	gui.drawRectangle(SCREEN_X,0,RIGHT_GAP - 1,UP_GAP + DOWN_GAP + SCREEN_Y - 1,0xFF00AA00, 0x00000000)
	gui.drawRectangle(0,0, SCREEN_X, UP_GAP, 0xFF00AA00, 0xFF004400)
	gui.drawText(SCREEN_X / 2 - ((string.len(gamename)+6) * 3),3,"Game: " .. gamename,"white", 0x00000000, 10, "Lucida Console") --Centered Text
end

function drawBottomMenu()
	itemcount = table.getn(BOTTOM_MENU_ITEMS)
	itemsize = SCREEN_X / itemcount
	for i=1,itemcount,1 do
		gui.drawRectangle((i-1)*itemsize, UP_GAP + SCREEN_Y, itemsize, UP_GAP, NONSELECTEDCOLOR)
		text((i-1)*itemsize, UP_GAP + SCREEN_Y + 2, BOTTOM_MENU_ITEMS[i], NONSELECTEDCOLOR)
	end
	gui.drawRectangle((bottommenuindex-1)*itemsize, UP_GAP + SCREEN_Y, itemsize, UP_GAP, SELECTEDCOLOR[1], SELECTEDCOLOR[2])
	text((bottommenuindex-1)*itemsize, UP_GAP + SCREEN_Y + 2, BOTTOM_MENU_ITEMS[bottommenuindex], SELECTEDCOLOR[1])
end

function getNatureColor(stat, nature)
	color = "white"
	if nature % 6 == 0 then
		color = "white"
	elseif stat == "atk" then
		if nature < 5 then
			color = 0xFF00FF00
		elseif nature % 5 == 0 then
			color = "red"
		end
	elseif stat == "def" then
		if nature > 4 and nature < 10 then
			color = 0xFF00FF00
		elseif nature % 5 == 1 then
			color = "red"
		end
	elseif stat == "spe" then
		if nature > 9 and nature < 15 then
			color = 0xFF00FF00
		elseif nature % 5 == 2 then
			color = "red"
		end
	elseif stat == "spa" then
		if nature > 14 and nature < 20 then
			color = 0xFF00FF00
		elseif nature % 5 == 3 then
			color = "red"
		end
	elseif stat == "spd" then
		if nature > 19 then
			color = 0xFF00FF00
		elseif nature % 5 == 4 then
			color = "red"
		end
	end
	return color
end

function drawPokemonView()
	drawPokemonIcon(pokemondata["pokemonID"], SCREEN_X + 5, 5)
	colorbar = "white"

	if pokemondata["curHP"] / pokemondata["maxHP"] <= 0.2 then
		colorbar = "red"
	elseif pokemondata["curHP"] / pokemondata["maxHP"] <= 0.5 then
		colorbar = "yellow"
	end
	
	text(SCREEN_X + 45, 7, pokemonName[pokemondata["pokemonID"] + 1])
	text(SCREEN_X + 45, 17, "HP:")
	text(SCREEN_X + 60, 17, pokemondata["curHP"] .. " / " .. pokemondata["maxHP"], colorbar)
	text(SCREEN_X + 45, 27, "Level: " .. pokemondata["level"])
	
	text(SCREEN_X + 5, 43, "Item:")
	text(SCREEN_X + 42, 43, itemName[pokemondata["heldItem"] + 1], "yellow")
	text(SCREEN_X + 5, 53, "PKRS:")
	text(SCREEN_X + 42, 53, pokemondata["pokerus"], "yellow")
	text(SCREEN_X + 5, 63, "OT ID:")
	text(SCREEN_X + 42, 63, pokemondata["tid"], "yellow")
	text(SCREEN_X + 75, 63, "OT SID:")
	text(SCREEN_X + 112, 63, pokemondata["sid"], "yellow")
	
	gui.drawRectangle(SCREEN_X + 5, 75, RIGHT_GAP - 11, 85,0xFFAAAAAA, 0xFF222222)
	
	text(SCREEN_X + 60, 80, "Stat", "white")
	text(SCREEN_X + 90, 80, "IV", "white")
	text(SCREEN_X + 120, 80, "EV", "white")
	
	text(SCREEN_X + 10, 95, "HP", getNatureColor("hp", pokemondata["nature"]))
	text(SCREEN_X + 10, 105, "Attack", getNatureColor("atk", pokemondata["nature"]))
	text(SCREEN_X + 10, 115, "Defense", getNatureColor("def", pokemondata["nature"]))
	text(SCREEN_X + 10, 125, "Sp. Atk", getNatureColor("spa", pokemondata["nature"]))
	text(SCREEN_X + 10, 135, "Sp. Def", getNatureColor("spd", pokemondata["nature"]))
	text(SCREEN_X + 10, 145, "Speed", getNatureColor("spe", pokemondata["nature"]))
	
	text(SCREEN_X + 60, 95, pokemondata["maxHP"], getNatureColor("hp", pokemondata["nature"]))
	text(SCREEN_X + 60, 105, pokemondata["atk"], getNatureColor("atk", pokemondata["nature"]))
	text(SCREEN_X + 60, 115, pokemondata["def"], getNatureColor("def", pokemondata["nature"]))
	text(SCREEN_X + 60, 125, pokemondata["spa"], getNatureColor("spa", pokemondata["nature"]))
	text(SCREEN_X + 60, 135, pokemondata["spd"], getNatureColor("spd", pokemondata["nature"]))
	text(SCREEN_X + 60, 145, pokemondata["spe"], getNatureColor("spe", pokemondata["nature"]))

	hpiv = getbits(pokemondata["iv"],0,5)
	atkiv = getbits(pokemondata["iv"],5,5)
	defiv = getbits(pokemondata["iv"],10,5)
	speiv = getbits(pokemondata["iv"],15,5)
	spaiv = getbits(pokemondata["iv"],20,5)
	spdiv = getbits(pokemondata["iv"],25,5)
	
	text(SCREEN_X + 90, 95, hpiv, getNatureColor("hp", pokemondata["nature"]))
	text(SCREEN_X + 90, 105, atkiv, getNatureColor("atk", pokemondata["nature"]))
	text(SCREEN_X + 90, 115, defiv, getNatureColor("def", pokemondata["nature"]))
	text(SCREEN_X + 90, 125, spaiv, getNatureColor("spa", pokemondata["nature"]))
	text(SCREEN_X + 90, 135, spdiv, getNatureColor("spd", pokemondata["nature"]))
	text(SCREEN_X + 90, 145, speiv, getNatureColor("spe", pokemondata["nature"]))
	
	text(SCREEN_X + 120, 95, getbits(pokemondata["ev1"], 0, 8), getNatureColor("hp", pokemondata["nature"]))
	text(SCREEN_X + 120, 105, getbits(pokemondata["ev1"], 8, 8), getNatureColor("atk", pokemondata["nature"]))
	text(SCREEN_X + 120, 115, getbits(pokemondata["ev1"], 16, 8), getNatureColor("def", pokemondata["nature"]))
	text(SCREEN_X + 120, 125, getbits(pokemondata["ev2"], 0, 8), getNatureColor("spa", pokemondata["nature"]))
	text(SCREEN_X + 120, 135, getbits(pokemondata["ev2"], 8, 8), getNatureColor("spd", pokemondata["nature"]))
	text(SCREEN_X + 120, 145, getbits(pokemondata["ev1"], 24, 8), getNatureColor("spe", pokemondata["nature"]))
	
	hptype = math.floor(((hpiv%2 + 2*(atkiv%2) + 4*(defiv%2) + 8*(speiv%2) + 16*(spaiv%2) + 32*(spdiv%2))*15)/63)
    hppower = math.floor(((getbits(hpiv,1,1) + 2*getbits(atkiv,1,1) + 4*getbits(defiv,1,1) + 8*getbits(speiv,1,1) + 16*getbits(spaiv,1,1) + 32*getbits(spdiv,1,1))*40)/63 + 30)
	
	text(SCREEN_X + 15, 162, "Nature:")
	text(SCREEN_X + 80, 162, natureName[pokemondata["nature"] + 1], "yellow")
	text(SCREEN_X + 15, 172, "Hidden Power:")
	text(SCREEN_X + 80, 172, typeName[hptype + 1] .. "  " .. hppower, "yellow")
	
	gui.drawRectangle(SCREEN_X + 5, 185, RIGHT_GAP - 11, 65,0xFFAAAAAA, 0xFF222222)
	
	text(SCREEN_X + 10, 205, moveName[pokemondata["move1"] + 1])
	text(SCREEN_X + 10, 215, moveName[pokemondata["move2"] + 1])
	text(SCREEN_X + 10, 225, moveName[pokemondata["move3"] + 1])
	text(SCREEN_X + 10, 235, moveName[pokemondata["move4"] + 1])
	
	text(SCREEN_X + 90, 190, "PP")
	text(SCREEN_X + 90, 205, getbits(pokemondata["pp"], 0, 8))
	text(SCREEN_X + 90, 215, getbits(pokemondata["pp"], 8, 8))
	text(SCREEN_X + 90, 225, getbits(pokemondata["pp"], 16, 8))
	text(SCREEN_X + 90, 235, getbits(pokemondata["pp"], 24, 8))
end

function drawTrainerView()
	gui.drawText(8,TRAINER_PKM_POS[2] - 13,"Player Data","cyan",null,10, "Arial")
	for i=1,6,1 do
		drawPokemonIcon(trainerdata["pkmID"][i], TRAINER_PKM_POS[1] + (i-1) * 39, TRAINER_PKM_POS[2], pokemonindex==i and playerindex==1)
		if trainerdata["pkmID"][i] > 0 then
			colorbar = "white"
			curhp = trainerdata["curHP"][i]
			maxhp = trainerdata["maxHP"][i]
			if curhp / maxhp <= 0.2 then
				colorbar = "red"
			elseif curhp / maxhp <= 0.5 then
				colorbar = "yellow"
			end
			text(TRAINER_PKM_POS[1] + (i-1) * 39, TRAINER_PKM_POS[2] + 36, "Lv. " .. trainerdata["level"][i])
			text(TRAINER_PKM_POS[1] + (i-1) * 39 - 1, TRAINER_PKM_POS[2] + 46, curhp .. "/" .. maxhp, colorbar)
		end
	end
	gui.drawText(8,TRAINER_PKM_POS[2] + ENEMY_PKM_DIST - 13,"Enemy Data","cyan",null,10, "Arial")
	for i=1,6,1 do
		drawPokemonIcon(enemydata["pkmID"][i], TRAINER_PKM_POS[1] + (i-1) * 39, TRAINER_PKM_POS[2] + ENEMY_PKM_DIST, pokemonindex==i and playerindex==2)
		if enemydata["pkmID"][i] > 0 then
			colorbar = "white"
			curhp = enemydata["curHP"][i]
			maxhp = enemydata["maxHP"][i]
			if curhp / maxhp <= 0.2 then
				colorbar = "red"
			elseif curhp / maxhp <= 0.5 then
				colorbar = "yellow"
			end
			text(TRAINER_PKM_POS[1] + (i-1) * 39, TRAINER_PKM_POS[2] + ENEMY_PKM_DIST + 36, "Lv. " .. enemydata["level"][i])
			text(TRAINER_PKM_POS[1] + (i-1) * 39 - 1, TRAINER_PKM_POS[2] + ENEMY_PKM_DIST + 46, curhp .. "/" .. maxhp, colorbar)
		end
	end
end

function drawRNGView()
	-- RNG squares and text below
	textstart = RNG_SQUARE_POS[2] + rngcols*5 + 20
	prevrng = currng
	currng = mdword(rng[game])
	
	text(2, textstart, "RNG value:")
	text(50, textstart, tohex(currng), "yellow")
	text(2, textstart+10, "RNG prev:")
	text(50, textstart+10, tohex(prevrng), "yellow")
	text(2, textstart+20, "Dist. last:")
	distancelast = getRNGDistance(prevrng,currng)
	text(50, textstart+20, distancelast, "yellow")
	text(2, textstart+30, "RNG frame:")
	text(50, textstart+30, getRNGDistance(rngseed,currng), "yellow")
	
	gui.drawRectangle(19, textstart - 15, RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2])
	gui.drawRectangle(54, textstart - 15, RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2])
	gui.drawRectangle(67, textstart - 15, RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2])
	text(22, textstart - 14, rngmod)
	text(57, textstart - 14, "-")
	text(70, textstart - 14, "+")
	
	-- RNG mode menu
	rngmodecount = table.getn(RNGMODE_ITEMS)
	for i=1,rngmodecount,1 do
		gui.drawRectangle(RNGMODE_POS[1] + (i-1)*RNGMODE_SIZE[1] / rngmodecount, RNGMODE_POS[2], RNGMODE_SIZE[1] / rngmodecount,RNGMODE_SIZE[2],NONSELECTEDCOLOR)
		text(RNGMODE_POS[1] + (i-1)*RNGMODE_SIZE[1] / rngmodecount + 2, RNGMODE_POS[2] + 1, RNGMODE_ITEMS[i], NONSELECTEDCOLOR)
	end
	gui.drawRectangle(RNGMODE_POS[1] + (rngmode-1)*RNGMODE_SIZE[1] / rngmodecount, RNGMODE_POS[2], RNGMODE_SIZE[1] / rngmodecount,RNGMODE_SIZE[2],SELECTEDCOLOR[1],SELECTEDCOLOR[2])
	text(RNGMODE_POS[1] + (rngmode-1)*RNGMODE_SIZE[1] / rngmodecount + 2, RNGMODE_POS[2] + 1, RNGMODE_ITEMS[rngmode], SELECTEDCOLOR[1])

	-- RNG battle menu
	if rngmode == 1 then
		-- Update Miss and Hit Texts:
		for i = 1, table.getn(RNGBATTLEMODE_ITEMS), 1 do
			rngbattlemode_text = RNGBATTLEMODE_ITEMS[i]
			if rngrate[i] >= 0 then
				rngbattlemode_text = rngbattlemode_text .. " (" .. rngrate[i] .. "% acc.)"
				gui.drawRectangle(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], NONSELECTEDCOLOR)
				gui.drawRectangle(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + RNGSUBMENU_SIZE[2], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], NONSELECTEDCOLOR)
				text(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + 4, RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2] + 1, "-", NONSELECTEDCOLOR)
				text(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + 16, RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2] + 1, "+", NONSELECTEDCOLOR)
			end
			gui.drawRectangle(RNGSUBMENU_POS[1], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[1], RNGSUBMENU_SIZE[2], NONSELECTEDCOLOR)
			text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2] + 1, rngbattlemode_text, NONSELECTEDCOLOR)
		end
		rngbattlemode_text = RNGBATTLEMODE_ITEMS[rngbattlemode]
		if rngrate[rngbattlemode] >= 0 then
			rngbattlemode_text = rngbattlemode_text .. " (" .. rngrate[rngbattlemode] .. "% acc.)"
			gui.drawRectangle(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1], RNGSUBMENU_POS[2] + (rngbattlemode-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], SELECTEDCOLOR[1], SELECTEDCOLOR[2])
			gui.drawRectangle(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + RNGSUBMENU_SIZE[2], RNGSUBMENU_POS[2] + (rngbattlemode-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[2], SELECTEDCOLOR[1], SELECTEDCOLOR[2])
			text(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + 4, RNGSUBMENU_POS[2] + (rngbattlemode-1)*RNGSUBMENU_SIZE[2] + 1, "-", SELECTEDCOLOR[1])
			text(RNGSUBMENU_POS[1] + RNGSUBMENU_SIZE[1] + 16, RNGSUBMENU_POS[2] + (rngbattlemode-1)*RNGSUBMENU_SIZE[2] + 1, "+", SELECTEDCOLOR[1])
		end
		gui.drawRectangle(RNGSUBMENU_POS[1], RNGSUBMENU_POS[2] + (rngbattlemode-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[1], RNGSUBMENU_SIZE[2], SELECTEDCOLOR[1], SELECTEDCOLOR[2])
		text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + (rngbattlemode-1)*RNGSUBMENU_SIZE[2] + 1, rngbattlemode_text, SELECTEDCOLOR[1])
	end
	
	-- RNG encounter menu
	if rngmode == 2 then
		enccount = table.getn(RNGENCMODE_ITEMS)
		for i=1,enccount,1 do
			gui.drawRectangle(RNGMODE_POS[1] + (i-1)*RNGMODE_SIZE[1] / enccount, RNGMODE_POS[2] + 16, RNGMODE_SIZE[1] / enccount,RNGMODE_SIZE[2],NONSELECTEDCOLOR)
			text(RNGMODE_POS[1] + (i-1)*RNGMODE_SIZE[1] / enccount + 2, RNGMODE_POS[2] + 17, RNGENCMODE_ITEMS[i], NONSELECTEDCOLOR)
		end
		gui.drawRectangle(RNGMODE_POS[1] + (encountermode-1)*RNGMODE_SIZE[1] / enccount, RNGMODE_POS[2] + 16, RNGMODE_SIZE[1] / enccount,RNGMODE_SIZE[2],SELECTEDCOLOR[1],SELECTEDCOLOR[2])
		text(RNGMODE_POS[1] + (encountermode-1)*RNGMODE_SIZE[1] / enccount + 2, RNGMODE_POS[2] + 17, RNGENCMODE_ITEMS[encountermode], SELECTEDCOLOR[1])
	end
	
	-- RNG encounter info
	if rngmode == 2 then
		if encounterdata[encountermode]["encrate"] > 0 then
			for i=1,numslots[encountermode],1 do
				if encounterdata[encountermode]["minlevel"][i] == encounterdata[encountermode]["maxlevel"][i] then
					levelstr = encounterdata[encountermode]["minlevel"][i]
				else
					levelstr = encounterdata[encountermode]["minlevel"][i] .. "-" .. encounterdata[encountermode]["maxlevel"][i]
				end
				if selectedslot[i] then
					gui.drawRectangle(100, 217+i*9, 7, 7, "white", slotcolors[i])
					text(110, 215+i*9, "Slot " .. i .. " (" .. slots[encountermode][i] .. "%):")
					text(161, 215+i*9, pokemonName[encounterdata[encountermode]["pokemon"][i]+1] .. " Lv. " .. levelstr)
				else
					gui.drawRectangle(100, 217+i*9, 7, 7, "gray", slotcolors[i])
					text(110, 215+i*9, "Slot " .. i .. " (" .. slots[encountermode][i] .. "%):", "gray")
					text(161, 215+i*9, pokemonName[encounterdata[encountermode]["pokemon"][i]+1] .. " Lv. " .. levelstr, "gray")
				end
			end
		else
			text(110, 224, "No encounters")
		end
	end
	
	-- RNG Catch Menu
	if rngmode == 3 then
		enccount = table.getn(RNGCATCHMODE_ITEMS)
		for i=1,enccount,1 do
			gui.drawRectangle(RNGMODE_POS[1] + (i-1)*RNGMODE_SIZE[1] / enccount, RNGMODE_POS[2] + 16, RNGMODE_SIZE[1] / enccount,RNGMODE_SIZE[2],NONSELECTEDCOLOR)
			text(RNGMODE_POS[1] + (i-1)*RNGMODE_SIZE[1] / enccount + 2, RNGMODE_POS[2] + 17, RNGCATCHMODE_ITEMS[i], NONSELECTEDCOLOR)
		end
		gui.drawRectangle(RNGMODE_POS[1] + (rngcatchmode-1)*RNGMODE_SIZE[1] / enccount, RNGMODE_POS[2] + 16, RNGMODE_SIZE[1] / enccount,RNGMODE_SIZE[2],SELECTEDCOLOR[1],SELECTEDCOLOR[2])
		text(RNGMODE_POS[1] + (rngcatchmode-1)*RNGMODE_SIZE[1] / enccount + 2, RNGMODE_POS[2] + 17, RNGCATCHMODE_ITEMS[rngcatchmode], SELECTEDCOLOR[1])
	end
	
	-- RNG Catch Data
	if rngmode == 3 then
		catchitem_text = {"Pokemon", "Cur. HP", "Max. HP", "Status", "Ball"}
		catchitem_data = {pokemonName[catchdata["pokemon"] + 1], catchdata["curHP"], catchdata["maxHP"], statusName[catchdata["status"] + 1], itemName[catchdata["ball"] + 1]}
		
		coloritemauto = "white"
		if rngcatchmode == 1 then
			coloritemauto = NONSELECTEDCOLOR
		end
		coloritem = {coloritemauto,coloritemauto,coloritemauto,coloritemauto,"white"}
		
		for i=1,table.getn(catchitem_text),1 do
			gui.drawRectangle(RNGCATCHITEM_POS[1], RNGCATCHITEM_POS[2] + i*RNGCATCHITEM_SIZE[2] + 3, RNGCATCHITEM_SIZE[1], RNGCATCHITEM_SIZE[2], NONSELECTEDCOLOR)
			text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + i*RNGSUBMENU_SIZE[2] + 4, catchitem_text[i] .. ":", NONSELECTEDCOLOR)
			text(RNGCATCHITEM_POS[1] + 2, RNGSUBMENU_POS[2] + i*RNGSUBMENU_SIZE[2] + 4, catchitem_data[i], coloritem[i])
		end
		
		text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + 6*RNGSUBMENU_SIZE[2] + 8, "RNG:", NONSELECTEDCOLOR)
		text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + 7*RNGSUBMENU_SIZE[2] + 8, "Catch rate:", NONSELECTEDCOLOR)
		
		text(RNGCATCHITEM_POS[1] + 2, RNGSUBMENU_POS[2] + 6*RNGSUBMENU_SIZE[2] + 8, catchdata["rng"] .. " / 65536", SELECTEDCOLOR[1])
		text(RNGCATCHITEM_POS[1] + 2, RNGSUBMENU_POS[2] + 7*RNGSUBMENU_SIZE[2] + 8, (catchdata["rate"] * 100) .. "%", SELECTEDCOLOR[1])		
	end
	
	-- RNG Other Menu
	if rngmode == 4 then
		for i = 1, table.getn(RNGOTHERMODE_ITEMS), 1 do
			gui.drawRectangle(RNGSUBMENU_POS[1], RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[1], RNGSUBMENU_SIZE[2], NONSELECTEDCOLOR)
			text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + (i-1)*RNGSUBMENU_SIZE[2] + 1, RNGOTHERMODE_ITEMS[i], NONSELECTEDCOLOR)
		end
		gui.drawRectangle(RNGSUBMENU_POS[1], RNGSUBMENU_POS[2] + (rngothermode-1)*RNGSUBMENU_SIZE[2], RNGSUBMENU_SIZE[1], RNGSUBMENU_SIZE[2], SELECTEDCOLOR[1], SELECTEDCOLOR[2])
		text(RNGSUBMENU_POS[1] + 2, RNGSUBMENU_POS[2] + (rngothermode-1)*RNGSUBMENU_SIZE[2] + 1, RNGOTHERMODE_ITEMS[rngothermode], SELECTEDCOLOR[1])
	end
	
	-- RNG square
	if distancelast <= rngmod then
		gui.drawRectangle(RNG_SQUARE_POS[1], RNG_SQUARE_POS[2], 18 * 5 + 2, rngcols * 5 + 2, 0xFFFFFFFF)
	else
		gui.drawRectangle(RNG_SQUARE_POS[1], RNG_SQUARE_POS[2], 18 * 5 + 2, rngcols * 5 + 2, "red", 0xFF555500)
	end	
	testrng = currng
	for i=0,rngcols-1,1 do
		for j=0,17,1 do
			clr = 0xFF606060
			if j%rngmod == 0 then
				clr = 0xFFB0B0B0
			end
			rngtop = gettop(testrng)
			if rngmode == 1 then
				if rngbattlemode == 1 then
					if rngtop%16 == 0 then
						if rngmod == 3 then
							test2rng = rngAdvanceMulti(testrng, 10)
						else
							test2rng = rngAdvanceMulti(testrng, 7)
						end
						if gettop(test2rng)%16 == 0 then
							clr = 0xFF0000FF
						else
							clr = 0xFFFF0000 + (0x1000 * (gettop(test2rng)%16))
						end
					end
				elseif rngbattlemode == 2 then
					if rngtop%16 == 0 then
						clr = 0xFF0000FF
					else
						clr = 0xFFFF0000 + (0x1000 * (rngtop%16))
					end
				elseif rngbattlemode == 3 then
					if rngtop%100 >= rngrate[3] then
						clr = 0xFF0000FF
					end
				elseif rngbattlemode==4 then
					if rngtop%100 < rngrate[4] then
						clr = 0xFFFF0000
					end
				elseif rngbattlemode==5 then
					if rngtop < 0x3333 then
						clr = 0xFF00FF00
					end
				elseif rngbattlemode==6 then
					if rngtop%4==0 then
						clr = 0xFFFFFF00
					end
				end
			elseif rngmode == 2 then
				accum = 0
				for k=1,numslots[encountermode],1 do
					accum = accum + slots[encountermode][k]
					if rngtop%100 < accum then
						if selectedslot[k] then
							clr=slotcolors[k]
						end
						break
					end
				end
			elseif rngmode == 3 then
				testaux = testrng
				count = 0
				for k = 1,4,1 do
					if gettop(testaux) <= catchdata["rng"] then
						count = count + 1
					end
					testaux = rngDecrease(testaux)
				end
				if count == 4 then
					clr = 0xFFFF0000
				end
			elseif rngmode == 4 then
				if rngothermode==1 then -- Pokerus
					if rngtop == 0x4000 or rngtop == 0x8000 or rngtop == 0xC000 then
						clr = 0xFFFF0000
					end
				elseif rngothermode==2 then -- Test
					if (rngtop%2880) < 160 then
							testaux = rngAdvance(testrng)
							slotcheck = gettop(testaux)%100
							if slotcheck > 69 and slotcheck < 80 then
							--if slotcheck > 59 and slotcheck < 70 then
								clr = 0xFFFF0000
							else
								clr = 0x88888800
							end
					end
				end
			end
			drawRNGsquare(j,i,clr)
			testrng = rngAdvance(testrng)
		end
	end
end

function calculateCatchData()
	if rngcatchmode == 1 then
		pkmdaux = getPokemonData(2, 1)
		if validPokemonData(pkmdaux) then
			catchdata['pokemon'] = pkmdaux['pokemonID']
			catchdata['curHP'] = pkmdaux['curHP']
			catchdata['maxHP'] = pkmdaux['maxHP']
			catchdata['level'] = pkmdaux['level']
			catchdata['status'] = pkmdaux['status']
		end
	end
	m = catchdata['maxHP']
	h = catchdata['curHP']
	c = pokemoncatchrate[catchdata['pokemon'] + 1]
	
	s = 1
	if catchdata['status'] == 1 or catchdata['status'] == 4 then
		s = 2
	elseif catchdata['status'] > 1 then
		s = 1.5
	end
		
	b = 1
	if catchdata['ball'] == 2 then
	elseif catchdata['ball'] == 2 then
		b = 1.5
	elseif catchdata['ball'] == 3 then
		b = 1.5
	elseif catchdata['ball'] == 5 then
		b = 1.5
	end
	
	x = math.floor((3 * m - 2 * h) * math.floor(c * b))
	x = math.floor(x / (3*m))
	x = math.floor(x * s)
	
	y = 65536
	if (x < 255 and catchdata['ball'] > 1) then		
		y = math.floor(math.sqrt(16711680/x))
		y = math.floor(math.sqrt(y))
		y = math.floor(1048560 / y)
	end
	catchdata['rng'] = y
	catchdata['rate'] = (y/65536) * (y/65536) * (y/65536) * (y/65536)
	
end

function drawGeneralInfo()
	currng = mdword(rng[game])
	text(SCREEN_X + 5, UP_GAP + SCREEN_Y + DOWN_GAP - 40, "RNG seed:")
	text(SCREEN_X + 60, UP_GAP + SCREEN_Y + DOWN_GAP - 40, rngseed .. " (" .. tohex(rngseed) .. ")", "yellow")
	text(SCREEN_X + 5, UP_GAP + SCREEN_Y + DOWN_GAP - 30, "RNG frame:")
	text(SCREEN_X + 60, UP_GAP + SCREEN_Y + DOWN_GAP - 30, getRNGDistance(rngseed,currng), "yellow")
	
	gui.drawRectangle(CHANGESEED_POS[1], CHANGESEED_POS[2], CHANGESEED_SIZE[1], CHANGESEED_SIZE[2], 0xFF00AAFF, 0xFF000055)
	text(CHANGESEED_POS[1] + 3, CHANGESEED_POS[2] + 1, "Change seed", 0xFF00AAFF)
end

--------------------------
------- MAIN LOOP --------
--------------------------

getGame()
client.SetGameExtraPadding(0,UP_GAP,RIGHT_GAP,DOWN_GAP)
gui.defaultTextBackground(0x00000000)

while true do
	collectgarbage()
	inputCheck()
	drawLayout()
	if showrightmenu == 1 then
		pkmdaux = getPokemonData(playerindex,pokemonindex)
		if validPokemonData(pkmdaux) then
			pokemondata = pkmdaux
		end
		drawPokemonView()
		drawTriangle(RIGHT_GAP + SCREEN_X - UP_GAP,0,"left",0xFF00FF00)
	else
		drawTriangle(SCREEN_X - UP_GAP,0,"right",0xFF88FF88)
	end
	drawBottomMenu()
	if bottommenuindex == 1 then
		trainerdata = getTrainerData(1)
		enemydata = getTrainerData(2)
		drawTrainerView()
	elseif bottommenuindex == 2 then
		if rngmode == 2 then
			mymap = mword(mapbank[game])
			if (mymap ~= currentmap) then
				currentmap = mymap
				encounterdata = getEncounterData()
			end
		elseif rngmode == 3 then
			if rngothermode == 1 then
				calculateCatchData()
			end
		end
		drawRNGView()
	end
	if showrightmenu == 1 then
		drawGeneralInfo()
	end
	emu.frameadvance()
end