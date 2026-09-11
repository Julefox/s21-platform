global function CodeCallback_PreMapInit
global function CodeCallback_MapInit
global function CodeCallback_OnPlayerUpdraftLift

void function CodeCallback_PreMapInit()
{
}

void function CodeCallback_MapInit()
{
	InitWaterLeviathans()
	Canyonlands_MapInit_Common()
	RunMySurvivalPreprocess()

	InitOctaneTownTakeover()
	Flyers_SetFlyersToSpawn( 8 )

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_hu.rpak" )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	SURVIVAL_SetMapCenter( <5500.0, 5100.0, 0> )

	ShPrecacheSkydiveLauncherAssets()
	CommonStoryEvents_Init()
	CanyonLandsCausticLore_Init()

	if ( GetCurrentPlaylistVarInt( "deathfield_end_on_script_locations", 0 ) == 1 )
		AddCircleOverrideLocations()

	//CONTROL INTRO CAMERA
	IntroCameraSettings view
	if( GameMode_IsActive( eGameModes.CONTROL ) )
	{
		//CAUSTIC TT
		view.origin = < 8449.456055, -25911.128906, 2978.833740 >
		view.angles = < -13.739958, -100.697678, 0 >
		view.fov = 70
	}
	else
	{
		int randChoice = RandomInt( 7 )
		switch( randChoice )
		{
			// Relic
			case 0:
				view.origin = < -9673.486328, -20556.648438, 3096.391113 >
				view.angles = < -2.970001, 68.840263, 0.000000 >
				view.fov = 90
				break
				// Basin

			case 1:
				view.origin = < 26333.195313, 23412.291016, 3868.038086 >
				view.angles = < -14.969805, 115.092682, 0.000000 >
				view.fov = 80
				break
				// Crashed Ship

			case 2:
				view.origin = < -3464.560, 28975.292, 4880.627 >
				view.angles = < -18.150, 104.420, 0.000 >
				view.fov = 70
				break
				// Filtration Dam Interior

			case 3:
				view.origin = < -20460.881, 22082.725, 2275.531 >
				view.angles = < -10.274, -120.972, 0.000 >
				view.fov = 70
				break
				// Spotted Lake Hightop

			case 4:
				view.origin = < -18416.203, 25687.599, 3358.951 >
				view.angles = < 8.476, -154.949, 0.000 >
				view.fov = 80
				break
				// Destroyed Artillery Back Gate

			case 5:
				view.origin = < 6465.107, 31394.420, 4895.015 >
				view.angles = < -23.010, 69.627, 0.000 >
				view.fov = 90
				// Caustic TT

			case 6:
				view.origin = <  8294.706055, -26825.814453, 2997.494873 >
				view.angles = < -20.478926, -115.878998, 0 >
				view.fov = 90
				break
		}
	}

	SetIntroCameraSettings( view )

                      
                                                          

             
                                                                                                                                       

              
                                                                                                                                           
                                                                                                                                                   
                                                                                                                                             

          
                                                                                                                                             
                                                                                                                                          
                                                                                                                                      

            
                                                                                                                                          
                                                                                                                                                   
                                                                                                                                               
                                                                                                                                                

          
                                                                                                                                                          

        
                                                                                                                                         
                                                                                                                                           
                                                                                                                                            

          
                                                                                                                                             
                                                                                                                                            

        
                                                                                                                                             
                                                                                                                                           

        
                                                                                                                                             
                                                                                                                                               
                            
}

void function EntitiesDidLoad()
{
	PlaceOctaneTownTakeoverLoot()
}

void function AddCircleOverrideLocations()
{
	SURVIVAL_AddOverrideCircleLocation( <-17524, 23588, 2220>,  0, true )	// Spotted Lakes
	SURVIVAL_AddOverrideCircleLocation( <-24696, 11914, 3028>,  0, true )	// Runoff
	SURVIVAL_AddOverrideCircleLocation( <-24518, -3246, 2512>,  0, true )	// Airbase
	SURVIVAL_AddOverrideCircleLocation( <-18931, -12205, 3087>, 0, true )	// Gauntlet
	SURVIVAL_AddOverrideCircleLocation( <-15980, 3464, 2877>,   0, true )	// village between airbase and bunker
	SURVIVAL_AddOverrideCircleLocation( <-5758, -14204, 3200>,  0, true )	// Salvage
	SURVIVAL_AddOverrideCircleLocation( <-443, -11480, 2889>,   0, true )	// Market
	SURVIVAL_AddOverrideCircleLocation( <8208, -23073, 2489>,   0, true )	// Water Treatment (Caustic TT)
	SURVIVAL_AddOverrideCircleLocation( <21704, -21806, 3856>,  0, true )	// Map Room
	SURVIVAL_AddOverrideCircleLocation( <21793, -14886, 4664>,  0, true )	// Repulsor
	SURVIVAL_AddOverrideCircleLocation( <22765, -6026, 4336>,   0, true )	// Hydro
	SURVIVAL_AddOverrideCircleLocation( <35419, -1750, 2816>,   0, true )	// Swamps
	SURVIVAL_AddOverrideCircleLocation( <27551, 3506, 3192>,    0, true )	// Labs
	SURVIVAL_AddOverrideCircleLocation( <16214, -2948, 3927>,    0, true )	// Cage
	SURVIVAL_AddOverrideCircleLocation( <23852, 16724, 2624>,   0, true )	// Capacitor
	SURVIVAL_AddOverrideCircleLocation( <33959, 19701, 3912>,   0, true )	// Rig
	SURVIVAL_AddOverrideCircleLocation( <7413, 30840, 4768>,    0, true )	// Artillery
	SURVIVAL_AddOverrideCircleLocation( <-4462, 17106, 2686>,   0, true )	// Containment
	SURVIVAL_AddOverrideCircleLocation( <-4427, 4281, 2148>,    0, true )	// Destroyed Cascades (between bunker and market)
	SURVIVAL_AddOverrideCircleLocation( <7573, 9690, 5248>,    0, true )	// Destroyed Cascades 2 (between bunker and capacitor)
	SURVIVAL_AddOverrideCircleLocation( <13035, 19610, 4714>,    0, true )	// Two Spines
	SURVIVAL_AddOverrideCircleLocation( <-3912, 35774, 5101>,    0, true )	// Crash Site
}

void function CodeCallback_OnPlayerUpdraftLift( entity player )
{
	Canyonlands_UpdraftInit_Common( player )
}

