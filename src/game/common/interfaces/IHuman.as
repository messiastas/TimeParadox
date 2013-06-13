package game.common.interfaces 
{
	/**
	 * ...
	 * @author messia_s
	 */
	import flash.geom.Point;
	public interface IHuman 
	{
		
		function changeAngle(angle:Number):void;
		function makeStep():void;
		function newTarget(obj:IWorldObject, act:String):void;
		function getWeapon():IWeapon;
		function setWeapon(weapon:IWeapon):void;
		function getHealth():Number;
		function setHealth(level:Number):void;
		function shootedBy(weapon:IWeapon):void;
		function getCurrentPoint():Point;
		function getName():String;
		function checkNoise(obj:Object):void;
		/*function getAgressive():Number;
		function setAgressive(level:Number):void;
		function getRelationWith(some:IHuman):Number;
		function setRelationWith(some:IHuman, level:Number):void;
		function getTargetAction():String;
		function setTargetAction(action:String):void;
		
		function getVisibleObjects():Object;
		function isVisibleObject(some:IWorldObject):Boolean;*/
		
	}

}