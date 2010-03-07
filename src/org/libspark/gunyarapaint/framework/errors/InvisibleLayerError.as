package org.libspark.gunyarapaint.framework.errors
{
    /**
     * 非表示レイヤーに対して描写を行う時にに作成される
     * 
     */
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
