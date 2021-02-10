package
{
	import flash.display.BlendMode;
	
	public class talcumPowder extends physicsParticle
	{
		public function talcumPowder(level:Level,X = 0,Y = 0,speed = 0)
		{
			super(level,X,Y,new talcumPowderGraphic());
			x=X;
			y=Y;
			
			friction = 0.01;
			
			filters = [];
			//cacheAsBitmap = true;
			blendMode = BlendMode.ADD;
			noCollideObject = talcumPowderTub;
			
			looping = true;
			verticalSpeed = (Math.random() - 0.5) * 2;
			horizontalSpeed = (Math.random()) * speed;
		}
		
		
		
		override public function loop():void
		{
			if (verticalSpeed != 0 && alpha > 0)
			{
				y += verticalSpeed;
				x += horizontalSpeed;
				
				if (scaleX > 0)
					scaleX = scaleY += 0.01;
				
				if (verticalSpeed < 0)
					verticalSpeed += 0.01;
					
				else
					verticalSpeed -= 0.01;
				
				alpha -= 0.01;
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