global function NPCPrecache_Spider_Jungle

#if SERVER
const asset NPC_SPIDER_JUNGLE_MODEL = $"mdl/creatures/spider/spider.rmdl"
#endif
#if CLIENT
const asset NPC_SPIDER_JUNGLE_MODEL = $"mdl/creatures/spider/spider_jungle.rmdl"
#endif
const asset NPC_SPIDER_JUNGLE_WEAPON = $"npc_weapon_spider_jungle"

void function NPCPrecache_Spider_Jungle()
{
	printf("======================== SPIDER JUNGLE PRECACHE")
	PrecacheModel( NPC_SPIDER_JUNGLE_MODEL )
	PrecacheWeapon( NPC_SPIDER_JUNGLE_WEAPON )
	SetNPCAsset( eNPC.SPIDER_JUNGLE, eNPCAsset.BODY, NPC_SPIDER_JUNGLE_MODEL )
}
