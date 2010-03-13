package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    public final class RectModule extends CanvasModule implements ICanvasModule
    {
        public static const RECT:String = "rect";
        
        public function RectModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawingSession();
        }
        
        public function move(x:Number, y:Number):void
        {
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.drawRect(
                coordinateX,
                coordinateY,
                Math.abs(x - coordinateX),
                Math.abs(y - coordinateY)
            );
        }
        
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawingSession();
            if (!equalsCoordinate(x, y)) {
                // TODO: implement this
            }
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        public function get name():String
        {
            return RECT;
        }
    }
}