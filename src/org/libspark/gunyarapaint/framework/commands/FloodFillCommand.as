package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
    /**
     * @private
     * 
     */
    public final class FloodFillCommand implements ICommand
    {
        public static const ID:uint = 13;
        
        public function FloodFillCommand()
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
            canvas.painter.floodFill();
            canvas.pushUndo();
            canvas.painter.stopDrawingSession();
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