package
{
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	
	public class Level2 extends Level
	{ 	
		private var _terrain = new Array([[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[1]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[1]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[1]],
									 	 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[1]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[1],[0],[0],[0],[0] ,[0],[0],[0],[0],[1],[0],[0],[0],[0],[0],[1]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[1]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[0],[0],[10],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]],
										 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1] ,[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]])
		
		private var nodelist:Vector.<Node> = new Vector.<Node>();
								
		public function Level2(TrapList = null)
		{  
			Engine.gameTracker.beginLevel(2)
			
			Engine.hud.successScreen.visible = false;
		
			trace ('levelTwo');
			
			nodelist.push(new Node(0,400,[[1,0]]));
			nodelist.push(new Node(500,400,[[2,1]/*,[4,0]*/]));
			nodelist.push(new Node(650,400,[[3,0]]));
			nodelist.push(new Node(1250,400,[[]]));
			
			nodelist.push(new Node(500,450,[[5,0]]));
			nodelist.push(new Node(550,450,[[6,0]]));
			nodelist.push(new Node(620,450,[[2,4]]));
			
			super(_terrain,nodelist,360,TrapList,80);
			//createMap();
			
			Engine.hud.readyButton.visible = false;
			
			BGM = new garden();
			musicChannel = BGM.play();
			
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
				super.createTrap(450,390,tire);
				super.createTrap(160,394,rope);
				super.createTrap(850,378,Lawnmower);
				//super.createTrap(500,400,rake);
				super.createTrap(700,390,wateringCan);
				super.createTrap(120,345,oilCan);
			}
			
			door = addChild(new Door(50,400));
		}
		
		override public function loop():void
		{
			if (loopCount > 0)
				loopCount --;
				
			
			// setup
			if (levelState == 0)
			{
				if (tutProgress == 0 && loopCount == 0)
				{
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyTextBox.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "He has found another way in, i'll need to think of something. I'll use all the stuff in this part of the garden and stop him.";
					
					voiceChannel = new Level2Voice1().play();
					
					loopCount = 200;
					tutProgress = 1;
				}
				
				else if (tutProgress == 1 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
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
					if (tutProgress < 4)
					{
						Engine.gameTracker.endLevel()
						
						loopCount = 100;
						BGM = new Victory();
						musicChannel.stop();
						musicChannel = BGM.play();
						
						Engine.achievementManager.level2Complete = true;
						
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBox.gotoAndStop(2);
						Engine.hud.storyTextBox.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "Arghh, who left that there. I'll find another way in.";
						
						voiceChannel.stop();
						voiceChannel = new Level2Voice2().play();
						
						tutProgress = 4;
						
						//timer = new Timer(5000)
						//timer.addEventListener(TimerEvent.TIMER, levelSuccess);
						//timer.start();
					}
					
					else if (tutProgress == 5 && loopCount == 0)
					{
						Engine.hud.storyTextBox.visible = false;
						Engine.hud.storyText.visible = false;
						Engine.hud.successScreen.visible = true;
					}

					else if (tutProgress == 4 && loopCount == 0)
					{
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBox.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyTextBox.gotoAndStop(1);
						Engine.hud.storyText.text = "Ha, that should slow him down. Better make sure he doesn't get in anywhere else.";
						
						voiceChannel.stop();
						voiceChannel = new Level2Voice3().play();
						
						tutProgress = 5;
						loopCount = 100;
					}
				}
				
				else if (player.x >= actualWidth + 25)
				{					
					if (Engine.hud.failScreen.visible == false && !(Engine.hud.storyText.text == "I didn't manage to stop the burglar. Oh man my parent's are gonna be mad, I better try again."))
					{
						loopCount = 200;
						BGM = new Failure();
						musicChannel.stop();
						musicChannel = BGM.play();
														
						Engine.hud.healthText.visible = false;
						Engine.hud.healthBar.visible = false;
						Engine.hud.storyTextBox.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "I didn't manage to stop the burglar. Oh man my parent's are gonna be mad, I better try again.";
					
						voiceChannel.stop();
						voiceChannel = new Level0Voice9().play();
					
					}
					
					else if (loopCount == 0)
					{
						Engine.hud.storyTextBox.visible = false;
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