package org.libspark.gunyarapaint.framework.i18n
{
	/**
	 * 翻訳するクラスのインターフェースです
	 * 
	 */	
    public interface ITranslator
    {
		/**
		 * 文字列から現在のロケールに合わせて翻訳を行ないます
		 * 
		 * @param str 翻訳する文字列のフォーマット
		 * @param rest 翻訳する文字列に対する引数
		 * @return 翻訳した文字列
		 */		
        function translate(str:String, ...rest):String;
    }
}
