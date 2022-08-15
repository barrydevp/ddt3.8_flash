package ddt.utils
{
	import com.pickgliss.ui.text.FilterFrameText;
	
	import flash.text.TextFormat;
   
	 public class UIUtils
	 {
	  
		 public function UIUtils()
		 {
			super();
		 }
		  
		 public static function setTextFieldColor(txtField: FilterFrameText, color:uint, begin:int, end:int = -1): void {
		 	if(begin < 0 || begin >= end){
		 		return;
		 	}
		 	if(end == -1) {
				end = begin + 1;
		 	}
		 	// set the color of txt from begin to end
		 	var txtFormat:TextFormat = txtField.getTextFormat(begin, end);
		 	txtFormat.color = color;
			txtField.setTextFormat(txtFormat, begin, end);
		  
		}
	}
}
