﻿package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class water extends fluidTrap
	{
		public function water(level:Level,X = 0,Y = 0,speed = 0,bag:Class = null)
		{
			super(level,X,Y,new waterGraphic());
			friction = 0.02;
			horizontalSpeed = speed;
			changeMode();
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			looping = true;
			noCollideObject = bag;
		}
		
		override public function loop():void
		{
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				looping = false;
				return;
			}
			
			if (onGround == false)
				verticalSpeed += gravity;
			
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
			
			else if (onGround == false)
				verticalSpeed += gravity;
				
			if (x < -width/2 || x > level.actualWidth + 40)
				looping = false;
		}
	}
}