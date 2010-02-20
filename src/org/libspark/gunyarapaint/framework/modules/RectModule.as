package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.Recorder;
    
    public class RectModule extends DrawModule implements IDrawable
    {
        public function RectModule(recorder:Recorder)
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
            if (m_drawing) {
                var painter:Painter = m_recorder.painter;
                var fromX:int = painter.roundPixel(coordinateX);
                var fromY:int = painter.roundPixel(coordinateY);
                var toX:int = painter.roundPixel(x);
                var toY:int = painter.roundPixel(y);
                painter.clear();
                painter.resetPen();
                painter.drawRect(
                    fromX,
                    fromY,
                    Math.abs(toX - fromX),
                    Math.abs(toY - fromY)
                );
            }
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
    }
}