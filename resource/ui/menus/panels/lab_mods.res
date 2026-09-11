"resource/ui/menus/panels/lab_mods.res"
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
			tall                    1400
			visible                 1
            tabPosition             1

            ServerModsHeader
            {
                ControlName				ImagePanel
                InheritProperties		SubheaderBackgroundWide
                className               "SettingScrollSizer"
                xpos					0
                ypos					6
            }
            ServerModsHeaderText
            {
                ControlName				Label
                InheritProperties		SubheaderText
                pin_to_sibling			ServerModsHeader
                pin_corner_to_sibling	LEFT
                pin_to_sibling_corner	LEFT
                use_pin_locale_direction    1
                labelText				"SERVER MODS"
            }

            SwitchMod0
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
                pin_to_sibling			ServerModsHeader
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod1
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
                pin_to_sibling			SwitchMod0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod2
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
                pin_to_sibling			SwitchMod1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod3
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
                pin_to_sibling			SwitchMod2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod4
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
                pin_to_sibling			SwitchMod3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod5
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
                pin_to_sibling			SwitchMod4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod6
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
                pin_to_sibling			SwitchMod5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod7
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
                pin_to_sibling			SwitchMod6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod8
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
                pin_to_sibling			SwitchMod7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod9
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
                pin_to_sibling			SwitchMod8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod10
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
                pin_to_sibling			SwitchMod9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            SwitchMod11
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
                pin_to_sibling			SwitchMod10
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        ChoiceButtonAlways
            }

            ButtonDisableAllMods
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			SwitchMod11
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

        }
    }
}
