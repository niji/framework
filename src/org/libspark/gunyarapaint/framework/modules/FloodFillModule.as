package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.FloodFillCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    public final class FloodFillModule extends CanvasModule implements ICanvasModule
    {
        public static const FLOOD_FILL:String = "floodFill";
        
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
            return FLOOD_FILL;
        }
    }
}