package
{
	public class stairObject extends collisionObject
	{
		protected var steps:Vector.<Object> = new Vector.<Object>();
		public var width:Number;
		public var height:Number;
		public var optional:Boolean = false;
		public var direction:int;
		
		public function stairObject(X = 0,Y = 0,width = 0,height = 0,Direction = 0,Optional = false)
		{
			x=X;
			y=Y;
			optional = Optional;
			direction = Direction;
			
			if (direction == 0)
			{
				steps.push(new staticCollisionRect(null,X,Y,width/4,height/4));
				steps.push(new staticCollisionRect(null,X,Y + (height/4),width/2,height/4));
				steps.push(new staticCollisionRect(null,X,Y + (height/2),width/2 + width/4,height/4));
				steps.push(new staticCollisionRect(null,X,Y + (height/2) + (height/4),width,height/4));
				//steps.push(new staticCollisionTri(null,X,Y,width,height,0))
			}
			
			else
			{
				steps.push(new staticCollisionRect(null,X,Y + (height/2) + (width/4),width,height/4));
				steps.push(new staticCollisionRect(null,X +(width/4),Y + (height/2),width/2 + width/4,height/4));
				steps.push(new staticCollisionRect(null,X +(width/2),Y + (height/4),width/2,height/4));
				steps.push(new staticCollisionRect(null,X +(width/2) + (width/4),Y,width/4,height/4));
			}
		}
		
		public function checkPolyCollision(target,horizontalOnly:Boolean = false, bounce:Boolean = false):Boolean
		{
			var numCollisions:int = 0;
			
			for (var i:int = 0; i < steps.length; i++)
			{
				if (numCollisions < 1)
				{
					if (horizontalOnly == true)
					{
						var collision = steps[i].checkPolyCollision(target,true,bounce)
					}
					
					else if (!(target is AiPlayer && target.y > steps[i].y))
					{
						var collision = steps[i].checkPolyCollision(target,false,bounce);
					}
					
					if (collision)
					{
						numCollisions ++;
						
						if (target is AiPlayer)
						{
							if (target.physicalEffect != 'tripping' && collision && target.y + target.height/2 > steps[i].y)
								target.y -= 2;
								
							return(true);
						}
					}
				}
				
				else
					return(true);
			}
			
			return(collision);
		}
	}
}