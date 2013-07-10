package game.controller.command 
{
	import game.model.entity.*;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	 import game.common.interfaces.IHuman;
	 import game.common.interfaces.IWeapon;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class takeWeaponCommand extends SimpleCommand implements ICommand 
	{
		
		override public function execute(notification:INotification):void
		{
			var weapon:IWeapon;
			switch(notification.getBody()["weapon"])
			{
				case "":
					weapon = new WFeasts();
					break;
				case "WKnife":
					weapon = new WKnife();
					break;
				case "WPistol":
					weapon = new WPistol();
					break;
				default:
					weapon = new WFeasts();
					break;
			}
			(notification.getBody()["receiver"] as IHuman).setWeapon(weapon);
			
		}
		
	}

}