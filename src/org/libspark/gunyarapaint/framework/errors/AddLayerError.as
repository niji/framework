package org.libspark.gunyarapaint.framework.errors
{
    import org.libspark.gunyarapaint.framework.i18n.TranslatorRegistry;
	
	/**
	 * 規定のレイヤー数を超えて作成しようとした場合に作成される例外クラスです
	 */
    public final class AddLayerError extends Error
    {
        /**
         * コンストラクタ
         * 
         * @param max レイヤーの最大値
         */
        public function AddLayerError(max:uint)
        {
            name = "AddLayerError";
            super(TranslatorRegistry.tr("Cannot create a layer more than %s", max), 0);
        }
    }
}
