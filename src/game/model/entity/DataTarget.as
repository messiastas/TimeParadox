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
		public var waypoint:IWorldObject;
		public function DataTarget(tName:String,tType:String,tAction:String,tPoint:IWorldObject = null):void 
		{
			targetName = tName;
			targetType = tType;
			targetAction = tAction;
			waypoint = tPoint;
		}
		
	}

}