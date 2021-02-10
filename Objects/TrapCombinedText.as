package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TrapCombinedText extends MovieClip
	{ 	
		private var verticalSpeed:Number = -1;
								
		public function TrapCombinedText(X = 0,Y = 0)
		{  			
			x = X;
			y = Y;
			
			addEventListener (Event.ENTER_FRAME, loop, false, 0, true);		
		}
		
		private function loop(evt:Event):void
		{
			y += verticalSpeed;
			verticalSpeed += 0.01;
			alpha -= 0.01;
			
			if (alpha == 0 || verticalSpeed >= 0)
			{
				removeEventListener (Event.ENTER_FRAME, loop);		
				parent.removeChild(this);
			}
		}
	}
}