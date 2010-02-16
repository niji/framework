package org.libspark.gunyarapaint.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.CanvasContext;
    import org.libspark.gunyarapaint.commands.ICommand;
    
    public final class SetLayerIndexCommand implements ICommand
    {
        public static const ID:uint = 19;
        
        public function SetLayerIndexCommand()
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
            if (m_index !== index) {
                bytes.writeByte(commandID);
                bytes.writeByte(index);
                m_index = index;
            }
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.layers.currentIndex = m_index;
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