package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;

    // TODO: CanvasModuleContext
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
        }
        
        public function registerModule(module:ICanvasModule):void
        {
            m_modules[module.name] = module;
        }
        
        public function getModule(name:String):ICanvasModule
        {
            return m_modules[name];
        }
        
        private var m_modules:Object;
    }
}
