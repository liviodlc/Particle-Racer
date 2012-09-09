package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;

	public class Car extends Sprite {

		protected var MAX_SPEED:Number = 20;
		protected var MAX_SPEED_REVERSE:Number = -20;
		protected var ACC:Number = 1;
		protected var ACC_REVERSE:Number = 1;
		protected var FRICTION:Number = 0.99;
		protected var BRAKE:Number = 0.8;

		protected var STEERING_MAX:Number = 30;
		protected var STEERING_ACC:Number = 4;
		protected var STEERING_DEC:Number = 8;
		protected var STEERING_MAX_RADIUS:Number = 100; //smallest radius possible
		protected var STEERING_SLOWDOWN:Number = 0.3;

		protected var DRIFT_MIN_SPEED:Number = 8;
		protected var DRIFT_MAX_STRETCH:Number = 100;

		protected var RADIAN:Number = Math.PI / 180;

		private var theStage:Stage;
		private var main:Main;
		public var hitbox:Rectangle;

		private var trajectoryAngle:Number = -90;
		private var rotationAngle:Number = 0;
		private var steeringAngle:Number = 0;
		private var speed:Number = 0;

		private var newX:Number = 0;
		private var newY:Number = 0;


		public function Car(main:Main, theStage:Stage) {
			this.theStage = theStage;
			this.main = main;
		}

		private var leftWheel:Sprite;
		private var rightWheel:Sprite;


		protected function drawPlayer(spr:Bitmap):void {
			//front-left wheel
			leftWheel = getWheel();
			leftWheel.x = -11;
			leftWheel.y = -9;
			addChild(leftWheel);

			//front-right wheel
			rightWheel = getWheel();
			rightWheel.x = 11;
			rightWheel.y = -9;
			addChild(rightWheel);

			//rear-left wheel
			var rlw:Sprite = getWheel();
			rlw.x = -11;
			rlw.y = 11;
			addChild(rlw);

			//rear-right wheel
			var rrw:Sprite = getWheel();
			rrw.x = 11;
			rrw.y = 11;
			addChild(rrw);

			//body
			spr.x = -spr.width / 2;
			spr.y = -spr.height / 2;
			addChild(spr);
		}

		protected var WHEEL_COLOR:uint = 0;
		protected var WHEEL_WIDTH:uint = 4;
		protected var WHEEL_HEIGHT:uint = 10;


		private function getWheel():Sprite {
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(WHEEL_COLOR);
			spr.graphics.drawRect(-WHEEL_WIDTH / 2, -WHEEL_HEIGHT / 2, WHEEL_WIDTH, WHEEL_HEIGHT);
			spr.graphics.endFill();
			return spr;
		}

		protected var pressRight:Boolean;
		protected var pressLeft:Boolean;
		protected var pressUp:Boolean;
		protected var pressDown:Boolean;


		public function onGameLoop():void {
			updateControls();
			updateMovement();
			updateState();
		}


		private function updateControls():void {
			if (pressUp && !pressDown) {
				if (speed < 0) {
					speed *= BRAKE;
					if (speed > -0.5)
						speed = 0;
				} else {
					speed += ACC;
					if (speed > MAX_SPEED)
						speed = MAX_SPEED;
				}
			} else if (pressDown) {
				if (speed > 0) {
					speed *= BRAKE;
					if (speed < 0.5)
						speed = 0;
					if (speed > DRIFT_MIN_SPEED) {
						main.addMark(new TireMark(x, y, -11, 11, this.rotation));
						main.addMark(new TireMark(x, y, 11, 11, this.rotation));
					}
				} else {
					speed -= ACC_REVERSE
					if (speed < MAX_SPEED_REVERSE)
						speed = MAX_SPEED_REVERSE;
				}
			} else {
				if (speed > 0) {
					speed *= FRICTION;
					if (speed < 0.5)
						speed = 0;
				}
				if (speed < 0) {
					speed *= FRICTION;
					if (speed > -0.5)
						speed = 0;
				}
			}

			if (pressRight && !pressLeft) {
				if (steeringAngle < 0) {
					steeringAngle += STEERING_DEC;
					if (steeringAngle > 0)
						steeringAngle = 0;
				}
				steeringAngle += STEERING_ACC;
				if (steeringAngle > STEERING_MAX) {
					steeringAngle = STEERING_MAX;
				}
			} else if (pressLeft && !pressRight) {
				if (steeringAngle > 0) {
					steeringAngle -= STEERING_DEC;
					if (steeringAngle < 0)
						steeringAngle = 0;
				}
				steeringAngle -= STEERING_ACC;
				if (steeringAngle < -STEERING_MAX) {
					steeringAngle = -STEERING_MAX;
				}
			} else {
				if (steeringAngle > 0) {
					steeringAngle -= STEERING_DEC;
					if (steeringAngle < 0)
						steeringAngle = 0;
				} else if (steeringAngle < 0) {
					steeringAngle += STEERING_DEC;
					if (steeringAngle > 0)
						steeringAngle = 0;
				}
			}

			leftWheel.rotation = steeringAngle;
			rightWheel.rotation = steeringAngle;
		}


		private function updateMovement():void {
			if (steeringAngle != 0) {
				var steeringPercent:Number = Math.abs(steeringAngle / STEERING_MAX);
				var radius:Number = STEERING_MAX_RADIUS / steeringPercent;

				if (speed > DRIFT_MIN_SPEED) {
					var driftPercent:Number = (speed - DRIFT_MIN_SPEED) / (MAX_SPEED - DRIFT_MIN_SPEED);
					radius += driftPercent * DRIFT_MAX_STRETCH;
					if (steeringAngle == STEERING_MAX) {
						main.addMark(new TireMark(x, y, 11, 11, this.rotation));
						main.addMark(new TireMark(x, y, -11, 11, this.rotation));
					}
					if (steeringAngle == -STEERING_MAX) {
						main.addMark(new TireMark(x, y, 11, 11, this.rotation));
						main.addMark(new TireMark(x, y, -11, 11, this.rotation));
					}
				}

				var circumference:Number = 2 * radius;

				var displacementPercent:Number = speed * STEERING_SLOWDOWN / circumference;
				var arcAngle:Number = displacementPercent * 360;

				var tangentAngle:Number;
				if (steeringAngle > 0)
					tangentAngle = trajectoryAngle + 90;
				else
					tangentAngle = trajectoryAngle - 90;

				var tangentCircleX:Number = Math.cos(tangentAngle * RADIAN) * radius + this.x;
				var tangentCircleY:Number = Math.sin(tangentAngle * RADIAN) * radius + this.y;

				var tangentCircleAngle:Number, totalAngle:Number;
				if (steeringAngle > 0) {
					tangentCircleAngle = tangentAngle - 180;
					totalAngle = tangentCircleAngle + arcAngle;
				} else {
					tangentCircleAngle = tangentAngle + 180;
					totalAngle = tangentCircleAngle - arcAngle;
				}

				newX = Math.cos(totalAngle * RADIAN) * radius + tangentCircleX;
				newY = Math.sin(totalAngle * RADIAN) * radius + tangentCircleY;

				var totalTangentAngle:Number = totalAngle + 90;
				if (steeringAngle < 0)
					totalTangentAngle -= 180;

				trajectoryAngle = totalTangentAngle;
				this.rotation = trajectoryAngle + 90;
			} else {
				newY += Math.sin(trajectoryAngle * RADIAN) * speed;
				newX += Math.cos(trajectoryAngle * RADIAN) * speed;
				this.rotation = trajectoryAngle + 90;
			}

			while (trajectoryAngle > 360) {
				trajectoryAngle -= 360;
			}
			while (trajectoryAngle < -360) {
				trajectoryAngle += 360;
			}
		}


		private function updateState():void {
			x = newX;
			y = newY;
			//			trace(x, y);
		}
	}
}
