package org.libspark.gunyarapaint.framework.modules
{
    import flash.geom.Rectangle;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    internal final class CircleModule extends DrawModule implements IDrawable
    {
        public function CircleModule(recorder:Recorder)
        {
            super(recorder);
        }
        
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.painter.startDrawingSession();
            m_drawing = true;
        }
        
        public function move(x:Number, y:Number):void
        {
            if (m_drawing) {
                var painter:Painter = m_recorder.painter;
                storeCircleCoordinate(x, y);
                painter.clear();
                painter.resetPen();
                painter.moveTo(s_rectangle.x, s_rectangle.y);
                painter.drawCircle(s_rectangle.width);
            }
        }
        
        public function stop(x:Number, y:Number):void
        {
            if (m_drawing) {
                m_recorder.painter.stopDrawingSession();
                if (!equalsCoordinate(x, y)) {
                    storeCircleCoordinate(x, y);
                    m_recorder.commitCommand(
                        MoveToCommand.ID,
                        getArgumentsFromCoordinate(s_rectangle.x, s_rectangle.y)
                    );
                    m_recorder.commitCommand(
                        DrawCircleCommand.ID,
                        { "radius": s_rectangle.width }
                    );
                    m_recorder.commitCommand(
                        CompositeCommand.ID,
                        {}
                    );
                }
                m_drawing = false;
            }
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        public function get name():String
        {
            return DrawModuleFactory.CIRCLE;
        }
        
        protected function storeCircleCoordinate(x:Number, y:Number):void
        {
            var dx:Number = x - coordinateX;
            var dy:Number = y - coordinateY;
            if (key_A) {
                s_rectangle.x = x + dx;
                s_rectangle.y = y - dy;
            }
            else if (key_Q) {
                s_rectangle.x = x - dx;
                s_rectangle.y = x + dy;
            }
            else {
                s_rectangle.x = coordinateX;
                s_rectangle.y = coordinateY;
            }
            s_rectangle.width = Math.sqrt(dx * dx + dy * dy);
            s_rectangle.height = 0;
        }
        
        private static var s_rectangle:Rectangle = new Rectangle();
    }
}