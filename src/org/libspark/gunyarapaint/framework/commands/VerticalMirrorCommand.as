package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
    public final class VerticalMirrorCommand implements ICommand
    {
        public static const ID:uint = 25;
        
        public function VerticalMirrorCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_index = bytes.readUnsignedByte();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var index:int = args.index;
            bytes.writeByte(commandID);
            bytes.writeByte(index);
            m_index = index;
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.transformWithVerticalMirrorAt(m_index);
        }
        
        public function reset():void
        {
            m_index = 0;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_index:int;
    }
}