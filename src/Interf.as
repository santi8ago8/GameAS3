package  {
	
	import flash.display.MovieClip;
	
	
	public class Interf extends MovieClip {
		
		var cant:int;
		public function Interf() {
			// constructor code
		}
		
		public function init(s:String,cant:int) {
			this.Frase.text = s;
			this.cant = cant;
			this.updateScore(0);
		}
		public function updateScore(s:int){
			this.Puntos.text = s + '/' + cant;
		}
	}
	
}
