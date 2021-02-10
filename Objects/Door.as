package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class Door extends MovieClip
	{
		private var rotationSpeed:Number = 0;
		public var active:Boolean = false;
		//private var graphic:Shape;
		
		private var sound;
		private var soundChannel;
		
		public function Door(X = 0,Y = 0)
		{
			x=X;
			y=Y;
			
			//graphic = new Shape();
			//graphic.graphics.beginFill(0x000000,1);
			//graphic.graphics.drawRect(-10,-100,10,100)
			//graphic.graphics.endFill();
			//addChild(graphic);
		}
		
		public function loop()
		{
			if (sound == null)
			{
				sound = new Falling();
				soundChannel = sound.play();
			}
			
			if (graphic.rotation < 90)
			{
				graphic.rotation += rotationSpeed;
				rotationSpeed ++;
			}
			
			else
			{
				graphic.rotation = 90; 
				active = false;
				soundChannel.stop();
				sound = new Bump();
				soundChannel = sound.play();
			}
		}
	}
}