package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
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
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.layers.copy();
            canvas.pushUndoIfNeed();
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