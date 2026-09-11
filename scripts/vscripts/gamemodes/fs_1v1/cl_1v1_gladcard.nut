// FSLeaderboard banner viewer. NestedGladiatorCardHandle is only nameable after mp/sh_gladiator_cards.nut.
// Card is owned by the local player; fields come from the server push -- other-realm rows have no entity.

global function FS_1v1_SetupLeaderboardGladCard
global function FS_1v1_TeardownLeaderboardGladCard

struct
{
	var panel = null
	array<NestedGladiatorCardHandle> cardHandle
} file

void function FS_1v1_SetupLeaderboardGladCard( var panel, string playerName, int charGuid, int skinGuid, int frameGuid, int careerKills, int careerDeaths )
{
	FS_1v1_TeardownLeaderboardGladCard()

	if ( panel == null || charGuid == 0 )
		return

	Hud_SetAboveBlur( panel, true )

	NestedGladiatorCardHandle cardHandle = CreateNestedGladiatorCard( Hud_GetRui( panel ), "card",
		eGladCardDisplaySituation.MENU_CUSTOMIZE_ANIMATED, eGladCardPresentation.FULL_BOX )
	ChangeNestedGladiatorCardOwner( cardHandle, LocalClientEHI(), Time(), eGladCardLifestateOverride.ALIVE )
	SetNestedGladiatorCardOverrideName( cardHandle, playerName )

	ApplyLeaderboardCardLook( cardHandle, charGuid, skinGuid, frameGuid )
	ApplyLeaderboardCardTrackers( cardHandle, careerKills, careerDeaths )

	if ( cardHandle.cardRui != null )
		RuiSetGameTime( cardHandle.cardRui, "menuGladCardRevealAt", Time() )

	file.panel = panel
	file.cardHandle.append( cardHandle )
}

void function FS_1v1_TeardownLeaderboardGladCard()
{
	foreach ( NestedGladiatorCardHandle cardHandle in file.cardHandle )
		CleanupNestedGladiatorCard( cardHandle )

	file.cardHandle.clear()
	file.panel = null
}

// The 3D capture only starts once skin AND stance resolve, and stance is
// character-associated so 1v1 never writes it -- take the slot default.
void function ApplyLeaderboardCardLook( NestedGladiatorCardHandle cardHandle, int charGuid, int skinGuid, int frameGuid )
{
	ItemFlavor character = GetItemFlavorByGUID( charGuid )

	ItemFlavor skin = CharacterClass_GetDefaultSkin( character )
	if ( skinGuid != 0 )
		skin = GetItemFlavorByGUID( skinGuid )

	SetNestedGladiatorCardOverrideCharacter( cardHandle, character )
	SetNestedGladiatorCardOverrideSkin( cardHandle, skin )
	SetNestedGladiatorCardOverrideStance( cardHandle, Loadout_GladiatorCardStance( character ).defaultItemFlavor )

	if ( frameGuid != 0 )
		SetNestedGladiatorCardOverrideFrame( cardHandle, GetItemFlavorByGUID( frameGuid ) )
	else
		SetNestedGladiatorCardOverrideFrame( cardHandle, Loadout_GladiatorCardFrame( character ).defaultItemFlavor )
}

void function ApplyLeaderboardCardTrackers( NestedGladiatorCardHandle cardHandle, int careerKills, int careerDeaths )
{
	if ( careerKills < 0 )
		careerKills = 0
	if ( careerDeaths < 0 )
		careerDeaths = 0

	SetNestedGladiatorCardRawTracker( cardHandle, 0, "LIFETIME KILLS", careerKills )
	SetNestedGladiatorCardRawTracker( cardHandle, 1, "LIFETIME DEATHS", careerDeaths )

	float kd = careerDeaths > 0 ? careerKills.tofloat() / careerDeaths.tofloat() : careerKills.tofloat()
	int kdWhole = int( kd )
	int kdFrac = int( ( kd - kdWhole.tofloat() ) * 100.0 + 0.5 )
	if ( kdFrac > 99 )
	{
		kdFrac = 0
		kdWhole += 1
	}
	SetNestedGladiatorCardRawTracker( cardHandle, 2, "LIFETIME K/D", kdWhole, format( ".%02d", kdFrac ) )
}
