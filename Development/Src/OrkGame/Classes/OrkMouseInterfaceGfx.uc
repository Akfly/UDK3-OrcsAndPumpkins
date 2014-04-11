/**
 * 
 * OrkMouseInterfaceGfx
 * 
 * The ScaleForm Flash Interface for the mouse. 
 * 
 * **/
class OrkMouseInterfaceGfx extends GFxMoviePlayer;

var vector2d    MousePosition;     //Mouse X and Y position on the screen
var OrkHUD      TheHUD;            //The Main Game HUD

/**
 * If the mouse moves, we set the new mouse position.
 * 
 * @param   X   the new X position
 * @param   Y   the new Y position
 * **/
function OnMouseMove( int X, int Y )
{
	MousePosition.X = X;
	MousePosition.Y = Y;
}

/**
 * Called when the mouse releases a button
 * @param   X   The X position of the mouse
 * @param   Y   The Y position of the mouse
 * @param   Btn The mouse button that has been released
 * **/
function OnMouseUp( int X, int Y, int Btn )
{
	//Left Mouse
	if ( Btn == 0 )
	{
		TheHUD.OnMouseUp();
	}
}

DefaultProperties
{
	MovieInfo=SwfMovie'OrkMouse.OrkMouse'
	bDisplayWithHudOff=false
}