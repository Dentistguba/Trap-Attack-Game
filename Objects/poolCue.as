package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class poolCue extends swingUpTrap
	{
		public function poolCue(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new poolCueGraphic());
		}
	}
}