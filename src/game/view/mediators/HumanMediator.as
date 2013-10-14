package game.view.mediators 
{
	import game.common.interfaces.IHuman;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import game.model.entity.GameParameters;
	import game.view.components.HumanView;
	import flash.geom.Point;
	import game.common.GameFacade;
	import game.common.SharedConst;
	import org.puremvc.as3.interfaces.INotification;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class HumanMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = 'PlayerMediator'; 
		private var humanName:String = "John Smith";
		
		private var interests:Array = new Array
		
		public function HumanMediator(Name:String):void
		{
			humanName = Name;	
			interests = [
				SharedConst.ACTION_MOVE_HUMAN + humanName,
				SharedConst.ACTION_CHANGE_ANGLE + humanName,
				SharedConst.ACTION_CHANGE_STATE + humanName,
				SharedConst.NOISE,
				SharedConst.ACTION_SAY_SOMETHING + humanName,
			];
			super( NAME + humanName, new HumanView(humanName) );
		}
		
		override public function listNotificationInterests() : Array 
		{
			return interests; 
		}
		
		override public function handleNotification( note : INotification ) : void  
		{
			//trace(note.getName());
			var obj:Object = note.getBody();
			switch ( note.getName() ) 
			{
				case SharedConst.ACTION_MOVE_HUMAN + humanName:
					human.setPosition(note.getBody()["newX"], note.getBody()["newY"]);
					break;
				case SharedConst.ACTION_CHANGE_ANGLE + humanName:
					human.setAngle(note.getBody()["newAngle"]);
					break;
				case SharedConst.ACTION_CHANGE_STATE + humanName:
					if (note.getBody()["newState"] == "die")
					{
						interests.splice(interests.indexOf(SharedConst.NOISE), 1);
						trace("*********************** removing interests for ", humanName);
					}
					human.setState(note.getBody())
					
					break;
				case SharedConst.NOISE:
					try {
						sendNotification(SharedConst.CMD_CHECK_NOISE, {hName:humanName, body:note.getBody() } );
						//(GameFacade.getInstance().retrieveProxy(humanName) as IHuman).checkNoise(note.getBody());
					} catch (er:Error) {
						//trace("no more ", humanName)
					}
					break;
				case SharedConst.ACTION_SAY_SOMETHING + humanName:
					
					human.saySomething(note.getBody().message,note.getBody().time)
					break;
			}
		}
		
		protected function get human() : HumanView {
			return viewComponent as HumanView;
		}
		
	}

}