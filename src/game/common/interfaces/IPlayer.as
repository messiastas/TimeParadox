package game.common.interfaces 
{
	/**
	 * ...
	 * @author messia_s
	 */
	import flash.geom.Point;
	public interface IPlayer 
	{
		function makeMove(movingObject:Object):void;
		function doSomething(command:String):void;
		
		
	}

}