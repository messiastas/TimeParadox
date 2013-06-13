package game.controller.command 
{
	import game.model.service.HumanService;
	import game.view.mediators.HumanMediator;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.INotification;
	
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class createHumanCommand extends SimpleCommand implements ICommand 
	{
		
		
		override public function execute(notification:INotification):void
		{
			
			facade.registerMediator(new HumanMediator(notification.getBody()["humanName"]));
			facade.registerProxy(new HumanService(notification.getBody()));
			
		}
		
	}

}