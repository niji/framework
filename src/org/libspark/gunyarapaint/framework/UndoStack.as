package org.libspark.gunyarapaint.framework
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    import org.libspark.gunyarapaint.framework.errors.RedoError;
    import org.libspark.gunyarapaint.framework.errors.UndoError;
    
    /**
     * アンドゥを管理する
     * 
     */
    internal final class UndoStack
    {
        public function UndoStack(painter:Painter,
                                  size:uint = 16)
        {
            m_buffer = new Vector.<Object>(size + 1, true);
            m_index = 0;
            m_first = 0;
            m_last = 0;
            m_buffer[i] = painter.undo;
            for (var i:uint = 1; i < size + 1; i++) {
                m_buffer[i] = null;
            }
        }
        
        public function undo(painter:Painter):void
        {
            if (m_index === m_first) {
                throw new UndoError();
            }
            else if (m_index === 0) {
                m_index = m_buffer.length - 1;
            }
            else {
                m_index--;
            }
            painter.undo = m_buffer[m_index];
        }
        
        public function redo(painter:Painter):void
        {
            if (m_index === m_last) {
                throw new RedoError();
            }
            m_index = (m_index + 1) % m_buffer.length;
            painter.undo = m_buffer[m_index];
        }
        
        public function push(painter:Painter):void
        {
            m_index = (m_index + 1) % m_buffer.length;
            m_buffer[m_index] = painter.undo;
            m_last = m_index;
            if (m_index === m_first) {
                m_first = (m_first + 1) % m_buffer.length;
            }
        }
        
        public function get undoCount():uint
        {
            var count:int = m_index - m_first;
            return count < 0 ? count + m_buffer.length : count;
        }
        
        public function get redoCount():uint
        {
            var count:int = m_last - m_index;
            return count < 0 ? count + m_buffer.length : count;
        }
        
        private var m_buffer:Vector.<Object>;
        private var m_index:uint;
        private var m_first:uint;
        private var m_last:uint;
    }
}