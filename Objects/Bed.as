package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class Bed extends trippingTrap
	{
		public function Bed(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new bedGraphic());
		}
	}
}