"resource/ui/menus/panels/quest.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 0"
        paintbackground         1
    }

	CenterFrame
	{
		ControlName				RuiPanel
        xpos					0
        ypos					0
        wide					1920
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        rui					    "ui/basic_image.rpak"
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	QuestInfoBox
	{
	    ControlName				RuiPanel

	    pin_to_sibling			CenterFrame
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_LEFT
	    xpos					-241
	    ypos					18
	    wide					1460
	    tall					770
	    visible					1
	    rui					    "ui/quest_info_box.rpak"
	}

    //////////////////////////////////////
    // REWARD BUTTONS + PURCHASE BUTTON //
    //////////////////////////////////////

    RewardsPanel
    {
        ControlName				CNestedPanel
        pin_to_sibling		    QuestInfoBox
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
        xpos					0
        ypos					0
        wide					1460   // Match size to QuestInfoBox
        tall					770 //clip the bottom of items
        visible					1
        clip                    1
        controlSettingsFile		"resource/ui/menus/panels/quest_rewards.res"
    }
    /////////////////////
    //  INTRO BUTTON   //
    /////////////////////

    IntroButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"
        labelText               ""
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					-371
        ypos					-200
        wide				    464
        tall				    100
        visible                 0
        scriptID                0
        rui					    "ui/battle_pass_purchase_button.rpak"
        sound_focus             "UI_Menu_Focus_Large"
        cursorVelocityModifier  0.7
        proportionalToParent	1

        navUp AboutButton
    }

    CinematicButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"
        labelText               ""
        xpos				    -50
        ypos				    -332
        wide				    265
        tall				    62
        visible                 1
        rui					    "ui/quest_buy_box_button.rpak"
        sound_focus             "UI_Menu_Focus_Large"
        cursorVelocityModifier  0.7
        proportionalToParent	1
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        use_pin_locale_direction 1

        navUp                   RewardButton20
        navLeft                 CompletionRewardButton3

        ruiArgs
        {
            buttonText "#VIEW_CINEMATIC"
        }
    }
    DeepLinkButton
	{
	    ControlName			    RuiButton
	    classname               "MenuButton"
	    labelText               ""
	    xpos				    15
	    ypos				    0
	    wide				    265
	    tall				    62
	    visible                 1
	    rui					    "ui/quest_buy_box_button.rpak"
	    sound_focus             "UI_Menu_Focus_Large"
	    cursorVelocityModifier  0.7
	    proportionalToParent	1
	    pin_to_sibling			CinematicButton
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_RIGHT

	    navUp                   RewardButton20
	    navLeft                 CompletionRewardButton3
	}

	/////////////////////
    // MISSION BUTTONS //
    /////////////////////

    MissionButton0
    {
        ControlName				RuiButton
		classname				MissionSelect
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        use_pin_locale_direction 1
        xpos					-990
        ypos					-79
        wide					130
        tall					130
        visible					1
        enabled					1
        navRight                MissionButton1
        navDown                 MissionButton3
        rui                     "ui/mission_button.rpak"
    }

    MissionButton1
    {
        ControlName				RuiButton
		classname				MissionSelect
        pin_to_sibling			MissionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        use_pin_locale_direction 1
        xpos					14
        ypos					0
        wide					130
        tall					130
        visible					1
        enabled					1
        navLeft                 MissionButton0
        navRight                MissionButton2
        navDown                 MissionButton3
        rui                     "ui/mission_button.rpak"
    }

    MissionButton2
    {
        ControlName				RuiButton
		classname				MissionSelect
        pin_to_sibling			MissionButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        use_pin_locale_direction 1
        xpos					14
        ypos					0
        wide					130
        tall					130
        visible					1
        enabled					1
        navLeft                 MissionButton1
        navDown                 MissionButton3
        rui                     "ui/mission_button.rpak"
    }

    MissionButton3
    {
        ControlName				RuiButton
		classname				MissionSelect
        pin_to_sibling			MissionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        use_pin_locale_direction 1
        xpos					0
        ypos					14
        wide					130
        tall					130
        visible					1
        enabled					1
        navRight                MissionButton4
        navDown                 RewardButton0
        rui                     "ui/mission_button.rpak"
    }

    MissionButton4
    {
        ControlName				RuiButton
		classname				MissionSelect
        pin_to_sibling			MissionButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        use_pin_locale_direction 1
        xpos					14
        ypos					0
        wide					130
        tall					130
        visible					1
        enabled					1
        navLeft                 MissionButton3
        navRight                MissionButton5
        navDown                 RewardButton0
        rui                     "ui/mission_button.rpak"
    }

    MissionButton5
    {
        ControlName				RuiButton
		classname				MissionSelect
        pin_to_sibling			MissionButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        use_pin_locale_direction 1
        xpos					14
        ypos					0
        wide					130
        tall					130
        visible					1
        enabled					1
        navLeft                 MissionButton4
        navDown                 RewardButton0
        rui                     "ui/mission_button.rpak"
    }

    ///////////////////
    // COMICS LOCKED //
    ///////////////////

                          
    LockedComicsPanel
    {
        ControlName				RuiPanel

        pin_to_sibling			MissionButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					0
        ypos					-41
        wide					500
        tall					40
        visible					0
        rui				        "ui/quest_locked_comics_panel.rpak"
    }
      

    ////////////////////////////////
    // FINAL MISSION REWARDS SMALL//
    ////////////////////////////////

    CompletionRewardButton1
    {
        ControlName				RuiButton
		classname				CompletionReward
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
        xpos					-197    [!$RTL]
        xpos					-377    [$RTL]
        ypos					-76
        wide					55
        tall					55
        visible					1
        enabled					1
        navRight                CompletionRewardButton2
        navUp                   RewardButton14
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }

    CompletionRewardButton2
    {
        ControlName				RuiButton
		classname				CompletionReward
        pin_to_sibling			CompletionRewardButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        use_pin_locale_direction    1
        xpos					5
        ypos					0
        wide					55
        tall					55
        visible					1
        enabled					1
        navLeft                 CompletionRewardButton1
        navRight                CompletionRewardButton3
        navUp                   RewardButton14
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }

    CompletionRewardButton3
    {
        ControlName				RuiButton
		classname				CompletionReward
        pin_to_sibling			CompletionRewardButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        use_pin_locale_direction    1
        xpos					5
        ypos					0
        wide					55
        tall					55
        visible					0
        enabled					1
        navLeft                 CompletionRewardButton2
        navRight                PurchaseButton
        navUp                   RewardButton14
        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    //////////////////////////////
    // FINAL MISSION REWARDS BIG//
    //////////////////////////////
	CompletionRewardBigButton1
    {
        ControlName				RuiButton
        classname				CompletionReward
        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos					-581
        ypos					-589
        wide					120
        tall					120
        visible					1
        enabled					1

        navRight                CompletionRewardBigButton2

        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    CompletionRewardBigButton2
    {
        ControlName				RuiButton
        classname				CompletionReward
        pin_to_sibling			CompletionRewardBigButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					50
        ypos					0
        wide					120
        tall					120
        visible					1
        enabled					1

        navLeft                 CompletionRewardBigButton1
        navRight                CompletionRewardBigButton3

        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
    CompletionRewardBigButton3
    {
        ControlName				RuiButton
        classname				CompletionReward
        pin_to_sibling			CompletionRewardBigButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos					50
        ypos					0
        wide					120
        tall					120
        visible					1
        enabled					1

	    navLeft                 CompletionRewardBigButton2

        rui                     "ui/quest_reward_button.rpak"
        sound_focus             "UI_Menu_Focus_Small"
    }
	///////////////////////
	//  PURCHASE BUTTON  //
	///////////////////////
	PurchaseButton
	{
		ControlName			    RuiButton
		classname               "MenuButton"
		labelText               ""
		xpos				    -330
		ypos				    -20
		wide				    266
		tall				    67
		visible                 1
		scriptID                0
		rui					    "ui/quest_buy_box_button.rpak" // store_inspect_purchase_button
		sound_focus             "UI_Menu_Focus_Large"
		cursorVelocityModifier  0.7
		proportionalToParent	1
		pin_to_sibling			QuestInfoBox
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT

		navUp                   RewardButton20
		navLeft                 CompletionRewardButton3
	}
     ///////////////////
    // MODEL PREVIEW //
    ///////////////////

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    0
        ypos					0
        zpos                    0
        wide                    780
        tall                    630

        pin_to_sibling			QuestInfoBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT

    }


    ///////////////////
    //  DEBUG STUFF  //
    ///////////////////

   	debugText0
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow

        xpos					1000
        ypos					150
        zpos					30
	}
	debugText1
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow
        zpos					30
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        pin_to_sibling			debugText0
	}
	debugText2
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow
        zpos					30
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        pin_to_sibling			debugText1
	}
	debugText3
	{
		ControlName				Label
		auto_wide_tocontents	1
		tall					17
		visible					1
		labelText				""
		font					Default_19_DropShadow
        zpos					30
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        pin_to_sibling			debugText2
	}
}
 