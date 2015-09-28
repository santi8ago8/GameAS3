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
	public class Main extends Sprite
	{
		
		public function Main()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private var folder:String = new String("../img/lion_legendary/");
		
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
					delay:2,
					onComplete: this.exit,
					onCompleteParams:[loader]
					} );
		}
		private function exit(loader:GameLoader):void {
			Tweener.addTween(loader, {
					y: -800 +Math.random()*2400, 
					x: -800 + Math.random() * 2400, 
					time:2 + Math.random() * 2, 
					transition:'easeInOutCubic' , 
					delay:2,
					onComplete: this.start,
					onCompleteParams:[loader]
					} );
		}
	
	}

}