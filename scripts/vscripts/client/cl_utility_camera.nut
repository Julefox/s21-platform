global function CreateWorldCrawlerCamera
global function SetWorldCrawlerCameraPosition
global function SetWorldCrawlerCameraAngles
global function SetWorldCrawlerCameraPositionAndAngles

global entity g_ClientCamera

void function CreateWorldCrawlerCamera()
{
	entity player = GetLocalClientPlayer()

	if(!IsValid(player)) return

	vector origin = <0, 0, 0>
	vector angles = <0, 0, 0>

	g_ClientCamera = CreateClientSidePointCamera(origin, angles, 90)
	g_ClientCamera.SetFOV(90)

	player.SetMenuCameraEntity(g_ClientCamera)
}

void function SetWorldCrawlerCameraPosition(vector position)
{
	if(!IsValid(g_ClientCamera)) return

	g_ClientCamera.SetOrigin(position)
}

void function SetWorldCrawlerCameraAngles(vector angles)
{
	if(!IsValid(g_ClientCamera)) return

	g_ClientCamera.SetAngles(angles)
}

void function SetWorldCrawlerCameraPositionAndAngles(vector position, vector angles)
{
	if(!IsValid(g_ClientCamera)) return

	g_ClientCamera.SetOrigin(position)
	g_ClientCamera.SetAngles(angles)
}
