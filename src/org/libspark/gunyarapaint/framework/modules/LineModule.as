package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    public final class LineModule extends DrawModule implements IDrawable
    {
        public static const LINE:String = "line";
        
        public function LineModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawingSession();
            m_drawing = true;
        }
        
        public function move(x:Number, y:Number):void
        {
            if (m_drawing) {
                m_recorder.clear();
                m_recorder.resetPen();
                m_recorder.moveTo(coordinateX, coordinateY);
                m_recorder.lineTo(x, y);
            }
        }
        
        public function stop(x:Number, y:Number):void
        {
            if (m_drawing) {
                m_recorder.stopDrawingSession();
                if (!equalsCoordinate(x, y)) {
                    var from:Object = getArgumentsFromCurrentCoordinate();
                    var to:Object = getArgumentsFromCoordinate(x, y);
                    m_recorder.commitCommand(MoveToCommand.ID, from);
                    m_recorder.commitCommand(LineToCommand.ID, to);
                    m_recorder.commitCommand(CompositeCommand.ID, {});
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
            return LINE;
        }
    }
}