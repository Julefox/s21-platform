resource/ui/menus/panels/create_match.res
{
	DarkenBackground
	{
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
		visible					1
		bgcolor_override		"0 0 0 0"
		paintbackground			1
	}

	CreateServerBG
	{
		ControlName				ImagePanel
		classname				"CreateServerUI"
		ypos					-100
		xpos					-20
		wide					490
		tall					280
		fillColor				"30 30 30 100"
		drawColor				"30 30 30 100"
		visible					1
		zpos					0

		pin_to_sibling			DarkenBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	CreateServerBGTopLine
	{
		ControlName				ImagePanel
		classname				"CreateServerUI"
		wide					490
		tall					3
		fillColor				"195 29 38 200"
		drawColor				"195 29 38 200"
		visible					1
		zpos					0

		pin_to_sibling			CreateServerBG
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	CreateServerBGBottomLine
	{
		ControlName				ImagePanel
		classname				"CreateServerUI"
		wide					490
		tall					40
		fillColor				"195 29 38 200"
		drawColor				"195 29 38 200"
		visible					1
		zpos					0

		pin_to_sibling			CreateServerBG
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
	}

	ServerSettingsText
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"SERVER SETTINGS"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					10
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			CreateServerBGBottomLine
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	// S21: custom_loadscreen_image.rpak is S3-only; basic_image is retail-safe.
	ServerMapImg
	{
		ControlName				RuiPanel
		wide					680
		tall					370
		visible					1
		rui						"ui/basic_image.rpak"
		ypos					-125
		xpos					-25
		zpos					1
		scaleImage				1

		ruiArgs
		{
			basicImage			"rui/menu/character_skills/background"
		}

		pin_to_sibling			DarkenBackground
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	ServerMapImgTopLine
	{
		ControlName				ImagePanel
		wide					680
		tall					3
		fillColor				"195 29 38 200"
		drawColor				"195 29 38 200"
		visible					1
		zpos					0

		pin_to_sibling			ServerMapImg
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	ServerMapImgBottomLine
	{
		ControlName				ImagePanel
		wide					680
		tall					3
		fillColor				"195 29 38 200"
		drawColor				"195 29 38 200"
		visible					1
		zpos					0

		pin_to_sibling			ServerMapImg
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
	}

	// S21: generic_button (same as serverbrowser) instead of control_options_description.
	BtnStartGame
	{
		ControlName				RuiButton
		style					RuiButton
		classname				"CreateServerUI"
		wide					680
		tall					50
		xpos					0
		ypos					10
		zpos					6
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7

		ruiArgs
		{
			buttonText			""
		}

		pin_to_sibling			ServerMapImg
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BtnStartGameText
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"START LOCAL SERVER"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					7
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			BtnStartGame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	CreateStatusText
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				""
		font					Default_27_Outline
		wide					680
		zpos					7
		fontHeight				18
		textAlignment			center
		xpos					0
		ypos					8
		fgcolor_override		"200 200 200 255"
		visible					1

		pin_to_sibling			BtnStartGame
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	PlaylistNameBG
	{
		ControlName				ImagePanel
		xpos					0
		ypos					-15
		tall					30
		wide					225
		fillColor				"30 30 30 200"
		drawColor				"30 30 30 200"
		wrap					1
		visible					1
		zpos					6

		pin_to_sibling			ServerMapImg
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	PlaylistInfoEdit
	{
		ControlName				Label
		labelText				"--"
		font					Default_27_Outline
		allcaps					1
		wide					225
		zpos					7
		fontHeight				25
		textAlignment			center
		xpos					5
		ypos					0
		fgcolor_override		"240 240 240 255"
		bgcolor_override		"0 0 0 255"

		pin_to_sibling			PlaylistNameBG
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	MapServerNameBG
	{
		ControlName				ImagePanel
		xpos					0
		ypos					-15
		tall					30
		wide					680
		fillColor				"30 30 30 200"
		drawColor				"30 30 30 200"
		wrap					1
		visible					1
		zpos					6

		pin_to_sibling			ServerMapImg
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	MapServerNameInfoEdit
	{
		ControlName				Label
		labelText				"My local server"
		font					Default_27_Outline
		allcaps					1
		wide					680
		zpos					7
		fontHeight				25
		textAlignment			center
		xpos					0
		ypos					0
		fgcolor_override		"240 240 240 255"
		bgcolor_override		"0 0 0 255"

		pin_to_sibling			MapServerNameBG
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	VisBG
	{
		ControlName				ImagePanel
		xpos					0
		ypos					-15
		tall					30
		wide					125
		fillColor				"30 30 30 200"
		drawColor				"30 30 30 200"
		wrap					1
		visible					1
		zpos					6

		pin_to_sibling			ServerMapImg
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	VisInfoEdit
	{
		ControlName				Label
		labelText				"Offline"
		font					Default_27_Outline
		allcaps					1
		wide					125
		zpos					7
		fontHeight				25
		textAlignment			center
		xpos					0
		ypos					0
		fgcolor_override		"240 240 240 255"
		bgcolor_override		"0 0 0 255"

		pin_to_sibling			VisBG
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	BtnServerName
	{
		ControlName				RuiButton
		style					RuiButton
		wide					480
		tall					50
		xpos					0
		ypos					-5
		zpos					6
		classname				"createserverbuttons"
		scriptID				3
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7

		ruiArgs
		{
			buttonText			""
		}

		pin_to_sibling			CreateServerBG
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	BtnServerNameTxT
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"SERVER NAME"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					7
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			BtnServerName
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	BtnServerDesc
	{
		ControlName				RuiButton
		style					RuiButton
		wide					480
		tall					50
		xpos					0
		ypos					5
		zpos					6
		classname				"createserverbuttons"
		scriptID				4
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7

		ruiArgs
		{
			buttonText			""
		}

		pin_to_sibling			BtnServerName
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	BtnServerDescTxT
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"SERVER DESCRIPTION"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					7
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			BtnServerDesc
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	BtnPlaylist
	{
		ControlName				RuiButton
		style					RuiButton
		wide					480
		tall					50
		xpos					0
		ypos					5
		zpos					6
		classname				"createserverbuttons"
		scriptID				1
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7

		ruiArgs
		{
			buttonText			""
		}

		pin_to_sibling			BtnServerDesc
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	BtnPlaylistText
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"SELECT PLAYLIST"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					7
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			BtnPlaylist
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	BtnMap
	{
		ControlName				RuiButton
		style					RuiButton
		wide					480
		tall					50
		xpos					0
		ypos					5
		zpos					6
		classname				"createserverbuttons"
		scriptID				0
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7

		ruiArgs
		{
			buttonText			""
		}

		pin_to_sibling			BtnPlaylist
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	BtnMapText
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"SELECT MAP"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					7
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			BtnMap
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	BtnVis
	{
		ControlName				RuiButton
		style					RuiButton
		wide					480
		tall					50
		xpos					0
		ypos					5
		zpos					6
		classname				"createserverbuttons"
		scriptID				2
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7

		ruiArgs
		{
			buttonText			""
		}

		pin_to_sibling			BtnMap
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	BtnVisText
	{
		ControlName				Label
		classname				"CreateServerUI"
		labelText				"SELECT VISIBILITY"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		zpos					7
		fontHeight				25
		xpos					0
		ypos					0
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			BtnVis
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	R5RPlaylistPanel
	{
		ControlName				CNestedPanel
		classname				"CustomPrivateMatchMenu"
		ypos					-61
		xpos					-520
		wide					490
		tall					560
		visible					0
		controlSettingsFile		"resource/ui/menus/panels/create_playlist.res"
		proportionalToParent	1
		zpos					10

		pin_to_sibling			DarkenBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	R5RMapPanel
	{
		ControlName				CNestedPanel
		classname				"CustomPrivateMatchMenu"
		ypos					-61
		xpos					-520
		wide					490
		tall					560
		visible					0
		controlSettingsFile		"resource/ui/menus/panels/create_map.res"
		proportionalToParent	1
		zpos					10

		pin_to_sibling			DarkenBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	R5RVisPanel
	{
		ControlName				CNestedPanel
		classname				"CustomPrivateMatchMenu"
		ypos					-61
		xpos					-520
		wide					500
		tall					220
		visible					0
		controlSettingsFile		"resource/ui/menus/panels/create_visibility.res"
		proportionalToParent	1
		zpos					10

		pin_to_sibling			DarkenBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	R5RNamePanel
	{
		ControlName				CNestedPanel
		classname				"CustomPrivateMatchMenu"
		ypos					0
		zpos					45
		wide					f0
		tall					f0
		visible					0
		controlSettingsFile		"resource/ui/menus/panels/create_servername.res"
		proportionalToParent	1
	}

	R5RDescPanel
	{
		ControlName				CNestedPanel
		classname				"CustomPrivateMatchMenu"
		ypos					0
		zpos					45
		wide					f0
		tall					f0
		visible					0
		controlSettingsFile		"resource/ui/menus/panels/create_serverdesc.res"
		proportionalToParent	1
	}
}
