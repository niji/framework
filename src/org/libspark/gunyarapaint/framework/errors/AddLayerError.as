package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    public final class AddLayerError extends Error
    {
        public function AddLayerError(max:uint)
        {
            name = "AddLayerError";
            super(TranslatorRegistry.tr("Cannot create a layer more than %s", max), 0);
        }
    }
}
