/**
 * 
 * OrKPumpkinCollectionArea
 * 
 * Tower where the pumpkins must be delivered
 * 
 * **/
class OrKPumpkinCollectionArea extends Actor placeable;

enum TowerTeams
{
	Blue,
	Red
};

var OrkAreaColor    LightArea;      //The light that defines the area where the pumpkins are delivered
var int             pumpkinCount;   //How many pumpkins do we have
var(Ork) TowerTeams Team;           //Which team we belong

/**
 * Called immediately after gameplay begins.
 * **/
event PostBeginPlay()
{
	local rotator lrot;
	local Color newColor;

	super.PostBeginPlay();

	//Spawns the light
	lrot = Rotation;
	lrot.Pitch += -90 * DegToUnrRot;
	LightArea = Spawn(class'OrkAreaColor',self,,Location,lrot);

	//Sets the light color depending on the team
	if(Team == TowerTeams.Blue)
	{
		newColor.R=0;
		newColor.G=0;
		newColor.B=255;
		LightArea.LightComponent.SetLightProperties(,newColor);
	}
	else if (Team == TowerTeams.Red)
	{
		newColor.R=255;
		newColor.G=0;
		newColor.B=0;
		LightArea.LightComponent.SetLightProperties(,newColor);
	}

	SetCollision(true,false);
	pumpkinCount=0;
}

/**
 * Tells if we are of the given team or not
 * @param   tname   The name of the team
 * @return  if the teams are the same or not
 * **/
function bool CompareTeam(name tname)
{
	return (tname == GetEnum(Enum'TowerTeams', Team));
}

/**
 * Adds a pumpkin to the tower
 * **/
function AddPumpkin()
{
	pumpkinCount++;
	OrkGameInfo(WorldInfo.Game).pManager.pumpkinsInTowers++;
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MyMesh
		StaticMesh=StaticMesh'OrkGameplay.Meshes.guard_tower'
		Scale=0.4
	End Object
	Components.Add(MyMesh)

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=450.0
		CollisionHeight=100.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=false
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}
