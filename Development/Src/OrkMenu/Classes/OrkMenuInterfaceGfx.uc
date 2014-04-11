/**
 * 
 * OrkMenuInterfaceGfx
 * 
 * Flash interface for the OrkGame's main menu
 * 
 * **/

class OrkMenuInterfaceGfx extends GFxMoviePlayer;

var GFxObject MC_Root;          //Flash Root
var GFxObject MC_PlayButton;    //Flash Play Button
var GFxObject MC_ExitButton;    //Flash Exit Button

var float     playX, playY, playWidth, playHeight,  //Play Button's position and size, used to detect mouse collision
			exitX, exitY, exitWidth, exitHeight;    //Exit Button's position and size, used to detect mouse collision

/**
 * Initialize function
 * **/
event bool Start(optional bool StartPaused = false)
{
	super.Start( StartPaused );
	Advance(0);

	Configure();

	return true;
}

/**
 * Configure Unreal variables to work with the Flash enviroment
 * **/
function Configure()
{
	//Root
	MC_Root = GetVariableObject( "root" );
	
	if ( MC_Root != none )
	{
		//Buttons
		MC_PlayButton = MC_Root.GetObject("Playb");
		MC_ExitButton = MC_Root.GetObject("Exitb");


		//Play button's data
		if ( MC_PlayButton != none )
		{
			MC_PlayButton.GetPosition(playX, playY);
			playWidth = MC_PlayButton.GetFloat("bWidth");
			playHeight = MC_PlayButton.GetFloat("bHeight");
		}

		//Exit button's data
		if( MC_ExitButton != none )
		{
			MC_ExitButton.GetPosition(exitX, exitY);
			exitWidth = MC_ExitButton.GetFloat("bWidth");
			exitHeight = MC_ExitButton.GetFloat("bHeight");
		}
	}
}

/**
 * Function called when the mouse button is released
 * 
 * @param   X   Mouse X position on the screen
 * @param   Y   Mouse Y position on the screen
 * **/
function OnMouseUp(float X, float Y)
{
	if( X > playX && X < playX + playWidth  &&
		Y > playY && Y < playY + playHeight )
	{
		//Start map
		ConsoleCommand("open OrkJazz");
	}
	else if( X > exitX && X < exitX + exitWidth  &&
		Y > exitY && Y < exitY + exitHeight )
	{
		//Leave Game
		ConsoleCommand("quit");
	}
}

DefaultProperties
{
	MovieInfo=SwfMovie'OrkMainMenu.OrkMainMenu'
}