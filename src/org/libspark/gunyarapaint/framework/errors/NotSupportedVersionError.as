package org.libspark.gunyarapaint.framework.errors
{
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
