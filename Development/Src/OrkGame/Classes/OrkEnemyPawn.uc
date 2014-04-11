/**
 * OrkEnemyPawn
 * 
 * The character of the enemy
 * 
 * **/
class OrkEnemyPawn extends OrkPawn	placeable;

var(Ork) OrkPumpkinCollectionArea myTower;      //The tower where I should deliver the pumpkins

/**
 * Called immediately after gameplay begins.
 * **/
event PostBeginPlay()
{
	super.PostBeginPlay();
	Team = TowerTeams.Red;
}

/**
 * Adds a pumpkin to the pawn head
 * **/
function AddPumpkin()
{
	super.AddPumpkin();
	OrkEnemyController(Controller).bPumpkinCollected = true;
}

DefaultProperties
{
	GroundSpeed=300.0

	ControllerClass=class'OrkEnemyController'

	Begin Object Name=MyMesh
		SkeletalMesh=SkeletalMesh'OrkGameplay.Effects.old_micro_orc'
		AnimSets(0)=AnimSet'OrkGameplay.Effects.root_orc'
		AnimtreeTemplate=AnimTree'OrkGameplay.Effects.OrcAnimTree'
	End Object
}