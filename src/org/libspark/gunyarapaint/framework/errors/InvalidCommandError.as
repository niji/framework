package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * 登録されていないコマンドを呼び出そうとしたときに作成される
     * 
     */
    public final class InvalidCommandError extends Error
    {
        public function InvalidCommandError(count:uint, command:uint)
        {
            name = "InvalidCommandError";
            super(TranslatorRegistry.tr("%s is not found at %s", command, count), 0);
        }
    }
}
