package org.libspark.gunyarapaint.framework.i18n
{
	/**
	 * ITranslator を実装するクラスを管理するグローバルなクラスです
	 */
    public final class TranslatorRegistry
    {
		/**
		 * ITranslator を実装したクラスをインストールして利用出来るようにします
		 * 
		 * @param translator ITranslator を実装したクラス
		 */
        public static function install(translator:ITranslator):void
        {
            s_translator = translator;
        }
		
		/**
		 * ITranslator を実装したクラスを返します
		 * 
		 * @return ITranslator を実装したオブジェクト
		 */
        public static function get translator():ITranslator
        {
            return s_translator;
        }
        
		/**
		 * ITranslator#translate() のショートカット
		 * 
		 * @param str 翻訳する文字列のフォーマット
		 * @param rest 翻訳する文字列に対する引数
		 * @return 翻訳した文字列
         * @see ITranslator#translate()
		 */
        public static function tr(str:String, ...rest):String
        {
            return s_translator.translate(str, rest);
        }
        
        private static var s_translator:ITranslator = new NullTranslator();
    }
}
