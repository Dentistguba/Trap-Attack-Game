package
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	public class Engine extends MovieClip
	{		
		public static var KeyArray:Array = new Array();
		public static var mouse:Array = new Array(false,false);
		private var Paused:Boolean = false;
		public static var game;
		public static var hud;
		public static var achievementManager:AchievementManager;
		public static var musicOff:Boolean = false;
		private var framerateTracker = null;
		private var framerateTrackerCountdown:int = 0;
		
		public static var gameTracker;
		
		public function Engine()
		{
			gameTracker = new GameTracker();
			
			achievementManager = new AchievementManager();
						
			for (var i:int = 0; i <  222; i++)				//puts all keys in KeyArray into default false state
			{
				KeyArray.push([i, false, false]);
			}				
						
			Pause();
						
			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKeysDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, checkKeysUp);
			//stage.addEventListener(Event.MOUSE_LEAVE, Pause);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseTrue);
			addEventListener(MouseEvent.MOUSE_UP, mouseFalse);

			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		private function mouseTrue(evt:Event):void
		{
			mouse[0] = true;
			mouse[1] = true;
		}
		
		private function mouseFalse(evt:Event):void
		{
			mouse[0] = false;
			mouse[1] = false;
		}
		
		private function checkKeysDown(evt:KeyboardEvent) // sets keys in "KeyArray" to true if down
		{			
			if (KeyArray[evt.keyCode][1] == false)
				KeyArray[evt.keyCode][2] = true;
			
			KeyArray[evt.keyCode][1] = true;
		}
			
		private function checkKeysUp(evt:KeyboardEvent)  // sets keys in "KeyArray" to false if up
		{
			KeyArray[evt.keyCode][1] = false;
		}	
	
		public function startGame(level,single):void
		{
			gameTracker.beginGame();
			
			hud = new HUD(stage.stageWidth/2, stage.stageHeight/2);

			game = addChild(new Game(stage.stageWidth / 2, stage.stageHeight / 2,level,single));
			
			addChild(hud);
			
			hud.failScreen.restart.addEventListener(MouseEvent.MOUSE_DOWN, game.restartLevel);
			hud.failScreen.edit.addEventListener(MouseEvent.MOUSE_DOWN, game.editLevel);
			hud.failScreen.mainMenu.addEventListener(MouseEvent.MOUSE_DOWN, endGame);
			hud.successScreen.mainMenu.addEventListener(MouseEvent.MOUSE_DOWN, endGame);
			Engine.hud.successScreen.next.addEventListener(MouseEvent.CLICK,game.currentLevel.levelSuccess);
			
			//framerateTracker = addChild (new FramerateTracker())
			//framerateTracker.x = 300
		}
		
		public function endGame(evt:MouseEvent = null)
		{
			if (game != null)
				removeChild(game);
			
			hud.failScreen.restart.removeEventListener(MouseEvent.MOUSE_DOWN, game.restartLevel);
			hud.failScreen.edit.removeEventListener(MouseEvent.MOUSE_DOWN, game.editLevel);
			hud.failScreen.mainMenu.removeEventListener(MouseEvent.MOUSE_DOWN, endGame);
			
			removeChild(hud);
			
			changeScene(1,'Menu');
		}
		
		public function changeScene(frame,scene):void
		{
			gotoAndStop(frame,scene);
		}
		
		private function Pause(evt:Event = void)
		{
			var sTransform:SoundTransform = new SoundTransform(1,0);
			sTransform.volume = 0;
			SoundMixer.soundTransform = sTransform;
			Paused = true;
			addEventListener(MouseEvent.MOUSE_OVER, unPause);
		}
		
		private function unPause(evt:Event = void)
		{
			var sTransform:SoundTransform = new SoundTransform(1,0);
			sTransform.volume = 1;
			SoundMixer.soundTransform = sTransform;
			Paused = false;
			removeEventListener(MouseEvent.MOUSE_OVER, unPause);
		}
		
		public function loop(evt:Event):void
		{			
			if (game != null && Paused == false)
				game.loop();
			
			for (var i:int = 0; i < KeyArray.length; i ++)
				KeyArray[i][2] = false;
				
			mouse[1] = false;
			
			if (framerateTracker != null)
			{
				if (framerateTrackerCountdown == 0)
				{
					framerateTracker.getFps();
					framerateTrackerCountdown == 2;
				}
					
				else
					framerateTrackerCountdown --;
			}
		}
	}
}