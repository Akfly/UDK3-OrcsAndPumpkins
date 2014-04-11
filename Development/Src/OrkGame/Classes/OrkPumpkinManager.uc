/**
 * 
 * OrkPumpkinManager
 * 
 * Class that considers every pumpkin in the game and controls if the game has ended
 * 
 * **/
class OrkPumpkinManager extends Actor placeable;

var int pumpkinCount;               //How many pumkins are left in the map
var array<OrkPumpkin> pumpkinList;  //The list of pumpkins left in the map
var int pumpkinsInTowers;           //Number of pumpkins that are in the tower now
var int maxPumpkins;                //max pumpkins in the world

/**
 * Adds a pumpkin to the list
 * 
 * @param   pumpkin The pumpkin to add
 * **/
function AddPumpkin(OrkPumpkin pumpkin)
{
	pumpkinCount++;
	maxPumpkins++;
	pumpkinList.AddItem(pumpkin);
}

/**
 * Removes a pumpkin from the list, and tells to the AI
 * 
 * @param   pumpkinID   the ID of the pumpkin to remove
 * **/
function RemovePumpkin(int pumpkinID)
{
	local int i;

	pumpkinCount--;
	
	for(i=0; i<pumpkinList.Length; i++)
	{
		if(pumpkinID==pumpkinList[i].ID)
		{
			pumpkinList.RemoveItem(pumpkinList[i]);
		}
	}

	OrkGameInfo(WorldInfo.Game).enemyC.PumpkinRemoved(pumpkinID);
}

/**
 * Checks if the match has ended
 * **/
function CheckGameOver()
{
    local Sequence GameSeq;
    local array<SequenceObject> AllSeqEvents;
	local int i;

	if(pumpkinsInTowers >= maxPumpkins)
	{
		GameSeq = WorldInfo.GetGameSequence();
		if(GameSeq != None)
		{
		   GameSeq.FindSeqObjectsByClass(class'OrkSeq_Event_GameOver', true, AllSeqEvents); //ITERATE OVER ALL EVENTS OF SOME TYPE (YOU HAVE ONLY ONE)
		   for(i=0; i<AllSeqEvents.Length; i++)
		   {
			  OrkSeq_Event_GameOver(AllSeqEvents[i]).CheckActivate(WorldInfo, None); //TRIGGER IT
		   }
		}
	}
}

DefaultProperties
{
	pumpkinCount=0
	pumpkinsInTowers=0
	maxPumpkins=0
}
