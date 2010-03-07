package org.libspark.gunyarapaint.framework.errors
{
    /**
     * レイヤー統合時にレイヤーが一つ、あるいは統合対象のレイヤーのどちらかが非表示の場合に作成される
     * 
     */
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
