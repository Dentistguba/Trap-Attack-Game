package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class toySoldier extends caltropTrap
	{
		public function toySoldier(level:Level,X = 0,Y = 0,speed:int = 0,box:Class = null)
		{
			super(level,X,Y,new toySoldierGraphic());
			horizontalSpeed = speed;
			
			if (speed > 0)
				rotationSpeed = 9;
			
			else
				rotationSpeed = -9;
			
			changeMode();
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			looping = true;
			noCollideObject = box;
		}
		
		override public function loop():void
		{
			if (onGround == false)
				verticalSpeed += gravity;
			
			iterMove();
			
			rotationSpeed = horizontalSpeed * 2;
						
			if (graphic != null)
				graphic.rotation += rotationSpeed;
				
			hitBox.rotate(rotationSpeed);
			
			if (rotationSpeed >= 0.5)
			{
				rotationSpeed -= 0.5;
			}
			
			else if (rotationSpeed <= -0.5)
			{
				rotationSpeed += 0.5;
			}
			
			if (horizontalSpeed <= -0.1)
			{
				horizontalSpeed += 0.1
			}
			
			else if (horizontalSpeed >= 0.1)
			{
				horizontalSpeed -= 0.1;
			}
			
			else
			{
				horizontalSpeed = 0;
			}
			
			if (verticalSpeed == 0 && horizontalSpeed == 0)
			{
				trace ('stoppedLooping')
				looping = false;
			}
			
			if (onGround == false)
				verticalSpeed += gravity;
		}
	}
}