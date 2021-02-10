package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class armour extends staticTrap
	{
		private var hit;
		
		public function armour(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new armourGraphic());
			graphic.club.stop();
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
				downArrow.x = -15;
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
			removeChild(downArrow);
		
			level.trapList.push(hit = level.addChild(new Club(level,x - 10,y - 10)));
			hit.visible = false;
			hit.verticalSpeed = 10;
			hit.active = true;
			graphic.club.play();
			
			looping = true;
		
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		override public function loop():void
		{
			if (graphic.club.currentFrame == graphic.club.totalFrames)
			{
				level.removeChild(hit);
				
				for (var i:int = 0; i < level.trapList.length; i++)
				{
					if (level.trapList[i] == hit)
					{
						level.trapList.splice(i,1);
					}
				}
				
				graphic.club.stop();
				looping = false;
			}
		}
	}
}