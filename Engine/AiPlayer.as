package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class AiPlayer extends MovieClip
	{		
		// stats
		public var health:Number = 100;
		private var maxHealth:Number = 100;
		private var morale:int = 100;
	
		private var speed:int = 4;
		private var moveIters:int = 1;
		
		private var nodeList:Vector.<Node> = new Vector.<Node>();
		private var currentNode:Node;
		private var currentConnection:Connection;
				
		public var hitBox:collisionPoly;
		private var graphic:Shape;
		
		private var animList:Array = new Array();
		
		private var hurtFootGraphic;
		private var jumpGraphic;
		private var fallGraphic;
		private var paintGraphic;
		private var wetGraphic;
		private var oilyGraphic;
		private var burntGraphic;
		private var steamedGraphic;
		private var powderedGraphic;
		private var pullingDoorGraphic;
		private var electrocutionGraphic;
		private var tripForwardGraphic;
		private var tripBackwardGraphic;
		private var lyingFrontGraphic;
		private var lyingBackGraphic;
		public var ladderGraphic;
		
		private var onGround:Boolean = false;
		public var verticalSpeed:Number = 0;
		public var horizontalSpeed:Number = 0;
		private const horizontalMaxSpeed:Number = 10;
		//private const fallingMaxSpeed:int = 10;
		private const gravity:Number = 0.4;
		
		private var rotationSpeed:int;
		
		private var currentLevel:Level;
		
		public var physicalEffect:String;
		private var physicalEffectTimer:int;
		private var AIEffect:String;
		private var AIEffectTimer:int
		
		private var goThroughStairs:Boolean = true;
		
		public var waiting:Boolean = true;
		private var hat;
		
		private var soundChannel;
	    
		public function AiPlayer(level:Level,X = 0,Y = 0,Health = 100):void
		{
			maxHealth = health = Health;
			
			if (health > 0)
				Engine.hud.healthBar.scaleX = health/100;
					
			else
				Engine.hud.healthBar.scaleX = 0;
			
			Graphic.stop();
			Graphic.visible = false;
			
			
			x = X;
			y = Y;
			currentLevel = level;
			nodeList = level.nodeList.concat();
			currentNode = nodeList[0];
			
			if (currentNode.connections != null && currentNode.connections.length > 0)
				currentConnection = (nodeList[0].connections[Math.round(Math.random() * (nodeList[0].connections.length - 1))]);
			
			hitBox = new collisionPoly([new Point(-2,-height/2),new Point(-width/4,-10),new Point(-8,height/2),new Point(8,height/2),new Point(width/4,-10),new Point(2,-height/2)],new Point(0,0),this);

			//hitBox = new collisionPoly([new Point(-width/2,-height/2),new Point(-width/2,height/2),new Point(width/2,height/2),new Point(width/2,-height/2)],new Point(0,0),this);

			animList.push(Graphic);
			
			hurtFootGraphic = addChild(new robberBetterOwie());
			hurtFootGraphic.visible = false;
			hurtFootGraphic.stop();
			animList.push(hurtFootGraphic);
						  
			jumpGraphic = addChild(new robberBetterJump());
			jumpGraphic.visible = false;
			jumpGraphic.stop();
			animList.push(jumpGraphic)
						  
			fallGraphic = addChild(new robberBetterDropping());
			fallGraphic.visible = false;
			fallGraphic.stop();
			animList.push(fallGraphic);
			
			paintGraphic = addChild(new robberBetterPaint());
			paintGraphic.visible = false;
			paintGraphic.stop();
			animList.push(paintGraphic);
			
			wetGraphic = addChild(new robberBetterSoaking());
			wetGraphic.visible = false;
			wetGraphic.stop();
			animList.push(wetGraphic);
						  
			oilyGraphic = addChild(new robberBetterOily());
			oilyGraphic.visible = false;
			oilyGraphic.stop();
			animList.push(oilyGraphic);
						  
			burntGraphic = addChild(new robberBetterBurnt());
			burntGraphic.visible = false;
			burntGraphic.stop();
			animList.push(burntGraphic);
			
			steamedGraphic = addChild(new robberBetterHot());
			steamedGraphic.visible = false;
			steamedGraphic.stop();
			animList.push(steamedGraphic);
						
			powderedGraphic = addChild(new robberBetterPowder());
			powderedGraphic.visible = false;
			powderedGraphic.stop();
			animList.push(powderedGraphic);
			
			pullingDoorGraphic = addChild(new robberKnockingAtTheBack());
			pullingDoorGraphic.visible = true;
			animList.push(pullingDoorGraphic);
						
			electrocutionGraphic = addChild(new robberBetterShock());
			electrocutionGraphic.visible = false;
			electrocutionGraphic.stop();
			animList.push(electrocutionGraphic);
						  
			tripForwardGraphic = addChild(new robberBetterTripForward());
			tripForwardGraphic.visible = false;
			tripForwardGraphic.stop();
			animList.push(tripForwardGraphic);
						  
			tripBackwardGraphic = addChild(new robberBetterTripBackward());
			tripBackwardGraphic.visible = false;
			tripBackwardGraphic.stop();
			animList.push(tripBackwardGraphic);
						  
			lyingFrontGraphic = addChild(new robberBetterLyingFront());
			lyingFrontGraphic.visible = false;
			lyingFrontGraphic.stop();
			animList.push(lyingFrontGraphic);
						  
			lyingBackGraphic = addChild(new robberBetterLyingBack());
			lyingBackGraphic.visible = false;
			lyingBackGraphic.stop();
			animList.push(lyingBackGraphic);
						  
			ladderGraphic = addChild(new robberBetterLadder());
			ladderGraphic.visible = false;
			ladderGraphic.stop();
			animList.push(ladderGraphic);
						  
			graphic = new Shape();
			graphic.graphics.lineStyle(0.1, 0x00FF00);
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
			//addChild(graphic);
			
			//rotate(90);
			
			currentLevel.proximityTree.addObject(this);
		}
		
		public function rotate(degs:Number):void
		{
			hitBox.rotate(degs);
			redrawCollisionBox();
		}
		
		private function redrawCollisionBox():void
		{
			//removeChild(graphic);
			graphic = new Shape();
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
			//addChild(graphic);
				
			//graphic.x = 0;
			graphic.y = 0;
		}
			
		
		private function terrainCollide():void
		{			
			var i:int = Math.round(y) / currentLevel.cellSize;
			var n:int = Math.round(x) / currentLevel.cellSize;
				
			// checks players current cell
			if (i >= 0 && n >= 0 && currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					var collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if (collision)
					{
						if (verticalSpeed >= 0)
							verticalSpeed = 0;
						//onGround = true;
					}
				}
			}
			
			else if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is Goal && hitTestObject(currentLevel.terrain[i][n][1]) && currentLevel.terrain[i][n][1].Complete == false)
			{
				currentLevel.terrain[i][n][1].makeComplete()
			}
			
			
			// checks cell below player:
			i = Math.round(y) / currentLevel.cellSize + 1;
			n = Math.round(x) / currentLevel.cellSize;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri || (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if (collision)
					{
						if (physicalEffect == 'tripping')
						{						
							if (onGround == false)
							{
								health -= verticalSpeed;
								//trace(health);
							}
							
							
							
							
							if (horizontalSpeed >= 1)
								horizontalSpeed -= 1;
							
							else if (horizontalSpeed <= -1)
								horizontalSpeed += 1;
						}
						
						onGround = true;
						verticalSpeed = 0;
					}
				}
			}

			// checks cell above player:
			i = Math.round(y) / currentLevel.cellSize - 1;
			n = Math.round(x) / currentLevel.cellSize;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri || (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
	
					if (collision == true)
					{
						verticalSpeed = 0;
						
						if (currentLevel.terrain[i][n][1] is staticCollisionTri)
						{
							horizontalSpeed /= 3;
						}
					}
				}
			}
			
			// checks cell to left of player
			i = Math.round(y) / currentLevel.cellSize;
			n = Math.round(x) / currentLevel.cellSize - 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell to right of player
			i = Math.round(y) / currentLevel.cellSize;
			n = Math.round(x) / currentLevel.cellSize + 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell below-left of player:
			i = Math.round(y) / currentLevel.cellSize + 1;
			n = Math.round(x) / currentLevel.cellSize - 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
			} 
			
			// checks cell below-right of player:
			i = Math.round(y) / currentLevel.cellSize + 1;
			n = Math.round(x) / currentLevel.cellSize + 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
				}
			}
			
			// checks cell above-left of player:
			i = Math.round(y) / currentLevel.cellSize - 1;
			n = Math.round(x) / currentLevel.cellSize - 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri || (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
			
			// checks cell above-right of player:
			i = Math.round(y) / currentLevel.cellSize - 1;
			n = Math.round(x) / currentLevel.cellSize + 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
			}
		}
		
		private function trippedTerrainCollide():void
		{						
			var i:int = Math.round(y) / currentLevel.cellSize;
			var n:int = Math.round(x) / currentLevel.cellSize;
				
			// checks players current cell
			if (i >= 0 && n >= 0 && currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					var collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if (collision)
					{
						if (currentLevel.terrain[i][n][1] is stairObject)
						{
							if (fallGraphic.rotation != 45 && currentLevel.terrain[i][n][1].direction == 1)
							{
								fallGraphic.rotation = 45;
								hitBox.setRotate(45);
								redrawCollisionBox();
							}
							
							else if (fallGraphic.rotation != 120 && currentLevel.terrain[i][n][1].direction == 0)
							{
								fallGraphic.rotation = 120;
								hitBox.setRotate(120);
								redrawCollisionBox();
							}
						}
						
						else if (verticalSpeed >= 0)
							verticalSpeed = 0;
						//onGround = true;
					}
				}
			}
			
			else if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is Goal && hitTestObject(currentLevel.terrain[i][n][1]) && currentLevel.terrain[i][n][1].Complete == false)
			{
				currentLevel.terrain[i][n][1].makeComplete()
			}
			
			
			// checks cell below player:
			i = Math.round(y) / currentLevel.cellSize + 1;
			n = Math.round(x) / currentLevel.cellSize;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if (collision)
					{
						//trace('below')
						
						
							
						if (currentLevel.terrain[i][n][1] is stairObject)
						{
							health -= Math.abs(verticalSpeed + horizontalSpeed)/200;
							//trace(health);
						
							if (fallGraphic.rotation != 45 && currentLevel.terrain[i][n][1].direction == 1)
							{
								horizontalSpeed = 0;
								fallGraphic.rotation = 45;
								hitBox.setRotate(45);
								redrawCollisionBox();
							}
								
							else if (fallGraphic.rotation != 120 && currentLevel.terrain[i][n][1].direction == 0)
							{
								fallGraphic.rotation = 120;
								hitBox.setRotate(120);
								redrawCollisionBox();
							}
						}
							
						else
						{
							if (fallGraphic.rotation > 0)
							{
								tripForwardGraphic.visible = false;
								tripBackwardGraphic.visible = false;
								fallGraphic.rotation = 90;
								
								lyingFrontGraphic.visible = true;
								
								hitBox.setRotate(90);
								redrawCollisionBox();
							}
							
							else
							{
								tripForwardGraphic.visible = false;
								tripBackwardGraphic.visible = false;
								fallGraphic.rotation = -90
								
								lyingBackGraphic.visible = true;
								
								hitBox.setRotate(-90);
								redrawCollisionBox();
							}
								
							if (onGround == false)
							{
								health -= Math.abs(verticalSpeed);
								//trace(health);
								
								//if(!(sound is Bump))
								//{
									//if (sound != null)
										soundChannel.stop();
										
									var sound = new Bump();
									
									soundChannel = sound.play();
								//}
							}
							
							if (horizontalSpeed >= 1)
								horizontalSpeed -= 1;
								
							else if (horizontalSpeed <= -1)
								horizontalSpeed += 1
								
							else if (horizontalSpeed >= 0.1)
								horizontalSpeed -= 0.1
								
							else if (horizontalSpeed <= -0.1)
								horizontalSpeed += 0.1
							
							onGround = true;
							verticalSpeed = 0;
						}
					}
				}
			}

			// checks cell above player:
			i = Math.round(y) / currentLevel.cellSize - 1;
			n = Math.round(x) / currentLevel.cellSize;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
	
					if (collision == true)
					{
						if (verticalSpeed < 0)
							verticalSpeed = 0;
						
						if (currentLevel.terrain[i][n][1] is staticCollisionTri)
						{
							//horizontalSpeed /= 3;
						}
					}
				}
			}
			
			// checks cell to left of player
			i = Math.round(y) / currentLevel.cellSize;
			n = Math.round(x) / currentLevel.cellSize - 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if(collision)
					{
						if (currentLevel.terrain[i][n][1] is stairObject)
						{
							health -= (verticalSpeed + horizontalSpeed)/200;
							//trace(health);
							
							if (fallGraphic.rotation != 45 && currentLevel.terrain[i][n][1].direction == 1)
							{
								horizontalSpeed = 0;
								fallGraphic.rotation = 45;
								hitBox.setRotate(45);
								redrawCollisionBox();
							}
							
							else if (fallGraphic.rotation != 120 && currentLevel.terrain[i][n][1].direction == 0)
							{
								fallGraphic.rotation = 120;
								hitBox.setRotate(120);
								redrawCollisionBox();
							}
						}
					}
				}
			}
			
			// checks cell to right of player
			i = Math.round(y) / currentLevel.cellSize;
			n = Math.round(x) / currentLevel.cellSize + 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if(collision)
					{
						//trace('right')
						
						if (currentLevel.terrain[i][n][1] is stairObject)
						{
							health -= (verticalSpeed + horizontalSpeed)/200;
							//trace(health);
							
							if (fallGraphic.rotation != 45 && currentLevel.terrain[i][n][1].direction == 1)
							{
								horizontalSpeed = 0;
								fallGraphic.rotation = 45;
								hitBox.setRotate(45);
								redrawCollisionBox();
							}
							
							else if (fallGraphic.rotation != 120 && currentLevel.terrain[i][n][1].direction == 0)
							{
								fallGraphic.rotation = 120;
								hitBox.setRotate(120);
								redrawCollisionBox();
							}
						}
					}
				}
			}
			
			// checks cell below-left of player:
			i = Math.round(y) / currentLevel.cellSize + 1;
			n = Math.round(x) / currentLevel.cellSize - 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if(collision)
					{
						//trace('bottom right')
						
						if (currentLevel.terrain[i][n][1] is stairObject)
						{
							health -= (verticalSpeed + horizontalSpeed)/200;
							//trace(health);
							
							if (fallGraphic.rotation != 45 && currentLevel.terrain[i][n][1].direction == 1)
							{
								horizontalSpeed = 0;
								fallGraphic.rotation = 45;
								hitBox.setRotate(45);
								redrawCollisionBox();
							}
							
							else if (fallGraphic.rotation != 120 && currentLevel.terrain[i][n][1].direction == 0)
							{
								fallGraphic.rotation = 120;
								hitBox.setRotate(120);
								redrawCollisionBox();
							}
						}
						
						else
						{
							if (fallGraphic.rotation > 0)
							{
								tripForwardGraphic.visible = false;
								tripBackwardGraphic.visible = false;
								fallGraphic.rotation = 90;
								
								lyingFrontGraphic.visible = true;
								
								hitBox.setRotate(90);
								redrawCollisionBox();
							}
							
							else
							{
								tripBackwardGraphic.visible = false;
								tripForwardGraphic.visible = false;
								fallGraphic.rotation = -90;
								
								lyingBackGraphic.visible = true;
								
								hitBox.setRotate(-90);
								redrawCollisionBox();
							}
								
							if (onGround == false)
							{
								health -= Math.abs(verticalSpeed);
								//trace(health);
								
								//if(!(sound is Bump))
								//{
									//if (sound != null)
										soundChannel.stop();
										
									var sound = new Bump();
									
									soundChannel = sound.play();
								//}
							}
							
							if (horizontalSpeed >= 1)
								horizontalSpeed -= 1;
								
							else if (horizontalSpeed <= -1)
								horizontalSpeed += 1
								
							else if (horizontalSpeed >= 0.1)
								horizontalSpeed -= 0.1
								
							else if (horizontalSpeed <= -0.1)
								horizontalSpeed += 0.1
							
							onGround = true;
							verticalSpeed = 0;
						}
					}
				}
			} 
			
			// checks cell below-right of player:
			i = Math.round(y) / currentLevel.cellSize + 1;
			n = Math.round(x) / currentLevel.cellSize + 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if(collision)
					{
						//trace('bottom right')
						
						if (currentLevel.terrain[i][n][1] is stairObject)
						{
							health -= (verticalSpeed + horizontalSpeed)/200;
							//trace(health);
							
							if (fallGraphic.rotation != 45 && currentLevel.terrain[i][n][1].direction == 1)
							{
								horizontalSpeed = 0;
								fallGraphic.rotation = 45;
								hitBox.setRotate(45);
								redrawCollisionBox();
							}
							
							else if (fallGraphic.rotation != 120 && currentLevel.terrain[i][n][1].direction == 0)
							{
								fallGraphic.rotation = 120;
								hitBox.setRotate(120);
								redrawCollisionBox();
							}
						}
						
						else
						{
							if (fallGraphic.rotation > 0)
							{
								tripForwardGraphic.visible = false;
								tripBackwardGraphic.visible = false;
								fallGraphic.visible = false;
								fallGraphic.rotation = 90;
								
								lyingFrontGraphic.visible = true;
								
								hitBox.setRotate(90);
								redrawCollisionBox();
							}
							
							else
							{
								tripBackwardGraphic.visible = false;
								tripForwardGraphic.visible = false;
								fallGraphic.visible = false;
								fallGraphic.rotation = -90;
								
								lyingBackGraphic.visible = true;
								
								hitBox.setRotate(-90);
								redrawCollisionBox();
							}
								
							if (onGround == false)
							{
								health -= Math.abs(verticalSpeed);
								//trace(health);
								
								//if(!(sound is Bump))
								//{
									//if (sound != null)
										soundChannel.stop();
										
									var sound = new Bump();
									
									soundChannel = sound.play();
								//}
							}
							
							if (horizontalSpeed >= 1)
								horizontalSpeed -= 1;
								
							else if (horizontalSpeed <= -1)
								horizontalSpeed += 1
								
							else if (horizontalSpeed >= 0.1)
								horizontalSpeed -= 0.1
								
							else if (horizontalSpeed <= -0.1)
								horizontalSpeed += 0.1
							
							onGround = true;
							verticalSpeed = 0;
						}
					}
				}
			}
			
			// checks cell above-left of player:
			i = Math.round(y) / currentLevel.cellSize - 1;
			n = Math.round(x) / currentLevel.cellSize - 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if (collision == true)
					{
						if (verticalSpeed < 0)
							verticalSpeed = 0;
						
						if (currentLevel.terrain[i][n][1] is staticCollisionTri)
						{
							//horizontalSpeed /= 3;
						}
					}
				}
			}
			
			// checks cell above-right of player:
			i = Math.round(y) / currentLevel.cellSize - 1;
			n = Math.round(x) / currentLevel.cellSize + 1;
			
			if (currentLevel.terrain[i] != null && currentLevel.terrain[i][n] != null && currentLevel.terrain[i][n][1] is collisionObject)
			{
				if (goThroughStairs == false || (currentLevel.terrain[i][n][1] is staticCollisionRect && currentLevel.terrain[i][n][1].optional == false) || currentLevel.terrain[i][n][1] is staticCollisionTri|| (currentLevel.terrain[i][n][1] is stairObject && currentLevel.terrain[i][n][1].optional == false))
				{
					collision = currentLevel.terrain[i][n][1].checkPolyCollision(this);
					
					if (collision == true)
					{
						if (verticalSpeed < 0)
							verticalSpeed = 0;
						
						if (currentLevel.terrain[i][n][1] is staticCollisionTri)
						{
							//horizontalSpeed /= 3;
						}
					}
				}
			}
		}
		
		private function AI():void
		{
			if (horizontalSpeed == 0)
				horizontalSpeed = 4;
			
			//check current node to make sure it is still closest, if not make closest new current node
			var bestNode:Node = null;
			var bestDistance = 0;
			var bestConnection;
			
			if (/*x < currentNode.x - 20 || */x > currentConnection.nodeB.x + 10)
			{
				//trace('past node')
				for (var i:int = 0; i < nodeList.length; i++)
				{
					
					//var distance = Math.abs(Math.sqrt(Math.abs(((nodeList[i].x - x) * (nodeList[i].x - x))) + Math.abs(((nodeList[i].y - (y + (height/2))) * (nodeList[i].y - (y + (height/2)))))))
					
					// calculate perpendicular distance to paths
					for (var n:int = 0; n < nodeList[i].connections.length; n++)
					{
						var vectorEdge = [nodeList[i].x - nodeList[i].connections[n].nodeB.x, nodeList[i].y - nodeList[i].connections[n].nodeB.y]
											
						var normalizedVector = [(vectorEdge[0])/Math.sqrt((vectorEdge[0] * vectorEdge[0]) + (vectorEdge[1] * vectorEdge[1])), (vectorEdge[1])/Math.sqrt((vectorEdge[0] * vectorEdge[0]) + (vectorEdge[1] * vectorEdge[1]))]					
						
						var rightNormal = [-normalizedVector[1],normalizedVector[0]];
						
						var projectionX = ((x * rightNormal[0] + (y + height/2) * rightNormal[1]) / (rightNormal[0] * rightNormal[0] + rightNormal[1] * rightNormal[1])) * rightNormal[0];
						var projectionY = ((x * rightNormal[0] + (y + height/2) * rightNormal[1]) / (rightNormal[0] * rightNormal[0] + rightNormal[1] * rightNormal[1])) * rightNormal[1];
						
						var scalarDist:Number = Math.abs(Math.sqrt(projectionX * projectionX + projectionY * projectionY));
						
						if (bestNode == null || scalarDist < bestDistance)
						{
							bestNode = nodeList[i];
							bestConnection = nodeList[i].connections[n];
							bestDistance = scalarDist;
						}
					}
				}
				
				currentNode = bestNode;
				//trace (currentNode);
				
				// make sure player is at current node
				if (bestNode.x > x)
					horizontalSpeed = 10;
					
				// pick random node to go to
				//else
					//currentConnection = currentNode.connections[Math.round(Math.random()) * (currentNode.connections.length - 1)];
			}
			
			// if reached node - pick connection + jump if neccesary
			if (currentConnection != null && x > currentConnection.nodeB.x - 4 && x < currentConnection.nodeB.x + 4)
			{
				//horizontalSpeed = 0;
				currentNode = currentConnection.nodeB;
				//trace ('changedNode')
				
				// if current node has connections - pick one + jump
				if (currentNode.connections.length > 0)
				{
					currentConnection = currentNode.connections[Math.round(Math.random()) * (currentNode.connections.length - 1)];
					
					//Jump
					if (currentConnection.type > 0 && currentConnection.type != 4 && currentConnection.type != 5)
					{
						// check if jump lands on trap, if not - do jump
						//for (var i:int = 0; i < 10; i++)
						//{
							//var point:Point = new Point(currentConnection.nodeB.x,currentConnection.nodeB.x);
//							currentLevel.proximityTree.addObject(point);
//							var neighbors:Array = currentLevel.proximityTree.getNeighbors(point);
//							currentLevel.proximityTree.removeObject(point);
//							
//							if (neighbors.length > 0)
//							{
//								for (var n:int = 0; n < neighbors.length; i++)
//								{
//									if (neighbors[n] is Trap)
//									{
//										
//									}
//									
//									else
//									{
//										// time in air required to cover x distance to current checking point
//										var time:Number = ((currentConnection.nodeB.x) - (x - width/2)) / horizontalSpeed;
//	
//										// convert into initial vertical speed
//										verticalSpeed = - ((time * gravity) / 2);
//										horizontalSpeed += i;
//										//i = 10;
//										
//										return;
//									}
//								}
//							}
//							
//							else
//							{
								// horizontal jump
								if (currentConnection.type == 1)
								{
									jumpGraphic.visible = true;
									jumpGraphic.play();
									
									Graphic.visible = false;
									Graphic.stop();
									
									if (Math.abs(currentConnection.nodeB.x - (x - width/2)) < 200)
										horizontalSpeed = 5;
										
									else
										horizontalSpeed = 7;
									
									onGround = false;
									var time:Number = (currentConnection.nodeB.x - (x - width/2)) / horizontalSpeed;
		
									// convert into initial vertical speed
									verticalSpeed = - ((time * gravity) / 2);
											
									return;
								}
								
								// jump up
								else if (currentConnection.type == 2)
								{
									jumpGraphic.visible = true;
									jumpGraphic.play();
									
									Graphic.visible = false;
									Graphic.stop();
									
									
									onGround = false;
									//time in air required to cover x distance to current checking point
									var time:Number = (currentConnection.nodeB.x - (x - width/2)) / horizontalSpeed;
							
									// convert into initial vertical speed
									verticalSpeed = - (((time * gravity) / 2) + 5);
									horizontalSpeed = 3;
									//i = 10;
									return;
								}
								
								//drop down
								else
								{
									onGround = false;
									//time in air required to cover x distance to current checking point
									var time:Number = (currentConnection.nodeB.x - (x - width/2)) / horizontalSpeed;
							
									// convert into initial vertical speed
									verticalSpeed = - ((time * gravity) / 2);
									//i = 10;
									return;
								}
							//}
							
							
						//}
					}
					
					else
					{
						if (x > currentConnection.nodeB.x)
							horizontalSpeed = 4;
					}
				}
			
				else
				{
					//trace ('nowhere to go')
					//currentConnection = null;
					
					//if (onGround)
						horizontalSpeed = 0;
						
					Graphic.stop();
				}
			}
			
			// not yet reached node
			else 
			{
				if (x > currentConnection.nodeB.x && currentConnection.nodeB.connections.length < 1/*&& onGround*/)
				{
					horizontalSpeed = 0;
					Graphic.stop();
				}
					
				// walk
				else if (currentConnection.type == 0)
				{
					horizontalSpeed = 4;
					
					if (onGround)
					{
						jumpGraphic.visible = false;
						jumpGraphic.stop();
						
						ladderGraphic.visible = false;
						ladderGraphic.stop();
						
						Graphic.visible = true
						Graphic.play();
					}
					goThroughStairs = true;
				}
					
				else if (currentConnection.type == 4 && onGround)
				{
					jumpGraphic.visible = false;
					jumpGraphic.stop();
					
					Graphic.visible = true
					Graphic.play();
					
					goThroughStairs = false;
					horizontalSpeed = 5;
				}
				
				else if (currentConnection.type == 5 && onGround)
				{
					jumpGraphic.visible = false;
					jumpGraphic.stop();
					
					Graphic.visible = true
					Graphic.play();
					
					goThroughStairs = false;
					horizontalSpeed = 1;
					verticalSpeed = 4;
				}
			}
		}
		
		private function trapCollide():void
		{
			var collision:Boolean = false;	
			var objArray:Array = currentLevel.proximityTree.getNeighbors(this);
						
			if (objArray != null && objArray.length - 1 > 0)
			{
				for (var i:int = 0; i <= objArray.length; i ++)
				{		
					// tripping trap
					if (objArray[i] != null && objArray[i] != this && objArray[i] is Trap && objArray[i].active == true)
					{
						if (objArray[i] is marble)
						{
							collision = objArray[i].playerCollide(this);
						}
							
						
						else if (collision = objArray[i].playerCollide(this))
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || objArray[i].impactSound2 == null) && objArray[i].impactSound != null)
								soundChannel == objArray[i].impactSound.play()
							
							else if ((soundChoice > 1 || objArray[i].impactSound3 == null) && objArray[i].impactSound2 != null)
								soundChannel == objArray[i].impactSound2.play()
							
							else if (soundChoice > 0 && objArray[i].impactSound3 != null)
								soundChannel == objArray[i].impactSound3.play()
							
							if (Engine.achievementManager.achievement3 == false && objArray[i] is tire)
							{
								Engine.achievementManager.achievement3 = true
								Engine.hud.addChild(new Achievement3Text());
							}
							
							if (Engine.achievementManager.achievement4 == false && objArray[i] is skateboard)
							{
								Engine.achievementManager.achievement4 = true
								Engine.hud.addChild(new Achievement4Text());
							}
							
							if (Engine.achievementManager.achievement6 == false && objArray[i] is globe)
							{
								Engine.achievementManager.achievement6 = true
								Engine.hud.addChild(new Achievement6Text());
							}
							
							if (Engine.achievementManager.achievement7 == false && objArray[i] is remoteControlCar)
							{
								Engine.achievementManager.achievement8 = true
								Engine.hud.addChild(new Achievement8Text());
							}
						}
							
						
						if (collision == true && AIEffect == null)
						{							
							if (objArray[i] is water)
							{ 
								if (objArray[i].y < y)
								{
									if (Engine.achievementManager.achievement7 == false)
									{
										Engine.achievementManager.achievement7 = true
										Engine.hud.addChild(new Achievement7Text());
									}
									
									objArray[i].active = false;
									AIEffect = 'soaked';
									AIEffectTimer = 100;
									health -= 20;
									
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									Graphic.visible = false;
									Graphic.stop();
									onGround = false;
									
									fallGraphic.visible = false;
									
									hurtFootGraphic.visible = false;
									hurtFootGraphic.stop();
									
									jumpGraphic.stop();
									jumpGraphic.visible = false;
									
									wetGraphic.play();
									wetGraphic.visible = true;
									
									hitBox.setRotate(0);
									
									horizontalSpeed = 1;
								}
							}
							
							else if (objArray[i] is oil && objArray[i].y < y)
							{
								objArray[i].active = false;
								AIEffect = 'soaked';
								AIEffectTimer = 100;
								health -= 20;
								
								for(var n:int = 0; n < animList.length; n++)
								{
									animList[n].stop();
									animList[n].visible = false;
								}
								
								Graphic.visible = false;
								Graphic.stop();
								
								fallGraphic.visible = false;
									
								hurtFootGraphic.visible = false;
								hurtFootGraphic.stop();
								
								jumpGraphic.stop();
								jumpGraphic.visible = false;
								
								oilyGraphic.visible = true;
								oilyGraphic.play();
								
								hitBox.setRotate(0);
									
								horizontalSpeed = 1;
							}
							
							else if (objArray[i] is paintPot && objArray[i].y < y && objArray[i].looping == true && physicalEffect == null)
							{
									trace ('stuck on head')
									
									soundChannel = new glugGlugGlug().play()
									
									horizontalSpeed = 0;
									objArray[i].active = false;
									objArray[i].looping = false;
									objArray[i].graphic.rotation = 180;
									AIEffect = 'stuckOnHead';
									AIEffectTimer = 80;
									hat = objArray[i]
									hat.x = x;
									hat.y = (y-height/2) + 5;
									health -= 20;
									
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									paintGraphic.visible = true;
									
									Graphic.visible = false;
									Graphic.stop();
							}
							
							else if (objArray[i] is TV && objArray[i].y < y && objArray[i].looping == true && physicalEffect == null)
							{
								objArray[i].active = false;
								objArray[i].looping = false;
								AIEffect = 'stuckOnHead';
								AIEffectTimer = 80;
								hat = objArray[i]
								hat.x = x;
								hat.y = (y-height/2) + 5;
								hat.graphic.rotation = -90;
								health -= 20;
								Graphic.stop();
							}
							
							else if (objArray[i] is painting  && objArray[i].y < y && objArray[i].looping == true && physicalEffect == null)
							{
								trace ('stuck on head')
								
								horizontalSpeed = 0;
								objArray[i].active = false;
								objArray[i].looping = false;
								AIEffect = 'stuckOnHead';
								AIEffectTimer = 80;
								hat = objArray[i]
								hat.x = x;
								hat.y = (y-height/2) + 10;
								hat.graphic.rotation = 0;
								health -= 20;
								Graphic.stop();
								hat.graphic.gotoAndStop(2);
							}
							
							else if (objArray[i] is stuckOnHeadTrap && objArray[i].y < y && objArray[i].looping == true && physicalEffect == null)
							{
								trace ('stuck on head')
								
								horizontalSpeed = 0;
								objArray[i].active = false;
								objArray[i].looping = false;
								AIEffect = 'stuckOnHead';
								AIEffectTimer = 80;
								hat = objArray[i]
								hat.x = x;
								hat.y = (y-height/2) + 5;
								health -= 20;
								Graphic.stop();
							}
						}
						
						if (collision == true && physicalEffect == null)
						{
							//trace ('effect')
							
							if (objArray[i] is trippingTrap)
							{
								if (Engine.achievementManager.achievement3 == false && objArray[i] is tire)
								{
									Engine.achievementManager.achievement3 = true
									Engine.hud.addChild(new Achievement3Text());
								}
								
								if (Engine.achievementManager.achievement4 == false && objArray[i] is skateboard)
								{
									Engine.achievementManager.achievement4 = true
									Engine.hud.addChild(new Achievement4Text());
								}
								
								if (Engine.achievementManager.achievement6 == false && objArray[i] is globe)
								{
									Engine.achievementManager.achievement6 = true
									Engine.hud.addChild(new Achievement6Text());
								}
								
								if (Engine.achievementManager.achievement7 == false && objArray[i] is remoteControlCar)
								{
									Engine.achievementManager.achievement7 = true
									Engine.hud.addChild(new Achievement7Text());
								}
								
								if (AIEffect == 'stuckOnHead')
								{
									hat.looping = true;
									hat = null;
									AIEffect = null;
									AIEffectTimer = 0;
								}
								
								if (objArray[i].y >= y)
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									objArray[i].active = false;
									physicalEffect = 'tripping';
									physicalEffectTimer = 100;
									
									if (objArray[i].x > x)
									{
										hitBox.setRotate(90);
										redrawCollisionBox();
										
										//fallGraphic.visible = true;
										fallGraphic.rotation = 90;
										tripForwardGraphic.visible = true;
										tripForwardGraphic.play();
									}
									
									else
									{
										hitBox.setRotate(-90);
										redrawCollisionBox();
									
										tripBackwardGraphic.visible = true;
										tripBackwardGraphic.play();
										fallGraphic.rotation = -90;
									}
									
									
									
									if(!(sound is Falling))
									{
										if (sound != null)
											soundChannel.stop();
											
										var sound = new Falling();
										
										soundChannel = sound.play();
									}
									
									verticalSpeed = -8;
									
									
									Graphic.visible = false;
									Graphic.stop();
									onGround = false;
									
									hurtFootGraphic.visible = false;
									hurtFootGraphic.stop();
									
									ladderGraphic.visible = false;
									ladderGraphic.stop();
									
									jumpGraphic.stop();
									jumpGraphic.visible = false;
									
									paintGraphic.visible = false;
									paintGraphic.stop();
								}
								
								else if (objArray[i].x >= x && (objArray[i].horizontalSpeed + objArray[i].verticalSpeed != 0))
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									trace('fallBackward')
									health -= 2 * (Math.abs(objArray[i].horizontalSpeed)  + Math.abs(objArray[i].verticalSpeed)); 
									
									physicalEffect = 'tripping';
									physicalEffectTimer = 100;
									
									if(!(sound is Falling))
									{
										if (sound != null)
											soundChannel.stop();
											
										var sound = new Falling();
										
										soundChannel = sound.play();
									}
									
									horizontalSpeed = -Math.abs(objArray[i].horizontalSpeed)/2;
									verticalSpeed = -4;
									
									hitBox.setRotate(-45);
									redrawCollisionBox();
									
									tripBackwardGraphic.visible = true;
									tripBackwardGraphic.play();
									fallGraphic.rotation = -45;
									
									ladderGraphic.visible = false;
									ladderGraphic.stop();
									
									Graphic.visible = false;
									Graphic.stop();
									onGround = false;
									
									jumpGraphic.stop();
									jumpGraphic.visible = false
								}
								
								else if (objArray[i].x < x  && (objArray[i].horizontalSpeed + objArray[i].verticalSpeed != 0))
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									trace('fall forward');
									health -= 2 * (Math.abs(objArray[i].horizontalSpeed) + Math.abs(objArray[i].verticalSpeed)); 
									
									physicalEffect = 'tripping';
									physicalEffectTimer = 100;
									
									if(!(sound is Falling))
									{
										if (sound != null)
											soundChannel.stop();
											
										var sound = new Falling();
										
										soundChannel = sound.play();
									}
									
									horizontalSpeed = Math.abs(objArray[i].horizontalSpeed);
									verticalSpeed = -4;
									
									hitBox.setRotate(45);
									redrawCollisionBox();
									
									tripForwardGraphic.visible = true;
									tripForwardGraphic.play();
									fallGraphic.rotation = 45;
									
									ladderGraphic.visible = false;
									ladderGraphic.stop();
									
									Graphic.visible = false;
									Graphic.stop();
									onGround = false;
									
									jumpGraphic.stop();
									jumpGraphic.visible = false
									
								}
							}
							
							else if (objArray[i] is slippingTrap && !(objArray[i] is water))
							{
								if (AIEffect == 'stuckOnHead')
								{
									hat.looping = true;
									hat = null;
									AIEffect = null;
									AIEffectTimer = 0;
								}
								
								
								
								if (objArray[i].y >= y + 25)
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
								
									objArray[i].active = false;
									physicalEffect = 'tripping';
									physicalEffectTimer = 100;
									
									var rand:Number = Math.round(Math.random());
									
									if (rand == 1)
									{
										hitBox.setRotate(90);
										redrawCollisionBox();
										
										tripForwardGraphic.visible = true;
										tripForwardGraphic.play();
										fallGraphic.rotation = 90;
									}
									
									else
									{
										hitBox.setRotate(-90);
										redrawCollisionBox();
										horizontalSpeed = 0;
									
										tripBackwardGraphic.visible = true;
										tripBackwardGraphic.play();
										fallGraphic.rotation = -90;
									}
									
									
									
									if(!(sound is Falling))
									{
										if (sound != null)
											soundChannel.stop();
											
										var sound = new Falling();
										
										soundChannel = sound.play();
									}
									
									verticalSpeed = -8;
									
									
									Graphic.visible = false;
									Graphic.stop();
									onGround = false;
									
									hurtFootGraphic.visible = false;
									hurtFootGraphic.stop();
									
									jumpGraphic.stop();
									jumpGraphic.visible = false;
									
									lyingFrontGraphic.stop();
									lyingFrontGraphic.visible = false;
									
									lyingBackGraphic.stop();
									lyingBackGraphic.visible = false;
									
									paintGraphic.visible = false;
									paintGraphic.stop();
									
									oilyGraphic.visible = false;
									oilyGraphic.stop();
								}
								
								else //if (objArray[i] is soap)
								{
									if (objArray[i].x >= x && (objArray[i].horizontalSpeed + objArray[i].verticalSpeed != 0))
									{
										for(var n:int = 0; n < animList.length; n++)
										{
											animList[n].stop();
											animList[n].visible = false;
										}
										
										trace('fallBackward')
										health -=  Math.abs(objArray[i].horizontalSpeed)  + Math.abs(objArray[i].verticalSpeed); 
										
										physicalEffect = 'tripping';
										physicalEffectTimer = 100;
										
										if(!(sound is Falling))
										{
											if (sound != null)
												soundChannel.stop();
												
											var sound = new Falling();
											
											soundChannel = sound.play();
										}
										
										horizontalSpeed = -Math.abs(objArray[i].horizontalSpeed)/2;
										verticalSpeed = -4;
										
										hitBox.setRotate(-45);
										redrawCollisionBox();
										
										Graphic.visible = false;
										Graphic.stop();
										onGround = false;
										
										tripBackwardGraphic.visible = true;
										tripBackwardGraphic.play();
										fallGraphic.rotation = 45;

										hurtFootGraphic.visible = false;
										hurtFootGraphic.stop();
										
										jumpGraphic.stop();
										jumpGraphic.visible = false;
										
										lyingFrontGraphic.stop();
										lyingFrontGraphic.visible = false;
									
										lyingBackGraphic.stop();
										lyingBackGraphic.visible = false;
										
										ladderGraphic.stop();
										ladderGraphic.visible = false;
										
										paintGraphic.visible = false;
										paintGraphic.stop();
										
										oilyGraphic.visible = false;
										oilyGraphic.stop();
									}
									
									else if (objArray[i].x < x  && (objArray[i].horizontalSpeed + objArray[i].verticalSpeed != 0))
									{
										for(var n:int = 0; n < animList.length; n++)
										{
											animList[n].stop();
											animList[n].visible = false;
										}
										
										trace('fall forward');
										health -=  Math.abs(objArray[i].horizontalSpeed) + Math.abs(objArray[i].verticalSpeed); 
										
										physicalEffect = 'tripping';
										physicalEffectTimer = 100;
										
										if(!(sound is Falling))
										{
											if (sound != null)
												soundChannel.stop();
												
											var sound = new Falling();
											
											soundChannel = sound.play();
										}
										
										horizontalSpeed = Math.abs(objArray[i].horizontalSpeed);
										verticalSpeed = -4;
										
										hitBox.setRotate(45);
										redrawCollisionBox();
										
										tripForwardGraphic.visible = true;
										tripForwardGraphic.play();
										fallGraphic.rotation = 45;
										
										Graphic.visible = false;
										Graphic.stop();
										onGround = false;
										
										hurtFootGraphic.visible = false;
										hurtFootGraphic.stop();
										
										jumpGraphic.stop();
										jumpGraphic.visible = false;
										
										lyingFrontGraphic.stop();
										lyingFrontGraphic.visible = false;
									
										lyingBackGraphic.stop();
										lyingBackGraphic.visible = false;
										
										paintGraphic.visible = false;
										paintGraphic.stop();
										
										oilyGraphic.visible = false;
										oilyGraphic.stop();
										
									}
								}
							}
							
							else if (objArray[i] is caltropTrap && onGround)
							{
								for(var n:int = 0; n < animList.length; n++)
								{
									animList[n].stop();
									animList[n].visible = false;
								}
								
								physicalEffect = 'caltrop';
								physicalEffectTimer = 100;
								
								objArray[i].active = false;
								if(!(sound is BurglarVoiceAargh))
								{
									if (sound != null)
										soundChannel.stop();
										
									var sound = new BurglarVoiceAargh();
									
									soundChannel = sound.play();
								}
								
								Graphic.stop();
								Graphic.visible = false;
								
								hurtFootGraphic.visible = true
								hurtFootGraphic.play();
								
								//if (x < objArray[i].x - 1)
									horizontalSpeed = 0;
									
								health -= 20;
								//trace(health);
							}
							
							else if (objArray[i] is swingUpTrap /*&& objArray[i].rotationSpeed < 0*/)
							{
								for(var n:int = 0; n < animList.length; n++)
								{
									animList[n].stop();
									animList[n].visible = false;
								}
								
								trace ('swing up')
								objArray[i].active = false;
								physicalEffect = 'swingUp';
								physicalEffectTimer = 10;	
								Graphic.visible = true;
								Graphic.stop();
								horizontalSpeed = 0;
							}		
							
							else if (objArray[i] is damageTrap)
							{
								objArray[i].active = false;
								
								horizontalSpeed = 0;
								
								if (objArray[i] is Flame || objArray[i] is Flame2)
								{
									if (Engine.achievementManager.achievement5 == false)
									{
										Engine.achievementManager.achievement5 = true
										Engine.hud.addChild(new Achievement5Text());
									}
									
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									physicalEffect = 'burned';
									physicalEffectTimer = 50;
									
									Graphic.visible = false;
									Graphic.stop();
									
									burntGraphic.visible = true
									burntGraphic.play();
									
									health -= 20;
								}
								
								else if (objArray[i] is Steam)
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									physicalEffect = 'steamed';
									physicalEffectTimer = 50;
									steamedGraphic.visible = true;
									steamedGraphic.play();
									health -= 20;
								}
								
								else if (objArray[i] is talcumPowder)
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									physicalEffect = 'choked';
									physicalEffectTimer = 50;
									powderedGraphic.visible = true;
									powderedGraphic.stop();
									health -= 20;
								}
								
								else if ((objArray[i] is Porridge || objArray[i] is porridgePowder) && objArray[i].y < y)
								{
									for(var n:int = 0; n < animList.length; n++)
									{
										animList[n].stop();
										animList[n].visible = false;
									}
									
									physicalEffect = 'choked';
									physicalEffectTimer = 50;
									Graphic.visible = false;
									Graphic.stop();
									powderedGraphic.visible = true;
									powderedGraphic.stop();
									health -= 20;
								}
							}
							
							else if (objArray[i] is Bed/*  && objArray[i].y > y + height/2*/)
							{
								trace ('bed')
								
								physicalEffect = 'tripping';
								physicalEffectTimer = 100;
								
								verticalSpeed = -10;
							}
							
							else if (objArray[i] is paintPot || objArray[i] is TV)
							{
								if (objArray[i].y >= y)
								{
									objArray[i].active = false;
									physicalEffect = 'tripping';
									physicalEffectTimer = 100;
									
									if (objArray[i].x > x)
									{
										hitBox.setRotate(90);
										redrawCollisionBox();
										
										//fallGraphic.visible = true;
										fallGraphic.rotation = 90;
										tripForwardGraphic.visible = true;
										tripForwardGraphic.play();
									}
									
									else
									{
										hitBox.setRotate(-90);
										redrawCollisionBox();
									
										//fallGraphic.visible = true;
										tripBackwardGraphic.visible = true;
										tripBackwardGraphic.play();
										fallGraphic.rotation = -90;
									}
									
									
									
									if(!(sound is Falling))
									{
										if (sound != null)
											soundChannel.stop();
											
										var sound = new Falling();
										
										soundChannel = sound.play();
									}
									
									verticalSpeed = -8;
									
									
									Graphic.visible = false;
									Graphic.stop();
									onGround = false;
									
									hurtFootGraphic.visible = false;
									hurtFootGraphic.stop();
									
									jumpGraphic.stop();
									jumpGraphic.visible = false;
								}
							}
						}
						
						if (collision == true)
						{
							trace('collide')
							objArray[i].active = false
						}
					}
				}
			}
		}
			
		
		private function normalLoop():void
		{
			// this function checks for the ai players best path and sets his speed 
			AI();
			
			//if (Engine.KeyArray[37][1] && horizontalSpeed > -5)
//			{
//				horizontalSpeed -= 5;
//				
//				if (horizontalSpeed < 0)
//				{
//					//Graphic.x += Graphic.width;
//					Graphic.scaleX = -1
//				}
//			}
//				
//			if (Engine.KeyArray[39][1] && horizontalSpeed < 5)
//			{
//				horizontalSpeed += 5;
//				
//				if (horizontalSpeed > 0)
//				{
//					//Graphic.x -= Graphic.width;
//					Graphic.scaleX = 1;
//				}
//			}
//			
//			if (Engine.KeyArray[38][1] && onGround)
//			{
//				verticalSpeed = -8;
//				onGround = false;
//			}
				
			//if (Engine.KeyArray[82][0])
				//rotate(1);
			
			// this code moves the player based on his current speed and triggers collision check, iterates so that player never moves more than 1 between collisions
			
		}
		
		private function trippedLoop():void
		{
			if (physicalEffectTimer > 0)
			{
				var bestNode:Node = null;
				var bestDistance = 0;
				
				if (x < currentNode.x - 10 || x > currentConnection.nodeB.x + 10)
				{
					//trace('past node')
					for (var i:int = 0; i < nodeList.length; i++)
					{
						var distance = Math.abs(Math.sqrt(Math.abs(((nodeList[i].x - x) * (nodeList[i].x - x))) + Math.abs(((nodeList[i].y - (y + (height/2))) * (nodeList[i].y - (y + (height/2)))))))
						
						if (bestNode == null || (distance < bestDistance  &&  Math.abs(nodeList[i].y - (y + (height/2))) < 40))
						{
							bestNode = nodeList[i];
							bestDistance = distance;
							
						}
					}
					
					currentNode = bestNode;
						
					// pick random node to go to
					if (!(bestNode.x > x))
						currentConnection = currentNode.connections[Math.round(Math.random()) * (currentNode.connections.length - 1)];
				}
				
				if (currentConnection.type == 4 || currentConnection.type ==5)
					goThroughStairs = false;
				
				physicalEffectTimer --;
			}
			
			else 
			{
				physicalEffect = null;
				
				hitBox.setRotate(0);
				redrawCollisionBox();
				Graphic.rotation = 0;
				Graphic.play();
				Graphic.visible = true;
				y -= (height/2) - 15;
				
				fallGraphic.visible = false;
				fallGraphic.rotation = 0;
				
				lyingFrontGraphic.visible = false;
				lyingBackGraphic.visible = false;
				
				
				var bestNode:Node = null;
				var bestDistance = 0;
				
				//trace('past node')
				for (var i:int = 0; i < nodeList.length; i++)
				{
					var distance = Math.abs(Math.sqrt(Math.abs(((nodeList[i].x - x) * (nodeList[i].x - x))) + Math.abs(((nodeList[i].y - (y + (height/2))) * (nodeList[i].y - (y + (height/2)))))))
					
					//trace(i);
					//trace(distance);
					
					if (bestNode == null || (distance < bestDistance &&  Math.abs(nodeList[i].y - (y + (height/2))) < 40))
					{
						bestNode = nodeList[i];
						bestDistance = distance;
						
					}
				}
				
				currentNode = bestNode;
				//trace (currentNode)
					
				// pick random node to go to
				if (!(bestNode.x > x))
					currentConnection = currentNode.connections[Math.round(Math.random()) * (currentNode.connections.length - 1)];

				
				if (currentConnection.type == 4 || currentConnection.type ==5)
					goThroughStairs = false;
			}
		}
		
		private function caltropLoop():void
		{
			if (physicalEffectTimer > 0)
			{ 
				if (onGround)
				{
					//onGround = false;
					//verticalSpeed = -5;
				}
				
				physicalEffectTimer --;
			}
			
			else //if (onGround)
			{
				//horizontalSpeed = 4;
				physicalEffect = null;
				hurtFootGraphic.stop();
				hurtFootGraphic.visible = false;
				
				Graphic.play();
				Graphic.visible = false;
				
				if (onGround)
				{
					horizontalSpeed = 4;
					verticalSpeed = -8;
					onGround = false;
					
					jumpGraphic.visible = true;
					jumpGraphic.play();
				}				
			}
		}
		
		private function swingUpLoop()
		{
			physicalEffectTimer --;
			
			if (physicalEffectTimer == 0)
			{
				health -= 20;
				trace('fallBackward')
								
				physicalEffect = 'tripping';
				physicalEffectTimer = 100;
				
				if(!(sound is Falling))
				{
					if (sound != null)
						soundChannel.stop();
						
					var sound = new Falling();
					
					soundChannel = sound.play();
				}
				
				horizontalSpeed = -4;
				verticalSpeed = -4;
				
				hitBox.setRotate(-45);
				redrawCollisionBox();
				
				//fallGraphic.visible = true;
				tripBackwardGraphic.visible = true;
				tripBackwardGraphic.play();
				fallGraphic.rotation = -45;
				
				Graphic.visible = false;
				Graphic.stop();
				onGround = false;
				
				jumpGraphic.stop();
				jumpGraphic.visible = false
			}
		}
		
		private function burnedLoop():void
		{
			if (physicalEffectTimer > 0)
			{ 
				physicalEffectTimer --;
			}
			
			else
			{
				physicalEffect = null;
				
				Graphic.play();
				Graphic.visible = true;
				
				burntGraphic.visible = false;
				burntGraphic.stop();
				
				horizontalSpeed = 4;
			}
		}
		
		private function steamedLoop():void
		{
			if (physicalEffectTimer > 0)
			{ 
				physicalEffectTimer --;
				
				if (steamedGraphic.currentFrame == steamedGraphic.totalFrames)
					steamedGraphic.stop();
			}
			
			else
			{
				physicalEffect = null;
				
				steamedGraphic.visible = false;
				steamedGraphic.stop();
				
				Graphic.play();
				Graphic.visible = true;
				
				horizontalSpeed = 4;
			}
		}
		
		private function chokedLoop():void
		{
			if (physicalEffectTimer > 0)
			{ 
				physicalEffectTimer --;
				
				//if (physicalEffectTimer == 20)
					//powderedGraphic.play();
			}
			
			else
			{
				physicalEffect = null;
				
				powderedGraphic.visible = false;
				powderedGraphic.stop();
				
				Graphic.play();
				Graphic.visible = true;
				
				horizontalSpeed = 4;
			}
		}
		
		private function stuckOnHeadLoop():void
		{
			if (AIEffectTimer > 0)
			{
				hat.x = x;
				hat.y = (y-height/2) + 10;
				AIEffectTimer --;
				
				if (AIEffectTimer == 50)
				{
					paintGraphic.play();
					Graphic.play();
					horizontalSpeed = 3;
				}
				
				if (hat is TV)
				{
					hat.graphic.rotation = -90;
					
					if (AIEffectTimer <= 60 && AIEffectTimer >= 55)
					{
						Graphic.visible = false;
						Graphic.stop();
						
						electrocutionGraphic.visible = true;
						electrocutionGraphic.play();
						
						soundChannel = new electricSound().play();
						
						if (AIEffectTimer == 40)
							health -= 10
						
						horizontalSpeed = 0;
					}
					
					else if (AIEffectTimer <= 40 && AIEffectTimer >= 35)
					{
						Graphic.visible = false;
						Graphic.stop();
						
						electrocutionGraphic.visible = true;
						electrocutionGraphic.play();
						
						soundChannel = new electricSound().play();
						
						if (AIEffectTimer == 40)
							health -= 10
						
						horizontalSpeed = 0;
					}
					
					else if (AIEffectTimer <= 20 && AIEffectTimer >= 15)
					{
						Graphic.visible = false;
						Graphic.stop();
						
						electrocutionGraphic.visible = true;
						electrocutionGraphic.play();
						
						soundChannel = new electricSound().play();
						
						if (AIEffectTimer == 40)
							health -= 10
						
						horizontalSpeed = 0;
					}
					
					else
					{
						Graphic.visible = true;
						Graphic.play();
						
						electrocutionGraphic.visible = false;
						electrocutionGraphic.stop();
						
						horizontalSpeed = 4;
					}
				}
			}
			
			
			
			else //if (onGround)
			{
				//horizontalSpeed = 4;
				paintGraphic.visible = false;
				paintGraphic.stop;
				
				Graphic.visible = true;
				Graphic.play();
				hat.looping = true;
				hat.verticalSpeed = 0.4;
				AIEffect = null;
				hat.graphic.gotoAndStop(3);
			}
		}
		
		private function soakedLoop():void
		{
			if (AIEffectTimer > 0)
			{
				AIEffectTimer --;
			}
						
			else //if (onGround)
			{
				//horizontalSpeed = 4;
				wetGraphic.visible = false;
				wetGraphic.stop;
				
				oilyGraphic.visible = false
				oilyGraphic.stop();
				
				Graphic.visible = true;
				Graphic.play();
				AIEffect = null;
			}
		}
		
		private function iterMove():void
		{
			rotate(rotationSpeed);
			
			if (verticalSpeed != 0 && Math.sqrt(verticalSpeed * verticalSpeed) >= Math.sqrt(horizontalSpeed * horizontalSpeed))
			{
				moveIters = Math.sqrt(verticalSpeed * verticalSpeed);
				
				for (var i:int = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(verticalSpeed * verticalSpeed) != 0)
						y += verticalSpeed / Math.sqrt(verticalSpeed * verticalSpeed);
						
					x += horizontalSpeed / moveIters;
					
					if (physicalEffect == 'tripping')
						trippedTerrainCollide();
					
					else
						terrainCollide();
					
					trapCollide();
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
										
					if (physicalEffect == 'tripping')
						trippedTerrainCollide();
						
					else
						terrainCollide();
						
					trapCollide();
				}
			}
		}
		
		public function loop():void
		{
			if (waiting == false)
			{
				pullingDoorGraphic.visible = false;
				pullingDoorGraphic.stop();
				
				if (physicalEffect == null && AIEffect == null)
					normalLoop();
					
				else if (physicalEffect == 'tripping')
					trippedLoop();
					
				else if (physicalEffect == 'caltrop')
					caltropLoop();
					
				else if (physicalEffect == 'swingUp')
					swingUpLoop();
					
				else if (physicalEffect == 'burned')
					burnedLoop();
					
				else if (physicalEffect == 'steamed')
					steamedLoop();
					
				else if (physicalEffect == 'choked')
					chokedLoop();
				
				else if (AIEffect == 'stuckOnHead')
					stuckOnHeadLoop();
					
				else if (AIEffect == 'soaked')
					soakedLoop();
				
				iterMove();
				
				if (AIEffect == 'stuckOnHead')
				{
					hat.x = x;
					hat.y = (y-height/2) + 10;
				}

				if (health > 0)
				{
					Engine.hud.healthBar.scaleX = health/100;
					
					if (health < maxHealth && Engine.achievementManager.achievement1 == false)
					{
						Engine.achievementManager.achievement1 = true;
						Engine.hud.addChild(new Achievement1Text());
					}
				}
					
				else
				{
					Engine.hud.healthBar.scaleX = 0;
				}
				
						
				//if (verticalSpeed < fallingMaxSpeed)
					verticalSpeed += gravity;
					
				if (x < 10)
					x = 10;
			}
		}
	}
}