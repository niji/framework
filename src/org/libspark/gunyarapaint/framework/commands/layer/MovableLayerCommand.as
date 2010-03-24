package org.libspark.gunyarapaint.framework.commands.layer
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.Painter;

    internal class MovableLayerCommand
    {
        public function MovableLayerCommand()
        {
            reset();
        }
        
        public function read(bytes:ByteArray):void
        {
            m_coordinateX = bytes.readShort();
            m_coordinateY = bytes.readShort();
        }
        
        public function write(bytes:ByteArray, args:Object):void
        {
            var x:int = args.x;
            var y:int = args.y;
            bytes.writeByte(commandID);
            bytes.writeShort(x);
            bytes.writeShort(y);
            m_coordinateX = x;
            m_coordinateY = y;
        }
        
        public function reset():void
        {
            m_coordinateX = 0;
            m_coordinateY = 0;
        }
        
        public function get commandID():uint
        {
            return 0;
        }
        
        protected var m_coordinateX:int;
        protected var m_coordinateY:int;
    }
}
