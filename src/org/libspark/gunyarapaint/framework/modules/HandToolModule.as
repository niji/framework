package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    internal final class HandToolModule extends DrawModule implements IDrawable
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
        
        public function get name():String
        {
            return "";
        }
    }
}