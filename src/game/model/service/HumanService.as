package game.model.service 
{
	import flash.geom.Point;
	import game.common.interfaces.IGameService;
	import game.common.interfaces.IHuman;
	import game.common.interfaces.ILevelDesign;
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
		private var stackOfWaypoints:Array = new Array;
		
		private var needToStop:Boolean = false;
		
		
		
		
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
			if (!needToStop)
			{
				if (wayPoint)//TODO normal if
				{
					//if (GameFacade.getInstance().iteration % 10 == 0)
						//changeAngle(calculateAngleToPoint(wayPoint));
					if (!checkAction())
					{
						
						currentPoint.x += Math.sin(currentAngle / 57.296) * currentSpeed;
						currentPoint.y -= Math.cos(currentAngle / 57.296) * currentSpeed;
						sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": currentPoint.x, "newY": currentPoint.y } );
					}
					
					
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
					else
						checkWayPoint();
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
					} else 
					{
						checkWayPoint();
					}
					break;
			}
			return false;
		}
		
		private function checkWayPoint():void 
		{
			if (Utils.calculateDistance(wayPoint, currentPoint) < currentSpeed )
			{
				goToNextWayPoint();
			}
		}
		
		private function goToNextWayPoint():void 
		{
			if (stackOfWaypoints.length>0)
			{
				
					wayPoint = stackOfWaypoints[0];
					changeAngle(calculateAngleToPoint(wayPoint));
					stackOfWaypoints.shift();
			} else 
			{
				wayPoint = null;
				if (Utils.calculateDistance(currentTarget.getCurrentPoint(), getCurrentPoint()) > SharedConst.MAP_STEP*2 && !needToStop)
				{
					//trace(Utils.calculateDistance(currentTarget.getCurrentPoint(), stackOfWaypoints[stackOfWaypoints.length - 1] as Point))
					stackOfWaypoints = new Array();
					//wayPoint = null;
					searchPathTo(getCurrentPoint(), currentTarget.getCurrentPoint(), (GameFacade.getInstance().retrieveProxy(SharedConst.MAP_SERVICE) as ILevelDesign).getMapArray(), stackOfWaypoints);
					goToNextWayPoint()
				}
			}
		}
		public function newTarget(obj:IWorldObject,act:String):void
		{
			currentTarget = obj;
			targetAction = act;
			trace("Target for ", getName(), ": ", currentTarget.getName());
			stackOfWaypoints = new Array();
			searchPathTo(getCurrentPoint(),currentTarget.getCurrentPoint(), (GameFacade.getInstance().retrieveProxy(SharedConst.MAP_SERVICE) as ILevelDesign).getMapArray(), stackOfWaypoints);
			
			goToNextWayPoint()
			//wayPoint = currentTarget.getCurrentPoint();
			//changeAngle(calculateAngleToPoint(wayPoint));
			
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
		
		
		private  function searchPathTo(startPoint:Point, targetPoint:Point, map:Array, wayPoints:Array):void
		{
			//needToStop = true;
			var costArray:Array = new Array(map.length);
			for (var i:int = 0; i < costArray.length; i++)
			{
				costArray[i] = new Array((map[0] as Array).length);
				for (var j:int = 0; j < (map[0] as Array).length; j++)
				{
					costArray[i][j] = {"distance":costArray.length,"cost":costArray.length*costArray.length,"comeFrom":new Point(-1,-1),"point":new Point(j,i)}
				}
			}
			var currentIndex:Point = new Point(int(startPoint.x / SharedConst.MAP_STEP), int(startPoint.y / SharedConst.MAP_STEP));
			var targetIndex:Point = new Point(int(targetPoint.x / SharedConst.MAP_STEP), int(targetPoint.y / SharedConst.MAP_STEP));
			
			var isFind:Boolean = false;
			
			costArray[currentIndex.y][currentIndex.x]["distance"] = Utils.calculateDistance(currentIndex, targetIndex);
			costArray[currentIndex.y][currentIndex.x]["cost"] = 0;
			costArray[currentIndex.y][currentIndex.x]["heuristic"] = costArray[currentIndex.y][currentIndex.x]["distance"] + costArray[currentIndex.y][currentIndex.x]["cost"];
			costArray[currentIndex.y][currentIndex.x]["comeFrom"] = new Point( -1, -1)
			costArray[currentIndex.y][currentIndex.x]["index"] = new Point(currentIndex.x, currentIndex.y)
			
			var openList:Array = new Array;
			var closedList:Array = new Array;
			openList.push(costArray[currentIndex.y][currentIndex.x]);
			
			
			while (!isFind && openList.length>0)
			{
				//trace(openList.length);
				openList.sortOn("heuristic", Array.NUMERIC);
				var destX:int = openList[0]["point"].x;
				var destY:int = openList[0]["point"].y;
				var summ:int = 0;
				summ += checkExcel(costArray, map, openList, destX, destY+1,targetIndex,openList[0]["index"],2)
				summ += checkExcel(costArray, map, openList, destX, destY-1,targetIndex,openList[0]["index"],2)
				summ += checkExcel(costArray, map, openList, destX+1, destY,targetIndex,openList[0]["index"],2)
				summ += checkExcel(costArray, map, openList, destX-1, destY,targetIndex,openList[0]["index"],2)
				summ += checkExcel(costArray, map, openList, destX+1, destY+1,targetIndex,openList[0]["index"],3)
				summ += checkExcel(costArray, map, openList, destX+1, destY-1,targetIndex,openList[0]["index"],3)
				summ += checkExcel(costArray, map, openList, destX-1, destY+1,targetIndex,openList[0]["index"],3)
				summ += checkExcel(costArray, map, openList, destX-1, destY-1,targetIndex,openList[0]["index"],3)
				openList.shift();
				//trace(humanName, summ);
				if (summ > 9)
				{
					isFind = true;
					
				} 
			}
			if (!isFind)
			{
				
			 trace("PATH WAS NOT FOUNED BY", humanName);
			 needToStop = true;
			} else 
			{
				trace("PATH WAS FOUNED BY", humanName)
				var currentWayPoint:Object = costArray[targetIndex.y][targetIndex.x];
				//trace (wayPoints)
				//stackOfWaypoints = new Array();
				//trace(currentWayPoint["comeFrom"])
				while (currentWayPoint["comeFrom"].x > -1)
				{
					
					wayPoints.unshift(new Point(currentWayPoint["index"].x*SharedConst.MAP_STEP + SharedConst.MAP_STEP/2,currentWayPoint["index"].y*SharedConst.MAP_STEP+ SharedConst.MAP_STEP/2))
					currentWayPoint = costArray[currentWayPoint["comeFrom"].y][currentWayPoint["comeFrom"].x]
				}
				//trace(humanName, "wayPoints",wayPoints);
				needToStop = false;
			}
			
		}
		
		private function checkExcel(costArray:Array,map:Array,openList:Array,destX:int,destY:int,targetIndex:Point,currentIndex:Point,costCoef:int):int
		{
			try
			{
				var checkedExcel:Object = costArray[destY][destX];//
				if (map[destY][destX]==0 && checkedExcel["cost"]>openList[0]["cost"]+costCoef) 
				{
					checkedExcel["distance"] = Utils.calculateDistance(new Point(destX,destY), targetIndex);
					checkedExcel["cost"] = openList[0]["cost"] + costCoef;
					checkedExcel["heuristic"] = checkedExcel["distance"] + checkedExcel["cost"];
					checkedExcel["comeFrom"] = new Point(currentIndex.x, currentIndex.y)
					checkedExcel["index"] = new Point(destX, destY)
					openList.push(checkedExcel);
					//trace(checkedExcel["index"]);
					if (checkedExcel["index"].x == targetIndex.x && checkedExcel["index"].y == targetIndex.y)
						return 10
					else
						return 1;
				} else 
				{
					return 0;
				}
			} catch (er:Error)
			{
				return 0;
			}
			return 0;
		}
	}

}