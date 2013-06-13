package game.controller.command 
{
	import game.common.interfaces.IGameService;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	 import game.common.interfaces.IHuman;
	 import game.common.GameFacade;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class newRandomTargetCommand extends SimpleCommand implements ICommand 
	{
		
		override public function execute(notification:INotification):void
		{
			(GameFacade.getInstance().retrieveProxy("GameService") as IGameService).setRandomTarget(notification.getBody()["sender"] as IHuman)
			
		}
		
	}

}