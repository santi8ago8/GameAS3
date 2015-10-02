package 
{
	/**
	 * ...
	 * @author santi8ago8
	 */
	public class Main 
	{
		
		public function Main()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			
		}
	}

}