package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    /**
     * 楕円長方形描写ツールの実装
     */
    public final class RoundRectModule extends CanvasModule implements ICanvasModule
    {
        public static const ROUND_RECT:String = PREFIX + "roundRect";
        
        public function RoundRectModule(recorder:Recorder)
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
            // TODO: implement this
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                // TODO: implement this
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
            return ROUND_RECT;
        }
    }
}