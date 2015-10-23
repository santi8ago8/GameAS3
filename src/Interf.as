package  {
	
	import flash.display.MovieClip;
	
	
	public class Interf extends MovieClip {
		
		
		public function Interf() {
			// constructor code
		}
		
		public function init(s:String,cant:int) {
			this.Frase.text = s;
			
			this.Puntos.text = 0 + '/' + cant;
			
		}
	}
	
}
