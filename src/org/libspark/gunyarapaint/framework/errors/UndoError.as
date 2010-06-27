package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * これ以上やり直しが出来ないときに作成される例外クラスです
     */
    public final class UndoError extends Error
    {
        /**
         * コンストラクタ
         */
        public function UndoError()
        {
            name = "UndoError";
            super(TranslatorRegistry.tr("Cannot undo any more"), 0);
        }
    }
}
