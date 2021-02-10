package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Porridge extends physicsParticle
	{
		public function Porridge(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new porridgeGraphic());
			x=X;
			y=Y;
			
			hitBox.setRotate(45);
			
			filters = [];
			
			noCollideObject = porridgeBox;
			looping = true;
			
			removeEventListener(MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			
			impactSound = null;
			impactSound2 = null;
			impactSound3 = null;
		}
		
		override protected function trapCollide():void
		{
			var neighbors = level.proximityTree.getNeighbors(this);
					
			var leftOccupied:Boolean = false;
			var rightOccupied:Boolean = false;
					
			for (var i:int = 0; i <= neighbors.length; i ++)
			{
				if (neighbors[i] is Trap && neighbors[i] != null && neighbors[i] != this && !(noCollideObject != null && neighbors[i] is noCollideObject) && neighbors[i].hitBox != null && !(neighbors[i] is physicsParticle))
				{
					if (x + (width/2) > neighbors[i].x - (width/2) && x - (width/2) < neighbors[i].x + (width/2) && y + (height/2) > neighbors[i].y - (height/2) && y - (height/2) < neighbors[i].y + (height/2))
					{
						if (neighbors[i] is Porridge && !(neighbors[i] is porridgePowder))
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,true,1,true))
							{
								if (neighbors[i].looping == false && y > neighbors[i].y - 2 && y < neighbors[i].y + 2)
								{
									looping = false;
								}
							}
						}
						
						else if (!(neighbors[i] is fluidTrap && neighbors[i] is porridgePowder))
							neighbors[i].hitBox.checkTrapPolyCollision(this,false,0)
					}
				}
			}
		}
		
		override public function loop():void
		{
			iterMove();
			
			if (onGround)
				looping = false
				
			else
				verticalSpeed += gravity;
		}
	}
}