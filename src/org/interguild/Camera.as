package org.interguild {
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Camera extends Sprite {
		
		private var box:Rectangle;
		
		public function Camera(w:Number, h:Number) {
			box = new Rectangle(0, 0, w, h);
		}
		
		public function onGameLoop(focusX:Number, focusY:Number):void {
			x = int(-focusX + box.x + box.width / 2);
			y = int(-focusY + box.y + box.height / 2);
			
//			if ( /*lvl.x < 0 &&*/lvl.levelWidth + lvl.x < box.width) {
//				lvl.x = int(box.width - lvl.levelWidth);
//			}
//			if ( /*lvl.y < 0 &&*/lvl.levelHeight + lvl.y < box.height) {
//				lvl.y = int(box.height - lvl.levelHeight);
//			}
//			if(lvl.x > 0){
//				lvl.x = 0;
//			}
//			if(lvl.y > 0){
//				lvl.y = 0;
//			}
		}
	}
}
