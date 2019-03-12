Forms = {
	formhandle,
	texthandle,
	dropdownhandle
}

function Forms.onChangeSeedClick()
	GameSettings.rngseed = tonumber(forms.gettext(Forms.texthandle),16)
	forms.destroy(Forms.formhandle)
end

function Forms.onChangeCatchPokemonClick()
	Program.catchdata.pokemon = Utils.getTableValueIndex(forms.gettext(Forms.dropdownhandle), PokemonData.name) - 1
	forms.destroy(Forms.formhandle)
end

function Forms.onChangeCatchCurHPClick()
	Program.catchdata.curHP = tonumber(forms.gettext(Forms.texthandle))
	if Program.catchdata.curHP < 1 then
		Program.catchdata.curHP = 1
	elseif Program.catchdata.curHP > 999 then
		Program.catchdata.curHP = 999
	end
	forms.destroy(Forms.formhandle)
end

function Forms.onChangeCatchMaxHPClick()
	Program.catchdata.maxHP = tonumber(forms.gettext(Forms.texthandle))
	if Program.catchdata.maxHP < 1 then
		Program.catchdata.maxHP = 1
	elseif Program.catchdata.maxHP > 999 then
		Program.catchdata.maxHP = 999
	end
	forms.destroy(Forms.formhandle)
end

function Forms.onChangeCatchStatusClick()
	Program.catchdata.status = Utils.getTableValueIndex(forms.gettext(Forms.dropdownhandle), PokemonData.status) - 1
	forms.destroy(Forms.formhandle)
end

function Forms.onChangeCatchBallClick()
	local ballaux = forms.gettext(Forms.dropdownhandle)
	if ballaux == 'Master Ball' then
		Program.catchdata.ball = 1
	elseif ballaux == 'Ultra Ball' then
		Program.catchdata.ball = 2
	elseif ballaux == 'Great Ball' then
		Program.catchdata.ball = 3
	elseif ballaux == 'Safari Ball' then
		Program.catchdata.ball = 5
	else
		Program.catchdata.ball = 4
	end
	forms.destroy(Forms.formhandle)
end