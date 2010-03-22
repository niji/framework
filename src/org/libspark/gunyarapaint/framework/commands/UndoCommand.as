package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class UndoCommand implements ICommand
    {
        public static const ID:uint = 5;
        
        public function UndoCommand()
        {
        }
        
        public function read(bytes:ByteArray):void
        {
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            bytes.writeByte(commandID);
        }
        
        public function execute(painter:Painter):void
        {
            painter.undo();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[UndoCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}
