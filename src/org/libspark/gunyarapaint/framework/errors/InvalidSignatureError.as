package org.libspark.gunyarapaint.framework.errors
{
    /**
     * ログの最初の識別子が一致しない場合に作成される
     * 
     */
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
