package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.motion.Color;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;


	
	
	public class swingingTrap extends Trap
	{		
		public var swingingObject;
		private var origin
		private var constraintDist:int = 100;
		private var tempGraphic;
	
		public function swingingTrap(level:Level,O,X = 0,Y = 0)
		{
			swingingObject = O;
			
			var exampleName:String = getQualifiedClassName(swingingObject.graphic);
			var exampleType:Class = getDefinitionByName( exampleName ) as Class;
			
			tempGraphic = addChild(new exampleType());
			
			tempGraphic.x =  constraintDist;
			tempGraphic.y =  swingingObject.actualHeight/2;
			
			
			graphic = new Shape();
			graphic.graphics.moveTo(0,0);
			graphic.graphics.lineStyle(2)
			graphic.graphics.lineTo(tempGraphic.x,tempGraphic.y);	
			
			graphic.graphics.beginFill(0xFF5555,0.5);
			graphic.graphics.drawRect(-5,0, 10,10);
			graphic.graphics.endFill();

			
			super(level,X,Y,graphic);
			//level.trapList.push(swingingObject = level.addChild(new rope(level,X + 100,Y + 2)));
			
			boxGraphic.x += width/4 + 10;
			boxGraphic.y += height/4 + 4;

			swingingObject.visible = false;
			
			swingingObject.x = x + constraintDist;
			swingingObject.y = y + (swingingObject.actualHeight/2);
			
			tempGraphic.x =  constraintDist;
			tempGraphic.y =  swingingObject.actualHeight/2;
			
			graphic.graphics.moveTo(0,0);
			graphic.graphics.lineStyle(2)
			graphic.graphics.lineTo(tempGraphic.x,tempGraphic.y);			
			
			startSound = new ropeSound1();
		}
		
		public function finalise():void
		{
			level.dragging = true;
			dragging = true;
			
			swingingObject.dragging = false;
			
			swingingObject.hanging = true;
			swingingObject.removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			swingingObject.removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			swingingObject.removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			swingingObject.filters = [];
			//swingingObject.endDrag();
			
			level.addChild(new TrapCombinedText(x,y));
		}
		
		override protected function iterMove():void
		{
			if (verticalSpeed != 0 && Math.sqrt(verticalSpeed * verticalSpeed) >= Math.sqrt(horizontalSpeed * horizontalSpeed))
			{
				if (verticalSpeed > 1 || verticalSpeed < -1)
					var moveIters = Math.abs(Math.sqrt(verticalSpeed * verticalSpeed));
					
				else
					moveIters = 1;
				
				for (var i:int = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(verticalSpeed * verticalSpeed) != 0)
						y += verticalSpeed / Math.sqrt(verticalSpeed * verticalSpeed);
						
					x += horizontalSpeed / moveIters;
					
					level.proximityTree.refresh();
					trapCollide();
					terrainCollide();
					
				}
			}
				
			else 
			{
				if (horizontalSpeed > 1 || horizontalSpeed < -1)
					moveIters = Math.abs(Math.sqrt(horizontalSpeed * horizontalSpeed));
					
				else
					moveIters = 1;
				
				for ( i = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(horizontalSpeed * horizontalSpeed) != 0)
						x += horizontalSpeed / Math.sqrt(horizontalSpeed * horizontalSpeed);
												
					y += verticalSpeed / moveIters;
										
					level.proximityTree.refresh();
					trapCollide();
					terrainCollide();
					
				}
			}
		}
		
		override protected function trapCollide():void
		{
			
		}
		
		override protected function terrainCollide():void
		{
			
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			//if (mouseX < 0)
				//horizontalSpeed = 3;
			
			//else
				//horizontalSpeed = -3;
				
			soundChannel = startSound.play();
				
			looping = true;
			removeChild(tempGraphic);
			tempGraphic = null;
			swingingObject.visible = true;
			
			if ('spill' in swingingObject)
				swingingObject.spill();
			
			swingingObject.removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		override public function playerCollide(target,movement = true):Boolean
		{
			//var collision:Boolean = false;
			
			//collision = swingingObject.hitBox.checkPolyCollision(target,false,0,movement);
			
			return(false);
		}
		
		override protected function snap():void
		{
			var neighbors:Array;
			
			var i:int = Math.round(y) / level.cellSize;
			var n:int = Math.round(x) / level.cellSize;
			
			if (level.terrain[i] != null && level.terrain[i][n] != null && !(level.terrain[i][n][1] is collisionObject))
			{				
				if (level.terrain[i - 1][n] != null && level.terrain[i - 1][n][1] != null && (level.terrain[i - 1][n][1] is staticCollisionRect || level.terrain[i - 1][n][1] is staticCollisionOct))
				{
					y = ((i * level.cellSize))
					
					snapped = true;
					//trace('blah');
					
					if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
					{
						level.terrain[i][n + 1][1].checkPolyCollision(this,true);
						//boxCollide(level.terrain[i][n + 1][1]);
					}
					
					if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
					{
						level.terrain[i][n - 1][1].checkPolyCollision(this,true);
						//boxCollide(level.terrain[i][n - 1][1]);
					}
					
					level.proximityTree.refresh();
					
					neighbors = level.proximityTree.getNeighbors(this);
					
					for (var i:int = 0; i <= neighbors.length; i ++)
					{				
						if (neighbors[i] != null && neighbors[i] != this)
						{
							neighbors[i].hitBox.checkPolyCollision(this,true);
						}
					}
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0x000000,0);
					transform.colorTransform = tint;
				}
				
				else
				{
					snapped = false;
					
					if (level.terrain[i][n][1] != null)
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
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0xFF0000,0.5);
					transform.colorTransform = tint;
				}
			}
			
			else 
			{
				if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && (level.terrain[i - 1][n][1] == null ||(level.terrain[i - 1][n][1] != null && level.terrain[i - 1][n][1] is collisionObject)))
				{
					if (level.terrain[i][n][1] != null)
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
					y = (i * level.cellSize) + level.cellSize;
					
					snapped = true;
					level.proximityTree.refresh();
					
					neighbors = level.proximityTree.getNeighbors(this);
					
					for (var i:int = 0; i <= neighbors.length; i ++)
					{				
						if (neighbors[i] != null && neighbors[i] != this)
						{
							neighbors[i].hitBox.checkPolyCollision(this,true);
						}
					}
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0xFF0000,0);
					transform.colorTransform = tint;
				}
				
				else
				{
					snapped = false;
					
					if (level.terrain[i][n][1] != null)
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
						level.terrain[i + 1][n][1].checkPolyCollision(this)
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
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0xFF0000,0.5);
					transform.colorTransform = tint;
				}
			}
			
			swingingObject.x = x + constraintDist;
			swingingObject.y = y + (swingingObject.actualHeight/2);
		}
		
		override public function loop():void
		{
			swingingObject.loop();		
			
			var distance:Number = Math.sqrt(((swingingObject.x - x) * (swingingObject.x - x)) + ((swingingObject.y - y) * (swingingObject.y - y)));
			var angle:Number = swingingObject.y - y / swingingObject.x - x
			
			var swingingObjectAngle = Math.atan2(swingingObject.x - x, swingingObject.y - y) /(Math.PI/180);
			
			if (distance > constraintDist)
			{
				if (swingingObjectAngle < 90 && swingingObjectAngle >= 45)
					swingingObject.horizontalSpeed += (swingingObjectAngle - 90) / 8;
					
				else if (swingingObjectAngle < 45 && swingingObjectAngle > 0)
					swingingObject.horizontalSpeed -= (swingingObjectAngle) / 8;
					
				else if (swingingObjectAngle < 0 && swingingObjectAngle >= -45)
					swingingObject.horizontalSpeed -= (swingingObjectAngle) / 8;
				
				else if (swingingObjectAngle < -45 && swingingObjectAngle > -90)
					swingingObject.horizontalSpeed += (swingingObjectAngle + 90) / 8;
					
				swingingObject.y -= (Math.cos(swingingObjectAngle * (Math.PI/180)) * (distance - constraintDist));												
				swingingObject.x -= (Math.sin(swingingObjectAngle * (Math.PI/180)) * (distance - constraintDist));
			}
			
			else
				swingingObject.verticalSpeed += gravity;
				
			graphic.graphics.clear();
			graphic.graphics.moveTo(-graphic.height/2,0);
			graphic.graphics.lineStyle(2)
			graphic.graphics.lineTo((swingingObject.x - x),swingingObject.y - y);

			if (x < 0 || x > level.actualWidth)
				looping = false;
			
			//if (swingingObject.x < x)
			//{
				//if (swingingObject.y < y)
					//swingingObject.horizontalSpeed += ((x - swingingObject.x) * (y - swingingObject.y)) / 16;
					
				//else
					//swingingObject.horizontalSpeed += ((x - swingingObject.x) * (swingingObject.y - y)) / 16;
			//}
				
			//else if (swingingObject.x > x)
			//{
				//if (swingingObject.y < y)
					//swingingObject.horizontalSpeed -= ((swingingObject.x - x) * (y - swingingObject.y)) / 16;	
					
				//else
					//swingingObject.horizontalSpeed += ((x - swingingObject.x) * (swingingObject.y - y)) / 16;
			//}
		}
	}
}