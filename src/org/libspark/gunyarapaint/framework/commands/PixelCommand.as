package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
    public final class PixelCommand implements ICommand
    {
        public static const ID:uint = 23;
        
        public function PixelCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_x = Math.floor(bytes.readShort());
            m_y = Math.floor(bytes.readShort());
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var x:int = Math.floor(args.x);
            var y:int = Math.floor(args.y);
            bytes.writeByte(commandID);
            bytes.writeShort(x);
            bytes.writeShort(y);
            m_x = x;
            m_y = y;
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.setPixel(m_x, m_y);
            canvas.pushUndo();
        }
        
        public function reset():void
        {
            m_x = 0;
            m_y = 0;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_x:int;
        private var m_y:int;
    }
}