--[[
	Localization for Ludwig
--]]

local AddonName, Addon = ...
local L = Addon:NewModule('Locals')

--Keybinding text
BINDING_HEADER_LUDWIG = "Ludwig"
BINDING_NAME_LUDWIG_SHOW = "Show Ludwig"

--UI text
L.FrameTitle = "Ludwig: %d Items"

--filters
L.Key = "Key"
L.Quest = "Quest"
L.Junk = "Junk"
L.Parts = "Parts"
L.Explosives = "Explosives"
L.Devices = "Devices"
L.TradeGoods = "Trade Goods"

--Slash command responses
L.UnknownCommand = "\"%s\" is an unknown command"
L.MissingNumber = "Missing item id to query for"
L.NoMatchingItems = "There are no items matching '%s'"
L.NumMatching = "There are %d items matching '%s':"
L.GenTime = "Generated in %.3f seconds"