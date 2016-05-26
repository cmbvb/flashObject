package com.canaan.programEditor.core
{
	public class Tokens
	{
		private var jsonString:String;
		private var ch:String;
		private var loc:int=0;
		
		public function Tokens(_jsonString)
		{
			jsonString = _jsonString;
		}
		public function Parse():Array{
			var arr:Array = [];
			nextChar();
			var str:String=getNextToken();
			while(str.length>0){
				arr.push(str);
				str=getNextToken();
			}
			return arr;
		}
		private function nextChar():String {
			return ch = jsonString.charAt( loc++ );
		}
		public function getNextToken():String {
			skipWhite();//跳过空白
			var token:String ="";
			do{
				if(isWhiteSpace(ch)){
					if(token.length>0){
						return token;
					}
				}else{
					token+=ch;
				}
			}while(nextChar());
			return token;
		}
		private function skipIgnored():void {
			skipWhite();
		}
		/**
		 * Skip any whitespace in the input string and advances
		 * the character to the first character after any possible
		 * whitespace.
		 */
		private function skipWhite():void {
			
			// As long as there are spaces in the input 
			// stream, advance the current location pointer
			// past them
			while ( isWhiteSpace( ch ) ) {
				nextChar();
			}
			
		}
		/**
		 * Determines if a character is whitespace or not.
		 *
		 * @return True if the character passed in is a whitespace
		 *	character
		 */
		private function isWhiteSpace( ch:String ):Boolean {
			return ( ch == ' ' || ch == '\t' || ch == '\n' || ch == ';'|| ch == '/' || ch == ',');
		}
		
		/**
		 * Determines if a character is a digit [0-9].
		 *
		 * @return True if the character passed in is a digit
		 */
		private function isDigit( ch:String ):Boolean {
			return ( ch >= '0' && ch <= '9' );
		}
		
	}
}