/**
 * 
 * OrkPlayerInput
 * 
 * Class that handles all the player keyboard input and calls the neccesary classes
 * 
 * **/
class OrkPlayerInput extends PlayerInput within OrkPlayerController config(OrkPlayerInput);


/**
 * Toogles the pause game
 * **/
exec function GBA_ShowMenu()
{
	if(OrkGameInfo(WorldInfo.Game).bGamePaused)
	{
		Outer.UnPauseGame();
	}
	else
	{
		Outer.PauseGame();
	}
}

DefaultProperties
{
	
}
