package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    internal final class RoundRectModule extends DrawModule implements IDrawable
    {
        public function RoundRectModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.painter.startDrawingSession();
            m_drawing = true;
        }
        
        public function move(x:Number, y:Number):void
        {
            // TODO: implement this
        }
        
        public function stop(x:Number, y:Number):void
        {
            if (m_drawing) {
                m_recorder.painter.stopDrawingSession();
                if (!equalsCoordinate(x, y)) {
                    // TODO: implement this
                }
                m_drawing = false;
            }
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        public function get name():String
        {
            return DrawModuleFactory.ROUND_RECT;
        }
    }
}