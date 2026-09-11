                       
#if SERVER || CLIENT || UI
global function ShEventAbilities_Init
global function EventAbilities_GetRewardImage
#endif

#if SERVER || CLIENT || UI
struct EventAbilityData
{
	int passive = ePassives.INVALID
	bool active = false
	ItemFlavor& calEvent
}
#endif


#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, EventAbilityData> eventAbilityDataTable
}
#endif


#if SERVER || CLIENT
FileStruct_LifetimeLevel fileLevel // resets every level change
#elseif UI
FileStruct_LifetimeLevel& fileLevel // resets every level change

struct {
	//
} fileVM // resets every UI VM reset
#endif


#if SERVER || CLIENT || UI
void function ShEventAbilities_Init()
{
	AddCallback_RegisterRootItemFlavors( OnRegisterRootItemFlavors )
	AddCallbackOrMaybeCallNow_OnAllItemFlavorsRegistered( OnAllItemFlavorsRegistered )
	#if SERVER
		if ( GetCurrentPlaylistVarBool( "event_abilities", false ) )
			Survival_AddCallback_OnPlayerSetupComplete( OnPlayerSetupComplete )
                    
         
                                                                         
                                                 
        
        
	#endif
}


void function OnAllItemFlavorsRegistered()
{
	foreach ( itemflavor, ead in fileLevel.eventAbilityDataTable )
	{
		if ( !CalEvent_IsActive( ead.calEvent , GetUnixTimestamp()) )
		{
			continue
		}

		ead.active = true
	}
}

void function OnRegisterRootItemFlavors()
{
	foreach ( asset eventAbility in GetBaseItemFlavorsFromArray( "eventAbilities" ) )
	{
		if ( eventAbility == $"" )
			continue

		EventAbilityData ead

		asset calEventAsset = WORKAROUND_AssetAppend( GetGlobalSettingsAsset( eventAbility , "calEventFlav" ), ".rpak" )
		if ( !IsValidItemFlavorSettingsAsset( calEventAsset ) )
		{
			printt("OnRegisterRootItemFlavors skipping registration cause associated cal event not valid")
			continue
		}

		ead.calEvent = GetItemFlavorByAsset( calEventAsset )

		//if ( !CalEvent_IsActive( GetItemFlavorByAsset( calEventAsset ) , GetUnixTimestamp()) )
		//{
		//	printt("OnRegisterRootItemFlavors skipping registration cause associated cal event not active")
		//	continue
		//}


		string passiveRef = GetGlobalSettingsString( eventAbility , "passiveScriptRef" )
		if ( passiveRef == "" )
		{
			printt("OnRegisterRootItemFlavors skipping registration cause passiveRef is empty")
			continue
		}

		Assert( passiveRef in ePassives, "Unknown passive script ref: " + passiveRef )

		ead.passive = ePassives[ passiveRef ]

		ItemFlavor ornull eventAbilityOrNull = RegisterItemFlavorFromSettingsAsset( eventAbility )
		if ( eventAbilityOrNull == null )
			continue

		expect ItemFlavor( eventAbilityOrNull )

		printt("OnRegisterRootItemFlavors registration complete " + string(eventAbility) + " registered")

		fileLevel.eventAbilityDataTable[ eventAbilityOrNull ] <- ead
	}
}

asset function EventAbilities_GetRewardImage( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.event_ability )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "rewardImage" )
}

#endif

#if SERVER
void function OnPlayerSetupComplete( entity player )
{
	if ( !IsValid ( player ) )
		return

	thread function() : (player)
	{
		player.EndSignal( "OnDestroy" )

		while ( !GRX_IsInventoryReady( player ) )
			WaitFrame()

		foreach ( itemflavor, ead in fileLevel.eventAbilityDataTable )
		{
			if ( ead.active && GRX_IsItemOwnedByPlayer( itemflavor, player ) )
			{
				GivePassive( player, ead.passive )
			}
		}

	}()
}

                  
       
                                                                              
 
              
                                                                                                                                                                           
  
           
  

                                                  
                                                            

 
      
                       
#endif

      
