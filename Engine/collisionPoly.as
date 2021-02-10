package
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class collisionPoly extends collisionObject
	{
		private var rotation:Number = 0;
		private var origin:Point;
		var holder:Object;
		
		public function collisionPoly(points:Array,Origin:Point,Holder:Object):void
		{
			origin = Origin;
			holder = Holder;
			
			for (var i:int = 0; i < points.length; i ++)
			{
				pointList.push(points[i]);
				
				if (i < points.length - 1)
					var vectorEdge = [points[i + 1].x - points[i].x, points[i + 1].y - points[i].y]
				
				else
					vectorEdge = [points[0].x - points[i].x, points[0].y - points[i].y]
										
				var normalizedVector = [/*roundDecimal(*/(vectorEdge[0])/Math.sqrt((vectorEdge[0] * vectorEdge[0]) + (vectorEdge[1] * vectorEdge[1]))/*,2)*/, /*roundDecimal(*/(vectorEdge[1])/Math.sqrt((vectorEdge[0] * vectorEdge[0]) + (vectorEdge[1] * vectorEdge[1]))/*,2)*/]					
					
				var rightNormal = [-normalizedVector[1],normalizedVector[0]];
								
				var duplicate:Boolean = false;
				
				for (var n:int = 0; n < normalList.length; n++)
				{
					if (rightNormal[0] == normalList[n][0] && rightNormal[1] == normalList[n][1])
					{
						duplicate = true;
					}
				}
				
				if (duplicate == false)
				{
					normalList.push(rightNormal);
				}
			}
		}
		
		private function createNormals():void
		{
			normalList = new Array();
			
			for (var i:int = 0; i < pointList.length; i ++)
			{
				if (i < pointList.length - 1)
						var vectorEdge = [pointList[i + 1].x - pointList[i].x, pointList[i + 1].y - pointList[i].y]
					
				else
					vectorEdge = [pointList[0].x - pointList[i].x, pointList[0].y - pointList[i].y]
										
				var normalizedVector = [/*roundDecimal(*/(vectorEdge[0])/Math.sqrt((vectorEdge[0] * vectorEdge[0]) + (vectorEdge[1] * vectorEdge[1]))/*,2)*/, /*roundDecimal(*/(vectorEdge[1])/Math.sqrt((vectorEdge[0] * vectorEdge[0]) + (vectorEdge[1] * vectorEdge[1]))/*,2)*/]					
					
				var rightNormal = [-normalizedVector[1],normalizedVector[0]];
								
				var duplicate:Boolean = false;
				
				for (var n:int = 0; n < normalList.length; n++)
				{
					if (rightNormal[0] == normalList[n][0] && rightNormal[1] == normalList[n][1])
					{
						duplicate = true;
					}
				}
				
				if (duplicate == false)
				{
					normalList.push(rightNormal);
				}
			}
		}
		
		public function rotate(degs:Number)
		{
			for (var i:int = 0; i < pointList.length; i++)
			{
				pointList[i] = rotatePoint(pointList[i],origin,degs);
			}
			
			rotation += degs;
			
			createNormals();
		}
		
		public function setRotate(degs:Number)
		{
			degs -= rotation;
			
			for (var i:int = 0; i < pointList.length; i++)
			{
				pointList[i] = rotatePoint(pointList[i],origin,degs);
			}
			
			rotation += degs;
			
			createNormals();
		}
		
		private function rotatePoint(p:Point, o:Point, d:Number):Point
		{
			var np:Point = new Point();
			p.x += (0 - o.x);
			p.y += (0 - o.y);
			np.x = (p.x * Math.cos(d * (Math.PI/180))) - (p.y * Math.sin(d * (Math.PI/180)));
			np.y = Math.sin(d * (Math.PI/180)) * p.x + Math.cos(d * (Math.PI/180)) * p.y;
			np.x += (0 + o.x);
			np.y += (0 + o.y)
			
			return np; 
		}
		
		public function checkPolyCollision(target,horizontalOnly:Boolean = false,bounce:int = 2,movement:Boolean = true):Boolean
		{
			var collision:Boolean = false;
			
			var axisList:Array = new Array();
			axisList = normalList.concat();
			
			axisList = axisList.concat(target.hitBox.normalList);
			//trace ('b');
							
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
					point = new Point(pointList[n].x + holder.x,pointList[n].y + holder.y);
					
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
					//if (objBMax < 0 && objAMin < 0)
						//overlap = objAMin - objBMax;
					
					//else
						overlap = -(objBMax - objAMin);
					
					//overlap = objBMax - objAMin;
				}
				
				else if ((objAMin + objAMax)/2 < (objBMin + objBMax)/2 && objBMin < objAMax)
				{
					//if (objAMax < 0 && objBMin < 0)
						//overlap = objBMin - objAMax;
					
					//else
						overlap = objAMax - objBMin;
				}
								
				if (overlap == 0)
					return(false);
					
				if (horizontalOnly && axisList[i][1] < axisList[i][0])
				{
					if (bounce == 1)
					{
						target.horizontalSpeed = -target.horizontalSpeed;
						holder.horizontalSpeed = -holder.horizontalSpeed;
						target.x -= overlap/2;
						holder.x -= overlap/2
					}
					
					else if (bounce == 2)
					{
						//var tempHolderSpeed = holder.horizontalSpeed;
						//holder.horizontalSpeed = -holder.horizontalSpeed;
						//target.horizontalSpeed = -target.horizontalSpeed;
						//target.x -= overlap;
						
						//var speed;
//						
//						speed = Math.abs(holder.horizontalSpeed) + Math.abs(target.horizontalSpeed);
//						
//						if (!((holder.horizontalSpeed > 0 && target.horizontalSpeed > 0) || (holder.horizontalSpeed < 0 && target.horizontalSpeed < 0)))
//							speed /= 5;
						
						//if (target.x < holder.x)
						//{
							//var tempTargetSpeed = target.horizontalSpeed;
							//target.horizontalSpeed = holder.horizontalSpeed//speed/2;
							//holder.horizontalSpeed = tempTargetSpeed//-speed/2;
						//}
						
						//else
						//{
							//var tempHolderSpeed = holder.horizontalSpeed;
							//target.horizontalSpeed = target.horizontalSpeed//-speed/2;
							//holder.horizontalSpeed = tempHolderSpeed//speed/2;
						//}
						
						//target.horizontalSpeed = -target.horizontalSpeed/2;
						//holder.horizontalSpeed = -target.horizontalSpeed/2;
						//holder.x += overlap///2;
						//target.x -= overlap/2;
					}
					
					else
						target.x -= overlap;
						
					return(true);
				}
								
				if (bestAxis == null || Math.abs(overlap/* * overlap*/) < Math.abs(bestAxisAmount/* * bestAxisAmount*/))
				{
					bestAxis = i;
					bestAxisAmount = overlap;
				}			
			}
			
			//if (horizontalOnly)
				//return(false);
			
			//trace (bestAxis,bestAxisAmount);
			if (movement == true)
			{
				target.x += axisList[bestAxis][0] * bestAxisAmount;
				target.y += axisList[bestAxis][1] * bestAxisAmount;
				
				if(axisList[bestAxis][1] * bestAxisAmount < 0)
				{
					//target.verticalSpeed = 0;
				}
				
				if (bounce > 0 && axisList[bestAxis][1] == 0)
				{
					target.horizontalSpeed = -target.horizontalSpeed;
				}
			}
			
			return(true);
		}
		
		public function checkTrapPolyCollision(target,horizontalOnly:Boolean = false,bounce:int = 2,movement:Boolean = true):Boolean
		{
			var collision:Boolean = false;
			
			var axisList:Array = new Array();
			axisList = normalList.concat();
			
			axisList = axisList.concat(target.hitBox.normalList);
			//trace ('b');
							
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
					point = new Point(pointList[n].x + holder.x,pointList[n].y + holder.y);
					
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
					//if (objBMax < 0 && objAMin < 0)
						//overlap = objAMin - objBMax;
					
					//else
						overlap = objBMax - objAMin;
					
					//overlap = objBMax - objAMin;
				}
				
				else if ((objAMin + objAMax)/2 < (objBMin + objBMax)/2 && objBMin < objAMax)
				{
					//if (objAMax < 0 && objBMin < 0)
						//overlap = objBMin - objAMax;
					
					//else
						overlap = -(objAMax - objBMin);
				}
								
				if (overlap == 0)
					return(false);
					
				if (horizontalOnly && axisList[i][1] < axisList[i][0])
				{
					if (bounce == 1)
					{
						target.horizontalSpeed = -target.horizontalSpeed;
						holder.horizontalSpeed = -holder.horizontalSpeed;
						target.x += overlap/2;
						holder.x -= overlap/2
					}
					
					else if (bounce == 2)
					{
						//var tempHolderSpeed = holder.horizontalSpeed;
						//holder.horizontalSpeed = -holder.horizontalSpeed;
						//target.horizontalSpeed = -target.horizontalSpeed;
						//target.x -= overlap;
						
						//var speed;
//						
//						speed = Math.abs(holder.horizontalSpeed) + Math.abs(target.horizontalSpeed);
//						
//						if (!((holder.horizontalSpeed > 0 && target.horizontalSpeed > 0) || (holder.horizontalSpeed < 0 && target.horizontalSpeed < 0)))
//							speed /= 5;
						
						//if (target.x < holder.x)
						//{
							//var tempTargetSpeed = target.horizontalSpeed;
							//target.horizontalSpeed = holder.horizontalSpeed//speed/2;
							//holder.horizontalSpeed = tempTargetSpeed//-speed/2;
						//}
						
						//else
						//{
							//var tempHolderSpeed = holder.horizontalSpeed;
							//target.horizontalSpeed = target.horizontalSpeed//-speed/2;
							//holder.horizontalSpeed = tempHolderSpeed//speed/2;
						//}
						
						//target.horizontalSpeed = -target.horizontalSpeed/2;
						//holder.horizontalSpeed = -target.horizontalSpeed/2;
						//holder.x += overlap///2;
						//target.x -= overlap/2;
					}
					
					else
						target.x -= overlap;
						
					return(true);
				}
								
				if (bestAxis == null || Math.abs(overlap/* * overlap*/) < Math.abs(bestAxisAmount/* * bestAxisAmount*/))
				{
					bestAxis = i;
					bestAxisAmount = overlap;
				}			
			}
			
			//if (horizontalOnly)
				//return(false);
			
			//trace (bestAxis,bestAxisAmount);
			if (movement == true)
			{
				target.x += axisList[bestAxis][0] * bestAxisAmount;
				target.y += axisList[bestAxis][1] * bestAxisAmount;
				
				if(axisList[bestAxis][1] * bestAxisAmount < 0)
				{
					//target.verticalSpeed = 0;
				}
				
				if (bounce > 0 && axisList[bestAxis][1] == 0)
				{
					target.horizontalSpeed = -target.horizontalSpeed;
				}
			}
			
			return(true);
		}

		
		private function roundDecimal(num:Number, decimals:Number):Number
		{
			var t:Number = Math.pow(10, decimals);
			return Math.round(t * num) / t;
		}
	}
}