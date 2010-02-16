package org.libspark.gunyarapaint.modules
{
    import org.libspark.gunyarapaint.Pen;
    import org.libspark.gunyarapaint.Recorder;
    import org.libspark.gunyarapaint.commands.BeginFillCommand;
    import org.libspark.gunyarapaint.commands.CompositeCommand;
    import org.libspark.gunyarapaint.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.commands.EndFillCommand;
    import org.libspark.gunyarapaint.commands.LineToCommand;
    import org.libspark.gunyarapaint.commands.MoveToCommand;
    import org.libspark.gunyarapaint.commands.PenCommand;
    
    public class FreeHandModule extends DrawModule implements IDrawable
    {
        public function FreeHandModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_drawing = true;
            commitCommand(
                m_logger.getCommand(MoveToCommand.ID),
                getArgumentsFromCoordinate(x, y)
            );
        }
        
        public function move(x:Number, y:Number):void
        {
            if (m_drawing) {
                commitCommand(
                    m_logger.getCommand(LineToCommand.ID),
                    getArgumentsFromCoordinate(x, y)
                );
            }
        }
        
        public function stop(x:Number, y:Number):void
        {
            if (m_drawing) {
                if (!m_drawingLine) {
                    var pen:Pen = m_recorder.painter.pen;
                    var tempAlpha:Number = pen.alpha;
                    commitCommand(
                        m_logger.getCommand(PenCommand.ID),
                        {
                            "type": PenCommand.ALPHA,
                            "alpha": 0
                        }
                    );
                    commitCommand(
                        m_logger.getCommand(BeginFillCommand.ID),
                        {
                            "color": pen.color,
                            "alpha": tempAlpha
                        }
                    );
                    commitCommand(
                        m_logger.getCommand(DrawCircleCommand.ID),
                        { "radius": pen.thickness / 2 }
                    );
                    commitCommand(m_logger.getCommand(EndFillCommand.ID), {});
                    commitCommand(
                        m_logger.getCommand(PenCommand.ID),
                        {
                            "type": PenCommand.ALPHA,
                            "alpha": tempAlpha
                        }
                    );
                }
                commitCommand(
                    m_logger.getCommand(CompositeCommand.ID),
                    {}
                );
                m_drawing = false;
            }
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            move(x, y);
            stop(x, y);
        }
    }
}