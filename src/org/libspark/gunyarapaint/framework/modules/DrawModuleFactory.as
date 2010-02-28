package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;

    public final class DrawModuleFactory
    {
        public static const CIRCLE:String = "circle";
        
        public static const DROPPER:String = "dropper";
        
        public static const ELLIPSE:String = "ellipse";
        
        public static const ERASER:String = "eraser";
        
        public static const FLOOD_FILL:String = "floodFill";
        
        public static const FREE_HAND:String = "freeHand";
        
        public static const LINE:String = "line";
        
        public static const PIXEL:String = "pixel";
        
        public static const RECT:String = "rect";
        
        public static const ROUND_RECT:String = "roundRect";
        
        public function DrawModuleFactory()
        {
            throw new ArgumentError();
        }
        
        public static function create(name:String, recorder:Recorder):IDrawable
        {
            switch (name) {
                case CIRCLE:
                    return new CircleModule(recorder);
                case DROPPER:
                    return new DropperModule(recorder);
                case ELLIPSE:
                    return new EllipseModule(recorder);
                case ERASER:
                    return new EraserModule(recorder);
                case FLOOD_FILL:
                    return new FloodFillModule(recorder);
                case FREE_HAND:
                    return new FreeHandModule(recorder);
                case LINE:
                    return new LineModule(recorder);
                case PIXEL:
                    return new PixelModule(recorder);
                case RECT:
                    return new RectModule(recorder);
                case ROUND_RECT:
                    return new RoundRectModule(recorder);
                default:
                    throw new ArgumentError();
                    break;
            }
        }
    }
}
