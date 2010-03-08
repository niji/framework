package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class SwapLayerCommand implements ICommand
    {
        public static const ID:uint = 16;
        
        public function SwapLayerCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_from = bytes.readUnsignedByte();
            m_to = bytes.readUnsignedByte();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var from:int = args.from;
            var to:int = args.to;
            bytes.writeByte(commandID);
            bytes.writeByte(from);
            bytes.writeByte(to);
            m_from = from;
            m_to = to;
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.layers.swap(m_from, m_to);
            canvas.pushUndoIfNeed();
        }
        
        public function reset():void
        {
            m_from = 0;
            m_to = 0;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_from:int;
        private var m_to:int;
    }
}