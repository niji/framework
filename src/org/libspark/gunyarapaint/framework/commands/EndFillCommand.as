package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class EndFillCommand implements ICommand
    {
        public static const ID:uint = 8;
        
        public function EndFillCommand()
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
            painter.endFill();
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