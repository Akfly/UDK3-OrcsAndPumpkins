package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	public class Mouse extends MovieClip {

		public function Mouse()
		{
			stage.addEventListener( MouseEvent.MOUSE_MOVE, OnMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, OnMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, OnMouseDown );
		}

		public function OnMouseMove(e:MouseEvent)
		{
			this.x = root.mouseX;
			this.y = root.mouseY;
			
			ExternalInterface.call( "OnMouseMove", this.x, this.y );
		}
		
		public function OnMouseUp(e:MouseEvent)
		{
			ExternalInterface.call( "OnMouseUp", this.x, this.y);
		}
		
		public function OnMouseDown(e:MouseEvent)
		{
			ExternalInterface.call( "OnMouseDown", this.x, this.y);
		}
	}
	
}
