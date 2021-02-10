package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class paintPot extends stuckOnHeadTrap
	{			
		public function paintPot(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,new paintPotGraphic());
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
				leftArrow.x = graphic.width/2;
				leftArrow.y = 0;
				
				addChild(rightArrow = new RightArrow());
				rightArrow.x = -graphic.width/2;
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