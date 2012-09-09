package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Tunnel extends Sprite {

		private static const TICK_DELAY:uint = 500;

		public static const UP:uint = 0;
		public static const DOWN:uint = 1;

		[Embed(source = "img/tunnel.png")]
		private var Img:Class;

		private var timer:Timer;
		private var main:Main;
		private var direction:uint;


		public function Tunnel(main:Main, direction:uint = Tunnel.UP) {
			this.main = main;
			this.direction = direction;

			var i:Bitmap = new Img();
			if (direction == DOWN) {
				i.rotation = 180;
				i.x += i.width;
				i.y += i.height;
			}
			addChild(i);

			timer = new Timer(TICK_DELAY);
			timer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			timer.start();
		}


		private function onTick(evt:TimerEvent):void {
			var angle:Number = 0;
			if(direction==DOWN)
				angle = 180;
			var t:TrafficMid = new TrafficMid(main, angle);
			if (direction == UP) {
				t.x = this.x + width / 3 * 2;
				t.y = this.y + 50;
			} else {
				t.x = this.x + width / 3;
				t.y = this.y + 50;
			}
			main.addCar(t);
		}
	}
}
