package 
{
	import flash.display.Loader;
	
	/**
	 * ...
	 * @author santiago
	 */
	public class GameLoader extends Loader 
	{
		
		public function GameLoader() 
		{
			super();
			
		}
		public var box:Object = null;
		public var tag:Object = new Object();

		public function isVisible():Boolean{

			return (x>0 && this.visible);

		}
	}

}