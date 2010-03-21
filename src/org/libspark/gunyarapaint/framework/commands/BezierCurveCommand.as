package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class BezierCurveCommand implements ICommand
    {
        public static const ID:uint = 28;
        
        public function BezierCurveCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_anchorX = bytes.readShort();
            m_anchorY = bytes.readShort();
            m_controlX = bytes.readShort();
            m_controlY = bytes.readShort();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var anchorX:int = args.anchorX;
            var anchorY:int = args.anchorY;
            var controlX:int = args.controlX;
            var controlY:int = args.controlY;
            bytes.writeByte(commandID);
            bytes.writeShort(anchorX);
            bytes.writeShort(anchorY);
            bytes.writeShort(controlX);
            bytes.writeShort(controlY);
            m_anchorX = anchorX;
            m_anchorY = anchorY;
            m_controlX = controlX;
            m_controlY = controlY;
        }
        
        public function execute(painter:Painter):void
        {
            // TODO: implement this
        }
        
        public function reset():void
        {
            m_anchorX = 0;
            m_anchorY = 0;
            m_controlX = 0;
            m_controlY = 0;
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_anchorX:int;
        private var m_anchorY:int;
        private var m_controlX:int;
        private var m_controlY:int;
    }
}
