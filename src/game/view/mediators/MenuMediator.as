package fearless.view.mediators 
{
	import flash.events.Event;
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
	public class MenuMediator extends Mediator implements IMediator 
	{
		public static const NAME:String = 'MenuMediator'; 
		
		public function MenuMediator() 
		{
			super( NAME, new MenuView );
			menu.addEventListener(MenuView.START_CLICK, onMenuStartClick);
			//MusicAnalizerFacade.getInstance().mainStage.addChild(menu);
			//loginPanel.addEventListener( LoginPanel.TRY_LOGIN, onTryLogin );
		}
		
		override public function listNotificationInterests() : Array {
			return [
				SharedConst.SONG_ACTION,
				SharedConst.CMD_START_PLAY,
				SharedConst.SONG_LEFT_PEAK_HIGH,
				SharedConst.SONG_RIGHT_PEAK_HIGH,
				SharedConst.SONG_PEAK_HIGH,
				SharedConst.SONG_LEFT_PEAK_MEDIUM,
				SharedConst.SONG_RIGHT_PEAK_MEDIUM,
				SharedConst.SONG_PEAK_MEDIUM,
				SharedConst.SONG_LEFT_PEAK_LOW,
				SharedConst.SONG_RIGHT_PEAK_LOW,
				SharedConst.SONG_PEAK_LOW
			];
		}
		
		override public function handleNotification( note : INotification ) : void  {
			//trace(note.getName());
			switch ( note.getName() ) {
				case SharedConst.CMD_START_PLAY:
					menu.init();
					break;
				case SharedConst.SONG_ACTION:
					menu.action(note.getBody()["lines"]);
					break;
				case SharedConst.SONG_LEFT_PEAK_HIGH:
					
					menu.leftPeakHigh();
					break;
				case SharedConst.SONG_RIGHT_PEAK_HIGH:
					
					menu.rightPeakHigh();
					break;
				case SharedConst.SONG_PEAK_HIGH:
					
					menu.peakHigh();
					break;
				case SharedConst.SONG_LEFT_PEAK_MEDIUM:
					
					menu.leftPeakMedium();
					break;
				case SharedConst.SONG_RIGHT_PEAK_MEDIUM:
					
					menu.rightPeakMedium();
					break;
				case SharedConst.SONG_PEAK_MEDIUM:
					
					menu.peakMedium();
					break;
				case SharedConst.SONG_LEFT_PEAK_LOW:
					
					menu.leftPeakLow();
					break;
				case SharedConst.SONG_RIGHT_PEAK_LOW:
					
					menu.rightPeakLow();
					break;
				case SharedConst.SONG_PEAK_LOW:
					
					menu.peakLow();
					break;
				default:
					
					break;
			}
		}
		
		public function onMenuStartClick(e:Event):void {
			menu.startGame();
		}
		
		protected function get menu() : MenuView {
			return viewComponent as MenuView;
		}
		
	}

}