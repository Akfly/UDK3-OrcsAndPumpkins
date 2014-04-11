/**
 * 
 * OrkEnemyController
 * 
 * Class that represent the AI of the enemy
 * 
 * **/
class OrkEnemyController extends GameAIController;

var OrkPumpkin  targetPumpkin;      //The pumpkin that I want to take next
var int         targetPumpkinID;    //The ID of the pumpkin that I want to take next
var Actor       targetAI;           //The target actor that is located where I want to go. Usually a pumpkin or my Tower
var vector      targetAILocation;   //The location where I want to go
var() Vector    TempDest;           //A temporary destination. If I'm in a NavMesh's Polygon which doesn't have my target, I want to know the position where I want to go in that polygon
var bool        bPumpkinCollected;  //If we collected the pumpkin that we are pursuing

var(Ork) OrkPumpkinCollectionArea   myTower;
var array<PathNode>                 PathNodeList;   //List of every node of the path that I should follow to reach my destination

/**
 * 
 * Called immediately before gameplay begins.
 * 
 * **/
event PreBeginPlay()
{
	super.PreBeginPlay();
	OrkGameInfo(WorldInfo.Game).enemyC = self;
}

/** 
 *  
 * Handles attaching this controller to the specified
 * pawn.
 * 
 * **/
event Possess(Pawn inPawn, bool bVehicleTransition)
{
	super.Possess( inPawn, bVehicleTransition );
	Pawn.SetMovementPhysics();
	myTower = OrkEnemyPawn(Pawn).myTower;
}

/**
 * 
 * Scripting hook to move this AI to a specific actor.
 * 
 * **/
function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
	local Actor DestActor;
	local SeqVar_Object ObjVar;

	DestActor = none;
	// abort any previous latent moves
	ClearLatentAction(class'SeqAct_AIMoveToActor',true,Action);

	// if we found a valid destination
	if (DestActor != None)
	{
		// set the target and push our movement state
		ScriptedRoute = Route(DestActor);
		if (ScriptedRoute != None)
		{
			if (ScriptedRoute.RouteList.length == 0)
			{
				`warn("Invalid route with empty MoveList for scripted move");
			}
			else
			{
				ScriptedRouteIndex = 0;
				if (!IsInState('ScriptedRouteMove'))
				{
					PushState('ScriptedRouteMove');
				}
			}
		}
		else
		{
			// MT->pop existing state if there is one
			if(IsInState('ScriptedMove'))
			{
				PopState(true);
			}
			ScriptedMoveTarget = DestActor;
			PushState('ScriptedMove');
		}
		// set AI focus, if one was specified
		ScriptedFocus = None;
		foreach Action.LinkedVariables(class'SeqVar_Object', ObjVar, "Look At")
		{
			ScriptedFocus = Actor(ObjVar.GetObjectValue());
			if (ScriptedFocus != None)
			{
				break;
			}
		}
	}
	else
	{
		`warn("Invalid destination for scripted move");
	}
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
	local bool bMatineeIsPlaying;
	bMatineeIsPlaying = OrkPlayerController(GetALocalPlayerController()).bMatineeIsPlaying ;

	super.Tick(DeltaTime);

	//If the Matinee intro is playing, I should not start playing :S
	if( bMatineeIsPlaying )
	{
		if(GetStateName() != 'Idle')
		{
			GoToState('Idle');
		}
	}
	else
	{
		//If Matinee is not playing, I should move now........
		if(GetStateName() == 'Idle')
		{
			GoToState('SearchPumpkin');
		}
	}
}

/**
 * Searches for a pumpkin and if found, set it as a target
 * 
 * @return  If we found a pumpkin or not
 * 
 * **/
function bool LookForPumpkins()
{
	local array<OrkPumpkin> pList;      //List of pumpkins in the map
	local float minDist, actualDist;    //used to get the nearest
	local int i, minID;

	pList = OrkGameInfo(WorldInfo.Game).pManager.pumpkinList;
	
	//If there are no pumpkins left, we return false
	if(pList.Length <= 0)
	{
		return false;	
	}

	//Set the first pumpkin as minimum distance to compare them
	minDist = VSize(pList[0].Location - Pawn.Location);
	minID = 0;

	//We compare each pumpkin, if we found one closer, 
	//we take that pumkin instead of the previous one
	for(i=1; i<pList.Length; i++)
	{
		actualDist = VSize(pList[i].Location - Pawn.Location);
		if(actualDist < minDist)
		{
			minDist = actualDist;
			minID = i;
		}
	}

	targetPumpkin = pList[minID];
	targetPumpkinID = targetPumpkin.ID;

	return true;
}

function PumpkinRemoved(int pID);

auto state Idle
{
Begin:
}

state SearchPumpkin
{
Begin:
	//If we found a pumkin, we go for it
	if(LookForPumpkins())
	{
		if(OrkPawn(Pawn).pumpkinCount < OrkPawn(Pawn).maxPumpkins)
		{
			GoToState('GoToPumpkin');
		}
		else
		{
			GoToState('ReturnToTower');
		}
	}
	else
	{
		//If there are no pumpkins and we have some on our head, we, return to our tower
		//else we just wait, there's nothing more to do
		if(OrkPawn(Pawn).pumpkinCount > 0)
		{
			GoToState('ReturnToTower');
		}
		else
		{
			GoToState('Wait');
		}
	}
}

state GoToPumpkin
{
	/**
	 * 
	 * Function called if a pumpkin on the map disappeared.
	 * If it is the pumpkin we wanted to get, 
	 * we should change our target
	 * 
	 * @param   pID The removed pumpkin ID
	 * 
	 * **/
	function PumpkinRemoved(int pID)
	{
		if(pID == targetPumpkinID)
		{
			if(OrkPawn(Pawn).pumpkinCount < OrkPawn(Pawn).maxPumpkins)
			{
				GoToState('SearchPumpkin');
			}
			else
			{
				GoToState('ReturnToTower');
			}
		}
	}

	/**
	 * 
	 * Seraches for path from our position to the target
	 * through the navMesh
	 * 
	 * **/
	function bool FindNavMeshPath()
	{
		// Clear cache and constraints (ignore recycling for the moment)
		NavigationHandle.PathConstraintList = none;
		NavigationHandle.PathGoalList = none;

		// Create constraints
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,targetAI );
		class'NavMeshGoal_At'.static.AtActor( NavigationHandle, targetAI );

		// Find path
		return NavigationHandle.FindPath();
	}

Begin:

	//sets the target
	targetAI=targetPumpkin;
	targetAILocation=targetAI.Location;
	bPumpkinCollected=false;

	//If there are no target, search again
	if(targetAI == none)
	{
		GoToState('SearchPumpkin');
	}
	
	NavigationHandle.SetFinalDestination(targetAILocation);

	if( !NavigationHandle.ActorReachable( targetAI) )
		{
			if( FindNavMeshPath() )
			{
				//`log("FindNavMeshPath returned TRUE");
				FlushPersistentDebugLines();
				NavigationHandle.DrawPathCache(,TRUE);
			}
			else
			{
				//give up because the nav mesh failed to find a path
				`warn("FindNavMeshPath failed to find a path to"@targetAI);
				targetAI = None;
			}   
		}
		else
		{
			// then move directly to the actor
			MoveTo( targetAILocation,ScriptedFocus,10 );

		}

		//while we haven't reached our destination
		while( Pawn != None && targetAI != None && !Pawn.ReachedDestination(targetAI) && !bPumpkinCollected)
		{				
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				// suggest move preparation will return TRUE when the edge's
			    // logic is getting the bot to the edge point
					// FALSE if we should run there ourselves
				if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
				{
					MoveTo( TempDest, ScriptedFocus,10 );						
				}
			}
		}

	//if we have some space left for more pumpkins, we look for more
	//else we return to our base
	if(OrkPawn(Pawn).pumpkinCount < OrkPawn(Pawn).maxPumpkins)
	{
		GoToState('SearchPumpkin');
	}
	else
	{
		GoToState('ReturnToTower');
	}
}

state ReturnToTower
{
	/**
	 * 
	 * Seraches for path from our position to the target
	 * through the navMesh
	 * 
	 * **/
	function bool FindNavMeshPath()
	{
		// Clear cache and constraints (ignore recycling for the moment)
		NavigationHandle.PathConstraintList = none;
		NavigationHandle.PathGoalList = none;

		// Create constraints
		class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,targetAI );
		class'NavMeshGoal_At'.static.AtActor( NavigationHandle, targetAI );

		// Find path
		return NavigationHandle.FindPath();
	}
Begin:
	
	//sets the target
	targetAI=myTower;
	targetAILocation=targetAI.Location;
	bPumpkinCollected=false;

	if(targetAI == none)
	{
		GoToState('SearchPumpkin');
	}
	
	NavigationHandle.SetFinalDestination(targetAILocation);

	if( !NavigationHandle.ActorReachable( targetAI) )
		{
			if( FindNavMeshPath() )
			{
				//`log("FindNavMeshPath returned TRUE");
				FlushPersistentDebugLines();
				NavigationHandle.DrawPathCache(,TRUE);
			}
			else
			{
				//give up because the nav mesh failed to find a path
				`warn("FindNavMeshPath failed to find a path to"@targetAI);
				targetAI = None;
			}   
		}
		else
		{
			// then move directly to the actor
			MoveTo( targetAILocation,ScriptedFocus,10 );

		}

		//if we reached the tower area, we should stop
		while( Pawn != None && targetAI != None && !Pawn.ReachedDestination(targetAI) && OrkEnemyPawn(Pawn).pumpkinCount > 0)
		{				
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
				// suggest move preparation will return TRUE when the edge's
			    // logic is getting the bot to the edge point
					// FALSE if we should run there ourselves
				if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
				{
					MoveTo( TempDest, ScriptedFocus,10 );						
				}
			}
		}

	
	GoToState('SearchPumpkin');
}

state Wait
{
Begin:
	GoToState('SearchPumpkin');
}

DefaultProperties
{
	bPumpkinCollected=false
}