package
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import fl.motion.Color;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	
	public class staticTrap extends Trap
	{		
		public function staticTrap(level:Level,X = 0,Y = 0,graphic = null)
		{
			this.graphic = graphic;
			super(level,X,Y,graphic,true,false,false,true);
			boxGraphic.alpha = 0;
			
			filters = [/*new GlowFilter(0xFF00FF,1,20,20)*/]
			
			removeEventListener(MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
		}
	}
}