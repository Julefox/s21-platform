global function mp_rr_thunderdome_SurvivalPreprocess
global function RunMySurvivalPreprocess

void function RunMySurvivalPreprocess()
{
	mp_rr_thunderdome_SurvivalPreprocess()
}

void function mp_rr_thunderdome_SurvivalPreprocess()
{
	if ( Dev_CommandLineHasParm( "-survival_preprocess" ) )
		return

	AddZone_0()

	SURVIVAL_MarkLevelAsPreProcessed()
}

void function AddZone_0()
{
	SURVIVALPreProcess_AddLootZone( "zone_low", < 0,0,0 > )
}

