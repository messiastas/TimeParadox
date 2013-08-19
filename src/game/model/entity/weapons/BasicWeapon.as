package game.model.entity.weapons 
{
	/**
	 * ...
	 * @author messia_s
	 */
	
	 import flash.events.EventDispatcher;
	 import flash.geom.Point;
	 import flash.utils.Timer;
	 import game.common.interfaces.IHuman;
	 import game.common.Utils;
	 import game.common.interfaces.IWeapon;
	 import flash.utils.getQualifiedClassName;
	 import game.common.SharedConst;
	 import org.puremvc.as3.patterns.observer.Notifier;
	 
	public class BasicWeapon extends Notifier implements IWeapon 
	{
		protected var power:Number = 100;
		protected var distance:Number = 10;
		protected var noise:Number = 10;
		protected var maxBullets:int = 0;
		protected var currentBullets:int = 0;
		protected var reloadTime:int = 50;
		private var reloadTimer:Timer;
		
		public function BasicWeapon():void
		{
			//trace("create Weapon: ", getQualifiedClassName(this));
			reloadTimer = new Timer(reloadTime*SharedConst.ACTION_TIME,1);
		}
		
		public function getName():String
		{
			var a:Array = getQualifiedClassName(this).split(":W");
			return a[a.length-1];
		}
		public function getDamage():Number
		{
			return power;
		}
		public function getDistance():Number
		{
			return distance
		}
		public function getNoiseLevel():Number
		{
			return noise
		}
		public function getMaxBullets():Number
		{
			return maxBullets
		}
		public function getCurrentBullets():Number
		{
			return currentBullets
		}
		public function shot(shooter:IHuman,victim:IHuman):void
		{
			if (!reloadTimer.running)
			{
				currentBullets--;
				trace(shooter.getName()+" is shooting with " + getName() + " to " + victim.getName());
				victim.shootedBy(this);
				reloadTimer.start();
				sendNotification(SharedConst.NOISE_SHOT, { "point":shooter.getCurrentPoint(), "distance": distance});
			}
			
			
		}
	}

}