package org.libspark.gunyarapaint.framework.i18n
{
	/**
	 * @private
	 */
    public final class NullTranslator implements ITranslator
    {
        public function NullTranslator()
        {
        }
        
        public function translate(str:String, ...rest):String
        {
            var args:Array = rest[0].slice();
            return str.replace(/%s/g, function():String
            {
                return args.shift();
            });
        }
    }
}
