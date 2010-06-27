package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * 投稿時にレイヤー数が一定数を超えた場合に作成される例外クラスです
     */
    public final class TooManyLayersError extends Error
    {
        /**
         * コンストラクタ
         * 
         * @param count 許容する最大値
         */
        public function TooManyLayersError(count:uint)
        {
            name = "TooManyLayersError";
            super(TranslatorRegistry.tr("Try reduce layers to %s", count), 0);
        }
    }
}
