package game.model.entity 
{
	import flash.geom.Point;
	import org.puremvc.as3.core.Model;
	import org.puremvc.as3.interfaces.IModel;
	import game.common.SharedConst;
	/**
	 * ...
	 * @author messia_s
	 */
	public class GameParameters extends Model implements IModel
	{
		private var _currentPlayer:String //= SharedConst.REAL_PLAYER;
		private var _playerSpeed:Number = 5;
		
		private var _realPlayerPoint:Point = new Point(0, 0);
		private var _emotionalPlayerPoint:Point = new Point(0, 0);
		
		private var _realPlayerAngle:Number = 0;
		private var _emotionalPlayerAngle:Number = 0;
		
		public function GameParameters() 
		{
			
		}
		
		public function get currentPlayer():String 
		{
			return _currentPlayer;
		}
		
		public function set currentPlayer(s:String): void 
		{
			 _currentPlayer = s;
		}
		
		public function get playerSpeed():Number 
		{
			return _playerSpeed;
		}
		
		public function set playerSpeed(s:Number): void 
		{
			 _playerSpeed = s;
		}
		
		public function get realPlayerPoint():Point 
		{
			return _realPlayerPoint;
		}
		
		public function set realPlayerPoint(s:Point): void 
		{
			 _realPlayerPoint = s;
		}
		
		public function get emotionalPlayerPoint():Point 
		{
			return _emotionalPlayerPoint;
		}
		
		public function set emotionalPlayerPoint(s:Point): void 
		{
			 _emotionalPlayerPoint = s;
		}
		
		public function get realPlayerAngle():Number 
		{
			return _realPlayerAngle;
		}
		
		public function set realPlayerAngle(s:Number): void 
		{
			 _realPlayerAngle = s;
		}
		
		public function get emotionalPlayerAngle():Number 
		{
			return _emotionalPlayerAngle;
		}
		
		public function set emotionalPlayerAngle(s:Number): void 
		{
			 _emotionalPlayerAngle = s;
		}
		
	}

}