package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.filters.BevelFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	
	public class Level extends MovieClip
	{
		public var actualWidth:Number;
		public var actualHeight:Number;
		public const cellSize = 50;
		protected const panStart:int = 160;
		protected const panSpeed:int = 10;
		private var _terrain:Array = new Array
		([[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]],
		 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[5],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[4],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]],
		 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[5],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[4],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[5]],
		 [[1],[1],[1],[1],[1],[1],[1],[1],[5],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[4],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[5],[0]],
		 [[1],[1],[1],[1],[1],[1],[1],[5],[0],[0],[9],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[8],[0],[0],[4],[1],[1],[1],[1],[1],[1],[1],[1],[1],[5],[0],[0]],
		 [[1],[0],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[8],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1]],
		 [[0],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[8],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1]],
		 [[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[8],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1]],
		 [[1],[1],[1],[6],[0],[0],[4],[1],[1],[1],[1],[1],[1],[1],[5],[0],[0],[7],[1],[1],[6],[0],[0],[4],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[5],[0],[0],[7],[1],[1],[1],[1],[1]],
		 [[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1],[1],[1],[1],[1]],
		 [[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1],[1],[1],[1],[1],[1]],
		 [[1],[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1],[1],[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[7],[1],[1],[1],[1],[1],[1],[1],[1]],
		 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]]);
		
		
		// this contains proximity grids for collision, each object will be added to one of these based on its rough size:
		// ground Quads(four 'chunks' of ground size - largest), ground(for floor e.t.c. and most traps e.g. bucket), particles(e.g. marbles)
		public var proximityTree = new simpleProximityTree(cellSize);

		//list of ai paths: new Node(x,y,[[node:int,type:int]])
		public var nodeList:Vector.<Node> = new Vector.<Node>();
		public var terrainTypes:Array = new Array(null,staticCollisionRect,Goal);
		
		public var trapList:Vector.<Trap> = new Vector.<Trap>();
		public var editTrapList:Vector.<Trap> = new Vector.<Trap>();
		
		public var trapTypes:Array = new Array(Trap);
		private var goalList:Array = new Array();
		protected var playerFollow:Boolean = false;
		protected var player;
		protected var door;
	
		private var trapType:int = 0;
		public var dragging:Boolean = false;
		public var levelState:int = 0;
		
		protected var BGM = new bedroom();
		public var musicChannel:SoundChannel = new SoundChannel();
		
		public var voiceChannel:SoundChannel = new SoundChannel();
		
		protected var timer:Timer;
		protected var playerY:Number;
		protected var playerHealth:int = 100;
		
		protected var cameraStartY:int = -275;
		
		protected var objective;
		
		protected var loopCount:int = 0;
		protected var tutProgress:int = 0;
		
		public function Level(map = null,nodelist = null,PlayerY = 360,TrapList = null,PlayerHealth = 100,CameraStartY:int = 0,Objective = null):void
		{
			Engine.hud.storyText.visible = false;
			Engine.hud.healthText.visible = false;
			Engine.hud.healthBar.visible = false;
			
			if (Objective != null)
				objective = Objective;
			
			cameraStartY -= CameraStartY;
			
			playerY = PlayerY;
			playerHealth = PlayerHealth;
			
			//musicChannel = BGM.play();
			//musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
			
			x = -250;
			y = cameraStartY;
			
			if (map != null)
			{
				_terrain = map;
				nodeList = nodelist;
				
				for (var i:int = 0; i < nodeList.length; i++)
					nodeList[i].createConnections(nodeList);
					
				if(TrapList != null)
				{
					for (var i:int = 0; i < TrapList.length; i++)
					{
						var exampleType:Class = Object(TrapList[i]).constructor;

						trace (exampleType , 're-Create trap');
						
						if (TrapList[i] is swingingTrap)
						{
							var trap;
							var hangingObjectType = Object((TrapList[i] as swingingTrap).swingingObject).constructor;
							var object = (TrapList[i] as swingingTrap).swingingObject
							
							trapList.push(addChild(trap = new swingingTrap (this,addChild (new hangingObjectType(this,object.x,object.y)), TrapList[i].x, TrapList[i].y)));
							trap.finalise();
							trap.swingingObject.hanging = true;
							trap.dragging = false;
							dragging = false;
							trap.swingingObject.removeEventListener (MouseEvent.MOUSE_OVER, trap.swingingObject.beginHighlight);
						}
						
						else
							trapList.push(addChild(new exampleType(this,TrapList[i].x,TrapList[i].y)));
					}
				}
				
				createMap();
			}
			
			//else
//			{
//				nodeList.push(new Node(0,400,[[1,0]]));
//				nodeList.push(new Node(150,400,[[2,1],[3,5]]));
//				nodeList.push(new Node(300,400,[[4,4],[12,0]]));
//				nodeList.push(new Node(350,600,[[16,0]]));
//				nodeList.push(new Node(550,200,[[5,0]]));
//				nodeList.push(new Node(1450,200,[[6,5]]));
//				nodeList.push(new Node(1650,400,[[7,0]]));
//				nodeList.push(new Node(1850,400,[[8,1]]));
//				nodeList.push(new Node(2000,400,[[9,0]]));
//				nodeList.push(new Node(2100,400,[[10,4]]));
//				nodeList.push(new Node(2250,250,[[11,0]]));
//				nodeList.push(new Node(2300,250,[]));
//	
//				nodeList.push(new Node(750,400,[[13,1]]));
//				nodeList.push(new Node(900,400,[[14,0]]));
//				nodeList.push(new Node(1000,400,[[15,1],[17,5]]));
//				nodeList.push(new Node(1150,400,[[6,0]]));
//				
//				nodeList.push(new Node(700,600,[[13,4]]));			
//				nodeList.push(new Node(1200,600,[[18,0]]));
//				nodeList.push(new Node(1800,600,[[8,4]]));
//				
//				for (var i:int = 0; i < nodeList.length; i++)
//					nodeList[i].createConnections(nodeList);
//				
//				createMap();
//				
//				door = addChild(new Door(50,400));
//				
//				createTrap(700,400,Amp);
//				createTrap(1500,400,Amp);
//				createTrap(800,200,toySoldiersTub);
//				createTrap(1500,600,rope);
//				createTrap(1685,560,TV);
//				createTrap(1700,400,marbleBag);
//				createTrap(1800,400,marbleBag);
//				createTrap(1400,400,remoteControlCar);
//			}
			
			
			Engine.hud.readyButton.addEventListener(MouseEvent.MOUSE_UP, attempt);
			Engine.hud.readyButton.visible = true;
			
			if (Engine.musicOff == true)
			{
				var transform:SoundTransform = musicChannel.soundTransform;
            	transform.volume = 0;
            	musicChannel.soundTransform = transform;
			}
		}
		
		protected function loopMusic(evt:Event):void
		{
			musicChannel = BGM.play();
			musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
		}
		
		protected function attempt(evt:MouseEvent):void
		{
			levelState = 1;
			Engine.hud.storyTextBox.visible = false;
			Engine.hud.storyTextBoxNoSkip.visible = false;
			Engine.hud.storyText.visible = false;
			Engine.hud.healthText.visible = true;
			Engine.hud.healthBar.visible = true;
			
			BGM = new Sneaky();
			musicChannel.stop();
			musicChannel = BGM.play();
			musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
			
			if (Engine.musicOff == true)
			{
				var transform:SoundTransform = musicChannel.soundTransform;
            	transform.volume = 0;
            	musicChannel.soundTransform = transform;
			}
			
			for (var i:int = 0; i < trapList.length; i++)
			{
				var exampleType:Class = Object(trapList[i]).constructor;
	
				if (exampleType != swingingTrap && trapList[i].hanging == false)
					editTrapList.push(new exampleType(null,trapList[i].x,trapList[i].y));
					
				else if (exampleType == swingingTrap)
				{
					editTrapList.push(new swingingTrap(null,(trapList[i] as swingingTrap).swingingObject,trapList[i].x,trapList[i].y));
				}
			}
			
			//trace (editTrapList)
			
			for (var i:int = 0; i < trapList.length; i++)
			{
				trapList[i].changeMode();
			}
					
			x = -250;
			y = cameraStartY;
			
			door.active = true;
			
			Engine.hud.readyButton.removeEventListener(MouseEvent.MOUSE_UP, attempt);
			Engine.hud.readyButton.visible = false;
		}
		
		public function get terrain():Array
		{
			return _terrain;
		}
		
		protected function createMap():void
		{
			var bg:Shape = new Shape; // initializing the variable named rectangle
			//bg.graphics.lineStyle(0,0x000000);
			bg.graphics.beginFill(0x8888ff);
			bg.graphics.drawRect(0,0,_terrain[1].length* (cellSize),_terrain.length* (cellSize));
			bg.graphics.endFill();
			addChild(bg);
			actualWidth = _terrain[1].length* (cellSize);
			actualHeight = _terrain.length* (cellSize);
			//bg.visible = false;
			removeChild(bg);
			
			for (var i:int = 0; i < _terrain.length; i++)
			{
				for (var n:int = 0; n < _terrain[i].length; n++)
				{
					if (_terrain[i][n] == 1)
					{
						var rectangle:Shape = new Shape; // initializing the variable named rectangle
						rectangle.graphics.lineStyle(0,0x00FF00);
						rectangle.graphics.beginFill(0xFF0000,0.5); // choosing the colour for the fill, here it is red
						rectangle.graphics.drawRect(0,0,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE); // (x spacing, y spacing, width, height)
						rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
						rectangle.x = n* cellSize; 
						rectangle.y = i* cellSize;
						//addChild(rectangle);
						//rectangle.filters = [new BevelFilter()];
						
						var leftOpen = false
						var rightOpen = false
						
						if (_terrain[i][n-1] == 1)
							leftOpen = false
						
						_terrain[i][n][1] = new staticCollisionRect(this,n* cellSize,i* cellSize,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE,false,leftOpen,rightOpen);
					}
					
					else if (_terrain[i][n] == 2)
					{
						var rectangle:Shape = new Shape; // initializing the variable named rectangle
						rectangle.graphics.lineStyle(0,0x00FF00);
						rectangle.graphics.beginFill(0xFF0000,0.5); // choosing the colour for the fill, here it is red
						rectangle.graphics.drawRect(0,0,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE); // (x spacing, y spacing, width, height)
						rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
						rectangle.x = n* cellSize; 
						rectangle.y = i* cellSize;
						//addChild(rectangle);
						//rectangle.filters = [new BevelFilter()];
						_terrain[i][n][1] = new staticCollisionRect(this,n* cellSize,i* cellSize,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE, true);
						
						
						//var triangle:Shape = new Shape;
//						triangle.graphics.lineStyle(0, 0x00FF00); 
//						triangle.graphics.beginFill(0xFF0000,0.5);
//						triangle.graphics.lineTo(0,cellSize- Number.MIN_VALUE);
//						triangle.graphics.lineTo(cellSize- Number.MIN_VALUE,cellSize - Number.MIN_VALUE);
//						triangle.graphics.lineTo(0,0);
//						triangle.graphics.endFill(); 
//						triangle.x = n* cellSize; 
//						triangle.y = i* cellSize;
//						addChild(triangle);
//						
//						_terrain[i][n][1] = new staticCollisionTri(this,n* cellSize,i* cellSize,cellSize/*- Number.MIN_VALUE*/,cellSize- Number.MIN_VALUE,0);
					}
					
					else if (_terrain[i][n] == 3)
					{
						var rectangle:Shape = new Shape; // initializing the variable named rectangle
						rectangle.graphics.lineStyle(0,0x00FF00);
						rectangle.graphics.beginFill(0xFF0000,0.5); // choosing the colour for the fill, here it is red
						rectangle.graphics.drawRect(0,0,10,cellSize- Number.MIN_VALUE); // (x spacing, y spacing, width, height)
						rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
						rectangle.x = (n* cellSize) + (cellSize - 10); 
						rectangle.y = i* cellSize;
						//addChild(rectangle);
						//rectangle.filters = [new BevelFilter()];
						_terrain[i][n][1] = new ladderObject(this,n* cellSize,i* cellSize,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE);
						
						//goalList.push(_terrain[i][n][1] = addChild(new Goal(i * cellSize + cellSize/2 ,n * cellSize + cellSize)));
						//var triangle:Shape = new Shape;
//						triangle.graphics.lineStyle(0, 0x00FF00); 
//						triangle.graphics.beginFill(0xFF0000,0.5);
//						triangle.graphics.lineTo(0,cellSize- Number.MIN_VALUE);
//						triangle.graphics.lineTo(cellSize- Number.MIN_VALUE,cellSize - Number.MIN_VALUE);
//						triangle.graphics.lineTo(0,0);
//						triangle.graphics.endFill(); 
//						triangle.scaleX = -1;
//						triangle.x = (n* cellSize) + cellSize; 
//						triangle.y = (i* cellSize);
//						addChild(triangle);
//						
//						_terrain[i][n][1] = new staticCollisionTri(this,n* cellSize,i* cellSize,cellSize/*- Number.MIN_VALUE*/,cellSize- Number.MIN_VALUE,1);
					}
					
					else if (_terrain[i][n] == 4)
					{
						
						//goalList.push(_terrain[i][n][1] = addChild(new Goal(i * cellSize + cellSize/2 ,n * cellSize + cellSize)));
						var triangle:Shape = new Shape;
						triangle.graphics.lineStyle(0, 0x00FF00); 
						triangle.graphics.beginFill(0xFF0000,0.5);
						triangle.graphics.lineTo(0,cellSize- Number.MIN_VALUE);
						triangle.graphics.lineTo(cellSize- Number.MIN_VALUE,cellSize - Number.MIN_VALUE);
						triangle.graphics.lineTo(0,0);
						triangle.graphics.endFill(); 
						triangle.scaleX = -1;
						triangle.scaleY = -1;
						triangle.x = (n* cellSize) + cellSize; 
						triangle.y = (i* cellSize) + cellSize;
						//addChild(triangle);
						
						_terrain[i][n][1] = new staticCollisionTri(this,n* cellSize,i* cellSize,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE,2);
					}
					
					else if (_terrain[i][n] == 5)
					{
						var triangle:Shape = new Shape;
						triangle.graphics.lineStyle(0, 0x00FF00); 
						triangle.graphics.beginFill(0xFF0000,0.5);
						triangle.graphics.lineTo(0,cellSize- Number.MIN_VALUE);
						triangle.graphics.lineTo(cellSize- Number.MIN_VALUE,cellSize - Number.MIN_VALUE);
						triangle.graphics.lineTo(0,0);
						triangle.graphics.endFill(); 
						triangle.scaleY = -1;
						triangle.x = n* cellSize; 
						triangle.y = (i* cellSize) + cellSize;
						//addChild(triangle);
						
						_terrain[i][n][1] = new staticCollisionTri(this,n* cellSize,i* cellSize,cellSize/*- Number.MIN_VALUE*/,cellSize- Number.MIN_VALUE,3);
					}
					
					else if (_terrain[i][n] == 6)
					{
						var stair:Shape = new Shape;
						stair.graphics.lineStyle(0, 0x00FF00); 
						stair.graphics.beginFill(0xFF0000,0.5);
						stair.graphics.lineTo(cellSize/4,0);
						stair.graphics.lineTo(cellSize/4,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize);
						stair.graphics.lineTo(0,cellSize);
						stair.graphics.lineTo(0,0);
						stair.graphics.endFill(); 
						stair.x = n* cellSize; 
						stair.y = i* cellSize;
						//addChild(stair);
						
						_terrain[i][n][1] = new stairObject(n* cellSize,i* cellSize,cellSize,cellSize,0);
					}
					
					else if (_terrain[i][n] == 7)
					{
						var stair:Shape = new Shape;
						stair.graphics.lineStyle(0, 0x00FF00); 
						stair.graphics.beginFill(0xFF0000,0.5);
						stair.graphics.lineTo(cellSize/4,0);
						stair.graphics.lineTo(cellSize/4,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize);
						stair.graphics.lineTo(0,cellSize);
						stair.graphics.lineTo(0,0);
						stair.graphics.endFill();
						stair.scaleX = -1;
						stair.x = (n* cellSize) + cellSize; 
						stair.y = i* cellSize;
						//addChild(stair);
						
						_terrain[i][n][1] = new stairObject(n* cellSize,i* cellSize,cellSize,cellSize,1);
					}
					
					else if (_terrain[i][n] == 8)
					{
						var stair:Shape = new Shape;
						stair.graphics.lineStyle(0, 0x00FF00); 
						stair.graphics.beginFill(0xFF5555,0.5);
						stair.graphics.lineTo(cellSize/4,0);
						stair.graphics.lineTo(cellSize/4,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize);
						stair.graphics.lineTo(0,cellSize);
						stair.graphics.lineTo(0,0);
						stair.graphics.endFill(); 
						stair.x = n* cellSize; 
						stair.y = i* cellSize;
						//trace(stair.y)
						//addChild(stair);
						
						_terrain[i][n][1] = new stairObject(n* cellSize,i* cellSize,cellSize,cellSize,0,true);
					}
					
					else if (_terrain[i][n] == 9)
					{
						var stair:Shape = new Shape;
						stair.graphics.lineStyle(0, 0x00FF00); 
						stair.graphics.beginFill(0xFF5555,0.5);
						stair.graphics.lineTo(cellSize/4,0);
						stair.graphics.lineTo(cellSize/4,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/4);
						stair.graphics.lineTo(cellSize/2,cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize/2);
						stair.graphics.lineTo(cellSize - (cellSize/4),cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize - (cellSize/4));
						stair.graphics.lineTo(cellSize,cellSize);
						stair.graphics.lineTo(0,cellSize);
						stair.graphics.lineTo(0,0);
						stair.graphics.endFill();
						stair.scaleX = -1;
						stair.x = (n* cellSize) + cellSize; 
						stair.y = i* cellSize;
						//addChild(stair);
						
						_terrain[i][n][1] = new stairObject(n* cellSize,i* cellSize,cellSize,cellSize,1,true);
					}
					
					else if (_terrain[i][n] == 10)
					{
						var rectangle:Shape = new Shape; // initializing the variable named rectangle
						rectangle.graphics.lineStyle(0,0x00FF00);
						rectangle.graphics.beginFill(0xFF0000,0.5); // choosing the colour for the fill, here it is red
						rectangle.graphics.drawRect(0,0,10,cellSize- Number.MIN_VALUE); // (x spacing, y spacing, width, height)
						rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
						rectangle.x = (n* cellSize) + (cellSize - 10); 
						rectangle.y = i* cellSize;
						//addChild(rectangle);
						//rectangle.filters = [new BevelFilter()];
						_terrain[i][n][1] = new ladderObject(this,n* cellSize,i* cellSize,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE,false);
					}
					
					else if (_terrain[i][n] == 11)
					{
						var rectangle:Shape = new Shape; // initializing the variable named rectangle
						rectangle.graphics.lineStyle(0,0x00FF00);
						rectangle.graphics.beginFill(0xFF0000,0.5); // choosing the colour for the fill, here it is red
						rectangle.graphics.drawRect(0,0,10,cellSize- Number.MIN_VALUE); // (x spacing, y spacing, width, height)
						rectangle.graphics.endFill(); // not always needed but I like to put it in to end the fill
						rectangle.x = (n* cellSize) + (cellSize - 10); 
						rectangle.y = i* cellSize;
						//addChild(rectangle);
						//rectangle.filters = [new BevelFilter()];
						_terrain[i][n][1] = new staticCollisionOct(this,n* cellSize,i* cellSize,cellSize- Number.MIN_VALUE,cellSize- Number.MIN_VALUE, false);
					}
				}
			}
			
			for (var i:int = 0; i < nodeList.length; i++)
			{				
				var node:Shape = new Shape; // initializing the variable named rectangle
				node.graphics.lineStyle(0,0x00FF00);
				node.graphics.beginFill(0xFFFF00); // choosing the colour for the fill, here it is red
				node.graphics.drawCircle(0,0,10); // (x spacing, y spacing, width, height)
				node.graphics.endFill(); // not always needed but I like to put it in to end the fill
				node.x = nodeList[i].x; 
				node.y = nodeList[i].y;
				//addChild(node);
				
				if (nodeList[i].connections != null && nodeList[i].connections.length > 0)
				{					
					for (var n:int = 0; n < nodeList[i].connections.length; n++)
					{
						if (nodeList[i].connections[n] != null)
						{
							//trace (nodeList[i].connections[n].type)
							
							if (nodeList[i].connections[n].type == 0 || nodeList[i].connections[n].type == 4 || nodeList[i].connections[n].type == 5)
							{
								var connection:Shape = new Shape;
								connection.graphics.lineStyle(2,0xFFFFFF);
								connection.graphics.lineTo(nodeList[i].connections[n].nodeB.x - nodeList[i].x,nodeList[i].connections[n].nodeB.y - nodeList[i].y);
								connection.x = nodeList[i].x;
								connection.y = nodeList[i].y;
								//addChild(connection);
							}
							
							else if (nodeList[i].connections[n].type == 1 || nodeList[i].connections[n].type == 2)
							{
								var connection:Shape = new Shape;
								
								connection.graphics.lineStyle(2,0xFFFFFF);
								connection.graphics.curveTo((nodeList[i].connections[n].nodeB.x - nodeList[i].x)/2,-40,nodeList[i].connections[n].nodeB.x - nodeList[i].x,nodeList[i].connections[n].nodeB.y - nodeList[i].y);
								connection.x = nodeList[i].x;
								connection.y = nodeList[i].y;
								//addChild(connection);
							}
							
							else if (nodeList[i].connections[n].type == 3)
							{
								var connection:Shape = new Shape;
								
								connection.graphics.lineStyle(2,0xFFFFFF);
								connection.graphics.curveTo((nodeList[i].connections[n].nodeB.x - nodeList[i].x)/2,-40,nodeList[i].connections[n].nodeB.x - nodeList[i].x,nodeList[i].connections[n].nodeB.y - nodeList[i].y);
								connection.x = nodeList[i].x;
								connection.y = nodeList[i].y;
								//addChild(connection);
							}
						}
					}
					
					for (var n:int = 0; n < nodeList[i].backwardsConnections.length; n++)
					{
						if (nodeList[i].backwardsConnections[n] != null)
						{
							//trace (nodeList[i].backwardsConnections[0])
							
							if (nodeList[i].backwardsConnections[n].type == 0)
							{
								var connection:Shape = new Shape;
								connection.graphics.lineStyle(2,0x0000FF);
								connection.graphics.lineTo(nodeList[i].backwardsConnections[n].nodeB.x - nodeList[i].x,nodeList[i].backwardsConnections[n].nodeB.y - nodeList[i].y);
								connection.x = nodeList[i].x;
								connection.y = nodeList[i].y;
								//addChild(connection);
							}
							
							else if (nodeList[i].backwardsConnections[n].type == 1 || nodeList[i].backwardsConnections[n].type == 2)
							{
								var connection:Shape = new Shape;
								connection.graphics.lineStyle(2,0x000FF);
								connection.graphics.curveTo((nodeList[i].backwardsConnections[n].nodeB.x - nodeList[i].x)/2,-10,nodeList[i].backwardsConnections[n].nodeB.x - nodeList[i].x,nodeList[i].backwardsConnections[n].nodeB.y - nodeList[i].y);
								connection.x = nodeList[i].x;
								connection.y = nodeList[i].x;
								//addChild(connection);
							}
	//						
	//						else if (nodeList[i][2][n][1] == 3)
	//						{
	//							var connection:Shape = new Shape;
	//							connection.graphics.lineStyle(2,0xFFFFFF);
	//							connection.graphics.curveTo((nodeList[nodeList[i][2][n][0]][0] - nodeList[i][0])/2,-200,nodeList[nodeList[i][2][n][0]][0] - nodeList[i][0],nodeList[nodeList[i][2][n][0]][1] - nodeList[i][1]);
	//							connection.x = nodeList[i][0];
	//							connection.y = nodeList[i][1];
	//							addChild(connection);
	//						}
						}
					}
				}
			}

		}
		
		public function levelSuccess(evt:Event = null):void
		{
			trace("boom");
			musicChannel.stop();
			
			if (Engine.game.currentLevel != null)
				Engine.game.removeLevel();
			
			musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
			
			Engine.hud.storyTextBox.visible = false;
			Engine.hud.storyText.visible = false;
			Engine.hud.successScreen.visible = false;
		}
		
		protected function createTrap(X,Y,type):Trap
		{
			//var i:int = Math.round(Y / cellSize);
			//var n:int = Math.round(X / cellSize);
			
			//if (_terrain)
			//{
				var trap;
				trapList.push(trap = addChild(new type(this,X,Y)));
				return(trap);
			//}
		}
		
		public function loop():void
		{
			// setup
			if (levelState == 0)
			{
				if (player == null)
				{
					if (playerY == 0)
						player = addChildAt(new AiPlayer(this,11,360,playerHealth),3);
						
					else
						player = addChildAt(new AiPlayer(this,11,playerY,playerHealth),3);
				}
					
				// run trap loop if being dragged
				if(dragging)
				{
					for (var i:int = 0; i < trapList.length; i++)
					{
						if (trapList[i].dragging == true)
						{
							trapList[i].drag();
						}
					}
				}
			
				// screen mouse follow
				var mousePos = new Point(stage.mouseX, stage.mouseY);
				
				if (mousePos.x > Engine.game.x + panStart && x + actualWidth > 250)
					x -= panSpeed;
						
				else if (mousePos.x < Engine.game.x - panStart && x < -250)
					x += panSpeed;
						
				if (mousePos.y > Engine.game.y + panStart && y + actualHeight > 200)
					y -= panSpeed;
				
				else if (mousePos.y < Engine.game.y - panStart && y < -200)
					y += panSpeed;
					
					
				// moves to attempt phase
				//if (Engine.KeyArray[32][1] == true)
//				{
//					for (var i:int = 0; i < trapList.length; i++)
//					{
//						trapList[i].changeMode();
//					}
//					
//					levelState = 1;
//					x = -250;
//					y = -250;
//					door.active = true;
//				}
			}
			
			
			// attempt
			else
			{
				if (player.health <= 0)
				{
					if (Engine.hud.successScreen.visible == false)
					{
						BGM = new Victory();
						musicChannel.stop();
						musicChannel = BGM.play();
						Engine.hud.successScreen.visible = true;
						
						//timer = new Timer(5000)
						//timer.addEventListener(TimerEvent.TIMER, levelSuccess);
						//timer.start();
					}
				}
				
				else if (player.x >= actualWidth + 25)
				{
					if (Engine.hud.failScreen.visible == false)
					{
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						
						BGM = new Failure();
						musicChannel.stop();
						musicChannel = BGM.play();
						
						Engine.hud.failScreen.visible = true;
					}
				}
				
				else if (objective != null && player.x > objective.x - 50)
				{
					Engine.hud.healthText.visible = false;
					Engine.hud.healthBar.visible = false;
					
					BGM = new Failure();
					musicChannel.stop();
					musicChannel = BGM.play();
						
					Engine.hud.failScreen.visible = true;
				}
				
				else if (player.x > actualWidth - (actualWidth/5) && player.x < actualWidth && !(BGM is Uhoh))
				{
					BGM = new Uhoh();
					musicChannel.stop();
					musicChannel = BGM.play();
					
					if (Engine.musicOff == true)
					{
						var transform:SoundTransform = musicChannel.soundTransform;
						transform.volume = 0;
						musicChannel.soundTransform = transform;
					}
				}
					
				else
				{
					for (var i:int = 0; i < trapList.length; i++)
					{
						if (trapList[i].looping == true)
						{
							trapList[i].loop();
						}
					}
					
					if (player != null)
					{
						player.loop();
					}
					
					if (door.active)
					{
						
						
						door.loop(); 
					}
					
					else if (player.waiting)
					{
						player.waiting = false;
					}
									
					else if(Engine.KeyArray[32][1] == true) 
					{
						removeChild(player)
						proximityTree.removeObject(player);
						player = addChildAt(new AiPlayer(this,50,playerY),3)
					}
						
					//if (player.x <= actualWidth - 250 && player.x >= 250)
//						this.x = (this.width / 2) - player.x - ((this.width) / 2);
//						
//					if (player.y <= 450 && player.y >= 200)
//						this.y = (this.height / 2) - player.y - ((this.height) / 2);
						
					// screen mouse follow
					var mousePos = new Point(stage.mouseX, stage.mouseY);
				
					if (mousePos.x > Engine.game.x + panStart && x + actualWidth > 250)
						x -= panSpeed;
						
					else if (mousePos.x < Engine.game.x - panStart && x < -250)
						x += panSpeed;
						
					if (mousePos.y > Engine.game.y + panStart && y + actualHeight > 200)
						y -= panSpeed;
				
					else if (mousePos.y < Engine.game.y - panStart && y < -200)
						y += panSpeed;
					
					
				}
				
				
			}
			
			proximityTree.refresh();
		}
		
		public function removeSelf():void
		{
			removeEventListener(Event.ENTER_FRAME, loop);
			
			for (var i:int = 0; i < trapList.length; i++)
			{
				trapList[i].removeSelf();
			}
		}
	}
}