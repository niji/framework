package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * レイヤーがひとつしか無いときに削除しようとした場合に作成される
     * 
     */
    public final class RemoveLayerError extends Error
    {
        public function RemoveLayerError()
        {
            name = "RemoveLayerError";
            super(TranslatorRegistry.tr("Cannot remove the layer because there is only one layer"), 0);
        }
    }
}
