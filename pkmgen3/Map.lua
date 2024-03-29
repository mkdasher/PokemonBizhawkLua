Map = {
	grid = {},
	file = ''
}

if GameSettings.version == GameSettings.VERSIONS.FRLG then
	Map.file = 'kanto'
	Map.grid = {
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x7C, 0x7D, 0x7D, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x7C, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0x61, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x63, 0x68, 0x68, 0x68, 0x68, 0x68, 0x5B, 0x6D, 0x6D, 0x6D, 0x64, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x9F, 0x9F, 0x9F},
		{0xC5, 0xC5, 0xC5, 0x7B, 0xC5, 0x5A, 0x67, 0x67, 0x67, 0x67, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x69, 0xC5, 0xC5, 0xC5, 0x6E, 0xC5, 0xC5, 0xC5, 0x92, 0xC5, 0xA0, 0xA0, 0xA0, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0x7B, 0xC5, 0x66, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x69, 0xC5, 0xC5, 0xC5, 0x6E, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x93, 0xA1, 0xC5},
		{0xC5, 0xC5, 0xC5, 0x7B, 0xC5, 0x66, 0xC5, 0xC5, 0x74, 0x74, 0x74, 0x74, 0x5E, 0x6B, 0x6B, 0x62, 0x6C, 0x6C, 0x6C, 0x5C, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA1, 0xA2},
		{0xC5, 0xC5, 0xC5, 0x7B, 0xC5, 0x66, 0xC5, 0xC5, 0x75, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x6A, 0xC5, 0xC5, 0xC5, 0x70, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA2},
		{0xC5, 0xC5, 0xC5, 0x7A, 0x7A, 0x59, 0xC5, 0xC5, 0x75, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x6A, 0xC5, 0xC5, 0xC5, 0x70, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA2},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x65, 0xC5, 0xC5, 0x75, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x5D, 0x6F, 0x6F, 0x6F, 0x70, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x65, 0xC5, 0xC5, 0x75, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x70, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x58, 0xC5, 0xC5, 0x75, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x72, 0x71, 0x71, 0x70, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA3, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0x96, 0xC5, 0xC5, 0x79, 0xC5, 0xC5, 0x76, 0x76, 0x76, 0x76, 0x76, 0x5F, 0x73, 0x73, 0x72, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA3, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0x96, 0xC5, 0xC5, 0x79, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x77, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA3, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0x96, 0xC5, 0xC5, 0x60, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78, 0x78, 0x77, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA7, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA4, 0xA4, 0xA4, 0xA5},
		{0xC5, 0xC5, 0x96, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA7, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA5},
		{0xC5, 0xC5, 0x96, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x94, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x95, 0xA5},
		{0xC5, 0x8F, 0x96, 0xC5, 0xC5, 0xC5, 0x98, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA8, 0xA9, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA5},
		{0xC5, 0x97, 0xC5, 0xC5, 0xC5, 0xC5, 0x98, 0xC5, 0xC5, 0xC5, 0x99, 0x99, 0x99, 0x99, 0x91, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA9, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA6, 0xA6, 0xA5},
		{0xC5, 0x97, 0xC5, 0xC5, 0xC5, 0xC5, 0x90, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x9A, 0x9A, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA9, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xA6, 0xA6, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5}
	}
else
	Map.file = 'hoenn'
	Map.grid = {
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0x1D, 0x1D, 0x04, 0x1C, 0x1C, 0x1C, 0x1C, 0x1A, 0xC5, 0xC5, 0x22, 0x0B, 0x23, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0x1D, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x1A, 0xC5, 0xC5, 0x22, 0xC5, 0x23, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x1E, 0x1D, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x1A, 0xC5, 0xC5, 0x22, 0xC5, 0x23, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x1E, 0xC5, 0xC5, 0xC5, 0xC5, 0x03, 0x1B, 0x1B, 0x1A, 0xC5, 0xC5, 0x22, 0xC5, 0x23, 0x24, 0x24, 0x24, 0x24, 0x0C, 0x0C, 0x27, 0x27, 0x27, 0x27, 0x28, 0x28, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x1E, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x1A, 0xC5, 0xC5, 0x22, 0xC5, 0xC5, 0xC5, 0xC5, 0x25, 0xC5, 0xC5, 0xC5, 0x27, 0x27, 0x27, 0x27, 0x28, 0x28, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x0A, 0x1F, 0x1F, 0x1F, 0x1F, 0xC5, 0xC5, 0xC5, 0x1A, 0xC5, 0xC5, 0x22, 0xC5, 0xC5, 0xC5, 0xC5, 0x25, 0xC5, 0xC5, 0xC5, 0x27, 0x27, 0x27, 0x27, 0x0D, 0x0D, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x0A, 0xC5, 0xC5, 0xC5, 0x05, 0x20, 0x20, 0x20, 0x09, 0x09, 0x21, 0x21, 0x26, 0x26, 0x26, 0x26, 0x26, 0xC5, 0xC5, 0xC5, 0x29, 0x29, 0x29, 0x2A, 0x2A, 0x2A, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x13, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x19, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x29, 0x0E, 0x29, 0x2A, 0x2A, 0x2A, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x13, 0xC5, 0xC5, 0xC5, 0x12, 0x12, 0x12, 0x12, 0x19, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x29, 0x29, 0x29, 0x2A, 0x2A, 0x2A, 0xC5, 0x0F, 0xC5},
		{0xC5, 0x13, 0x07, 0x11, 0x11, 0x01, 0xC5, 0xC5, 0xC5, 0x19, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x2B, 0x2B, 0x2B, 0x2B, 0x0F, 0xC5},
		{0xC5, 0x14, 0xC5, 0xC5, 0xC5, 0x10, 0xC5, 0xC5, 0xC5, 0x08, 0x31, 0x31, 0x31, 0x30, 0x30, 0x30, 0x2F, 0x2F, 0x06, 0x2E, 0x2E, 0x2E, 0x2D, 0x2D, 0x2D, 0x2C, 0x2C, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x14, 0xC5, 0xC5, 0xC5, 0x00, 0xC5, 0xC5, 0xC5, 0x08, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x14, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x18, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x3A, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0x15, 0x15, 0x15, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0x18, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0x02, 0x16, 0x16, 0x16, 0x17, 0x17, 0x18, 0xC5, 0xC5, 0xC5, 0x49, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5},
		{0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5, 0xC5}
	}
end

function Map.findCoords(mapid)
	local x = 0
	local y = 0
	local count = 0
	for i = 1, #Map.grid, 1 do
		for j = 1, #Map.grid[i], 1 do
			if mapid == Map.grid[i][j] then
				count = count + 1
				x = x + j
				y = y + i
			end
		end
	end
	if count == 0 then
		return {-10, -10}
	else
		return {x/count, y/count}
	end
end