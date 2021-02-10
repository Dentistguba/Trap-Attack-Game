package
{
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	
	public class Level4 extends Level
	{ 
		private var _terrain = new Array([[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1] ,[1],[1],[1],[1]],
										 [[1],[1],[5],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[1]],
										 [[1],[5],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[1],[0],[0],[0],[1],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[1]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[1],[1],[1],[1],[6],[0],[0],[0],[1],[1],[1],[1],[1],[1],[1],[1],[1],[0],[0],[0],[9],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[0],[0],[10],[1],[1],[1],[1],[1]],
										 [[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[10],[1],[1],[1],[1],[1]],
										 [[1],[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[10],[1],[1],[1],[1],[1]],
										 [[1],[1],[1],[1],[1],[1],[1],[6],[0],[0],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[10],[1],[1],[1],[1],[1]],
										 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]])
		
		private var nodelist:Vector.<Node> = new Vector.<Node>();
								
		public function Level4(TrapList = null)
		{  
			Engine.gameTracker.beginLevel(4)
		
			trace ('blah');
			
			nodelist.push(new Node(0,250,[[1,0]]));
			nodelist.push(new Node(200,250,[[2,1],[8,5]]));
			nodelist.push(new Node(400,250,[[3,0]]));
			nodelist.push(new Node(850,250,[[4,1]]));
			nodelist.push(new Node(1050,250,[[5,0]]));
			nodelist.push(new Node(1600,250,[[6,1]]));
			nodelist.push(new Node(1750,250,[[7,0]]));
			nodelist.push(new Node(2000,250,[[]]));
			
			nodelist.push(new Node(400,450,[[9,0]]));
			nodelist.push(new Node(850,450,[[4,4],[10,0]]));
			nodelist.push(new Node(1725,450,[[6,5]]));
			
			super(_terrain,nodelist,210,TrapList);
			//createMap();
			
			BGM = new lounge();
			musicChannel = BGM.play();
			
			Engine.hud.readyButton.visible = false;
			
			if (Engine.musicOff == true)
			{
				var transform:SoundTransform = musicChannel.soundTransform;
				transform.volume = 0;
				musicChannel.soundTransform = transform;
			}
			
			else
			{
				musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
			}
			
			if (TrapList == null)
			{
				super.createTrap(1450,425,trolley);
				super.createTrap(1555,410,peaBag);
				super.createTrap(1550,198,banana);
				setChildIndex(super.createTrap(650,222.5,cooker),2);
				super.createTrap(600,190,kettle);
				super.createTrap(300,188,porridgeBox);
				super.createTrap(1070,240,bleachCan);
				super.createTrap(1150,338,beerKeg);
				super.createTrap(1250,338,cheeseWheel);
			}
			
			door = addChild(new Door(50,250));
		}
		
		override public function loop():void
		{
			if (loopCount > 0)
				loopCount --;
				
			
			// setup
			if (levelState == 0)
			{
				if (tutProgress == 0 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(2);
					Engine.hud.storyTextBox.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "Stupid traps! When I find that kid...";
					
					voiceChannel = new Level4Voice1().play();
					
					loopCount = 200;
					tutProgress = 1;
				}
					
				if (tutProgress == 1 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyText.text = "He’s getting further into the house! Whatever he’s after, I’ll stop him. I bet there’s something in the kitchen I can use...";
					
					voiceChannel.stop();
					voiceChannel = new Level4Voice2().play();
					
					loopCount = 200;
					tutProgress = 2;
				}
				
				else if (tutProgress == 2 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.readyButton.visible = true;
					Engine.hud.storyTextBox.visible = false;
					Engine.hud.storyText.visible = false;
					loopCount = 200;
					tutProgress = 3;
				}
				
				
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
					if (tutProgress < 4)
					{
						Engine.gameTracker.endLevel()
						
						loopCount = 100;
						BGM = new Victory();
						musicChannel.stop();
						musicChannel = BGM.play();
						
						Engine.achievementManager.level4Complete = true;
						
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBoxNoSkip.gotoAndStop(2);
						Engine.hud.storyTextBoxNoSkip.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "Arghh, who left that there. I'll find another way in.";
						
						voiceChannel.stop();
						voiceChannel = new Level2Voice2().play();
						
						tutProgress = 4
						
						//timer = new Timer(5000)
						//timer.addEventListener(TimerEvent.TIMER, levelSuccess);
						//timer.start();
					}
					
					else if (tutProgress == 5 && loopCount == 0)
					{
						Engine.hud.storyTextBox.visible = false;
						Engine.hud.storyTextBoxNoSkip.visible = false;
						Engine.hud.storyText.visible = false;
						Engine.hud.successScreen.visible = true;
					}

					else if (loopCount == 0)
					{
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBoxNoSkip.gotoAndStop(1);
						Engine.hud.storyText.text = "Ha, that should slow him down. Better make sure he doesn't get in anywhere else.";
						
						voiceChannel.stop();
						voiceChannel = new Level3Voice6().play();
						
						tutProgress = 5;
						loopCount = 100;
					}
				}
				
				else if (player.x >= actualWidth + 25)
				{					
					if (Engine.hud.failScreen.visible == false && !(Engine.hud.storyText.text == "I didn't manage to stop the burglar. Oh man my parent's are gonna be mad, I better try again."))
					{
						loopCount = 100;
						BGM = new Failure();
						musicChannel.stop();
						musicChannel = BGM.play();
																	
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBoxNoSkip.gotoAndStop(1);
						Engine.hud.storyTextBoxNoSkip.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "I didn't manage to stop the burglar. Oh man my parent's are gonna be mad, I better try again.";
					
						voiceChannel.stop();
						voiceChannel = new Level0Voice9().play();
					}
					
					else if (loopCount == 0)
					{
						Engine.hud.storyTextBoxNoSkip.visible = false;
						Engine.hud.storyText.visible = false;
						Engine.hud.failScreen.visible = true;
					}
				}
				
				else if (objective != null && player.x > objective.x - 50)
				{
					BGM = new Failure();
					musicChannel.stop();
					musicChannel = BGM.play();
						
					Engine.game.editLevel();
						
					//Engine.hud.failScreen.visible = true;
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
						player = addChild(new AiPlayer(this,50,playerY))
					}
						
					//if (player.x <= actualWidth - 250 && player.x >= 250)
//						this.x = (this.width / 2) - player.x - ((this.width) / 2);
//						
//					if (player.y <= 450 && player.y >= 200)
//						this.y = (this.height / 2) - player.y - ((this.height) / 2);
						
					//screen mouse follow
					var mousePos = new Point(stage.mouseX, stage.mouseY);
					var playerPos = localToGlobal(new Point(player.x,player.y))
					
					if (mousePos.x > Engine.game.x + panStart && x + actualWidth > 250)
						x -= panSpeed;
						
					else if (playerPos.x < Engine.game.x && mousePos.x < Engine.game.x - panStart && x < -250)
						x += panSpeed;
						
					if (mousePos.y > Engine.game.y + panStart && y + actualHeight > 200)
						y -= panSpeed;
				
					else if (mousePos.y < Engine.game.y - panStart && y < -200)
						y += panSpeed;
					
					// screen burglar follow
					if (playerPos.x - 100 > Engine.game.x && x + actualWidth > 250)
						x -= player.horizontalSpeed;
					
					
				}
				
				
			}
			
			proximityTree.refresh();
		}
	}
}