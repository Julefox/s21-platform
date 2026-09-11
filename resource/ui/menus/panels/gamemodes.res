resource/ui/menus/panels/gamemodes.res
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

	// Everything else pins off this row, so this is what centres the whole block.
	// With a CENTER/CENTER pin, xpos/ypos are offsets: xpos 0 keeps it horizontally
	// centred, ypos lifts it by half the block height (44 + 8 + 500 + footer).
	CategoryBG
	{
		ControlName				ImagePanel
		xpos					0
		ypos					-260
		wide					970
		tall					44
		fillColor				"30 30 30 160"
		drawColor				"30 30 30 160"
		visible					1
		zpos					0

		pin_to_sibling			DarkenBackground
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	// Category buttons. ScriptID is the eGamemodeCategory value the panel reads.
	CategoryButton0
	{
		ControlName				RuiButton
		classname				"GamemodeCategoryButton"
		scriptID				0
		rui						"ui/generic_button.rpak"
		wide					242
		tall					40
		visible					1
		zpos					5
		xpos					1
		ypos					0
		sound_focus				"UI_Menu_Focus_Small"

		ruiArgs
		{
			buttonText			"BATTLE ROYALE"
		}

		pin_to_sibling			CategoryBG
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	CategoryButton1
	{
		ControlName				RuiButton
		classname				"GamemodeCategoryButton"
		scriptID				1
		rui						"ui/generic_button.rpak"
		wide					242
		tall					40
		visible					1
		zpos					5
		sound_focus				"UI_Menu_Focus_Small"

		ruiArgs
		{
			buttonText			"MIXTAPE"
		}

		pin_to_sibling			CategoryButton0
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	CategoryButton2
	{
		ControlName				RuiButton
		classname				"GamemodeCategoryButton"
		scriptID				2
		rui						"ui/generic_button.rpak"
		wide					242
		tall					40
		visible					1
		zpos					5
		sound_focus				"UI_Menu_Focus_Small"

		ruiArgs
		{
			buttonText			"SANDBOX"
		}

		pin_to_sibling			CategoryButton1
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	CategoryButton3
	{
		ControlName				RuiButton
		classname				"GamemodeCategoryButton"
		scriptID				3
		rui						"ui/generic_button.rpak"
		wide					242
		tall					40
		visible					1
		zpos					5
		sound_focus				"UI_Menu_Focus_Small"

		ruiArgs
		{
			buttonText			"ALL"
		}

		pin_to_sibling			CategoryButton2
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	ListBG
	{
		ControlName				ImagePanel
		xpos					0
		ypos					8
		wide					500
		tall					500
		fillColor				"20 20 20 190"
		drawColor				"20 20 20 190"
		visible					1
		zpos					0

		pin_to_sibling			CategoryBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	ModeList
	{
		ControlName				GridButtonListPanel
		xpos					0
		ypos					0
		columns					1
		rows					10
		buttonSpacing			2
		scrollbarSpacing		1
		scrollbarOnLeft			0
		setUnusedScrollbarInvisible 0
		visible					1
		zpos					5
		tabPosition				1
		selectOnDpadNav			1

		ButtonSettings
		{
			rui						"ui/generic_item_button.rpak"
			clipRui					1
			wide					492
			tall					48
			cursorVelocityModifier	0.7
			rightClickEvents		0
			doubleClickEvents		1
			sound_focus				"UI_Menu_Focus_Small"
			sound_accept			""
			sound_deny				""
		}

		pin_to_sibling			ListBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	ListFooterText
	{
		ControlName				Label
		labelText				""
		font					Default_21
		auto_wide_tocontents	1
		zpos					6
		xpos					4
		ypos					2
		fgcolor_override		"180 180 180 255"
		visible					1

		pin_to_sibling			ListBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	// Retail gamemode tile. Geometry mirrors serverbrowser.res's ServerMapImg,
	// which is the only gamemode_select_button instance proven on this client.
	ModePreview
	{
		ControlName				RuiPanel
		rui						"ui/gamemode_select_button.rpak"
		wide					450
		tall					250
		xpos					20
		ypos					0
		visible					1
		zpos					4
		polyShape				"5.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0"

		ruiArgs
		{
			lockIconEnabled		0
			modeNameText		""
			modeDescText		""
			alwaysShowDesc		1
		}

		pin_to_sibling			ListBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DetailBG
	{
		ControlName				ImagePanel
		xpos					0
		ypos					8
		wide					450
		tall					242
		fillColor				"20 20 20 190"
		drawColor				"20 20 20 190"
		visible					1
		zpos					0

		pin_to_sibling			ModePreview
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	DetailTitle
	{
		ControlName				Label
		labelText				""
		font					DefaultBold_36
		wide					430
		tall					34
		zpos					6
		xpos					10
		ypos					6
		fgcolor_override		"255 255 255 255"
		visible					1

		pin_to_sibling			DetailBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	DetailSubtitle
	{
		ControlName				Label
		labelText				""
		font					Default_24
		wide					430
		tall					26
		zpos					6
		xpos					0
		ypos					0
		fgcolor_override		"195 195 195 255"
		visible					1

		pin_to_sibling			DetailTitle
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	DetailDesc
	{
		ControlName				Label
		labelText				""
		font					Default_21
		wide					430
		tall					70
		wrap					1
		zpos					6
		xpos					0
		ypos					6
		fgcolor_override		"170 170 170 255"
		visible					1

		pin_to_sibling			DetailSubtitle
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	DetailShape
	{
		ControlName				Label
		labelText				""
		font					Default_21
		wide					430
		tall					24
		zpos					6
		xpos					0
		ypos					0
		fgcolor_override		"170 170 170 255"
		visible					1

		pin_to_sibling			DetailDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	DetailIdText
	{
		ControlName				Label
		labelText				""
		font					Default_21
		wide					430
		tall					24
		zpos					6
		xpos					0
		ypos					0
		fgcolor_override		"120 140 170 255"
		visible					1

		pin_to_sibling			DetailShape
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	BtnApplyMode
	{
		ControlName				RuiButton
		classname				"GamemodeApplyButton"
		rui						"ui/generic_button.rpak"
		wide					300
		tall					44
		visible					1
		zpos					6
		xpos					0
		ypos					6
		sound_focus				"UI_Menu_Focus_Small"
		sound_accept			"UI_Menu_Accept"

		ruiArgs
		{
			buttonText			"SET ON SERVER"
		}

		pin_to_sibling			DetailIdText
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	StatusText
	{
		ControlName				Label
		labelText				""
		font					Default_24
		wide					450
		tall					26
		zpos					6
		xpos					0
		ypos					4
		fgcolor_override		"235 205 120 255"
		visible					1

		pin_to_sibling			DetailBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
}
