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
	
	public class Level0 extends Level
	{ 	
		private var _terrain = new Array([[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
									 	 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[0],[0],[0],[0],[0],[0],[0],[0],[0],[0]],
										 [[1],[1],[1],[1],[1],[1],[1],[1],[1],[1],[1]])
		
		private var nodelist:Vector.<Node> = new Vector.<Node>();
		
		private var hasDragged:Boolean = false;
		private var tutMessage;
								
		public function Level0(TrapList = null)
		{  			
			nodelist.push(new Node(0,400,[[1,0]]),new Node(600,400,[]));
			
			
			super(_terrain,nodelist,360,TrapList,24,-20);
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
				super.createTrap(200,392,rake);
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
				if (hasDragged == false && dragging == true)
				{
					//hasDragged = true;
				}
				
				if (hasDragged == true && dragging == false)
				{
					//Engine.hud.readyButton.visible = true;
				}
				
				if (tutProgress == 0 && loopCount == 0)
				{
					Engine.hud.storyText.visible = true;
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyText.text = " Oh man, can't believe I was grounded for stealing. ";
					
					voiceChannel = new Level0Voice1OhMan().play();
					
					loopCount = 300;
					tutProgress = 1;
				}
					
				if (tutProgress == 1 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(2);
					Engine.hud.storyText.text = "Grr, stupid fence";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice2Grr().play();
					
					loopCount = 100;
					tutProgress = 2;
				}
					
				else if (tutProgress == 2 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyText.text = "What was that?";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice3What().play();
					
					loopCount = 100;
					tutProgress = 3;
				}
					
				else if (tutProgress == 3 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(2);
					Engine.hud.storyText.text = "Gah! Who makes these stupid things anyway!?!";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice4Gah().play();
					
					loopCount = 100;
					tutProgress = 4;
				}
				
				else if (tutProgress == 4 && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBox.gotoAndStop(1);
					Engine.hud.storyText.text = "Oh wow! That guy’s a real life burglar! This’d be cool if he wasn’t after my stuff! Guess I’d better stop him getting into the house.  Maybe I could use some things in the garden to stop him...";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice5().play();
					
					loopCount = 300;
					tutProgress = 5;
				}
				
				
				else if (tutProgress == 5 && dragging == false && (loopCount == 0 || (Engine.mouse[1]==true && Engine.hud.storyTextBox.mouseX < Engine.hud.storyTextBox.width/2 && Engine.hud.storyTextBox.mouseY < Engine.hud.storyTextBox.height/2)))
				{
					Engine.hud.storyTextBoxNoSkip.visible = true;
					Engine.hud.storyTextBox.visible = false;
					Engine.hud.storyTextBoxNoSkip.gotoAndStop(1);
					
					Engine.hud.storyText.text = "I could click on that rake and put it in front of him to get in his way...";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice6().play();
					
					addChild(tutMessage = new tutMessage1());
					tutMessage.x = 200;
					tutMessage.y = 390;
					loopCount = 100;
					tutProgress = 6;
				}
				
				else if ((tutProgress == 6 || (tutProgress == 5 && loopCount == 0)) && (dragging == true || hasDragged == true))
				{
					Engine.hud.storyText.text = "When the rake is red it means I can't put it there, if it is green it means I can.";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice7().play();
					
					if (tutMessage != null)
					{
						removeChild(tutMessage);
						tutMessage = null;
					}
					
					loopCount = 100;
					tutProgress = 7;
				}
				
				else if (tutProgress == 7 && dragging == false)
				{
					Engine.hud.readyButton.visible = true;
					Engine.hud.storyText.text = "Right, now i'm ready I should click the ready button.";
					
					voiceChannel.stop();
					voiceChannel = new Level0Voice8().play();
					
					loopCount = 100;
					tutProgress = 8;
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
						BGM = new Victory();
						musicChannel.stop();
						musicChannel = BGM.play();
						Engine.hud.successScreen.visible = true;
						
						Engine.hud.successScreen.next.addEventListener(MouseEvent.MOUSE_DOWN,levelSuccess);
						
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