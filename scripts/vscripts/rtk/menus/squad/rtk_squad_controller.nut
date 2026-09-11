#if CLIENT











global function UICallback_RTKPopulateSquadGladCards
global function UICallback_RTKToggleMutePings
global function UICallback_RTKBlockSquadMate


global struct RTKSquadGladCards_Properties
{
	rtk_panel gladCardList
}


global struct RTKSquadGladCardModel
{
	string uid
	string unspoofedUid
	string eaid
	string hardware
	int    team
	string id = ""
	string name = ""

	bool canMute = false
	bool isMuted = false
	bool canViewProfile = false

	bool canMutePing = false
	bool isPingMuted = false

	bool canReport = false
	bool canBlock = false
	bool canInvite = false
	bool canSendFriendRequest = false
	bool isConnected = true
	bool isLocalPlayer = true

	string actionText = ""

	bool isFriendly = false
}






































































































































































































































































void function UICallback_RTKBlockSquadMate( string path, int index )
{
	rtk_struct model = RTKDataModel_GetStruct( path )
	rtk_array squadGladCardsModel = RTKStruct_GetArray( model, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )

		array< PlayerInfo > teammates = Cl_Squad_GetTeammates()
		PlayerInfo playerData
		foreach ( data in teammates )
		{
			if( data.uid == uid && data.eaid == eaid )
			{
				playerData = data
				break
			}
		}

		printt( "#EADP UICallback_BlockSquadMate", playerData.ehi, playerData.hardware, playerData.uid, playerData.eaid )
		RunUIScript( "ClientToUI_ShowBlockPlayerDialog", GetDisplayablePlayerNameFromEHI( playerData.ehi ), playerData.hardware, playerData.uid, playerData.eaid )
	}
}




































































void function UICallback_RTKToggleMutePings( string path, int index )
{
	rtk_struct model = RTKDataModel_GetStruct( path )
	rtk_array squadGladCardsModel = RTKStruct_GetArray( model, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )

		array< PlayerInfo > teammates = Cl_Squad_GetTeammates()
		entity player
		foreach ( data in teammates )
		{
			if( data.uid == uid && data.eaid == eaid )
			{
				player = data.player
				break
			}
		}

		if( IsValid( player ) )
		{
			TogglePlayerWaypointMute( player )

			RTKStruct_SetBool( quadGladCardModel, "isPingMuted", PlayerIsPingMuted( player ) )
		}
	}
}













































void function UICallback_RTKPopulateSquadGladCards( string path )
{
	entity localPlayer = GetLocalClientPlayer()
	EHI localPlayerEHI = ToEHI( localPlayer )

	rtk_struct model = RTKDataModel_GetStruct( path )
	rtk_array squadGladCardModel = RTKStruct_GetOrCreateScriptArrayOfStructs( model, "gladcards", "RTKSquadGladCardModel" )
	array< PlayerInfo > teammates = Cl_Squad_GetTeammates( true )
	teammates = teammates.slice( 0, int( min( GetMaxTeamSizeForPlaylist( GetCurrentPlaylistName() ), teammates.len() ) ) )

	array<RTKSquadGladCardModel> dataModel

	foreach ( data in teammates )
	{
		entity dataPlayer = FromEHI( data.ehi )
		bool isLocalPlayer = data.ehi == localPlayerEHI
		bool isPlayerBot = false
		RTKSquadGladCardModel gladCard

		bool canReport = false
		if ( IsValid( dataPlayer ) )
		{
#if AUTO_PLAYER
				isPlayerBot 		  = AutoPlayer_IsAutoPlayer( dataPlayer ) || dataPlayer.IsBot()
#else
				isPlayerBot 		  = dataPlayer.IsBot()
#endif

			isPlayerBot 		  = dataPlayer.IsBot()
			gladCard.isMuted      = dataPlayer.IsVoiceAndTextMuted()
			gladCard.isPingMuted  = PlayerIsPingMuted( dataPlayer )
			gladCard.unspoofedUid = dataPlayer.GetUnspoofedPlatformUserIdStr()
			canReport = CanReportPlayer( dataPlayer )
		}
		else
		{
			int reportStyle = GetReportStyle()

			switch ( reportStyle )
			{
				case 1: 
					canReport = CrossplayUserOptIn() ? true : data.hardware == GetLocalClientPlayer().GetUnspoofedHardware()
				break

				case 2: 
					canReport = true
				break

				case 0: 
				default:
					canReport = false
			}
		}

		if( !isLocalPlayer && !isPlayerBot )
		{
			EHIScriptStruct teammateEHISS
			if ( EEHHasValidScriptStruct( data.ehi ) )
				teammateEHISS = GetEHIScriptStruct( data.ehi )

			if ( GetCurrentPlaylistVarBool( "showPlayerObfuscatedID", true ) && teammateEHISS.obfuscatedID != "" )
			{
				gladCard.id = Localize( "#DEATH_SCREEN_ID", teammateEHISS.obfuscatedID )
			}

			bool canAddFriend = CanSendFriendRequest( GetLocalClientPlayer() ) && !EADP_IsFriendByEAID( data.eaid )
			bool canInviteParty = CanInviteSquadMate( data.uid ) && CanInviteToparty() == 0

			if ( canAddFriend )
			{
				
				CommunityFriends friends = GetFriendInfo()
				foreach ( id in friends.ids )
				{
					if ( data.uid == id )
					{
						canAddFriend = false
						break
					}
				}
			}

			gladCard.canViewProfile = Teams_CanViewProfile( data.uid, data.hardware )
			string actionText = ""
			if( gladCard.canViewProfile )
				actionText += ( actionText == "" )? Localize( "#Y_BUTTON_VIEW_PROFILE" ): "\n" + Localize( "#Y_BUTTON_VIEW_PROFILE" )

			if( canInviteParty )
				actionText += ( actionText == "" )? Localize( "#CLICK_INVITE_PARTY" ): "\n" + Localize( "#CLICK_INVITE_PARTY" )

			if( canAddFriend )
				actionText += ( actionText == "" )? Localize( "#RCLICK_INVITE_FRIEND" ): "\n" + Localize( "#RCLICK_INVITE_FRIEND" )

			gladCard.actionText = Localize( actionText )
		}

		gladCard.isConnected 		  = isPlayerBot || ( ( IsValid( dataPlayer ) )? dataPlayer.IsConnectionActive(): false )
		gladCard.canBlock 			  = !isPlayerBot && !isLocalPlayer && CrossplayUserOptIn() && !IsUserOnSamePlatform( data.hardware )
		gladCard.canInvite            = !isPlayerBot && !isLocalPlayer
		gladCard.canMute              = !isPlayerBot && !isLocalPlayer && gladCard.isConnected
		gladCard.canMutePing          = !isPlayerBot && !isLocalPlayer && gladCard.isConnected
		gladCard.canReport            = !isPlayerBot && !isLocalPlayer && canReport
		gladCard.canSendFriendRequest = !isPlayerBot && !isLocalPlayer
		gladCard.name                 = GetDisplayablePlayerNameFromEHI( data.ehi )
		gladCard.team                 = data.team
		gladCard.uid                  = data.uid
		gladCard.eaid                 = data.eaid
		gladCard.hardware             = data.hardware
		gladCard.isFriendly           = isLocalPlayer || ( data.team == localPlayer.GetTeam() )
		gladCard.isLocalPlayer        = isLocalPlayer

		dataModel.append( gladCard )
	}

	RTKArray_SetValue( squadGladCardModel, dataModel )
}








#endif

#if UI

global function InitRTKSquadPanel

global function RTKSquadGladCards_InitMetaData
global function RTKSquadGladCards_OnInitialize
global function RTKSquadGladCards_OnDestroy

global function IsRTKSquadsEnabled








global struct RTKSquadGladCards_Properties
{
	rtk_panel gladCardList
}


global struct RTKSquadGladCardModel
{
	string uid
	string unspoofedUid
	string eaid
	string hardware
	int    team
	string id = ""
	string name = ""

	bool canMute = false
	bool isMuted = false
	bool canViewProfile = false

	bool canMutePing = false
	bool isPingMuted = false

	bool canReport = false
	bool canBlock = false
	bool canInvite = false
	bool canSendFriendRequest = false
	bool isConnected = true
	bool isLocalPlayer = true

	string actionText = ""

	bool isFriendly = false
}



struct PrivateData
{
	string path = ""
	rtk_struct squadModel
	int currentnewChildIndex = -1

	var functionref( var ) Callback_PCFButton_Activate
}



void function InitRTKSquadPanel( var panel )
{
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowSquad )

	InitSquadFooter( panel )
}




void function OnShowSquad( var panel )
{
	var parentMenu = GetParentMenu( panel )

	if( parentMenu == GetMenu( "DeathScreenMenu" ) && CanRunClientScript() ) 
	{
		var headerElement = Hud_GetChild( parentMenu, "Header" )
		RunClientScript( "DeathScreen_OnSquadShow", headerElement )
	}
}



void function RTKSquadGladCards_InitMetaData( string behaviorType, string structType )
{
	RegisterSignal( "RTKSquadGladCardsStop" )
}



void function RTKSquadGladCards_OnInitialize( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	p.path = RTKDataModelType_GetDataPath( RTK_MODELTYPE_MENUS, "squad", true, [] )

	self.GetPanel().SetBindingRootPath( p.path )
	p.squadModel = RTKDataModelType_CreateStruct( RTK_MODELTYPE_MENUS, "squad", "" )

	thread RTKSquadGladCards_DataThread( self )

	
	rtk_panel ornull gladCardList = self.PropGetPanel( "gladCardList" )
	if ( gladCardList != null )
	{
		expect rtk_panel( gladCardList )
		self.AutoSubscribe( gladCardList, "onChildAdded", function ( rtk_panel newChild, int newChildIndex ) : ( self ){
			array< rtk_behavior > itemListButtons = newChild.FindBehaviorsByTypeName( "Button" )
			rtk_behavior GladCardHitArea = newChild.FindChildByName( "GladCardHitArea" ).FindBehaviorByTypeName( "Button" )

			rtk_panel Actions = newChild.FindChildByName( "Bottom" ).FindChildByName( "Actions" )
			rtk_behavior ReportButton = Actions.FindChildByName( "ReportButtonContainer" ).FindChildByName( "ReportButton" ).FindBehaviorByTypeName( "Button" )
			rtk_behavior MuteButton = Actions.FindChildByName( "MuteButtonContainer" ).FindChildByName( "MuteButton" ).FindBehaviorByTypeName( "Button" )
			rtk_behavior MutePingsButton = Actions.FindChildByName( "MutePingsContainer" ).FindChildByName( "MutePingsButton" ).FindBehaviorByTypeName( "Button" )
			rtk_behavior BlockButton = Actions.FindChildByName( "BlockContainer" ).FindChildByName( "BlockButton" ).FindBehaviorByTypeName( "Button" )

			self.AutoSubscribe( GladCardHitArea, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				switch( keycode )
				{
					case MOUSE_LEFT:
					case BUTTON_A:
						RTKSquadGladCards_InviteSquadMate( self, newChildIndex )
						break
					case MOUSE_RIGHT:
					case BUTTON_X:
						RTKSquadGladCards_SendFriendRequest( self, newChildIndex )
						break
					case BUTTON_Y:
						RTKSquadGladCards_RTKViewProfile( self, newChildIndex )
						break
				}
			} )

			self.AutoSubscribe( GladCardHitArea, "onHighlightedOrFocused", function(  rtk_behavior button, int prevState ) : ( self, newChildIndex ) {
				PrivateData p
				self.Private( p )

				p.currentnewChildIndex = newChildIndex
			} )
			self.AutoSubscribe( GladCardHitArea, "onIdle", function(  rtk_behavior button, int prevState ) : ( self, newChildIndex ) {
				PrivateData p
				self.Private( p )

				p.currentnewChildIndex = -1
			} )


			self.AutoSubscribe( ReportButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				RTKSquadGladCards_Report( self, newChildIndex )
			} )

			self.AutoSubscribe( MuteButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				RTKSquadGladCards_ToggleMute( self, newChildIndex )
			} )

			self.AutoSubscribe( MutePingsButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				RTKSquadGladCards_ToggleMutePings( self, newChildIndex )
			} )

			self.AutoSubscribe( BlockButton, "onPressed", function( rtk_behavior button, int keycode, int prevState ) : ( self, newChildIndex ) {
				RTKSquadGladCards_BlockSquadMate( self, newChildIndex )
			} )
		} )
	}

	p.Callback_PCFButton_Activate = function( var button ) : ( self )
	{
		PCFButton_Activate( button, self )
	}

	RegisterButtonPressedCallback( KEY_F, p.Callback_PCFButton_Activate )
}



void function PCFButton_Activate( var button, rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	if( p.currentnewChildIndex > 0 )
		RTKSquadGladCards_RTKViewProfile( self, p.currentnewChildIndex )
}




void function RTKSquadGladCards_DataThread( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	EndSignal( self, "RTKSquadGladCardsStop" )

	while( true )
	{
		if ( CanRunClientScript() )
			RunClientScript( "UICallback_RTKPopulateSquadGladCards", p.path )

		wait 1.0
	}
}



void function RTKSquadGladCards_OnDestroy( rtk_behavior self )
{
	PrivateData p
	self.Private( p )

	Signal( self, "RTKSquadGladCardsStop" )
	DeregisterButtonPressedCallback( KEY_F, p.Callback_PCFButton_Activate )
	RTKDataModelType_DestroyStruct( RTK_MODELTYPE_MENUS, "squad", [""] )
}



void function RTKSquadGladCards_Report( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	rtk_array squadGladCardsModel = RTKStruct_GetArray( p.squadModel, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string playerName = RTKStruct_GetString( quadGladCardModel, "name" )
		int hardware = int( RTKStruct_GetString( quadGladCardModel, "hardware" ) )
		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )

		ClientToUI_ShowReportPlayerDialog( playerName, hardware, uid, eaid, "friendly" )
	}
}



void function RTKSquadGladCards_SendFriendRequest( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	rtk_array squadGladCardsModel = RTKStruct_GetArray( p.squadModel, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string hardware = RTKStruct_GetString( quadGladCardModel, "hardware" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )
		string unspoofedUid = RTKStruct_GetString( quadGladCardModel, "unspoofedUid" )

		if ( uid == "" )
			return

		bool canAddFriend = CanSendFriendRequest( GetLocalClientPlayer() )

		if ( canAddFriend )
		{
			CommunityFriends friends = GetFriendInfo()
			foreach ( id in friends.ids )
			{
				if ( uid == id || unspoofedUid == id || EADP_IsFriendByEAID( eaid ) )
				{
					canAddFriend = false
					break
				}
			}
		}

		if ( !canAddFriend )
			return

		
		EmitUISound( "UI_Menu_InviteFriend_Send" )
		string playerHardware = GetUnspoofedPlayerHardware()
		if ( playerHardware == hardware )
		{
			DoInviteToBeFriend( unspoofedUid )
		}
		else if ( CrossplayEnabled() && eaid != "" )
		{
			
			printt( "InviteEADPFriend id:", eaid )
			EADP_InviteFriendByEAID( eaid )
		}
	}
}



void function RTKSquadGladCards_BlockSquadMate( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	if ( CanRunClientScript() )
		RunClientScript( "UICallback_RTKBlockSquadMate", p.path, index )
}


































void function RTKSquadGladCards_InviteSquadMate( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	rtk_array squadGladCardsModel = RTKStruct_GetArray( p.squadModel, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string playerName = RTKStruct_GetString( quadGladCardModel, "name" )
		int hardware = int( RTKStruct_GetString( quadGladCardModel, "hardware" ) )
		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )

		int localHardwareId = GetHardwareFromName( GetUnspoofedPlayerHardware() )
		if ( localHardwareId != hardware )
		{
			ClientToUI_InviteToPlayByEAID( eaid )
		}
		else
		{
			DoInviteToParty( [ uid ] )
		}
	}
}



void function RTKSquadGladCards_ToggleMute( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	rtk_array squadGladCardsModel = RTKStruct_GetArray( p.squadModel, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string hardware = RTKStruct_GetString( quadGladCardModel, "hardware" )
		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )

		TogglePlayerVoiceAndTextMuteForUID( uid, hardware, eaid )
		RTKStruct_SetBool( quadGladCardModel, "isMuted", IsPlayerVoiceAndTextMutedForUID( uid, hardware ) )
	}
}



void function RTKSquadGladCards_ToggleMutePings( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	if ( CanRunClientScript() )
		RunClientScript( "UICallback_RTKToggleMutePings", p.path, index )
}






































void function RTKSquadGladCards_RTKViewProfile( rtk_behavior self, int index )
{
	PrivateData p
	self.Private( p )

	rtk_array squadGladCardsModel = RTKStruct_GetArray( p.squadModel, "gladcards" )
	int squadGladCardsModelCount = RTKArray_GetCount( squadGladCardsModel )

	if( squadGladCardsModelCount > index )
	{
		rtk_struct quadGladCardModel = RTKArray_GetStruct( squadGladCardsModel, index )

		string hardware = RTKStruct_GetString( quadGladCardModel, "hardware" )
		string uid = RTKStruct_GetString( quadGladCardModel, "uid" )
		string eaid = RTKStruct_GetString( quadGladCardModel, "eaid" )
		string unspoofedUid = RTKStruct_GetString( quadGladCardModel, "unspoofedUid" )
		bool canViewProfile = RTKStruct_GetBool( quadGladCardModel, "canViewProfile" )

		if( canViewProfile )
		{

				if ( !PCPlat_IsOverlayAvailable() )
				{
					string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
					ConfirmDialogData dialogData
					dialogData.headerText   = ""
					dialogData.messageText  = "#" + platname + "_INGAME_REQUIRED"
					dialogData.contextImage = $"ui/menu/common/dialog_notice"


					OpenOKDialogFromData( dialogData )
					return
				}


			ShowPlayerProfileCardForUID( unspoofedUid )
		}
	}
}


























































































































bool function IsRTKSquadsEnabled()
{
	return GetCurrentPlaylistVarBool( "rtk_squads_enabled", true )
}

#endif
