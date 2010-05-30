package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class CreateLayerCommand implements ICommand
    {
        public static const ID:uint = 14;
        
        public function CreateLayerCommand()
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
            painter.layers.add();
            painter.pushUndo();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[CreateLayerCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}