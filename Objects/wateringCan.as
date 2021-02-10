package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class wateringCan extends trippingTrap
	{
		private var waterCount:int = 20;
		private var waterDirection:int = 0;
		private var waterTimer:int = 0;
		
		public function wateringCan(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new wateringCanGraphic());
			noCollideObject = water;
			
			startSound = new glugGlugGlug();
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
				
				addChild(leftArrow = new LeftArrow());
				leftArrow.x = (graphic.width / 2) + 2;
				leftArrow.y = 0;
				
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
				
				leftArrow.scaleX = 1.5;
			}
			
			else if (leftArrow.scaleX != 1)
			{
				leftArrow.scaleX = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleX = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			if (startSound != null)
			{
				soundChannel = startSound.play();
			}
			
			removeChild(leftArrow);
			
			looping = true;
			

			horizontalSpeed = -3;
			rotationSpeed = -7;
			waterDirection = 1;
			
			
			addEventListener(Event.ENTER_FRAME, addWater);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function spill():void
		{
			addEventListener(Event.ENTER_FRAME, addWater);if (x < 0 || x > level.actualWidth)
				looping = false;
		}
		
		private function addWater(evt:Event)
		{
			if (waterCount > 0)
			{
				if (waterTimer == 0)
				{
					if (waterDirection == 0)
					{
						level.trapList.push(level.addChild(new water(level,x + (width/2),y,2,wateringCan)));
					}
					
					else
					{
						level.trapList.push(level.addChild(new water(level,x - (width/2),y,-2,wateringCan)));
					}
					
					waterCount --;
					waterTimer = 5;
				}
				
				waterTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addWater);
		}
	}
}