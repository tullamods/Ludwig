--[[
	Chinese translation (zhCN) by lostcup @ NGACN
--]]

if GetLocale() ~= "zhCN" then return end
local ADDON, Addon = ...
local L = Addon.Locals

-- Keybindings
BINDING_NAME_LUDWIG_SHOW = "显示 " .. ADDON

-- UI
L.FrameTitle = ADDON ..  ": %d件物品"

-- Slash command responses
L.UnknownCommand = "\"%s\"命令不能被识别"
L.MissingNumber = "缺少要查询的物品 ID"
