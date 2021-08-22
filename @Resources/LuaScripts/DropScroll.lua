function Initialize()
	currentPos = 0
end

-- Move the scrollbar meter using relative positioning.
function UpdateCurrentPos(amount)
	currentPos = currentPos + amount

	-- prevent the meter from moving when at the top of the list
	if currentPos < 0 then
		currentPos = 0
	end

	local count = SKIN:GetVariable('MaxItem')
	local topHeight = SKIN:GetVariable('TopHeight')
	local maxItems = SKIN:GetMeasure('AnalyzeTotal'):GetValue()

	-- prevent the meter from moving when at the bottom of the list
	if currentPos ~= 0 and currentPos > (maxItems - count) then
		currentPos = maxItems - count
	end

	local size = SKIN:GetMeasure('Size'):GetValue()
	SKIN:Bang('!SetOption', 'CurrentPos', 'Y', currentPos * (size / maxItems)+(2) ..'R')
end