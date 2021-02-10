package
{
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	
	public class Level8 extends Level
	{ 	
		private var _terrain = new Array([[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[2],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0]],
										 [[0],[0],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[0],[3],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[0],[3],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[0],[0],[1],[1],[1],[1] ,[1],[1],[1],[1]],
										 [[0],[0],[1],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[1],[1]],
										 [[0],[0],[1],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[1],[1]],
									 	 [[1],[1],[1],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[1],[1]],
										 [[1],[1],[1],[1],[1],[0],[3],[1],[1],[1],[1],[0],[3],[1],[1],[1],[1],[1],[1],[0],[0],[0],[9],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[8],[0],[0],[0],[1],[1],[1],[1],[1],[1],[1],[0],[10],[1],[1],[1],[1]],
										 [[1],[1],[5],[0],[0],[0],[3],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[8],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[10],[1],[1],[1],[1]],
										 [[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[8],[0],[0],[0],[0],[0],[0],[0],[0],[0],[10],[1],[1],[1],[1]],
										 [[0],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[3],[0],[0],[0],[0],[0],[0],[9],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[8],[0],[0],[0],[0],[0],[0],[0],[0],[10],[1],[1],[1],[1]],
										 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1] ,[1],[1],[1],[1]])
		
		private var nodelist:Vector.<Node> = new Vector.<Node>();
								
		public function Level8(TrapList = null)
		{  
			Engine.gameTracker.beginLevel(8)
		
			trace ('blah');
			
			nodelist.push(new Node(0,700,[[1,0]]));
			nodelist.push(new Node(300,700,[[2,4],[21,0]]));
			nodelist.push(new Node(350,500,[[3,0]]));
			nodelist.push(new Node(550,500,[[4,1]]));
			nodelist.push(new Node(650,500,[[5,0]]));
			nodelist.push(new Node(750,500,[[6,4],[14,0]]));
			
			nodelist.push(new Node(800,300,[[7,0]]));
			nodelist.push(new Node(1400,300,[[8,1]]));
			nodelist.push(new Node(1500,300,[[9,0]]));
			nodelist.push(new Node(2000,300,[[10,0]]));
			
			nodelist.push(new Node(2050,500,[[11,0]]));
			nodelist.push(new Node(2200,500,[[12,1]]));
			nodelist.push(new Node(2300,500,[[13,0]]));
			nodelist.push(new Node(2400,500,[[]]));
			
			
			nodelist.push(new Node(950,500,[[15,1]]));
			nodelist.push(new Node(1150,500,[[16,0]]));
			nodelist.push(new Node(1450,500,[[8,4],[17,0]]));
			nodelist.push(new Node(1650,500,[[20,1],[18,5]]));
			
			nodelist.push(new Node(1850,700,[[19,0]]));
			nodelist.push(new Node(2250,700,[[12,4]]));
			
			nodelist.push(new Node(1850,500,[[11,0]]));
			
			
			nodelist.push(new Node(500,700,[[22,0]]));			
			nodelist.push(new Node(600,700,[[4,4],[23,0]]));
			nodelist.push(new Node(900,700,[[15,4],[18,0]]));
			
			
			super(_terrain,nodelist,660,TrapList,95,250);
			//createMap();
			
			BGM = new attic();
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
				super.createTrap(400,460,hatStand);
				super.createTrap(800,495,rope);
				super.createTrap(750,600,painting);
				super.createTrap(1200,463,guitar);
				super.createTrap(1900,495,skateboard);
				super.createTrap(1550,484,box);
				super.createTrap(1900,679,box);
				super.createTrap(1800,679,toySoldiersTub);
				super.createTrap(2000,480,cannon);
				super.createTrap(1900,280,bird);
				super.createTrap(1200,670,bust);
			}
			
			addChild(objective = new safe());
			objective.x = 2376;
			objective.y = 479;
			
			door = addChild(new Door(50,700));
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
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyTextBox.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "Right, this is it. I’d better use all the stuff in the loft to stop him here or he’ll get the safe!";
					
					voiceChannel = new Level8Voice1().play();
					
					loopCount = 200;
					tutProgress = 1;
				}
					
				else if (tutProgress == 1 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(2);
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "So close! I can do this!";
					
					voiceChannel.stop();
					voiceChannel = new Level8Voice2().play();
					
					loopCount = 200;
					tutProgress = 2;
				}
				
				else if (tutProgress == 2 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyTextBox.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "That old cannon looks interesting, maybe I can combine another object with it like I did with the rope.";
					
					voiceChannel.stop();
					voiceChannel = new Level8Voice3().play();
					
					loopCount = 200;
					tutProgress = 3;
				}
				
				else if (tutProgress == 3 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.readyButton.visible = true;
					Engine.hud.storyTextBox.visible = false;
					Engine.hud.storyText.visible = false;
					loopCount = 200;
					tutProgress = 4;
				}
				
				if (player == null)
				{
					if (playerY == 0)
						player = addChildAt(new AiPlayer(this,11,360,playerHealth),2);
						
					else
						player = addChildAt(new AiPlayer(this,11,playerY,playerHealth),2);
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
					if (Engine.achievementManager.achievement9 == false)
					{
						Engine.achievementManager.achievement9 = true;
						Engine.hud.addChild(new Achievement9Text());
					}
					
					if (tutProgress == 3)
					{
						Engine.gameTracker.endLevel()
						
						loopCount = 100;
						BGM = new Victory();
						musicChannel.stop();
						musicChannel = BGM.play();
						
						Engine.achievementManager.level8Complete = true;
						
						Engine.hud.storyTextBoxNoSkip.gotoAndStop(2);
						Engine.hud.storyTextBoxNoSkip.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "You bratty kid, I can't go on. I give up.";
						
						if (voiceChannel != null)
							voiceChannel.stop();
							
						voiceChannel = new Level8Voice4().play();
						
						//timer = new Timer(5000)
						//timer.addEventListener(TimerEvent.TIMER, levelSuccess);
						//timer.start();
						tutProgress = 4
					}
					
					else if (tutProgress == 5 && loopCount == 0)
					{
						Engine.hud.storyTextBoxNoSkip.gotoAndStop(2);
						Engine.hud.storyText.text = "To be honest, a life of crime isn't much fun when you're getting hit in the face by skateboards.";
						
						voiceChannel.stop();
						voiceChannel = new Level8Voice5().play();
						
						tutProgress = 6;
						loopCount = 100;
					}
					
					else if (tutProgress == 6 && loopCount == 0)
					{
						levelSuccess();
					}
					
					else if (loopCount == 0)
					{
						Engine.hud.storyTextBoxNoSkip.gotoAndStop(1);
						Engine.hud.storyText.text = "You're going to jail so you can't rob houses ever again! Man, I can't believe I thought stealing stuff was ok. From now on i'm stealing nothing, people work hard to get their stuff.";
						
						if (voiceChannel != null)
							voiceChannel.stop();
							
						voiceChannel = new Level0Voice6().play();
						
						tutProgress = 5;
						loopCount = 100;
					}
				}
				
				else if (player.x >= actualWidth + 25)
				{					
					if (Engine.hud.failScreen.visible == false && !(Engine.hud.storyText.text == "Oh no, the family fortune is gone. I better try again."))
					{
						loopCount = 100;
						BGM = new Failure();
						musicChannel.stop();
						musicChannel = BGM.play();
						
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBoxNoSkip.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "Oh no, the family fortune is gone. I better try again.";
						
						if (voiceChannel != null)
							voiceChannel.stop();
							
						voiceChannel = new Level8Voice7().play();
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
					if (Engine.hud.failScreen.visible == false && !(Engine.hud.storyText.text == "Oh no, the family fortune is gone. I better try again."))
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
						Engine.hud.storyText.text = "Oh no, the family fortune is gone. I better try again.";
						
						voiceChannel.stop();
						voiceChannel = new Level8Voice7().play();
					}
					
					else if (loopCount == 0)
					{
						Engine.hud.storyTextBoxNoSkip.visible = false;
						Engine.hud.storyText.visible = false;
						Engine.hud.failScreen.visible = true;
					}
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