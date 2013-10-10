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
	import game.model.entity.weapons.*;
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
			currentFraction = playerStartData["fraction"];
			setHealth(playerStartData["Health"]);
			sendNotification(SharedConst.CMD_TAKE_WEAPON, { "receiver":this, "weapon":playerStartData["weapon"] } );
			if (playerStartData["poolTargets"])
			{
				for each(var dt:Object in playerStartData["poolTargets"])
				{
					poolOfTargets.push(new DataTarget(dt));
				}
			}
			
			sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": playerStartData["newX"], "newY": playerStartData["newY"] } );
			
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
					//if (GameFacade.getInstance().iteration % 30 == 0)
					//	changeAngle(calculateAngleToPoint(wayPoint));
					if (!checkAction())
					{
						
						currentPoint.x += Math.sin(currentAngle *0.0175) * currentSpeed;
						currentPoint.y -= Math.cos(currentAngle *0.0175) * currentSpeed;
						sendNotification(SharedConst.ACTION_MOVE_HUMAN + humanName, { "newX": currentPoint.x, "newY": currentPoint.y } );
					}
					
					
					
					
					
					
				} else 
				{
					if (waitIterations > 0)
					{
						waitIterations--;
					} else 
					{
						removeTargetFromPool();
						trace(humanName,"end waiting")
					}
				}
			}
		}
		
		private function checkAction():Boolean 
		{
			switch(targetAction)
			{
				case SharedConst.ACTION_GOTO:
					if (Utils.calculateDistance(currentTarget.getCurrentPoint(), currentPoint) < SharedConst.MAP_STEP*2)
					{
						removeTargetFromPool();
						trace(humanName,"arrived")
						
						return true;
					}
					else
						checkWayPoint();
					break;
				case SharedConst.ACTION_KILL:
					var d:Number = Utils.calculateDistance(currentTarget.getCurrentPoint(), currentPoint);
					if ( (d <= currentWeapon.getDistance() || d<SharedConst.MAP_STEP*2) )
					{
						
						if ((currentTarget as IHuman).getHealth() > 0)
						{
							
							//changeAngle(calculateAngleToPoint(currentTarget.getCurrentPoint()));
							currentWeapon.shot(this, currentTarget as IHuman);
						} else
						{
							removeTargetFromPool();
							
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
		
		private function removeTargetFromPool():void 
		{
			if (!cyclingTarget)
			{
				wayPoint = null;
				currentTarget = null;
				poolOfTargets.shift();
				getNextTargetFromPool();
			} else 
			{
				poolOfTargets.push(poolOfTargets[0]);
				wayPoint = null;
				currentTarget = null;
				poolOfTargets.shift();
				getNextTargetFromPool();
			}
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
				if (Utils.calculateDistance(currentTarget.getCurrentPoint(), lastTargetPoint) > SharedConst.MAP_STEP*5 && !needToStop)
				{
					wayPoint = null;
					stackOfWaypoints.length = 0;
					searchPathTo(getCurrentPoint(), currentTarget.getCurrentPoint(), (GameFacade.getInstance().retrieveProxy(SharedConst.MAP_SERVICE) as ILevelDesign).getMapArray(), stackOfWaypoints);
					goToNextWayPoint()
				} else 
				{
					
					wayPoint = stackOfWaypoints[0];
					changeAngle(calculateAngleToPoint(wayPoint));
					stackOfWaypoints.shift();
				}
			} else 
			{
				wayPoint = null;
				if (Utils.calculateDistance(currentTarget.getCurrentPoint(), getCurrentPoint()) > SharedConst.MAP_STEP*2 && !needToStop)
				{
					stackOfWaypoints.length = 0;
					searchPathTo(getCurrentPoint(), currentTarget.getCurrentPoint(), (GameFacade.getInstance().retrieveProxy(SharedConst.MAP_SERVICE) as ILevelDesign).getMapArray(), stackOfWaypoints);
					goToNextWayPoint()
				}
			}
		}
		public function newTarget(obj:IWorldObject,act:String):void
		{
			if (!needToStop)
			{
			currentTarget = obj;
			targetAction = act;
			stackOfWaypoints.length = 0;
			searchPathTo(getCurrentPoint(),currentTarget.getCurrentPoint(), (GameFacade.getInstance().retrieveProxy(SharedConst.MAP_SERVICE) as ILevelDesign).getMapArray(), stackOfWaypoints);
			
			goToNextWayPoint()
			}
			
		}
		
		public function getNextTargetFromPool():void
		{
			if (poolOfTargets.length > 0)
			{
					
				var targ:DataTarget = poolOfTargets[0] as DataTarget;
				switch (targ.targetType) {
					case SharedConst.TYPE_HUMAN:
						newTarget(GameFacade.getInstance().retrieveProxy(targ.targetName) as IWorldObject, targ.targetAction);
						if (targ.isCycling)
							cyclingTarget = true;
						else 
							cyclingTarget = false;
						break;
					case SharedConst.TYPE_WAYPOINT:
						//trace("TYPE_WAYPOINT", targ.waypoint)
						if (targ.isCycling)
							cyclingTarget = true;
						else 
							cyclingTarget = false;
						newTarget(targ.waypoint as IWorldObject, targ.targetAction);
						//trace("TYPE_WAYPOINT", targ.waypoint.getCurrentPoint())
						break;
					case SharedConst.TYPE_WAITING:
						//trace("TYPE_WAYPOINT", targ.waypoint)
						if (targ.isCycling)
							cyclingTarget = true;
						else 
							cyclingTarget = false;
						waitIterations = int(int(targ.targetAction) * 1000 / SharedConst.ACTION_TIME);
						//trace("TYPE_WAYPOINT", targ.waypoint.getCurrentPoint())
						break;
				}
				
			} else {
				trace(getName(), "is finished");
				sendNotification(SharedConst.CMD_HUMAN_DONE, { sender:getName() } );
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
				trace(humanName, "has listen the", obj["point"])
				if (SharedConst.FRACTIONS_PACIFIC.indexOf(getFraction())>-1)
				{
					//trace(humanName, "has listen the", obj["point"])
					
					var protector:IHuman = (GameFacade.getInstance().retrieveProxy(SharedConst.GAME_SERVICE) as IGameService).getNearestProtector( { name:getName(), fraction:getFraction(), point:getCurrentPoint() } );
					
					if (currentTarget.getName() != protector.getName())
					{
						trace(getName(), "must run to", protector.getName());
						var targ:DataTarget = new DataTarget({targetName:protector.getName(), targetType:SharedConst.TYPE_HUMAN, targetAction:SharedConst.ACTION_GOTO});
						pushTargetintoPool(targ);
					}
				} else if (SharedConst.FRACTIONS_ARMED.indexOf(getFraction())>-1 && getName() != obj["shooter"])
				{
					trace(getName(), "is ready to fight with",obj["shooter"])
					var shooter:IHuman = GameFacade.getInstance().retrieveProxy(obj["shooter"]) as IHuman;
					if (Utils.getFractionRelations(getFraction(), shooter.getFraction()) < SharedConst.FRACTION_AGRESSION_LIMIT && (currentTarget==null || (currentTarget.getName() != shooter.getName() )) )
					{
						trace("For ", getName(), "new target is ", shooter.getName());
						targ = new DataTarget({targetName:shooter.getName(), targetType:SharedConst.TYPE_HUMAN, targetAction:SharedConst.ACTION_KILL});
						pushTargetintoPool(targ);
					}
				}
			}
		}
		
		private function pushTargetintoPool(targ:DataTarget):void 
		{
			if (poolOfTargets.length > 0)
				{
					poolOfTargets.unshift(targ);
				} else 
				{
					poolOfTargets[0] = targ;
				}
				getNextTargetFromPool();
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
		
		
		private  function searchPathTo(startPoint:Point, targetPoint:Point, map:Array, wayPoints:Array):void
		{
			//needToStop = true;
			lastTargetPoint.x = targetPoint.x;
			lastTargetPoint.y = targetPoint.y;
			
			var costArray:Array = new Array(map.length);
			var costArrayLength:int = costArray.length;
			var costArrayLength2:int = costArrayLength * costArrayLength;
			var map0length:int = (map[0] as Array).length;
			var point11:Point = new Point( -1, -1);
			for (var i:int = 0; i < costArray.length; i++)
			{
				costArray[i] = new Array(map0length);
				for (var j:int = 0; j < map0length; j++)
				{
					costArray[i][j] = {"distance":costArrayLength,"cost":costArrayLength2,"comeFrom":point11,"point":new Point(j,i)}
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
			
			var openList:Array = [];
			var closedList:Array = [];
			openList.push(costArray[currentIndex.y][currentIndex.x]);
			
			var destX:int = 0;
			var destY:int = 0;
			var summ:int = 0;
			
			var checkE:Function = checkExcel;
			var openListIndex:Point;
			while (!isFind && openList.length>0)
			{
				openList.sortOn("heuristic", Array.NUMERIC);
				destX = openList[0]["point"].x;
				destY = openList[0]["point"].y;
				summ = 0;
				openListIndex = openList[0]["index"];
				summ += checkE(costArray[destY+1][destX], map[destY+1][destX], openList, destX, destY+1,targetIndex,openListIndex,2)
				summ += checkE(costArray[destY-1][destX], map[destY-1][destX], openList, destX, destY-1,targetIndex,openListIndex,2)
				summ += checkE(costArray[destY][destX+1], map[destY][destX+1], openList, destX+1, destY,targetIndex,openListIndex,2)
				summ += checkE(costArray[destY][destX-1], map[destY][destX-1], openList, destX-1, destY,targetIndex,openListIndex,2)
				summ += checkE(costArray[destY+1][destX+1], map[destY+1][destX+1], openList, destX+1, destY+1,targetIndex,openListIndex,3)
				summ += checkE(costArray[destY-1][destX+1], map[destY-1][destX+1], openList, destX+1, destY-1,targetIndex,openListIndex,3)
				summ += checkE(costArray[destY+1][destX-1], map[destY+1][destX-1], openList, destX-1, destY+1,targetIndex,openListIndex,3)
				summ += checkE(costArray[destY-1][destX-1], map[destY-1][destX-1], openList, destX-1, destY-1,targetIndex,openListIndex,3)
				openList.shift();
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
				
				var currentWayPoint:Object = costArray[targetIndex.y][targetIndex.x];
				
				while (currentWayPoint["comeFrom"].x > -1)
				{
					
					wayPoints.unshift(new Point(currentWayPoint["index"].x*SharedConst.MAP_STEP + SharedConst.MAP_STEP/2,currentWayPoint["index"].y*SharedConst.MAP_STEP+ SharedConst.MAP_STEP/2))
					currentWayPoint = costArray[currentWayPoint["comeFrom"].y][currentWayPoint["comeFrom"].x]
				}
				needToStop = false;
			}
			
		}
		
		private function checkExcel(checkedExcel:Object,map:int,openList:Array,destX:int,destY:int,targetIndex:Point,currentIndex:Point,costCoef:int):int
		{
			try
			{
				if (map==0 && checkedExcel["cost"]>openList[0]["cost"]+costCoef) 
				{
					checkedExcel["distance"] = Utils.calculateDistance(new Point(destX,destY), targetIndex);
					checkedExcel["cost"] = openList[0]["cost"] + costCoef;
					checkedExcel["heuristic"] = checkedExcel["distance"] + checkedExcel["cost"];
					checkedExcel["comeFrom"] = new Point(currentIndex.x, currentIndex.y)
					checkedExcel["index"] = new Point(destX, destY)
					openList.push(checkedExcel);
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
		
		public function getFraction():int 
		{
			return currentFraction;
		}
	}

}