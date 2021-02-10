package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class TV extends stuckOnHeadTrap
	{			
		public function TV(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,new TVGraphic());
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			looping = true;
			
			if (mouseX < 0)
			{
				horizontalSpeed = 3;
				rotationSpeed = +9.3;
			}
			
			else
			{
				horizontalSpeed = -3;
				rotationSpeed = -9.3;
			}
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
	}
}