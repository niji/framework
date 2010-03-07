package org.libspark.gunyarapaint.framework.errors
{
    /**
     * これ以上巻き戻しが出来ないときに作成される
     * 
     */
    public final class RedoError extends Error
    {
        public function RedoError()
        {
            var message:String = "Cannot redo any more";
            name = "RedoError";
            super(message, 0);
        }
    }
}
