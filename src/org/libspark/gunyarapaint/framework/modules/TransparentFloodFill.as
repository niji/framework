package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Pen;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    /**
     * 透明塗りつぶし描写ツールの実装
     */
    public final class TransparentFloodFill extends CanvasModule implements ICanvasModule
    {
        public static const TRANSPARENT_FLOOD_FILL:String = PREFIX + "transparentFloodFill";
        
        public function TransparentFloodFill(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            var pen:Pen = m_recorder.pen;
            validateLayerState();
            m_alpha = pen.alpha;
            m_color = pen.color;
            alpha = 0;
            color = 0;
            m_recorder.commitCommand(
                MoveToCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
            m_recorder.commitCommand(
                FloodFillCommand.ID,
                {}
            );
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            alpha = m_alpha;
            color = m_color;
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
            alpha = m_alpha;
            color = m_color;
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return TRANSPARENT_FLOOD_FILL;
        }
        
        private var m_alpha:Number;
        private var m_color:uint;
    }
}