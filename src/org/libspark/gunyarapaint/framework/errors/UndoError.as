package org.libspark.gunyarapaint.framework.errors
{
    public final class UndoError extends Error
    {
        public function UndoError()
        {
            var message:String = "Cannot undo any more";
            super(message, 0);
        }
    }
}