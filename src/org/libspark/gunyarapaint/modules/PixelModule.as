package org.libspark.gunyarapaint.modules
{
    import org.libspark.gunyarapaint.Painter;
    import org.libspark.gunyarapaint.Recorder;
    import org.libspark.gunyarapaint.commands.PixelCommand;
    
    public class PixelModule extends DrawModule implements IDrawable
    {
        public function PixelModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setPixel(x, y);
            m_drawing = true;
        }
        
        public function move(x:Number, y:Number):void
        {
            if (m_drawing)
                setPixel(x, y);
        }
        
        public function stop(x:Number, y:Number):void
        {
            m_drawing = false;
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            move(x, y);
            stop(x, y);
        }
        
        private function setPixel(x:Number, y:Number):void
        {
            commitCommand(
                m_logger.getCommand(PixelCommand.ID),
                getArgumentsFromCoordinate(x, y)
            );
        }
    }
}