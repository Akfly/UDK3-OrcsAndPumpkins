package  {
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	public class PlayButton extends SimpleButton{


		private var _bWidth:Number;
		private var _bHeight:Number;
		
		public function PlayButton()
		{
			// constructor code
			this.x = (stage.width/2) - (this.width/2);
			//this.x = 0;
			this.y = 100;
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
