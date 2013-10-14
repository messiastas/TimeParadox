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
	 import game.common.interfaces.IPlayer;
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
		
		//private var movingObject:Object = new Object;
		private var actionTimer:Timer = new Timer(SharedConst.ACTION_TIME);
		private var keyHeroes:Array = [];
		public static var iteration:Number = 0;
		
		private var humans:Array;
		private var playerData:Object;
		private var movingObject:Object = { up:0, down:0, left:0, right:0 };
		private var isPlayerMove:Boolean = false;
		
		public function GameService(pname:String,data:Object = null ):void 
		{
			proxyName = pname;//SharedConst.GAME_SERVICE;
			GameFacade.getInstance().registerProxy(this);
			init();
		}
		
		public function init():void {
			//proxyName = SharedConst.GAME_SERVICE;
			GameFacade.getInstance().mainStage.focus = GameFacade.getInstance().mainStage;
			actionTimer.addEventListener(TimerEvent.TIMER, onActionTimer);
			createMap();
			createHumans();
			setStartTargets();
			setPlayer();
			startLevel();
			
		}
		
		private function createHumans():void 
		{
			humans = SharedLevels.getInstance().getHumans(SharedConst.CURRENT_LEVEL);
			for each(var h:Object in humans)
			{
				
				
				sendNotification(SharedConst.CMD_CREATE_HUMAN, h);
				if (h.hasOwnProperty("keyHero") && h["keyHero"] == 1)
				{
					keyHeroes.push(h["humanName"]);
				}
			}
			trace(keyHeroes)
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
		
		private function setPlayer():void 
		{
			playerData = SharedLevels.getInstance().getPlayerData(SharedConst.CURRENT_LEVEL);
			sendNotification(SharedConst.CMD_CREATE_PLAYER, playerData);
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
			GameFacade.getInstance().mainStage.addEventListener(KeyboardEvent.KEY_UP,onKeyUnpressed);
		}
		
		private function onKeyPush(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 32:
					if (actionTimer.running)
					{
						trace(System.privateMemory, System.totalMemory, System.processCPUUsage);
						actionTimer.stop();
					}
					else 
						actionTimer.start();
					break;
					
				case 38:
					//Up
					movingObject["up"] = 1;
					isPlayerMove = true;
					break;
				case 40:
					//Down
					movingObject["down"] = 1;
					isPlayerMove = true;
					break;
				case 37:
					//Left
					movingObject["left"] = 1;
					isPlayerMove = true;
					break;
				case 39:
					//Right
					movingObject["right"] = 1;
					isPlayerMove = true;
					break;
				case 87:
					//Up
					movingObject["up"] = 1;
					isPlayerMove = true;
					break;
				case 83:
					//Down
					movingObject["down"] = 1;
					isPlayerMove = true;
					break;
				case 65:
					//Left
					movingObject["left"] = 1;
					isPlayerMove = true;
					break;
				case 68:
					//Right
					movingObject["right"] = 1;
					isPlayerMove = true;
					break;
			}
		}
		
		private function onKeyUnpressed(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case 38:
					//Up
					movingObject["up"] = 0;
					checkMoveEnd();
					break;
				case 40:
					//Down
					movingObject["down"] = 0;
					checkMoveEnd();
					break;
				case 37:
					//Left
					movingObject["left"] = 0;
					checkMoveEnd();
					break;
				case 39:
					//Right
					movingObject["right"] = 0;
					checkMoveEnd();
					break;
				case 87:
					//Up
					movingObject["up"] = 0;
					checkMoveEnd();
					break;
				case 83:
					//Down
					movingObject["down"] = 0;
					checkMoveEnd();
					break;
				case 65:
					//Left
					movingObject["left"] = 0;
					checkMoveEnd();
					break;
				case 68:
					//Right
					movingObject["right"] = 0;
					checkMoveEnd();
					break;
				case 69:
					//Speech
					(getHuman(SharedConst.PLAYER)as IPlayer).doSomething(SharedConst.ACTION_SAY_SOMETHING);
					break;
				
			}
			
		}
		
		private function checkMoveEnd():void
		{
			if (movingObject["up"] + movingObject["down"] + movingObject["left"] + movingObject["right"] == 0)
				isPlayerMove = false;
		}
		
		private function onActionTimer(e:TimerEvent):void 
		{
			iteration++;
			GameFacade.getInstance().iteration = iteration;
			//sendNotification(SharedConst.NEW_ITER, { "iteration":iteration } );
			if (isPlayerMove)
			{
				(getHuman(SharedConst.PLAYER) as IPlayer).makeMove(movingObject);
			}
			for each(var h:Object in humans)
			{
					getHuman(h["humanName"]).makeStep();
			}
		}
		
		public function getNearestProtector(data:Object):IHuman 
		{
			//trace("getNearestProtector action");
			var targetFraction:int = data.fraction;
			var protectorFraction:int
			for each (var armed:int in SharedConst.FRACTIONS_ARMED)
			{
				if (Utils.getFractionRelations(targetFraction, armed) > SharedConst.FRACTION_AGRESSION_LIMIT)
				{
					protectorFraction = armed;
					break;
				}
			}
			var currentDistance:int = 0;
			var protector:IHuman = null;
			for each (var h:Object in humans)
			{
				var currentHuman:IHuman = getHuman(h["humanName"]);
				
				if (currentHuman.getName() != data.name && currentHuman.getFraction()==protectorFraction)
				{
					var newDistance:Number = Utils.calculateDistance(data.point, currentHuman.getCurrentPoint())
					if (protector == null || ((newDistance < currentDistance) && (currentHuman.getHealth()>protector.getHealth())))
					{
						protector = currentHuman;
						currentDistance = newDistance;
					}
					
					//break;
				}
			}
			return protector;
		}
		
		public function humanDone(hName:String):void 
		{
			if (keyHeroes.indexOf(hName) > -1)
			{
				keyHeroes.splice(keyHeroes.indexOf(hName), 1)
				if (keyHeroes.length == 0)
				{
					trace("level cleared");
					actionTimer.stop();
					GameFacade.getInstance().mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPush);
				}
			}
			//humans.splice(humans.indexOf(hName), 1)
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