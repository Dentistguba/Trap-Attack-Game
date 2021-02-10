package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class remoteControlCar extends trippingTrap
	{
		private var airLoopSoundPlaying = false;
		private var airLoopSound;
		
		public function remoteControlCar(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new toyCarGraphic());
			friction = 0;
			
			loopSound = new remoteCarSound();
			airLoopSound = new remoteCarSound2();
		}
		
		override public function changeMode():void
		{
			removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			removeEventListener (Event.ENTER_FRAME, addEndDragListener);
			
			
			boxGraphic.alpha = 0;
			
			filters = [];
			
			if (hanging == false)
			{
				
				addChild(leftArrow = new LeftArrow());
				leftArrow.x = (graphic.width / 2) - 5;
				leftArrow.y = 0;
				
				boxGraphic.width = width;
				boxGraphic.x += leftArrow.width;
				
				addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
				level.addEventListener (MouseEvent.MOUSE_MOVE, mouseHover)
			}
		}
		
		private function mouseHover(evt:MouseEvent):void
		{
			if (mouseX > -(width/2) && mouseX < width/2 && mouseY > -(height/2) && mouseY < height/2)
			{
				trace('mouseOver');
				
				leftArrow.scaleX = 1.5;
			}
			
			else if (leftArrow.scaleX != 1)
			{
				leftArrow.scaleX = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleX = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			soundChannel = loopSound.play(0,int.MAX_VALUE);
			loopSoundPlaying = true;
			
			removeChild(leftArrow);
			
			looping = true;
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		override public function loop():void
		{
			if (horizontalSpeed < 0)
				graphic.wheel1.rotation = graphic.wheel2.rotation += rotationSpeed = 360 /((width * 3.142) / horizontalSpeed);
				
			else
				graphic.wheel1.rotation = graphic.wheel2.rotation += rotationSpeed = 360 /((width * 3.142) / horizontalSpeed);
			
			iterMove();
			
			if (horizontalSpeed > -5)
				horizontalSpeed -= 0.5;
				
			if (horizontalSpeed > 0)
			{
				looping = false;
				soundChannel.stop();
			}
						
			//if (graphic != null)
				//graphic.rotation += rotationSpeed;
				
			//hitBox.rotate(rotationSpeed);
			
			//if (rotationSpeed >= 0.5)
			//{
				//rotationSpeed -= 0.5;
			//}
			
			//else if (rotationSpeed <= -0.5)
			//{
				//rotationSpeed += 0.5;
			//}
			
			if (horizontalSpeed <= -friction)
			{
				horizontalSpeed += friction
			}
			
			else if (horizontalSpeed >= friction)
			{
				horizontalSpeed -= friction;
			}
			
			else
			{
				looping = false;
				soundChannel.stop();
				horizontalSpeed = 0;
			}
			
			//if (onGround)
			//{
			//}
			
			//else
			//{
				//graphic.rotation += rotationSpeed;
				
				//if (rotationSpeed > 0)
					//rotationSpeed -= 0.5;
					
				//else
					//rotationSpeed += 0.5;
			//}
			
			//if (horizontalSpeed == 0 && onGround == true)
			//{
				//alpha = 0.5;				//active = false;
				//looping = false;
			//}
			
			if (verticalSpeed > 0.4 && loopSoundPlaying == true)
			{
				soundChannel.stop();
				soundChannel = airLoopSound.play(0,int.MAX_VALUE);
				loopSoundPlaying = false;
				airLoopSoundPlaying = true;
			}
			
			else if (verticalSpeed < -0.4 && airLoopSoundPlaying == true)
			{
				soundChannel.stop();
				soundChannel = loopSound.play(0,int.MAX_VALUE);
				airLoopSoundPlaying = false;
				loopSoundPlaying = true;
			}
			
			if (onGround == false)
				verticalSpeed += gravity;
				
			if (x < 0 || x > level.actualWidth - 10)
			{
				soundChannel.stop();
				looping = false;
			}
		}
	}
}