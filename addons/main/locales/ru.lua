--[[
	Russian locale (ruRU) by ZamestoYV
--]]

if GetLocale() ~= "ruRU" then return end
local ADDON, Addon = ...
local L = Addon.Locals

-- Keybindings
BINDING_HEADER_LUDWIG = ADDON
BINDING_NAME_LUDWIG_SHOW = 'Показать ' .. ADDON

-- UI
L.FrameTitle = ADDON .. ': |cffffffff%d предметов|r'

-- Slash command responses
L.UnknownCommand = '"%s" - неизвестная команда'
L.MissingNumber = 'Отсутствует ID предмета для запроса'
