package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class poolCleaner extends swingUpTrap
	{
		public function poolCleaner(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new poolCleanerGraphic());
		}
	}
}