package game.model.entity 
{
	/**
	 * ...
	 * @author messia_s
	 */
	public class DataTarget extends Object 
	{
		public var targetType:String = "";
		public var targetName:String = "";
		public var targetAction:String = "";
		public function DataTarget(tName:String,tType:String,tAction:String):void 
		{
			targetName = tName;
			targetType = tType;
			targetAction = targetAction;
			
		}
		
	}

}