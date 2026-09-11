global function CodeCallback_MapInit

void function CodeCallback_MapInit()
{
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_district.rpak" )
	District_MapInit_Common()
	CryptoDrone_SetMaxZ( 3300 )

	SURVIVAL_SetPlaneHeight( 26000 )
	SURVIVAL_SetAirburstHeight( 2500 )
	SURVIVAL_SetMapCenter( <5000, 9000, 0> )
}
