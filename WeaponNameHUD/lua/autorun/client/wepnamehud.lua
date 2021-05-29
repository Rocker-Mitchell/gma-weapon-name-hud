--[[
Weapon Name HUD
	A HUD component that prints the name of the active weapon.
	The mod strives to replicate the style of the default hud,
	and substitute the weapon selector's ability to display name.
Author: Rocker
Date since last update: 7/7/2017
--]]

--		Client ConVars
-- ccv that enables the hud
CreateClientConVar( "weapon_name_hud", 0 )

--		Tool Menu Panels
hook.Add( "AddToolMenuTabs", "weapon_name_hud", function()
	spawnmenu.AddToolMenuOption( "Options", -- tab
	"Player", -- category
	"weapon_name_hud", -- class (unique)
	"Weapon Name HUD", -- name
	"", "", -- cmd, config
	function( Panel )
		-- make checkbox for turning hud on
		local weapon_name_hud = vgui.Create( "DCheckBoxLabel" )
		weapon_name_hud:SetText( "Turn the weapon name HUD on" )
		weapon_name_hud:SetTextColor( Color(0, 0, 0, 255) )
		weapon_name_hud:SetConVar( "weapon_name_hud" )
		weapon_name_hud:SetValue( GetConVarNumber( "weapon_name_hud" ) )
		Panel:AddItem( weapon_name_hud )
	end )
end )

--		Constants
-- color for the font
local fontColor = Color( 255, 235, 90, 240 )
-- color for the background
local bgColor = Color( 0, 0, 0, 80 )

--		Functions
-- main painting function
local function HUDPaint()
	--		Checks
	-- return if weapon_name_hud is 0; player does not want to see weapon name
	if GetConVarNumber( "weapon_name_hud" ) == 0 then return end
	-- return if cl_drawhud is 0; player has made the hud stop drawing
	if GetConVarNumber( "cl_drawhud" ) == 0 then return end
	-- return if LocalPlayer() is not alive; hud can't draw if the player is dead
	if not LocalPlayer():Alive() then return end
	-- return if LocalPlayer():GetActiveWeapon() is NULL; there is no active weapon, so the weapon name can't be printed
	if LocalPlayer():GetActiveWeapon() == NULL then return end
	-- return if LocalPlayer():GetActiveWeapon() is the camera; the camera blocks the hud from showing
	if LocalPlayer():GetActiveWeapon() == "Camera" then return end
	
	--		Calculations
	surface.SetFont( "HudSelectionText" )
	-- create margin for font to background
	margin = ScreenScale( 6.5 )
	-- get the weapon name
	name = string.upper( LocalPlayer():GetActiveWeapon():GetPrintName() )
	-- caclulate background width and height
	textWidth, textHeight = surface.GetTextSize( name )
	bgWidth = textWidth + 2*margin
	bgHeight = textHeight + 2*margin
	-- find the coordinates necessary for the background
	bgX = ( ScrW() - bgWidth ) / 2
	bgY = ScreenScale( 12 )
	-- find the coordinates necessary for the font
	fontX = bgX + margin
	fontY = bgY + margin
	
	--		Drawing
	-- draw the background
	draw.RoundedBox( ScreenScale(1.525), bgX, bgY, bgWidth, bgHeight, bgColor )
	-- print the name
	surface.SetTextColor( fontColor )
	surface.SetTextPos( fontX, fontY )
	surface.DrawText( name )
end

--		Hooks
-- add HUDPaint() to HUDPaint hook
hook.Add( "HUDPaint", "wepnamehud.HUDPaint()", HUDPaint )
