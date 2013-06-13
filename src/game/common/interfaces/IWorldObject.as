package game.common.interfaces 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public interface IWorldObject 
	{
		function getCurrentPoint():Point;
		function getType():String;
		function getName():String;
	}
	
}