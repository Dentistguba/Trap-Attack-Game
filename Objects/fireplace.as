package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class fireplace extends staticTrap
	{
		private var flameCount:int = 50;
		private var flameTimer:int = 2;
		
		public function fireplace(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new fireplaceGraphic());
			graphic.lit.visible = false;
			
			loopSound = new fireSound();
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{			
			soundChannel = loopSound.play(0,int.MAX_VALUE);
			loopSoundPlaying = true;
		
			addEventListener(Event.ENTER_FRAME, addFlame);
			
			graphic.lit.visible = true;
			graphic.lit.play();
			
			graphic.out.visible = false;
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		public function addFlame(evt:Event):void
		{
			if (flameCount > 0)
			{
				if (flameTimer == 0)
				{
					level.trapList.push(level.addChild(new Flame2(level,x + ((Math.random() - 0.5) * 30),y)));
					level.trapList.push(level.addChild(new Flame2(level,x + ((Math.random() - 0.5) * 30),y)));
					
					flameCount --;
					flameTimer = 2;
				}
				
				flameTimer --;
			}
			
			else
			{
				soundChannel.stop();
				removeEventListener(Event.ENTER_FRAME, addFlame);
			}
		}
	}
}