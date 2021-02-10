package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class testPlayer extends MovieClip
	{		
		private var xCollision = 0;
		private var yCollision = 0;
		private var speed:int = 1;
		private var moveIters:int = 1;
		
		private var previousPos:Point = new Point(0,0);
		
		public var hitBox;
		
		private var onGround:Boolean = false;
		private var verticalSpeed:Number = 0;
		private var horizontalSpeed:Number = 0;
		private const horizontalMaxSpeed:int = 5;
		private const fallingMaxSpeed:int = 10;
		
	    
		public function testPlayer(X = 0,Y = 0):void
		{
			x = X;
			y = Y;
			
			hitBox = new collisionPoly([new Point(-2,-height/2),new Point(-width/2,-10),new Point(-8,height/2),new Point(8,height/2),new Point(width/2,-10),new Point(2,-height/2)],new Point(width/2,height/2),this);

			var graphic:Shape = new Shape();
			//graphic.graphics.lineStyle(0.1, 0x00FF00);
			graphic.graphics.moveTo(hitBox.pointList[0].x, hitBox.pointList[0].y);
			graphic.graphics.beginFill(0x0000ff);
						
			
				
			for (var i:int = 0; i < hitBox.pointList.length; i ++)
			{
				if (i < hitBox.pointList.length - 1 && i == 0)
				{
					
				}
				
				if (i < hitBox.pointList.length - 1)
				{
					var convertedPos:Point = new Point (hitBox.pointList[i + 1].x,hitBox.pointList[i + 1].y);
					convertedPos.x = convertedPos.x;
					convertedPos.y = convertedPos.y;
					
					graphic.graphics.lineTo(convertedPos.x, convertedPos.y);
				}
				
				else 
				{
					graphic.graphics.lineTo(0,-height/2);
				}
			}
			
			graphic.graphics.endFill();
				
			//graphic.x = 0;
			//graphic.y = 0;
			addChild(graphic);
		}
		
		private function collide():void
		{
			var i:int = Math.round(x) / Engine.game.currentLevel.cellSize;
			var n:int = Math.round(y) / Engine.game.currentLevel.cellSize;
				
			// checks players current cell
			if (i >= 0 && n >= 0 && Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				var collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
				
				if (collision == true)
				{
					verticalSpeed = 0;
					onGround = true;
				}
			}
			
			else if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] != null && Engine.game.currentLevel.terrain[i][n][1] is Goal && hitTestObject(Engine.game.currentLevel.terrain[i][n][1]) && Engine.game.currentLevel.terrain[i][n][1].Complete == false)
			{
				Engine.game.currentLevel.terrain[i][n][1].makeComplete()
			}
			
			
			// checks cell below player:
			i = Math.round(x) / Engine.game.currentLevel.cellSize;
			n = Math.round(y) / Engine.game.currentLevel.cellSize + 1;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
				
				if (collision == true)
				{
					//if (horizontalSpeed >= 2)
//						horizontalSpeed -= 2;
//						
//					else if (horizontalSpeed <= -2)
//						horizontalSpeed += 2;
					
					verticalSpeed = 0;
					onGround = true;
				}
			}

			// checks cell above player:
			i = Math.round(x) / Engine.game.currentLevel.cellSize;
			n = Math.round(y) / Engine.game.currentLevel.cellSize - 1;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);

				if (collision == true)
					verticalSpeed = 0;
			}
			
			// checks cell to left of player
			i = Math.round(x) / Engine.game.currentLevel.cellSize - 1;
			n = Math.round(y) / Engine.game.currentLevel.cellSize;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell to right of player
			i = Math.round(x) / Engine.game.currentLevel.cellSize + 1;
			n = Math.round(y) / Engine.game.currentLevel.cellSize;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell below-left of player:
			i = Math.round(x) / Engine.game.currentLevel.cellSize - 1;
			n = Math.round(y) / Engine.game.currentLevel.cellSize + 1;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
			} 
			
			// checks cell below-right of player:
			i = Math.round(x) / Engine.game.currentLevel.cellSize + 1;
			n = Math.round(y) / Engine.game.currentLevel.cellSize + 1;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell above-left of player:
			i = Math.round(x) / Engine.game.currentLevel.cellSize - 1;
			n = Math.round(y) / Engine.game.currentLevel.cellSize - 1;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell above-right of player:
			i = Math.round(x) / Engine.game.currentLevel.cellSize + 1;
			n = Math.round(y) / Engine.game.currentLevel.cellSize - 1;
			
			if (Engine.game.currentLevel.terrain[i] != null && Engine.game.currentLevel.terrain[i][n] != null && Engine.game.currentLevel.terrain[i][n][1] is collisionObject)
			{
				collision = Engine.game.currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
		}
		
		public function loop():void
		{
			//trace (x,y);
			previousPos.x = x;
			previousPos.y = y;
			
			if (Engine.KeyArray[87][1] == true && onGround == true)
			{
				onGround = false;
				verticalSpeed = -18;
			}
			
			if (Engine.KeyArray[65][1] == true)
			{
				horizontalSpeed = -5;
				onGround = false;
			}
			
			if (Engine.KeyArray[68][1] == true)
			{
				horizontalSpeed = 5;
				onGround = false;
			}
				
			
			
			if (Engine.KeyArray[83][1] == true)
				verticalSpeed = 2;
				
				
//			if (Engine.KeyArray[65][1] == true && horizontalSpeed > -horizontalMaxSpeed)
//				horizontalSpeed -= 1;
//			
//			if (Engine.KeyArray[68][1] == true && horizontalSpeed < horizontalMaxSpeed)
//				horizontalSpeed += 1;
//				
//			if (Engine.KeyArray[87][1] == true && onGround == true)
//			{
//				onGround = false;
//				verticalSpeed = -10;
//			}
			
			
			
			if (verticalSpeed != 0 && Math.sqrt(verticalSpeed * verticalSpeed) >= Math.sqrt(horizontalSpeed * horizontalSpeed))
			{
				moveIters = Math.sqrt(verticalSpeed * verticalSpeed);
				
				for (var i:int = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(verticalSpeed * verticalSpeed) != 0)
						y += verticalSpeed / Math.sqrt(verticalSpeed * verticalSpeed);
						
					x += horizontalSpeed / moveIters;
					
					collide();
				}
			}
				
			else 
			{
				moveIters = Math.sqrt(horizontalSpeed * horizontalSpeed);
				
				for ( i = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(horizontalSpeed * horizontalSpeed) != 0)
						x += horizontalSpeed / Math.sqrt(horizontalSpeed * horizontalSpeed);
												
					y += verticalSpeed / moveIters;
										
					collide();
				}
			}
			
			horizontalSpeed = 0;
			//verticalSpeed = 0;
						
			if (verticalSpeed < 10 && onGround == false)	
				verticalSpeed += 0.8;
				
			
			
//			if (horizontalSpeed >= 1)
//				horizontalSpeed -= 1;
//						
//			else if (horizontalSpeed <= -1)
//				horizontalSpeed += 1;
		}
	}
}