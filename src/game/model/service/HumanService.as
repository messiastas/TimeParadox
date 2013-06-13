package game.model.service 
{
	import flash.geom.Point;
	import game.common.interfaces.IGameService;
	import game.common.interfaces.IHuman;
	import game.common.interfaces.IWeapon;
	import game.common.interfaces.IWorldObject;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import game.common.Utils;
	import game.common.SharedConst;
	import game.common.GameFacade;
	import game.model.entity.*;
	import game.model.entity.WPistol;
	import flash.utils.getDefinitionByName;
	import flash.system.ApplicationDomain;
	import game.model.entity.DataTarget;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class HumanService extends Proxy implements IProxy, IWorldObject, IHuman 
	{
		private var humanName:String = "John Smith";
		private var playerStartData:Object;
		private var currentTarget:IWorldObject;
		private var targetAction:String = "";
		private var currentPoint:Point;
		private var currentAngle:Number = 0;
		private var currentSpeed:Number = 5;
		private var wayPoint:Point;
		private var currentType:String = SharedConst.TYPE_HUMAN;
		
		private var poolOfTargets:Vector.<DataTarget> = new Vector.<DataTarget>;
		
		private var currentWeapon:IWeapon;
		private var currentHealth:Number;
		
		private var stackOfTargets:Array;
		private var stackOfWaypoints:Array;
		public function HumanService(data:Object):void
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
			currentHealth = playerStartData["Health"];
			sendNotification(SharedConst.CMD_TAKE_WEAPON, { "receiver":this, "weapon":playerStartData["weapon"] } );
			if (playerStartData["poolTargets"])
			{
				poolOfTargets = playerStartData["poolTargets"];
			}
			
			sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": playerStartData["newX"], "newY": playerStartData["newY"] } );
			getNextTargetFromPool();
		}
		
		public function changeAngle(angle:Number):void
		{
			currentAngle = angle;
			sendNotification(SharedConst.ACTION_CHANGE_ANGLE + humanName, {"newAngle":currentAngle});
		}
		public function makeStep():void
		{
			if (wayPoint)//TODO normal if
			{
				if (GameFacade.getInstance().iteration % 10 == 0)
					changeAngle(calculateAngleToPoint(wayPoint));
				if (!checkAction())
				{
					
					currentPoint.x += Math.sin(currentAngle / 57.296) * currentSpeed;
					currentPoint.y -= Math.cos(currentAngle / 57.296) * currentSpeed;
					sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": currentPoint.x, "newY": currentPoint.y } );
				}
				
				
			}
		}
		
		private function checkAction():Boolean 
		{
			switch(targetAction)
			{
				case SharedConst.ACTION_GOTO:
					if (Utils.calculateDistance(currentTarget.getCurrentPoint(), currentPoint) < currentSpeed)
						wayPoint = null;
					break;
				case SharedConst.ACTION_KILL:
					var d:Number = Utils.calculateDistance(currentTarget.getCurrentPoint(), currentPoint);
					if ( (d <= currentWeapon.getDistance() || d<currentSpeed) )
					{
						if((currentTarget as IHuman).getHealth()>0)
							currentWeapon.shot(this, currentTarget as IHuman);
						else
						{
							currentTarget = null;
							sendNotification(SharedConst.CMD_NEW_RANDOM_TARGET, { "sender":this } );
						}
						return true;
					}
					break;
			}
			return false;
		}
		
		public function newTarget(obj:IWorldObject,act:String):void
		{
			currentTarget = obj;
			targetAction = act;
			//trace("Target for ", getName(), ": ", currentTarget.getName(), currentTarget.getCurrentPoint());
			
			wayPoint = currentTarget.getCurrentPoint();
			changeAngle(calculateAngleToPoint(wayPoint));
			
		}
		
		public function getNextTargetFromPool():void
		{
			if (poolOfTargets.length > 0)
			{
				var targ:DataTarget = poolOfTargets[0];
				var gs:IGameService = (GameFacade.getInstance().retrieveProxy(SharedConst.GAME_SERVICE) as IGameService)
				switch (targ.targetType) {
					case SharedConst.TYPE_HUMAN:
						newTarget(gs.getHuman(targ.targetName) as IWorldObject, targ.targetAction);
						break;
				}
				poolOfTargets.shift();
			}
			
		}
		
		private function calculateAngleToPoint(point:Point):Number
		{
			var a:Number = 180*(-1)*Math.atan2(currentPoint.x-wayPoint.x,currentPoint.y-wayPoint.y)/Math.PI;
			return a;
		}
		
		
		
		
		public function shootedBy(weapon:IWeapon):void 
		{
			setHealth(getHealth() - weapon.getDamage());
			
		}
		
		public function checkNoise(obj:Object):void 
		{
			if (Utils.calculateDistance(currentPoint, obj["point"]) < obj["distance"])
			{
				//trace(humanName, "has listen the", obj["point"], "shot");
			}
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
			if (currentHealth <= 0)
			{
				trace(humanName, "died");
				currentTarget = null;
				wayPoint = null;
				sendNotification(SharedConst.ACTION_CHANGE_STATE + humanName, { "newState":"die"} );
			}
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
	}

}