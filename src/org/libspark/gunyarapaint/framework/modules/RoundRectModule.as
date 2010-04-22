package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    public final class RoundRectModule extends CanvasModule implements ICanvasModule
    {
        public static const ROUND_RECT:String = PREFIX + "roundRect";
        
        public function RoundRectModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawing();
        }
        
        public function move(x:Number, y:Number):void
        {
            // TODO: implement this
        }
        
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                // TODO: implement this
            }
            saveCoordinate(x, y);
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        public function get name():String
        {
            return ROUND_RECT;
        }
    }
}