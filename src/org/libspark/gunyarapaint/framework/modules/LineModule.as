package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    /**
     * 直線描写ツールの実装
     */
    public final class LineModule extends CanvasModule implements ICanvasModule
    {
        public static const LINE:String = PREFIX + "line";
        
        public function LineModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawing();
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.moveTo(coordinateX, coordinateY);
            m_recorder.lineTo(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                var from:Object = getArgumentsFromCurrentCoordinate();
                var to:Object = getArgumentsFromCoordinate(x, y);
                m_recorder.commitCommand(MoveToCommand.ID, from);
                m_recorder.commitCommand(LineToCommand.ID, to);
                m_recorder.commitCommand(CompositeCommand.ID, {});
            }
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
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