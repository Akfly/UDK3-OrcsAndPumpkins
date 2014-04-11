package  {
	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class MinimapArrow extends MovieClip 
	{
		
		private var _arrowRotation:Number;
		
		public function MinimapArrow() 
		{
			// constructor code
			_arrowRotation=0;
			UpdateArrow();
		}
		
		public function get arrowRotation():Number
		{
			return _arrowRotation;
		}
		
		public function set arrowRotation(rot:Number)
		{
			_arrowRotation = rot;
			UpdateArrow();
		}
		
		function UpdateArrow()
		{
			this.rotation = _arrowRotation;
		}

	}
	
}
