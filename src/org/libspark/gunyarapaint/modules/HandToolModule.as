package org.libspark.gunyarapaint.modules
{
    import org.libspark.gunyarapaint.Recorder;
    
    public class HandToolModule extends DrawModule implements IDrawable
    {
        public function HandToolModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
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