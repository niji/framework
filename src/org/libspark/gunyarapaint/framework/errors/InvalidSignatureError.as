package org.libspark.gunyarapaint.framework.errors
{
    public final class InvalidSignatureError extends Error
    {
        public function InvalidSignatureError()
        {
            var message:String = "Tried loading invalid signature log";
            name = "InvalidSignatureError";
            super(message, 0);
        }
    }
}
