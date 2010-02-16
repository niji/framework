package org.libspark.gunyarapaint.errors
{
    public final class NotSupportedVersionError extends Error
    {
        public function NotSupportedVersionError(version:String)
        {
            var message:String = "Tried loading not supported version's log ("
                + version + ")";
            super(message, 0);
        }
    }
}