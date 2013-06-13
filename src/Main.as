package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import game.common.GameFacade;
	//import starling.core.Starling;
	import game.common.Game;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	 import flash.display.StageAlign;
 import flash.display.StageScaleMode;
 [SWF(width="1000",height="600",frameRate="60",backgroundColor="#000000")]
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class Main extends Sprite 
	{
		//private var mStarling:Starling;
		private var game:Game;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			game = new Game();
			Game.mStage = stage;
			game.startGame();
			//mStarling = new Starling(Game, stage);
			//mStarling.start();
		}
		
	}
	
}