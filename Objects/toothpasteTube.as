package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class toothpasteTube extends slippingTrap
	{
		private var toothpasteCount:int = 20;
		private var toothpasteDirection:int = 0;
		private var toothpasteTimer:int = 0;
		
		public function toothpasteTube(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new toothpasteTubeGraphic());
			noCollideObject = toothpaste;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			looping = true;
			

			toothpasteDirection = 1;
			
			
			addEventListener(Event.ENTER_FRAME, addToothpaste);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		public function spill():void
		{
			addEventListener(Event.ENTER_FRAME, addToothpaste);if (x < 0 || x > level.actualWidth)
				looping = false;
		}
		
		private function addToothpaste(evt:Event)
		{
			if (toothpasteCount > 0)
			{
				if (toothpasteTimer == 0)
				{
					if (toothpasteDirection == 0)
					{
						level.trapList.push(level.addChild(new toothpaste(level,x + (width/2),y,0,toothpasteTube)));
					}
					
					else
					{
						level.trapList.push(level.addChild(new toothpaste(level,x - (width/2),y,-0,toothpasteTube)));
					}
					
					toothpasteCount --;
					toothpasteTimer = 5;
				}
				
				toothpasteTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addToothpaste);
		}
	}
}