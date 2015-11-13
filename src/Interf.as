package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	
	public class Interf extends MovieClip {
		
		var cant:int;
		var s:int;
		var arr:Array;
		public function Interf() {
			// constructor code
			this.addEventListener(Event.ENTER_FRAME,this.drawText);
		}
		
		public function init(s:String,cant:int) {
			this.Frase.text = s;
			this.s = 0;
			this.cant = cant;
			this.updateScore(0);
		}
		public function updateScore(s:int){
			this.s+=s;
			this.Puntos.text = this.s + '/' + cant;
		}
		public function setLetters(lets:Array){
			this.arr = lets;
		}
		public function drawText(e:Event){
			var j:int = 0;
			if (arr){
				for	(var i:int = 0;i<this.Frase.text.length; i++){
					if (i==arr[j].pos && j<arr.length){

						var format:TextFormat = new TextFormat();
						format.color = arr[j].color;

						this.Frase.setTextFormat(format,i,i+1);
						j++;
					}
				}
			}
		}
	}
	
}
