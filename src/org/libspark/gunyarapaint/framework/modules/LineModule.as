package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    internal final class LineModule extends DrawModule implements IDrawable
    {
        public function LineModule(recorder:Recorder)
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
                painter.moveTo(fromX, fromY);
                painter.lineTo(toX, toY);
            }
        }
        
        public function stop(x:Number, y:Number):void
        {
            if (m_drawing) {
                m_recorder.painter.stopDrawingSession();
                if (!equalsCoordinate(x, y)) {
                    var from:Object = getArgumentsFromCurrentCoordinate();
                    var to:Object = getArgumentsFromCoordinate(x, y);
                    commitCommand(m_logger.getCommand(MoveToCommand.ID), from);
                    commitCommand(m_logger.getCommand(LineToCommand.ID), to);
                    commitCommand(m_logger.getCommand(CompositeCommand.ID), {});
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
            return DrawModuleFactory.LINE;
        }
    }
}