package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class pea extends ballTrap
	{
		public function pea(level:Level,X = 0,Y = 0,speed = 0)
		{
			super(level,X,Y,speed,peaBag,new peaGraphic());
		}
	}
}