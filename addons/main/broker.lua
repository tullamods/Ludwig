--[[
Copyright 2007-2023 João Cardoso
Ludwig is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of Ludwig.
--]]

local ADDON, Addon = ...
local Broker = Addon:NewModule('Broker', LibStub('LibDataBroker-1.1'):NewDataObject('Ludwig', {
	type = 'launcher', label = ADDON,
	icon = 'Interface/Icons/inv_misc_book_04'
}))

function Broker:OnClick()
	Addon:ToggleWindow()
end

function Broker:OnTooltipShow()
	self:AddLine(ADDON)
end
