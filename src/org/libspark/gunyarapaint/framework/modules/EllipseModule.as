package org.libspark.gunyarapaint.framework.modules
{
    import org.libspark.gunyarapaint.framework.Recorder;
    
    /**
     * 楕円描写ツールの実装
     */
    public final class EllipseModule extends CanvasModule implements ICanvasModule
    {
        public static const ELLIPSE:String = PREFIX + "ellipse";
        
        public function EllipseModule(recorder:Recorder)
        {
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
            m_recorder.clear();
            m_recorder.resetPen();
            m_recorder.drawEllipse(
                coordinateX,
                coordinateY,
                Math.abs(x - coordinateX),
                Math.abs(y - coordinateY)
            );
        }
        
        /**
         * @inheritDoc
         */
        public function stop(x:Number, y:Number):void
        {
            m_recorder.stopDrawing();
            if (!equalsCoordinate(x, y)) {
                // TODO: implement this
            }
            saveCoordinate(x, y);
        }
        
        /**
         * @inheritDoc
         */
        public function get name():String
        {
            return ELLIPSE;
        }
        
        public function interrupt(x:Number, y:Number):void
        {
            stopDrawing();
        }
    }
}