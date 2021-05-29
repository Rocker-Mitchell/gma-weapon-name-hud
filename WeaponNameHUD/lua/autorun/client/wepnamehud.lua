-- CCV that enables the hud
CreateClientConVar("weapon_name_hud", 0)

-- Tool Menu Panels
hook.Add("AddToolMenuTabs", "weapon_name_hud", function()
    spawnmenu.AddToolMenuOption("Options", "Player", "weapon_name_hud",
                                "Weapon Name HUD", "", "", function(Panel)
        -- make checkbox for turning hud on
        local weapon_name_hud = vgui.Create("DCheckBoxLabel")
        weapon_name_hud:SetText("Turn the weapon name HUD on")
        weapon_name_hud:SetTextColor(Color(0, 0, 0, 255))
        weapon_name_hud:SetConVar("weapon_name_hud")
        weapon_name_hud:SetValue(GetConVarNumber("weapon_name_hud"))
        Panel:AddItem(weapon_name_hud)
    end)
end)

-- color for the font
local fontColor = Color(255, 235, 90, 240)
-- color for the background
local bgColor = Color(0, 0, 0, 80)

-- main painting function
local function HUDPaint()
    -- return early when the HUD shouldn't render
    if GetConVarNumber("weapon_name_hud") == 0 then return end
    if GetConVarNumber("cl_drawhud") == 0 then return end
    if not LocalPlayer():Alive() then return end
    if LocalPlayer():GetActiveWeapon() == NULL then return end
    if LocalPlayer():GetActiveWeapon() == "Camera" then return end

    surface.SetFont("HudSelectionText")

    -- margin for font to background
    local margin = ScreenScale(6.5)
    -- the weapon name
    local name = string.upper(LocalPlayer():GetActiveWeapon():GetPrintName())

    local textWidth, textHeight = surface.GetTextSize(name)
    local bgWidth = textWidth + 2 * margin
    local bgHeight = textHeight + 2 * margin

    local bgX = (ScrW() - bgWidth) / 2
    local bgY = ScreenScale(12)
    local fontX = bgX + margin
    local fontY = bgY + margin

    -- draw the background
    draw.RoundedBox(ScreenScale(1.525), bgX, bgY, bgWidth, bgHeight, bgColor)

    -- print the name
    surface.SetTextColor(fontColor)
    surface.SetTextPos(fontX, fontY)
    surface.DrawText(name)
end

-- add HUDPaint() to HUDPaint hook
hook.Add("HUDPaint", "wepnamehud.HUDPaint()", HUDPaint)
