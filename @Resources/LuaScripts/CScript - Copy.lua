-- LuaCalendar v6.0 by Smurfier (smurfier@outlook.com)
-- This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License.

function Initialize()
	Settings.HideLastWeek = Get.NumberVariable('HideLastWeek') > 0
	Settings.LeadingZeroes = Get.NumberVariable('LeadingZeroes') > 0
	Settings.StartOnMonday = Get.NumberVariable('StartOnMonday') > 0
	Settings.LabelFormat = Get.Variable('LabelText', '{$MName} {$Year}')
	Settings.NextFormat = Get.Variable('NextFormat', '{$day}: {$desc}')
	Settings.MonthNames = Delim(Get.Variable('MonthLabels', ''))
	Settings.MoonPhases = Get.NumberVariable('ShowMoonPhases') > 0
	-- Need to set Error.Source before calling Parse.Color
	Error.Open('Settings')
	Settings.MoonColor = Parse.Color(Get.Variable('MoonColor', ''), 'MoonColor', true)
	Error.Close()
	Settings.ShowEvents = Get.NumberVariable('ShowEvents') > 0
	Settings.DisableScroll = Get.NumberVariable('DisableScroll') > 0
	-- Weekday labels text
	SetLabels(Delim(Get.Variable('DayLabels', 'S|M|T|W|T|F|S')))
	-- Events File
	LoadEvents(ExpandFolder(Delim(Get.Variable('EventFile'))))
end -- Initialize

function Update()
	CombineScroll(0)
	
	local Current = Time.curr()
	
	-- If in the current month or if browsing and Month changes to that month, set to Real Time
	if (
		Time.stats.inmonth and Time.show.month ~= Current.month or
		Time.show.month == Current.month and Time.show.year == Current.year and not Time.stats.inmonth
	) then
		Move()
	end
	
	-- Recalculate and Redraw if Month and/or Year changes
	if (
		Time.show.month ~= Time.old.month or
		Time.show.year ~= Time.old.year
	) then
		Time.old = Time.show
		Time.stats() -- Set all Time.stats values for the current month.
		ParseEvents()
		Draw()
	
	-- Redraw if Today changes
	elseif (
		Current.day ~= Time.old.day and
		Time.stats.inmonth
	) then
		Time.old.day = Current.day
		Draw()
	end
	
	return Error.Log()
end -- Update

function CombineScroll(input)
	if Settings.DisableScroll then
		-- Do Nothing
	elseif input and not Scroll then
		Scroll = input
	elseif Scroll ~= 0 and input == 0 then
		Move(Scroll / math.abs(Scroll))
		Scroll = 0
	else
		Scroll = Scroll + input
	end
end -- CombineScroll

Settings = setmetatable(
	{}, -- Start with an empty settings table. Force the use of __newindex in the metatable.
	{
		-- Use __index metatable to set up default settings.
		__index = {
			EventColor = 'FontColor', -- String
			EventText = 'ToolTipText', -- String
			Range = 'month', -- String
			HideLastWeek = false, -- Boolean
			LeadingZeroes = false, -- Boolean
			StartOnMonday = false, -- Boolean
			LabelFormat = '{$MName}, {$Year}', -- String
			NextFormat = '{$day}: {$desc}', -- String
			MonthNames = {}, -- Table (of strings)
			MoonPhases = false, -- Boolean
			MoonColor = '', -- String
			ShowEvents = true, -- Boolean
			DisableScroll = false, -- Boolean
		},
		-- Use __newindex to validate setting values.
		__newindex = function(t, key, value)
			Error.Open(key)
			
			local tbl = getmetatable(Settings).__index
			if tbl[key] == nil then
				Error.Create('Setting does not exist.')
			elseif type(value) == type(tbl[key]) then
				rawset(t, key, value)
			else
				Error.Create('Invalid Setting type. Expected %s, received %s instead.', key, type(tbl[key]), type(value))
			end
			
			Error.Close()
		end,
	}
) -- Settings

Meters = { -- Set meter names/formats here.
	Labels = { -- Week Day Labels
		Name = function(input)
			-- Use %d to denote the number (0-6) of the meter.
			return string.format('l%d', input)
		end,
		Styles = {
			Normal = 'LblTxtSty',
			First = 'LblTxtStart',
			Current = 'LblCurrSty',
		},
	},
	Days = { -- Month Days
		Name = function(input)
			-- Use %d to denote the number (1-42) of the meter.
			return string.format('mDay%d', input)
		end,
		Styles = {
			Normal = 'TextStyle',
			FirstDay = 'FirstDay',
			NewWeek = 'NewWk',
			Current = 'CurrentDay',
			LastWeek = 'LastWeek',
			PreviousMonth = 'PreviousMonth',
			NextMonth = 'NextMonth',
			Weekend = 'WeekendStyle',
			Event = 'HolidayStyle',
		},
	},
} -- Meters

Time = { -- Used to store and call date functions and statistics
	curr = setmetatable(
		{},
		{
			__index = function(_, index)
				return os.date('*t')[index]
			end,
			__call = function(_)
				return os.date('*t')
			end,
		}
	),
	old = {
		day = 0,
		month = 0,
		year = 0,
	},
	show = os.date('*t'), -- Needs to be initialized with current values.
	stats = setmetatable(
		{
			inmonth = true,
		},
		{
			__call = function(tbl, index)
				local day = 86400
				
				local tstart = os.time{
					day = 1,
					month = Time.show.month,
					year = Time.show.year,
					isdst = false,
				}
				
				-- Date table for 31 days after the current month
				local NextMonth = os.date('*t', tstart + 31 * day)
				
				local nstart = os.time{
					day = 1,
					month = NextMonth.month,
					year = NextMonth.year,
					isdst = false,
				}
				
				local values = {
					nmonth = nstart, -- Timestamp for the first day of the following month.
					cmonth = tstart, -- Timestamp for the first day of the current month.
					clength = (nstart - tstart) / day, -- Number of days in the current month.
					plength = tonumber(os.date('%d', tstart - day)), -- Number of days in the previous month.
					startday = RotateDay(tonumber(os.date('%w', tstart))), -- Day code for the first day of the current month.
					vars = {
						last = {},
						first = {},
						second = {},
						third = {},
						fourth = {},
					}, -- Table of variables used in event files
				}
				
				local dayname = function(input) return string.lower(os.date('%a', input)) end
				local dayvalue = function(input) return tonumber(os.date('%d', input)) end
				
				-- Create table for the last week of the month
				for stamp = nstart - day * 7, nstart - day , day do
					values.vars.last[dayname(stamp)] = dayvalue(stamp)
				end
				
				-- Create tables for first, second, third, fourth weeks
				for thisweek, offset in pairs{first = 0, second = day * 7, third = day * 14, fourth = day * 21} do
					for stamp = tstart + offset , tstart + offset + day * 6, day do
						values.vars[thisweek][dayname(stamp)] = dayvalue(stamp)
					end
				end
				
				-- Set everything to main table
				for Name, Value in pairs(values) do
					rawset(tbl, Name, Value)
				end
			end,
		}
	),
} -- Time

Range = setmetatable( -- Makes allowance for either Month or Week ranges
	{
		month = {
			formula = function(input)
				return input - Time.stats.startday
			end,
			adjustment = function(input)
				return input
			end,
			days = 42,
			week = function()
				return math.ceil((Time.curr.day + Time.stats.startday) / 7)
			end,
		},
		week = {
			formula = function(input)
				local Current = Time.curr()
				return Current.day + ((input - 1) - RotateDay(Current.wday - 1))
			end,
			adjustment = function(input)
				local num = input % 7
				return num == 0 and 7 or num
			end,
			days = 7,
			week = function()
				return 1
			end,
			nomove = true,
		},
	},
	{
		__index = function(tbl, index)
			Error.Open('Range')
			Error.Create('Invalid range type: %s', index)
			Error.Close()
			return tbl.month
		end,
	}
) -- Range

function Delim(input, Separator) -- Separates an input string by a delimiter
	Error.Open('Delim')
	
	local tbl = {}
	if type(input) == 'string' then
		if not MultiType(Separator, 'nil|string') then
			Error.Create('Input #2 must be a string. Received %s instead. Using default value.', type(Separator))
			Separator = '|'
		end
		
		local MatchPattern = string.format('[^%s]+', Separator or '|')
		
		for word in string.gmatch(input, MatchPattern) do
			table.insert(tbl, word:match('^%s*(.-)%s*$'))
		end
	else
		Error.Create('Input must be a string. Received %s instead', type(input))
	end
	
	Error.Close()
	return tbl
end -- Delim

function ExpandFolder(input) -- Makes allowance for when the first value in a table represents the folder containing all objects.
	Error.Open('ExpandFolder')
	
	if type(input) ~= 'table' then
		Error.Create('Input must be a table. Received %s instead.', type(input))
		input = {}
	elseif #input > 1 then
		local FolderPath = table.remove(input, 1):match('(.-)[/\\]-$') .. '\\'
		for Key, FileName in ipairs(input) do
			input[Key] = SKIN:MakePathAbsolute(FolderPath .. FileName)
		end
	end
	
	Error.Close()
	return input
end -- ExpandFolder

function SetLabels(tbl) -- Sets weekday label text
	Error.Open('SetLabels')
	local default = {'S', 'M', 'T', 'W', 'T', 'F', 'S'}
	
	if type(tbl) ~= 'table' then
		Error.Create('Input must be a table. Received %s instead. Using default table.', type(tbl))
		tbl = default
	elseif #tbl ~= 7 then
		Error.Create('Input must be a table with seven indicies. Using default table instead.')
		tbl = default
	end
	
	if Settings.StartOnMonday then
		table.insert(tbl, table.remove(tbl, 1))
	end
	
	for Label, Text in ipairs(tbl) do
		SKIN:Bang('!SetOption', Meters.Labels.Name(Label - 1), 'Text', Text)
	end
	
	Error.Close()
end -- SetLabels

function LoadEvents(FileTable)
	Error.Open('LoadEvents')
	
	if not Settings.ShowEvents then
		FileTable = {}
	elseif type(FileTable) ~= 'table' then
		Error.Create('Input must be a table. Received %s instead.', type(FileTable))
		FileTable = {}
	end
	
	EventsData = {}
	
	local KeyNames = { -- Define valid key names
		'month',
		'day',
		'year',
		'description',
		'title',
		'color',
		'repeat',
		'multiplier',
		'anniversary',
		'inactive',
		'case',
		'skip',
		'timestamp',
		'finish',
	}
	
	local Escape = { -- Escape characters as needed by the XML structure
		quot = '"',
		amp = '&',
		lt = '<',
		gt = '>',
		apos = "'",
	}
	
	local ParseEscape = function(line)
		local temp = function(var)
			local dec = var:match('#(%d+)')
			local hex = var:match('#[xX](%x+)')
			
			if dec then
				return string.char(tonumber(dec))
			elseif hex then
				return string.char(tonumber(hex, 16))
			else
				return Escape[var:lower()]
			end
		end
		
		return line:gsub('&([^;]+);', temp):gsub('\r?\n', ' ')
	end -- ParseEscape
	
	local ParseKeys = function(line, default)
		local tbl = default or {}
		
		for key, value in line:gmatch('(%a+)="%s*(.-)%s*"') do
			tbl[key:lower()] = ParseEscape(value)
		end
		
		for key, value in line:gmatch("(%a+)='%s*(.-)%s*'") do
			tbl[key:lower()] = ParseEscape(value)
		end
		
		return tbl
	end -- ParseKeys
	
	for _, FilePath in ipairs(FileTable) do
		local FileName = FilePath:match('[^/\\]+$')
		local FileHandle = io.open(FilePath, 'r')
		
		local OpenTag, FileContent, CloseTag = '', '', ''
		if FileHandle then
			local FileText = FileHandle:read('*all')
			-- Remove commented sections
			FileText = FileText:gsub('<!%-%-.-%-%->', '')
			-- Validate XML structure, part 1
			OpenTag, FileContent, CloseTag = FileText:match('^.-<([^>]+)>(.+)<([^>]+)>[^>]*$')
			FileHandle:close()
		else
			Error.Create('File read error: %s', FileName)
		end
		
		-- Validate XML structure, part 2
		if (
			string.match(OpenTag or '', '%S*'):lower() ~= 'eventfile' or
			string.lower(CloseTag or '') ~= '/eventfile'
		) then
			Error.Create('Invalid event file: %s', FileName)
			-- Set FileContent to empty in order to skip the tag iterator
			FileContent = ''
		end
		
		local eFile, SetTags, ContentQueue = ParseKeys(OpenTag or ''), {}
		
		local AddEvent = function(options)
			local dSet, tbl = {}, {fname = FileName,}
			
			-- Collapse set matrix into a single table
			for _, column in ipairs(SetTags) do
				for key, value in pairs(column) do
					dSet[key] = value
				end
			end
			
			-- Work through all tables to add option to temporary table
			for _, v in pairs(KeyNames) do
				tbl[v] = options[v] or dSet[v] or eFile[v] or ''
			end
			
			-- Add temporary table to main Events table
			table.insert(EventsData, tbl)
		end -- AddEvent
		
		local ParseContents = function(TempKeys, TempContents)
			if TempKeys:match('/%s-$') then
				AddEvent(ParseKeys(TempKeys))
			elseif TempContents:gsub('[\t\n\r%s]', '') ~= '' then
				ContentQueue = {
					KeyLine = TempKeys,
					Contents = ParseEscape(TempContents),
				}
			else
				Error.Create('Event tag detected without contents. File: %s', FileName)
			end
		end -- ParseContents
		
		-- Tag Iterator
		for TagName, KeyLine, Contents in FileContent:gmatch('<%s-([^%s>]+)([^>]*)>([^<]*)') do
			TagName, Contents = TagName:lower(), Contents:gsub('%s+', ' ')
			
			if ContentQueue then
				local CloseTag, name = TagName:match('(/?)(.+)')
				-- Add the currently queued event
				AddEvent(ParseKeys(ContentQueue.KeyLine, {description = ContentQueue.Contents,}))
				ContentQueue = nil
				-- Check for errors
				if CloseTag == '' and name == 'event' then
					ParseContents(KeyLine, Contents)
					Error.Create('Unmatched Event tag detected. File: %s', FileName)
				elseif CloseTag == '' then
					Error.Create('Event tags may not have nested tags. File: %s', FileName)
				elseif CloseTag == '/' and name ~= 'event' then
					Error.Create('Unmatched Event tag detected. File: %s', FileName)
				end
			elseif TagName == 'variable' then
				if not KeyLine:match('/%s-$') then
					Error.Create('Open Variable tag detected. File: %s', FileName)
				end
				
				local Temp = ParseKeys(KeyLine)
				
				if not Variables then
					Variables = {
						[FileName] = {
							[Temp.name:lower()] = Temp.select,
						},
					}
				elseif not Variables[FileName] then
					Variables[FileName] = {
						[Temp.name:lower()] = Temp.select,
					}
				else
					Variables[FileName][Temp.name:lower()] = Temp.select
				end
			elseif TagName == 'set' then				
				table.insert(SetTags, ParseKeys(KeyLine))
			elseif TagName == '/set' then
				if #SetTags > 0 then
					table.remove(SetTags)
				else
					Error.Create('Unmatched /Set tag detected. File: %s', FileName)
				end
			elseif TagName == 'event' then
				ParseContents(KeyLine, Contents)
			else
				Error.Create('Invalid Tag <%s> in %s', TagName, FileName)
			end
		end
		
		if ContentQueue or #SetTags > 0 then
			Error.Create('Unmatched Event or Set tag detected. File: %s', FileName)
		end
	end
	
	Error.Close()
end -- LoadEvents

Case = {
	lower = function(line)
			return line:lower()
		end;
	upper = function(line)
			return line:upper()
		end;
	title = function(line)
			local temp = function(first, rest)
				return first:upper() .. rest:lower()
			end
			return line:gsub('(%S)(%S*)', temp)
		end;
	sentence = function(line)
			local temp = function(sentence)
				local space, first, rest = sentence:match('(%s*)(.)(.*)')	
				return space .. first:upper() .. rest:lower():gsub("%si([%s'])", ' I%1')
			end
			return line:gsub('[^.!?]+', temp)
		end;
	none = function(line)
			return line
		end;
}

function ParseEvents() -- Parse Events table.
	Error.Open('ParseEvents')
	
	Events = {}
	
	-- Helper Functions
	local tstamp = function(d, m, y)
		return os.time{
			day = d,
			month = m or Time.show.month,
			year = y or Time.show.year,
			isdst = false,
		}
	end -- tstamp
	
	-- Requires a matrix for use.
	-- {{test, error format, arguments,},}
	local TestRequirements = function(tbl)
		local State = true
		for k, v in ipairs(tbl) do
			local test = table.remove(v, 1)
			if not test then
				Error.Create(unpack(v))
			end
			State = State and test
		end
		return State
	end -- TestRequirements
	
	local DefineEvent = function(EventDay, EventDescription, EventColor, MoonTest)
		if not Events[EventDay] then
			Events[EventDay] = {
				text = {EventDescription},
				color = {EventColor},
			}
		else
			table.insert(Events[EventDay].text, EventDescription)
			
			-- Only add the color for the moon phase if no event color is present
			local test = false
			for value in pairs(MoonTest and Events[EventDay].color or {}) do
				if value ~= '' and value ~= Settings.MoonColor then
					test = true
					break
				end
			end
			
			table.insert(Events[EventDay].color, test and '' or EventColor)
		end
	end -- DefineEvent
	
	local iterator = function(input)
		local i = 0
		return function()
			i = i + 1
			if i > #input then
				-- Force the function to terminate
				return nil
			end
			
			-- Need to copy the table items individually else we just get the address to the original table
			-- which would corrupt the data in the original table.
			local temp = {}
			for k, v in pairs(input[i]) do
				temp[k] = v
			end
			
			temp.finish = Parse.Date(input[i].finish, Time.stats.nmonth, input[i].fname)
			temp.inactive = Parse.Boolean(input[i].inactive, false, input[i].fname)
			
			if temp.finish < Time.stats.cmonth or temp.inactive then
				-- Force the function to terminate
				return nil
			end
			
			temp.multip = Parse.Number(input[i].multiplier, 1, input[i].fname, 0)
			temp.erepeat = Parse.List(input[i]['repeat'], 'none', input[i].fname, 'none|week|year|month|custom')
			
			local EventStamp = Parse.Number(input[i].timestamp, false, input[i].fname)
			if EventStamp then				
				local dates = os.date('*t', EventStamp)
				
				temp.month = dates.month
				temp.day = dates.day
				temp.year = dates.year
			else			
				local day = Parse.Number(input[i].day, false, input[i].fname)
				if not day then
					Error.Create('Invalid Day %s in %s', input[i].day, input[i].description)
				end
				
				temp.month = Parse.Number(input[i].month, false, input[i].fname)
				temp.day = day or 0
				temp.year = Parse.Number(input[i].year, false, input[i].fname)
			end
			
			return temp
		end
	end -- iterator
	
	for event in iterator(EventsData or {}) do
		local AddEvent = function(EventDay, AnniversaryNumber)
			local CurrentStamp, temp = tstamp(EventDay, Time.show.month, Time.show.year), Delim(event.skip)
			for _, DateCode in ipairs(temp) do
				if Parse.Date(DateCode, 0, event.fname) == CurrentStamp then
					-- Force the function to terminate
					return nil
				end
			end
			
			local EventDescription = Parse.String(event.description, false, event.fname, true)
			if not EventDescription then
				Error.Create('Event detected with no Description in %s.', event.fname)
				EventDescription = ''
			end
			local UseAnniversary = Parse.Boolean(event.anniversary, false, event.fname) and AnniversaryNumber
			local EventTitle = Parse.String(event.title, false, event.fname, true)
			
			local temp = {EventDescription}
			if UseAnniversary then
				table.insert(temp, string.format('(%s)', AnniversaryNumber))
			end
			if EventTitle then
				table.insert(temp, string.format('-%s', EventTitle))
			end
			EventDescription = table.concat(temp, ' ')
			
			local CaseOption = Parse.List(event.case, 'none', event.fname, 'none|lower|upper|title|sentence')
			EventDescription = Case[CaseOption](EventDescription)
			
			local EventColor = Parse.Color(event.color, event.fname)
			
			DefineEvent(EventDay, EventDescription, EventColor)
		end -- AddEvent
		
		local frame = function(period) -- Repeats an event based on a given number of seconds
			local start = tstamp(event.day, event.month, event.year)
			
			if Time.stats.nmonth < start then
				-- Force the function to terminate
				return nil
			end
			
			local first = start
			if Time.stats.cmonth > start then
				first = Time.stats.cmonth + (period - ((Time.stats.cmonth - start) % period))
			end
			
			local stop = event.finish < Time.stats.nmonth and event.finish or Time.stats.nmonth
			
			for i = first, stop, period do
				AddEvent(tonumber(os.date('%d', i)), (i - start) / period + 1)
			end
		end -- frame
		
		-- Begin testing and adding events to table
		if event.erepeat == 'custom' then
			local Results = TestRequirements{
				{event.year, 'Year must be specified in %s when using Custom repeat.', event.description},
				{event.month, 'Month must be specified in %s when using Custom repeat.', event.description},
				{event.day, 'Day must be specified in %s when using Custom repeat.', event.description},
				{event.multip >= 86400, 'Multiplier must be greater than or equal to 86400 in %s when using Custom repeat.', event.description},
			}
			
			if Results then
				frame(event.multip)
			end
			
		elseif event.erepeat == 'week' then
			local Results = TestRequirements{
				{event.year, 'Year must be specified in %s when using Week repeat.', event.description},
				{event.month, 'Month must be specified in %s when using Week repeat.', event.description},
				{event.day, 'Day must be specified in %s when using Week repeat.', event.description},
				{event.multip >= 1, 'Multiplier must be greater than or equal to 1 in %s when using Week repeat.', event.description},
			}
			
			if Results then
				frame(event.multip * 604800)
			end
			
		elseif event.erepeat == 'year' then
			local Results = TestRequirements{
				{event.day, 'Day must be specified in %s when using Year repeat.', event.description},
				{event.month, 'Month must be specified in %s when using Year repeat.', event.description},
			}
			
			if Results and tstamp(event.day, event.month, Time.show.year) <= event.finish then
				local TestYear = 0
				if event.year and event.multip > 1 then
					TestYear = (Time.show.year - event.year) % event.multip
				end
				if event.month == Time.show.month and TestYear == 0 then
					AddEvent(event.day, event.year and Time.show.year - event.year / event.multip)
				end
			end
			
		elseif event.erepeat == 'month' then
			if not event.day then
				Error.Create('Day must be specified in %s when using Month repeat.', event.description)
			elseif not tstamp(event.day, event.month, event.year) <= event.finish then
				-- Do Nothing
			elseif not event.month and event.year then
				AddEvent(event.day)
			elseif Time.show.year >= event.year then
				local ydiff = Time.show.year - event.year - 1
				local mdiff
				if ydiff == -1 then
					mdiff = Time.show.month - event.month
				else
					mdiff = (12 - event.month) + Time.show.month + ydiff * 12
				end
				
				if (mdiff % event.multip) == 0 and Time.stats.cmonth >= tstamp(1, event.month, event.year) then
					AddEvent(event.day, mdiff / event.multip + 1)
				end
			end
			
		elseif event.erepeat == 'none' then
			local Results = TestRequirements{
				{event.year, 'Year must be specified in %s.', event.description},
				{event.month, 'Month must be specified in %s.', event.description},
				{event.day, 'Day must be specified in %s.', event.description},
			}
			
			if not Results then
				-- Do Nothing
			elseif event.year == Time.show.year and event.month == Time.show.month then
				AddEvent(event.day)
			end
		end
	end
	
	-- Find the Moon Phases for the Month
	if type(GetPhaseNumber) == 'function' and Settings.MoonPhases and Settings.ShowEvents then
		local MoonPhases, PhaseNames = {}, {[1] = 'New Moon', [5] = 'Full Moon',}
		for i = 1, Time.stats.clength do
			local PhaseNumber = GetPhaseNumber(Time.show.year, Time.show.month, i)
			if PhaseNames[PhaseNumber] and not MoonPhases[i - 1] then
				MoonPhases[i] = PhaseNames[PhaseNumber]
			end
		end
		-- Apply the Moon Phases to the Events table
		for PhaseDay, PhaseType in pairs(MoonPhases) do
			DefineEvent(PhaseDay, PhaseType, Settings.MoonColor, true)
		end
	end
	
	Error.Close()
end -- ParseEvents

function Draw() -- Sets all meter properties and calculates days
	Error.Open('Draw')
	
	-- Set Weekday Labels styles
	local CurrentWeekDay = RotateDay(Time.curr.wday - 1)
	for WeekDay = 0, 6 do
		local Styles = {Meters.Labels.Styles.Normal}
		
		if WeekDay == 0 then
			table.insert(Styles, Meters.Labels.Styles.First)
		end
		
		if CurrentWeekDay == WeekDay and Time.stats.inmonth then
			table.insert(Styles, Meters.Labels.Styles.Current)
		end
		
		SKIN:Bang('!SetOption', Meters.Labels.Name(WeekDay), 'MeterStyle', table.concat(Styles, '|'))
	end
	
	-- Calculate and set day meters
	local HideLastWeek = Settings.HideLastWeek and math.ceil((Time.stats.startday + Time.stats.clength) / 7) or 6
	local CurrentDayMeter = Range[Settings.Range].adjustment(Time.curr.day + Time.stats.startday)
	for MeterNumber = 1, Range[Settings.Range].days do
		local Styles, day, EventText, EventColor = {Meters.Days.Styles.Normal}, Range[Settings.Range].formula(MeterNumber)
		
		if MeterNumber == 1 then
			table.insert(Styles, Meters.Days.Styles.FirstDay)
		elseif (MeterNumber % 7) == 1 then
			table.insert(Styles, Meters.Days.Styles.NewWeek)
		end
		
		-- Events ToolTip and MeterStyle
		if (Events or {})[day] and day > 0 and day <= Time.stats.clength then
			EventText = table.concat(Events[day].text, '\n')
			table.insert(Styles, Meters.Days.Styles.Event)
			
			for _, value in ipairs(Events[day].color) do
				if value == '' then
					-- Do Nothing
				elseif not EventColor then
					EventColor = value
				elseif EventColor ~= value then
					EventColor = ''
					break
				end
			end
		end
		
		-- Regular MeterStyles
		if CurrentDayMeter == MeterNumber and Time.stats.inmonth then
			table.insert(Styles, Meters.Days.Styles.Current)
		elseif math.ceil(MeterNumber / 7) > HideLastWeek then
			table.insert(Styles, Meters.Days.Styles.LastWeek)
		elseif day < 1 then
			day = day + Time.stats.plength
			table.insert(Styles, Meters.Days.Styles.PreviousMonth)
		elseif day > Time.stats.clength then
			day = day - Time.stats.clength
			table.insert(Styles, Meters.Days.Styles.NextMonth)
		elseif (
			(MeterNumber % 7) == 0 or
			(MeterNumber % 7) == (Settings.StartOnMonday and 6 or 1) and
			not EventText
		) then
			table.insert(Styles, Meters.Days.Styles.Weekend)
		end
		
		-- Define meter properties
		local MeterName = Meters.Days.Name(MeterNumber)
		local MeterProperties = {
			Text = LeadingZero(day),
			MeterStyle = table.concat(Styles, '|'),
			[Settings.EventText or 'ToolTipText'] = EventText or '',
			[Settings.EventColor or 'FontColor'] = EventColor or '',
		}
		for Option, Value in pairs(MeterProperties) do
			SKIN:Bang('!SetOption', MeterName, Option, Value)
		end
	end
	
	-- Define skin variables
	local SkinVariables = {
		ThisWeek = Range[Settings.Range].week(),
		Week = RotateDay(Time.curr.wday - 1),
		Today = Time.stats.inmonth and LeadingZero(Time.curr.day) or '',
		Month = Settings.MonthNames[Time.show.month] or Time.show.month,
		Year = Time.show.year,
		MonthLabel = ParseVariables(Settings.LabelFormat),
		LastWkHidden = 6 - HideLastWeek,
		NextEvent = '',
	}
	
	-- Week Numbers for the current month
	local FirstWeek = os.time{
		day = (6 - Time.stats.startday),
		month = Time.show.month,
		year = Time.show.year,
		isdst = false,
	}
	for i = 0, 5 do
		local WeekName = string.format('WeekNumber%d', i + 1)
		local YearDayNumber = os.date('%j', FirstWeek + i * 604800)
		SkinVariables[WeekName] = math.ceil(YearDayNumber / 7)
	end
	
	-- Parse Events table to create a list of events
	local Current = Time.curr()
	if type(Events) == 'table' and Time.stats.cmonth >= os.time{day = 1, month = Current.month, year = Current.year, isdst = false,} then
		local Evns = {}
		
		-- Create and sort a list of the days in the month
		local keys, start = {}, Time.stats.inmonth and Time.curr.day or 1
		for day, _ in pairs(Events) do
			if day >= start then
				table.insert(keys, day)
			end
		end
		table.sort(keys)
		
		-- Format the lines
		for _, day in ipairs(keys) do
			local names = {
				day = LeadingZero(day),
				desc = table.concat(Events[day].text, ', '),
			}
			
			local temp = function(variable)
				local ReturnValue = names[variable:lower()]
				
				if not ReturnValue then
					Error.Create('Invalid NextFormat variable {$%s}', variable)
					return ''
				end
				
				return ReturnValue
			end
			
			local line = Settings.NextFormat:gsub('{%$([^}]+)}', temp)
			
			table.insert(Evns, line)
		end
		
		SkinVariables.NextEvent = table.concat(Evns, '\n')
	end
	
	-- Set Skin Variables
	for Name, Value in pairs(SkinVariables) do
		SKIN:Bang('!SetVariable', Name, Value)
	end
	
	Error.Close()
end -- Draw

function Move(value) -- Move calendar through the months
	Error.Open('Move')
	
	local Current = Time.curr()
	if not MultiType(value, 'nil|number') then
		Error.Create('Input must be a number. Received %s instead.', type(value))
	elseif Range[Settings.Range].nomove or not value then
		Time.show = Current
	elseif math.ceil(value) == value then -- Check that value is not a decimal
		local Years = math.modf(value / 12) -- Number of years without months
		local Months = Time.show.month + value - Years * 12 -- Number of months without years
		
		local MonthsAdjustment
		if value < 0 then
			MonthsAdjustment = Months < 1 and 12 or 0
		else
			MonthsAdjustment = Months > 12 and -12 or 0
		end
		
		Time.show = {
			month = (Months + MonthsAdjustment),
			year = (Time.show.year + Years - MonthsAdjustment / 12),
		}
	else
		Error.Create('Invalid input %s', value)
	end
	
	Time.stats.inmonth = (Time.show.month == Current.month and Time.show.year == Current.year)
	SKIN:Bang('!SetVariable', 'NotCurrentMonth', Time.stats.inmonth and 0 or 1)
	
	Error.Close()
end -- Move

function Easter()
	local a, b, c, h, L, m = (Time.show.year % 19), math.floor(Time.show.year / 100), (Time.show.year % 100), 0, 0, 0
	local d, e, f, i, k = math.floor(b/4), (b % 4), math.floor((b + 8) / 25), math.floor(c / 4), (c % 4)
	h = (19 * a + b - d - math.floor((b - f + 1) / 3) + 15) % 30
	L = (32 + 2 * e + 2 * i - h - k) % 7
	m = math.floor((a + 11 * h + 22 * L) / 451)
	
	return os.time{
		month = math.floor((h + L - 7 * m + 114) / 31),
		day = ((h + L - 7 * m + 114) % 31 + 1),
		year = Time.show.year,
	}
end -- Easter

BuiltIn = {
	easter = function()
		return Easter()
	end,
	
	goodfriday = function() -- Old style format. To be removed later
		return Easter() - 2 * 86400
	end,
	
	ashwednesday = function() -- Old style format. To be removed later
		return Easter() - 46 * 86400
	end,
	
	mardigras = function() -- Old style format. To be removed later
		return Easter() - 47 * 86400
	end,
	
	orthodoxeaster = function()
		-- Original Source: http://www.smart.net/~mmontes/ortheast.html
		local R4 = (19 * (Time.show.year % 19) + 16) % 30
		local RC = R4 + ((2 * (Time.show.year % 4) + 4 * (Time.show.year % 7) + 6 * R4) % 7)
		
		local stamp = os.time{
			year = Time.show.year,
			month = 4,
			day = 3,
			isdst = false,
		}
		
		return stamp + RC * 86400
	end,
} -- BuiltIn

function ParseVariables(line, FileName, ErrorSubstitute) -- Makes allowance for {$Variables}
	Error.Open('ParseVariables')
	
	local ScriptVariables = {
		mname = Settings.MonthNames[Time.show.month] or Time.show.month,
		year = Time.show.year,
		today = LeadingZero(Time.curr.day),
		month = Time.show.month,
	}
	local Day = {sun = 0, mon = 1, tue = 2, wed = 3, thu = 4, fri = 5, sat = 6,}
	local Week = {first = 0, second = 1, third = 2, fourth = 3,}
	
	local value = function(variable)
		local var = variable:gsub('%s', ''):lower()
		
		-- BuiltIn Event
		if (BuiltIn or {})[var:match('([^:]+):.+') or ''] then
			local name, vtype = var:match('^([^:]+):(.+)')
			local stamp = BuiltIn[name]()
			if vtype == 'stamp' then
				return stamp
			else
				return os.date('*t', stamp)[vtype]
			end
		
		-- Make allowance for old BuiltIn style
		elseif BuiltIn[var:match('(.+)month$') or var:match('(.+)day$') or ''] then
			local name = var:match('(.+)month$') or var:match('(.+)day$')
			local vtype = var:match('^' .. name .. '(.+)')
			return os.date('*t', BuiltIn[name]())[vtype]
		
		-- Event File Variable
		elseif ((Variables or {})[FileName or ''] or {})[var] then
			return Variables[FileName][var]
		
		-- Script Variable
		elseif ScriptVariables[var] then
			return ScriptVariables[var]
		
		-- Variable Day
		elseif (
			Week[var:match('(.+)...$') or ''] or
			Day[var:match('.+(...)$') or '']
		) then
			local WeekNum, DayNum = var:match('(.+)(...)')
			return Time.stats.vars[WeekNum][DayNum]
		end
	end -- value
	
	-- Allows for nested variables. IE: {$Var{$OtherVar}}
	-- In order to get around an issue where the function needed to be global,
	-- the function must be passed itself as an argument.
	local NestedExpression = function(InputLine, self)
		local temp = function(InputExpression)
			local NewLine = self(InputExpression:match('^{(.-)}$'), self)
			local name = NewLine:match('%$(.+)') or ''
			
			if name == '' then
				return string.format('{%s}', NewLine)
			end
			
			local ReturnValue = value(name)
				
			if not ReturnValue then 
				Error.Create('Invalid Variable {$%s}', name)
				return ErrorSubstitute
			elseif string.match(ReturnValue, '{%$.-}') then -- Allow for variables containing variables.
				return self(ReturnValue, self)
			else
				return ReturnValue
			end
		end
		
		return (InputLine:gsub('%b{}', temp))
	end -- NestedExpression
	
	local TempLine = NestedExpression(line, NestedExpression)
	Error.Close()
	return TempLine
end -- ParseVariables

-- Allow for existing but empty options and variables
Get = {
	Option = function(option, default)
		local input = SELF:GetOption(option)
		if input == '' then
			return default or ''
		else
			return input
		end
	end, -- GetOption
	
	NumberOption = function(option, default)
		return tonumber(SELF:GetOption(option)) or default or 0
	end, -- GetNumberOption
	
	Variable = function(option, default)
		local input = SKIN:GetVariable(option) or ''
		if input == '' then
			return default or ''
		else
			return input
		end
	end, -- GetVariable
	
	NumberVariable = function(option, default)
		local input = SKIN:GetVariable(option) or ''
		if input == '' then
			return default or 0
		else
			return SKIN:ParseFormula(input) or default or 0
		end
	end, -- GetNumberVariable
}

Parse = {
	Number = function(line, default, FileName, Decimals)
		line = ParseVariables(line, FileName, 0):gsub('%s', '')
		
		if line == '' then
			return default
		end
		
		local number = SKIN:ParseFormula('(' .. line .. ')') or default
		if Decimals then
			return tonumber(string.format('%.' .. Decimals .. 'f', number))
		else
			return number
		end
	end, -- Number
	
	Boolean = function(line, default, FileName)
		line = Parse.Formula(ParseVariables(line, FileName, ''))
		
		if line == '' then
			return default
		elseif tonumber(line) then
			return tonumber(line) ~= 0
		else
			return line:lower() == 'true'
		end
	end, -- Boolean
	
	List = function(line, default, FileName, FullList)
		line = ParseVariables(line, FileName, ''):gsub('[|%s]', ''):lower()
		
		if line == '' then
			return default
		elseif FullList:find(line) then
			return line
		else
			Error.Create('Invalid list option found in %s.', FileName)
			return default
		end
	end, -- List
	
	String = function(line, default, FileName, AllowSpaces)
		line = ParseVariables(line, FileName, '')
		
		if line == '' then
			return default
		elseif AllowSpaces then
			return line
		else
			return line:gsub('%s', '')
		end
	end, -- String
	
	Color = function(line, FileName, SkipVariables)
		if not SkipVariables then
			line = ParseVariables(line, FileName, 0)
		end
		line = Parse.Formula(line)
		
		if line == '' then
			return ''
		end
		
		local tbl = {}
		if line:match(',') then
			for rgb in line:gmatch('[^,]+') do
				if not tonumber(rgb) then
					Error.Create('Invalid RGB color code found in %s.', FileName)
					return ''
				end
				
				table.insert(tbl, string.format('%02X', tonumber(rgb)))
			end
		else
			for hex in line:gmatch('%S%S') do
				if not tonumber(hex, 16) then
					Error.Create('Invalid HEX color code found in %s.', FileName)
					return ''
				end
				
				table.insert(tbl, hex:upper())
			end
		end
		
		return table.concat(tbl)
	end, -- Color
	
	Date = function(line, default, FileName)
		line = Parse.Formula(ParseVariables(line, FileName, ''))
		if line == '' then
			return default
		end
		
		local DateTable = {}
		for word in line:gmatch('[^/]+') do
			local num = tonumber(word)
			if num then
				table.insert(DateTable, num)
			else
				break
			end
		end
		
		if #DateTable ~= 3 then
			Error.Create('Invalid date code found in %s.', FileName)
			return default
		end
		
		return os.time{
			day = DateTable[1],
			month = DateTable[2],
			year = DateTable[3],
			isdst = false,
		}
	end, -- Date
	
	Formula = function(line)
		local temp = function(input)
			return SKIN:ParseFormula(input)
		end
		return line:gsub('%s', ''):gsub('(%b())', temp)
	end, -- Formula
}

function RotateDay(value) -- Makes allowance for StartOnMonday
	if Settings.StartOnMonday then
		return ((value - 1 + 7) % 7)
	else
		return value
	end
end -- RotateDay

function LeadingZero(value) -- Makes allowance for LeadingZeros
	if Settings.LeadingZeroes then
		return string.format('%02d', value)
	else
		return value
	end
end -- LeadingZero

function MultiType(input, types) -- Test an input against multiple types
	return not not types:find(type(input))
	--return types:find(type(input)) and true or false
end -- MultiType

function inTable(t, value) -- Search a table for the first instance of a value
	for key, item in pairs(t) do
		if type(item) ~= type(value) then
			-- Do Nothing
		elseif item == value then
			return key
		end
	end
	return false
end -- inTable

Error = {
	Source = {''},
	Message = 'Success!',
	Queue = nil,
	
	Open = function(input)
		input = tostring(input)
		if input then
			input = input .. ': '
		end
		
		table.insert(Error.Source, 1, input or '')
	end,
	
	Close = function()
		if #Error.Source > 1 then
			table.remove(Error.Source, 1)
		end
	end,
	
	Log = function()
		if Error.Queue then
			for _, Message in ipairs(Error.Queue) do
				SKIN:Bang('!Log', Message, 'ERROR')
			end
			Error.Message, Error.Queue = Error.Queue[#Error.Queue], nil
		end
		
		return Error.Message
	end,

	Create = function(...)
		local NewMessage = Error.Source[1] .. ': ' .. string.format(unpack(arg))
		if not Error.Queue then
			Error.Queue = {NewMessage}
		elseif not inTable(Error.Queue, NewMessage) then
			table.insert(Error.Queue, NewMessage)
		end
	end,
} -- Error

-- Function provided by Mordasius, tweaked by Smurfier
function GetPhaseNumber(year, month, day)
	local fixangle = function(a) return a % 360 end
	local eccent = 0.016718 -- Eccentricity of Earth's orbit
	
	-- Convert Gregorian Date into Julian Date
	local gregorian = year >= 1583
	if month == 1 or month == 2 then
		year, month = (year - 1), (month + 12)
	end
	local a = math.floor(year / 100)
	local b = gregorian and (2 - a + math.floor(a / 4)) or 0
	local Jday = math.floor(365.25 * (year + 4716)) + math.floor(30.6001 * (month + 1)) + day + b - 1524
	
	local Day, M, Ec, Lambdasun, ml, Ev, Ae, MM, MmP, mEc, lP
	Day = Jday - 2444238.5 -- Date within epoch
	
	-- (360 / 365.2422) == 0.98564733209908
	M = math.rad(fixangle(fixangle(0.98564733209908 * Day) - 3.762863)) -- Convert from perigee co-ordinates to epoch 1980.0
	
	-- Solve Kepler equation
	local e, delta = M, - eccent * math.sin(M)
	while math.abs(delta) > 1E-6 do
		delta = e - eccent * math.sin(e) - M
		e = e - delta / (1 - eccent * math.cos(e))
	end
	
	-- math.sqrt((1 + eccent) / (1 - eccent)) == 1.0168601118216
	Ec = 2 * math.deg(math.atan(1.0168601118216 * math.tan(e / 2))) -- True anomaly
	
	Lambdasun = fixangle(Ec + 282.596403) -- Sun's geocentric ecliptic Longitude
	ml = fixangle(13.1763966 * Day + 64.975464) -- Moon's mean Longitude
	MM = fixangle(ml - 0.1114041 * Day - 348.383063) -- Moon's mean anomaly
	Ev = 1.2739 * math.sin(math.rad(2 * (ml - Lambdasun) - MM)) -- Evection
	Ae = 0.1858 * math.sin(M) -- Annual equation
	MmP = math.rad(MM + Ev - Ae - (0.37 * math.sin(M))) -- Corrected anomaly
	mEc = 6.2886 * math.sin(MmP) -- Correction for the equation of the centre
	lP = ml + Ev + mEc - Ae + (0.214 * math.sin(2 * MmP)) -- Corrected Longitude
	local PhaseNum = fixangle((lP + (0.6583 * math.sin(math.rad(2 * (lP - Lambdasun))))) - Lambdasun)
	
	if PhaseNum > 10 and PhaseNum <= 85 then
		return 2 -- Waxing Crescent
	elseif PhaseNum > 85 and PhaseNum <= 95 then
		return 3 -- First Quarter
	elseif PhaseNum > 95 and PhaseNum <= 170 then
		return 4 -- Waxing Gibbous
	elseif PhaseNum > 170 and PhaseNum <= 190 then
		return 5 -- Full Moon
	elseif PhaseNum > 190 and PhaseNum <= 265 then
		return 6 -- Waning Gibbous
	elseif PhaseNum > 265 and PhaseNum <= 275 then
		return 7 -- Last Quarter
	elseif PhaseNum > 275 and PhaseNum <= 350 then
		return 8 -- Waning Crescent
	else
		return 1 -- New Moon
	end
end  -- GetPhaseNumber