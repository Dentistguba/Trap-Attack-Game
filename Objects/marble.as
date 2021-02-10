package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class marble extends ballTrap
	{
		public function marble(level:Level,X = 0,Y = 0,speed = 0)
		{
			super(level,X,Y,speed,marbleBag,new marbleGraphic());
			noCollideObject = marbleBag;
		}
	}
}