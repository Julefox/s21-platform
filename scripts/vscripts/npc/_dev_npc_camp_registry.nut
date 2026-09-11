global function DEV_Tropics_RegisterNPCCamp
global function DEV_Tropics_NPCCampAnalysis

struct DEV_Tropic_NPCCamp
{
	vector origin
	int npcType //eNPC
	float range
	float cullingRadius
}

array <DEV_Tropic_NPCCamp> npcCamps = []

// File-private (non-global struct in signature cannot be global function).
vector function DEV_Tropic_GetNPCCampColor( DEV_Tropic_NPCCamp camp )
{
	switch ( camp.npcType )
	{
		case eNPC.PROWLER:
		case eNPC.SPIDER_JUNGLE:
			return <0, 125, 255>
		case eNPC.SPECTRE:
			return <255, 0, 0>
	}
	return <255, 255, 255>
}

void function DEV_Tropics_RegisterNPCCamp ( vector origin, int npcType, float range, float cullingRadius )
{
	DEV_Tropic_NPCCamp camp
	camp.origin = origin
	camp.npcType = npcType
	camp.range = range
	camp.cullingRadius = cullingRadius
	npcCamps.append( camp )
}

void function DEV_Tropics_NPCCampAnalysis ( float timeout = 60 )
{
	// Set the player's origin and angles so they're looking straight down on the map
	#if SERVER || CLIENT
	GetPlayerArray()[0].SetOrigin( < 20645.253906, 1344.686279, 54229.070313 > )
	#endif // SERVER || CLIENT
	GetPlayerArray()[0].SetAngles( < 76.240051, 142.319931, 0.000000 > )

	table < DEV_Tropic_NPCCamp, array < DEV_Tropic_NPCCamp > > badSpots

	foreach ( DEV_Tropic_NPCCamp camp in npcCamps )
	{
		array < vector > positions = GetEvenlySpacedPointsAroundCircle( camp.origin, <0,0,0>, 36, camp.range )

		foreach ( vector p in positions )
		{
			array< DEV_Tropic_NPCCamp > overlappingCamps = []
			foreach ( DEV_Tropic_NPCCamp otherCamp in npcCamps )
			{
				if (otherCamp == camp)
					continue

				if ( Distance2D( p, otherCamp.origin ) < otherCamp.range + camp.cullingRadius)
				{
					if ( !(camp in badSpots) )
					{
						badSpots[camp] <- [otherCamp]
					}
					else
					{
						foreach ( DEV_Tropic_NPCCamp c in badSpots[camp] )
						{
							if ( !badSpots[camp].contains( c ) )
							{
								badSpots[camp].append( c )
							}
						}
					}
				}
			}
		}
	}

	array < DEV_Tropic_NPCCamp > namedCamps = []

	vector arrowColor = <255, 55, 125>

	foreach ( key, val in badSpots )
	{
		float centroidX = 0
		float centroidY = 0

		string debugText = GetEnumString( "eNPC", key.npcType )
		DebugDrawText( key.origin, debugText, false, timeout )
		namedCamps.append( key )

		vector color = DEV_Tropic_GetNPCCampColor( key )
		DebugDrawSphereRGB( key.origin, 200, int(color.x), int(color.y), int(color.z), true, timeout )
		DebugDrawCircleRGB( key.origin, <0,0,0>, key.range, 255, 255, 255, true, timeout )
		DebugDrawCircleRGB( key.origin, <0,0,0>, key.range + key.cullingRadius, 125, 200, 90, true, timeout )

		foreach ( DEV_Tropic_NPCCamp camp in val )
		{
			if ( !namedCamps.contains( camp ) )
			{
				debugText = GetEnumString( "eNPC", camp.npcType )
				DebugDrawText( camp.origin, debugText, false, timeout )
				namedCamps.append( camp )
			}

			color = DEV_Tropic_GetNPCCampColor ( camp )
			DebugDrawSphereRGB( camp.origin, 200, int(color.x), int(color.y), int(color.z), true, timeout )

			DebugDrawLineRGB( key.origin, camp.origin, int(arrowColor.x), int(arrowColor.y), int(arrowColor.z), true, timeout )

			vector direction = Normalize(camp.origin - key.origin)

			vector arrowOrigin1 = RotateAroundOrigin2D ( camp.origin - direction * 2000, key.origin, DegToRad( 7 ) )
			vector arrowOrigin2 = RotateAroundOrigin2D ( camp.origin - direction * 2000, key.origin, DegToRad( -7 ) )

			DebugDrawLineRGB( arrowOrigin1, camp.origin, int(arrowColor.x), int(arrowColor.y), int(arrowColor.z), true, timeout )
			DebugDrawLineRGB( arrowOrigin2, camp.origin, int(arrowColor.x), int(arrowColor.y), int(arrowColor.z), true, timeout )
		}

		printf ( GetEnumString("eNPC", key.npcType) + " Spawner at "+ key.origin + " overlaps with " + val.len() + " other camps." )
	}
}
