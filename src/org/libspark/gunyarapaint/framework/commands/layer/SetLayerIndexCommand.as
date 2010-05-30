package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
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
        
        public function execute(painter:Painter):void
        {
            painter.layers.currentIndex = m_index;
			painter.pushUndoIfNeed();
        }
        
        public function reset():void
        {
            m_index = 0;
        }
        
        public function toString():String
        {
            return "[SetLayerIndexCommand"
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