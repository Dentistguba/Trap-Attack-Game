package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class Game extends MovieClip
	{
		private var levelList:Array = new Array(LevelEditor,Level0,Level0_2,Level1,Level0_3,Level2,Level3,Level5,Level4,Level6,Level7,Level8);
		public var currentLevel;
		private var currentLevelIndex:int;
		private var single:Boolean = false;
		
		public function Game(X,Y,Level,Single)
		{
			x = X;
			y = Y;
			
			//single = Single;
			currentLevelIndex = Level
			createLevel();
		}
		
		private function createLevel(trapList = null):void
		{
			currentLevel = addChild (new levelList[currentLevelIndex](trapList));
			//currentLevel.x = -250;
			//currentLevel.y = -250;
		}
		
		public function restartLevel(evt:MouseEvent = null)
		{
			trace ('level restarted')
			currentLevel.removeSelf();
			removeChild(currentLevel);
			currentLevel = null;
			createLevel();
			Engine.hud.failScreen.visible = false;
		}
		
		public function editLevel(evt:Event = null)
		{
			var trapList = currentLevel.editTrapList.concat();
			
			trace ('level edit-restarted')
			currentLevel.removeSelf();
			removeChild(currentLevel);
			currentLevel = null;
			createLevel(trapList);
			Engine.hud.failScreen.visible = false;
		}
		
		public function removeLevel():void
		{
			currentLevel.musicChannel.stop();
			trace ('level complete')
			currentLevel.removeSelf();
			removeChild(currentLevel);
			currentLevel = null;
			currentLevelIndex ++;
			
			if (currentLevelIndex < levelList.length && single == false)
				createLevel();
				
			else if (single == true)
			{
				Engine(root).changeScene(1,'Menu');
				Engine(root).removeChild(this);
			}
				
			else
			{
				Engine(root).changeScene(1,'Credits');
				Engine(root).removeChild(this);
				Engine.gameTracker.endGame();
			}
		}
		
		public function loop()
		{
			if (Engine.KeyArray[33][1] == true && z > -400 + 10)
			{
				scaleX -= 0.1;
				scaleY -= 0.1;
			}
			
			if (Engine.KeyArray[34][1] == true)
			{
				scaleX += 0.1;
				scaleY += 0.1;
			}
				
			if (currentLevel != null)
				currentLevel.loop();
		}
	}
}