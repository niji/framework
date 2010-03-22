package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class MergeLayerCommand implements ICommand
    {
        public static const ID:uint = 17;
        
        public function MergeLayerCommand()
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
            painter.layers.merge();
            painter.pushUndoIfNeed();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[MergeLayerCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}