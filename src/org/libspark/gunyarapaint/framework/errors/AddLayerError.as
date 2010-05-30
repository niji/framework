package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;
	
	/**
	 * 規定のレイヤー数を超えて作成しようとした場合に作成される
	 * 
	 */
    public final class AddLayerError extends Error
    {
        public function AddLayerError(max:uint)
        {
            name = "AddLayerError";
            super(TranslatorRegistry.tr("Cannot create a layer more than %s", max), 0);
        }
    }
}
