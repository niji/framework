package org.libspark.gunyarapaint.framework.errors
{
    /**
     * サポートされていないログのバージョンに対して再生を行おうとした時に作成される
     * 
     */
    public final class NotSupportedVersionError extends Error
    {
        public function NotSupportedVersionError(version:String)
        {
            var message:String = "Tried loading not supported version's log ("
                + version + ")";
            name = "NotSupportedVersionError";
            super(message, 0);
        }
    }
}
