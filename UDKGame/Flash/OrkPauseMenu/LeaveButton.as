package  {
	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	public class LeaveButton extends SimpleButton{

		private var _bWidth:Number;
		private var _bHeight:Number;
		
		public function LeaveButton() {
			// constructor code
			this.x = (stage.width/2) - (this.width/2);
			this.y = 200;
			_bWidth = this.width;
			_bHeight = this.height;
		}
		
		public function get bWidth():Number
		{
			return _bWidth;
		}
		
		public function get bHeight():Number
		{
			return _bHeight;
		}

	}
	
}
