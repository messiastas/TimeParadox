package game.model.service 
{
	/**
	 * ...
	 * @author messia_s
	 */
	
	 
	 import flash.events.Event;
	 import flash.events.KeyboardEvent;
	 import flash.events.TimerEvent;
	 import flash.media.Sound;
	 import flash.utils.Timer;
	 import game.common.interfaces.IHuman;
	  import game.common.interfaces.IGameService;
	 import game.common.interfaces.IWorldObject;
	 import game.model.entity.GameParameters;
	import game.common.GameFacade;
	import game.common.SharedConst;
	import game.common.SharedLevels;
	import game.common.Utils;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import flash.net.URLRequest;
	import game.common.SoundPlayer;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.system.System;
	
	
	public class GameService extends Proxy implements IProxy,IGameService
	{
		
		
		
		private var currentStep:int = 0;
		
		private var movingObject:Object = new Object;
		private var actionTimer:Timer = new Timer(SharedConst.ACTION_TIME);
		public static var iteration:Number = 0;
		
		private var humans:Array;
		
		public function GameService() 
		{
			proxyName = SharedConst.GAME_SERVICE;
			init();
		}
		
		public function init():void {
			GameFacade.getInstance().mainStage.focus = GameFacade.getInstance().mainStage;
			actionTimer.addEventListener(TimerEvent.TIMER, onActionTimer);
			createMap();
			createHumans();
			setStartTargets();
			startLevel();
			
		}
		
		private function createHumans():void 
		{
			humans = SharedLevels.getInstance().getHumans(SharedConst.CURRENT_LEVEL);
			for each(var h:Object in humans)
			{
				sendNotification(SharedConst.CMD_CREATE_HUMAN, h);
			}
		}
		
		private function createMap():void 
		{
			var mapData:Object = {};
			mapData["level"] = SharedConst.CURRENT_LEVEL;
			sendNotification(SharedConst.CMD_CREATE_MAP, mapData);
		}
		
		private function setStartTargets():void 
		{
			for each(var h:Object in humans)
			{
				//if (h["targetType"]==SharedConst.TYPE_HUMAN)
				//{
					//getHuman(h["humanName"]).newTarget(getHuman(h["targetName"]) as IWorldObject,h["targetAction"])
					trace("GameService ", h["humanName"]);
					getHuman(h["humanName"]).getNextTargetFromPool();
				//}
			}
		}
		
		public function setRandomTarget(forwho:IHuman):void 
		{
			for each(var h:Object in humans)
			{
				if (h["targetType"]==SharedConst.TYPE_HUMAN  && forwho.getName()!=h["humanName"])
				{
					if (getHuman(h["humanName"]).getHealth() <= 0)
					{
						
						//trace("removing ", h["humanName"]);
						humans.splice(humans.indexOf(h), 1);
						GameFacade.getInstance().removeMediator(h["humanName"]);
						GameFacade.getInstance().removeProxy(h["humanName"]);
					}
				}
			}
			
			forwho.newTarget(getHuman(humans[int(Math.random()*(humans.length-1))]["humanName"]) as IWorldObject, SharedConst.ACTION_KILL);
		
		}
		
		private function startLevel():void 
		{
			actionTimer.start();
			GameFacade.getInstance().mainStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPush);
		}
		
		private function onKeyPush(e:KeyboardEvent):void 
		{
			if (actionTimer.running)
			{
				trace(System.privateMemory, System.totalMemory, System.processCPUUsage);
				actionTimer.stop();
			}
			else 
				actionTimer.start();
		}
		
		private function onActionTimer(e:TimerEvent):void 
		{
			iteration++;
			GameFacade.getInstance().iteration = iteration;
			//sendNotification(SharedConst.NEW_ITER, { "iteration":iteration } );
			for each(var h:Object in humans)
			{
					getHuman(h["humanName"]).makeStep();
			}
		}
		
		
		
		
		
		public function getHuman(hName:String):IHuman
		{
			return GameFacade.getInstance().retrieveProxy(hName) as IHuman
		}
		private function copyObject ( objectToCopy:* ):*
		{
			var stream:ByteArray = new ByteArray();
			stream.writeObject( objectToCopy );
			stream.position = 0;
			return stream.readObject();
		}
		
		
		
	}

}