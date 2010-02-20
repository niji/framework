package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    
    public class DropperModule extends DrawModule implements IDrawable
    {
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
        
        private function drop(x:Number, y:Number):void
        {
            // TODO: implement this
            commitCommand(
                m_logger.getCommand(PenCommand.ID),
                {
                    "type": PenCommand.COLOR,
                    "color": m_recorder.painter.getPixel(x, y)
                }
            );
        }
    }
}