function Shibaz.HUD.CreateHUD()
    local ply = LocalPlayer()

    ply.ShibazInfo = {
        Health = math.Clamp(ply:Health(), 0, 100),
        Armor = math.Clamp(ply:Armor(), 0, 100),
        Hunger = math.Clamp((DarkRP and (ply:getDarkRPVar("Energy") or 100) or 100), 0, 100),
        Name = ply:Name(),
        Team = (DarkRP and ply:getDarkRPVar("job") or team.GetName(ply:Team())),
        Money = (DarkRP and DarkRP.formatMoney(ply:getDarkRPVar("money")) or 0),
        Props = ply:GetCount("props"),
        Props2 = cvars.Number("sbox_maxprops", 0),
    }

    --[[

    // Note : Les positions sont déjà adaptées
    Shibaz.HUD:CreateBox(
        38, // Position X
        892, // Position Y
        ply.ShibazInfo.Name, // Texte
        "name", // Nom de l'icon (materials/shibaz/hud/iconname.png)
        Color(231, 76, 60), // Couleur des cercles
        215, // Longueur
        true, // Alignement : true = Gauche, false = Droite
        true // Activé ou non
    )

    ]]

    // Name
    Shibaz.HUD:CreateBox(
        38,
        892,
        ply.ShibazInfo.Name,
        "name", 
        Color(231, 76, 60),
        215,
        true,
        true
    )

    // Team
    Shibaz.HUD:CreateBox(
        38,
        946,
        ply.ShibazInfo.Team,
        "team",
        Color(52, 152, 219),
        215,
        true,
        true
    )

    // Health
    Shibaz.HUD:CreateBox(
        38,
        1000,
        ply.ShibazInfo.Health,
        "health",
        Color(155, 89, 182),
        92,
        true,
        true
    )

    // Hunger
    Shibaz.HUD:CreateBox(
        160,
        1000,
        math.Round(ply.ShibazInfo.Hunger),
        "hunger",
        Color(46, 204, 113),
        92,
        true,
        true
    )

    // Armor
    Shibaz.HUD:CreateBox(
        282,
        1000,
        ply.ShibazInfo.Armor,
        "armor",
        Color(230, 126, 34),
        92,
        true,
        ply.ShibazInfo.Armor >= 1 and true or false
    )

    // Props
    Shibaz.HUD:CreateBox(
        38,
        40,
        ply.ShibazInfo.Props .. "/" .. ply.ShibazInfo.Props2,
        "props",
        Color(0, 184, 148),
        nil,
        true,
        ply.ShibazInfo.Props >= 1 and true or false
    )

    // Money
    Shibaz.HUD:CreateBox(
        1860,
        40,
        ply.ShibazInfo.Money,
        "money",
        Color(26, 188, 156),
        nil,
        false,
        true
    )

    // Ammo
    if IsValid(ply:GetActiveWeapon()) and isnumber(ply:GetActiveWeapon():Clip1()) then
        Shibaz.HUD:CreateBox(
            1860,
            148,
            ply:GetActiveWeapon():Clip1() .. "/" .. ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()),
            "ammo",
            Color(253, 121, 168),
            nil,
            false,
            ply:GetActiveWeapon():Clip1() >= 1 and true or false
        )
    end

    // CrossHair
    Shibaz.HUD:DrawCrossHair(20)

    // Wanted
    Shibaz.HUD:DrawWanted()

    // Notify
    Shibaz.HUD:DrawNotify()

    // Owner
    Shibaz.HUD.DrawOwner()
    
    // Vehicle
    if ply:InVehicle() and ply:GetVehicle():GetClass() != "prop_vehicle_prisoner_pod" then

        ply.GetVehicleSpeed = 0
        ply.GetVehicleFuel = 0
        
        if VC then
            ply.GetVehicleSpeed = math.Round(LocalPlayer():GetVehicle():VC_getSpeedKmH())
            ply.GetVehicleFuel = math.Round(LocalPlayer():GetVehicle():VC_fuelGet(false))
        elseif SVMOD and SVMOD:GetAddonState() and SVMOD:IsVehicle(ply:GetVehicle()) then
            ply.GetVehicleSpeed = math.Round(ply:GetVehicle():SV_GetSpeed())
            ply.GetVehicleFuel = math.Round(ply:GetVehicle():SV_GetFuel())
        end
        
        Shibaz.HUD:CreateBox(
            1860,
            1000,
            ply.GetVehicleSpeed .. " Km/h",
            "speed",
            Color(87, 75, 144),
            nil,
            false,
            true
        )

        Shibaz.HUD:CreateBox(
            1860,
            946,
            ply.GetVehicleFuel .. "L",
            "fuel",
            Color(225, 95, 65),
            nil,
            false,
            true
        )
    end
end

timer.Simple(10, function()
    hook.Add("HUDPaint", "Shibaz:HUD:CreateHUD", Shibaz.HUD.CreateHUD)
end)
