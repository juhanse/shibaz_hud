local Colors = {
    [NOTIFY_GENERIC] = Color(241, 196, 15),
    [NOTIFY_ERROR] = Color(192, 57, 43),
    [NOTIFY_UNDO] = Color(243, 156, 18),
    [NOTIFY_HINT] = Color(39, 174, 96),
    [NOTIFY_CLEANUP] = Color(41, 128, 185)    
}

local Icons = {
    [NOTIFY_GENERIC] = "generic",
    [NOTIFY_ERROR] = "error",
    [NOTIFY_UNDO] = "undo",
    [NOTIFY_HINT] = "hint",
    [NOTIFY_CLEANUP] = "cleanup"
}

local Notifications = {}

function notification.AddLegacy(text, type, time)
	surface.SetFont(Shibaz:Font(17))

	local w = surface.GetTextSize(text) + 20 + 32
	local h = 50
	local x = ScrW()
	local y = ScrH()/ 1

	table.insert(Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[ type ],
		icon = Icons[ type ],
		time = CurTime() + time,

		progress = false,
	})
end

function Shibaz.HUD:DrawNotify()
	for k, v in ipairs(Notifications) do
        Shibaz.HUD:CreateBox(
            v.x + 310,
            v.y - 12,
            v.text,
            v.icon,
            v.col,
            nil,
            false,
            true
        )
		v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - 50 or ScrW() + 50)
		v.y = Lerp(FrameTime() * 10, v.y, ScrH()/ 1 - (k - 1) * (v.h + 5))
	end

	for k, v in ipairs(Notifications) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove(Notifications, k)
		end
	end
end
