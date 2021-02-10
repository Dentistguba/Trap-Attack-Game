package
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	
	public class Level1 extends Level
	{ 	
		private var _terrain = new Array([[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
									 	 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[1],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]])
		
		private var nodelist:Vector.<Node> = new Vector.<Node>();
		
		private var tutMessage;
								
		public function Level1(TrapList = null)
		{  			
			Engine.gameTracker.beginLevel(1);
		
			nodelist.push(new Node(0,400,[[1,0]]),new Node(600,400,[]));
			
			super(_terrain,nodelist,360,TrapList,20,-20);
			//createMap();
			
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
			
			Engine.hud.readyButton.visible = false;
			
			if (TrapList == null)
			{
				super.createTrap(200,392,bucket);
				super.createTrap(300,392,rope);
			}
			
			door = addChild(new Gate(55,400));
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
					Engine.hud.storyTextBoxNoSkip.gotoAndStop(1);
					Engine.hud.storyTextBoxNoSkip.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "Now i've got a bucket and a rope, I wonder what happens if I drag the bucket onto the rope.";
					
					voiceChannel = new Level1Voice1().play();
					
					loopCount = 300;
					tutProgress = 1;
				}
				
				if (tutProgress == 1 && trapList[1].visible == false)
				{
					addChild(tutMessage = new tutMessage7())
					tutMessage.x = trapList[1].x;
					tutMessage.y = trapList[1].y - 50;
					tutProgress = 2;
				}
				
				if (tutProgress == 2 && trapList[1].visible == true && tutMessage != null)
				{
					removeChild(tutMessage)
					tutMessage = null;
					tutProgress = 1;
				}
					
				if ((tutProgress == 2 || tutProgress == 1) && trapList[0].hanging == true)
				{
					Engine.hud.storyText.text = "Cool, that looks like an interesting trap. I'll try putting it at the bottom of that branch.";
					
					voiceChannel.stop();
					voiceChannel = new Level1Voice2().play();
					
					addChild(tutMessage = new tutMessage5());
					tutMessage.x = 375;
					tutMessage.y = 280;
					
					loopCount = 100;
					tutProgress = 3;
				}
					
				if (tutProgress == 3 && dragging == false && trapList[0].y < 300)
				{
					Engine.hud.readyButton.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "Now i'm ready i should click the ready button.";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice8().play();
					
					removeChild(tutMessage);
					loopCount = 100;
					tutProgress = 4;
				}

				
				
				if (player == null)
				{
					if (playerY == 0)
						player = addChildAt(new AiPlayer(this,22,360,playerHealth),2);
						
					else
						player = addChildAt(new AiPlayer(this,22,playerY,playerHealth),2);
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
			
				//// screen mouse follow
//				var mousePos = new Point(stage.mouseX, stage.mouseY);
//				
//				if (mousePos.x > Engine.game.x + panStart && x + actualWidth > 250)
//					x -= panSpeed;
//						
//				else if (mousePos.x < Engine.game.x - panStart && x < -250)
//					x += panSpeed;
//						
//				if (mousePos.y > Engine.game.y + panStart && y + actualHeight > 200)
//					y -= panSpeed;
//				
//				else if (mousePos.y < Engine.game.y - panStart && y < -200)
//					y += panSpeed;
					
					
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
						Engine.gameTracker.endLevel()
						
						BGM = new Victory();
						musicChannel.stop();
						musicChannel = BGM.play();
						Engine.hud.successScreen.visible = true;
						Engine.achievementManager.level1Complete = true;
						
						//timer = new Timer(5000)
						//timer.addEventListener(TimerEvent.TIMER, levelSuccess);
						//timer.start();
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
											
						//Engine.hud.failScreen.visible = true;
					}
					
					if (loopCount == 0)
						Engine.game.restartLevel();
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
					if (tutProgress == 4)
					{
						Engine.hud.storyTextBoxNoSkip.visible = true;
						Engine.hud.storyText.visible = true;
						Engine.hud.storyText.text = "When the burglar is near the tree I can click on the trap to make it swing at him.";
						
						voiceChannel.stop();
						voiceChannel = new Level1Voice3().play();
						
						addChild(tutMessage = new tutMessage6())
						tutMessage.x = 375;
						tutMessage.y = 280;
						loopCount = 100;
						tutProgress = 5;
					}
					
					if (tutProgress == 5 && trapList[1].looping == true)
					{
						Engine.hud.storyTextBoxNoSkip.visible = false;
						Engine.hud.storyText.visible = false;
						removeChild(tutMessage);
						Engine.hud.storyText.visible = false;
						tutProgress = 6;
					}
					
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
						
					// screen mouse follow
					//var mousePos = new Point(stage.mouseX, stage.mouseY);
//				
//					if (mousePos.x > Engine.game.x + panStart && x + actualWidth > 250)
//						x -= panSpeed;
//						
//					else if (mousePos.x < Engine.game.x - panStart && x < -250)
//						x += panSpeed;
//						
//					if (mousePos.y > Engine.game.y + panStart && y + actualHeight > 200)
//						y -= panSpeed;
//				
//					else if (mousePos.y < Engine.game.y - panStart && y < -200)
//						y += panSpeed;
					
					
				}
				
				
			}
			
			proximityTree.refresh();
		}
	}
}