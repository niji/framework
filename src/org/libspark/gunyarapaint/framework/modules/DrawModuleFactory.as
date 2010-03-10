package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;

    public final class DrawModuleFactory
    {
        public function DrawModuleFactory(recorder:Recorder)
        {
            m_modules = {};
            add(new CircleModule(recorder));
            add(new DropperModule(recorder));
            add(new EllipseModule(recorder));
            add(new EraserModule(recorder));
            add(new FloodFillModule(recorder));
            add(new FreeHandModule(recorder));
            add(new LineModule(recorder));
            add(new PixelModule(recorder));
            add(new RectModule(recorder));
            add(new RoundRectModule(recorder));
        }
        
        public function add(module:IDrawable):void
        {
            m_modules[module.name] = module;
        }
        
        public function create(name:String):IDrawable
        {
            return m_modules[name];
        }
        
        private var m_modules:Object;
    }
}
