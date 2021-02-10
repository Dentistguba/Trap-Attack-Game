package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class fluidTrap extends slippingTrap
	{		
		public function fluidTrap(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,graphic);
			
			impactSound = null;
			impactSound2 = null;
			impactSound3 = null;
		}
	}
}