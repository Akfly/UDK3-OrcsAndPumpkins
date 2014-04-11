/**
 * 
 * OrkPlayerController
 * 
 * Controller class for the player
 * 
 * **/
class OrkPlayerController extends PlayerController;

var float           RotationSpeed;      //Speed rotation for the pawn when he has to face a new direction where he have to walk
var vector          MyTarget;           //the position where the mouse has clicked and I have to go.
var bool            bMatineeIsPlaying;  //If the matinee is playing, so I can't move while it is.

/**
 * Toogle if matinee is playing or not
 * **/
exec function ToggleInMatineeSequence()
{
	bMatineeIsPlaying=!bMatineeIsPlaying;
}

/**
 * Handles attaching this controller to the specified
 * pawn.
 * 
 * @param   inPawn              The pawn
 * @param   bVehicleTransition  if it is in a vehicle
 * **/
event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess( inPawn, bVehicleTransition );
	Pawn.SetMovementPhysics();
}

/**
 * 
 * Called every frame
 * 
 * @param   DeltaTime   Time elapsed from the last frame to this one
 * 
 * **/
event PlayerTick( float DeltaTime )
{
	local rotator NewRotation;

	super.PlayerTick( DeltaTime );

	//Rotate the pawn if required due to the new target position
	if(VSize2D(Pawn.Location - MyTarget) > 60)
	{
		NewRotation = RInterpTo(Pawn.Rotation, rotator(MyTarget - Pawn.Location), DeltaTime, RotationSpeed, false);
		NewRotation.Pitch=0;
		NewRotation.Roll=0;
		Pawn.SetRotation(NewRotation);
	}
}

/**
 * Pauses the game, stopping it and drawing the pause menu
 * **/
function PauseGame()
{
	OrkGameInfo(WorldInfo.Game).bGamePaused=true;
	WorldInfo.Game.SetPause(self);
	OrkHUD(myHUD).ShowPauseMenu();
}

/**
 * Unpauses the game, hidding the pause menu and 
 * giving life again to the rest of the game
 * **/
function UnPauseGame()
{
	OrkGameInfo(WorldInfo.Game).bGamePaused=false;
	WorldInfo.Game.ClearPause();
	OrkHUD(myHUD).HidePauseMenu();
}

/**
 * Function called when a mouse button is released
 * 
 * @param   vTarget     the new location on the scenary where I should go
 * 
 * **/
function OnMouseUp(vector vTarget);

state Idle
{
	/**
	 * Function called when a mouse button is released
	 * 
	 * @param   vTarget     the new location on the scenary where I should go
	 * 
	 * **/
	function OnMouseUp(vector vTarget)
	{
		GoToState('Seeking');
		MyTarget=vTarget;
	}
}
state Seeking
{
	/**
	 * Function called when a mouse button is released
	 * 
	 * @param   vTarget     the new location on the scenary where I should go
	 * 
	 * **/
	function OnMouseUp(vector vTarget)
	{
		GoToState('Seeking');
		MyTarget=vTarget;
	}
Begin:
	
	
	MoveTo(MyTarget);
	GoToState('Idle');
}


DefaultProperties
{
	CameraClass=class'OrkCamera'
	InputClass=class'OrkPlayerInput'
}
