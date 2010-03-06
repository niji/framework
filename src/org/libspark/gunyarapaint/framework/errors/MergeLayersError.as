package org.libspark.gunyarapaint.framework.errors
{
    public final class MergeLayersError extends Error
    {
        public function MergeLayersError()
        {
            var message:String = "Cannot merge layers because there is only one layer or invisible layer is found";
            name = "MergeLayersError";
            super(message, 0);
        }
    }
}
