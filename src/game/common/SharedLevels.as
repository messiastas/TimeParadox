package game.common 
{
	import game.common.interfaces.ILevel;
	/**
	 * ...
	 * @author messia_s
	 */
	public class SharedLevels implements ILevel
	{
		private static var instance:SharedLevels;
		private var humansInLevel1:Array = [ { "humanName":"Mark", "Health":100, "newX":50, "newY":50, "newAngle":0, "targetType":"type_human", "targetName":"Jack", "targetAction": "action_goto","speed":5},
		{"humanName":"Jack", "Health":100, "newX":250, "newY":250, "newAngle":90, "targetType":"type_human", "targetName":"Tony", "targetAction": "action_kill","speed":6,"weapon":"WPistol" },
		{ "humanName":"Tony", "Health":100, "newX":600, "newY":500, "newAngle":0, "targetType":"type_human", "targetName":"Mark", "targetAction": "action_goto","speed":4 },
		{ "humanName":"Rita", "Health":100, "newX":50, "newY":400, "newAngle":0, "targetType":"type_human", "targetName":"Jack", "targetAction": "action_kill","speed":8,"weapon":"WKnife"}]
		
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
			
			//for (var i:int = 0; i < 350; i++)
			//{
			//	humansArray.push({ "humanName":"human"+String(i), "Health":100, "newX":Math.random()*800, "newY":Math.random()*600, "newAngle":0, "targetType":"type_human", "targetName":humansArray[int(Math.random()*humansArray.length-2)+1]["humanName"], "targetAction": "action_kill", "speed":int(Math.random()*5+4),"weapon":"WPistol"})
			//}
			return humansArray;
		}
		
		public static function getInstance():SharedLevels {
			if(SharedLevels.instance == null){
				SharedLevels.instance = new SharedLevels();
			}
			return SharedLevels.instance;
		}
		
	}

}