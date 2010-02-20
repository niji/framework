package org.libspark.gunyarapaint.framework.errors
{
    public final class InvalidCommandError extends Error
    {
        public function InvalidCommandError(count:uint, command:uint)
        {
            var message:String = command + " is not found at " +count;
            super(message, 0);
        }
    }
}