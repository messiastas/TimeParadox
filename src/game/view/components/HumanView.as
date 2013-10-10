package game.view.components 
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import game.common.GameFacade
	import game.common.interfaces.IHuman;
	import game.common.SharedConst;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class HumanView extends EventDispatcher 
	{
		private var human:Sprite = new Sprite;
		private var body:MovieClip;
		private var humanName:String = "";
		private var infoPanel:InfoPanel = new InfoPanel;
		
		
		public function HumanView(hName:String) 
		{
			humanName = hName;
			init();
		}
		
		public function init():void {
			
			GameFacade.getInstance().mainStage.addChild(human);
			//var body:Rectangle = new Rectangle(0, 0, 20, 20);
			body = new HumanLive();
			human.addChild(body);
			human.addEventListener(MouseEvent.MOUSE_OVER, onOverHuman);
			infoPanel.nameText.text = humanName;
		}
		
		private function onOverHuman(e:MouseEvent):void 
		{
			human.removeEventListener(MouseEvent.MOUSE_OVER, onOverHuman);
			human.addEventListener(MouseEvent.MOUSE_OUT, onOutHuman);
			//var currentHuman:IHuman = GameFacade.getInstance().retrieveProxy(humanName) as IHuman;
			infoPanel.x = human.x;
			infoPanel.y = human.y - 10;
			GameFacade.getInstance().mainStage.addChild(infoPanel);
			//trace(currentHuman.getName(),currentHuman.getFraction(), currentHuman.getHealth(), currentHuman.getWeapon())
		}
		
		private function onOutHuman(e:MouseEvent):void 
		{
			GameFacade.getInstance().mainStage.removeChild(infoPanel);
			human.addEventListener(MouseEvent.MOUSE_OVER, onOverHuman);
			human.removeEventListener(MouseEvent.MOUSE_OUT, onOutHuman);
		}
		
		public function setPosition(newX:Number, newY:Number):void 
		{
			human.x = newX;
			human.y = newY;
		}
		
		public function setAngle( angle:Number):void 
		{
			body.rotation = angle;
		}
		
		public function setState(data:Object):void 
		{
			infoPanel.healthText.text = data.health;
			var state:String = data.newState
			switch (state)
			{
				case "die":
					var dx:Number = body.x;
					var dy:Number = body.y;
					var dangle:Number = body.rotation;
					human.removeChild(body);
					
					body = new HumanDead();
					human.addChild(body);
					body.x = dx;
					body.y = dy;
					body.rotation = dangle;
					GameFacade.getInstance().mainStage.addChildAt(human,0);
					break;
			}
			body.gotoAndStop(data.fraction+1)
		}
		
	}

}