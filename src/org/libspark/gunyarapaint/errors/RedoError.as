package org.libspark.gunyarapaint.errors
{
    public final class RedoError extends Error
    {
        public function RedoError()
        {
            var message:String = "Cannot redo any more";
            super(message, 0);
        }
    }
}