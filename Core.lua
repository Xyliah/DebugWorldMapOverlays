local debug = false

local old_print = print
local function print(...)
	if debug then 
		old_print(...)
	end
end


local frame = CreateFrame("Frame", nil, WorldMapFrame)
frame:RegisterEvent("WORLD_MAP_UPDATE")

local overlayCache = {}
local usedOverlays = {}
local counter = 0
local lastMap = ""

frame:SetScript("OnEvent", function(self, event, ...)
	--local continent = GetCurrentMapContinent()
	--local zoneID = GetCurrentMapZone()
	local areaID = GetCurrentMapAreaID()
	local mapName = GetMapNameByID(areaID)
	--local zoneName = zoneID > 0 and (select(zoneID*2, GetMapZones(continent))) or "no zone"

	local numMapOverlays = GetNumMapOverlays()

	print("-----------------------------------------")
	print(mapName and mapName or "no map")
	print("#usedOverlays: " .. #usedOverlays)

	-- clear used overlays
	local c = 0

	for i=1,#usedOverlays do
		--print("overlay into Cache"..usedOverlays[i])
		overlayCache[#overlayCache+1] = usedOverlays[i]
		--table.remove(usedOverlays, i)
		usedOverlays[i]:Hide()
		--print("removed used overlay #"..i)
		c = c + 1
	end
	wipe(usedOverlays)
	print("cleared " .. c .. " usedOverlays")
	print("overlayCache: " .. #overlayCache)

	print(string.format("Need TOTAL overlays: %s || need %s NEW overlays: ", numMapOverlays, numMapOverlays-#overlayCache))
	for i=1,numMapOverlays do
		local overlay = next(overlayCache)
		local fontstring
		--print("Need ".. i .. " overlays")
		if overlay then 
			print("overlay taken from cache: "..overlayCache[overlay]:GetName())
			usedOverlays[#usedOverlays+1] = overlayCache[overlay]
			fontstring = overlayCache[overlay]

			table.remove(overlayCache, overlay)
		else
			fontstring = frame:CreateFontString("DebugNumMapOverlay"..counter+1, "Overlay", "GameFontHighlight")
			fontstring:SetFont("Fonts\\FRIZQT__.TTF", 20)
			fontstring:SetParent(WorldMapButton)
			counter = counter + 1
			print("created new overlay "..fontstring:GetName())
			usedOverlays[#usedOverlays+1] = fontstring

		end

		local textureName, textureWidth, textureHeight, offsetX, offsetY, mapPointX, mapPointY = GetMapOverlayInfo(i)

		--print(textureName, textureWidth, textureHeight, offsetX, offsetY, mapPointX, mapPointY)

		local textureName, textureWidth, textureHeight, offsetX, offsetY = GetMapOverlayInfo(i)
		local height, width = WorldMapButton:GetHeight(), WorldMapButton:GetWidth()

		fontstring:SetPoint("CENTER", WorldMapButton, "TOPLEFT", offsetX + textureWidth/2, -textureHeight/2 - offsetY)
		fontstring:SetFormattedText("*%s*", i)
		fontstring:Show()

		local subZone = textureName:gsub("Interface\\WorldMap\\"..mapName.."\\", "")
		--old_print(i .. mmsubZone)
	end

	if mapName ~= lastMap then
		for i=1,100 do 
			if _G["WorldMapOverlay"..i] then
				local red, green, blue = random(0, 255), random(0, 255), random(0, 255)
				_G["WorldMapOverlay"..i]:SetVertexColor(red/255, green/255, blue/255, 0.6)
				--old_print(_G["WorldMapOverlay"..i]:GetTexture()..i)
			end
		end

		lastMap = mapName
	end

end)
