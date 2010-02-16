package org.libspark.gunyarapaint.errors
{
    public final class EOLError extends Error
    {
        public function EOLError()
        {
            super("Log has been reached to the end", 0);
        }
    }
}