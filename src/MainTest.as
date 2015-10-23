package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author santi8ago8
	 */
	public class MainTest extends Sprite
	{
		
		public function MainTest(folder:String)
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
				
			}
		}
		
		private function complete(child:GameLoader):void {
			trace(child);
		}
		
		private function start(loader:GameLoader):void {
			
			Tweener.addTween(loader, {
					y:loader.box.y, 
					x:loader.box.x, 
					time:2 + Math.random() * 2, 
					transition:'easeInOutCubic' , 
					delay:1
					} );
		}
		
		public function hide(cb:Function) {
			
			
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var loader:GameLoader = this.getChildAt(i) as GameLoader;
				Tweener.addTween(loader, {
					y: -800 +Math.random()*2400, 
					x: -800 + Math.random() * 2400, 
					time:2 + Math.random() * 2, 
					transition:'easeInOutCubic'
					});
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
		public function hideFromScene(cb:Function) {
		
			
			
			for (var i:int = 0; i < this.numChildren; i++)
			{
				var loader:GameLoader = this.getChildAt(i) as GameLoader;
				
				var x, y:Number;
				if (i % 2 == 0) {
					Math.random
					x = MainTest.randomIntRange( -2700, -800); //r.integer( -2700, -800);
					y = MainTest.randomIntRange(-800, 1800);
				} else {
					x = MainTest.randomIntRange(800, 1600);
					y = MainTest.randomIntRange(-800, 1800);
				}
				Tweener.addTween(loader, {
					y: y,
					x: x, 
					time:2 + Math.random() * 2, 
					transition:'easeInOutCubic'
					});
			}
			
			Tweener.addTween(this, {
					alpha:0,
					time:6, 
					transition:'easeInOutCubic' , 
					onComplete: function() {
						trace("cb call");
						cb();
						
					}
					});
		}
		public static function randomIntRange(start:Number, end:Number):int
		{
			return int(randomNumberRange(start, end));
		}
		
		public static function randomNumberRange(start:Number, end:Number):Number
		{
			end++;
			return Math.floor(start + (Math.random() * (end - start)));
		}

	}

}