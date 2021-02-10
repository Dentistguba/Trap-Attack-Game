package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class shower extends staticTrap
	{
		private var waterCount:int = 20;
		private var waterDirection:int = 0;
		private var waterTimer:int = 0;
		
		public function shower(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new showerGraphic());
			noCollideObject = water;
			
			loopSound = new showerSound();
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
				boxGraphic.y += boxGraphic.height/2;
				addChild(downArrow = new DownArrowBelow());
				downArrow.x = 0;
				downArrow.y = graphic.height/2 + 5;
				
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
			
			addEventListener(Event.ENTER_FRAME, addWater);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		public function spill():void
		{
			addEventListener(Event.ENTER_FRAME, addWater);
		}
		
		private function addWater(evt:Event)
		{
			if (waterCount > 0)
			{
				if (waterTimer == 0)
				{
					level.trapList.push(level.addChild(new water(level,x,y + (graphic.height/2),1,shower)));
					level.trapList.push(level.addChild(new water(level,x,y + (graphic.height/2),-1,shower)));
					level.trapList.push(level.addChild(new water(level,x,y + (graphic.height/2),0,shower)));

					waterCount --;
					waterTimer = 5;
				}
				
				waterTimer --;
			}
			
			else
			{
				soundChannel.stop();
				removeEventListener(Event.ENTER_FRAME, addWater);
			}
		}
	}
}