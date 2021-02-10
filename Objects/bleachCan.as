package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class bleachCan extends trippingTrap
	{
		private var bleachCount:int = 20;
		private var bleachDirection:int = 0;
		private var bleachTimer:int = 0;
		
		public function bleachCan(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new bleachCanGraphic());
			noCollideObject = bleach;
			
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
			soundChannel = startSound.play();
			
			removeChild(leftArrow);
			
			looping = true;
			

			horizontalSpeed = -3;
			rotationSpeed = -7;
			bleachDirection = 1;
			
			
			addEventListener(Event.ENTER_FRAME, addBleach);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function spill():void
		{
			addEventListener(Event.ENTER_FRAME, addBleach);
			
			if (x < 0 || x > level.actualWidth)
				looping = false;
		}
		
		private function addBleach(evt:Event)
		{
			if (bleachCount > 0)
			{
				if (bleachTimer == 0)
				{
					if (bleachDirection == 0)
					{
						level.trapList.push(level.addChild(new bleach(level,x + (width/2),y,3,bleachCan)));
					}
					
					else
					{
						level.trapList.push(level.addChild(new bleach(level,x - (width/2),y,-3,bleachCan)));
					}
					
					bleachCount --;
					bleachTimer = 5;
				}
				
				bleachTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addBleach);
		}
	}
}