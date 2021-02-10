package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class hatTrap extends stuckOnHeadTrap
	{			
		public function hatTrap(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,new hatGraphic());
			noCollideObject = hatStand;
		}
	}
}