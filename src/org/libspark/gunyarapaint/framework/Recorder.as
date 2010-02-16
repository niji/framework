package org.libspark.gunyarapaint
{
    import flash.utils.ByteArray;

    public final class Recorder extends CanvasContext
    {
        public static const DEFAULT_UNDO_MAX:uint = 16;
        
        public function Recorder()
        {
            super();
            var bytes:ByteArray = new ByteArray();
            m_logger = new Logger(bytes);
        }
        
        public function prepare(width:int, height:int, undo:int):void
        {
            m_width = width;
            m_height = height;
            m_logger.writeHeader(PAINTER_LOG_VERSION, width, height, undo);
            m_logger.loadCommands();
            createPainter(width, height, undo);
            m_undo = new UndoStack(m_painter, undo);
        }
        
        public function get logger():Logger
        {
            return m_logger;
        }
        
        private var m_logger:Logger;
    }
}