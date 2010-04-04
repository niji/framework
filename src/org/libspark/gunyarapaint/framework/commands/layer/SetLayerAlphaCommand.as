package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class SetLayerAlphaCommand implements ICommand
    {
        public static const ID:uint = 22;
        
        public function SetLayerAlphaCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_alpha = bytes.readDouble();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var alpha:Number = args.alpha;
            if (m_alpha !== alpha) {
                bytes.writeByte(commandID);
                bytes.writeDouble(alpha);
                m_alpha = alpha;
            }
        }
        
        public function execute(painter:Painter):void
        {
            painter.currentLayerAlpha = m_alpha;
            painter.pushUndo();
        }
        
        public function reset():void
        {
            m_alpha = 0;
        }
        
        public function toString():String
        {
            return "[SetLayerAlphaCommand"
                + " alpha=" + m_alpha.toPrecision(4)
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_alpha:Number;
    }
}