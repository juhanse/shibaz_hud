Shibaz = Shibaz or {}
Shibaz.HUD = {}

function Shibaz:Init(class, path)
    local file = "shibaz/" .. path .. ".lua"
    print("[Shibaz][HUD] " .. file .. " ✓")

    if class == "server" then
        if SERVER then
            include(file)
        end
    elseif class == "shared" then
        AddCSLuaFile(file)
        include(file)
    elseif class == "client" then
        if SERVER then
            AddCSLuaFile(file)
        else
            include(file)
        end
    end
end

Shibaz:Init("shared", "hud/elements/function")
Shibaz:Init("shared", "hud/configuration")

Shibaz:Init("client", "hud/elements/hud")
Shibaz:Init("client", "hud/elements/notify")
Shibaz:Init("client", "hud/elements/darkrp")
Shibaz:Init("client", "hud/elements/door")

Shibaz:Init("server", "hud/elements/resource")