package game.controller.command 
{
	import game.model.service.MapService;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import game.common.GameFacade;
	import org.puremvc.as3.interfaces.INotification;
	import game.common.SharedConst;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class createMapCommand extends SimpleCommand implements ICommand 
	{
		
		override public function execute(notification:INotification):void
		{
			
			//facade.registerMediator(new HumanMediator(notification.getBody()["humanName"]));
			GameFacade.getInstance().registerProxy(new MapService(SharedConst.MAP_SERVICE,notification.getBody()));
			
		}
		
	}

}