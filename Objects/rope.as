package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import fl.motion.Color;
	import flash.geom.Point;
	
	public class rope extends trippingTrap
	{
		public var tempCombination;
		private var object;
		private var objectPos:Point;
		
		public function rope(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new ropeCoiledGraphic());
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		override protected function snap():void
		{
			var neighbors:Array;
			
			var i:int = Math.round(y) / level.cellSize;
			var n:int = Math.round(x) / level.cellSize;
			
			if (level.terrain[i] != null && level.terrain[i][n] != null && !(level.terrain[i][n][1] is collisionObject))
			{				
				if (level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null && (level.terrain[i + 1][n][1] is staticCollisionRect || level.terrain[i + 1][n][1] is staticCollisionTri))
				{
					y = (i * level.cellSize) + level.cellSize - (actualHeight / 2)
					
					snapped = true;
					
					if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
					{
						level.terrain[i][n + 1][1].checkPolyCollision(this,true);
						//boxCollide(level.terrain[i][n + 1][1]);
					}
					
					if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
					{
						level.terrain[i][n - 1][1].checkPolyCollision(this,true);
						//boxCollide(level.terrain[i][n - 1][1]);
					}
					
					level.proximityTree.refresh();
					
					neighbors = level.proximityTree.getNeighbors(this);
									
					var deCombine:Boolean;
									
					for (var i:int = 0; i <= neighbors.length; i ++)
					{				
						if (neighbors[i] != null && neighbors[i] != this)
						{
							if(neighbors[i].hitBox.checkPolyCollision(this,true,0,true) && !(neighbors[i] is swingUpTrap))
							{
								if (neighbors[i] == combinationObject)
									deCombine == false
									
								else if ('combine' in neighbors[i])
								{
									neighbors[i].combine(this);
									combinationObject = neighbors[i];
								}
								
								else if (tempCombination == null)
								{
									combine(neighbors[i]);
								}
							}
						}
					}
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0x000000,0);
					transform.colorTransform = tint;
				}
				
				else
				{
					snapped = false;
					
					if (level.terrain[i] != null && level.terrain[i][n] != null &&level.terrain[i][n][1] != null)
						level.terrain[i][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n][1]);
						
					if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
					{
						level.terrain[i][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n + 1][1]);
					}
					
					if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
					{
						level.terrain[i][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n - 1][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null)
					{
						level.terrain[i + 1][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n + 1] != null && level.terrain[i + 1][n + 1][1] != null)
					{
						level.terrain[i + 1][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n + 1][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n - 1] != null && level.terrain[i + 1][n - 1][1] != null)
					{
						level.terrain[i + 1][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n - 1][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && level.terrain[i - 1][n][1] != null)
					{
						level.terrain[i - 1][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n - 1] != null && level.terrain[i - 1][n - 1][1] != null)
					{
						level.terrain[i - 1][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n - 1][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n + 1] != null && level.terrain[i - 1][n + 1][1] != null)
					{
						level.terrain[i - 1][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n + 1][1]);
					}
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0xFF0000,0.5);
					transform.colorTransform = tint;
					
					if (tempCombination != null)
					{
						this.deCombine();
						tempCombination = null;
					}
					
					if (combinationObject != null)
					{
						combinationObject.deCombine();
						combinationObject = null;
					}
				}
			}
			
			else 
			{
				if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && (level.terrain[i - 1][n][1] == null ||(level.terrain[i - 1][n][1] != null && !(level.terrain[i - 1][n][1] is collisionObject))))
				{
					if (level.terrain[i] != null && level.terrain[i][n] != null &&level.terrain[i][n][1] != null)
						level.terrain[i][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n][1]);
						
					if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
					{
						level.terrain[i][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n + 1][1]);
					}
					
					if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
					{
						level.terrain[i][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n - 1][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null)
					{
						level.terrain[i + 1][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n + 1] != null && level.terrain[i + 1][n + 1][1] != null)
					{
						level.terrain[i + 1][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n + 1][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n - 1] != null && level.terrain[i + 1][n - 1][1] != null)
					{
						level.terrain[i + 1][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n - 1][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && level.terrain[i - 1][n][1] != null)
					{
						level.terrain[i - 1][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n - 1] != null && level.terrain[i - 1][n - 1][1] != null)
					{
						level.terrain[i - 1][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n - 1][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n + 1] != null && level.terrain[i - 1][n + 1][1] != null)
					{
						level.terrain[i - 1][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n + 1][1]);
					}
					y = (i * level.cellSize) - (actualHeight / 2);
					
					snapped = true;
					level.proximityTree.refresh();
					
					neighbors = level.proximityTree.getNeighbors(this);
					
					for (var i:int = 0; i <= neighbors.length; i ++)
					{				
						if (neighbors[i] != null && neighbors[i] != this)
						{														
							if (neighbors[i].hitBox.checkPolyCollision(this,true) && Engine.mouse[1] && !(neighbors[i] is swingUpTrap))
							{
								if (mouseX > neighbors[i].x - (neighbors[i].width/2) && mouseX < neighbors[i].x + (neighbors[i].width/2) && 'combine' in neighbors[i])
								{
									 neighbors[i].combine(this);
								}
							}
						}
					}
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0xFF0000,0);
					transform.colorTransform = tint;
				}
				
				else
				{
					snapped = false;
					
					if (level.terrain[i] != null && level.terrain[i][n] != null && level.terrain[i][n][1] != null)
						level.terrain[i][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n][1]);
						
					if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
					{
						level.terrain[i][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n + 1][1]);
					}
					
					if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
					{
						level.terrain[i][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i][n - 1][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null)
					{
						level.terrain[i + 1][n][1].checkPolyCollision(this)
						//boxCollide(level.terrain[i + 1][n][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n + 1] != null && level.terrain[i + 1][n + 1][1] != null)
					{
						level.terrain[i + 1][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n + 1][1]);
					}
					
					if (level.terrain[i + 1] != null && level.terrain[i + 1][n - 1] != null && level.terrain[i + 1][n - 1][1] != null)
					{
						level.terrain[i + 1][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i + 1][n - 1][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && level.terrain[i - 1][n][1] != null)
					{
						level.terrain[i - 1][n][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n - 1] != null && level.terrain[i - 1][n - 1][1] != null)
					{
						level.terrain[i - 1][n - 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n - 1][1]);
					}
					
					if (level.terrain[i - 1] != null && level.terrain[i - 1][n + 1] != null && level.terrain[i - 1][n + 1][1] != null)
					{
						level.terrain[i - 1][n + 1][1].checkPolyCollision(this);
						//boxCollide(level.terrain[i - 1][n + 1][1]);
					}
					
					var tint:Color;
					tint = new Color();
					tint.setTint(0xFF0000,0.5);
					transform.colorTransform = tint;
				}
			}
			
			if (boxGraphic.x == 0 && x - width/2 < 50)
				x = 50 + (width/2);
				
			else if (x < 50)
				x = 50;
		}
		
		public function combine(Object)
		{
			trace ('combining');
			
			object = Object;
			objectPos = new Point(object.x,object.y);
			
			tempCombination = level.addChild(new swingingTrap(level,object,x,y));
			visible = false;
			
			object.x = x - 70
			
			level.addEventListener(MouseEvent.MOUSE_DOWN, finalise);
		}
		
		public function deCombine()
		{
			visible = true;
			object.visible = true;
			object.x = objectPos.x;
			object.y = objectPos.y;
			
			level.removeChild(tempCombination);
			
			for (var i:int = 0; i < level.trapList.length; i++)
			{
				if (level.trapList[i]  == tempCombination)
					level.trapList[i] = null;
			}
			
			level.proximityTree.removeObject(tempCombination);
			
			tempCombination = null;
			
			level.removeEventListener(MouseEvent.MOUSE_DOWN, finalise);
		}
		
		public function finalise(evt:MouseEvent)
		{
			level.removeEventListener(MouseEvent.MOUSE_DOWN, finalise);
			
			for(var i:int = 0; i < level.trapList.length; i++)
			{
				if(level.trapList[i] == this)
				{
					level.trapList.splice(i,1);
				}
			}
			level.proximityTree.removeObject(this);
			
			level.trapList.push(tempCombination);
			
			object.removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			object.removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			object.removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			object.endDrag();
			level.addEventListener(MouseEvent.MOUSE_DOWN, tempCombination.beginOrEndDrag);
			
			tempCombination.finalise();
		}
	}
}