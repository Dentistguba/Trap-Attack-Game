package
{
	import flash.display.MovieClip
	
	public class HUD extends MovieClip
	{
		private const gravity:Number = 0.9;
		private var ySpeed:Number = 0;
		
		public function HUD(X = 0,Y = 0)
		{
			x=X;
			y=Y;
			
			storyTextBoxNoSkip.visible = false
			failScreen.visible = false;
			successScreen.visible = false;
		}
	}
}