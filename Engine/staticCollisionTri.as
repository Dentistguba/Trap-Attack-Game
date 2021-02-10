package
{
	import flash.geom.Point;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	
	public class staticCollisionTri extends collisionObject
	{
		private var world;
		public var width:Number;
		public var height:Number;
		
		public function staticCollisionTri(World,X,Y,Width,Height,direction):void
		{
			world = World;
			x = X;
			y = Y;
			width = Width;
			height = Height;
			
			if (direction == 0)
			{
				normalList = new Array([1,0],[0,1],[1,-1]);
				pointList.push(new Point(0,0),new Point(0,height),new Point(width,height));
			}
			
			else if (direction == 1)
			{
				normalList = new Array([1,0],[0,1],[-1,-1]);
				pointList.push(new Point(0,height),new Point(width,height),new Point(width,0));
			}
			
			else if (direction == 2)
			{
				normalList = new Array([1,0],[0,1],[-1,1]);
				pointList.push(new Point(0,0),new Point(width,height),new Point(width,0));
			}
			
			else if (direction == 3)
			{
				normalList = new Array([1,0],[0,1],[1,1]);
				pointList.push(new Point(0,0),new Point(0,height),new Point(width,0));
			}
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
								
				if (bestAxis == null || Math.sqrt(overlap * overlap) < Math.sqrt(bestAxisAmount * bestAxisAmount))
				{
					bestAxis = i;
					bestAxisAmount = overlap;
				}			
			}
			
			//trace (bestAxis,bestAxisAmount);
			target.x += axisList[bestAxis][0] * bestAxisAmount;
			target.y += axisList[bestAxis][1] * bestAxisAmount;
			
			return(true/*[true,axisList[bestAxis][1] * bestAxisAmount]*/);
		}
	}
}