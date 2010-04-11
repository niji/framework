package org.libspark.gunyarapaint.framework.i18n
{
    public final class TranslatorRegistry
    {
        public static function install(translator:ITranslator):void
        {
            s_translator = translator;
        }
        
        public static function get translator():ITranslator
        {
            return s_translator;
        }
        
        public static function tr(str:String, ...rest):String
        {
            return s_translator.translate(str, rest);
        }
        
        private static var s_translator:ITranslator = new NullTranslator();
    }
}
