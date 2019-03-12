LayoutSettings = {
	showRightPanel = true,
	pokemonIndex = {
		player = 1,
		slot = 1
	},
	selectedslot = {
		true,false,false,false,false,
		false,false,false,false,false,
		false,false,false,false,false,
		false,false
	}
}

LayoutSettings.rng = {
	MINROWS = 2,
	MAXROWS = 20,
	rows = 12,
	columns = 18,
	modulo = 2,
	squaresize = 5
}

LayoutSettings.menus = {
	main = {
		items = {'TRAINER', 'RNG', 'MAP', 'MISC'},
		selecteditem = 1,
		
		TRAINER = 1,
		RNG = 2,
		MAP = 3,
		MISC = 4
	},
	rng = {
		items = {'BATTLE', 'ENCOU.', 'PICKUP', 'CATCH', 'OTHER'},
		selecteditem = 1,
		
		BATTLE = 1,
		ENCOUNTER = 2,
		PICKUP = 3,
		CATCH = 4,
		OTHER = 5
	},
	encounter = {
		items = {'GRASS', 'WATER', 'R.SMASH'},
		selecteditem = 1,
		
		GRASS = 1,
		WATER = 2,
		ROCKSMASH = 3
	},
	rngbattle = {
		items = {'Crit. Hit / dmg. range', 'Damage range', 'Miss', 'Hit', 'Quick claw', 'Fully Paralyzed'},
		selecteditem = 1,
		accuracy = {-1, -1, 90, 50, -1, -1},
		accuracy_step = 5,
		
		CRITICALHIT = 1,
		DAMAGERANGE = 2,
		MISS = 3,
		HIT = 4,
		QUICKCLAW = 5,
		PARALYZED = 6
	},
	rngother = {
		items = {'Pokerus'},
		selecteditem = 1,
		
		POKERUS = 1
	},
	catch = {
		items = {'AUTO', 'MANUAL'},
		selecteditem = 1,
		
		AUTO = 1,
		MANUAL = 2
	},
	pickuplevel = {
		items = {'1-9', '11-20', '21-30', '31-40', '41-50', '51-60', '61-70', '71-80', '81-90', '91-100'},
		selecteditem = 1
	}
}