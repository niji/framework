package org.libspark.gunyarapaint.framework.errors
{
    public final class LockedLayerError extends Error
    {
        public function LockedLayerError()
        {
            var message:String = "The current layer is locked";
            name = "LockedLayerError";
            super(message, 0);
        }
    }
}
