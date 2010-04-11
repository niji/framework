package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * サポートされていないログのバージョンに対して再生を行おうとした時に作成される
     * 
     */
    public final class NotSupportedVersionError extends Error
    {
        public function NotSupportedVersionError(version:String)
        {
            name = "NotSupportedVersionError";
            super(TranslatorRegistry.tr("Tried loading not supported version's log (%s)", version), 0);
        }
    }
}
