package
{
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	
	public class staticCollisionRect extends collisionObject
	{
		private var world;
		public var width:Number;
		public var height:Number; 
		
		public var optional:Boolean = false;
		
		private var leftOpen
		
		public function staticCollisionRect(World,X,Y,Width,Height,Optional = false,LeftOpen = true,RightOpen = true,UpOpen = true,DownOpen = true):void
		{
			optional = Optional
			world = World;
			x = X;
			y = Y;
			width = Width;
			height = Height;
			
			normalList = new Array([1,0],[0,1]);
			
			pointList = new Vector.<Point>();
			pointList.push(new Point(0,0),new Point(0,height),new Point(width,height),new Point(width,0));
		}
		
		public function checkOldPolyCollision(target):Boolean
		{
			var collision:Boolean = false;
			var maxXCollision = 0;
			var maxYCollision = 0;
				
			for (var i:int = 0; i < target.hitBox.pointList.length; i++)
			{
				var point:Point = new Point (target.hitBox.pointList[i].x + target.x,target.hitBox.pointList[i].y + target.y);
				var xCollision:Number = 0;
				var yCollision:Number = 0;
				
				
				if (point.x >= x && point.x <= x + width && point.y >= y && point.y <= y + height)
				{
					collision = true;
					
					if (point.x > x + (width/2))
					{
						xCollision = ((x + width) - point.x);
						
						xCollision += 0.01;
					}
					
					else if (point.x < x + (width/2))
					{
						xCollision = -(point.x - x);
						
						xCollision += 0.01;
					}
					
					if (point.y > y + (height/2))
					{
						yCollision = ((y + height) - point.y);
						
						yCollision += 0.01;
					}
					
					else if (point.y < y + (height/2))
					{
						yCollision = -(point.y - y);
						
						yCollision += 0.01;
					}
										
					if (Math.sqrt(xCollision * xCollision) > Math.sqrt(maxXCollision * maxXCollision))
					{
						maxXCollision = xCollision;
					}
					
					if (Math.sqrt(yCollision * yCollision) > Math.sqrt(maxYCollision * maxYCollision))
					{
						maxYCollision = yCollision;
					}
				}
			}
						
			if (maxYCollision != 0 && Math.sqrt(maxYCollision * maxYCollision) <= Math.sqrt(maxXCollision * maxXCollision) || maxXCollision == 0)
			{
				target.y += maxYCollision;
			}
			
			else 
				target.x += maxXCollision;
					
//			else if (maxXCollision != 0 && Math.sqrt(maxXCollision * maxXCollision) < Math.sqrt(maxYCollision * maxYCollision))
//			{
//				
//			}
//					
//			else 
//			{						
//				if (point.y > y + height/2)
//					target.y += yCollision;
//							
//				else 
//					target.y -= yCollision;
//							
//				if (point.x > x + width/2)
//					target.x += xCollision;
//							
//				else 
//					target.x -= xCollision;
//			}
			
			return(collision);
		}
		
		public function checkPolyCollision(target,horizontalOnly:Boolean = false,bounce = false):Boolean
		{
			var collision:Boolean = false;
			
			var axisList:Array = new Array();
			axisList = normalList.concat();
			
			axisList = axisList.concat(target.hitBox.normalList);
							
			var bestAxis;
			var bestAxisAmount:Number;
			
			for (var i = 0; i < axisList.length; i++)
			{
				var objAMin = null;
				var objAMax = null;
				
				var objBMin = null;
				var objBMax = null;
								
				var overlap:Number = 0;
				
				for (var n:int = 0; n < target.hitBox.pointList.length; n++)
				{
					var point:Point = new Point (target.hitBox.pointList[n].x + target.x,target.hitBox.pointList[n].y + target.y);
					
					var projectionX = ((point.x * axisList[i][0] + point.y * axisList[i][1]) / (axisList[i][0] * axisList[i][0] + axisList[i][1] * axisList[i][1])) * axisList[i][0];
					var projectionY = ((point.x * axisList[i][0] + point.y * axisList[i][1]) / (axisList[i][0] * axisList[i][0] + axisList[i][1] * axisList[i][1])) * axisList[i][1];
					
					
					
					var scalarDist:Number = Math.sqrt(projectionX * projectionX + projectionY * projectionY);
					
					if (point.x * axisList[i][0] + point.y * axisList[i][1] < 0)
						scalarDist = -scalarDist;
										
					if (objAMin == null || scalarDist < objAMin)
						objAMin = scalarDist;
						
					if (objAMax == null || scalarDist > objAMax)
						objAMax = scalarDist;
						
					
				}
				
				for (n = 0; n < pointList.length; n++)
				{
					point = new Point(pointList[n].x + x,pointList[n].y + y);
					
					projectionX = ((point.x * axisList[i][0] + point.y * axisList[i][1]) / (axisList[i][0] * axisList[i][0] + axisList[i][1] * axisList[i][1])) * axisList[i][0];
					projectionY = ((point.x * axisList[i][0] + point.y * axisList[i][1]) / (axisList[i][0] * axisList[i][0] + axisList[i][1] * axisList[i][1])) * axisList[i][1];
										 
					scalarDist = Math.sqrt(projectionX * projectionX + projectionY * projectionY);
																				
					if (point.x * axisList[i][0] + point.y * axisList[i][1] < 0)
						scalarDist = -scalarDist;															
																				
					if (objBMin == null || scalarDist < objBMin)
						objBMin = scalarDist;
						
					if (objBMax == null || scalarDist > objBMax)
						objBMax = scalarDist;								
				}
				
				
				
				if ((objAMin + objAMax)/2 >= (objBMin + objBMax)/2 && objAMin < objBMax)
				{
					overlap = objBMax - objAMin;
				}
				
				else if ((objAMin + objAMax)/2 < (objBMin + objBMax)/2 && objBMin < objAMax)
				{
					overlap = -(objAMax - objBMin);
				}
								
				if (overlap == 0)
				{
					return(false);
				}
								
				if (horizontalOnly == true && axisList[i][0] != 0)
				{
					target.x += overlap;
					
					if (bounce)
						target.horizontalSpeed = -target.horizontalSpeed;
					
					return(true);
				}
								
				if (bestAxis == null || Math.sqrt(overlap * overlap) < Math.sqrt(bestAxisAmount * bestAxisAmount))
				{
					bestAxis = i;
					bestAxisAmount = overlap;
				}			
			}
			
			//trace (bestAxis,bestAxisAmount);
			target.x += axisList[bestAxis][0] * bestAxisAmount;
			target.y += axisList[bestAxis][1] * bestAxisAmount;
			
			if (bounce && axisList[bestAxis][1] == 0)
			{
				target.horizontalSpeed = -target.horizontalSpeed;
			}
			
			return(true/*[true,axisList[bestAxis][1] * bestAxisAmount]*/);
		}
		
		public function checkPointCollision():Boolean
		{
			return(false);
		}
	}
}