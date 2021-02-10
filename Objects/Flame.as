package
{
	import flash.display.BlendMode;
	
	public class Flame extends physicsParticle
	{
		public function Flame(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new flameGraphic());
			x=X;
			y=Y;
			
			filters = [];
			blendMode = BlendMode.ADD;
			
			looping = true;
			verticalSpeed = -10;
			
			impactSound = null;
			impactSound2 = null;
			impactSound3 = null;
		}
		
		override public function loop():void
		{
			if (verticalSpeed < 0)
			{
				y += verticalSpeed;
				
				if (scaleX > 0)
					scaleX = scaleY -= 0.1;
				
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