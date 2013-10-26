package game.model.service 
{
	import flash.geom.Point;
	import game.common.interfaces.IGameService;
	import game.common.interfaces.IHuman;
	import game.common.interfaces.IPlayer;
	import game.common.interfaces.ILevelDesign;
	import game.common.interfaces.IWeapon;
	import game.common.interfaces.IWorldObject;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.observer.Observer;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import game.common.Utils;
	import game.common.SharedConst;
	import game.common.GameFacade;
	import game.model.entity.*;
	import game.model.entity.weapons.*;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;
	import game.model.entity.DataTarget;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class PlayerService extends Proxy implements IProxy, IWorldObject, IHuman, IPlayer 
	{
		private var humanName:String = SharedConst.PLAYER;
		private var playerStartData:Object;
		private var currentTarget:IWorldObject = null;
		private var targetAction:String = "";
		private var currentPoint:Point;
		private var currentAngle:Number = 0;
		private var currentSpeed:Number = 5;
		private var currentFraction:int = 0;
		private var wayPoint:Point;
		private var currentType:String = SharedConst.TYPE_HUMAN;
		private var lastTargetPoint:Point = new Point;
		
		private var poolOfTargets:Array = new Array;
		
		private var currentWeapon:IWeapon;
		private var currentHealth:Number;
		
		private var stackOfTargets:Array;
		private var stackOfWaypoints:Array = new Array;
		
		private var needToStop:Boolean = false;
		
		private var cyclingTarget:Boolean = false;
		private var waitIterations:int = 0;
		
		private var map:Array = new Array;
		
		
		
		
		public function PlayerService(data:Object):void
		{
			playerStartData = Utils.recursiveCopy(data);
			
			init();
			
		}
		
		private function init():void 
		{
			humanName = playerStartData["humanName"];
			proxyName = humanName;
			currentPoint = new Point(playerStartData["newX"], playerStartData["newY"])
			changeAngle(playerStartData["newAngle"]);
			currentSpeed = playerStartData["speed"];			
			currentFraction = playerStartData["fraction"];
			setHealth(playerStartData["Health"]);
			//sendNotification(SharedConst.CMD_TAKE_WEAPON, { "receiver":this, "weapon":playerStartData["weapon"] } );
			trace(proxyName);
			map = (GameFacade.getInstance().retrieveProxy(SharedConst.MAP_SERVICE) as ILevelDesign).getMapArray();
			sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": playerStartData["newX"], "newY": playerStartData["newY"] } );
			
		}
		
		public function makeMove(movingObject:Object):void
		{
			var angle:Number = 0;
				if (movingObject["up"] == 1)
				{
					if (movingObject["left"] == 1) angle = -45
					else if (movingObject["right"] == 1) angle = 45
					else angle = 0;
					
				} else if (movingObject["down"] == 1)
				{
					if (movingObject["left"] == 1) angle = -135
					else if (movingObject["right"] == 1) angle = 135
					else angle = 180;
				}
				
				if (angle == 0)
				{
					if (movingObject["left"] == 1)
					{
						angle = -90;
					} else if (movingObject["right"] == 1)
					{
						angle = 90;
					}
				}
				changeAngle(angle);
				var dx:Number = Math.sin(currentAngle * 0.0175) * currentSpeed;
				var dy:Number = Math.cos(currentAngle * 0.0175) * currentSpeed;
				
				if (map[int((currentPoint.y - dy) / SharedConst.MAP_STEP)][int((currentPoint.x + dx) / SharedConst.MAP_STEP)] == 0)
				{
					currentPoint.x += dx;
					currentPoint.y -= dy;
				}
				sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": currentPoint.x, "newY": currentPoint.y } );
		}
		
		public function changeAngle(angle:Number):void
		{
			currentAngle = angle;
			
			sendNotification(SharedConst.ACTION_CHANGE_ANGLE + humanName, {"newAngle":currentAngle});
		}
		
		public function doSomething(command:String):void 
		{
			switch (command)
			{
				case SharedConst.ACTION_SAY_SOMETHING:
					//TODO normal notification
					trace("PLAYER IS SPEAKING");
					sendNotification(SharedConst.ACTION_SAY_SOMETHING+getName(), { message:"someMEssage", time:SharedConst.SPEECH_TIME } );
					sendNotification(SharedConst.NOISE, {"type":SharedConst.NOISE_SPEECH, "point":getCurrentPoint(), "distance": SharedConst.SPEECH_DISTANCE, "speaker":getName(),"message":new DataInformation()});
					break;
			}
		}
		
		
		public function makeStep():void
		{
			
		}
		
		
	
		public function newTarget(obj:IWorldObject,act:String):void
		{
			
		}
		
		public function getNextTargetFromPool():void
		{
			
			
		}
		
		
		
		
		
		public function shootedBy(weapon:IWeapon):void 
		{
			setHealth(getHealth() - weapon.getDamage());
			
			
		}
		
		public function checkNoise(obj:Object):void 
		{
			
		}
		
		
		
		public function getWeapon():IWeapon
		{
			return currentWeapon;
		}
		public function setWeapon(weapon:IWeapon):void
		{
			currentWeapon = weapon;
		}
		public function getHealth():Number
		{
			return currentHealth;
		}
		public function setHealth(level:Number):void
		{
			currentHealth = level;
			//trace(getName() + "'s health: ", getHealth());
			var state:Object = {health:currentHealth,newState:"",fraction:getFraction()}
			if (currentHealth <= 0)
			{
				trace(humanName, "died");
				currentTarget = null;
				wayPoint = null;
				needToStop = true;
				state.newState = "die";
				sendNotification(SharedConst.CMD_HUMAN_DONE, { sender:getName() } );
			}
			sendNotification(SharedConst.ACTION_CHANGE_STATE + humanName, state );
		}
		
		public function getCurrentPoint():Point
		{
			return currentPoint;
		}
		public function getType():String
		{
			return currentType;
		}
		public function getName():String
		{
			return humanName;
		}
		
		
		
		
		public function getFraction():int 
		{
			return currentFraction;
		}
	}

}