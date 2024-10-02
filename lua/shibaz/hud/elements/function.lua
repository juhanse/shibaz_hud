function Shibaz:Width(pos) 
	return pos/1920*ScrW()
end

function Shibaz:Height(pos)
	return pos/1080*ScrH()
end

if CLIENT then
	function Shibaz:Material(addons, mat, posx, posy, sizex, sizey, col)
		surface.SetMaterial(Material("shibaz/" .. addons .. "/" .. mat .. ".png", "smooth"))
		surface.SetDrawColor(col or color_white)
		surface.DrawTexturedRect(posx, posy, sizex, sizey)
	end

	Shibaz.Fonts = {}
	function Shibaz:Font(size, weight)
		size = size or 20
		weight = weight or 500
		
		local FontName = ("Shibaz:Font:%s:%s"):format(size, weight)
		if not Shibaz.Fonts[FontName] then
			surface.CreateFont(FontName, {
				font = "Circular Std Medium",
				size = Shibaz:Width(size),
				weight = weight,
				extended = false
			})

			Shibaz.Fonts[FontName] = true

		end

		return FontName
	end
	
	function Shibaz.HUD.GlowColor(col1, col2, mod)
		local newr = col1.r + ((col2.r - col1.r) * (mod))
		local newg = col1.g + ((col2.g - col1.g) * (mod))
		local newb = col1.b + ((col2.b - col1.b) * (mod))
		return Color(newr, newg, newb)
	end
	
	function Shibaz.HUD.DrawFadingText(speed, text, font, x, y, color, fading_color, xalign, yalign)
		local xalign = xalign or TEXT_ALIGN_LEFT
		local yalign = yalign or TEXT_ALIGN_TOP
		local color_fade = Shibaz.HUD.GlowColor(color, fading_color, math.abs(math.sin((RealTime() - 0.08) * speed)))
		draw.SimpleText(text, font, x, y, color_fade, xalign, yalign)
	end
    
    function Shibaz.HUD:CreateBox(x, y, txt, icon, icclr, w, align, visible)
		if not visible then return end

		surface.SetFont(Shibaz:Font(20))
		local TxTSizeW, TxTSizeH = surface.GetTextSize(txt)

		if align then
			// Background
			draw.RoundedBox(8, Shibaz:Width(x) + Shibaz:Width(20), Shibaz:Height(y) + Shibaz:Height(6), w and Shibaz:Width(w) or TxTSizeW + Shibaz:Width(42), Shibaz:Height(32), Shibaz.HUD.Config["BackgroundColor"])

			// Icon Background
			draw.RoundedBox(20, Shibaz:Width(x), Shibaz:Height(y), Shibaz:Height(43), Shibaz:Height(43), icclr and icclr or Color(227, 133, 61))

			// Text
			draw.SimpleText(txt, Shibaz:Font(20), Shibaz:Width(x) + Shibaz:Width(50), Shibaz:Height(y) + Shibaz:Height(21.5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			// Icon
			Shibaz:Material("hud", icon, Shibaz:Width(x) + Shibaz:Width(10), Shibaz:Height(y) + Shibaz:Height(10), Shibaz:Height(25), Shibaz:Height(25), Shibaz.HUD.Config["IconColor"])
		else			
			// Background
			draw.RoundedBox(8, Shibaz:Width(x) - (w and Shibaz:Width(w) or TxTSizeW + Shibaz:Width(42)), Shibaz:Height(y) + Shibaz:Height(6), w and Shibaz:Width(w) or TxTSizeW + Shibaz:Width(42), Shibaz:Height(32), Shibaz.HUD.Config["BackgroundColor"])
			
			w = w or TxTSizeW
			
			// Icon Background
			draw.RoundedBox(20, Shibaz:Width(x) - Shibaz:Width(20), Shibaz:Height(y), Shibaz:Height(43), Shibaz:Height(43), icclr and icclr or Color(227, 133, 61))

			// Text
			draw.SimpleText(txt, Shibaz:Font(20), Shibaz:Width(x) - Shibaz:Width(31), Shibaz:Height(y) + Shibaz:Height(21.5), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			// Icon
			Shibaz:Material("hud", icon, Shibaz:Width(x) + Shibaz:Width(10) - Shibaz:Width(20), Shibaz:Height(y) + Shibaz:Height(10), Shibaz:Height(25), Shibaz:Height(25), Shibaz.HUD.Config["IconColor"])
		end
    end

	function Shibaz.HUD:DrawCrossHair(size)
		if not Shibaz.HUD.Config["CrossHair"] then return end

		Shibaz:Material("hud", "crosshair", (Shibaz:Width(1920)/2) - Shibaz:Width(size)/2, (Shibaz:Height(1080)/2) - Shibaz:Width(size)/2, Shibaz:Width(size), Shibaz:Width(size))
	end

	function Shibaz.HUD:DrawWanted()
		if not Shibaz.HUD.Config["Wanted"] then return end
		if not LocalPlayer():getDarkRPVar("wanted") then return end

		Shibaz.HUD.DrawFadingText(1, Shibaz.HUD.Config["WantedMsg"], Shibaz:Font(40), Shibaz:Width(1920)/2, Shibaz:Height(50), Color(231, 76, 60), Color(51, 17, 13), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function Shibaz.HUD.DrawOwner()
		if not Shibaz.HUD.Config["Owner"] then return end

		local ent = LocalPlayer():GetEyeTraceNoCursor().Entity
		
		LocalPlayer().GetEntOwner = "World"

		if not IsValid(ent) then return end
		if not IsValid(ent:CPPIGetOwner()) then return end

		LocalPlayer().GetEntOwner = ent:CPPIGetOwner():Name()

		if LocalPlayer():GetPos():Distance(ent:GetPos()) > 500 then return end

		Shibaz.HUD:CreateBox(38, 500, LocalPlayer().GetEntOwner, "owner", Color(56, 173, 169), nil, true, true)
	end
end
