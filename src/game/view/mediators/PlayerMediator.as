package game.view.mediators 
{
	import fearless.model.entity.FearlessParameters;
	import fearless.view.components.PlayerView;
	import flash.geom.Point;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import fearless.common.FearlessFacade;
	import fearless.view.components.MenuView
	import fearless.common.SharedConst;
	import org.puremvc.as3.interfaces.INotification;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class PlayerMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = 'PlayerMediator'; 
		private var playerType:String = "realPlayer";
		private var fParams:FearlessParameters;
		
		
		public function PlayerMediator(type:String = "realPlayer") 
		{
			playerType = type;
			super( NAME + playerType, new PlayerView(playerType) );
			fParams = FearlessFacade.getInstance().fearlessParameters;
		}
		
		override public function listNotificationInterests() : Array 
		{
			return [
				SharedConst.PLAYERS_MOVING
			];
		}
		
		override public function handleNotification( note : INotification ) : void  
		{
			//trace(note.getName(),playerType);
			var obj:Object = note.getBody();
			switch ( note.getName() ) 
			{
				case SharedConst.PLAYERS_MOVING:
					var coef:int = 1;
					var angle:Number = 0;
					
					//if (obj["angle"]!=null && )
					//{
						if (fParams.currentPlayer != playerType)
						{
							coef = -1;
						}
						angle = obj["angle"] * coef;
						(fParams[playerType + "Point"] as Point).x += Math.sin(angle/57.29578)*fParams.playerSpeed;// dX * coef;
						(fParams[playerType + "Point"] as Point).y -= Math.cos(angle / 57.29578) * fParams.playerSpeed;
						fParams[playerType + "Angle"] = angle;
						//player.movePlayer(dX * coef, dY);
						player.movePlayerToPoint(fParams[playerType + "Point"] as Point);
						player.setAngle(fParams[playerType + "Angle"]);
					//}
						
					break;
			}
		}
		
		protected function get player() : PlayerView {
			return viewComponent as PlayerView;
		}
		
	}

}