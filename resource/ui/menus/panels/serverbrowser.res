resource/ui/menus/panels/serverbrowser.res
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"%100"
		"tall"					"%100"
		"labelText"				""
		"bgcolor_override"		"0 0 0 0"
		"visible"				"1"
		"paintbackground"		"1"
	}

	"ServerBrowserBG"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"-245"
		"ypos"					"-70"
		"tall"					"50"
		"wide" 					"1395"
		fillColor		"50 50 50 255"
        drawColor		"50 50 50 255"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	"ServersBG"
	{
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"xpos"					"0"
		"ypos"					"-20"
		"tall"					"622"
		"wide" 					"1395"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"0"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui/menu/character_skills/background"
        }

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"ServerBrowserBGBottom"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"10"
		"tall"					"240"
		"wide" 					"1395"
		fillColor		"50 50 50 255"
        drawColor		"50 50 50 255"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"0"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
	}

	"BtnSearchLabel"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#BRIDGE_SB_SEARCH"
		"xpos"					"-23"
		"ypos"					"-16"
		"auto_wide_tocontents"	"1"
		"zpos" 					"10"
		"fontHeight"			"30"

		ruiArgs
		{
			buttonText "#BRIDGE_SB_SEARCH"
		}

		pin_to_sibling 			ServerBrowserBGBottom
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BtnServerSearch
	{
		ControlName				TextEntry
		xpos 10
		ypos 0
		wide 1275
		tall 40
		zpos					70 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
		allowRightClickMenu		0
		allowSpecialCharacters	0
		unicode					1

		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				100
		textAlignment			"center"
		ruiFont                 TitleRegularFont
		ruiFontHeight           22
		ruiMinFontHeight        16
		bgcolor_override		"30 30 30 200"

		pin_to_sibling 			BtnSearchLabel
		pin_corner_to_sibling LEFT
		pin_to_sibling_corner RIGHT
	}

	SwtBtnSelectGamemode
	{
		ControlName RuiButton
		InheritProperties SwitchButton
		style                   DialogListButton
		ConVar "serverbrowser_gameModeFilter"
		wide 670
		ypos 15

		ruiArgs
		{
			buttonText "#BRIDGE_SB_PLAYLIST_FILTER"
		}

		pin_to_sibling BtnSearchLabel
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner BOTTOM_LEFT

		childGroupAlways        MultiChoiceButtonAlways
	}

	SwtBtnSelectMap
	{
		ControlName RuiButton
		InheritProperties SwitchButton
		style                   DialogListButton
		ConVar "serverbrowser_mapFilter"
		wide 670
		ypos 0
		xpos 10

		ruiArgs
		{
			buttonText "#BRIDGE_SB_MAP_FILTER"
		}

		pin_to_sibling SwtBtnSelectGamemode
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT

		childGroupAlways        MultiChoiceButtonAlways
	}

	SwtBtnHideEmpty
	{
		ControlName RuiButton
		InheritProperties SwitchButton
		style                   DialogListButton
		ConVar "serverbrowser_hideEmptyServers"
		classname FilterPanelChild
		wide 1349
		ypos 10

		ruiArgs
		{
			buttonText "#BRIDGE_SB_HIDE_EMPTY"
		}

		list
		{
			"No" 0
			"Yes" 1
		}

		pin_to_sibling SwtBtnSelectGamemode
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner BOTTOM_LEFT

		childGroupAlways        ChoiceButtonAlways
	}

	"NoServersLbl"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#BRIDGE_SB_NO_SERVERS_FOUND"
		"xpos"					"0"
		"ypos"					"-15"
		"auto_wide_tocontents"	"1"
		"zpos" 					"10"
		"fontHeight"			"30"
		"visible"				"0"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}
	
	"NoSteamLbl"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#MAINMENU_WARNING_NO_STEAM"
		"xpos"					"0"
		"ypos"					"-15"
		"auto_wide_tocontents"	"1"
		"zpos" 					"10"
		"fontHeight"			"30"
		"visible"				"0"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"RefreshServers"
	{
		"ControlName"				"RuiButton"
		"style"						"RuiButton"
		"wide"						"200"
		"tall"						"35"
		"xpos"						"-5"
		"ypos"						"-5"
		"visible"					"1"
		"enabled"					"1"
		"zpos" 						"10"
        "rui"						"ui/generic_button.rpak"
		"cursorVelocityModifier"  	"0.7"

		ruiArgs
		{
			buttonText "#BRIDGE_SB_REFRESH_SERVERS"
		}

		"pin_to_sibling"			"ServerBrowserBGBottom"
		"pin_corner_to_sibling"		"BOTTOM_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	// S21: text lives on generic_button buttonText; keep Label as fallback only.
	"RefreshServersText"
	{
		"ControlName"			"Label"
		"labelText"				"#BRIDGE_SB_REFRESH_SERVERS"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"zpos" 					"12"
		"visible"				"0"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"RefreshServers"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"ClearFliters"
	{
		"ControlName"				"RuiButton"
		"style"						"RuiButton"
		"wide"						"200"
		"tall"						"35"
		"xpos"						"5"
		"ypos"						"0"
		"visible"					"1"
		"enabled"					"1"
		"zpos" 						"10"
        "rui"						"ui/generic_button.rpak"
		"cursorVelocityModifier"  	"0.7"

		ruiArgs
		{
			buttonText "#BRIDGE_SB_CLEAR_FILTERS"
		}

		"pin_to_sibling"			"RefreshServers"
		"pin_corner_to_sibling"		"BOTTOM_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_RIGHT"
	}

	// S21: text lives on generic_button buttonText; keep Label as fallback only.
	"ClearFlitersText"
	{
		"ControlName"			"Label"
		"labelText"				"#BRIDGE_SB_CLEAR_FILTERS"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"zpos" 					"12"
		"visible"				"0"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ClearFliters"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"ListSliderBG"
	{
		"ControlName"			"ImagePanel"
		wide 32
		tall 649
		xpos 2
		ypos 30
		zpos 0
        "fillColor"				"195 29 38 255"
		scaleImage				1
		"visible"				"0"

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	BtnServerListSlider
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		//labelText "V"
		wide 30
		tall 550
		xpos 2
		ypos 0
		zpos 0

		image "vgui/hud/white"
		drawColor "255 255 255 255"

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	BtnServerListSliderPanel
	{
		ControlName RuiPanel
		wide 30
		tall 550
		xpos 2
		ypos 0

		rui "ui/basic_image.rpak"

		visible 1
		zpos -1

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	// sh_menu_models.gnut has a global function which gets called when
	// left mouse button gets called while hovering and has mouse
	// deltaX; deltaY which we can yoink for ourselfes
	MouseMovementCapture
	{
		ControlName CMouseMovementCapturePanel
		wide 30
		tall 550
		xpos 2
		ypos 1
		zpos 100

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	BtnServerListUpArrow
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		//labelText "A"
		wide 30
		tall 45
		xpos 0
		ypos 0
		zpos 5

		image "vgui/hud/white"
		drawColor "255 255 255 128"

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_LEFT
	}

	BtnServerListUpArrowPanel
	{
		ControlName RuiPanel
		wide 30
		tall 45
		xpos 0
		ypos 0

		rui "ui/basic_image.rpak"

		visible 1
		zpos 4

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_LEFT
	}

	BtnServerListDownArrow
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		//labelText "A"
		wide 30
		tall 45
		xpos 0
		ypos 0
		zpos 5

		image "vgui/hud/white"
		drawColor "255 255 255 128"

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling BOTTOM_LEFT
		pin_to_sibling_corner BOTTOM_LEFT
	}

	BtnServerListDownArrowPanel
	{
		ControlName RuiPanel
		wide 30
		tall 45
		xpos 0
		ypos 0

		rui "ui/basic_image.rpak"

		visible 1
		zpos 4

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling BOTTOM_LEFT
		pin_to_sibling_corner BOTTOM_LEFT
	}

	"ServersCount"
	{
		"ControlName"			"Label"
		"labelText"				"#BRIDGE_SB_SERVERS_DASH"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"-25"
		"ypos"					"-10"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ServerBrowserBGBottom"
		"pin_corner_to_sibling"	"BOTTOM_RIGHT"
		"pin_to_sibling_corner"	"BOTTOM_RIGHT"
	}
	
	"PlayersCount"
	{
		"ControlName"			"Label"
		"labelText"				"#BRIDGE_SB_PLAYERS_DASH"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"7"
		"visible"				"1"
		"fontHeight"			"25"
		"xpos"					"30"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ServersCount"
		"pin_corner_to_sibling"	"RIGHT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"ServerNameLbl"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#BRIDGE_SB_SERVER_NAME"
		"xpos"					"-65"
		"ypos"					"0"
		"textalignment"			"center"
		"wide"					"150"
		"zpos" 					"4"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"PlayerCountLbl"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#BRIDGE_SB_PLAYERS"
		"xpos"					"-670"
		"ypos"					"0"
		"textalignment"			"center"
		"wide"					"110"
		"zpos" 					"4"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"PlaylistLbl"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#BRIDGE_SB_PLAYLIST"
		"xpos"					"-800"
		"ypos"					"0"
		"zpos"					"6"
		"textalignment"			"center"
		"wide"					"230"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"MapLbl"
	{
		"ControlName"			"Label"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"
		"labelText"				"#BRIDGE_SB_MAP"
		"xpos"					"-1050"
		"ypos"					"0"
		"zpos"					"6"
		"textalignment"			"center"
		"wide"					"330"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"ServerPasswordLine"
	{
		"mouseinputenabled"				"0"
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"ServerNameLine"
	{
		"mouseinputenabled"				"0"
		"ControlName"			"ImagePanel"
		"xpos"					"-50"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlayerCountLine"
	{
		"mouseinputenabled"				"0"
		"ControlName"			"ImagePanel"
		"xpos"					"-660"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistLine"
	{
		"mouseinputenabled"				"0"
		"ControlName"			"ImagePanel"
		"xpos"					"-790"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapLine"
	{
		"mouseinputenabled"				"0"
		"ControlName"			"ImagePanel"
		"xpos"					"-1040"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"RightLine"
	{
		"mouseinputenabled"				"0"
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"BOTTOM_RIGHT"
	}

	"ServerMapImg"
	{
		"ControlName"			"RuiPanel"
		"wide"					"450"
		"tall"            		"250"
		"visible"				"1"
		rui                     "ui/gamemode_select_button.rpak"
		"xpos"					"40"
		"zpos" 					"4"
		polyShape               "5.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0"

        ruiArgs
        {
            lockIconEnabled 0
            modeNameText ""
            modeDescText ""
            alwaysShowDesc 0
        }

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
		
	}

	"ServerInfoBG"
	{
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		ypos					15
        "tall"					"508"
		"wide" 					"450"
		visible					1
		scaleImage              1

        ruiArgs
        {
            basicImage "rui/menu/lobby/tabs_background"
        }

        "pin_to_sibling"		"ServerMapImg"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"ServerNameInfoEdit"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"420"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"-15"
		"textAlignment"			"center"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	"ServerCurrentMap"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"100"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-45"
		"textAlignment"			"left"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"ServerCurrentMapEdit"
	{
		"ControlName"			"Label"
		"textAlignment"			"east"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"270"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-45"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"ServerCurrentPlaylist"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"130"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-75"
		"textAlignment"			"left"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"PlaylistInfoEdit"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"270"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-75"
		"textAlignment"			"east"
		"fgcolor_override"		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"ServerDesc"
	{
		"ControlName"			"Label"
		"labelText"				""
		"wide"					"390"
		"tall"					"130"
		"wrap"					"1"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-115"
		"textAlignment"			"north-west"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"ConnectButton"
	{
		ControlName				RuiButton
		wide					450
        tall					112
        rui                     "ui/generic_ready_button.rpak"
		xpos 0
		ypos 15
		zpos 6

		ruiArgs
		{
			buttonText "#BRIDGE_SB_CONNECT"
		}


		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
		sound_focus             "UI_Menu_Focus_Large"
	}

	"ServerButton0"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"0"
		

		"pin_to_sibling"			"ServerBrowserBG"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton1"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"1"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton2"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"2"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton3"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"3"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton4"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"4"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton5"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"5"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton6"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"6"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton7"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"7"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton8"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"8"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton9"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"9"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton10"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"10"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton11"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"11"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton12"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"12"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton13"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"13"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton14"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/generic_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"14"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerLocked0"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked1"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked2"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked3"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked4"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked5"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked6"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked7"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked8"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked9"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked10"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked11"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked12"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked13"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerLocked14"
	{
		"mouseinputenabled"				"0"
		ControlName				RuiPanel
		rui                     "ui/basic_image.rpak"
		"classname"				"ServLocked"
		"xpos"					"-10"
		"ypos"					"0"
		"tall"					"30"
		"wide" 					"30"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"5"
		scaleImage              1

        ruiArgs
        {
            basicImage "rui\menu\store\reqs_locked"
        }

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName0"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName1"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName2"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName3"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName4"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName5"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName6"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName7"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName8"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName9"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName10"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName11"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName12"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName13"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName14"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-65"
		"ypos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist0"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textAlignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist1"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist2"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist3"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist4"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist5"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist6"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist7"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist8"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist9"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist10"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist11"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist12"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist13"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist14"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount0"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textAlignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount1"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount2"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount3"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount4"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount5"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount6"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount7"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount8"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount9"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount10"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount11"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount12"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount13"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount14"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map0"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map1"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map2"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map3"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map4"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map5"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map6"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map7"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map8"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map9"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map10"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map11"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map12"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map13"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map14"
	{
		"mouseinputenabled"				"0"
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"
		"fgcolor_override"		"255 255 255 255"
		"font"					"Default_27_Outline"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}
}

