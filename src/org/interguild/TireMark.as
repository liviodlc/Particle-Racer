package org.interguild {
	import flash.display.Sprite;

	public class TireMark extends Sprite {

		private static const COLOR:uint = 0x222222;
		private static const WIDTH:uint = 4;
		private static const HEIGHT:uint = 20;


		public function TireMark(x:Number, y:Number, mx:Number, my:Number, rotate:Number) {
			this.x = x;
			this.y = y;
			this.rotation = rotate;

			this.graphics.beginFill(COLOR);
			this.graphics.drawRect(mx-WIDTH / 2, my-HEIGHT / 2, WIDTH, HEIGHT);
			this.graphics.endFill();
		}
	}
}
