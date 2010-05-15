package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * 投稿時にレイヤー数が一定数を超えた場合に作成される
     * 
     */
    public final class TooManyLayersError extends Error
    {
        public function TooManyLayersError(count:uint)
        {
            name = "TooManyLayersError";
            super(TranslatorRegistry.tr("Try reduce layers to %s", count), 0);
        }
    }
}
