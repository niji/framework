package org.libspark.gunyarapaint.events
{
    public final class UndoEvent extends AbstractEvent
    {
        public static const UNDO:String = PREFIX + "undo";
        
        public static const REDO:String = PREFIX + "redo";
        
        public function UndoEvent(type:String)
        {
            super(type, false, false);
        }
    }
}
