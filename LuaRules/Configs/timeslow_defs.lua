local array = {}

------------------------
-- Config

local MAX_SLOW_FACTOR = 0.66
-- Max slow damage on a unit = MAX_SLOW_FACTOR * current health
-- Slowdown of unit = slow damage / current health
-- So MAX_SLOW_FACTOR is the limit for how much units can be slowed

local DEGRADE_TIMER = 0.5
-- Time in seconds before the slow damage a unit takes starts to decay

local DEGRADE_FACTOR = 0.04
-- Units will lose DEGRADE_FACTOR*(current health) slow damage per second

local UPDATE_PERIOD = 15 -- I'd preffer if this was not changed


local weapons = {
	slowmort_slowbeam = { slowDamage = 300, onlySlow = true, smartRetarget = 0.5, scaleSlow = true},
	cormak_blast = { slowDamage = 36, noDeathBlast = true, scaleSlow = true },
	slowmissile_weapon = { slowDamage = 1, onlySlow = true, scaleSlow = true },
}

-- reads from customParams and copies to weapons as appropriate - needed for procedurally generated comms
-- as always, need better way to handle if upgrades are desired!
local presets = {
	commrecon_slowbeam = { slowDamage = 450, onlySlow = true, smartRetarget = 0.5, scaleSlow = true},
	
	commrecon2_slowbeam = { slowDamage = 600, onlySlow = true, smartRetarget = 0.5, scaleSlow = true},
	commrecon2_slowbomb = { slowDamage = 1250, scaleSlow = true },
	
	commrecon3_slowbeam = { slowDamage = 750, onlySlow = true, smartRetarget = 0.5, scaleSlow = true},
	commrecon3_slowbomb = { slowDamage = 1500, scaleSlow = true },
	
	module_disruptorbeam = { slowDamage = 450, smartRetarget = 0.5, scaleSlow = true},
}

------------------------
-- Send the Config

--deep not safe with circular tables! defaults To false
function CopyTable(tableToCopy, deep)
	local copy = {}
		for key, value in pairs(tableToCopy) do
		if (deep and type(value) == "table") then
			copy[key] = CopyTable(value, true)
		else
			copy[key] = value
		end
	end
	return copy
end

for name,data in pairs(WeaponDefNames) do
	if data.customParams.timeslow_preset then
		weapons[name] = CopyTable(presets[data.customParams.timeslow_preset])
	end
	if weapons[name] then array[data.id] = weapons[name] end
end

return array, MAX_SLOW_FACTOR, DEGRADE_TIMER*30/UPDATE_PERIOD, DEGRADE_FACTOR*UPDATE_PERIOD/30, UPDATE_PERIOD