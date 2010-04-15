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
        public static const TRANSPARENT_LINE:String = "transparentLine";
        
        public function TransparentLineModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_blendMode = m_recorder.layers.currentLayer.blendMode;
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
            m_recorder.stopDrawingSession();
            if (!equalsCoordinate(x, y)) {
                var from:Object = getArgumentsFromCurrentCoordinate();
                var to:Object = getArgumentsFromCoordinate(x, y);
                blendMode = BlendMode.ERASE;
                m_recorder.commitCommand(MoveToCommand.ID, from);
                m_recorder.commitCommand(LineToCommand.ID, to);
                m_recorder.commitCommand(CompositeCommand.ID, {});
                blendMode = m_blendMode;
            }
            m_recorder.currentLayerBlendMode = m_blendMode;
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
        
        private var m_blendMode:String;
    }
}
