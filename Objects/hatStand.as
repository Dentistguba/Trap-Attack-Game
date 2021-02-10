package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class hatStand extends Trap
	{		
		private var swinging:Boolean = true;
		private var hat
	
		public function hatStand(level:Level,X = 0,Y = 0,graphic = null)
		{
			super(level,X,Y,new hatStandGraphic(),true,false,true);
			
			rotationSpeed = 0;
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
				
				addChild(leftArrow = new UpArrow());
				leftArrow.x = 0;
				leftArrow.y = -height/2 - 5;
				
				boxGraphic.width = width;
				//boxGraphic.x += leftArrow.width;
				
				addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
				level.addEventListener (MouseEvent.MOUSE_MOVE, mouseHover)
			}
		}
		
		private function mouseHover(evt:MouseEvent):void
		{
			if (mouseX > -(width/2) && mouseX < width/2 && mouseY > -(height/2) && mouseY < height/2)
			{
				trace('mouseOver');
				
				leftArrow.scaleY = 1.5;
			}
			
			else if (leftArrow.scaleY != 1)
			{
				leftArrow.scaleY = 1;
			}
		}
		
		private function mouseAway(evt:MouseEvent):void
		{
			leftArrow.scaleY = 1;
		}
		
		override public function playerCollide(target,movement = true):Boolean
		{
			//var collision:Boolean = false;
			
			if (target.hitBox.checkPolyCollision(this,true,0,false))
			{
				return(true);
			}
				
			else
				return(false);
		}
		
		override protected function mouseInteract(evt:MouseEvent):void
		{
			startSound.play()
			
			removeChild(leftArrow);
			
			looping = true;
			swinging = true;
			
			level.trapList.push(hat = level.addChild(new hatTrap(level,x,y)));
			hat.verticalSpeed = - 5;
			hat.changeMode();
			hat.looping = true;
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
		}
		
		override public function loop():void
		{
			if (swinging == true)
			{
				if (graphic.rotation <= -90)
				{
					rotationSpeed = 0;
					graphic.rotation = -90;
					looping = false;
					swinging = false;
				}
				
				else 
				{
					rotationSpeed --;
				}
				
				
				//if (graphic != null)
				graphic.rotation += rotationSpeed;
						
				verticalSpeed += gravity;
				//hitBox.setRotate(graphic.rotation);
			}

			else
			{
				iterMove();
							
				//hitBox.rotate(rotationSpeed);
				
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
					if (graphic != null)
						graphic.rotation += rotationSpeed;
					
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
					
					if (onGround)
					{
					}
					
					else
					{
						graphic.rotation += rotationSpeed;
						
						if (rotationSpeed > 0)
							rotationSpeed -= 0.5;
							
						else
							rotationSpeed += 0.5;
					}
					
					if (horizontalSpeed == 0 && verticalSpeed == 0 && rotationSpeed == 0)
					{
						alpha = 0.5;				//active = false;
						looping = false;
					}
					
					else
						verticalSpeed += gravity;
				}
			}
		}
	}
}