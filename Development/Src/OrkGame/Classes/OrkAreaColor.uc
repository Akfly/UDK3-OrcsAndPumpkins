/**
 * 
 * OrkAreaColor
 * 
 * A light that visually represents the area of the OrkPumpkinCollectionArea
 * 
 * **/
class OrkAreaColor extends SpotLightMovable;

var float lightZOffset;

function PostBeginPlay()
{
	local vector newLocation;  //The new position of the light, we don't want it inside the tower 

	super.PostBeginPlay();

	//We set the new offset of the light
	newLocation = Location;
	newLocation.Z += lightZOffset;
	self.SetLocation(newLocation);

	//Lights On!!
	self.LightComponent.SetEnabled(true);
}

DefaultProperties
{
	Begin Object Name=SpotLightComponent0
		LightColor=(R=0,G=255,B=0)
		InnerConeAngle=100
		OuterConeAngle=100
		Radius=500
		Brightness=5000
	End Object

	bNoDelete=false
	bStatic = false

	lightZOffset=200
}