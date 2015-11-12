package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author santi8ago8
	 */
	public class Game extends Sprite
	{
		var letras:MovieClip;
		var frase:String;
		var countGraph:int;
		var letrasArr:Array;
		
		public function Game(folder:String)
		{
			this.folder = folder;
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private var folder:String;
		
		private function init(e:Event = null):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var urlBack:String = folder + 'back.png';
			var loader:Loader = new Loader();
			loader.load(new URLRequest(urlBack));
			this.addChild(loader)
			
			var loaderJson:URLLoader = new URLLoader(new URLRequest(folder + 'data.json'));
			loaderJson.addEventListener(Event.COMPLETE, this.fileLoaded);


			
		}
		
		private function fileLoaded(e:Event):void {
			var data:Object = JSON.parse((e.target as URLLoader).data);
			Main.currentJson = data;
			this.alpha = 0;
			Tweener.addTween(this, {
				alpha:1,
				time:.9
			});
			this.countGraph = 0;
			
			for (var i:int = 0; i < data.els.length; i++)
			{
				var url:String = folder + i + '.png';
				var loader:GameLoader = new GameLoader();
				loader.load(new URLRequest(url));
				this.addChild(loader)
				var box:Object = data.els[i];
				loader.x = -800 + Math.random() * 2400;
			    
				loader.y = i % 2 == 0? -500:1200;
				loader.box = box;
				this.start(loader);
				this.countGraph++;
				
			}

			this.letras = new MovieClip();
			this.addChild(letras);
		}

		public function createLetters():String{

			var str:String = Main.currentJson.description.toLowerCase();
			letrasArr = new Array();
			for (var i = 0;i<str.length;i++){
				var l:String = str.charAt(i);
				if (l!=' ' && l!=',' && l!='.'){
					letrasArr.push({
						pos:i,
						letra:l,
						color: 0xffffff
					});
				}
			}
			Main.I.setLetters(letrasArr);

			var frase:String = Main.currentJson.description.toLowerCase()
				.split(" ").join("")
				.split(".").join("")
				.split(",").join("")
				.split("á").join("a")
				.split("é").join("e")
				.split("í").join("i")
				.split("ó").join("o")
				.split("ú").join("u");

			var tiempo:Number = Main.currentJson.time;
			var tiempoCU:Number = tiempo/frase.length;
			this.frase = frase;
			

			for (var i = 0;i<frase.length;i++){
				var l:String = frase.charAt(i);
				var url:String = 'img/abecedario/' + l + '.png';
				var loader:GameLoader = new GameLoader();
				
				loader.load(new URLRequest(url));
				loader.tag = new Object();
				loader.tag.letra = l;
				loader.tag.pos = i;
				letras.addChild(loader);
				loader.y = -100;
				loader.x = Game.randomIntRange(10,700);
				Tweener.addTween(loader,{
					y:650,
					delay:i*tiempoCU,
					time:Game.randomNumberRange(.75,2),
					transition:'easeInOutCubic',
					onComplete:function(lO:GameLoader){
						if (!lO.tag.passed){
							letrasArr[lO.tag.pos].color = 0xFA0202;
						}

						lO.visible = false;
					},
					onCompleteParams:[loader]
				});
			}


			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keydown);


			return frase;
		}

		private function keydown(e:KeyboardEvent):void{

			var letra:String = String.fromCharCode(e.keyCode).toLowerCase();
			var count:int=0;
			for (var i:int = 0; i<this.letras.numChildren; i++){
				var l:GameLoader = this.letras.getChildAt(i) as GameLoader;
				if (l.tag.letra == letra && l.isVisible()){
					//trace('pego: ',letra);
					l.visible = false;
					l.tag.passed = true;
					letrasArr[l.tag.pos].color = 0x02FA0B;
					count++;
				}
			}
			if (count>0){
				//animar a cero las piezas.
				this.toZero(count);
				Main.I.updateScore(count);
			}
		}
		
		private function complete(child:GameLoader):void {
			trace(child);
			
		}
		
		private function start(loader:GameLoader,delay:int=1):void {
			
			Tweener.addTween(loader, {
				y:loader.box.y, 
				x:loader.box.x, 
				time:2 + Math.random() * 2, 
				transition:'easeInOutCubic' , 
				delay:delay
			});
		}
		
		public function hide(cb:Function) {
			
			
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				if (this.getChildAt(i) is GameLoader){
					var loader:GameLoader = this.getChildAt(i) as GameLoader;
					Tweener.addTween(loader, {
						y: -800 +Math.random()*2400, 
						x: -800 + Math.random() * 2400, 
						time:2 + Math.random() * 2, 
						transition:'easeInOutCubic'
						});
				}
			}
			
			Tweener.addTween(this, {
					alpha:0,
					time:6, 
					transition:'easeInOutCubic' , 
					onComplete: function() {
						cb();
					}
					});
			
		}
		public function hideFromScene(cb:Function,alpha:Boolean=true) {
		
			
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				if (this.getChildAt(i) is GameLoader){
					var loader:GameLoader = this.getChildAt(i) as GameLoader;
					
					var x, y:Number;
					if (i % 2 == 0) {
						Math.random
						x = Game.randomIntRange( -2700, -800); //r.integer( -2700, -800);
						y = Game.randomIntRange(-800, 1800);
					} else {
						x = Game.randomIntRange(800, 1600);
						y = Game.randomIntRange(-800, 1800);
					}
					Tweener.addTween(loader, {
						y: y,
						x: x, 
						time:2 + Math.random() * 2, 
						transition:'easeInOutCubic'
					});
				}
			}
			cb();
			if (alpha)
			Tweener.addTween(this, {
				alpha:0,
				time:6, 
				transition:'easeInOutCubic' 
			});
		}
		public function toZero (count:int):void{
			// 20   -->   100%
			// 1    -->     x%

			var percent:Number = count*1/this.frase.length;

			var toShow:int = (this.countGraph * percent);
			//trace(percent,toShow);

			for (var i:int = 0; (i<this.numChildren && toShow > 0);i++){
				if (this.getChildAt(i) is GameLoader){
					var l:GameLoader = this.getChildAt(i) as GameLoader;
					if (!l.tag.inZero){
						l.tag.inZero = true;
						toShow--;
						this.start(l,.3);
					}
				}
			}

		}
		public static function randomIntRange(start:Number, end:Number):int
		{
			return int(randomNumberRange(start, end));
		}
		
		public static function randomNumberRange(start:Number, end:Number):Number
		{
			end++;
			return (start + (Math.random() * (end - start)));
		}

	}

}