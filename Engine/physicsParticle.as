package
{
	public class physicsParticle extends damageTrap
	{
		private var life:int;
		
		public function physicsParticle(level,X = 0,Y = 0,graphic = null,Life = 10)
		{
			super(level,x,y,graphic);
			x=X;
			y=Y;
			boxGraphic.alpha = 0;
		}
		
		override protected function trapCollide():void
		{
			
		}
		
		override public function loop():void
		{
			verticalSpeed += gravity;
			y += verticalSpeed;
		}
	}
}