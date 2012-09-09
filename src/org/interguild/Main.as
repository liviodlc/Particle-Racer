package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[SWF(width = "800", height = "600")]
	public class Main extends Sprite {

		private static const FPS:int = 30;
		private static const PERIOD:int = 1000 / FPS;

		private var camera:Camera;
		private var player:Player;
		private var timer:Timer;

		[Embed(source = "img/map.jpg")]
		private var Track:Class;
		
		private var marks:Array;


		public function Main() {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xdedede);
			sp.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			sp.graphics.endFill();
			addChild(sp);

			camera = new Camera(stage.stageWidth, stage.stageHeight);
			marks = [];

			var t:Bitmap = new Track();
			t.x = -t.width / 2;
			t.y = -t.height / 2;
			t.alpha = .5;
			camera.addChild(t);

			player = new Player(this, stage);
			camera.addChild(player);

			traffic = new TrafficMid();
			traffic.x = player.width;
			camera.addChild(traffic);

			addChild(camera);
			onGameLoop(null);

			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
			timer.start();
		}

		private var traffic:TrafficMid;

		private function onGameLoop(evt:TimerEvent):void {
			player.onGameLoop();
			camera.onGameLoop(player.x, player.y);

			pruneMarks();
			
			if(player.y < 0)
				traffic.y -= 18;
		}
		
		public function addMark(m:Sprite):void{
			camera.addChildAt(m, 0);
			marks.push(m);
		}
		
		private function pruneMarks():void{
			for each(var m:Sprite in marks){
				if(Math.abs(player.y - m.y) > 600 || Math.abs(player.x - m.x) > 800){
					camera.removeChild(m);
					marks.splice(marks.lastIndexOf(m), 1);
				}
			}
		}

	}
}
