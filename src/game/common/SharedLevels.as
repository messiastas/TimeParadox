package game.common 
{
	import flash.geom.Point;
	import game.common.interfaces.ILevel;
	import game.model.entity.EmptyWorldObject;
	/**
	 * ...
	 * @author messia_s
	 */
	public class SharedLevels implements ILevel
	{
		private static var instance:SharedLevels;
		private var humansInLevel1:Array = [ { "humanName":"Mark", "Health":100, "newX":50, "newY":50, "newAngle":0, 
												"poolTargets":[ { "targetType":"type_human", "targetName":"Tony", "targetAction": "action_goto" },
																{ "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint", new Point(600, 500)), "isCycling":true }, 
																{ "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint2", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint2", new Point(350, 100)), "isCycling":true } ],
												"speed":2,"fraction":SharedConst.FRACTION_CIVIL_POOR},
		
											{"humanName":"Jack", "Health":100, "newX":450, "newY":400, "newAngle":90, 
												"poolTargets":[ { "targetType":"type_human", "targetName":"Tony", "targetAction": "action_kill" },
																{ "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint2", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint2", new Point(350, 100)), "isCycling":false } ],
												"speed":3,"weapon":"WPistol","fraction":SharedConst.FRACTION_REBEL,"keyHero":1 },
		
											{ "humanName":"Tony", "Health":100, "newX":600, "newY":500, "newAngle":0, 
												"poolTargets":[ { "targetType":"type_human", "targetName":"Mark", "targetAction": "action_goto" }, 
																{ "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint", new Point(600, 500)), "isCycling":false }, 
																{ "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint2", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint2", new Point(350, 100)), "isCycling":false } ], 
												"speed":3, "fraction":SharedConst.FRACTION_CIVIL_RICH,"keyHero":1 },
		
											{ "humanName":"Rita", "Health":50, "newX":50, "newY":400, "newAngle":0, 
												"poolTargets":[ { "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint", new Point(300, 375)), "isCycling":true },
																{ "targetType":SharedConst.TYPE_WAITING, "targetName":"waypoint3", "targetAction":"2", "tPoint":new EmptyWorldObject("waypoint2", new Point(0, 0)), "isCycling":true }, 
																{ "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint2", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint2", new Point(60, 550)), "isCycling":true } ],
												"speed":3, "weapon":"WPistol", "fraction":SharedConst.FRACTION_POLICE },
			
			
											{ "humanName":"John", "Health":60, "newX":600, "newY":100, "newAngle":0, 
												"poolTargets":[ { "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint", new Point(700, 350)), "isCycling":true }, 
												{ "targetType":SharedConst.TYPE_WAITING, "targetName":"waypoint3", "targetAction":"1", "tPoint":new EmptyWorldObject("waypoint2", new Point(0, 0)), "isCycling":true }, { "targetType":SharedConst.TYPE_WAYPOINT, "targetName":"waypoint2", "targetAction":SharedConst.ACTION_GOTO, "tPoint":new EmptyWorldObject("waypoint2", new Point(400, 100)), "isCycling":true } ],
												"speed":3,"weapon":"WPistol","fraction":SharedConst.FRACTION_POLICE,"keyHero":0}]
											//{ "humanName":"Rita", "Health":100, "newX":50, "newY":400, "newAngle":0, "poolTargets":[{"targetType":"type_human", "targetName":"Jack", "targetAction": "action_kill"}],"speed":3,"weapon":"WKnife","fraction":SharedConst.FRACTION_POLICE}]
		private var playerDatainLevel1:Object = {humanName:SharedConst.PLAYER,newX:400,newY:300, "newAngle":0,Health:100,"speed":3,"fraction":SharedConst.FRACTION_SCIENTIST };
		public function SharedLevels() 
		{
			
		}
		
		public function getHumans(level:int):Array 
		{
			var humansArray:Array = new Array;
			
			for each (var h:Object in (this["humansInLevel" + level] as Array))
			{
				humansArray.push(h);
			}
			
			//for (var i:int = 0; i < 5; i++)
			//{
			//	humansArray.push({ "humanName":"human"+String(i), "Health":100, "newX":Math.random()*800, "newY":Math.random()*600, "newAngle":0, "targetType":"type_human", "targetName":humansArray[int(Math.random()*humansArray.length-2)+1]["humanName"], "targetAction": "action_kill", "speed":int(Math.random()*3+3),"weapon":"WFeasts"})
			//}
			return humansArray;
		}
		
		public function getPlayerData(level:int):Object
		{
			return this["playerDatainLevel" + level] as Object;
		}
		
		public static function getInstance():SharedLevels {
			if(SharedLevels.instance == null){
				SharedLevels.instance = new SharedLevels();
			}
			return SharedLevels.instance;
		}
		
	}

}