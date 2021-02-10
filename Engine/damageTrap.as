package
{
	public class damageTrap extends Trap
	{
		public function damageTrap(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,graphic);
			x=X;
			y=Y;
		}
		
		override public function loop():void
		{
			verticalSpeed += gravity;
			y += verticalSpeed;
		}
	}
}