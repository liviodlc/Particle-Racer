package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	[SWF(width = "800", height = "600")]
	public class Main extends Sprite {

		private static const FPS:int = 30;
		private static const PERIOD:int = 1000 / FPS;

		private static const BG_COLOR:uint = 0x0a530b;
		private static const GRID_BOUNDS:Rectangle = new Rectangle(-250, -9900, 600, 10100);
		private static const GRID_SIZE:int = 100;

		private var camera:Camera;
		private var player:Player;
		private var timer:Timer;

		private var marks:Array;
		private var cars:Array;

		private var grids:Array;


		public function Main() {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(BG_COLOR);
			sp.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			sp.graphics.endFill();
			addChild(sp);

			camera = new Camera(stage.stageWidth, stage.stageHeight);
			marks = [];
			cars = [];

			initGrid();
			buildRoads();

			player = new Player(this, stage);
			camera.addCar(player);
			updateGrid(player);

			addChild(camera);
			onGameLoop(null);

			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
			timer.start();
		}


		private function initGrid():void {
			grids = new Array(GRID_BOUNDS.width / GRID_SIZE);
			for (var x:int = 0; x * GRID_SIZE < GRID_BOUNDS.width; x++) {
				grids[x] = new Array(GRID_BOUNDS.height / GRID_SIZE);
				for (var y:int = 0; y * GRID_SIZE < GRID_BOUNDS.height; y++) {
					grids[x][y] = [];
				}
			}
//			trace(grid.length, grid[0].length);
		}


		private function buildRoads():void {
			var r:StraightRoad = new StraightRoad(300, 10000);
			r.x = -150;
			r.y = -9900;
			camera.addRoad(r);

			var t:Tunnel = new Tunnel(this);
			t.x = -t.width / 2;
			t.y = 80;
			camera.addTunnel(t);

			t = new Tunnel(this, Tunnel.DOWN);
			t.x = -t.width / 2;
			t.y = -9960;
			camera.addTunnel(t);
		}


		private function onGameLoop(evt:TimerEvent):void {
			for each (var c:Car in cars) {
				c.onGameLoop();
			}
			player.onGameLoop();

			for each (c in cars) {
				c.testCollisions();
			}
			camera.onGameLoop(player.x, player.y);

			pruneMarks();
		}


		public function addMark(m:Sprite):void {
			camera.addMark(m);
			marks.push(m);
		}


		private function pruneMarks():void {
			for each (var m:Sprite in marks) {
				if (Math.abs(player.y - m.y) > 600 || Math.abs(player.x - m.x) > 800) {
					camera.removeMark(m);
					marks.splice(marks.lastIndexOf(m), 1);
				}
			}
		}


		public function addCar(t:TrafficMid):void {
			cars.push(t);
			camera.addCar(t);
			updateGrid(t);
		}


		public function removeCar(t:TrafficMid):void {
			cars.splice(cars.lastIndexOf(t), 1);
			camera.removeCar(t);
		}


		public function updateGrid(c:Car):void {
//			trace(int((c.x - GRID_BOUNDS.x) / GRID_SIZE), int((c.y - GRID_BOUNDS.y) / GRID_SIZE));
			var newGrid:Array = grids[int((c.x - GRID_BOUNDS.x) / GRID_SIZE)];
			if (newGrid != null) {
				newGrid = newGrid[int((c.y - GRID_BOUNDS.y) / GRID_SIZE)];
				if (newGrid != c.currentGrid) {
					if (c.currentGrid != null) {
						c.currentGrid.splice(c.currentGrid.lastIndexOf(c), 1);
					}
					c.currentGrid = newGrid;
					if (newGrid != null) {
						newGrid.push(c);
					} else if (c is TrafficMid) {
//						trace("removed");
						removeCar(c as TrafficMid);
					}
				}
			}
		}


		public function getNearbyCars(c:Car):Array {
			var result:Array = [];
			var gridX:int = (c.x - GRID_BOUNDS.x) / GRID_SIZE;
			var gridY:int = (c.y - GRID_BOUNDS.y) / GRID_SIZE;

			result = getCarsInGrid(gridX, gridY - 1, result);
			result = getCarsInGrid(gridX, gridY, result);
			result = getCarsInGrid(gridX, gridY + 1, result);

			result = getCarsInGrid(gridX + 1, gridY - 1, result);
			result = getCarsInGrid(gridX + 1, gridY, result);
			result = getCarsInGrid(gridX + 1, gridY + 1, result);

			result = getCarsInGrid(gridX - 1, gridY - 1, result);
			result = getCarsInGrid(gridX - 1, gridY, result);
			result = getCarsInGrid(gridX - 1, gridY + 1, result);

			return result;
		}


		private function getCarsInGrid(gridX:int, gridY:int, result:Array):Array {
			var grid:Array = grids[gridX];
			if (grid == null)
				return result;
			grid = grid[gridY];
			if (grid == null)
				return result;
			return result.concat(grid);
		}
	}
}
