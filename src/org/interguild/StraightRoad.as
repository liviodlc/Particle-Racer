package org.interguild {
	import flash.display.Sprite;

	public class StraightRoad extends Sprite {

		private static const STREET_COLOR:uint = 0x666666;
		private static const LINE_COLOR:uint = 0xFFD700;
		private static const LINE_ALPHA:Number = 0.75;
		private static const LINE_SPACING:uint = 120;
		private static const LINE_WIDTH:uint = 8;
		private static const LINE_HEIGHT:uint = 60;
		
//		private static const LINE_COLOR2:uint = 0xFFFFFF;
//		private static const LINE_ALPHA2:Number = 0.75;
//		private static const LINE_SPACING2:uint = 100;
//		private static const LINE_OFFSET:uint = 50;
//		private static const LINE_WIDTH2:uint = 5;
//		private static const LINE_HEIGHT2:uint = 40;


		public function StraightRoad(width:Number, height:Number) {
			this.graphics.beginFill(STREET_COLOR);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();

			var x:Number = width / 2 - LINE_WIDTH / 2;
			this.graphics.beginFill(LINE_COLOR, LINE_ALPHA);
			for (var y:Number = LINE_SPACING; y + LINE_HEIGHT < height; y += LINE_HEIGHT + LINE_SPACING) {
				this.graphics.drawRect(x, y, LINE_WIDTH, LINE_HEIGHT);
			}
			this.graphics.endFill();
			
//			x = width / 4 - LINE_WIDTH2 / 2;
//			var x1:Number = width * 3 / 4 - LINE_WIDTH2 / 2;
//			this.graphics.beginFill(LINE_COLOR2, LINE_ALPHA2);
//			for (y = LINE_SPACING2 + LINE_OFFSET; y + LINE_HEIGHT2 < height; y += LINE_HEIGHT2 + LINE_SPACING2) {
//				this.graphics.drawRect(x, y, LINE_WIDTH2, LINE_HEIGHT2);
//				this.graphics.drawRect(x1, y, LINE_WIDTH2, LINE_HEIGHT2);
//			}
//			this.graphics.endFill();
		}
	}
}
