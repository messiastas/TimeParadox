package game.view.components 
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import game.common.GameFacade
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
		
		
		public function HumanView(hName:String) 
		{
			humanName = hName;
			init();
		}
		
		public function init():void {
			
			GameFacade.getInstance().mainStage.addChild(human);
			//var body:Rectangle = new Rectangle(0, 0, 20, 20);
			body = new RealPlayer();
			human.addChild(body);
		}
		
		public function setPosition(newX:Number, newY:Number):void 
		{
			body.x = newX;
			body.y = newY;
		}
		
		public function setAngle( angle:Number):void 
		{
			body.rotation = angle;
		}
		
		public function setState(state:String):void 
		{
			switch (state)
			{
				case "die":
					var dx:Number = body.x;
					var dy:Number = body.y;
					var dangle:Number = body.rotation;
					human.removeChild(body);
					
					body = new EmotionalPlayer();
					human.addChild(body);
					body.x = dx;
					body.y = dy;
					body.rotation = dangle;
					GameFacade.getInstance().mainStage.addChildAt(human,0);
					break;
			}
		}
		
	}

}