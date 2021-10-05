--[[
	Chinese translation (zhCN) by lostcup @ NGACN
--]]

if GetLocale() ~= "zhCN" then return end

local ADDON, Addon = ...
local L = Addon('Locals')

--Keybinding text
BINDING_HEADER_LUDWIG = "Ludwig"
BINDING_NAME_LUDWIG_SHOW = "显示 Ludwig"

--UI text
L.FrameTitle = "Ludwig: %d件物品"

--filters
L.Key = "钥匙"
L.Quest = "任务"
L.Junk = "垃圾"
L.Parts = "零件"
L.Explosives = "爆炸物"
L.Devices = "设备"
L.TradeGoods = "商品"

--Slash command responses
L.UnknownCommand = "\"%s\"命令不能被识别"
L.MissingNumber = "缺少要查询的物品 ID"
L.NoMatchingItems = "没有物品能够匹配关键字\"%s\""
L.NumMatching = "共有%d件物品能够匹配关键字\"%s\"："
L.GenTime = "耗时%.3f秒"
