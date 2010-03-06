package org.libspark.gunyarapaint.framework.events
{
    public final class UndoEvent extends AbstractEvent
    {
        public static const UNDO:String = PREFIX + "undo";
        
        public static const REDO:String = PREFIX + "redo";
        
        public static const PUSH:String = PREFIX + "push";
        
        public function UndoEvent(type:String, undoCount:int, redoCount:int)
        {
            m_undoCount = undoCount;
            m_redoCount = redoCount;
            super(type, false, false);
        }
        
        public function get undoCount():int
        {
            return m_undoCount;
        }
        
        public function get redoCount():int
        {
            return m_redoCount;
        }
        
        private var m_undoCount:int;
        private var m_redoCount:int;
    }
}
