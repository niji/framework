package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    
    public final class DropperModule extends DrawModule implements IDrawable
    {
        public static const DROPPER:String = "dropper";
        
        public function DropperModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        public function move(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        public function stop(x:Number, y:Number):void
        {
            drop(x, y);
        }
        
        public function interrupt(x:Number, y:Number):void
        {
        }
        
        public function get name():String
        {
            return DROPPER;
        }
        
        private function drop(x:Number, y:Number):void
        {
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