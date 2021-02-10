package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class painting2 extends painting
	{		
		public function painting2(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new painting2Graphic());
		}
	}
}