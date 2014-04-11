/**
 * 
 * OrkPlayerPawn
 * 
 * The pawn of the player.
 * 
 * **/
class OrkPlayerPawn extends OrkPawn;

var(Esne) PointLightComponent LightComponent;

/**
 * Called immediately after gameplay begins.
 * **/
event PostBeginPlay()
{
	super.PostBeginPlay();
	//Declare the team
	Team = TowerTeams.Blue;
}

DefaultProperties
{
	Begin Object Class=PointLightComponent Name=MyLightComponent
		CastShadows=false
		Translation=(Z=300)
	End Object
	LightComponent=MyLightComponent
	Components.Add( MyLightComponent )
}
