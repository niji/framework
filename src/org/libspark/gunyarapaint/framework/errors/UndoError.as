package org.libspark.gunyarapaint.framework.errors
{
    /**
     * これ以上やり直しが出来ないときに作成される
     * 
     */
    public final class UndoError extends Error
    {
        public function UndoError()
        {
            var message:String = "Cannot undo any more";
            name = "UndoError";
            super(message, 0);
        }
    }
}
