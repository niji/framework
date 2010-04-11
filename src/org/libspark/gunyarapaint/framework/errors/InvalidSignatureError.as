package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * ログの最初の識別子が一致しない場合に作成される
     * 
     */
    public final class InvalidSignatureError extends Error
    {
        public function InvalidSignatureError()
        {
            name = "InvalidSignatureError";
            super(TranslatorRegistry.tr("Tried loading invalid signature log"), 0);
        }
    }
}
