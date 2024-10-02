Shibaz.HUD.RemoveBase = {
	["DarkRP_HUD"] = true,
	["DarkRP_EntityDisplay"] = false,
	["DarkRP_ZombieInfo"] = false,
    ["DarkRP_PlayerInfo"] = false,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Agenda"] = false,
	["DarkRP_Hungermod"] = true,
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSuitPower"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
    ["CHudCrosshair"] = true
}

hook.Add("HUDShouldDraw", "Shibaz:HUD:RemoveBase", function(name)
    if (Shibaz.HUD.RemoveBase[name]) then
        return false
    end
end)

hook.Add("HUDDrawTargetID", "Shibaz:HUD:RemoveTarget", function()
    return false
end)

usermessage.Hook("_Notify", function(msg)
    local txt = msg:ReadString()
    
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end)

hook.Add("Initialize", "Shibaz:HUD:RemoveFPP", function() 
	hook.Remove("HUDPaint", "FPP_HUDPaint")  
end)
