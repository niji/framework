package org.libspark.gunyarapaint.framework.errors
{
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
