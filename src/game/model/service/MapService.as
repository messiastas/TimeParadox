package game.model.service 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import game.common.SharedConst;
	import game.common.interfaces.ILevelDesign;
	import game.common.GameFacade;
	
	/**
	 * ...
	 * @author messia_s
	 */
	public class MapService extends Proxy implements IProxy,ILevelDesign
	{
		
		private var currentMapGraphic:MovieClip;
		private var mapStep:int;
		private var realMap:Array = new Array();
		
		public function MapService(data:Object):void 
		{
			proxyName = SharedConst.MAP_SERVICE;
			switch(data["level"])
			{
				case 1:
					currentMapGraphic = new Map1();
					GameFacade.getInstance().mainStage.addChild(currentMapGraphic);
					break;
					
			}
			mapStep = SharedConst.MAP_STEP;
			createMap();
		}
		
		private function createMap():void 
		{
			var i:int = 0;//vertical
			var j:int = 0;//horizontal
			var bMap:BitmapData = new BitmapData(currentMapGraphic.width, currentMapGraphic.height, true, 0);
			bMap.fillRect(bMap.rect, 0);
			bMap.draw(currentMapGraphic);
			
			
			trace(currentMapGraphic.width, currentMapGraphic.height);
			while (i * mapStep < currentMapGraphic.height)
			{
				var horizontalArray:Array = [];
				while (j * mapStep < currentMapGraphic.width)
				{
					
					if (bMap.getPixel(j * mapStep + mapStep *0.5, i * mapStep + mapStep *0.5)>0)
					{
						//trace(i, j);
						horizontalArray[j] = 1
					} else 
					{
						horizontalArray[j] = 0
					}
					j++;
				}
				realMap[i] = horizontalArray;
				i++;
				j = 0;
			}
			//trace(realMap);
		}
		
		public function getMapArray():Array
		{
			return realMap;
		}
		
	}

}