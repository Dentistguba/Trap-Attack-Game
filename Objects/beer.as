package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class beer extends slippingTrap
	{
		public function beer(level:Level,X = 0,Y = 0,speed = 0,bag:Class = null)
		{
			super(level,X,Y,new beerGraphic());
			friction = 0.02;
			horizontalSpeed = speed;
			verticalSpeed += gravity;
			changeMode();
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			looping = true;
			noCollideObject = bag;
		}
		
		override protected function trapCollide():void
		{
			var neighbors = level.proximityTree.getNeighbors(this);
					
			for (var i:int = 0; i <= neighbors.length; i ++)
			{				
				if (neighbors[i] is Trap && neighbors[i] != null && neighbors[i] != this && !(noCollideObject != null && neighbors[i] is noCollideObject) && neighbors[i].hitBox != null)
				{
					if (x + (width/2) > neighbors[i].x - (width/2) && x - (width/2) < neighbors[i].x + (width/2) && y + (height/2) > neighbors[i].y - (height/2) && y - (height/2) < neighbors[i].y + (height/2))
					{
						if (neighbors[i] is beer || neighbors[i] is bleach || neighbors[i] is oil)
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,true,0,true))
							{
								if (neighbors[i].looping == false && y > neighbors[i].y - 2 && y < neighbors[i].y + 2)
								{
									looping = false; 
								}
							}
						}

						
						else
							neighbors[i].hitBox.checkTrapPolyCollision(this,false,0)
					}
				}
			}
		}
		
		override public function loop():void
		{
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				looping = false;
				return;
			}
			
			if (horizontalSpeed < 0)
				graphic.rotation += rotationSpeed = 360 /((width * 3.142) / horizontalSpeed);
				
			else
				graphic.rotation += rotationSpeed = 360 /((width * 3.142) / horizontalSpeed);
			
			iterMove();
						
			//if (graphic != null)
				//graphic.rotation += rotationSpeed;
				
			//hitBox.rotate(rotationSpeed);
			
			//if (rotationSpeed >= 0.5)
			//{
				//rotationSpeed -= 0.5;
			//}
			
			//else if (rotationSpeed <= -0.5)
			//{
				//rotationSpeed += 0.5;
			//}
			
			if (horizontalSpeed <= -friction)
			{
				horizontalSpeed += friction
			}
			
			else if (horizontalSpeed >= friction)
			{
				horizontalSpeed -= friction;
			}
			
			else
			{
				horizontalSpeed = 0;
			}
			
			//if (onGround)
			//{
				
			//}
			
			//else
			//{
				//graphic.rotation += rotationSpeed;
				
				//if (rotationSpeed > 0)
					//rotationSpeed -= 0.5;
					
				//else
					//rotationSpeed += 0.5;
			//}
			
			if (horizontalSpeed == 0 && verticalSpeed == 0)
			{
				alpha = 0.5;				//active = false;
				looping = false;
			}
			
			//else if (onGround == false)
				verticalSpeed += gravity;
				
			if (x < -width/2 || x > level.actualWidth + 40)
				looping = false;
		}
	}
}