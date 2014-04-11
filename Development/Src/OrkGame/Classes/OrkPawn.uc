/**
 * 
 * OrkPawn
 * 
 * Character that will be playing. Base class for player's and enemy's pawn
 * 
 * **/ 
class OrkPawn extends Pawn
	placeable
	ClassGroup(Ork);

//Which team I belong
enum TowerTeams
{
	Blue,
	Red
};

enum EAnimState
{
    ST_Sleeping,
    ST_Normal,
    ST_Die
};

var AnimNodeBlendList AnimNodeAnimState;
var AnimNodeSlot      AnimNodeSpecialMove;

var(Ork) const editconst SkeletalMeshComponent MySkeletalMesh;      //Mesh of the pawn

var int             pumpkinCount;               //Number of pumpkins I've collected
var int             maxPumpkins;                //max number of pumpkins that I can carry on
var float           pumpkinColumnDistance;      //Offset of each pumpkin to position them on the top of the head, so each one appears at a different position
var float           pumpkinColumnScale;         //Scale of the pumpkins that I carry on the head
var array<OrkPumpkinMesh> pumpkinMeshArray;     //Array that list every pumpkin mesh that the pawn can carry on the head

var TowerTeams Team;    //The team that I belong

/**
 * Called immediately after gameplay begins.
 * **/
event PostBeginPlay()
{
    local LightingChannelContainer Lights;

    super.PostBeginPlay();

    Lights.Unnamed_1 = true;
    MySkeletalMesh.SetLightingChannels( Lights );

    SetAnimationState( ST_Normal );
	Team = TowerTeams.Blue;
}

/**
 * Changes the animation of the AnimTree
 * 
 * @param   eState  The new animation
 * **/
function SetAnimationState( EAnimState eState )
{
    if ( AnimNodeAnimState != none )
    {
        AnimNodeAnimState.SetActiveChild( eState, 0.25 );
    }
}

/**
 * Called after initializing the AnimTree for the given SkeletalMeshComponent that has this Actor as its Owner
 * this is a good place to cache references to skeletal controllers, etc that the Actor modifies
 * 
 * @param   SkelComp    The SkeletalMeshComponent that is attatched to this Actor
 * **/
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local int i;            //for loops
	local vector newPos;    //new pumpkin positions
	local rotator newRot;   //new pumpkin rotations

	newPos.X=0;
	newPos.Y=0;
	newPos.Z=0;
	newRot.Pitch=0;
	newRot.Roll=0;
	newRot.Yaw=0;

    super.PostInitAnimTree( SkelComp );

	//Attach the animTree's nodes
    AnimNodeAnimState       = AnimNodeBlendList( SkelComp.FindAnimNode('AnimState') );
    AnimNodeSpecialMove     = AnimNodeSlot( SkelComp.FindAnimNode('SpecialMove') );

	//Creates the pumpkins on the head
	pumpkinMeshArray.Add(maxPumpkins);
	for(i=0; i<maxPumpkins; i++)
	{
		newPos.Z = pumpkinColumnDistance*i;             //new pumpkin position
		newRot.Yaw=RandRange(0, 360 * DegToUnrRot);     //new pumpkin random rotation

		//Sets the properties to the pumpkin
		pumpkinMeshArray[i] = new class'OrkPumpkinMesh';
		pumpkinMeshArray[i].NewRelativePosition(newPos);
		pumpkinMeshArray[i].NewRelativeRotation(newRot);
		pumpkinMeshArray[i].NewScale(pumpkinColumnScale);

		//Attach the pumpkin and hide it
		MySkeletalMesh.AttachComponentToSocket(pumpkinMeshArray[i].GetMesh(), 'TopHead');
		pumpkinMeshArray[i].GetMesh().SetHidden(true);
	}

}

/**
 * Called on both Actor and Other when they are touching each other. 
 * Both Actor and Other must be collidable, and either Actor or 
 * Other must use non blocking collision.
 * 
 * @param   Other       Actor that touched this Actor.
 * @param   OtherComp	Component that touched this Actor.
 * @param   HitLocation	World location where the touch occurred.
 * @param   HitNormal	Normal of the touch that occurred.
 * **/
event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local OrkPumpkin pumpkin;
	local OrKPumpkinCollectionArea tower;

	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	//If we touch a pumpkin, and can carry more pumpkins
	if(Other.Class == class'OrkPumpkin' && pumpkinCount < maxPumpkins)
	{
		AddPumpkin();
		pumpkin=OrkPumpkin(Other);
		OrkGameInfo(WorldInfo.Game).pManager.RemovePumpkin(pumpkin.ID);
		pumpkin.Destroy();
		
	}
	//If we touch our tower and have some pumpkins
	else if(Other.Class == class'OrKPumpkinCollectionArea' && pumpkinCount > 0)
	{
		tower = OrKPumpkinCollectionArea(Other);

		if(tower.CompareTeam(GetEnum(Enum'TowerTeams', Team)))
		{
			while(pumpkinCount>0)
			{
				RemovePumpkin();
				tower.AddPumpkin();
				OrkGameInfo(WorldInfo.Game).pManager.CheckGameOver();
			}
		}
	}
}

/**
 * Adds a pumpkin. Shows it on the head and increases 
 * the number of pumpkins we carry
 * **/
function AddPumpkin()
{
	pumpkinMeshArray[pumpkinCount].GetMesh().SetHidden(false);
	pumpkinCount++;
}

/**
 * Removes a pumpkin. Hides it on the head and decreases 
 * the number of pumpkins we carry
 * **/
function RemovePumpkin()
{
	pumpkinMeshArray[pumpkinCount-1].GetMesh().SetHidden(true);
	pumpkinCount--;
}

DefaultProperties
{
    Begin Object Class=SkeletalMeshComponent Name=MyMesh
        SkeletalMesh=SkeletalMesh'OrkGameplay.Effects.micro_orc'
        AnimTreeTemplate=AnimTree'OrkGameplay.Effects.OrcAnimTree'
        AnimSets(0)=AnimSet'OrkGameplay.Effects.root_orc'
    End Object
    Components.Add( MyMesh )
    MySkeletalMesh=MyMesh

	CollisionType=COLLIDE_BlockAll
    Begin Object Name=CollisionCylinder
        CollisionHeight=20
        CollisionRadius=30
    End Object

    DrawScale=0.5

    LandMovementState=Idle

    RotationRate=(Yaw=40000)

	pumpkinCount=0
	maxPumpkins=3

	pumpkinColumnDistance=15
	pumpkinColumnScale=2
}
