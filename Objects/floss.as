package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	
	public class floss extends trippingTrap
	{
		private var tempCombination;
		private var object;
		
		
		public function floss(level:Level,X = 0,Y = 0)
		{
			super(level,X,Y,new flossGraphic());
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		public function combine(Object)
		{
			trace ('combining');
			
			object = Object;
			
			tempCombination = level.addChild(new swingingTrap(level,object,x,y));
			visible = false;
			object.x = x - 70
			
			level.addEventListener(MouseEvent.MOUSE_DOWN, finalise);
		}
		
		public function deCombine()
		{
			visible = true;
			object.visible = true;
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