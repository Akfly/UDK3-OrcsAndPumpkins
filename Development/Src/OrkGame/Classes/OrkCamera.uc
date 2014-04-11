/**
 * 
 * OrkCamera
 * 
 * The Game's Camera
 * 
 * **/

class OrkCamera extends Camera;

var(Ork) vector CameraOffset;   //Relative position of the camera from the player

/**
 * Query ViewTarget and outputs Point Of View.
 *
 * @param	OutVT		ViewTarget to use.
 * @param	DeltaTime	Delta Time since last camera update (in seconds).
 * **/
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local vector    CamLocation;
	local rotator   CamRotation;
	local Pawn      ThePawn;

	super.UpdateViewTarget(OutVT, DeltaTime);

	//If we are playing a matinee movie, we don't want to override it
	if( OrkPlayerController(GetALocalPlayerController()).bMatineeIsPlaying )
	{
		return;
	}

	ThePawn=PCOwner.Pawn;

	CamLocation = ThePawn.Location + CameraOffset;
	CamRotation = rotator( ThePawn.Location - (ThePawn.Location + CameraOffset));

	OutVT.POV.Location = CamLocation;
	OutVT.POV.Rotation = CamRotation;
}

DefaultProperties
{
	CameraOffset=(X=-100,Y=0,Z=500)
}
