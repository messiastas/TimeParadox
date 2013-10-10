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
		
		public function PlayerView() 
		{
			init();
		}
		
		public function init():void {
			
			FearlessFacade.getInstance().mainStage.addChild(player);
			
			switch(playerType)
			{
				case SharedConst.REAL_PLAYER:
					body = new RealPlayer();
					FearlessFacade.getInstance().fearlessParameters.realPlayerPoint = new Point(FearlessFacade.getInstance().mainStage.stageWidth / 2 + FearlessFacade.getInstance().mainStage.stageWidth / 4, FearlessFacade.getInstance().mainStage.stageHeight - 50);
					player.x = FearlessFacade.getInstance().fearlessParameters.realPlayerPoint.x;
					player.y = FearlessFacade.getInstance().fearlessParameters.realPlayerPoint.y;
					break;
				case SharedConst.EMOTIONAL_PLAYER:
					body = new EmotionalPlayer();
					FearlessFacade.getInstance().fearlessParameters.emotionalPlayerPoint = new Point(FearlessFacade.getInstance().mainStage.stageWidth / 4, FearlessFacade.getInstance().mainStage.stageHeight - 50);
					player.x = FearlessFacade.getInstance().fearlessParameters.emotionalPlayerPoint.x;
					player.y = FearlessFacade.getInstance().fearlessParameters.emotionalPlayerPoint.y;
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