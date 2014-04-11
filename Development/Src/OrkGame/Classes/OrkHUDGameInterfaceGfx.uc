/**
 * 
 * OrkHUDGameInterfaceGfx
 * 
 * The ScaleForm Flash Interface of the HUD. 
 * Which by now it only includes the map.
 * 
 * **/
class OrkHUDGameInterfaceGfx extends GFxMoviePlayer;

var GFxObject MC_Root;          //Flash root
var GFxObject MC_MiniMap;       //The minimap element
var GFxObject MC_MiniMapArrow;  //The arrow inside the minimap

var float   ArrowRotation;      //Angle in degrees of the arrow, being 0 looking at North
var bool    bIsVisible;         //If the HUD is visible or not

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
		//Minimap
		MC_MiniMap = MC_Root.GetObject("mMap");

		if(MC_MiniMap != none)
		{
			//Minimap's arrow
			MC_MiniMapArrow = MC_MiniMap.GetObject("mArrow");
			
			if(MC_MiniMapArrow != none)
			{
				ArrowRotation = MC_MiniMapArrow.GetFloat("arrowRotation");
			}
			else
			{
				MC_MiniMapArrow = MC_Root.GetObject("mArrow");
				if(MC_MiniMapArrow != none)
				{
					ArrowRotation = MC_MiniMapArrow.GetFloat("arrowRotation");
				}
			}
		}
	}
}

/**
 * Changes the minimap's arrow rotation
 * 
 * @param   DegreeRot   Rotation of the arrow in degrees, 0 is North
 * **/
function UpdateMinimapRotation(float DegreeRot)
{
	ArrowRotation = DegreeRot;
	MC_MiniMapArrow.SetFloat("arrowRotation", ArrowRotation);
}

/**
 * Changes the visibility of the HUD
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

DefaultProperties
{
	MovieInfo=SwfMovie'OrkHUDGame.OrkHUDGame'
	bIsVisible=false
}
