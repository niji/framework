package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * 非表示レイヤーに対して描写を行う時にに作成される例外クラスです
     * 
     */
    public final class InvisibleLayerError extends Error
    {
        /**
         * コンストラクタ
         */
        public function InvisibleLayerError()
        {
            name = "LockedLayerError";
            super(TranslatorRegistry.tr("The current layer is invisible"), 0);
        }
    }
}
