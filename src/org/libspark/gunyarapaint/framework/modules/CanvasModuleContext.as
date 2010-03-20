package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;

    // TODO: CanvasModuleContext
    public final class CanvasModuleContext
    {
        public function CanvasModuleContext(recorder:Recorder)
        {
            m_modules = {};
            add(new CircleModule(recorder));
            add(new DropperModule(recorder));
            add(new EllipseModule(recorder));
            add(new FloodFillModule(recorder));
            add(new FreeHandModule(recorder));
            add(new LineModule(recorder));
            add(new PixelModule(recorder));
            add(new RectModule(recorder));
            add(new RoundRectModule(recorder));
            add(new TransparentFloodFill(recorder));
        }
        
        public function add(module:ICanvasModule):void
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
