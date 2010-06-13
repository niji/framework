package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    
    /**
     * スポイトツールの実装
     */ 
    public final class DropperModule extends CanvasModule implements ICanvasModule
    {
        public static const DROPPER:String = PREFIX + "dropper";
        
        public function DropperModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            drop(x, y);
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return DROPPER;
        }
        
        private function drop(x:Number, y:Number):void
        {
            var color:uint = m_recorder.getPixel(x, y);
            if (m_recorder.pen.color != color) {
                m_recorder.commitCommand(
                    PenCommand.ID,
                    {
                        "type": PenCommand.COLOR,
                        "color": m_recorder.getPixel(x, y)
                    }
                );
            }
        }
    }
}