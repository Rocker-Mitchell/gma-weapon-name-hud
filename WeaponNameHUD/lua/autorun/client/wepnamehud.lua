-- convar name for enabling hud
local CV_ENABLE = "weapon_name_hud"
-- convar name for tracking font color
local CV_FONT_COLOR = "weapon_name_hud_font_color"
-- color for the background
local BG_COLOR = Color(0, 0, 0, 80)
-- default color vector for the font; alpha value not tracked
local FONT_COLOR_VECTOR = Color(255, 235, 90):ToVector()
-- alpha color for the font
local FONT_ALPHA = 240

-- client convar that enables the hud
CreateClientConVar(CV_ENABLE, 0)
-- client convar tracking font color
CreateClientConVar(CV_FONT_COLOR, tostring(FONT_COLOR_VECTOR))

-- menu builder
local function WeaponNameHudMenu()
    local function BuildMenu(panel)
        -- NOTE: panel should be a DForm

        -- checkbox to enable hud through convar
        panel:CheckBox("Turn the weapon name HUD on", CV_ENABLE)

        -- mixer for font color
        local font_color_mixer = vgui.Create("DColorMixer")
        font_color_mixer:SetLabel("Set a custom font color")
        font_color_mixer:SetAlphaBar(false)
        font_color_mixer:SetPalette(true)
        font_color_mixer:SetWangs(true)
        font_color_mixer:SetVector(Vector(GetConVar(CV_FONT_COLOR):GetString()))
        function font_color_mixer:ValueChanged(color)
            -- update convar with new color's vector
            RunConsoleCommand(CV_FONT_COLOR, tostring(color:ToVector()))
        end
        -- BUG: mixer's palette button size too small, leaves gap on last row

        panel:AddItem(font_color_mixer)

        -- button for color reset
        local font_color_reset = vgui.Create("DButton")
        font_color_reset:SetText("Reset the font color")
        function font_color_reset:DoClick()
            -- udpate mixer with default color vector
            font_color_mixer:SetVector(FONT_COLOR_VECTOR)
        end

        panel:AddItem(font_color_reset)
    end

    spawnmenu.AddToolMenuOption("Options", "Player", "WeaponNameHud",
                                "Weapon Name HUD", "", "", BuildMenu)
end

-- hud painter
local function WeaponNameHudPaint()
    -- return early when the HUD shouldn't render
    if (not GetConVar("cl_drawhud"):GetBool() or
        not GetConVar(CV_ENABLE):GetBool()) then return end

    local local_player = LocalPlayer()
    if (not local_player:Alive()) then return end

    local weapon = local_player:GetActiveWeapon()
    if (not IsValid(weapon)) then return end

    surface.SetFont("HudSelectionText")

    local font_color = Vector(GetConVar(CV_FONT_COLOR):GetString()):ToColor()
    font_color.a = FONT_ALPHA

    local padding = ScreenScale(6.5)

    local name = string.upper(weapon:GetPrintName())
    -- BUG: STool is not capitalized

    local name_width, name_height = surface.GetTextSize(name)
    local bg_width = name_width + (2 * padding)
    local bg_height = name_height + (2 * padding)

    local bg_x = (ScrW() - bg_width) / 2
    local bg_y = ScreenScale(12)
    local name_x = bg_x + padding
    local name_y = bg_y + padding

    -- draw the background
    draw.RoundedBox(ScreenScale(1.525), bg_x, bg_y, bg_width, bg_height,
                    BG_COLOR)

    -- print the name
    surface.SetTextColor(font_color)
    surface.SetTextPos(name_x, name_y)
    surface.DrawText(name)
end

-- add menu for hud
hook.Add("AddToolMenuTabs", "WeaponNameHudMenu", WeaponNameHudMenu)

-- add paint of hud
hook.Add("HUDPaint", "WeaponNameHudPaint", WeaponNameHudPaint)
