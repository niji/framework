package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * レイヤー統合時にレイヤーが一つ、あるいは統合対象のレイヤーのどちらか
     * が非表示の場合に作成される例外クラスです
     */
    public final class MergeLayersError extends Error
    {
        /**
         * コンストラクタ
         */
        public function MergeLayersError()
        {
            name = "MergeLayersError";
            super(TranslatorRegistry.tr("Cannot merge layers because there is only one layer or invisible layer is found"), 0);
        }
    }
}
