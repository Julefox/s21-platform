global function CodeCallback_MapInit
global function CodeCallback_OnPlayerUpdraftLift

void function CodeCallback_MapInit()
{
	RunMySurvivalPreprocess()
	
	DividedMoon_MapInit_Common()

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_divided_moon_mu1.rpak" )

	SURVIVAL_SetPlaneHeight( 25000 )
	SURVIVAL_SetMapCenter( <0,0,0> )
	SURVIVAL_SetAirburstHeight( 2500 )

	ShPrecacheSkydiveLauncherAssets()

	
	//CONTROL INTRO CAMERA
	IntroCameraSettings view
	if( GameMode_IsActive( eGameModes.CONTROL ) )
	{
		//PRODUCTION
		view.origin = <  -36323.4, -1813.5, 1347.3 > 
		view.angles = < -11.9, 316.3, 0.0 >
		view.fov = 100
	}
	else
	{
		int randChoice = RandomInt( 11 )
		switch( randChoice )
		{
			// Ground Zero
			case 0:
				view.origin = < -14471.145508, -12009.662109, 9658.262695 >
				view.angles = < 32.000370, 46.113014, 0 >
				view.fov = 90
				break
				
				
			// Foundry
			case 1:
				view.origin = < -36355.7, -22964.8, 4091.9 >
				view.angles = < 0.7, -46.0, 0 >
				view.fov = 90
				break
				
			// Ground Zero
			case 2:
				view.origin = < -12972.331055, -1890.236328, 6184.154297 >
				view.angles = < 12.194203, -34.696590, 0 > 
				view.fov = 90
				break
				
			//Space Port	
			case 3:
				view.origin = < -31605.031250, 19305.628906, 1898.908691 >
				view.angles = < 18.748920, 145.426727, 0 > 
				view.fov = 90
				break

			//Cliff Side
			case 4:
				view.origin = < -1117.578125, 9660.479492, 3153.888916 >
				view.angles = < 9.329087, -12.396012, 0 > 
				view.fov = 90
				break

				//Solar Pods
			case 5:
				view.origin = < -17749.144531, -31189.634766, 3963.217041 >
				view.angles = < 7.631382, 137.688095, 0 > 
				view.fov = 90
				break

				//Experimental Labs
			case 6:
				view.origin = < -35096.839844, -20535.984375, 2875.459717 >
				view.angles = < 14.726166, 50.206558, 0 > 
				view.fov = 90
				break


			// Atmo
			case 7:
				view.origin = < 13846.1, -40322.0, 11897.3 >
				view.angles = < 17.2, 121.4, 0 >
				view.fov = 110
				break	
				
			// The Core
			case 8:
				view.origin = < -21018.0, 19829.8, 2399.3 >
				view.angles = < -10.8, -18.9, 0 >
				view.fov = 70
				break
								
			// Eternal Acres
			case 9:
				view.origin = < 22687.7, 9636.1, 1548.9 >
				view.angles = < -21.6, 128.8, 0 >
				view.fov = 70
				break
				
			// Terraformer
			case 10:
				view.origin = < 17783.896484, -3196.333984, 9879.986328 >
				view.angles = < 24.321203, -152.439957, 0 >
				view.fov = 70
				break
		}				
	}
	SetIntroCameraSettings( view )

	if ( GetCurrentPlaylistVarInt( "deathfield_end_on_script_locations", 0 ) == 1 )
		AddCircleOverrideLocations()

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

                      
                                                          

                                                                              
                                                                             
                                                                             
                                                                               
                                                                                  
                                                                            
                                                                                   
                                                                          
                                                                            
                                                                             
                                                                                
                                                                               
                                                                              

       
                                                                             
                                                                                 
                                                                                  
                                                                            
                                                                              
                                                                                     
                                                                               
                            
}



const array<vector> ZONE8_SLIDING_DOORS_AMB_GENERIC_ORIGINS = [ < -13208.5, 18795.98, 2105.5>,  < -12783.2, 19112.0, 2105.5>, < -12894.6, 18372.8, 2105.5>, < -12466.3, 18684.6, 2105.5> ]
void function EntitiesDidLoad()
{
	array< entity > ents =  GetEntArrayByScriptName( "kinectic_battery_spinning_wall" )
	if ( ents.len() == 1 )
	{
		foreach ( ambGenOrigin in ZONE8_SLIDING_DOORS_AMB_GENERIC_ORIGINS )
		{
			entity ambientGeneric = CreateEntity( "ambient_generic" )
			ambientGeneric.SetOrigin( ambGenOrigin )
			ambientGeneric.SetSoundName( "DividedMoon_PerpetualCore_Emit_RotatingWall_Friction" )
			ambientGeneric.SetParent( ents[0] )
			ambientGeneric.SetEnabled( true )
			DispatchSpawn( ambientGeneric )
		}

	}
}


// Updraft logic taken from Desertlands & Canyonlands MU3 (Caustic TT)
void function CodeCallback_OnPlayerUpdraftLift( entity player )
{
	DividedMoon_UpdraftInit_Common( player )
}

//Custom Endings
void function AddCircleOverrideLocations()
{
	{
		switch ( RandomInt( 2 ) )//0 Terraformer
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <14051, -8121, 5731>, 0, true )   // Terraformer #0
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <5676, -15101, 5081>, 0, true )   // Terraformer #1 base of cave
				break
		}
	}
	{
		switch ( RandomInt( 4 ) )//1 S. Promenade
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-13669, -4640, 4096>, 0, true )   // S. Promenade #2
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-15654, 1105, 3714>, 0, true )   // S. Promenade (NW side) #3
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-7259, -9717, 4640>, 0, true )   // S. Promenade (SE side) #4
				break

			case 3:
				SURVIVAL_AddOverrideCircleLocation( <-7957, -4639, 4160>, 0, true )   // S. Promenade (Center!!!) #5
				break
		}
	}
	{
		switch ( RandomInt( 2 ) )//2 Production Yard
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-24252, -5418, 2177>, 0, true )   // Production Yard #6
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-36556, -2876, 1047>, 0, true )   // Production Yard #7
				break
		}
	}
	{
		switch ( RandomInt( 3 ) )//3 Core
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-12845, 18731, 2068>, 0, true )   // Core #8
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-8249, 19764, 1885>, 0, true )   // Core #9
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-19676, 17175, 1339>, 0, true )   // Core #10
				break
		}
	}
	{
		switch ( RandomInt( 2 ) )//4 Dry gulch
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-27181, 9498, 948>, 0, true )   // dry gulch #11
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-24227, 16007, 530>, 0, true )   // dry gulch #12
				break
		}
	}
	{
		switch ( RandomInt( 2 ) )//5 Alpha Base
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <3539, 26842, 767>, 0, true )   // Alpha Base #13
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <5137, 31644, 863>, 0, true )   // Alpha Base #14
				break
		}
	}
	{
		switch ( RandomInt( 2 ) )//6 Garden
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <24325, 6718, 1570>, 0, true )   // Garden #15
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <22919, 15114, 1532>, 0, true )   // Garden #16
				break
		}
	}
	{
		switch ( RandomInt( 2 ) )//7 ATMO
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <23669, 28216, 3248>, 0, true )   // ATMO #17
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <18962, 26695, 2336>, 0, true )   // ATMO #18
				break
		}
	}
	{
		switch ( RandomInt( 2 ) )//8 Bionomics
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <30194, -17972, 4784>, 0, true )   // Bionomics #19
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <25880, -24821, 5153>, 0, true )   // Bionomics #20
				break
		}
	}
	{
		switch ( RandomInt( 3 ) )//9 ATMOSTATION
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <10032, -33726, 6564>, 0, true )   // ATMOSTATION #21
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <12977, -31161, 6204>, 0, true )   // ATMOSTATION #22
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <3151, -24692, 5240>, 0, true )   // ATMOSTATION #23
				break
		}
	}
	{
		switch ( RandomInt( 3 ) )//10 Foundary + Cultivation
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <-30333, -25580, 1857>, 0, true )   // Foundary W #24
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <-6691, -31870, 3365>, 0, true )   // Cultivation #25
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <-23757, -35157, 1729>, 0, true )   // Foundary E #26
				break
		}
	}
	{
		switch ( RandomInt( 3 ) )//11 Stasis
		{
			case 0:
				SURVIVAL_AddOverrideCircleLocation( <5168, 14866, 1335>, 0, true )   // Stasis array #27
				break

			case 1:
				SURVIVAL_AddOverrideCircleLocation( <2254, 10923, 2720>, 0, true )   // Cultivation #28
				break

			case 2:
				SURVIVAL_AddOverrideCircleLocation( <11809, 14701, 1227>, 0, true )   // Cultivation #29
				break
		}
	}
}