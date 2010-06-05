package org.libspark.gunyarapaint.framework.commands
{
    import flash.errors.IllegalOperationError;
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class CompatibilityCommand implements ICommand
    {
        public static const ID:uint = 29;
        
        public function CompatibilityCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_type = bytes.readUnsignedByte();
            m_value = bytes.readBoolean();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var type:uint = args.type;
            var value:Boolean = args.value;
            bytes.writeByte(commandID);
            bytes.writeByte(type);
            bytes.writeBoolean(value);
            m_type = type;
            m_value = value;
        }
        
        public function execute(painter:Painter):void
        {
            switch (m_type) {
                case Painter.COMPATIBILITY_UNDO_LAYER:
                    painter.enableUndoLayer = m_value;
                    break;
                case Painter.COMPATIBILITY_BIG_PIXEL:
                    painter.enableBigPixel = m_value;
                    break;
                default:
                    throw new ArgumentError();
                    break;
            }
        }
        
        public function reset():void
        {
            m_type = 0;
            m_value = false;
        }
        
        public function toString():String
        {
            var ret:String = "[CompatibilityCommand ";
            switch (m_type) {
                case Painter.COMPATIBILITY_UNDO_LAYER:
                    ret += "undoLayer=";
                    break;
                case Painter.COMPATIBILITY_BIG_PIXEL:
                    ret += "bigPixel=";
                    break;
                default:
                    throw new IllegalOperationError();
            }
            ret += m_value + "]";
            return ret;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_type:uint;
        private var m_value:Boolean;
    }
}
