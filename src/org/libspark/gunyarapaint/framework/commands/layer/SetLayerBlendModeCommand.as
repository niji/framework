package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.display.BlendMode;
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    
    /**
     * @private
     * 
     */
    public final class SetLayerBlendModeCommand implements ICommand
    {
        public static const ID:uint = 21;
        
        public function SetLayerBlendModeCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_blendMode = bytes.readUTF();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var blendMode:String = args.blendMode;
            if (m_blendMode !== blendMode) {
                bytes.writeByte(commandID);
                bytes.writeUTF(blendMode);
                m_blendMode = blendMode;
            }
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.currentLayerBlendMode = m_blendMode;
            canvas.pushUndoIfNeed();
        }
        
        public function reset():void
        {
            m_blendMode = BlendMode.NORMAL;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_blendMode:String;
    }
}