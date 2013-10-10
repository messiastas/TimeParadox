package game.controller.command 
{
	import game.model.service.HumanService;
	import game.model.service.PlayerService;
	import game.view.mediators.HumanMediator;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	import game.common.GameFacade;
	
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class createPlayerCommand extends SimpleCommand implements ICommand 
	{
		
		
		override public function execute(notification:INotification):void
		{
			
			GameFacade.getInstance().registerMediator(new HumanMediator(notification.getBody()["humanName"]));
			GameFacade.getInstance().registerProxy(new PlayerService(notification.getBody()));
			
		}
		
	}

}