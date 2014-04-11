/**
 * 
 * OrkMenuHUD
 * 
 * HUD of the Menu
 * **/
class OrkMenuHUD extends HUD;

var OrkMenuInterfaceGfx MenuInterface;      //The flash interface

event PostBeginPlay()
{
	super.PostBeginPlay();

	//Initializing of the flash interface
	MenuInterface = new class'OrkMenuInterfaceGfx';
	MenuInterface.Start();
}

DefaultProperties
{
}
