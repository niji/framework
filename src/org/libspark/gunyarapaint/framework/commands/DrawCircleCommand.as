package org.libspark.gunyarapaint.framework.commands
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.CanvasContext;
    
    public final class DrawCircleCommand implements ICommand
    {
        public static const ID:uint = 10;
        
        public function DrawCircleCommand()
        {
        }
        
        public function read(bytes:ByteArray):void
        {
            m_radius = bytes.readDouble();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var radius:Number = args.radius;
            bytes.writeByte(commandID);
            bytes.writeDouble(radius);
            m_radius = radius;
        }
        
        public function execute(canvas:CanvasContext):void
        {
            canvas.painter.drawCircle(m_radius);
        }
        
        public function reset():void
        {
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_radius:Number;
    }
}