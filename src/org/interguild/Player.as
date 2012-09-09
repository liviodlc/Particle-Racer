package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;

	public class Player extends Car {

		[Embed(source = "img/player.png")]
		private var Body:Class;


		public function Player(main:Main, theStage:Stage) {
			super(main, theStage);

			MAX_SPEED = 20;
			MAX_SPEED_REVERSE = -20;
			ACC = 1;
			ACC_REVERSE = 1;
			FRICTION = 0.99;
			BRAKE = 0.8;

			STEERING_MAX = 30;
			STEERING_ACC = 4;
			STEERING_DEC = 8;
			STEERING_MAX_RADIUS = 100; //smallest radius possible
			STEERING_SLOWDOWN = 0.3;

			DRIFT_MIN_SPEED = 8;
			DRIFT_MAX_STRETCH = 100;

			RADIAN = Math.PI / 180;

			WHEEL_COLOR = 0;
			WHEEL_WIDTH = 4;
			WHEEL_HEIGHT = 10;

			drawPlayer(new Body());

			theStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			theStage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
		}


		private function onKeyDown(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 38: //UP
					pressUp = true;
					break;
				case 40: //DOWN
					pressDown = true;
					break;
				case 37: //LEFT
					pressLeft = true;
					break;
				case 39: //RIGHT
					pressRight = true;
					break;
			}
		}


		private function onKeyUp(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case 38: //UP
					pressUp = false;
					break;
				case 40: //DOWN
					pressDown = false;
					break;
				case 37: //LEFT
					pressLeft = false;
					break;
				case 39: //RIGHT
					pressRight = false;
					break;
			}
		}
	}
}
