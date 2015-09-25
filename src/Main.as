package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.lorentz.SVG.display.SVGDocument;
	/**
	 * ...
	 * @author santi8ago8
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			var svg:SVGDocument = new SVGDocument();  
			svg.load("lion.svg");  
			trace(svg.numChildren);
			
			
			addChild(svg);
		}
		
	}
	
}