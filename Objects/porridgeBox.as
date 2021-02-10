package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class porridgeBox extends trippingTrap
	{
		private var porridgeCount:int = 20;
		private var porridgeTimer:int = 5;
		private var porridgePowderCount:int = 5;
		private var porridgePowderTimer:int = 2;
		private var porridgeDirection:int = 0;
		
		public function porridgeBox(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new porridgeBoxGraphic());
			
			startSound = new Poof();
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
				boxGraphic.scaleX = 4;
				addChild(leftArrow = new LeftArrow());
				leftArrow.x = 15;
				leftArrow.y = 0;
				
				addChild(rightArrow = new RightArrow());
				rightArrow.x = -15;
				rightArrow.y = 0;
				
				addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
				level.addEventListener (MouseEvent.MOUSE_MOVE, mouseHover)
			}
		}
		
		private function mouseHover(evt:MouseEvent):void
		{
			if (mouseX > -(width/2) && mouseX < width/2 && mouseY > -(height/2) && mouseY < height/2)
			{
				trace('mouseOver');
				
			
				if (mouseX < 0)
				{
					rightArrow.scaleX = 1.5;
					leftArrow.scaleX = 1;
				}
				
				else
				{
					leftArrow.scaleX = 1.5;
					rightArrow.scaleX = 1;
				}
			}
			
			else if (leftArrow.scaleX != 1 || rightArrow.scaleX != 1)
			{
				leftArrow.scaleX = 1;
				rightArrow.scaleX = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleX = 1;
			rightArrow.scaleX = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			soundChannel = startSound.play();
			
			removeChild(leftArrow);
			removeChild(rightArrow);
			
			looping = true;
			
			if (mouseX < 0)
			{
				porridgeDirection = 0;
				horizontalSpeed = 2;
				rotationSpeed = +9.3;
			}
			
			else
			{
				porridgeDirection = 1;
				horizontalSpeed = -2;
				rotationSpeed = -9.3;
			}
			
			addEventListener(Event.ENTER_FRAME, addPorridge);
			addEventListener(Event.ENTER_FRAME, addPorridgePowder);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		
		
		public function addPorridge(evt:Event):void
		{
			if (porridgeCount > 0)
			{
				if (porridgeTimer == 0)
				{
					if (porridgeDirection == 0)
						level.trapList.push(level.addChild(new Porridge(level,x + (width/2),y - (height/2))));
									
					else
						level.trapList.push(level.addChild(new Porridge(level,x - (width/2),y - (height/2))));
									
					porridgeCount --;
					porridgeTimer = 5;
				}
				
				porridgeTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addPorridge);
		}
		
		public function addPorridgePowder(evt:Event):void
		{
			if (porridgePowderCount > 0)
			{
				if (porridgePowderTimer == 0)
				{
					if (porridgeDirection == 0)
						level.trapList.push(level.addChild(new porridgePowder(level,x + (width/2),y - (height/2),5)));
									
					else
						level.trapList.push(level.addChild(new porridgePowder(level,x - (width/2),y - (height/2),-5)));
									
					porridgePowderCount --;
					porridgePowderTimer = 5;
				}
				
				porridgePowderTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addPorridgePowder);
		}
	}
}