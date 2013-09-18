package game.model.entity 
{
	import game.common.interfaces.IWorldObject;
	/**
	 * ...
	 * @author messia_s
	 */
	public class DataTarget extends Object 
	{
		public var targetType:String = "";
		public var targetName:String = "";
		public var targetAction:String = "";
		public var waypoint:IWorldObject = null;
		public var isCycling:Boolean = false;
		public function DataTarget(targetObject:Object,tPoint:IWorldObject = null):void 
		{
			targetName = targetObject.targetName;
			targetType = targetObject.targetType;
			targetAction = targetObject.targetAction;
			if(targetObject.hasOwnProperty("isCycling"))
				isCycling = targetObject.isCycling;
			
			waypoint = tPoint;
			if (targetObject.hasOwnProperty("tPoint"))
				waypoint = targetObject.tPoint;
			
		}
		
	}

}