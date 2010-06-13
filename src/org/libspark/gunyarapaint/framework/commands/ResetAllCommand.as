package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     */
    public final class ResetAllCommand implements ICommand
    {
        public static const ID:uint = 30;
        
        public function ResetAllCommand()
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
            LineCommand.resetCoordinates();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[ResetAllCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}
