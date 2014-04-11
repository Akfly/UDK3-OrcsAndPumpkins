/**
 * 
 * OrkPauseMenuInterfaceGfx
 * 
 * The ScaleForm Flash Interface for the menu that 
 * will show up when the game is paused.
 * 
 * **/
class OrkPauseMenuInterfaceGfx extends GFxMoviePlayer;

var GFxObject MC_Root;          //Flash root
var GFxObject MC_PlayButton;    //Resume Button
var GFxObject MC_ExitButton;    //Leave game button

var bool bIsVisible;    //If the menu is visible or not
var OrkHUD TheHUD;  //Used for resume game

var float     playX, playY, playWidth, playHeight,  //Resume button's data
			exitX, exitY, exitWidth, exitHeight;    //Leave button's data


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
		MC_PlayButton = MC_Root.GetObject("Resumeb");
		MC_ExitButton = MC_Root.GetObject("Leaveb");

		//Resume button

		if ( MC_PlayButton != none )
		{
			MC_PlayButton.GetPosition(playX, playY);
			playWidth = MC_PlayButton.GetFloat("bWidth");
			playHeight = MC_PlayButton.GetFloat("bHeight");
		}

		//Leave Button
		if( MC_ExitButton != none )
		{
			MC_ExitButton.GetPosition(exitX, exitY);
			exitWidth = MC_ExitButton.GetFloat("bWidth");
			exitHeight = MC_ExitButton.GetFloat("bHeight");
		}
	}
}

/**
 * If the mouse is over the Resume Button
 * 
 * @param _x    The X coordinates of the mouse
 * @param _y    The Y coordinates of the mouse
 * @return      TRUE if the menu is visible and the mouse is over the button, FALSE otherwise
 * **/
function bool IsResumeInBounds(int _x, int _y)
{
	return ( bIsVisible &&
		( _x > playX && _x < playX + playWidth  &&
		_y > playY && _y < playY + playHeight ));
}

/**
 * If the mouse is over the Leave Game Button
 * 
 * @param _x    The X coordinates of the mouse
 * @param _y    The Y coordinates of the mouse
 * @return      TRUE if the menu is visible and the mouse is over the button, FALSE otherwise
 * **/
function bool IsLeaveInBounds(int _x, int _y)
{
	return ( bIsVisible &&
		( _x > exitX && _x < exitX + exitWidth  &&
		_y > exitY && _y < exitY + exitHeight ));
}

/**
 * Leave Game Button's action, which is return to the Game Menu
 * **/
function LeaveAction()
{
	//Return to Game Menu
	ConsoleCommand("open MainMenu");
}

/**
 * Changes the visibility of the Menu
 * 
 * @param   _isVisible  If the HUD will be visible or not
 * **/
function SetVisibility(bool _isVisible)
{
	if(MC_Root != none)
	{
		MC_Root.SetVisible(_isVisible);
	}
	bIsVisible = _isVisible;
}

/**
 * Called when the mouse releases a button, 
 * and performs an action if the mouse is over a button
 * 
 * @param   xpos   The X position of the mouse
 * @param   ypos   The Y position of the mouse
 * **/
function MouseUp(int xpos, int ypos)
{
	//If the menu is hidden, we do nothing
	if(!bIsVisible)
	{
		return;
	}

	//Resume Game
	if(IsResumeInBounds(xpos, ypos))
	{
		theHUD.ResumeGame();
	}
	//Leave Game
	else if(IsLeaveInBounds(xpos, ypos))
	{
		ConsoleCommand("open MainMenu");
	}
}

DefaultProperties
{
	MovieInfo=SwfMovie'OrkPauseMenu.OrkPauseMenu'
	bIsVisible=false
}
