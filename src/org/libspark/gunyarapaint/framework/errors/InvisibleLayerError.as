package org.libspark.gunyarapaint.framework.errors
{
    public final class InvisibleLayerError extends Error
    {
        public function InvisibleLayerError()
        {
            var message:String = "The current layer is invisible";
            name = "LockedLayerError";
            super(message, 0);
        }
    }
}
