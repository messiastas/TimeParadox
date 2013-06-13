package game.common 
{
	//import starling.display.Sprite;
	//import starling.display.Stage;
	//import starling.events.Event;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class Game extends Sprite 
	{
		public static var mStage:Stage;
		public function Game() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
		   
		}
		
		public function startGame():void {
			GameFacade.getInstance().startup(mStage as Stage);
		}
		
	}

}