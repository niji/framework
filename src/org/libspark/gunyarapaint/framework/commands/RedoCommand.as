package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class RedoCommand implements ICommand
    {
        public static const ID:uint = 6;
        
        public function RedoCommand()
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
            painter.redo();
        }
        
        public function reset():void
        {
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}