package org.libspark.gunyarapaint.framework.modules
{
    import flash.display.BlendMode;
    
    import org.libspark.gunyarapaint.framework.Pen;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    public final class TransparentLineModule extends CanvasModule implements ICanvasModule
    {
        public static const TRANSPARENT_LINE:String = PREFIX + "transparentLine";
        
        public function TransparentLineModule(recorder:Recorder)
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
            var pen:Pen = m_recorder.pen;
            var blendMode:String = pen.blendMode;
            pen.blendMode = BlendMode.ERASE;
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.moveTo(coordinateX, coordinateY);
            m_recorder.lineTo(x, y);
            pen.blendMode = blendMode;
        }
        
        public function stop(x:Number, y:Number):void
        {
            var pen:Pen = m_recorder.pen;
            var currentBlendMode:String = pen.blendMode;
            m_recorder.stopDrawingSession();
            if (!equalsCoordinate(x, y)) {
                var from:Object = getArgumentsFromCurrentCoordinate();
                var to:Object = getArgumentsFromCoordinate(x, y);
                blendMode = BlendMode.ERASE;
                m_recorder.commitCommand(MoveToCommand.ID, from);
                m_recorder.commitCommand(LineToCommand.ID, to);
                m_recorder.commitCommand(CompositeCommand.ID, {});
                blendMode = currentBlendMode;
            }
            pen.blendMode = currentBlendMode;
            saveCoordinate(x, y);
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        public function get name():String
        {
            return TRANSPARENT_LINE;
        }
    }
}
