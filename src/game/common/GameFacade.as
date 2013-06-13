package game.common 
{
	
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.interfaces.IFacade;
	import flash.display.Stage;
	//import starling.display.Stage;
	import game.model.entity.GameParameters;
	import game.controller.command.*;

	
	/**
	 * ...
	 * @author Stas.Shostak
	 */
	
	public class GameFacade extends Facade implements IFacade 
	{
		public static const NAME:String = 'Game';
		
		public static const CMD_STARTUP:String = NAME + 'StartUp';
		
		
		private static var _instance:GameFacade = new GameFacade();
		
		private var _gameParameters:GameParameters = new GameParameters();
		private static var _mainStage:Stage;
		
		private static var _iteration:Number = 0;
		
		public function GameFacade() 
		{
			if (_instance != null) throw new Error("GameFacade is obviously also... Singleton.");
			init();
		}
		
		public function init():void 
        {
			registerCommand(CMD_STARTUP, StartupCommand);
			registerCommand(SharedConst.CMD_CREATE_HUMAN, createHumanCommand);
			registerCommand(SharedConst.CMD_CREATE_MAP, createMapCommand);
			registerCommand(SharedConst.CMD_TAKE_WEAPON, takeWeaponCommand);
			registerCommand(SharedConst.CMD_NEW_RANDOM_TARGET, newRandomTargetCommand);
		}
		
		public function startup(newStage:Stage):void 
		{
			mainStage = newStage;
			sendNotification(CMD_STARTUP,mainStage);
		}
		
		
		
		public static function getInstance():GameFacade 
        {
            if (_instance == null ) _instance = new GameFacade();
            return _instance as GameFacade;
        }
		
		public function get gameParameters():GameParameters 
		{
			return _gameParameters;
		}
		
		public function set gameParameters(value:GameParameters):void 
		{
			_gameParameters = value;
		}
		
		public function get mainStage():Stage 
		{
			return _mainStage;
		}
		
		public function set mainStage(value:Stage):void 
		{
			_mainStage = value;
		}
		
		public function get iteration():Number 
		{
			return _iteration;
		}
		
		public function set iteration(value:Number):void 
		{
			_iteration = value;
		}
	}
}