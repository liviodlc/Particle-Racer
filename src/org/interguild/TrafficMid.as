package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class TrafficMid extends Sprite {
		
		[Embed(source = "img/traffic-mid.png")]
		private var TrafficImg:Class;
		
		public function TrafficMid() {
			var spr:Bitmap = new TrafficImg();
			spr.x = -spr.width / 2;
			spr.y = -spr.height / 2;
			addChild(spr);
		}
	}
}
