package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Pen;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.BeginFillCommand;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.framework.commands.EndFillCommand;
    import org.libspark.gunyarapaint.framework.commands.LineToCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    import org.libspark.gunyarapaint.framework.commands.PenCommand;
    
    public final class FreeHandModule extends CanvasModule implements ICanvasModule
    {
        public static const FREE_HAND:String = PREFIX + "freeHand";
        
        public function FreeHandModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.commitCommand(
                MoveToCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
        }
        
        public function move(x:Number, y:Number):void
        {
            m_recorder.commitCommand(
                LineToCommand.ID,
                getArgumentsFromCoordinate(x, y)
            );
            m_drawedLine = true;
        }
        
        public function stop(x:Number, y:Number):void
        {
            if (!m_drawedLine) {
                var pen:Pen = m_recorder.pen;
                var tempAlpha:Number = pen.alpha;
                m_recorder.commitCommand(
                    PenCommand.ID,
                    {
                        "type": PenCommand.ALPHA,
                        "alpha": 0
                    }
                );
                m_recorder.commitCommand(
                    BeginFillCommand.ID,
                    {
                        "color": pen.color,
                        "alpha": tempAlpha
                    }
                );
                m_recorder.commitCommand(
                    DrawCircleCommand.ID,
                    { "radius": pen.thickness / 2 }
                );
                m_recorder.commitCommand(EndFillCommand.ID, {});
                m_recorder.commitCommand(
                    PenCommand.ID,
                    {
                        "type": PenCommand.ALPHA,
                        "alpha": tempAlpha
                    }
                );
                m_drawedLine = false;
            }
            m_recorder.commitCommand(
                CompositeCommand.ID,
                {}
            );
            saveCoordinate(x, y);
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            move(x, y);
            stop(x, y);
        }
        
        public function get name():String
        {
            return FREE_HAND;
        }
        
        private var m_drawedLine:Boolean;
    }
}