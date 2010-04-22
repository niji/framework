package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    public final class EllipseModule extends CanvasModule implements ICanvasModule
    {
        public static const ELLIPSE:String = PREFIX + "ellipse";
        
        public function EllipseModule(recorder:Recorder)
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
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.drawEllipse(
                coordinateX,
                coordinateY,
                Math.abs(x - coordinateX),
                Math.abs(y - coordinateY)
            );
        }
        
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                // TODO: implement this
            }
            saveCoordinate(x, y);
        }
        
        public function get name():String
        {
            return ELLIPSE;
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
    }
}