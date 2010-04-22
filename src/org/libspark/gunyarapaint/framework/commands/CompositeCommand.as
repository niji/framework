package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
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
        
        public function execute(painter:Painter):void
        {
            painter.composite();
            painter.pushUndo();
            painter.stopDrawing();
        }
        
        public function reset():void
        {
        }
        
        public function toString():String
        {
            return "[CompositeCommand]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}