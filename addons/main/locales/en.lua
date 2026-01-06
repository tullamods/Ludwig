--[[
	English default locale
--]]

local ADDON, Addon = ...
local L = Addon:NewModule('Locals')

-- Keybindings
BINDING_NAME_LUDWIG_SHOW = 'Show ' .. ADDON

-- UI
L.FrameTitle = ADDON .. ': |cffffffff%d Items|r'

-- Slash command responses
L.UnknownCommand = '"%s" is an unknown command'
L.MissingNumber = 'Missing item id to query for'
