package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.PixelCommand;
    
    /**
     * ドット描写ツールの実装
     */
    public final class PixelModule extends CanvasModule implements ICanvasModule
    {
        public static const PIXEL:String = PREFIX + "pixel";
        
        public function PixelModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setPixel(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            setPixel(x, y);
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
            move(x, y);
            stop(x, y);
        }
        
        private function setPixel(x:Number, y:Number):void
        {
            m_recorder.commitCommand(
                PixelCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
        }
        
        public function get name():String
        {
            return PIXEL;
        }
    }
}