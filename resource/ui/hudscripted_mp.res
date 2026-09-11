#base "HudWeapons.res"
#base "MPPrematch.res"
#base "HUDDev.res"
#base "HudDeathRecap.res"
#base "DebugOverlays.res"
#base "flowstate_customhudvgui.res"

Resource/UI/HudScripted_mp.res
{
	Screen
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
	}

	SafeArea
	{
		ControlName		ImagePanel
		wide			%90
		tall			%90
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	SafeAreaCenter
	{
		ControlName		ImagePanel
		wide			%90
		tall			%90
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	Scoreboard
	{
		ControlName			CNestedPanel
		xpos				0
		ypos				0
		wide				%100
		tall				%100
		visible				0

		zpos				4000

		controlSettingsFile	"resource/UI/HudScoreboard.res"
	}

	OutOfBoundsWarning_Anchor
	{
		ControlName				Label
		xpos					c-2
		ypos					c-45
		wide					4
		tall					4
		visible					0
		enabled					1
		labelText				""
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		font					Default_34_ShadowGlow
	}

	OutOfBoundsWarning_Message
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					674
		tall					45
		visible					0
		enabled					1
		auto_wide_tocontents	1
		labelText				"#OUT_OF_BOUNDS_WARNING"
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		bgcolor_override 		"0 0 0 200"
		font					Default_34_ShadowGlow

		pin_to_sibling			OutOfBoundsWarning_Anchor
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	OutOfBoundsWarning_Timer
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					674
		tall					45
		visible					0
		enabled					1
		auto_wide_tocontents	1
		labelText				":00"
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		bgcolor_override 		"0 0 0 200"
		font					Default_34_ShadowGlow

		pin_to_sibling			OutOfBoundsWarning_Message
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	Dev_Info1
	{
		ControlName				Label
		xpos					-5
		ypos					-44
		auto_wide_tocontents 	1
		visible					0
		font 					Default_34_ShadowGlow
		labelText				"[Dev Info1]"
		textAlignment			left
		fgcolor_override 		"255 255 255 255"

		zpos 1000

		pin_to_sibling				Screen
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	Dev_Info2
    {
        ControlName				Label
        //xpos					80
        ypos					-4
        auto_wide_tocontents 	1
        visible					0
        font 					Default_34_ShadowGlow
        labelText				"[Dev Info2]"
        textAlignment			left
        fgcolor_override 		"255 255 255 255"

        zpos 1000

        pin_to_sibling				Dev_Info1
        pin_corner_to_sibling		TOP_LEFT
        pin_to_sibling_corner		BOTTOM_LEFT
    }

    Dev_Info3
    {
        ControlName				Label
        //xpos					80
        ypos					-4
        auto_wide_tocontents 	1
        visible					0
        font 					Default_34_ShadowGlow
        labelText				"Test Map"
        textAlignment			left
        fgcolor_override 		"255 255 255 255"

        zpos 1000

        pin_to_sibling				Dev_Info2
        pin_corner_to_sibling		TOP_LEFT
        pin_to_sibling_corner		BOTTOM_LEFT
    }

	ShoutOutAnchor
	{
		ControlName		ImagePanel
		xpos			c-0
		ypos			c-405
		wide			0
		tall			0
		visible			1
		scaleImage		1

		zpos			5
	}

	EventNotification
	{
		ControlName				Label
		xpos					0
		ypos					150
		wide					899
		tall					67
		visible					0
		font					Default_27_ShadowGlow
		labelText				"Something is going on!"
		textAlignment			center
		auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		allCaps					1

		zpos			1000

		pin_to_sibling				ShoutOutAnchor
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	IngameTextChat
	{
		ControlName				CBaseHudChat
		InheritProperties		ChatBox

		destination				"match"

		visible 				0

		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-48 [$PC]
		xpos					%-5 [!$PC]
		ypos					-512
		zpos                    9999
	}

    AccessibilityHint
    {
        ControlName             RuiPanel
        classname               "MenuButton"
        ypos                    12
        xpos                    -10
        wide                    500
        tall                    40
        visible                 0

        rui                     "ui/accessibility_hint.rpak"

        ruiArgs
        {
            buttonText          "#INGAME_ACCESSIBILITY_CHAT_HINT" [!$PC]
            buttonText          "#INGAME_ACCESSIBILITY_CHAT_HINT_PC" [$PC] // controller chat option only on console
            buttonTextPC        "#INGAME_ACCESSIBILITY_CHAT_HINT_PC"
        }

        pin_to_sibling			IngameTextChat
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	HudCheaterMessage
	{
		ControlName			Label
		font				Default_34_ShadowGlow
		labelText			"#FAIRFIGHT_CHEATER"
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		zpos				10
		wide				450
		tall				58
		textAlignment		center

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	EMPScreenFX
	{
		ControlName		ImagePanel
		xpos 			0
		ypos 			0
		zpos			-1000
		wide			%100
		tall			%100
		visible			0
		scaleImage		1
		image			vgui/HUD/pilot_flashbang_overlay
		drawColor		"255 255 255 64"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

    NotificationBox
    {
        ControlName		RuiPanel
        wide			680
        tall			140
        visible			0
        enabled         0
        rui                     "ui/notification_box.rpak"

		pin_to_sibling				Screen
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
    }
// --- Flowstate 1v1 / FSDM HUD (bridge) ---
// Names must match cl_gamemode_1v1.nut HUD_* constants.
FS_DMCountDown_Frame
{
	ControlName				RuiPanel
	pin_to_sibling			SafeArea
	pin_corner_to_sibling	TOP
	pin_to_sibling_corner	TOP
	xpos					0
	ypos					48
	zpos					500
	wide					286
	tall					54
	visible					0
	scaleImage				1
	rui						"ui/basic_image.rpak"
}

FS_DMCountDown_Text
{
	ControlName				Label
	pin_to_sibling			FS_DMCountDown_Frame
	pin_corner_to_sibling	CENTER
	pin_to_sibling_corner	CENTER
	xpos					0
	ypos					0
	zpos					501
	wide					300
	tall					30
	visible					0
	enabled					1
	labelText				""
	textAlignment			center
	font					Default_34_ShadowGlow
	fgcolor_override		"255 255 255 255"
}

FS_1v1Banner
{
	ControlName				RuiPanel
	pin_to_sibling			SafeArea
	pin_corner_to_sibling	CENTER
	pin_to_sibling_corner	CENTER
	xpos					0
	ypos					-80
	zpos					520
	wide					400
	tall					120
	visible					0
	scaleImage				1
	rui						"ui/basic_image.rpak"
}

FS_ModeLogo
{
	ControlName				RuiPanel
	wide					64
	tall					64
	xpos					0
	ypos					4
	zpos					6
	visible					0
	rui						"ui/basic_image.rpak"
	pin_to_sibling			SafeArea
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

FS_ModeName
{
	ControlName				Label
	xpos					10
	ypos					0
	zpos					7
	wide					280
	tall					64
	visible					0
	fontHeight				22
	labelText				""
	font					"TitleBoldFont"
	allcaps					0
	fgcolor_override		"255 255 255 255"
	textAlignment			west
	pin_to_sibling			FS_ModeLogo
	pin_corner_to_sibling	LEFT
	pin_to_sibling_corner	RIGHT
}

// --- Flowstate Aim Trainer challenge timer (original CafeFPS VGUI) ---
// Mirrors flowstate_customhudvgui.res Countdown + CountdownFrame.
// Client: cl_gamemode_aimtrainer_freeroam.gnut Hud_SetText/Visible.
CountdownFrame
{
	ControlName				RuiPanel
	wide					80
	tall					60
	zpos					500
	visible					0
	rui						"ui/basic_image.rpak"
	ruiArgs
	{
		basicImageColor		"0 0 0"
		basicImageAlpha		0.7
	}
	pin_to_sibling			SafeArea
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

Countdown
{
	ControlName				Label
	xpos					0
	ypos					0
	zpos					501
	auto_wide_tocontents	1
	tall					50
	visible					0
	enabled					1
	fontHeight				53
	labelText				"60"
	font					"TitleBoldFont"
	allcaps					1
	fgcolor_override		"255 255 255 255"
	textAlignment			center
	pin_to_sibling			CountdownFrame
	pin_corner_to_sibling	CENTER
	pin_to_sibling_corner	CENTER
}


// --- Map editor bind panel ---
// Client: mapeditor/cl_mapeditor.nut Hud_SetText/Visible while build mode is on.
MapEditFrame
{
	ControlName				RuiPanel
	xpos					0
	ypos					90
	zpos					500
	wide					320
	tall					406
	visible					0
	rui						"ui/basic_image.rpak"
	ruiArgs
	{
		basicImageColor		"0 0 0"
		basicImageAlpha		0.62
	}
	pin_to_sibling			SafeArea
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditTitle
{
	ControlName				Label
	xpos					14
	ypos					8
	zpos					501
	tall					30
	wide					300
	visible					0
	enabled					1
	fontHeight				26
	labelText				"MAP EDITOR"
	font					"TitleBoldFont"
	allcaps					1
	fgcolor_override		"255 79 161 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditStatus
{
	ControlName				Label
	xpos					14
	ypos					38
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				20
	labelText				""
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"150 220 255 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint0
{
	ControlName				Label
	xpos					14
	ypos					68
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Fire  Place prop"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint1
{
	ControlName				Label
	xpos					14
	ypos					95
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Reload  Delete looked-at prop"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint2
{
	ControlName				Label
	xpos					14
	ypos					122
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Switch fire mode  Undo"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint3
{
	ControlName				Label
	xpos					14
	ypos					149
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Switch weapons  Redo"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint4
{
	ControlName				Label
	xpos					14
	ypos					176
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Equip weapon 1 / 2  Raise / lower"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint5
{
	ControlName				Label
	xpos					14
	ypos					203
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Alt interact  Cycle grid snap"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint6
{
	ControlName				Label
	xpos					14
	ypos					230
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"F7  Toggle noclip"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint7
{
	ControlName				Label
	xpos					14
	ypos					257
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Gib shield toggle  Zipline anchor"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint8
{
	ControlName				Label
	xpos					14
	ypos					284
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"Inspect weapon  Model browser"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint9
{
	ControlName				Label
	xpos					14
	ypos					311
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"F6  Toggle build mode"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint10
{
	ControlName				Label
	xpos					14
	ypos					338
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"[  /  ]  Rotate yaw"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}

MapEditHint11
{
	ControlName				Label
	xpos					14
	ypos					365
	zpos					501
	tall					26
	wide					300
	visible					0
	enabled					1
	fontHeight				21
	labelText				"F8  Who placed this"
	font					"Default_34_ShadowGlow"
	allcaps					0
	fgcolor_override		"235 235 235 255"
	textAlignment			left
	pin_to_sibling			MapEditFrame
	pin_corner_to_sibling	TOP_LEFT
	pin_to_sibling_corner	TOP_LEFT
}


}
