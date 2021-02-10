package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class bust extends trippingTrap
	{
		public function bust(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new bustGraphic());
			
			startSound = new stoneSlab();
			impactSound = new stoneSlab();
			impactSound2 = null;
			impactSound3 = null;
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
				boxGraphic.scaleX = 4;
				addChild(leftArrow = new LeftArrow());
				leftArrow.x = 15;
				leftArrow.y = 0;
				
				addChild(rightArrow = new RightArrow());
				rightArrow.x = -15;
				rightArrow.y = 0;
				
				addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
				level.addEventListener (MouseEvent.MOUSE_MOVE, mouseHover)
			}
		}
		
		private function mouseHover(evt:MouseEvent):void
		{
			if (mouseX > -(width/2) && mouseX < width/2 && mouseY > -(height/2) && mouseY < height/2)
			{
				trace('mouseOver');
				
			
				if (mouseX < 0)
				{
					rightArrow.scaleX = 1.5;
					leftArrow.scaleX = 1;
				}
				
				else
				{
					leftArrow.scaleX = 1.5;
					rightArrow.scaleX = 1;
				}
			}
			
			else if (leftArrow.scaleX != 1 || rightArrow.scaleX != 1)
			{
				leftArrow.scaleX = 1;
				rightArrow.scaleX = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleX = 1;
			rightArrow.scaleX = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			if (startSound != null)
			{
				soundChannel = startSound.play();
			}
			
			if (loopSound != null)
			{
				soundChannel = loopSound.play(0,int.MAX_VALUE);
				loopSoundPlaying = true;
			}
			
			removeChild(leftArrow);
			removeChild(rightArrow);
			
			looping = true;
			
			if (mouseX < 0)
			{
				horizontalSpeed = 3;
				rotationSpeed = +9.3;
			}
			
			else
			{
				horizontalSpeed = -3;
				rotationSpeed = -9.3;
			}
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		override public function loop():void
		{
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				soundChannel.stop();
				looping = false;
				return;
			}
			
			iterMove();
						
			if (graphic != null)
				graphic.rotation += rotationSpeed;
				
			hitBox.setRotate(graphic.rotation);
			
			if (rotationSpeed >= 0.5)
			{
				rotationSpeed -= 0.5;
			}
			
			else if (rotationSpeed <= -0.5)
			{
				rotationSpeed += 0.5;
			}
			
			else if (rotationSpeed >= 0.1)
			{
				rotationSpeed -= 0.1;
			}
			
			else if (rotationSpeed <= -0.1)
			{
				rotationSpeed += 0.1;
			}
			
			else
				rotationSpeed = 0;
			
			if (hanging == false)
			{
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
					if (soundChannel != null)
						soundChannel.stop();
					horizontalSpeed = 0;
				}
				
				if (verticalSpeed > 0.4 || verticalSpeed < -0.4)
				{
					soundChannel.stop();
					loopSoundPlaying = false;
				}
					
				else if (loopSoundPlaying == false)
				{
					soundChannel = loopSound.play(0,int.MAX_VALUE);
					loopSoundPlaying = true;
				}
				
				if (onGround)
				{
				}
				
				else
				{
					graphic.rotation += rotationSpeed;
					
					if (rotationSpeed > 0)
						rotationSpeed -= 0.5;
						
					else if (rotationSpeed < 0)
						rotationSpeed += 0.5;
				}
				
				if (horizontalSpeed == 0 && verticalSpeed == 0 && rotationSpeed == 0)
				{
					if (soundChannel != null)
						soundChannel.stop();
					alpha = 0.5;				//active = false;
					looping = false;
				}
				
				else
					verticalSpeed += gravity;
					
			}
			
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				if (soundChannel != null)
					soundChannel.stop();
				looping = false;
			}
			
		}
	}
}