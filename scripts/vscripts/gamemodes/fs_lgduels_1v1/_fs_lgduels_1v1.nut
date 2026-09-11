global function Flowstate_LgDuels1v1_Init

const string LG_DUEL_WEAPON = "mp_weapon_r97 optic_cq_hcog_classic stock_tactical_l1 bullets_mag_l2"
const float LG_DUEL_HEAL = 3.0

void function Flowstate_LgDuels1v1_Init()
{
	printt( "[FS-LGDUels] init" )

	AddCallback_SpawnsSettings(
		void function()
		{
			SpawnSystem_SetCustomPlaylist( "fs_1v1" )
		}
	)

	AddCallback_OnClientConnected( INIT_LGDuels_Player )
	AddCallback_OnPlayerRespawned( LGDuel_OnPlayerRespawned )
	AddCallback_OnWeaponAttack( LGDuel_OnWeaponAttack )
}

void function INIT_LGDuels_Player( entity player )
{
	AddEntityCallback_OnDamaged( player, LGDuel_OnPlayerDamaged )
}

void function LGDuel_GiveLoadout( entity player )
{
	TakeAllWeapons( player )
	Gamemode1v1_GiveWeapon( player, LG_DUEL_WEAPON, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	Gamemode1v1_GiveWeapon( player, LG_DUEL_WEAPON, WEAPON_INVENTORY_SLOT_PRIMARY_1 )
	Survival_SetInventoryEnabled( player, true )
	SetPlayerInventory( player, [] )
	EnableOffhandWeapons( player )
	DeployAndEnableWeapons( player )
}

void function LGDuel_OnPlayerRespawned( entity player )
{
	if ( !IsValid( player ) )
		return

	int state = Gamemode1v1_GetPlayerGamestate( player )
	if ( state == e1v1State.RESTING || state == e1v1State.RECAP )
		LGDuel_GiveLoadout( player )
}

void function LGDuel_OnWeaponAttack( entity player, entity weapon, string weaponName, int ammoUsed, vector attackOrigin, vector attackDir )
{
	if ( !Flowstate_IsLGDuels() || !IsValid( player ) || !player.IsPlayer() )
		return

	int state = Gamemode1v1_GetPlayerGamestate( player )
	if ( state != e1v1State.IN_MATCH && state != e1v1State.SEQUENCE )
		return

	player.p.totalLGShots++
}

void function LGDuel_OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() )
		return

	int victimState = Gamemode1v1_GetPlayerGamestate( victim )
	if ( FS_1v1_IsLobbyState( victimState ) )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		return
	}

	if ( Bleedout_IsBleedingOut( victim ) )
		return

	entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
	if ( !IsValid( attacker ) || !attacker.IsPlayer() || !IsAlive( attacker ) )
		return

	float dmg = DamageInfo_GetDamage( damageInfo )
	if ( dmg <= 0 )
		return

	DamageInfo_SetDamage( damageInfo, LG_DUEL_HEAL )

	attacker.RefillAllAmmo()

	float atthealth = float( attacker.GetHealth() )
	if ( atthealth < attacker.GetMaxHealth() )
		attacker.SetHealth( min( atthealth + LG_DUEL_HEAL, float( attacker.GetMaxHealth() ) ) )

	attacker.p.totalLGHits++

	if ( attacker.p.totalLGShots > 0 )
	{
		int accuracy = int( ( float( attacker.p.totalLGHits ) / float( attacker.p.totalLGShots ) ) * 100 )
		attacker.SetPlayerNetInt( "accuracy", accuracy )
	}
}
