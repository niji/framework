package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * ログが終端に達した場合に作成される例外クラスです
     */
    public final class EOLError extends Error
    {
        /**
         * コンストラクタ
         */
        public function EOLError()
        {
            name = "EOLError";
            super(TranslatorRegistry.tr("Log has been reached to the end"), 0);
        }
    }
}