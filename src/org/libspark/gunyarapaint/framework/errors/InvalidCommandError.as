package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * 登録されていないコマンドを呼び出そうとしたときに作成される例外クラスです
     */
    public final class InvalidCommandError extends Error
    {
        /**
         * コンストラクタ
         * 
         * @param count 例外を発生したログの位置
         * @param command コマンドの番号
         */
        public function InvalidCommandError(count:uint, command:uint)
        {
            name = "InvalidCommandError";
            super(TranslatorRegistry.tr("%s is not found at %s", command, count), 0);
        }
    }
}
