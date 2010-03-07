package org.libspark.gunyarapaint.framework.errors
{
    /**
     * 登録されていないコマンドを呼び出そうとしたときに作成される
     * 
     */
    public final class InvalidCommandError extends Error
    {
        public function InvalidCommandError(count:uint, command:uint)
        {
            var message:String = command + " is not found at " +count;
            name = "InvalidCommandError";
            super(message, 0);
        }
    }
}
