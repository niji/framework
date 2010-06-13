package org.libspark.gunyarapaint.framework.events
{
    import flash.events.Event;

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
        
        public function UndoEvent(type:String)
        {
            super(type, false, false);
        }
        
        /**
         * @inheritDoc
         */
        public override function clone():Event
        {
            return new UndoEvent(type);
        }
    }
}
