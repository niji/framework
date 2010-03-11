package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class BeginFillCommand implements ICommand
    {
        public static const ID:uint = 7;
        
        public function BeginFillCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_color = bytes.readUnsignedInt();
            m_alpha = bytes.readDouble();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var color:uint = args.color;
            var alpha:Number = args.alpha;
            bytes.writeByte(commandID);
            bytes.writeUnsignedInt(color);
            bytes.writeDouble(alpha);
            m_color = color;
            m_alpha = alpha;
        }
        
        public function execute(painter:Painter):void
        {
            painter.beginFill(m_color, m_alpha);
        }
        
        public function reset():void
        {
            m_color = 0;
            m_alpha = 0;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_color:uint;
        private var m_alpha:Number;
    }
}