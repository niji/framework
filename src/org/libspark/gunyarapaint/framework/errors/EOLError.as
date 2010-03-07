package org.libspark.gunyarapaint.framework.errors
{
    /**
     * ログが終端に達した場合に作成される
     * 
     */
    public final class EOLError extends Error
    {
        public function EOLError()
        {
            name = "EOLError";
            super("Log has been reached to the end", 0);
        }
    }
}