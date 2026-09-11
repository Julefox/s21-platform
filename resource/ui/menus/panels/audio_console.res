"resource/ui/menus/panels/audio_console.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    SldMasterVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        tabPosition             1
        navDown                 SwchSpatialAudio
        conCommand              "sound_volume"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3
        ypos                    0
        xpos                    0
    }

    SwchSpatialAudio
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        className               "SettingScrollSizer"
        style                   DialogListButton
        ConVar                  "miles_spatial"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        navUp                   SldMasterVolume
        navDown                 SwchAudioLanguage
        pin_to_sibling          SldMasterVolume

        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
        
        ypos                    6

        enabled                 0
        visible                 0
    }

    SwchAudioLanguage
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        className               "SettingScrollSizer"
        style                   DialogListButton
        navUp                   SwchSpatialAudio
        navDown                 SldOpenMicSensitivity
        ConVar                  "miles_language"
        list
        {
            "#SETTING_DEFAULT"          ""
            "#GAMEUI_LANGUAGE_ENGLISH"  "english"
        }

        pin_to_sibling          SwchSpatialAudio
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        visible                 0 //[$ENGLISH || $PORTUGUESE || $TCHINESE]
        //visible                 1 [!$ENGLISH && !$PORTUGUESE && !$TCHINESE]

        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]
        childGroupAlways        ChoiceButtonAlways
    }

    VoiceChatHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        className               "SettingScrollSizer"
        xpos					0
        ypos					6
        pin_to_sibling			SwchSpatialAudio //[$ENGLISH || $PORTUGUESE || $TCHINESE]
        //pin_to_sibling			SwchAudioLanguage [!$ENGLISH && !$PORTUGUESE && !$TCHINESE]
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        use_pin_locale_direction    1
    }
    VoiceChatHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			VoiceChatHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        use_pin_locale_direction    1
        labelText				"#MENU_VOICE_CHAT"
    }
    SldOpenMicSensitivity
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        navUp                   SwchAudioLanguage
        navDown                 SldSFXVolume
        conCommand              "speex_quiet_threshold"
        minValue                0
        maxValue                32767
        stepSize                50
        inverseFill             0
        showLabel               1
		tall_nx_handheld		80 [$NX]
		
        pin_to_sibling          VoiceChatHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        PrgValue
        {
            ControlName				RuiPanel
            fieldName				PrgValue
            xpos                    50
            zpos					5
            wide					280
            tall					60
            tall_nx_handheld		80 [$NX]
            visible					1
            enabled					1
            tabPosition				0
            rui                     "ui/settings_voice_slider.rpak"
        }
    }

    AdvancedHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        className               "SettingScrollSizer"
        xpos					0
        ypos					6
        pin_to_sibling			SldOpenMicSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        use_pin_locale_direction    1
    }
    AdvancedHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			AdvancedHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        use_pin_locale_direction    1
        labelText				"#MENU_ADVANCED"
    }

    SldSFXVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        navUp                   SldOpenMicSensitivity
        navDown                 SldDialogueVolume
        conCommand              "sound_volume_sfx"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          AdvancedHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]
    }
    SldDialogueVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        navUp                   SldSFXVolume
        navDown                 SldMusicVolume
        conCommand              "sound_volume_dialogue"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          SldSFXVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]
    }
    SldMusicVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        navUp                   SldDialogueVolume
        navDown                 SldLobbyMusicVolume
        conCommand              "sound_volume_music_game"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          SldDialogueVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]
    }
    SldLobbyMusicVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        navUp                   SldMusicVolume
        navDown                 SldSFXObserverVolume
        conCommand              "sound_volume_music_lobby"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3


        pin_to_sibling          SldMusicVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]
    }
    SldSFXObserverVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        className               "SettingScrollSizer"
        navUp                   SldLobbyMusicVolume
        navDown                 SwchSoundStandingEmotes
        conCommand              "sound_volume_sfx_observer"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          SldLobbyMusicVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]
    }
	SwchSoundStandingEmotes
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        className               "SettingScrollSizer"
        style                   DialogListButton
        navUp                   SldSFXObserverVolume
        navDown                 SwchVipTelemetry
        ConVar                  "cl_anim_always_play_nonlobby_sfx"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        pin_to_sibling          SldSFXObserverVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways

        ypos                    6
        ypos_nx_handheld        2
    }
    SwchVipTelemetry
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        className               "SettingScrollSizer"
        style                   DialogListButton
        navUp                   SwchSoundStandingEmotes
        ConVar                  "xlog_tls_allow_vip_upload"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        pin_to_sibling          SwchSoundStandingEmotes
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
        
        ypos                    6
        ypos_nx_handheld        2			[$NX || $NX_UI_PC]

        enabled                 0
        visible                 0
    }
} 