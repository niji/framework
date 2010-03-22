package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class HorizontalMirrorCommand implements ICommand
    {
        public static const ID:uint = 24;
        
        public function HorizontalMirrorCommand()
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
        
        public function execute(painter:Painter):void
        {
            painter.transformWithHorizontalMirrorAt(m_index);
        }
        
        public function reset():void
        {
            m_index = 0;
        }
        
        public function toString():String
        {
            return "[HorizontalMirrorCommand"
                + " index=" + m_index
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_index:int;
    }
}