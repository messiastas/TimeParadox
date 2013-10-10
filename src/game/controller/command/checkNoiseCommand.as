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
	public class checkNoiseCommand extends SimpleCommand implements ICommand 
	{
		
		override public function execute(notification:INotification):void
		{
			try 
			{
			(GameFacade.getInstance().retrieveProxy(notification.getBody().hName) as IHuman).checkNoise(notification.getBody().body);
			} catch (er:Error)
			{
				trace(notification.getBody().hName, "is not NPC");
			}
		}
		
	}

}