global function Weapon_Cubemap_Init
#if SERVER
global function Cubemap_CleanupUtilitySlot
#endif

void function Weapon_Cubemap_Init()
{
#if SERVER
	Bleedout_AddCallback_CleanupUtilitySlot( Cubemap_CleanupUtilitySlot )
#endif
}

#if SERVER
void function Cubemap_CleanupUtilitySlot( entity player )
{
	bool isCubemapActive = false
	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.GetWeaponClassName() == "weapon_cubemap" )
		isCubemapActive = true
	
	entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_3 )
	if ( IsValid( weapon ) && weapon.GetWeaponClassName() == "weapon_cubemap" )
		player.TakeWeaponByEntNow( weapon )
		
	if ( isCubemapActive )
		player.SetActiveWeaponByName( eActiveInventorySlot.mainHand, player.GetLatestPrimaryWeapon( eActiveInventorySlot.mainHand ).GetWeaponClassName() )
}
#endif
