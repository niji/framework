package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;
	
	/**
	 * 指定されたバージョンより上のふっかつのじゅもんのログを読み込もうとした場合に作成される例外クラスです
	 */
    public final class MarshalVersionError extends Error
    {
        /**
         * コンストラクタ
         * 
         * @param actual 読み込まれたログのバージョン
         * @param expected バージョンの上限
         */
        public function MarshalVersionError(actual:uint, expected:uint)
        {
            name = "MarshalVersionError";
            super(TranslatorRegistry.tr(
                "Cannot load this file: actual version = %s, expected version = %s",
                actual, expected), 0);
        }
    }
}
