-- convar name for enabling hud
local CV_ENABLE = "weapon_name_hud"
-- color for the font
local FONT_COLOR = Color(255, 235, 90, 240)
-- color for the background
local BG_COLOR = Color(0, 0, 0, 80)

-- client convar that enables the hud
CreateClientConVar(CV_ENABLE, 0)

-- menu builder
local function WeaponNameHudMenu()
    spawnmenu.AddToolMenuOption("Options", "Player", "WeaponNameHud",
                                "Weapon Name HUD", "", "", function(panel)
        -- checkbox to enable hud through CCV
        local checkbox_enable = vgui.Create("DCheckBoxLabel")
        checkbox_enable:SetText("Turn the weapon name HUD on")
        checkbox_enable:SetTextColor(Color(0, 0, 0, 255))
        checkbox_enable:SetConVar(CV_ENABLE)
        checkbox_enable:SetValue(GetConVarNumber(CV_ENABLE))

        panel:AddItem(checkbox_enable)
    end)
end

-- hud painter
local function WeaponNameHudPaint()
    -- return early when the HUD shouldn't render
    if (GetConVarNumber("cl_drawhud") == 0 or GetConVarNumber(CV_ENABLE) ==
        0) then return end

    local local_player = LocalPlayer()
    if (not local_player:Alive()) then return end

    local weapon = local_player:GetActiveWeapon()
    if (not IsValid(weapon)) then return end

    surface.SetFont("HudSelectionText")

    -- margin for font to background
    local margin = ScreenScale(6.5)

    local name = string.upper(weapon:GetPrintName())

    local name_width, name_height = surface.GetTextSize(name)
    local bg_width = name_width + 2 * margin
    local bg_height = name_height + 2 * margin

    local bg_x = (ScrW() - bg_width) / 2
    local bg_y = ScreenScale(12)
    local name_x = bg_x + margin
    local name_y = bg_y + margin

    -- draw the background
    draw.RoundedBox(ScreenScale(1.525), bg_x, bg_y, bg_width, bg_height,
                    BG_COLOR)

    -- print the name
    surface.SetTextColor(FONT_COLOR)
    surface.SetTextPos(name_x, name_y)
    surface.DrawText(name)
end

-- add menu for hud
hook.Add("AddToolMenuTabs", "WeaponNameHudMenu", WeaponNameHudMenu)

-- add paint of hud
hook.Add("HUDPaint", "WeaponNameHudPaint", WeaponNameHudPaint)
