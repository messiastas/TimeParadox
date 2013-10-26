package game.model.entity 
{
	import game.common.SharedConst;
	/**
	 * ...
	 * @author messia_s
	 */
	public class DataInformation extends Object 
	{
		public var infoType:String = SharedConst.INFO_CHAT;
		public var infoName:String = "";
		public var infoMessage:String = "Hey you! think i know you";
		public function DataInformation(targetObject:Object=null):void 
		{
			if (targetObject)
			{
				
				infoName = targetObject.infoName;
				infoType = targetObject.infoType;
				infoMessage = targetObject.infoMessage;
			}
			
			
		}
		
	}

}