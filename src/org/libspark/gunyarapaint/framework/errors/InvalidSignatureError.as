package org.libspark.gunyarapaint.errors
{
    public final class InvalidSignatureError extends Error
    {
        public function InvalidSignatureError()
        {
            var message:String = "Tried loading invalid signature log";
            super(message, 0);
        }
    }
}