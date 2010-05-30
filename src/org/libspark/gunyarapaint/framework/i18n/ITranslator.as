package org.libspark.gunyarapaint.framework.i18n
{
	/**
	 * 翻訳するクラスのインターフェース
	 * 
	 */	
    public interface ITranslator
    {
		/**
		 * 文字列から現在のロケールに合わせて翻訳を行う
		 * 
		 * @param str 翻訳する文字列
		 * @param rest 翻訳する文字列に対する引数
		 * @return 翻訳した文字列
		 * 
		 */		
        function translate(str:String, ...rest):String;
    }
}
