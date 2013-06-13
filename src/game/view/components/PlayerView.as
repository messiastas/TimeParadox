package game.view.components 
{
	//import starling.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import game.common.GameFacade
	import game.common.SharedConst;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//import starling.display.Quad;
	//import starling.display.Sprite;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class PlayerView extends EventDispatcher 
	{
		private var player:Sprite = new Sprite;
		private var body:MovieClip;
		private var playerType:String = "realPlayer";
		
		public function PlayerView(pType:String = "realPlayer") 
		{
			playerType = pType;
			trace(playerType);
			init();
		}
		
		public function init():void {
			
			GameFacade.getInstance().mainStage.addChild(player);
			
			switch(playerType)
			{
				case SharedConst.REAL_PLAYER:
					body = new RealPlayer();
					GameFacade.getInstance().gameParameters.realPlayerPoint = new Point(GameFacade.getInstance().mainStage.stageWidth / 2 + GameFacade.getInstance().mainStage.stageWidth / 4, GameFacade.getInstance().mainStage.stageHeight - 50);
					player.x = GameFacade.getInstance().gameParameters.realPlayerPoint.x;
					player.y = GameFacade.getInstance().gameParameters.realPlayerPoint.y;
					break;
				case SharedConst.EMOTIONAL_PLAYER:
					body = new EmotionalPlayer();
					GameFacade.getInstance().gameParameters.emotionalPlayerPoint = new Point(GameFacade.getInstance().mainStage.stageWidth / 4, GameFacade.getInstance().mainStage.stageHeight - 50);
					player.x = GameFacade.getInstance().gameParameters.emotionalPlayerPoint.x;
					player.y = GameFacade.getInstance().gameParameters.emotionalPlayerPoint.y;
					break;
			}
			player.addChild(body);
		}
		
		public function movePlayer(dX:Number, dY:Number):void 
		{
			player.x += dX;
			player.y += dY;
		}
		
		public function movePlayerToPoint(targetPoint:Point):void 
		{
			player.x = targetPoint.x;
			player.y = targetPoint.y;
		}
		
		public function setAngle(a:Number):void 
		{
			player.rotation = a;
		}
		
	}

}