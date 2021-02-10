package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class ladderObject extends stairObject
	{
		public function ladderObject(World,X,Y,Width,Height,Optional = true)
		{
			steps.push(new staticCollisionRect(null,X + (Width - 10),Y,10,Height,false));
			optional = Optional;
			direction = 1;
		}
		
		override public function checkPolyCollision(target,horizontalOnly:Boolean = false, bounce:Boolean = false):Boolean
		{
			//trace('true');
			
			var numCollisions:int = 0;
			
			for (var i:int = 0; i < steps.length; i++)
			{
				if (numCollisions < 1)
				{
					if (horizontalOnly == true)
					{
						var collision = steps[i].checkPolyCollision(target,true,bounce)
					}
					
					else
					{
						var collision = steps[i].checkPolyCollision(target,false,bounce);
					}
					
					if (collision)
					{
						numCollisions ++;
						
						if (target is AiPlayer)
						{
							if (target.physicalEffect != 'tripping' && collision)
							{
								target.y -= 0.5;
								
								if (target.y + (target.height/2) > steps[i].y && (target.x + 30) <= (steps[i].x + 22))
								{
									target.ladderGraphic.visible = true;
									target.Graphic.visible = false;
									target.Graphic.stop();
									target.ladderGraphic.play();
									
									if (target.ladderGraphic.currentFrame == target.ladderGraphic.totalFrames)
									{
										target.ladderGraphic.play();
									}
								}
								
								else 
								{
									target.ladderGraphic.visible = false;
									target.ladderGraphic.stop();
									target.Graphic.visible = true;
									target.Graphic.play;
								}
							}
								
							return(true);
						}
					}
				}
				
				else
					return(true);
			}
			
			return(collision);
			
			//if (steps[0].checkPolyCollision(target))
//			{				
//			
//				
//				
//				if (target is AiPlayer)
//				{
//					if (target.physicalEffect != 'tripping' && target.y + target.height/2 > steps[0].y)
//					{
//						target.verticalSpeed == 0;
//						target.y -= 2;
//					}
//						
//					
//					return(true);
//				}
//				
//				else
//					return(true);
//			}
//			
//			else
//				return(false);
		}
	}
}