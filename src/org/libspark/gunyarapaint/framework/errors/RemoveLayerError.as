package org.libspark.gunyarapaint.framework.errors
{
    public final class RemoveLayerError extends Error
    {
        public function RemoveLayerError()
        {
            var message:String = "Cannot remove the layer because there is "
                + "only one layer";
            name = "RemoveLayerError";
            super(message, 0);
        }
    }
}
