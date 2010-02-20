package org.libspark.gunyarapaint.framework.errors
{
    public final class EOLError extends Error
    {
        public function EOLError()
        {
            super("Log has been reached to the end", 0);
        }
    }
}