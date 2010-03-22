package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class SetLayerVisibleCommand implements ICommand
    {
        public static const ID:uint = 20;
        
        public function SetLayerVisibleCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_index = bytes.readUnsignedByte();
            m_visible = bytes.readBoolean();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var index:int = args.index;
            var visible:Boolean = args.visible;
            bytes.writeByte(commandID);
            bytes.writeByte(index);
            bytes.writeBoolean(visible);
            m_index = index;
            m_visible = visible;
        }
        
        public function execute(painter:Painter):void
        {
            painter.layers.at(m_index).visible = m_visible;
            painter.pushUndoIfNeed();
        }
        
        public function reset():void
        {
            m_index = 0;
            m_visible = true;
        }
        
        public function toString():String
        {
            return "[SetLayerVisibleCommand"
                + " index=" + m_index
                + ", visible=" + m_visible
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_index:uint;
        private var m_visible:Boolean;
    }
}