package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
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
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			for (var i:int = 0; i < 455; i++)
			{
				var url:String = "../img/lion/" + i + '.png';
				var loader = new Loader();
				loader.load(new URLRequest(url));
				this.addChild(loader)
				loader.x = stage.stageWidth/2;
				loader.y = stage.stageHeight/2;
			}
			this.addEventListener(Event.ENTER_FRAME, this.update);
		}
		private function update(e:Event):void {
			
			for (var i:int = 0; i < this.numChildren; i++) 
			{	
				//this.getChildAt(i).x += 1//Math.random() * 2 - 1;
				//this.getChildAt(i).y += Math.random() * 2 - 1;
			}
			
		}
	
	}

}