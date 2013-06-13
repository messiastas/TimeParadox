package fearless.view.components 
{
	//import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.IView;
	import fearless.common.FearlessFacade
	import flash.events.MouseEvent;
	import fearless.common.SharedConst;
	import flash.display.Sprite;
	//import starling.display.Quad;
	//import starling.display.Sprite;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class MenuView extends EventDispatcher
	{
		private var menu:Sprite = new Sprite();
		public static const START_CLICK:String = "start_click";
		private var mins:Array = new Array;
		private var leftCircleHigh:Quad = new Quad(25, 25);
		private var rightCircleHigh:Quad = new Quad(25, 25);
		private var circleHigh:Quad = new Quad(25, 25);
		private var leftCircleMedium:Quad = new Quad(50, 50);
		private var rightCircleMedium:Quad = new Quad(50, 50);
		private var circleMedium:Quad = new Quad(50, 50);
		private var leftCircleLow:Quad = new Quad(100, 100);
		private var rightCircleLow:Quad = new Quad(100, 100);
		private var circleLow:Quad = new Quad(100, 100);
		private var visibleStepHigh:int = 0;
		private var visibleStepMedium:int = 0;
		private var visibleStepLow:int = 0;
		
		public function MenuView() 
		{
			
			
		}
		
		public function init(songAdress:String = ""):void {
			MusicAnalizerFacade.getInstance().mainStage.addChild(menu);
			trace(songAdress);
			//menu.getChildByName("bStart").addEventListener(MouseEvent.CLICK, onStartClick);
			
			/*for (var i:int = 0; i <256; i++) {
				var min:Quad = new Quad(1, 120);
					menu.addChild(min);
				mins.push(min);
				min.x=0+i*2;
				min.y=240;
				min.rotation = Math.PI;
			}
			for (i=256; i < 512; i++) {
				min = new Quad(1, 120);
					menu.addChild(min);
				mins.push(min);
				min.x=0+i*2;
				min.y=240;
				min.rotation = Math.PI;
			}*/
			
			menu.addChild(leftCircleHigh);
			leftCircleHigh.x = 50;
			leftCircleHigh.y = 250;
			
			menu.addChild(rightCircleHigh);
			rightCircleHigh.x = 875;
			rightCircleHigh.y = 250;
			
			menu.addChild(circleHigh);
			circleHigh.x = 450;
			circleHigh.y = 250;
			
			leftCircleHigh.visible = false;
			rightCircleHigh.visible = false;
			circleHigh.visible = false;
			
			menu.addChild(leftCircleMedium);
			leftCircleMedium.x = 50;
			leftCircleMedium.y = 300;
			
			menu.addChild(rightCircleMedium);
			rightCircleMedium.x = 875;
			rightCircleMedium.y = 300;
			
			menu.addChild(circleMedium);
			circleMedium.x = 450;
			circleMedium.y = 300;
			
			leftCircleMedium.visible = false;
			rightCircleMedium.visible = false;
			circleMedium.visible = false;
			
			menu.addChild(leftCircleLow);
			leftCircleLow.x = 50;
			leftCircleLow.y = 400;
			
			menu.addChild(rightCircleLow);
			rightCircleLow.x = 875;
			rightCircleLow.y = 400;
			
			menu.addChild(circleLow);
			circleLow.x = 450;
			circleLow.y = 400;
			
			leftCircleLow.visible = false;
			rightCircleLow.visible = false;
			circleLow.visible = false;
		}
		
		public function action(byteArray:ByteArray):void {
			/*for (var i:int = 0; i < 512; i++) {
				var n:Number = (byteArray.readFloat() * SharedConst.LINE_WIDTH);
				mins[i].height = n;
			}*/
			
			if(visibleStepHigh<8){
				visibleStepHigh++;
				leftCircleHigh.alpha -=.1;
				rightCircleHigh.alpha -=.1;
				circleHigh.alpha -=.1;
			} else if (visibleStepHigh == 8) {
				leftCircleHigh.visible = false;
				rightCircleHigh.visible = false;
				circleHigh.visible = false;
			}
			
			if(visibleStepMedium<8){
				visibleStepMedium++;
				leftCircleMedium.alpha -=.1;
				rightCircleMedium.alpha -=.1;
				circleMedium.alpha -=.1;
			} else if (visibleStepMedium == 8) {
				leftCircleMedium.visible = false;
				rightCircleMedium.visible = false;
				circleMedium.visible = false;
			}
			
			if(visibleStepLow<8){
				visibleStepLow++;
				leftCircleLow.alpha -=.1;
				rightCircleLow.alpha -=.1;
				circleLow.alpha -=.1;
			} else if (visibleStepLow == 8) {
				leftCircleLow.visible = false;
				rightCircleLow.visible = false;
				circleLow.visible = false;
			}
			
		}
		
		public function leftPeakHigh():void {
			leftCircleHigh.visible = true;
			leftCircleHigh.alpha = 1;
			visibleStepHigh = 0;
		}
		
		public function rightPeakHigh():void {
			rightCircleHigh.visible = true;
			rightCircleHigh.alpha = 1;
			visibleStepHigh = 0;
		}
		
		public function peakHigh():void {
			circleHigh.visible = true;
			circleHigh.alpha = 1;
			visibleStepHigh = 0;
		}
		
		public function leftPeakMedium():void {
			leftCircleMedium.visible = true;
			leftCircleMedium.alpha = 1;
			visibleStepMedium = 0;
		}
		
		public function rightPeakMedium():void {
			rightCircleMedium.visible = true;
			rightCircleMedium.alpha = 1;
			visibleStepMedium = 0;
		}
		
		public function peakMedium():void {
			circleMedium.visible = true;
			circleMedium.alpha = 1;
			visibleStepMedium = 0;
		}
		
		public function leftPeakLow():void {
			leftCircleLow.visible = true;
			leftCircleLow.alpha = 1;
			visibleStepLow = 0;
		}
		
		public function rightPeakLow():void {
			rightCircleLow.visible = true;
			rightCircleLow.alpha = 1;
			visibleStepLow = 0;
		}
		
		public function peakLow():void {
			circleLow.visible = true;
			circleLow.alpha = 1;
			visibleStepLow = 0;
		}
		
		private function onStartClick(e:MouseEvent):void {
			dispatchEvent(new Event(START_CLICK));
		}
		
		public function startGame():void {
			MusicAnalizerFacade.getInstance().mainStage.removeChild(menu);
		}
		
	}

}