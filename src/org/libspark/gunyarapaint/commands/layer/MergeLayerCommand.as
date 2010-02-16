package org.libspark.gunyarapaint.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.CanvasContext;
    import org.libspark.gunyarapaint.commands.ICommand;
    
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
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.layers.merge();
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