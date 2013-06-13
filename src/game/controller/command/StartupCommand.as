package game.controller.command 
{
	import game.view.mediators.PlayerMediator;
	import game.view.components.MenuView
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import game.common.GameFacade;
	import game.model.service.GameService;
	import game.model.service.GameService;
	import org.puremvc.as3.interfaces.INotification;
	import game.common.SharedConst;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class StartupCommand extends SimpleCommand implements ICommand
	{
		
		override public function execute(notification:INotification):void
		{
			facade.registerProxy(new GameService());
			//facade.registerMediator(new PlayerMediator(SharedConst.REAL_PLAYER));
			//facade.registerMediator(new PlayerMediator(SharedConst.EMOTIONAL_PLAYER));
			
		}
		
	}

}