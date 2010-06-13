package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    /**
     * バケツ塗りつぶしツールの実装
     */
    public final class FloodFillModule extends CanvasModule implements ICanvasModule
    {
        public static const FLOOD_FILL:String = PREFIX + "floodFill";
        
        public function FloodFillModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
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
            return FLOOD_FILL;
        }
    }
}