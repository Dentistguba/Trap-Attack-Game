package
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import fl.motion.Color;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	
	public class Trap extends MovieClip
	{
		protected var level:Level;
		public var run:Boolean
		public var active:Boolean = true;
		public var dragging:Boolean = false;
		public var looping:Boolean = false;
		protected var snapped:Boolean = false;
		
		public var actualWidth:Number;
		public var actualHeight:Number;
		
		public var hitBox:collisionPoly;

		public var horizontalSpeed:Number = 0;
		public var verticalSpeed:Number = 0;
		public var rotationSpeed:Number = 0;
		protected var gravity:Number = 0.4;
		
		public var graphic;
		protected var boxGraphic;
		protected var onGround:Boolean = false;
		protected var friction:Number = 0.1;
		protected var goThroughStairs:Boolean = true;
		
		private var startY:Number;
		public var hanging:Boolean = false;
		protected var combinationObject;
		
		public var leftArrow = null;
		public var rightArrow = null;
		public var downArrow = null;
		
		public var startSound:Sound;
		public var loopSound:Sound;
		public var impactSound:Sound;
		public var impactSound2:Sound;
		public var impactSound3:Sound;
		public var soundChannel:SoundChannel;
		public var soundChannel2:SoundChannel;
		public var loopSoundPlaying:Boolean = false;
		
		protected var noCollideObject:Class;
						
		public function Trap(level:Level,X = 0,Y = 0,graphic = null,collisionObject = true,small = false,yOffset = false,static = false)
		{
			//graphic.filters = [new GlowFilter(0x00FFFF,1,20,20)]
			
			startSound = new defaultImpact1();
			loopSound = new skateboardSound();
			impactSound = new defaultImpact1();
			impactSound2 = new defaultImpact2();
			impactSound3 = new defaultImpact3();
			
			x=X;
			y=Y;
			
			//var rect:Shape = new Shape();
//			rect.graphics.beginFill(0x000000,1);
//			rect.graphics.drawRect(-10,-10,20,20)
//			rect.graphics.endFill();
//			addChild(rect);
			
			if (graphic != null)
			{
				this.graphic = graphic;
				
				if (yOffset)
					graphic.y =(graphic.height/2);
				
				addChild(this.graphic);
				
				
					
			}
			
			if (graphic is MovieClip)
				graphic.stop();
			
			
			
			if (collisionObject)
			{
				if (small == true)
					hitBox = new collisionPoly([new Point(-4,-4),new Point(-4,4),new Point(4,4),new Point(4,-4)],new Point(0,0),this);

				
				else
					hitBox = new collisionPoly([new Point(-width/2,-height/2),new Point(-width/2,height/2),new Point(width/2,height/2),new Point(width/2,-height/2)],new Point(0,0),this);
			}
			
			boxGraphic = new Shape();
			boxGraphic.graphics.lineStyle(0.1, 0x00FF00);
			boxGraphic.graphics.beginFill(0x000000,0);
			boxGraphic.graphics.drawRect(-width/2,-height/2,width,height)
			boxGraphic.graphics.endFill();
			
			//boxGraphic.graphics.lineStyle(0.1, 0x00FF00);
//			boxGraphic.graphics.moveTo(hitBox.pointList[0].x, hitBox.pointList[0].y);
//			boxGraphic.graphics.beginFill(0x0000ff,0.0);
//						
//			
//				
//			for (var i:int = 0; i < hitBox.pointList.length; i ++)
//			{
//				if (i < hitBox.pointList.length - 1 && i == 0)
//				{
//					
//				}
//				
//				if (i < hitBox.pointList.length - 1)
//				{
//					var convertedPos:Point = new Point (hitBox.pointList[i + 1].x,hitBox.pointList[i + 1].y);
//					convertedPos.x = convertedPos.x;
//					convertedPos.y = convertedPos.y;
//					
//					boxGraphic.graphics.lineTo(convertedPos.x, convertedPos.y);
//				}
//				
//				else 
//				{
//					boxGraphic.graphics.lineTo(0,-height/2);
//				}
//			}
//			
//			boxGraphic.graphics.endFill();
//				
//			boxGraphic.x = 0;
//			boxGraphic.y = 0;
			addChildAt(boxGraphic,0);
						
			this.level = level
			
			if (level != null)
				level.proximityTree.addObject(this);
			
			actualWidth = width;
			actualHeight = height;
			
			addEventListener(MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			
			addEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			addEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			
			//if (static == false)
			//{
				//snap();
			
				//if (level != null && collisionObject)
					//terrainCollide();
			//}
				
			startY = y;
		}
		
		public function beginHighlight(evt:MouseEvent):void
		{
			if (level.dragging == false)
				scaleX = scaleY = 1.5;
		}
		
		public function endHighlight(evt:MouseEvent):void
		{
			if (dragging == false && level.dragging == false)
				scaleX = scaleY = 1;
		}
		
		public function beginOrEndDrag(evt:MouseEvent):void
		{
			trace('end drag')
			
			if (level.dragging == false && dragging == false)
			{
				dragging = true;
				level.dragging = true;
				addEventListener(Event.ENTER_FRAME, addEndDragListener);
			}
			
			else  if (snapped == true)
			{
				scaleX = scaleY = 1;
				startY = y;
				dragging = false;
				level.dragging = false;
				level.removeEventListener(MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			}
		}	
		
		protected function addEndDragListener(evt:Event):void
		{
			level.addEventListener(MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			removeEventListener(Event.ENTER_FRAME, addEndDragListener);
		}
		
		public function endDrag():void
		{
			dragging = false;
			level.dragging = false;
			scaleX = scaleY = 1;
			var tint:Color;
			tint = new Color();
			tint.setTint(0xFF0000,0);
			transform.colorTransform = tint;
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
		}
		
		protected function snap():void
		{
			var neighbors:Array;
			
			var i:int = Math.round(y) / level.cellSize;
			var n:int = Math.round(x) / level.cellSize;
			
			if (level.terrain[i] != null && level.terrain[i][n] != null && !(level.terrain[i][n][1] is collisionObject))
			{				
				if (level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null && (level.terrain[i + 1][n][1] is staticCollisionRect || level.terrain[i + 1][n][1] is staticCollisionTri || (level.terrain[i + 1][n][1] is staticCollisionOct && x > (level.terrain[i + 1][n][1].x + (level.cellSize / 3)) && x < (level.terrain[i + 1][n][1].x + (level.cellSize - (level.cellSize/3))))))
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
							if(neighbors[i].hitBox.checkPolyCollision(this,true,0,true) && !(neighbors[i] is swingUpTrap)  && !(this is swingUpTrap))
							{
								if (neighbors[i] == combinationObject)
									deCombine == false
									
								else if ('combine' in neighbors[i])
								{
									neighbors[i].combine(this);
									combinationObject = neighbors[i];
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
							if (neighbors[i].hitBox.checkPolyCollision(this,true) && Engine.mouse[1] && !(neighbors[i] is swingUpTrap)  && !(this is swingUpTrap))
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
		
		protected function iterMove():void
		{
			if (verticalSpeed != 0 && Math.sqrt(verticalSpeed * verticalSpeed) >= Math.sqrt(horizontalSpeed * horizontalSpeed))
			{
				if (verticalSpeed > 1 || verticalSpeed < -1)
					var moveIters = Math.abs(Math.sqrt(verticalSpeed * verticalSpeed));
					
				else
					moveIters = 1;
				
				for (var i:int = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(verticalSpeed * verticalSpeed) != 0)
						y += verticalSpeed / Math.sqrt(verticalSpeed * verticalSpeed);
						
					x += horizontalSpeed / moveIters;
					
					level.proximityTree.refresh();
					trapCollide();
					terrainCollide();
					
				}
			}
				
			else 
			{
				if (horizontalSpeed > 1 || horizontalSpeed < -1)
					moveIters = Math.abs(Math.sqrt(horizontalSpeed * horizontalSpeed));
					
				else
					moveIters = 1;
				
				for ( i = 0; i < moveIters; i ++)
				{
					if (Math.sqrt(horizontalSpeed * horizontalSpeed) != 0)
						x += horizontalSpeed / Math.sqrt(horizontalSpeed * horizontalSpeed);
												
					y += verticalSpeed / moveIters;
										
					level.proximityTree.refresh();
					trapCollide();
					terrainCollide();
					
				}
			}
		}
		
		protected function terrainCollide():void
		{
			onGround = false;
			var i:int = Math.round(y) / level.cellSize;
			var n:int = Math.round(x) / level.cellSize;
			
			if (level.terrain[i] != null && level.terrain[i][n] != null && level.terrain[i][n][1] != null)
			{
				if (level.terrain[i][n][1] is staticCollisionRect  || level.terrain[i][n][1] is stairObject && (level.terrain[i][n][1].y >= startY || goThroughStairs == false || level.terrain[i][n][1].optional == false))
				{
					if (level.terrain[i][n][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
							
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i][n][1] is staticCollisionTri && level.terrain[i][n][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					else if(y < level.terrain[i][n][1].y)
					{
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i][n][1] is staticCollisionOct)
				{
					if (level.terrain[i][n][1].checkPolyCollision(this))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
					}
				}
			}
				//boxCollide(level.terrain[i][n][1]);
				
			if (level.terrain[i] != null && level.terrain[i][n + 1] != null && level.terrain[i][n + 1][1] != null)
			{
				if (level.terrain[i][n + 1][1] is staticCollisionRect  || level.terrain[i][n + 1][1] is stairObject && (level.terrain[i][n + 1][1].y >= startY || goThroughStairs == false || level.terrain[i][n + 1][1].optional == false))
				{
					if (level.terrain[i][n + 1][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i][n + 1][1] is staticCollisionTri && level.terrain[i][n + 1][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					else if(y < level.terrain[i][n][1].y)
					{
						onGround = true;
						//trace('onGround');
					}
				}
			}
			
			if (level.terrain[i] != null && level.terrain[i][n - 1] != null && level.terrain[i][n - 1][1] != null)
			{
				if (level.terrain[i][n - 1][1] is staticCollisionRect  || level.terrain[i][n - 1][1] is stairObject && (level.terrain[i][n - 1][1].y >= startY || goThroughStairs == false || level.terrain[i][n - 1][1].optional == false))
				{
					if (level.terrain[i][n - 1][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i][n - 1][1] is staticCollisionTri && level.terrain[i][n - 1][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					onGround = true;
					//trace('onGround');
				}
			}
			
			if (level.terrain[i + 1] != null && level.terrain[i + 1][n] != null && level.terrain[i + 1][n][1] != null)
			{
				if (level.terrain[i + 1][n][1] is staticCollisionRect  || level.terrain[i + 1][n][1] is stairObject && (level.terrain[i + 1][n][1].y >= startY || goThroughStairs == false || level.terrain[i + 1][n][1].optional == false))
				{
					if (level.terrain[i + 1][n][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i + 1][n][1] is staticCollisionTri && level.terrain[i + 1][n][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					if (y < level.terrain[i + 1][n][1].y)
					{
						onGround = true;
						verticalSpeed = 0;
					}
					//trace('onGround');
				}
				//boxCollide(level.terrain[i + 1][n][1]);
			}
			
			if (level.terrain[i + 1] != null && level.terrain[i + 1][n + 1] != null && level.terrain[i + 1][n + 1][1] != null)
			{
				if (level.terrain[i + 1][n + 1][1] is staticCollisionRect  || level.terrain[i + 1][n + 1][1] is stairObject && (level.terrain[i + 1][n + 1][1].y >= startY || goThroughStairs == false || level.terrain[i + 1][n + 1][1].optional == false))
				{
					if (level.terrain[i + 1][n + 1][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i + 1][n + 1][1] is staticCollisionTri && level.terrain[i + 1][n + 1][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					onGround = true;
					//trace('onGround');
				}
				//boxCollide(level.terrain[i + 1][n + 1][1]);
			}
			
			if (level.terrain[i + 1] != null && level.terrain[i + 1][n - 1] != null && level.terrain[i + 1][n - 1][1] != null)
			{
				if (level.terrain[i + 1][n - 1][1] is staticCollisionRect  || level.terrain[i + 1][n - 1][1] is stairObject && (level.terrain[i + 1][n - 1][1].y >= startY || goThroughStairs == false || level.terrain[i + 1][n - 1][1].optional == false))
				{
					if (level.terrain[i + 1][n - 1][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
					}
				}
				
				else if (level.terrain[i + 1][n - 1][1] is staticCollisionTri && level.terrain[i + 1][n - 1][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					onGround = true;
					//trace('onGround');
					
					
				}
				
				//boxCollide(level.terrain[i + 1][n - 1][1]);
			}
			
			if (level.terrain[i - 1] != null && level.terrain[i - 1][n] != null && level.terrain[i - 1][n][1] != null)
			{
				if (level.terrain[i - 1][n][1] is staticCollisionRect  || level.terrain[i - 1][n][1] is stairObject && (level.terrain[i - 1][n][1].y >= startY || goThroughStairs == false || level.terrain[i - 1][n][1].optional == false))
				{
					if (level.terrain[i - 1][n][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
						
						
					}
				}
				
				else if (level.terrain[i - 1][n][1] is staticCollisionTri && level.terrain[i - 1][n][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					onGround = true;
					//trace('onGround');
					
					
				}
			}
			
			if (level.terrain[i - 1] != null && level.terrain[i - 1][n - 1] != null && level.terrain[i - 1][n - 1][1] != null)
			{
				if (level.terrain[i - 1][n - 1][1] is staticCollisionRect  || level.terrain[i - 1][n - 1][1] is stairObject && (level.terrain[i - 1][n - 1][1].y >= startY || goThroughStairs == false || level.terrain[i - 1][n - 1][1].optional == false))
				{
					if (level.terrain[i - 1][n - 1][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
						
						
					}
				}
				
				else if (level.terrain[i - 1][n - 1][1] is staticCollisionTri && level.terrain[i - 1][n - 1][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					onGround = true;
					//trace('onGround');
					
					
				}
			}
			
			if (level.terrain[i - 1] != null && level.terrain[i - 1][n + 1] != null && level.terrain[i - 1][n + 1][1] != null)
			{
				if (level.terrain[i - 1][n + 1][1] is staticCollisionRect  || level.terrain[i - 1][n + 1][1] is stairObject && (level.terrain[i - 1][n + 1][1].y >= startY || goThroughStairs == false || level.terrain[i - 1][n + 1][1].optional == false))
				{
					if (level.terrain[i - 1][n + 1][1].checkPolyCollision(this,false,true))
					{
						if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
						{
							var soundChoice = Math.random() * 3
						
							if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
								soundChannel2 == impactSound.play()
							
							else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
								soundChannel2 == impactSound2.play()
							
							else if (soundChoice > 0 && impactSound3 != null)
								soundChannel2 == impactSound3.play()
						}
						
						verticalSpeed = 0;
						onGround = true;
						//trace('onGround');
						
						
					}
				}
				
				else if (level.terrain[i - 1][n + 1][1] is staticCollisionTri && level.terrain[i - 1][n + 1][1].checkPolyCollision(this))
				{
					if ((horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4) && loopSoundPlaying == false)
					{
						var soundChoice = Math.random() * 3
					
						if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
							soundChannel2 == impactSound.play()
						
						else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
							soundChannel2 == impactSound2.play()
						
						else if (soundChoice > 0 && impactSound3 != null)
							soundChannel2 == impactSound3.play()
					}
					
					if (verticalSpeed < 0)
						verticalSpeed = 0;
						
					onGround = true;
					//trace('onGround');
					
					
				}
			}
		}
		
		protected function trapCollide():void
		{
			var neighbors = level.proximityTree.getNeighbors(this);
					
			for (var i:int = 0; i <= neighbors.length; i ++)
			{				
				if (neighbors[i] is Trap && neighbors[i] != null && neighbors[i] != this && !(noCollideObject != null && neighbors[i] is noCollideObject) && neighbors[i].hitBox != null && !(neighbors[i] is physicsParticle))
				{
					if (x + (width/2) > neighbors[i].x - (width/2) && x - (width/2) < neighbors[i].x + (width/2) && y + (height/2) > neighbors[i].y - (height/2) && y - (height/2) < neighbors[i].y + (height/2))
					{
						if (this is Lawnmower && neighbors[i].hitBox.checkTrapPolyCollision(this,false,0))
						{
							soundChannel.stop()
						}
						
						else if (this is ballTrap && y <= neighbors[i].y && neighbors[i] is ballTrap)
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,true,1))
							{
								neighbors[i].looping = true;
								neighbors[i].alpha = 1;
								
								if (horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4)
								{
									var soundChoice = Math.random() * 3
								
									if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
										soundChannel2 == impactSound.play()
									
									else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
										soundChannel2 == impactSound2.play()
									
									else if (soundChoice > 0)
										soundChannel2 == impactSound3.play()
								}
							}
						}
						
						else if (this is toySoldier && neighbors[i] is toySoldier)
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,false,0,false))
							{
								if (neighbors[i].looping == false)
								{
									looping = false;
								}
								
								if (horizontalSpeed != 0 || verticalSpeed > 0.4 || verticalSpeed < -0.4)
								{
									var soundChoice = Math.random() * 3
								
									if ((soundChoice > 2 || impactSound2 == null) && impactSound != null)
										soundChannel2 == impactSound.play()
									
									else if ((soundChoice > 1 || impactSound3 == null) && impactSound2 != null)
										soundChannel2 == impactSound2.play()
									
									else if (soundChoice > 0)
										soundChannel2 == impactSound3.play()
								}
							}

						}
						
						else if (this is fluidTrap && neighbors[i] is fluidTrap)
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,true,1,true))
							{
								if (neighbors[i].looping == false && y > neighbors[i].y - 2 && y < neighbors[i].y + 2)
								{
									looping = false;
								}
							}
						}
						
						/*else if (this is water && (neighbors[i] is water || neighbors[i] is oil))
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,true,1,true))
							{
								if (neighbors[i].looping == false && y > neighbors[i].y - 2 && y < neighbors[i].y + 2)
								{
									looping = false;
								}
							}
						}
						
						else if (this is oil && (neighbors[i] is water || neighbors[i] is oil))
						{
							if (neighbors[i].hitBox.checkTrapPolyCollision(this,true,1,true))
							{
								if (neighbors[i].looping == false && y > neighbors[i].y - 2 && y < neighbors[i].y + 2)
								{
									looping = false;
								}
							}
						}*/
						
						else if (!(neighbors[i] is fluidTrap))
							neighbors[i].hitBox.checkTrapPolyCollision(this,false,2)
					}
				}
			}
		}
		
		public function drag():void
		{			
			var mouseCellY = Math.floor(level.mouseY / level.cellSize);
			var mouseCellX = Math.floor(level.mouseX / level.cellSize);

			if (!(level.terrain[mouseCellY][mouseCellX][1] is collisionObject))
			{
				x = level.mouseX;
				y = level.mouseY;
			}

			if (level.terrain[mouseCellY] != null && level.terrain[mouseCellY][mouseCellX] != null && level.terrain[mouseCellY][mouseCellX][1] != null)
			{
				for (var i:int = 0; i < 10; i++)
				{
					x += (level.mouseX - x)/10
					y += (level.mouseY - y)/10
					
					snap()
				}
				
				//else
//				{
//					for (var i:int = 0; i < (Math.abs(level.mouseX - x)); i++)
//					{
//						if (level.mouseX != x)
//							x += ((level.mouseX - x) / Math.abs(level.mouseX - x)) * 2;
//					
//						if (level.mouseY != y)
//							y += ((level.mouseY - y) / Math.abs(level.mouseY - y)) * 2;
//					}
//				}
			}
			
			//else 
//			{
//				x = level.mouseX;
//				y = level.mouseY;
//			}
			
			snap();
			
			//trace (level.proximityTree.getNeighbors(this))
			
		}
		
		public function boxCollide(object)
		{
			if (x + (width / 2) > object.x && x - (width / 2) < object.x + object.width && y + (height / 2) > object.y && y - (height / 2) < object.y + (object.height))
			{
				var xCollision:Number = 0;
				var yCollision:Number = 0;
				
				if (x > object.x + (object.width/2))
				{
					xCollision = ( (object.x + object.width)-(x - width /2) );	
				}
						
				else if (x < object.x + (object.width/2))
				{
					xCollision = ( (x + width /2)-(object.x));		
				}
						
				if (y > object.y + (object.height/2))
				{
					yCollision = ( (object.y + object.height)-(y - height /2) );		
				}		
						
				else if (y < object.y + (object.height/2))
				{
					yCollision = ( (y + height /2)-(object.y));		
				}
						
				if (xCollision < yCollision && xCollision != 0)
				{
					if (this.x > object.x + (object.width/2))
						this.x += xCollision;
							
					else if (this.x < object.x + (object.width/2))
						this.x -= xCollision;
				}
						
				else if (yCollision < xCollision && yCollision != 0)
				{
					if (this.y > object.y  + (object.height/2))
						this.y += yCollision;
								
					else if (this.y < object.y + (object.height/2))
						this.y -= yCollision;
				}
				
				else
				{
					if (this.x > object.x + (object.width/2))
						this.x += xCollision;
							
					else if (this.x < object.x + (object.width/2))
						this.x -= xCollision;
						
					if (this.y > object.y  + (object.height/2))
						this.y += yCollision;
								
					else if (this.y < object.y + (object.height/2))
						this.y -= yCollision;
				}
			}
		}
		
		
		// beyond this point - for attempt mode
		public function changeMode():void
		{
			removeEventListener (MouseEvent.MOUSE_DOWN, beginOrEndDrag);
			removeEventListener (MouseEvent.MOUSE_OVER, beginHighlight);
			removeEventListener (MouseEvent.MOUSE_OUT, endHighlight);
			removeEventListener (Event.ENTER_FRAME, addEndDragListener);
			
			boxGraphic.alpha = 0;
			
			filters = [];
			
			addEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		public function playerCollide(target,movement = true):Boolean
		{			
			if (hanging == true)
			{
				if (target.hitBox.checkPolyCollision(this,true,0,true))
					return(true);
					
				else
					return(false);
			}
			
			else if (hitBox.checkPolyCollision(target,false,0,false))
				return(true);
				
			else
				return(false);
		}
		
		protected function mouseInteract(evt:MouseEvent):void
		{
			if (startSound != null)
			{
				soundChannel = startSound.play();
				loopSoundPlaying = true;
			}
			
			if (loopSound != null)
			{
				soundChannel = loopSound.play(0,int.MAX_VALUE);
				loopSoundPlaying = true;
			}
			
			
			
			//if (mouseX < 0)
				//horizontalSpeed = 3;
			
			//else
				//horizontalSpeed = -3;
				
			looping = true;
			
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
		}
		
		public function loop():void
		{
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				soundChannel.stop();
				looping = false;
				return;
			}
			
			iterMove();
						
			if (graphic != null)
				graphic.rotation += rotationSpeed;
				
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
				if (horizontalSpeed <= -friction)
				{
					horizontalSpeed += friction;
				}
				
				else if (horizontalSpeed >= friction)
				{
					horizontalSpeed -= friction;
				}
				
				else
				{
					if (soundChannel != null)
						soundChannel.stop();
					
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
						
					else if (rotationSpeed < 0)
						rotationSpeed += 0.5;
				}
				
				if (verticalSpeed > 0.4 || verticalSpeed < -0.4)
				{
					if (soundChannel != null)
					soundChannel.stop();
					loopSoundPlaying = false;
				}
				
				else if (loopSoundPlaying == false)
				{
					soundChannel = loopSound.play(0,int.MAX_VALUE);
					loopSoundPlaying = true;
				}
				
				if (horizontalSpeed == 0 && verticalSpeed == 0 && rotationSpeed == 0)
				{
					alpha = 0.5;				//active = false;
					looping = false;
					soundChannel.stop();
				}
				
				else
					verticalSpeed += gravity;
					
			}
			
			if (x < -width/2 || x > level.actualWidth + 40)
			{
				soundChannel.stop();
				looping = false;
			}
			
		}
		
		private function mouseHover():void
		{
			
		}
		
		private function mouseAway():void
		{
			
		}
		
		public function removeSelf():void
		{
			removeEventListener (MouseEvent.MOUSE_DOWN, mouseInteract);
			
			removeEventListener (MouseEvent.MOUSE_OVER, mouseHover)
			removeEventListener (MouseEvent.MOUSE_OUT, mouseAway)
			
			level.proximityTree.removeObject(this);
			looping = false;
		}
	}
}