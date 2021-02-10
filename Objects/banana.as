package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class banana extends slippingTrap
	{
		public function banana(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new bananaGraphic());
		}
	}
}