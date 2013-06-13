package game.common.interfaces 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author messia_s
	 */
	public interface IWeapon 
	{
		function getName():String;
		function getDamage():Number;
		function getDistance():Number;
		function getNoiseLevel():Number;
		function getMaxBullets():Number;
		function getCurrentBullets():Number;
		function shot(shooter:IHuman,victim:IHuman):void;
		
	}

}