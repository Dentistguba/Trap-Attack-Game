package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class swingUpTrap extends Trap
	{		
		private var damagingEnd;
		private var swinging:Boolean = true;
	
		public function swingUpTrap(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,graphic,true,true);
			boxGraphic.x += boxGraphic.width/2;
			startSound = new rakeSound1();
			//damagingEnd = new collisionPoly([new Point(-8,-8),new Point(-8,8),new Point(8,8),new Point(8,-8)],new Point(-width/2,0),this);
		}
		
		override public function playerCollide(target,movement = true):Boolean
		{
			//var collision:Boolean = false;
			
			if (target.hitBox.checkPolyCollision(this,true,0,false))
			{
				//if (hanging == false)
				//{
					rotationSpeed = - 10;
					swinging = true;
					trace(graphic.rotation)
					looping = true;
					soundChannel = startSound.play();
					return(true);
				//}
								
				//else
					//return(false);
			}
				
			else
				return(false);
		}
		
		override public function loop():void
		{
			if (swinging == true)
			{
				if (graphic.rotation <= -80)
				{
					rotationSpeed = 1;
				}
				
				else if (graphic.rotation < 0 && rotationSpeed > 0)
				{
					rotationSpeed ++;
				}
				
				else if (rotationSpeed > 0)
				{
					soundChannel = impactSound.play();
					graphic.rotation = 0;
					rotationSpeed = 0;
					swinging = false;
					looping = false;
					active = false;
				}
				
				//if (graphic != null)
						graphic.rotation += rotationSpeed;
						
				//hitBox.setRotate(graphic.rotation);
			}

			else
			{
				iterMove();
							
				//hitBox.rotate(rotationSpeed);
				
				if (rotationSpeed >= 0.5)
				{
					rotationSpeed -= 0.5;
				}
				
				else if (rotationSpeed <= -0.5)
				{
					rotationSpeed += 0.5;
				}
				
				else if (rotationSpeed >= 0.1)
				{
					rotationSpeed -= 0.1;
				}
				
				else if (rotationSpeed <= -0.1)
				{
					rotationSpeed += 0.1;
				}
				
				else
					rotationSpeed = 0;
				
				if (hanging == false)
				{
					if (graphic != null)
						graphic.rotation += rotationSpeed;
					
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
					
					if (onGround)
					{
					}
					
					else
					{
						graphic.rotation += rotationSpeed;
						
						if (rotationSpeed > 0)
							rotationSpeed -= 0.5;
							
						else
							rotationSpeed += 0.5;
					}
					
					if (horizontalSpeed == 0 && verticalSpeed == 0 && rotationSpeed == 0)
					{
						alpha = 0.5;				//active = false;
						looping = false;
					}
					
					else
						verticalSpeed += gravity;
				}
				
				if (x < 0 || x > level.actualWidth)
					looping = false;
			}
		}
	}
}