package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;

	/**
	 * ICanvasModule を管理するクラス
	 * 
	 */	
    public final class CanvasModuleContext
    {
        public function CanvasModuleContext(recorder:Recorder)
        {
            m_modules = {};
            registerModule(new CircleModule(recorder));
            registerModule(new DropperModule(recorder));
            registerModule(new EllipseModule(recorder));
            registerModule(new FloodFillModule(recorder));
            registerModule(new FreeHandModule(recorder));
            registerModule(new LineModule(recorder));
            registerModule(new PixelModule(recorder));
            registerModule(new RectModule(recorder));
            registerModule(new RoundRectModule(recorder));
            registerModule(new TransparentFloodFill(recorder));
            registerModule(new TransparentLineModule(recorder));
        }
        
		/**
		 * ICanvasModule を登録して利用出来るようにする
		 * 
		 * @param module ICanvasModule を実装したクラス
		 */		
        public function registerModule(module:ICanvasModule):void
        {
            m_modules[module.name] = module;
        }
        
		/**
		 * ICanvasModule#name に対応するモジュールID から ICanvasModule を実装したクラスを返す
		 * 
		 * @param name モジュールID
		 * @return ICanvasModule を実装したクラス
		 */		
        public function getModule(name:String):ICanvasModule
        {
            return m_modules[name];
        }
        
        private var m_modules:Object;
    }
}
