package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class CopyLayerCommand implements ICommand
    {
        public static const ID:uint = 15;
        
        public function CopyLayerCommand()
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
            painter.layers.copy();
            painter.pushUndoIfNeed();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[CopyLayerCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}