package game.model.entity 
{
	import flash.geom.Point;
	import game.common.interfaces.IWorldObject;
	import game.common.SharedConst;
	/**
	 * ...
	 * @author messia_s
	 */
	public class EmptyWorldObject extends Object implements IWorldObject
	{
		private var currentPoint:Point;
		private var currentName:String;
		public function EmptyWorldObject(tName:String,tPoint:Point):void 
		{
			currentName = tName;
			currentPoint = tPoint;
			
		}
		
		public function getCurrentPoint():Point 
		{
			return currentPoint;
		}
		public function getType():String
		{
			return SharedConst.TYPE_WAYPOINT;
		}
		public function getName():String
		{
			return currentName;
		}
		
	}

}