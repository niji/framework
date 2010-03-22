package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
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
        
        public function execute(painter:Painter):void
        {
            painter.floodFill();
            painter.pushUndo();
            painter.stopDrawingSession();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[FloodFillCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}