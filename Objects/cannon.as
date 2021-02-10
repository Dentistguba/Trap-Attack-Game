package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class cannon extends staticTrap
	{
		private var shellObject = null;
		
		public function cannon(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new cannonGraphic());
			
			startSound = new cannonBoom();
		}
		
		override public function changeMode():void
		{
			removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			removeEventListener (Event.ENTER_FRAME, addEndDragListener);
			
			
			boxGraphic.alpha = 0;
			
			filters = [];
			
			if (hanging == false && shellObject != null)
			{
				
				addChild(leftArrow = new LeftUpArrow2());
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
			if (startSound != null)
			{
				soundChannel = startSound.play();
			}
			
			removeChild(leftArrow);
			
			if (shellObject.leftArrow != null)
				shellObject.leftArrow.alpha = 0;
				
			if (shellObject.rightArrow != null)
				shellObject.rightArrow.alpha = 0;
			
			shellObject.x = x - width/2;
			shellObject.y = y - 10;
			
			shellObject.looping = true;
			shellObject.visible = true;
			shellObject.horizontalSpeed = - 10;
			shellObject.verticalSpeed = - 8;
			

			if (!(shellObject.width > shellObject.height))
			{
				shellObject.graphic.rotation = - 90;
				shellObject.hitBox.setRotate(- 90);
			}
			
			shellObject.x -= shellObject.width/2;
			
			
			level.addChild(new Smoke(level,x - (width/2),y));
			level.addChild(new Smoke(level,x - (width/2),y));
			level.addChild(new Smoke(level,x - (width/2),y));
			level.addChild(new Smoke(level,x - (width/2),y));
			level.addChild(new Smoke(level,x - (width/2),y));
			level.addChild(new Smoke(level,x - (width/2),y));
			
			level.addChild(new smallFire(level,x - (width/2),y));
			level.addChild(new smallFire(level,x - (width/2),y));
			level.addChild(new smallFire(level,x - (width/2),y));
			
			horizontalSpeed = 2;
			looping = true;
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function combine(Object)
		{
			//trace ('combining');
			
			level.addEventListener(MouseEvent.MOUSE_DOWN,finalise);
			
			shellObject = Object;
			shellObject.visible = false;
			shellObject.x = x - width/2;
			shellObject.y = y;
		}
		
		public function deCombine()
		{
			level.removeEventListener(MouseEvent.MOUSE_DOWN,finalise);
			
			shellObject.visible = true;
		}
		
		public function finalise(evt:MouseEvent)
		{
			level.removeEventListener(MouseEvent.MOUSE_DOWN,finalise);
			
			trace ('finalise')
			shellObject.x = x - width/2;
			shellObject.y = y;
			
			shellObject.removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			shellObject.removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			shellObject.removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			shellObject.endDrag();
			
			level.addChild(new TrapCombinedText(x,y));
		}
	}
}