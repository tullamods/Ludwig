local AddonName, Addon = ...
local Search = Addon:NewModule('Search')

Search.name = '';

function Search:GetItems()
	if not itemDB then
	local items = ItemDB:GetItems(
		self.name,
		self.quality,
		self.type,
		self.subType,
		self.equipLoc,
		self.minLevel,
		self.maxLevel
	)

	self.lastSearch = items
	return items
end

function Search:Reset()
	self.name = ''
	self.quality = nil
	self.type = nil
	self.subType = nil
	self.equipLoc = nil
	self.minLevel = nil
	self.maxLevel = nil
end