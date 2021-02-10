package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class painting extends Trap
	{		
		public function painting(level:Level,X = 0,Y = 0,graphic = null)
		{
			if (graphic == null)
				graphic = new paintingGraphic();
			
			super(level,X,Y,graphic);
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
		
		override protected function snap():void
		{
			level.proximityTree.refresh();
			
			var neighbors = level.proximityTree.getNeighbors(this);
			
			for (var i:int = 0; i <= neighbors.length; i ++)
			{				
				if (neighbors[i] != null && neighbors[i] != this)
					neighbors[i].hitBox.checkTrapPolyCollision(this,false,0,true);
			}
			
			var i:int = Math.round(y) / level.cellSize;
			var n:int = Math.round(x) / level.cellSize;
			
			if (level.terrain[i] != null && level.terrain[i][n] != null &&level.terrain[i][n][1] != null)
				level.terrain[i][n][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i][n][1]);
				
			if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
			{
				level.terrain[i][n + 1][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i][n + 1][1]);
			}
			
			if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
			{
				level.terrain[i][n - 1][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i][n - 1][1]);
			}
			
			if (level.terrain[i + 1] != null && level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null)
			{
				level.terrain[i + 1][n][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i + 1][n][1]);
			}
			
			if (level.terrain[i + 1] != null && level.terrain[i + 1][n + 1] != null && level.terrain[i + 1][n + 1][1] != null)
			{
				level.terrain[i + 1][n + 1][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i + 1][n + 1][1]);
			}
			
			if (level.terrain[i + 1] != null && level.terrain[i + 1][n - 1] != null && level.terrain[i + 1][n - 1][1] != null)
			{
				level.terrain[i + 1][n - 1][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i + 1][n - 1][1]);
			}
			
			if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && level.terrain[i - 1][n][1] != null)
			{
				level.terrain[i - 1][n][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i - 1][n][1]);
			}
			
			if (level.terrain[i - 1] != null && level.terrain[i - 1][n - 1] != null && level.terrain[i - 1][n - 1][1] != null)
			{
				level.terrain[i - 1][n - 1][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i - 1][n - 1][1]);
			}
			
			if (level.terrain[i - 1] != null && level.terrain[i - 1][n + 1] != null && level.terrain[i - 1][n + 1][1] != null)
			{
				level.terrain[i - 1][n + 1][1].checkPolyCollision(this);
				//boxCollide(level.terrain[i - 1][n + 1][1]);
			}
			
			snapped = true;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			removeChild(downArrow);
			
			verticalSpeed = 0.4;
			changeMode();
			looping = true;
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
	}
}