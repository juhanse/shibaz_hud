local function GetDoorPos(entDoor)
    local vecDimension = entDoor:OBBMaxs() -entDoor:OBBMins()
    local vecCenter = entDoor:OBBCenter()
    local intMinimum, intKey
    local vecNorm, angRotate, vecPos, intDot
    
    for i = 1, 3 do
        if !intMinimum or vecDimension[ i ] <= intMinimum then
            intKey = i
            intMinimum = vecDimension[ i ]
        end
    end
    vecNorm = Vector()
    vecNorm[ intKey ] = 1
    angRotate = Angle( 0, vecNorm:Angle().y +90, 90 )

    if entDoor:GetClass() == "prop_door_rotating" then
        vecPos = Vector( vecCenter.x, vecCenter.y, 15 ) +angRotate:Up() *( intMinimum /6 )
    else
        vecPos = vecCenter + Vector( 0, 0, 20 ) +angRotate:Up() *( ( intMinimum *.5 ) -0.1 )
    end

    local angRotateNew = entDoor:LocalToWorldAngles( angRotate )
    intDot = angRotateNew:Up():Dot( LocalPlayer():GetShootPos() -entDoor:WorldSpaceCenter() )
    if intDot < 0 then
        angRotate:RotateAroundAxis( angRotate:Right(), 180 )
        vecPos = vecPos -( 2 *vecPos *-angRotate:Up() )
        angRotateNew = entDoor:LocalToWorldAngles( angRotate )
    end
    vecPos = entDoor:LocalToWorld( vecPos )
    return vecPos, angRotateNew
end

local tClass = {
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_door"] = true
}

surface.CreateFont("Shibaz:HUD:FontDoors", {
    font = "Circular Std Medium",
    size = 80,
    weight = 500,
    extended = false
})

hook.Add("PostDrawTranslucentRenderables", "Shibaz:HUD:Doors", function()
    local eDoor = LocalPlayer():GetEyeTrace().Entity
    if not IsValid(eDoor) or not isentity(eDoor) then return end
    if not tClass[eDoor:GetClass()] then return end

    local tPos, tAng = GetDoorPos(eDoor)
    if LocalPlayer():GetPos():DistToSqr(tPos) > 500^2 then return end

    cam.Start3D2D(tPos + tAng:Up(), tAng, .03)   
        if not eDoor:getKeysNonOwnable() and not IsValid(eDoor:getDoorOwner()) then
            if not isstring(eDoor:getKeysDoorGroup()) then
                local tTeams = eDoor:getKeysDoorTeams()
                if not (istable(tTeams) and table.Count(tTeams) > 0) then
                    draw.SimpleTextOutlined("Acheter la porte", "Shibaz:HUD:FontDoors", 0, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_white)
                    draw.SimpleTextOutlined("➜ F2 pour acheter", "Shibaz:HUD:FontDoors", 0, 90, Color(22, 160, 133), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(22, 160, 133))
                else
                    local i = false
                    for k, v in pairs(tTeams) do
                        if i then continue end
                        draw.SimpleTextOutlined("La porte est achetée", "Shibaz:HUD:FontDoors", 0, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_white)
                        draw.SimpleTextOutlined("➜ Possédé par "..team.GetName(k), "Shibaz:HUD:FontDoors", 0, 90, Color(22, 160, 133), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(22, 160, 133))
                        i = true
                    end
                end
            else
                draw.SimpleTextOutlined("La porte est achetée", "Shibaz:HUD:FontDoors", 0, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_white)
                draw.SimpleTextOutlined("➜ Possédé par "..eDoor:getKeysDoorGroup(), "Shibaz:HUD:FontDoors", 0, 90, Color(22, 160, 133), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(22, 160, 133))
            end
        else
            if IsValid(eDoor:getDoorOwner()) then
                draw.SimpleTextOutlined("La Porte est Achetée", "Shibaz:HUD:FontDoors", 0, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_white)
                draw.SimpleTextOutlined("➜ Possédé par "..eDoor:getDoorOwner():Name(), "Shibaz:HUD:FontDoors", 0, 90, Color(22, 160, 133), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(22, 160, 133))
            end
        end
    cam.End3D2D()
end)
