-- Lua Script made by MKDasher
-- Based on FractalFusion's VBA-rr lua scripts, with some extra features.
-- NOTE: On Bizhawk, go to Config / Display... Then uncheck Stretch pixels by integers only.

-- TODO
-- Pickup
-- Roaming

DATA_FOLDER = "pkmgen3"
dofile (DATA_FOLDER .. "/Data.lua")
dofile (DATA_FOLDER .. "/Memory.lua")
dofile (DATA_FOLDER .. "/GameSettings.lua")

-- Initialize Game Settings before loading other files.
GameSettings.initialize()

dofile (DATA_FOLDER .. "/GraphicConstants.lua")
dofile (DATA_FOLDER .. "/LayoutSettings.lua")
dofile (DATA_FOLDER .. "/Forms.lua")
dofile (DATA_FOLDER .. "/Map.lua")
dofile (DATA_FOLDER .. "/Utils.lua")
dofile (DATA_FOLDER .. "/Buttons.lua")
dofile (DATA_FOLDER .. "/Input.lua")
dofile (DATA_FOLDER .. "/RNG.lua")
dofile (DATA_FOLDER .. "/Drawing.lua")
dofile (DATA_FOLDER .. "/Program.lua")

-- Main loop
if GameSettings.game == 0 then
	client.SetGameExtraPadding(0, 0, 0, 0)
	while true do
		gui.text(0, 0, "Lua error: " .. GameSettings.gamename)
		emu.frameadvance()
	end
else
	client.SetGameExtraPadding(0, GraphicConstants.UP_GAP, GraphicConstants.RIGHT_GAP, GraphicConstants.DOWN_GAP)
	gui.defaultTextBackground(0)
	while true do
		collectgarbage()
		Program.main()
		emu.frameadvance()
	end
end