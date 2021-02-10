package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class bird extends trippingTrap
	{
		public function bird(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new birdGraphic());
			friction = 0;
			graphic.flying.visible = false;
			graphic.flying.stop();
			
			startSound = new birdStartle();
			
			filters = [/*new GlowFilter(0xFF00FF,1,20,20)*/]
			
			removeEventListener(MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
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
				
				addChild(leftArrow = new LeftUpArrow2());
				leftArrow.x = (-graphic.width / 2) - 5;
				leftArrow.y = -height/2 + 5;
				
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
				
				leftArrow.scaleX = 1.25;
				leftArrow.scaleY = 1.25;
			}
			
			else if (leftArrow.scaleX != 1)
			{
				leftArrow.scaleX = 1;
				leftArrow.scaleY = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleX = 1;
			leftArrow.scaleY = 1;
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			if (startSound != null)
			{
				soundChannel = startSound.play();
			}
			
			removeChild(leftArrow);
			
			looping = true;
			
			graphic.flying.visible = true;
			graphic.flying.play();
			
			graphic.still.visible = false;
			
			horizontalSpeed = -5;
			verticalSpeed = -0.8;
			
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover);
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway);
		}
		
		override public function loop():void
		{
			if (x < -width/2 || x > level.actualWidth + 40 || y < -height/2 || y > level.actualHeight + 40)
			{
				looping = false;
				return;
			}
			
			iterMove();
						
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
			
			//if (onGround == false)
				//verticalSpeed += gravity;
				
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				looping = false;
				return;
			}
		}
	}
}