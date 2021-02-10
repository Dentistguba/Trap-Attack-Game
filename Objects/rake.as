package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class rake extends swingUpTrap
	{
		public function rake(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new rakeGraphic());
		}
	}
}