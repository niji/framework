package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * これ以上巻き戻しが出来ないときに作成される例外クラスです
     */
    public final class RedoError extends Error
    {
        /**
         * コンストラクタ
         */
        public function RedoError()
        {
            name = "RedoError";
            super(TranslatorRegistry.tr("Cannot redo any more"), 0);
        }
    }
}
