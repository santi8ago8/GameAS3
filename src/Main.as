package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author santi8ago8
	 */
	public class Main extends MovieClip
	{
		
		public function Main()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public static var currentJson:Object;
		var menu:Game;
		var game:Game;
		var punt:MovieClip;
		var tMenu:Timer;
		var tGame:Timer;
		var fraseFinal:String;
		public static var I:Interf;
		
		public function playLevel1(e:TimerEvent):void {
			try{
			stage.removeChild(menu);
			stage.removeChild(game);
			stage.removeChild(I);
			} catch(Ecx){}
			
			trace("play level1");
			game = new Game("img/Lion legendary/");
			//menu.addEventListener(MouseEvent.CLICK, this.selectLevel);
			stage.addChild(game);
			tMenu = new Timer(5000, 1);
			tMenu.addEventListener(TimerEvent.TIMER, hideFromStage);
			tMenu.start();
			
			tGame = new Timer(7000, 1);
			tGame.addEventListener(TimerEvent.TIMER, initInterf);
			tGame.start();
		}
		
		private function initInterf(e:TimerEvent):void {
			trace(currentJson.description);
			var I:Interf = new Interf();
			Main.I = I;

			
			stage.addChild(I);
			I.init(currentJson.description, 0);
			I.alpha = 0;
			Tweener.addTween(I, {
				alpha:1,
				time:.6
			});
			tGame = new Timer(600,1);
			tGame.addEventListener(TimerEvent.TIMER,this.playGame);
			tGame.start();
		}
		
		private function playGame(e:TimerEvent):void{
		
			this.fraseFinal = game.createLetters();
			Main.I.init(Main.currentJson.description, this.fraseFinal.length);

			tGame = new Timer((currentJson.time+3)*1000,1);
			tGame.addEventListener(TimerEvent.TIMER,this.endGame);
			tGame.start();

		}

		private function endGame(e:TimerEvent):void{
			trace("endGame")

			//crear puntaje...
			var p:Puntaje = new Puntaje();
			this.punt = p;
			p.puntaje.text = game.countScore + " / " + this.fraseFinal.length;
			p.x = 400;
			p.y = 250;
			stage.addChild(p);
			p.addEventListener(MouseEvent.CLICK,this.replyGame);
		}
		
		private function replyGame(e:MouseEvent):void{
			Tweener.addTween(this.punt,{
				alpha: 0,
				time: 1,
				transition: 'easeInOutCubic'
			});
			Tweener.addTween(I,{
				alpha: 0,
				time: 1,
				transition: 'easeInOutCubic' 
			});
			this.punt.removeEventListener(MouseEvent.CLICK,this.endGame);
			game.hideFromScene(function() { } , true);		
			
			tGame = new Timer(3000,1);
			tGame.addEventListener(TimerEvent.TIMER,this.reloadGame);
			tGame.start();
		}
		
		private function reloadGame(e:Event):void{
			stage.removeChild(game);
			stage.removeChild(I);
			this.init();
		}

		private function nextLevel(){
			game.hideFromScene(function(){}, false);			
		}
			
		private function hideFromStage(e:Event) {
			trace("tick hide stage");
			game.hideFromScene(function() { } , false);
		}
		
		private function init(e:Event = null):void {
			trace("init");
			menu = new Game("img/menu/");
			menu.addEventListener(MouseEvent.CLICK, this.selectLevel);
			stage.addChild(menu);
		}
		
		private function selectLevel(e:MouseEvent):void {
			menu.removeEventListener(MouseEvent.CLICK, this.selectLevel);
			trace("hide menu begin");
			tMenu = new Timer(4000, 1);
			tMenu.addEventListener(TimerEvent.TIMER, this.playLevel1);
			tMenu.start();
			menu.hideFromScene(function() {});
			
		}
	}

}