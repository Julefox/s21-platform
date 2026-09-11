"resource/ui/menus/panels/lab_match.res"
{
	ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        visible					1
        enabled 				1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 0"
    }


	ModeOptionsPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel
        tall                    830

		visible                 1
        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
            tall                    830
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
			tall                    1500
			visible                 1
            tabPosition             1

            RingHeader
            {
                ControlName				ImagePanel
                InheritProperties		SubheaderBackgroundWide
                className               "SettingScrollSizer"
                xpos					0
                ypos					6
            }
            RingHeaderText
            {
                ControlName				Label
                InheritProperties		SubheaderText
                pin_to_sibling			RingHeader
                pin_corner_to_sibling	LEFT
                pin_to_sibling_corner	LEFT
                use_pin_locale_direction    1
                labelText				"RING"
            }

            ButtonRingStart
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			RingHeader
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonRingPause
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRingStart
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonRingHere
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRingPause
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            MatchHeader
            {
                ControlName				ImagePanel
                InheritProperties		SubheaderBackgroundWide
                className               "SettingScrollSizer"
                xpos					0
                ypos					6
                pin_to_sibling			ButtonRingHere
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }
            MatchHeaderText
            {
                ControlName				Label
                InheritProperties		SubheaderText
                pin_to_sibling			MatchHeader
                pin_corner_to_sibling	LEFT
                pin_to_sibling_corner	LEFT
                use_pin_locale_direction    1
                labelText				"MATCH"
            }

            SwitchMapTriggers
            {
                ControlName				RuiButton
                InheritProperties		SwitchButton
                className               "SettingScrollSizer"
                style					DialogListButton
                list
                {
                    "#SETTING_OFF"	0
                    "#SETTING_ON"	1
                }
                pin_to_sibling			MatchHeader
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchDevAlerts
            {
                ControlName				RuiButton
                InheritProperties		SwitchButton
                className               "SettingScrollSizer"
                style					DialogListButton
                list
                {
                    "#SETTING_OFF"	0
                    "#SETTING_ON"	1
                }
                pin_to_sibling			SwitchMapTriggers
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            ButtonSkydive
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			SwitchDevAlerts
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonSummon
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonSkydive
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            CarePackageHeader
            {
                ControlName				ImagePanel
                InheritProperties		SubheaderBackgroundWide
                className               "SettingScrollSizer"
                xpos					0
                ypos					6
                pin_to_sibling			ButtonSummon
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }
            CarePackageHeaderText
            {
                ControlName				Label
                InheritProperties		SubheaderText
                pin_to_sibling			CarePackageHeader
                pin_corner_to_sibling	LEFT
                pin_to_sibling_corner	LEFT
                use_pin_locale_direction    1
                labelText				"CARE PACKAGE"
            }

            ButtonCareR1
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			CarePackageHeader
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonCareR2
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonCareR1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonCareR3
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonCareR2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            RespawnHeader
            {
                ControlName				ImagePanel
                InheritProperties		SubheaderBackgroundWide
                className               "SettingScrollSizer"
                xpos					0
                ypos					6
                pin_to_sibling			ButtonCareR3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }
            RespawnHeaderText
            {
                ControlName				Label
                InheritProperties		SubheaderText
                pin_to_sibling			RespawnHeader
                pin_corner_to_sibling	LEFT
                pin_to_sibling_corner	LEFT
                use_pin_locale_direction    1
                labelText				"RESPAWN"
            }

            ButtonRespawnAllDead
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			RespawnHeader
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonRespawnAll
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRespawnAllDead
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonRespawnBots
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRespawnAll
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonRespawnAllies
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRespawnBots
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonRespawnEnemies
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRespawnAllies
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

        }
    }
}
