package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
    /**
     * @private
     * 
     */
    public final class CompositeCommand implements ICommand
    {
        public static const ID:uint = 4;
        
        public function CompositeCommand()
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
            canvas.composite();
            canvas.pushUndo();
            canvas.stopDrawingSession();
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