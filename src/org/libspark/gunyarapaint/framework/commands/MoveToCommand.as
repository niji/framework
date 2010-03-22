package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;
    
    /**
     * @private
     * 
     */
    public final class MoveToCommand extends LineCommand implements ICommand
    {
        public static const ID:uint = 1;
        
        public function MoveToCommand()
        {
            super();
        }
        
        public function read(bytes:ByteArray):void
        {
            var x:int = 0;
            var y:int = 0;
            if (m_compressedValue) {
                bytes.position -= 1;
                var short:uint = bytes.readShort();
                x = (short << 18) >> 25;
                y = (short << 25) >> 25;
                m_compressedValue = 0;
            }
            else {
                x = bytes.readShort();
                y = bytes.readShort();
            }
            s_readCoordinateX += x;
            s_readCoordinateY += y;
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var dx:int = args.x - s_writeCoordinateX;
            var dy:int = args.y - s_writeCoordinateY;
            if (dx >= -64 && dx <= 63 && dy >= -64 && dy <= 63) {
                // dxもdyも7bitに収まる場合
                bytes.writeShort(0x4000 | (dx << 7) & 0x3f80 | dy & 0x7f);
            }
            else {
                bytes.writeByte(commandID);
                bytes.writeShort(dx);
                bytes.writeShort(dy);
            }
            s_writeCoordinateX = args.x;
            s_writeCoordinateY = args.y;
        }
        
        public function execute(painter:Painter):void
        {
            painter.moveTo(
                s_readCoordinateX || s_writeCoordinateX,
                s_readCoordinateY || s_writeCoordinateY
            );
            painter.startDrawingSession();
        }
        
        public function toString():String
        {
            return "[MoveToCommand"
                + " readCoordinateX=" + s_readCoordinateX
                + ", readCoordinateY=" + s_readCoordinateY
                + ", writeCoordinateX=" + s_writeCoordinateX
                + ", writeCoordinateY=" + s_writeCoordinateY
                + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}
