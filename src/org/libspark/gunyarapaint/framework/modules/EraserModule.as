package org.libspark.gunyarapaint.modules
{
    import org.libspark.gunyarapaint.Recorder;
    
    public class EraserModule extends DrawModule implements IDrawable
    {
        public function EraserModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_drawing = true;
        }
        
        public function move(x:Number, y:Number):void
        {
        }
        
        public function stop(x:Number, y:Number):void
        {
        }
        
        public function interrupt(x:Number, y:Number):void
        {
        }
    }
}