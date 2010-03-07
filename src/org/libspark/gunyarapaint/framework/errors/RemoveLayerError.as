package org.libspark.gunyarapaint.framework.errors
{
    /**
     * レイヤーがひとつしか無いときに削除しようとした場合に作成される
     * 
     */
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
