package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * 非表示レイヤーに対して描写を行う時にに作成される
     * 
     */
    public final class InvisibleLayerError extends Error
    {
        public function InvisibleLayerError()
        {
            name = "LockedLayerError";
            super(TranslatorRegistry.tr("The current layer is invisible"), 0);
        }
    }
}
