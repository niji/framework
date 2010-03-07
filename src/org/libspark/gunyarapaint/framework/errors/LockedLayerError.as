package org.libspark.gunyarapaint.framework.errors
{
    /**
     * ロック(描写禁止)されているレイヤーに対して描写を行う時に作成される
     * 
     */
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
