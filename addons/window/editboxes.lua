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

local Editboxes = Ludwig:NewModule('Editboxes')


--[[ Common ]]--

function Editboxes:Create(name, next, default, parent)
	local edit = CreateFrame('EditBox', '$parent'..name, parent, 'InputBoxTemplate')
	edit:SetScript('OnEnterPressed', edit.ClearFocus)
	edit:SetScript('OnTextChanged', self.OnTextChanged)
	edit:SetScript('OnTabPressed', self.OnTabPressed)
	edit:SetScript('OnEditFocusLost', self.OnEditFocusLost)
	edit:SetScript('OnEditFocusGained', self.OnEditFocusGained)

	edit.Default = self.Default
	edit.ClearDefault = self.ClearDefault
	edit.default = default
	edit.next = next
	edit.key = name

	edit:SetAutoFocus(false)
	edit:Default()

	return edit
end

function Editboxes:Default(onlyEmpty)
	if not onlyEmpty or self:GetText() == '' then
		self:SetText(self.default)
		self:ClearFocus()
	end
end

function Editboxes:ClearDefault()
	if self:GetText() == self.default then
		self:SetText('')
	end
end

function Editboxes:OnTextChanged(isUserInput)
	local text = self:GetText()
	if isUserInput then
		self:GetParent():SetFilter(self.key, text and text ~= '' and text)
	end
end

function Editboxes:OnTabPressed()
	self:GetParent()[self.next]:SetFocus()
end

function Editboxes:OnEditFocusLost()
	self:HighlightText(0, 0)
	self:Default(true)
end

function Editboxes:OnEditFocusGained()
	self:HighlightText()
	self:ClearDefault()
end


--[[ Levels ]]--

function Editboxes:CreateMinLevel(parent)
	return self:CreateNumeric('minLevel', 'maxLevel', '', parent)
end

function Editboxes:CreateMaxLevel(parent)
	return self:CreateNumeric('maxLevel', 'search', '', parent)
end

function Editboxes:CreateNumeric(...)
	local edit = self:Create(...)
	edit:SetSize(25, 16)
	edit:SetNumeric(true)
	edit:SetAutoFocus(false)
	edit:SetMaxLetters(3)
	return edit
end


--[[ Search ]]--

function Editboxes:CreateSearch(parent)
	local search = self:Create('search', 'minLevel', SEARCH, parent)
	search:SetSize(190, 20)
	return search
end
