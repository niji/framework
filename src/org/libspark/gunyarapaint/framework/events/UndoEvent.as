package org.libspark.gunyarapaint.framework.events
{
    /**
     * やり直しまたは巻き戻し関連のイベント
     * 
     */
    public final class UndoEvent extends AbstractEvent
    {
        /**
         * やり直しした後
         * 
         */
        public static const UNDO:String = PREFIX + "undo";
        
        /**
         * 巻き戻しした後
         * 
         */
        public static const REDO:String = PREFIX + "redo";
        
        /**
         * アンドゥを管理するオブジェクトに情報が積まれた後
         * 
         */
        public static const PUSH:String = PREFIX + "push";
        
        public function UndoEvent(type:String, undoCount:int, redoCount:int)
        {
            m_undoCount = undoCount;
            m_redoCount = redoCount;
            super(type, false, false);
        }
        
        /**
         * やり直しが出来る回数を取得する
         * 
         */
        public function get undoCount():int
        {
            return m_undoCount;
        }
        
        /**
         * 巻き戻しが出来る回数を取得する
         * 
         */
        public function get redoCount():int
        {
            return m_redoCount;
        }
        
        private var m_undoCount:int;
        private var m_redoCount:int;
    }
}
