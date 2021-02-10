package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class beerKeg extends staticTrap
	{
		private var beerCount:int = 20;
		private var beerDirection:int = 0;
		private var beerTimer:int = 0;
		
		public function beerKeg(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new beerKegGraphic());
			noCollideObject = beer;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, addBeer);
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		public function spill():void
		{
			addEventListener(Event.ENTER_FRAME, addBeer);
		}
		
		private function addBeer(evt:Event)
		{
			if (beerCount > 0)
			{
				if (beerTimer == 0)
				{
					level.trapList.push(level.addChild(new beer(level,x,y + (height/2),0,beerKeg)));

					beerCount --;
					beerTimer = 5;
				}
				
				beerTimer --;
			}
			
			else
				removeEventListener(Event.ENTER_FRAME, addBeer);
		}
	}
}