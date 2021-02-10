package
{
	import flash.display.BlendMode;
	
	public class Flame2 extends physicsParticle
	{
		public function Flame2(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new flameGraphic2());
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