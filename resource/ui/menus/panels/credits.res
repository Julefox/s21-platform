resource/ui/menus/panels/credits.res
{
	// Modern vertical credits list (Rumble overview / cups-list energy):
	// tall scroll rows + hover tooltip + live detail pane.
	// Horizontal page-carousel saved as credits2.res / lobby_panel_credits2.nutui.

	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible					0
		bgcolor_override		"0 0 0 0"
		paintbackground			1
	}

	Header
	{
		ControlName				Label
		labelText				"CREDITS"
		font					TitleBoldFont
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				40
		fgcolor_override		"255 255 255 255"
		zpos					10
		xpos					-80
		ypos					-40

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	HeaderLine
	{
		ControlName				ImagePanel
		wide					360
		tall					3
		zpos					10
		fillColor				"255 70 70 255"
		drawColor				"255 70 70 255"
		visible					1
		ypos					6

		pin_to_sibling			Header
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	// Vertical scroll list of tall credit rows
	CreditsList
	{
		ControlName				GridButtonListPanel
		xpos					-80
		ypos					-100
		wide					420
		columns					1
		rows					8
		buttonSpacing			8
		scrollbarSpacing		6
		scrollbarOnLeft			0
		setUnusedScrollbarInvisible 0
		visible					1
		tabPosition				1
		selectOnDpadNav			1
		zpos					10

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT

		ButtonSettings
		{
			// Same quality-row language as modern inventory / cup lists
			rui						"ui/generic_item_button.rpak"
			clipRui					1
			wide					400
			tall					64
			cursorVelocityModifier	0.7
			rightClickEvents		1
			doubleClickEvents		1
			sound_focus				"UI_Menu_Focus_Small"
			sound_accept			"UI_Menu_Accept"
			sound_deny				""
		}
	}

	// Live detail pane (overview-style focus panel)
	DetailPlate
	{
		ControlName				ImagePanel
		wide					980
		tall					640
		zpos					5
		fillColor				"10 12 18 230"
		drawColor				"10 12 18 230"
		visible					1
		xpos					-60
		ypos					-100

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DetailAccent
	{
		ControlName				ImagePanel
		wide					6
		tall					640
		zpos					6
		fillColor				"255 70 70 255"
		drawColor				"255 70 70 255"
		visible					1

		pin_to_sibling			DetailPlate
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	DetailImage
	{
		ControlName				RuiPanel
		wide					360
		tall					360
		xpos					-36
		ypos					-36
		zpos					8
		visible					1
		rui						"ui/basic_image.rpak"
		scaleImage				1

		ruiArgs
		{
			basicImage			"rui/menu/apex_rumble/about_rumble_enter"
		}

		pin_to_sibling			DetailPlate
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	DetailName
	{
		ControlName				Label
		labelText				""
		font					TitleBoldFont
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				44
		fgcolor_override		"255 255 255 255"
		zpos					9
		xpos					-36
		ypos					-36

		pin_to_sibling			DetailPlate
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	DetailRole
	{
		ControlName				Label
		labelText				""
		font					TitleBoldFont
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				22
		fgcolor_override		"255 70 70 255"
		zpos					9
		ypos					10

		pin_to_sibling			DetailName
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	DetailBody
	{
		ControlName				RichText
		wide					520
		tall					280
		font					DefaultRegularFont
		fontHeight				22
		text					""
		maxchars				-1
		bgcolor_override		"0 0 0 0"
		paintbackground			0
		zpos					9
		ypos					28

		pin_to_sibling			DetailRole
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	DetailHint
	{
		ControlName				Label
		labelText				"HOVER A ROW FOR TOOLTIP  -  CLICK TO PIN"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				16
		fgcolor_override		"160 160 160 200"
		zpos					9
		ypos					-28

		pin_to_sibling			DetailPlate
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	BOTTOM
	}

	// Keep dummy fields some old paths might probe (hidden)
	Name
	{
		ControlName				Label
		visible					0
		labelText				""
		wide					1
		tall					1
	}
	Github
	{
		ControlName				Label
		visible					0
		labelText				""
		wide					1
		tall					1
	}
	Twitter
	{
		ControlName				Label
		visible					0
		labelText				""
		wide					1
		tall					1
	}
	DescriptionShort
	{
		ControlName				Label
		visible					0
		labelText				""
		wide					1
		tall					1
	}
	Description
	{
		ControlName				RichText
		visible					0
		text					""
		wide					1
		tall					1
	}
}
