package
{
	import flash.system.System;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.filters.BevelFilter;
	import flash.geom.Point;
	
	public class LevelEditor extends MovieClip
	{
		public const cellSize = 50;
		private const panStart:int = 150;
		private const panSpeed:int = 10;
		public var terrain:Array = new Array();
		private var canClick:Boolean = true;
		private var canChangeType:Boolean = true;
		private var cellType:int = 1;
		
		public function LevelEditor():void
		{
			terrain = [
			[[0],[0],[1],[1],[0],[1],[0],[0],[0]],
			[[0],[0],[0],[1],[0],[0],[0],[0],[0]],
			[[0],[0],[0],[1],[0],[0],[0],[1],[0]],
			[[0],[0],[0],[0],[0],[0],[0],[1],[0]],
			[[1],[1],[0],[0],[0],[1],[1],[0],[0]],
			[[0],[1],[1],[1],[0],[0],[0],[0],[0]]
			];
			
			createMap();
		
			addEventListener(MouseEvent.MOUSE_DOWN, this.mouseTrue);
			addEventListener(MouseEvent.MOUSE_UP, this.mouseFalse);
		}
		
		private function mouseTrue(evt:MouseEvent):void
		{
			if (canClick == true)
			{
				canClick = false;
				var mousePos = globalToLocal(new Point(stage.mouseX, stage.mouseY));
				
				var i:int = Math.round(mousePos.x) / cellSize;
				var n:int = Math.round(mousePos.y) / cellSize;
				
				if (terrain[i] != null && terrain[i][n] != null)
				{
					if (terrain[i][n][0] == 0)
					{
						if (cellType == 1)
						{
							terrain[i][n][0] = 1;
							var rectangle:Shape = new Shape; // initializing the variable named rectangle
							//rectangle.graphics.lineStyle(3,0x00ff00);
							rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
							rectangle.graphics.drawRect(0,0,cellSize,cellSize); // (x spacing, y spacing, width, height)
							rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
							rectangle.x = i* cellSize; 
							rectangle.y = n* cellSize;
							//rectangle.filters = [new BevelFilter()];
							terrain[i][n][1] = addChild(rectangle);
						}
						
						else if (cellType == 2)
						{
							terrain[i][n][0] = 2;
							var triangle:Shape = new Shape;
							//triangle.graphics.lineStyle(2, 0x000000); 
							triangle.graphics.beginFill(0xFF0000);
							triangle.graphics.lineTo(0,cellSize);
							triangle.graphics.lineTo(cellSize,cellSize);
							triangle.graphics.lineTo(0,0);
							triangle.graphics.endFill(); 
							triangle.x = i* cellSize; 
							triangle.y = n* cellSize;
							terrain[i][n][1] = addChild(triangle);
						}
						
						else if (cellType == 3)
						{
							terrain[i][n][0] = 3;
							terrain[i][n][1] = addChild(new Goal(i* cellSize + cellSize/2, n* cellSize + cellSize));
						}
						
					}
					
					else
					{
						terrain[i][n][0] = 0;
						removeChild(terrain[i][n][1]);
						terrain[i][n][1] = null;
					}
				}
			}
		}
		
		private function mouseFalse(evt:MouseEvent):void
		{
			canClick = true;
		}
		
		private function createMap():void
		{
			for (var i:int = 0; i < terrain.length; i++)
			{
				for (var n:int = 0; n < terrain[i].length; n++)
				{
					if (terrain[i][n] == 1)
					{
						var rectangle:Shape = new Shape; // initializing the variable named rectangle
						//rectangle.graphics.lineStyle(3,0x00ff00);
						rectangle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
						rectangle.graphics.drawRect(0,0,cellSize,cellSize); // (x spacing, y spacing, width, height)
						rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
						rectangle.x = i* cellSize; 
						rectangle.y = n* cellSize;
						//rectangle.filters = [new BevelFilter()];
						terrain[i][n][1] = addChild(rectangle);
					}
				}
			}
		}
		
		public function loop():void
		{
			player.loop();
			
			if (Engine.KeyArray[187][2] == true)
			{
				cellType ++;
			}
			
			else if (Engine.KeyArray[189][2] == true)
			{
				cellType --;
			}
			
			if (Engine.KeyArray[32][1] == true)
			{
				var stringArray:String = '';
				
				for (var i:int = 0; i < terrain.length; i++)
				{
					stringArray += '['
					
					for (var n:int = 0; n < terrain[i].length; n++)
					{
						stringArray += '[' + terrain[i][n][0] + ']'
						
						if (n < terrain[i].length-1)
							stringArray += ','
					}
					
					stringArray += ']'
					
					if (i < terrain.length - 1)
						stringArray += ','
				}
				
				trace (stringArray)
			}
			
			var mousePos = new Point(stage.mouseX, stage.mouseY);
				
			if (mousePos.x > Engine.game.x + panStart)
				x -= panSpeed;
					
			else if (mousePos.x < Engine.game.x - panStart)
				x += panSpeed;
					
			if (mousePos.y > Engine.game.y + panStart)
				y -= panSpeed;
					
			else if (mousePos.y < Engine.game.y - panStart)
				y += panSpeed;
		}
	}
}