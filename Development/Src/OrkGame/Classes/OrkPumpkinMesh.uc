/**
 * 
 * OrkPumpkinMesh 
 * 
 * Class that represent the pumpkins that
 * stack over the head of the pawns
 * 
 * **/
class OrkPumpkinMesh extends Object;

var MeshComponent newMesh;  //The mesh that represents the pumpkin

/**
 * Returns the own mesh
 * @return  The pumpkin mesh
 * **/
function MeshComponent GetMesh()
{
	return newMesh;
}

/**
 * Sets a new position to the mesh without moving the pivot
 * @param   rel_adv relative movement from the actual position
 * **/
function NewRelativePosition(vector rel_adv)
{
	newMesh.SetTranslation(rel_adv);
}

/**
 * Sets a new rotation to the mesh without affecting the pivot
 * @param   rel_rot relative rotation from the actual one
 * **/
function NewRelativeRotation(rotator rel_rot)
{
	newMesh.SetRotation(rel_rot);
}

/**
 * Sets a new scale to the mesh
 * @param   newscale The new scale that the mesh will have
 * **/
function NewScale(float newscale)
{
	newMesh.SetScale(newscale);
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MyMesh
	StaticMesh=StaticMesh'OrkGameplay.Effects.pumpkin_04_02_a'
	End Object
	newMesh=MyMesh;
}
