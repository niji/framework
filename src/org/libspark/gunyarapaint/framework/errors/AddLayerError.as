package org.libspark.gunyarapaint.framework.errors
{
    public final class AddLayerError extends Error
    {
        public function AddLayerError(max:uint)
        {
            var message:String = "Cannot create a layer more than " + max;
            name = "AddLayerError";
            super(message, 0);
        }
    }
}
