/**
 * 
 * OrkHUD
 * 
 * The whole HUD that appears in the game
 * 
 * **/
class OrkHUD extends HUD;

var OrkMouseInterfaceGfx 	    MouseInterface; //The mouse
var OrkPauseMenuInterfaceGfx 	PauseInterface; //Pause menu
var OrkHUDGameInterfaceGfx 	    IGHUDInstance;  //The HUD that appears ingame. Now it is only the map

var vector          MouseWorldOrigin;       //The initial mouse position in the world. Used to calculate the mouse position on the screen
var vector          MouseWorldDirection;    //The actual mouse position in the world. Used to calculate the mouse position on the screen
var vector          HitLocation;            //Where the mouse has clicked
var vector          HitNormal;              //The normal of the ray casted when the mouse clicks something

/**
 * Called immediately after gameplay begins.
 * **/
event PostBeginPlay()
{
	super.PostBeginPlay();

	//Initialize mouse
	MouseInterface = new class'OrkMouseInterfaceGfx';
	MouseInterface.TheHUD = self;
	MouseInterface.SetPriority(200);
	MouseInterface.Start();

	//Initialize Pause Menu
	PauseInterface = new class'OrkPauseMenuInterfaceGfx';
	PauseInterface.TheHUD = self;
	PauseInterface.SetPriority(100);
	PauseInterface.Start();
	PauseInterface.SetVisibility(false);

	//Initialize in-game HUD
	IGHUDInstance = new class'OrkHUDGameInterfaceGfx';
	IGHUDInstance.SetPriority(100);
	IGHUDInstance.Start();
	IGHUDInstance.SetVisibility(true);

}

/**
 * Used to initialize the mouse world position and direction
 * **/
event PostRender()
{
	super.PostRender();

	if ( Canvas != none )
	{
		Canvas.DeProject(MouseInterface.MousePosition, MouseWorldOrigin, MouseWorldDirection);
	}
}

/**
 * Shows the Pause menu and hides other HUD
 * **/
function ShowPauseMenu()
{
	PauseInterface.SetVisibility(true);
	IGHUDInstance.SetVisibility(false);
}

/**
 * Hides the Pause menu and shows other HUD
 * **/
function HidePauseMenu()
{
	PauseInterface.SetVisibility(false);
	IGHUDInstance.SetVisibility(true);
}

/**
 * Calls the game to resume it
 * **/
function ResumeGame()
{
	OrkPlayerController(WorldInfo.GetALocalPlayerController()).UnPauseGame();
}

/**
 * Moves the arrow on the mini-map
 * 
 * @param   CharDegRotation     The character rotation in degrees, so the arrow moves in that rotation
 * 
 * **/
function UpdateMinimap(float CharDegRotation)
{
	IGHUDInstance.UpdateMinimapRotation(CharDegRotation);
}

/**
 * 
 * Called every frame
 * 
 * @param   DeltaTime   Time elapsed from the last frame to this
 * 
 * **/
event Tick(float DeltaTime)
{
	UpdateMinimap(WorldInfo.GetALocalPlayerController().Pawn.Rotation.Yaw * UnrRotToDeg);
}

/**
 * Pre-Calculate most common values, to avoid doing 1200 times the same operations
 * **/
function PreCalcValues()
{
  Super.PreCalcValues();

  if (MouseInterface != None)
  {
    MouseInterface.SetViewport(0, 0, SizeX, SizeY);
    MouseInterface.SetViewScaleMode(SM_NoScale);
    MouseInterface.SetAlignment(Align_TopLeft);  
  }
}

/**
 * Function called when a mouse button is released
 * **/
function OnMouseUp()
{
	local Actor tracedA;

	//If we are playing a matinee movie, we don't want the player to play while on it
	if( OrkPlayerController(GetALocalPlayerController()).bMatineeIsPlaying )
	{
		return;
	}

	//If the game is paused, we obly want the mouse to interact with the pause Menu,
	//if not, just with the rest of the world
	if(OrkGameInfo(WorldInfo.Game).bGamePaused)
	{
		PauseInterface.MouseUp(MouseInterface.MousePosition.X, MouseInterface.MousePosition.Y);
	}
	else
	{
		tracedA = Trace(HitLocation, HitNormal, MouseWorldOrigin + MouseWorldDirection * 65536.0f , MouseWorldOrigin, true);
		//When moving, the player, we only want him to go inside the map, not to take him over any object or outside the map
		if(tracedA.Tag == 'FloorCollision')
		{
			OrkPlayerController(PlayerOwner).OnMouseUp(HitLocation);
		}
	}
}

DefaultProperties
{
	bShowOverlays=true
}

