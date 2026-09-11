"resource/ui/menus/panels/ads_controls_gamepad_motion.res"
{
	///////////////////////////////////////
    // ADS Motion Sensitivity Per Scope Enabled
    ///////////////////////////////////////
    SwchCustomMotionADSEnabled
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        className               "SettingScrollSizer"

        xpos					0
        ypos					0
        navDown					SldMotionSensitivityADS0		
        navUp                   ""
        ConVar					"motion_use_per_scope_sensitivity_scalars"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }
	///////////////////////////////
    // ADS Sensitivity Per Scope
    ///////////////////////////////
	SldMotionSensitivityADS0
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SwchCustomMotionADSEnabled
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchCustomMotionADSEnabled
        navDown					SldMotionSensitivityADS1
        conCommand				"motion_ads_advanced_sensitivity_scalar_0"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS0
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_0"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS0
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS1
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS0
        navDown					SldMotionSensitivityADS2
        conCommand				"motion_ads_advanced_sensitivity_scalar_1"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS1
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_1"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS1
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS2
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS1
        navDown					SldMotionSensitivityADS3
        conCommand				"motion_ads_advanced_sensitivity_scalar_2"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS2
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_2"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS2
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS3
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS2
        navDown					SldMotionSensitivityADS4
        conCommand				"motion_ads_advanced_sensitivity_scalar_3"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS3
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_3"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS3
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS4
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS3
        navDown					SldMotionSensitivityADS5
        conCommand				"motion_ads_advanced_sensitivity_scalar_4"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS4
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_4"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS4
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS5
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS4
        navDown					SldMotionSensitivityADS6
        conCommand				"motion_ads_advanced_sensitivity_scalar_5"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS5
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_5"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS5
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS6
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS5
        navDown					SldMotionSensitivityADS7
        conCommand				"motion_ads_advanced_sensitivity_scalar_6"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS6
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_6"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS6
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMotionSensitivityADS7
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        className               "SettingScrollSizer"
        pin_to_sibling			SldMotionSensitivityADS6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					4
        navUp					SldMotionSensitivityADS6
        navDown					""
        conCommand				"motion_ads_advanced_sensitivity_scalar_7"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryMotionSensitivityADS7
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "motion_ads_advanced_sensitivity_scalar_7"
        showConVarAsFloat		1

        pin_to_sibling			SldMotionSensitivityADS7
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
} 