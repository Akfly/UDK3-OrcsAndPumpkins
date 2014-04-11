/**
 * 
 * OrkGameInfo
 * 
 * The main class of the game.
 * 
 * **/
class OrkGameInfo extends GameInfo;

var bool	bGamePaused;    //If the game is paused or not.
var int	    PumpkinIDGen;   //Each time a pumpkin is loaded in the map, this var increases by one, giving a different ID to each one

var OrkEnemyController  enemyC;     //The AI Controller of the enemy. Used to comunicate it with other classes
var OrkPumpkinManager   pManager;   //A manager that has count of every pumpkin

/**
 * Called immediately after gameplay begins.
 * **/
event PreBeginPlay()
{
	super.PreBeginPlay();

	pManager = Spawn(class'OrkPumpkinManager', self);
}

/**
 * We only want to unpause the game whenever we want, not when the game want xD
 * **/
event ClearPause()
{
	if(!bGamePaused)
	{
		super.ClearPause();
	}
}

/**
 * Increases the Pumpkin ID Generator
 * **/
function int GeneratePumpkinID()
{
	PumpkinIDGen++;
	return PumpkinIDGen;
}

DefaultProperties
{
	PlayerControllerClass=class'OrkPlayerController'
	DefaultPawnClass=class'OrkPlayerPawn'
	bDelayedStart=false
	HUDType=class'OrkHUD'

	bGamePaused=false
	PumpkinIDGen=0
}
