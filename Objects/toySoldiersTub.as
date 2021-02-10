package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;

	
	public class toySoldiersTub extends trippingTrap
	{
		private var soldierCount:int = 5;
		private var soldierTimer:int = 0;
		private var soldierDirection = 0;
		
		public function toySoldiersTub(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new toySoldierTubGraphic());
			noCollideObject = toySoldier;
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
			removeChild(leftArrow);
			removeChild(rightArrow);
			
			addEventListener(Event.ENTER_FRAME, addSoldiers);
			looping = true;
			
			
			if (mouseX < 0)
			{
				soldierDirection = 0;
				horizontalSpeed = 1;
				rotationSpeed = 9.3;
			}
			
			else
			{
				soldierDirection = 1;
				horizontalSpeed = -1;
				rotationSpeed = -9.3;
			}
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function spill():void
		{
			addEventListener(Event.ENTER_FRAME, addSoldiers);
		}
		
		private function addSoldiers(evt:Event):void
		{
			if (soldierCount > 0)
			{
				if (soldierTimer == 0)
				{
					if (soldierDirection == 0)
						level.trapList.push(level.addChild(new toySoldier(level,x + (width/2)/* + ((Math.random() - 0.5) * 5)*/,y,4,toySoldiersTub)));
					
					else
						level.trapList.push(level.addChild(new toySoldier(level,x - (width/2)/* - ((Math.random() - 0.5) * 5)*/,y,-4,toySoldiersTub)));
					
					soldierCount --;
					soldierTimer = 5;
				}
				
				soldierTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addSoldiers);
		}
	}
}