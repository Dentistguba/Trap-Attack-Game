package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class kettle extends trippingTrap
	{
		private var steamCount:int = 50;
		private var steamTimer:int = 2;
		
		public function kettle(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new kettleGraphic());
			
			startSound = new KettleSound();
		}
		
		override public function changeMode():void
		{
			removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			removeEventListener (Event.ENTER_FRAME, addEndDragListener);
			
			
			boxGraphic.alpha = 0;
			
			filters = [];
			
			if (hanging == false)
			{
				
				addChild(leftArrow = new LeftUpArrow());
				leftArrow.x = (-graphic.width / 2) - 5;
				leftArrow.y = -height/2 + 5;
				
				boxGraphic.width = width;
				boxGraphic.x += leftArrow.width;
				
				addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
				level.addEventListener (MouseEvent.MOUSE_MOVE, mouseHover)
			}
		}
		
		private function mouseHover(evt:MouseEvent):void
		{
			if (mouseX > -(width/2) && mouseX < width/2 && mouseY > -(height/2) && mouseY < height/2)
			{
				trace('mouseOver');
				
				leftArrow.scaleX = 1.25;
				leftArrow.scaleY = 1.25;
			}
			
			else if (leftArrow.scaleX != 1)
			{
				leftArrow.scaleX = 1;
				leftArrow.scaleY = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleX = 1;
			leftArrow.scaleY = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			soundChannel = startSound.play();
			
			removeChild(leftArrow);
			
			looping = true;
			
			addEventListener(Event.ENTER_FRAME, addSteam);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function addSteam(evt:Event):void
		{
			if (steamCount > 0)
			{
				if (steamTimer == 0)
				{
					level.trapList.push(level.addChild(new Steam(level,x - (graphic.width/2) + ((Math.random() - 0.5) * 2),y - (graphic.height/2) + 5)));
									
					steamCount --;
					steamTimer = 2;
				}
				
				steamTimer --;
			}
			
			else
			{
				soundChannel.stop;
				removeEventListener(Event.ENTER_FRAME, addSteam);
			}
		}
	}
}