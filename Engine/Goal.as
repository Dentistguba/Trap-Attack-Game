package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class Goal extends MovieClip
	{
		public var Complete:Boolean = false;
		
		public function Goal(X,Y)
		{
			x = X;
			y = Y;
		}
		
		public function makeComplete():void
		{
			Complete = true;
			MovieClip(parent).checkGoals();
			trace ('goal complete');
		}
	}
}