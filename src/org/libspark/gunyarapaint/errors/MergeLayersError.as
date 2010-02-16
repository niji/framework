package org.libspark.gunyarapaint.errors
{
    public final class MergeLayersError extends Error
    {
        public function MergeLayersError()
        {
            var message:String = "Cannot merge layers because both layers are invisible";
            super(message, 0);
        }
    }
}