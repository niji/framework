package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;

    /**
     * ロック(描写禁止)されているレイヤーに対して描写を行う時に作成される例外クラスです
     * 
     */
    public final class LockedLayerError extends Error
    {
        /**
         * コンストラクタ
         */
        public function LockedLayerError()
        {
            name = "LockedLayerError";
            super(TranslatorRegistry.tr("The current layer is locked"), 0);
        }
    }
}
