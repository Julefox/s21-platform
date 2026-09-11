resource/ui/menus/panels/credits2.res
{
	// CREDITS2 backup — horizontal page-carousel (prev/next).
	// Active credits tab uses credits.res (vertical list + tooltips).

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

	// Full-bleed page plate
	PageBG
	{
		ControlName				RuiPanel
		wide					1400
		tall					720
		zpos					1
		visible					1
		rui						"ui/basic_image.rpak"
		scaleImage				1

		ruiArgs
		{
			basicImage			"rui/menu/character_skills/background"
		}

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	PageFrame
	{
		ControlName				ImagePanel
		wide					1400
		tall					720
		zpos					2
		fillColor				"12 14 20 210"
		drawColor				"12 14 20 210"
		visible					1

		pin_to_sibling			PageBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	// Accent top bar (heirloom/rumble energy)
	PageTopAccent
	{
		ControlName				ImagePanel
		wide					1400
		tall					4
		zpos					5
		fillColor				"255 70 70 255"
		drawColor				"255 70 70 255"
		visible					1

		pin_to_sibling			PageFrame
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	PageImage
	{
		ControlName				RuiPanel
		wide					520
		tall					520
		xpos					-40
		ypos					-40
		zpos					6
		visible					1
		rui						"ui/basic_image.rpak"
		scaleImage				1

		ruiArgs
		{
			basicImage			"rui/menu/apex_rumble/about_rumble_enter"
		}

		pin_to_sibling			PageFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	PageTitle
	{
		ControlName				Label
		labelText				"CafeFPS"
		font					TitleBoldFont
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				48
		fgcolor_override		"255 255 255 255"
		zpos					7
		xpos					-40
		ypos					-40

		pin_to_sibling			PageFrame
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	PageRole
	{
		ControlName				Label
		labelText				"S21 Bridge"
		font					TitleBoldFont
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				24
		fgcolor_override		"255 70 70 255"
		zpos					7
		ypos					8

		pin_to_sibling			PageTitle
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	PageBody
	{
		ControlName				RichText
		wide					720
		tall					360
		font					DefaultRegularFont
		fontHeight				22
		text					""
		maxchars				-1
		bgcolor_override		"0 0 0 0"
		paintbackground			0
		zpos					7
		ypos					24

		pin_to_sibling			PageRole
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	PageIndex
	{
		ControlName				Label
		labelText				"1 / 1"
		font					DefaultBold_41
		allcaps					1
		auto_wide_tocontents	1
		fontHeight				20
		fgcolor_override		"200 200 200 220"
		zpos					8
		ypos					-24

		pin_to_sibling			PageFrame
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	BOTTOM
	}

	// Prev / Next — big hit targets like Rumble card nav
	BtnPrev
	{
		ControlName				RuiButton
		style					RuiButton
		wide					72
		tall					120
		zpos					10
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7
		xpos					-16

		ruiArgs
		{
			buttonText			"<"
		}

		pin_to_sibling			PageFrame
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT
	}

	BtnNext
	{
		ControlName				RuiButton
		style					RuiButton
		wide					72
		tall					120
		zpos					10
		visible					1
		enabled					1
		rui						"ui/generic_button.rpak"
		cursorVelocityModifier	0.7
		xpos					16

		ruiArgs
		{
			buttonText			">"
		}

		pin_to_sibling			PageFrame
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	// Hidden list kept only if something still queries it — not used for display.
	CreditsList
	{
		ControlName				GridButtonListPanel
		wide					1
		tall					1
		visible					0
		enabled					0
		columns					1
		rows					1

		ButtonSettings
		{
			rui						"ui/generic_item_button.rpak"
			wide					1
			tall					1
		}

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
}
