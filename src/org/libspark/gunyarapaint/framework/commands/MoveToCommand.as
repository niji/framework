package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
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
            readCoordinate.x += x;
            readCoordinate.y += y;
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var dx:int = args.x - writeCoordinate.x;
            var dy:int = args.y - writeCoordinate.y;
            if (dx >= -64 && dx <= 63 && dy >= -64 && dy <= 63) {
                // dxもdyも7bitに収まる場合
                bytes.writeShort(0x4000 | (dx << 7) & 0x3f80 | dy & 0x7f);
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
            canvas.painter.moveTo(
                readCoordinate.x || writeCoordinate.x,
                readCoordinate.y || writeCoordinate.y
            );
            canvas.painter.startDrawingSession();
        }
        
        public function get commandID():uint
        {
            return ID;
        }
    }
}