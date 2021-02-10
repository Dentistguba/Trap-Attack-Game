package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class AiPlayer extends MovieClip
	{		
		//private var speed:int = 4;
//		private var moveIters:int = 1;
//		
//		private var nodeList:Vector.<Node> = new Vector.<Node>();
//		private var currentNode:Node;
//		private var currentConnection:Connection;
//				
//		public var hitBox;
//		
//		private var onGround:Boolean = false;
//		private var verticalSpeed:Number = 0;
//		private var horizontalSpeed:Number = 0;
//		private const horizontalMaxSpeed:Number = 6;
//		private const fallingMaxSpeed:int = 10;
//		private const gravity:Number = 0.9;
//		
//		private var currentLevel:Level;
	    
		public function AiPlayer(level:Level,X = 0,Y = 0):void
		{
			
		}
			//x = X;
//			y = Y;
//			currentLevel = level;
//			nodeList = level.nodeList.concat();
//			currentNode = nodeList[0];
//			currentConnection = nodeList[0].connections[Math.round(Math.random())];
//			
//			hitBox = new collisionPoly([new Point(-2,-height/2),new Point(-width/2,-10),new Point(-8,height/2),new Point(8,height/2),new Point(width/2,-10),new Point(2,-height/2)]);
//
//			var graphic:Shape = new Shape();
//			//graphic.graphics.lineStyle(0.1, 0x00FF00);
//			graphic.graphics.moveTo(hitBox.pointList[0].x, hitBox.pointList[0].y);
//			graphic.graphics.beginFill(0x0000ff);
//						
//			
//				
//			for (var i:int = 0; i < hitBox.pointList.length; i ++)
//			{
//				if (i < hitBox.pointList.length - 1 && i == 0)
//				{
//					
//				}
//				
//				if (i < hitBox.pointList.length - 1)
//				{
//					var convertedPos:Point = new Point (hitBox.pointList[i + 1].x,hitBox.pointList[i + 1].y);
//					convertedPos.x = convertedPos.x;
//					convertedPos.y = convertedPos.y;
//					
//					graphic.graphics.lineTo(convertedPos.x, convertedPos.y);
//				}
//				
//				else 
//				{
//					graphic.graphics.lineTo(0,-height/2);
//				}
//			}
//			
//			graphic.graphics.endFill();
//				
//			//graphic.x = 0;
//			//graphic.y = 0;
//			addChild(graphic);
//		}
//		
//		private function collide():void
//		{
//			var i:int = Math.round(x) / currentLevel.cellSize;
//			var n:int = Math.round(y) / currentLevel.cellSize;
//				
//			// checks players current cell
//			if (i >= 0 && n >= 0 && currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				var collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//				
//				if (collision == true)
//				{
//					verticalSpeed = 0;
//					onGround = true;
//				}
//			}
//			
//			else if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is Goal && hitTestObject(currentLevel.terrain[i][n][1]) && currentLevel.terrain[i][n][1].Complete == false)
//			{
//				currentLevel.terrain[i][n][1].makeComplete()
//			}
//			
//			
//			// checks cell below player:
//			i = Math.round(x) / currentLevel.cellSize;
//			n = Math.round(y) / currentLevel.cellSize + 1;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//				
//				if (collision == true)
//				{
//					//if (horizontalSpeed >= 2)
////						horizontalSpeed -= 2;
////						
////					else if (horizontalSpeed <= -2)
////						horizontalSpeed += 2;
//					
//					verticalSpeed = 0;
//					onGround = true;
//				}
//			}
//
//			// checks cell above player:
//			i = Math.round(x) / currentLevel.cellSize;
//			n = Math.round(y) / currentLevel.cellSize - 1;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//
//				if (collision == true)
//					verticalSpeed = 0;
//			}
//			
//			// checks cell to left of player
//			i = Math.round(x) / currentLevel.cellSize - 1;
//			n = Math.round(y) / currentLevel.cellSize;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//			}
//			
//			// checks cell to right of player
//			i = Math.round(x) / currentLevel.cellSize + 1;
//			n = Math.round(y) / currentLevel.cellSize;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//			}
//			
//			// checks cell below-left of player:
//			i = Math.round(x) / currentLevel.cellSize - 1;
//			n = Math.round(y) / currentLevel.cellSize + 1;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//			} 
//			
//			// checks cell below-right of player:
//			i = Math.round(x) / currentLevel.cellSize + 1;
//			n = Math.round(y) / currentLevel.cellSize + 1;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//			}
//			
//			// checks cell above-left of player:
//			i = Math.round(x) / currentLevel.cellSize - 1;
//			n = Math.round(y) / currentLevel.cellSize - 1;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//			}
//			
//			// checks cell above-right of player:
//			i = Math.round(x) / currentLevel.cellSize + 1;
//			n = Math.round(y) / currentLevel.cellSize - 1;
//			
//			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
//			{
//				collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
//			}
//		}
//		
//		private function newAI():void
//		{
//			// check current node to make sure it is still closest, if not make closest new current node
//			
//			// pick node to go to
//			if (currentLevel.nodeList[currentNode].connections.length > 0)
//			{
//				var currentConnection = currentNode.connections[Math.round(Math.random() * currentNode.connections.length)];
//				
//				// move player towards current node (if it is to the right - makes sure player is at node)
//				
//				// moves player towards next node
//				if (currentConnection.type == 0 && x < currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] - width/2)
//				{
//					horizontalSpeed = horizontalMaxSpeed;
//				}
//			
//				// player reached node
//				else //if (x >= currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0])
//				{
//						// moves along node list
//					currentNode = currentNode.connections[currentConnection];
//					
//					// jump / drop
//					if (onGround && currentLevel.nodeList[currentNode][2][0] != null && currentLevel.nodeList[currentNode][2][0][1] != null)
//					{
//						onGround = false;
//						
//						horizontalSpeed = horizontalMaxSpeed;
//					
//						// horizontal jump
//						if (currentLevel.nodeList[currentNode][2][0][1] == 1)
//						{
//							for (var i:int = 0; i < 10; i++)
//							{
//								// position to test jump to
//								var pos:Point = new Point(currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] + (i * 100), currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][1])
//								var posCell:Point = new Point(Math.round(pos.x / currentLevel.cellSize),Math.round(pos.y / currentLevel.cellSize) - 1);										
//								var cell = currentLevel.terrain[posCell.x][posCell.y];
//								trace(cell)
//																
//								// test whether jump lands on trap
//								if (cell[2] == null /*|| pos.x < cell[2].x || pos.x > cell[2].x || pos.y < cell[2].y || pos.y > cell[2].y*/)
//								{
//									// time in air required to cover x distance to current checking point
//									var time:Number = (pos.x - (x - width/2)) / horizontalSpeed;
//							
//									// convert into initial vertical speed
//									verticalSpeed = - ((time * gravity) / 2);
//									i = 10;
//								}
//							}
//						}
//					
//						// drop / jump up
//						else if (currentLevel.nodeList[currentNode][2][0][1] == 2)
//						{
//							for (var i:int = 0; i < 10; i++)
//							{
//								// position to test jump to
//								var pos:Point = new Point(currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] + (i * 100), currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][1])
//								var posCell:Point = new Point(Math.round(pos.x / currentLevel.cellSize),Math.round(pos.y / currentLevel.cellSize) - 1);										
//								var cell = currentLevel.terrain[posCell.x][posCell.y];
//								trace(cell)
//																
//								// test whether jump lands on trap
//								if (cell[2] == null /*|| pos.x < cell[2].x || pos.x > cell[2].x || pos.y < cell[2].y || pos.y > cell[2].y*/)
//								{
//									// time in air required to cover x distance to current checking point
//									var time:Number = (pos.x - (x - width/2)) / horizontalSpeed;
//							
//									// convert into initial vertical speed
//									verticalSpeed = - ((time * gravity) / 2);
//									i = 10;
//								}
//							}
//						}
//						
//						else if (currentLevel.nodeList[currentNode][2][0][1] == 3)
//						{
//							for (var i:int = 0; i < 10; i++)
//							{
//								// position to test jump to
//								var pos:Point = new Point(currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] + (i * 100), currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][1])
//								var posCell:Point = new Point(Math.round(pos.x / currentLevel.cellSize),Math.round(pos.y / currentLevel.cellSize) - 1);										
//								var cell = currentLevel.terrain[posCell.x][posCell.y];
//								trace(cell)
//																
//								// test whether jump lands on trap
//								if (cell[2] == null /*|| pos.x < cell[2].x || pos.x > cell[2].x || pos.y < cell[2].y || pos.y > cell[2].y*/)
//								{
//									// time in air required to cover x distance to current checking point
//									var time:Number = (pos.x - (x - width/2)) / horizontalSpeed;
//							
//									// convert into initial vertical speed
//									verticalSpeed = - ((time * gravity) / 2 + 1);
//									i = 10;
//								}
//							}
//						}
//					}
//				}
//			}
//			else 
//				horizontalSpeed = 0;
//		}
//		
//		private function AI():void
//		{
//			if (currentLevel.nodeList[currentNode].connections != null)
//			{			
//				// moves player towards next node
//				if (currentLevel.nodeList[currentNode].connections[0][1] == 0 && x < currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] - width/2)
//				{
//					horizontalSpeed = horizontalMaxSpeed;
//				}
//			
//				// player reached node
//				else //if (x >= currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0])
//				{
//					// moves along node list
//					currentNode = currentLevel.nodeList[currentNode][2][0][0];
//					
//					// jump / drop
//					if (onGround == true && currentLevel.nodeList[currentNode][2][0] != null && currentLevel.nodeList[currentNode][2][0][1] != null)
//					{
//						onGround = false;
//						
//						horizontalSpeed = horizontalMaxSpeed;
//						
//						// horizontal jump
//						if (currentLevel.nodeList[currentNode][2][0][1] == 1)
//						{
//							for (var i:int = 0; i < 10; i++)
//							{
//								// position to test jump to
//								var pos:Point = new Point(currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] + (i * 100), currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][1])
//								var posCell:Point = new Point(Math.round(pos.x / currentLevel.cellSize),Math.round(pos.y / currentLevel.cellSize) - 1);										
//								var cell = currentLevel.terrain[posCell.x][posCell.y];
//								trace(cell)
//								
//								trace('testing jump');
//								
//								// test whether jump lands on trap
//								if (cell[2] == null /*|| pos.x < cell[2].x || pos.x > cell[2].x || pos.y < cell[2].y || pos.y > cell[2].y*/)
//								{
//									// time in air required to cover x distance to current checking point
//									var time:Number = (pos.x - (x - width/2)) / horizontalSpeed;
//							
//									// convert into initial vertical speed
//									verticalSpeed = - ((time * gravity) / 2);
//									i = 10;
//								}
//							}
//						}
//						
//						// drop / jump up
//						else if (currentLevel.nodeList[currentNode][2][0][1] == 2)
//						{
//							for (var i:int = 0; i < 10; i++)
//							{
//								// position to test jump to
//								var pos:Point = new Point(currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] + (i * 100), currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][1])
//								var posCell:Point = new Point(Math.round(pos.x / currentLevel.cellSize),Math.round(pos.y / currentLevel.cellSize) - 1);										
//								var cell = currentLevel.terrain[posCell.x][posCell.y];
//								trace(cell)
//								
//								trace('testing drop');
//								
//								// test whether jump lands on trap
//								if (cell[2] == null /*|| pos.x < cell[2].x || pos.x > cell[2].x || pos.y < cell[2].y || pos.y > cell[2].y*/)
//								{
//									// time in air required to cover x distance to current checking point
//									var time:Number = (pos.x - (x - width/2)) / horizontalSpeed;
//							
//									// convert into initial vertical speed
//									verticalSpeed = - ((time * gravity) / 2);
//									i = 10;
//								}
//							}
//						}
//						
//						else if (currentLevel.nodeList[currentNode][2][0][1] == 3)
//						{
//							for (var i:int = 0; i < 10; i++)
//							{
//								// position to test jump to
//								var pos:Point = new Point(currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][0] + (i * 100), currentLevel.nodeList[currentLevel.nodeList[currentNode][2][0][0]][1])
//								var posCell:Point = new Point(Math.round(pos.x / currentLevel.cellSize),Math.round(pos.y / currentLevel.cellSize) - 1);										
//								var cell = currentLevel.terrain[posCell.x][posCell.y];
//								trace(cell)
//								
//								trace('testing jump up');
//								
//								// test whether jump lands on trap
//								if (cell[2] == null /*|| pos.x < cell[2].x || pos.x > cell[2].x || pos.y < cell[2].y || pos.y > cell[2].y*/)
//								{
//									// time in air required to cover x distance to current checking point
//									var time:Number = (pos.x - (x - width/2)) / horizontalSpeed;
//							
//									// convert into initial vertical speed
//									verticalSpeed = - ((time * gravity) / 2 + 1);
//									i = 10;
//								}
//							}
//						}
//					}
//				}
//			}
//			
//			else 
//				horizontalSpeed = 0;
//		}
//		
//		public function loop():void
//		{
//			// this function checks for the ai players best path and sets his speed 
//			AI();
//			
//			// this code moves the player based on his current speed and triggers collision check, iterates so that player never moves more than 1 between collisions
//			if (verticalSpeed != 0 && Math.sqrt(verticalSpeed * verticalSpeed) >= Math.sqrt(horizontalSpeed * horizontalSpeed))
//			{
//				moveIters = Math.sqrt(verticalSpeed * verticalSpeed);
//				
//				for (var i:int = 0; i < moveIters; i ++)
//				{
//					if (Math.sqrt(verticalSpeed * verticalSpeed) != 0)
//						y += verticalSpeed / Math.sqrt(verticalSpeed * verticalSpeed);
//						
//					x += horizontalSpeed / moveIters;
//					
//					collide();
//				}
//			}
//				
//			else 
//			{
//				moveIters = Math.sqrt(horizontalSpeed * horizontalSpeed);
//				
//				for ( i = 0; i < moveIters; i ++)
//				{
//					if (Math.sqrt(horizontalSpeed * horizontalSpeed) != 0)
//						x += horizontalSpeed / Math.sqrt(horizontalSpeed * horizontalSpeed);
//												
//					y += verticalSpeed / moveIters;
//										
//					collide();
//				}
//			}
//					
//			//if (verticalSpeed < fallingMaxSpeed)
//			verticalSpeed += gravity;
//			
//		}
	}
}