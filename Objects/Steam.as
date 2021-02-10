package
{
	import flash.display.BlendMode;
	
	public class Steam extends physicsParticle
	{
		public function Steam(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new steamGraphic());
			x=X;
			y=Y;
			
			filters = [];
			
			looping = true;
			verticalSpeed = -10;
			horizontalSpeed = - 10;
		}
		
		override public function loop():void
		{
			if (verticalSpeed < 0)
			{
				y += verticalSpeed;
				x += horizontalSpeed;
				
				if (scaleX > 0)
					scaleX = scaleY += 0.1;
				
				horizontalSpeed++;
				verticalSpeed ++;
			}
			
			else
			{
				looping = false;
				removeSelf();
				level.removeChild(this);
			}
		}
	}
}