package org.interguild {
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Camera extends Sprite {

		private var box:Rectangle;
		private var roads:Sprite;
		private var marks:Sprite;
		private var cars:Sprite;
		private var tunnels:Sprite;


		public function Camera(w:Number, h:Number) {
			box = new Rectangle(0, 0, w, h);
			roads = new Sprite;
			addChild(roads);
			marks = new Sprite;
			addChild(marks);
			cars = new Sprite;
			addChild(cars);
			tunnels = new Sprite;
			addChild(tunnels);
		}


		public function onGameLoop(focusX:Number, focusY:Number):void {
			x = int(-focusX + box.x + box.width / 2);
			y = int(-focusY + box.y + box.height / 2);
		}


		public function addRoad(r:StraightRoad):void {
			roads.addChild(r);
		}


		public function addMark(m:Sprite):void {
			marks.addChild(m);
		}


		public function removeMark(m:Sprite):void {
			marks.removeChild(m);
		}


		public function addCar(c:Car):void {
			cars.addChild(c);
		}


		public function removeCar(c:Car):void {
			cars.removeChild(c);
		}
		
		public function addTunnel(t:Tunnel):void {
			tunnels.addChild(t);
		}
	}
}
