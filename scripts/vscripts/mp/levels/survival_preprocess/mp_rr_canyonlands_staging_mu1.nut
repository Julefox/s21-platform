global function mp_rr_canyonlands_staging_mu1_SurvivalPreprocess
global function RunMySurvivalPreprocess

void function RunMySurvivalPreprocess()
{
	mp_rr_canyonlands_staging_mu1_SurvivalPreprocess()
}

void function mp_rr_canyonlands_staging_mu1_SurvivalPreprocess()
{
	if ( Dev_CommandLineHasParm( "-survival_preprocess" ) )
		return

	AddZone_0()

	SURVIVAL_MarkLevelAsPreProcessed()
}

void function AddZone_0()
{
	SURVIVALPreProcess_AddLootZone( "zone_low", < 0,0,0 > )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1874.06,  2353.56,  617.345 >, false, false )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1872.88,  2422.01,  617.345 >, false, false )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1861.87,  2386.42,  630 >, false, false )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1799.87,  2386.42,  634 >, false, false )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1798.54,  2353.5,  616.757 >, false, false )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1782.97,  2409.42,  616.768 >, false, false )
	SURVIVALPreProcess_AddLocationToLastLootZone( < -1645.87,  2386.42,  610 >, false, false )
}

