local RedHealth = _G.RedHealth
BLT.AssetManager:CreateEntry(Idstring("guis/textures/custom/hud_health_below_225"), Idstring("texture"), ModPath.. "guis/textures/pd2/hud_health_below_225.texture")

if RedHealth._data.customhud_fix == "on" or RedHealth._data.customhud_fix == true then
	Hooks:PostHook(PlayerInfoComponent.PlayerStatus, "init", "radial_health_red_customhud_init", function (self, panel, owner, width, height, settings)
		VHUDPlus = _G.VHUDPlus
		self._size = height
		Radial_health_panel_customhud = self._panel
		self._radial_health_red = self._panel:bitmap({
			name = "health_radial_red",
			texture = "guis/textures/custom/hud_health_below_225",
			render_template = "VertexColorTexturedRadial",
			texture_rect = {
				128,
				0,
				-128,
				128
			},
			blend_mode = "add", --"normal" and VHUDPlus:getSetting({"CustomHUD", "DisableBlend"}, false) or "add",
			color = Color(1, 0, 1, 1),
			h = self._size,
			w = self._size,
			layer = 4,
		})
	end)

	Hooks:PostHook(PlayerInfoComponent.PlayerStatus, "set_health", "radial_health_red_customhud", function (self, current, total)
		
		local red = (current / total) -- New health percentage (*100)
		local currentHealth = current * 10
		local radial_health_red = self._panel:child("health_radial_red")
		local radial_health = self._panel:child("health_radial")

		if red ~= nil then

			if currentHealth <= RedHealth._data.health_value then

				radial_health:set_visible(false)
	
				if red > radial_health:color().red then -- If new health is higher than old health
	
					radial_health_red:animate(function (o)
						local s = radial_health_red:color().r
						local e = red
						local health_ratio = nil
		
						over(0.2, function (p)
							health_ratio = math.lerp(s, e, p)
							radial_health_red:set_color(Color(1, health_ratio, 1, 1))
						end)
					end)
	
				else
					radial_health_red:set_color(Color(1, red, 1, 1))
				end
				
			else
				radial_health_red:set_color(Color(1, 0, 1, 1))
				radial_health:set_visible(true)
			end

		end
	end)
end

Hooks:PostHook(HUDTeammate, "_create_radial_health", "radial_health_red", function (self, radial_health_panel)
	local radial_health_red = radial_health_panel:bitmap({
		texture = "guis/textures/custom/hud_health_below_225",
		name = "radial_health_red",
		layer = 4,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = radial_health_panel:w(),
		h = radial_health_panel:h()
	})
end)

Hooks:PostHook(HUDTeammate, "set_health", "redHealthBelow225", function(self, data)

	local red = data.current / data.total -- New health percentage (*100)
	local currentHealth = data.current * 10
	local radial_health_panel = self._radial_health_panel
	local radial_health_red = radial_health_panel:child("radial_health_red")
	local radial_health = radial_health_panel:child("radial_health")

	if red ~= nil then

		if currentHealth <= RedHealth._data.health_value then

			radial_health:set_visible(false)

			if red > radial_health:color().red then -- If new health is higher than old health

				radial_health_red:animate(function (o)
					local s = radial_health_red:color().r
					local e = red
					local health_ratio = nil
	
					over(0.2, function (p)
						health_ratio = math.lerp(s, e, p)
						radial_health_red:set_color(Color(1, health_ratio, 1, 1))
					end)
				end)

			else
				radial_health_red:set_color(Color(1, red, 1, 1))
			end
			
		else
			radial_health_red:set_color(Color(1, 0, 1, 1))
			radial_health:set_visible(true)
		end

	end

end)