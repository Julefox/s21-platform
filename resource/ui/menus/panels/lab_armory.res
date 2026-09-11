"resource/ui/menus/panels/lab_armory.res"
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
			tall                    1600
			visible                 1
            tabPosition             1

            SwitchCategory
            {
                ControlName				RuiButton
                InheritProperties		SwitchButton
                className               "SettingScrollSizer"
                style					DialogListButton
                list
                {
                    "..."	0
                }
                childGroupAlways        MultiChoiceButtonAlways
            }

            SwitchKit
            {
                ControlName				RuiButton
                InheritProperties		SwitchButton
                className               "SettingScrollSizer"
                style					DialogListButton
                list
                {
                    "..."	0
                }
                pin_to_sibling			SwitchCategory
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        MultiChoiceButtonAlways
            }

            SwitchDeliver
            {
                ControlName				RuiButton
                InheritProperties		SwitchButton
                className               "SettingScrollSizer"
                style					DialogListButton
                list
                {
                    "..."	0
                }
                pin_to_sibling			SwitchKit
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                childGroupAlways        MultiChoiceButtonAlways
            }

            ButtonRefillAmmo
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			SwitchDeliver
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            ButtonStripWeapons
            {
                ControlName				RuiButton
                InheritProperties		SettingBasicButton
                className               "SettingScrollSizer"
                pin_to_sibling			ButtonRefillAmmo
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }

            GridHeader
            {
                ControlName				ImagePanel
                InheritProperties		SubheaderBackgroundWide
                className               "SettingScrollSizer"
                xpos					0
                ypos					6
                pin_to_sibling			ButtonStripWeapons
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
            }
            GridHeaderText
            {
                ControlName				Label
                InheritProperties		SubheaderText
                pin_to_sibling			GridHeader
                pin_corner_to_sibling	LEFT
                pin_to_sibling_corner	LEFT
                use_pin_locale_direction    1
                labelText				"ITEMS"
            }

            Tile0_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			GridHeader
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile0_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile0_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile0_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile1_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile1_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile1_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile2_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile2_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile2_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile3_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile3_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile3_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile4_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile4_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile4_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile5_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile5_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile5_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile6_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile6_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile6_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile7_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile7_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile7_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile8_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile8_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_0
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile8_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	BOTTOM_LEFT
                ypos                    8
                className               "SettingScrollSizer"
            }

            Tile9_1
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_0
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_2
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_1
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_3
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_2
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_4
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_3
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_5
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_4
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_6
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_5
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_7
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_6
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_8
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_7
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_9
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_8
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }

            Tile9_10
            {
                ControlName				RuiButton
                InheritProperties		SurvivalInventoryGridButton
                wide                    84
                tall                    89
                visible                 0
                scaleImage              1
                tabPosition             1
                drawColor               "255 255 255 255"
                zpos                    1
                pin_to_sibling			Tile9_9
                pin_corner_to_sibling	TOP_LEFT
                pin_to_sibling_corner	TOP_RIGHT
                xpos                    8
            }


        }
    }
}
