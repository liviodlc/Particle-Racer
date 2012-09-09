package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;

	public class TrafficMid extends Car {
		
		[Embed(source = "img/traffic-mid.png")]
		private var TrafficImg:Class;
		
		public function TrafficMid(main:Main, angle:Number) {
			super(main);
			
			MAX_SPEED = 18;
			trajectoryAngle += angle;
			rotationAngle += angle;
			
			drawPlayer(new TrafficImg());
			
			pressUp = true;
		}
	}
}
