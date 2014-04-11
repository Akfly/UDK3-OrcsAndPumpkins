/**
 * 
 * OrkPumpkin
 * 
 * Pumpkins that are distributed along the map
 * 
 * **/
class OrkPumpkin extends Actor placeable;

var float       MaxZPos;    //Max height offset (before PostBeginPlay) and position (after PostBeginPlay)
var float       iniPos;     //the initial Z position of the pumpkin
var(Ork) float  RPS;        //Rotations Per Second
var bool        bGoUp;      //If the pumpkin is moving up or down
var int         ID;

/**
 * Called immediately after gameplay begins.
 * **/
event PostBeginPlay()
{
	super.PostBeginPlay();

	iniPos = Location.Z;

	MaxZPos = iniPos + MaxZPos;
	bGoUp=true;

	SetCollision(true,false);

	OrkGameInfo(WorldInfo.Game).pManager.AddPumpkin(self);
	ID = OrkGameInfo(WorldInfo.Game).GeneratePumpkinID();
}

/**
 * 
 * Called every frame
 * 
 * @param   DeltaTime   Time elapsed from the last frame to this one
 * 
 * **/
event Tick(float DelTaTime)
{
	local vector    newPos;
	local rotator 	NewRotation;

	super.Tick(DelTaTime);

	//Sets the rotation
	NewRotation = Rotation;
	NewRotation.Yaw += RPS * 360.0 * DegToUnrRot * DeltaTime;
	SetRelativeRotation( NewRotation );
	
	//Moves the pumpkin up or down, if it reaches  the max Z pos,
	//then it changes direction
	if(bGoUp)
	{
		newPos = Location;
		newPos.Z += 1;
		self.SetLocation(newPos);

		if(newPos.Z > MaxZPos)
		{
			bGoUp=false;
		}
	}
	else
	{
		newPos = Location;
		newPos.Z -= 1;
		self.SetLocation(newPos);

		if(newPos.Z < iniPos)
		{
			bGoUp=true;
		}
	}
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MyMesh
	StaticMesh=StaticMesh'OrkGameplay.Effects.pumpkin_04_02_a'
	End Object
	Components.Add(MyMesh)

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=25.0
		CollisionHeight=20.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=false
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	MaxZPos = 15
	RPS=1.0
	DrawScale=2
}