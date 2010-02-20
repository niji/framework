package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
    public final class LineToCommand extends LineCommand implements ICommand
    {
        public static const ID:uint = 2;
        
        public function LineToCommand()
        {
            super();
        }
        
        public function read(bytes:ByteArray):void
        {
            var x:int = 0;
            var y:int = 0;
            if (m_compressedValue > 0) {
                if (m_compressedValue & 0x40) {
                    bytes.position -= 1;
                    var short:uint = bytes.readShort();
                    x = (short << 18) >> 25;
                    y = (short << 25) >> 25;
                }
                else {
                    x = (m_compressedValue << 26) >> 29;
                    y = (m_compressedValue << 29) >> 29;
                }
                m_compressedValue = 0;
            }
            else {
                x = bytes.readShort();
                y = bytes.readShort();
            }
            readCoordinate.x += x;
            readCoordinate.y += y;
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var dx:int = args.x - writeCoordinate.x;
            var dy:int = args.y - writeCoordinate.y;
            if (dx >= -4 && dx <= 3 && dy >= -4 && dy <= 3) {
                // dxもdyも3bitに収まる場合
                bytes.writeByte(0x80 | (dx << 3) & 0x38 | dy & 0x7);
            }
            else if (dx >= -64 && dx <= 63 && dy >= -64 && dy <= 63) {
                // dxもdyも7bitに収まる場合
                bytes.writeShort(0xc000 | (dx << 7) & 0x3f80 | dy & 0x7f);
            }
            else {
                bytes.writeByte(commandID);
                bytes.writeShort(dx);
                bytes.writeShort(dy);
            }
            writeCoordinate.x = args.x;
            writeCoordinate.y = args.y;
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.lineTo(
                readCoordinate.x || writeCoordinate.x,
                readCoordinate.y || writeCoordinate.y
            );
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}