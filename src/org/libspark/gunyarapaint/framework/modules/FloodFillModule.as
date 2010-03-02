package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    internal final class FloodFillModule extends DrawModule implements IDrawable
    {
        public function FloodFillModule(recorder:Recorder)
        {
            super(recorder);
        }
        
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
        
        public function move(x:Number, y:Number):void
        {
        }
        
        public function stop(x:Number, y:Number):void
        {
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        public function get name():String
        {
            return DrawModuleFactory.FLOOD_FILL;
        }
    }
}