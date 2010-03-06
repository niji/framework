package org.libspark.gunyarapaint.framework.errors
{
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
