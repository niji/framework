package org.libspark.gunyarapaint.framework.modules
{
    import flash.geom.Rectangle;
    
    import org.libspark.gunyarapaint.framework.Recorder;
    import org.libspark.gunyarapaint.framework.commands.CompositeCommand;
    import org.libspark.gunyarapaint.framework.commands.DrawCircleCommand;
    import org.libspark.gunyarapaint.framework.commands.MoveToCommand;
    
    /**
     * 円描写ツールの実装
     */
    public final class CircleModule extends CanvasModule implements ICanvasModule
    {
        public static const CIRCLE:String = PREFIX + "circle";
        
        public function CircleModule(recorder:Recorder)
        {
            m_rectangle = new Rectangle(0, 0, 0, 0);
            super(recorder);
        }
        
        /**
         * @inheritDoc
         */
        public function start(x:Number, y:Number):void
        {
            validateLayerState();
            setCoordinate(x, y);
            m_recorder.startDrawing();
        }
        
        /**
         * @inheritDoc
         */
        public function move(x:Number, y:Number):void
        {
            storeCircleCoordinate(x, y);
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.moveTo(m_rectangle.x, m_rectangle.y);
            m_recorder.drawCircle(m_rectangle.width);
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                storeCircleCoordinate(x, y);
                m_recorder.commitCommand(
                    MoveToCommand.ID,
                    getArgumentsFromCoordinate(m_rectangle.x, m_rectangle.y)
                );
                m_recorder.commitCommand(
                    DrawCircleCommand.ID,
                    { "radius": m_rectangle.width }
                );
                m_recorder.commitCommand(
                    CompositeCommand.ID,
                    {}
                );
            }
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return CIRCLE;
        }
        
        private function storeCircleCoordinate(x:Number, y:Number):void
        {
            var dx:Number = x - coordinateX;
            var dy:Number = y - coordinateY;
            if (getShouldDrawCircleClockwise()) {
                m_rectangle.x = x + dy;
                m_rectangle.y = y - dx;
            }
            else if (getShouldDrawCircleCounterClockwise()) {
                m_rectangle.x = x - dy;
                m_rectangle.y = y + dx;
            }
            else {
                m_rectangle.x = coordinateX;
                m_rectangle.y = coordinateY;
            }
            m_rectangle.width = Math.sqrt(dx * dx + dy * dy);
        }
        
        private var m_rectangle:Rectangle;
    }
}