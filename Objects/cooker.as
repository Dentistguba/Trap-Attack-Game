package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class cooker extends staticTrap
	{
		private var flameCount:int = 50;
		private var flameTimer:int = 2;
		
		public function cooker(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new cookerGraphic());
			
			loopSound = new fireSound();
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
				boxGraphic.scaleY = 2;
				boxGraphic.y -= boxGraphic.height/2;
				addChild(downArrow = new DownArrow());
				downArrow.x = 0;
				downArrow.y = -graphic.height/2;
				
				addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
				addEventListener (MouseEvent.MOUSE_OVER, mouseHover)
				addEventListener (MouseEvent.MOUSE_OUT, mouseAway)
			}
		}
		
		private function mouseHover(evt:MouseEvent):void
		{
			if (mouseX > -(width/2) && mouseX < width/2 && mouseY > -(height/2) && mouseY < height/2)
			{
				trace('mouseOver');
				
				downArrow.scaleY = 1.5;
			}
			
			else if (downArrow.scaleY != 1)
			{
				downArrow.scaleY = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			downArrow.scaleY = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{			
			soundChannel = loopSound.play(0,int.MAX_VALUE);
			loopSoundPlaying = true;
		
			removeChild(downArrow);
		
			addEventListener(Event.ENTER_FRAME, addFlame);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function addFlame(evt:Event):void
		{
			if (flameCount > 0)
			{
				if (flameTimer == 0)
				{
					level.trapList.push(level.addChildAt(new Flame(level,x + (width/4) + ((Math.random() - 0.5) * 2),y - (graphic.height/2)),2));
					level.trapList.push(level.addChildAt(new Flame(level,x - (width/4) + ((Math.random() - 0.5) * 2),y - (graphic.height/2)),2));
					
					level.trapList.push(level.addChild(new Flame(level,x + ((Math.random() - 0.5) * 20),y)));
					
					flameCount --;
					flameTimer = 2;
				}
				
				flameTimer --;
			}
			
			else
			{
				soundChannel.stop();
				removeEventListener(Event.ENTER_FRAME, addFlame);
			}
		}
	}
}