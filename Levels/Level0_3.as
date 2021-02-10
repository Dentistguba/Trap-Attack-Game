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
	
	public class Level0_3 extends Level
	{
		private var _terrain = new Array([[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
									 	 [[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[11],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0] ,[0],[0],[0],[0],[0],[0]],
										 [[1],[1],[1],[1],[1],[1],[1],[1] ,[1],[1],[1],[1],[1],[1],[1]])
		
		private var nodelist:Vector.<Node> = new Vector.<Node>();
		
		private var tutMessage;
								
		public function Level0_3(TrapList = null)
		{  			
			nodelist.push(new Node(0,400,[[1,0]]),new Node(755,400,[]));
			
			super(_terrain,nodelist,360,TrapList,40,-20);
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
				super.createTrap(200,392,bucket);
				super.createTrap(300,392,rake);
				super.createTrap(400,392,rope);
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
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyTextBox.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "This time i've got all three objects I have found so far.";
					
					voiceChannel = new Level03Voice1().play();
					
					loopCount = 300;
					tutProgress = 1;
				}
					
				if (tutProgress == 1 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyText.text = "This area is a bit small for all these traps, I should spread them out more.";
					
					voiceChannel.stop();
					voiceChannel = new Level03Voice2().play();
					
					loopCount = 100;
					tutProgress = 2;
				}
				
				if (tutProgress == 2 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyTextBox.visible = false;
					Engine.hud.storyTextBoxNoSkip.gotoAndStop(1);
					Engine.hud.storyTextBoxNoSkip.visible = true;
					Engine.hud.storyText.visible = true;
					Engine.hud.storyText.text = "I can scroll to see the rest of this part of the garden if I move the mouse to the right of the screen.";
					
					voiceChannel.stop();
					voiceChannel = new Level03Voice3().play();
					
					addChild(tutMessage = new tutMessage8());
					tutMessage.x = 375;
					tutMessage.y = 280;
					loopCount = 100;
					tutProgress = 3;
				}
				
				if (tutProgress == 3)
				{
					var mousePos = new Point(stage.mouseX, stage.mouseY);
					
					if (mousePos.x > Engine.game.x + panStart && x + actualWidth > 250)
					{
						loopCount = 100;
						tutProgress = 4;
					}
				}
					
				if (tutProgress == 4 && loopCount == 0)
				{
					removeChild(tutMessage);
					Engine.hud.storyText.visible = false;
					Engine.hud.storyTextBox.visible = false;
					Engine.hud.storyTextBoxNoSkip.visible = false;
					tutProgress = 5;
					
					Engine.hud.readyButton.visible = true;
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
					if (Engine.hud.failScreen.visible == false && !(Engine.hud.storyText.text == "I didn't manage to stop the burglar. Oh man my parent's are gonna be mad, I better try again."))
					{
						loopCount = 200;
						BGM = new Failure();
						musicChannel.stop();
						musicChannel = BGM.play();
						
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
	}
}