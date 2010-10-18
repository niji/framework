package com.github.niji.framework.commands
{
    import com.github.niji.framework.Painter;
    
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    public class DrawRectangleCommand implements ICommand
    {
        public static const ID:uint = 9;
        
        public function DrawRectangleCommand()
        {
            reset();
        }
        
        public function read(bytes:IDataInput):void
        {
            m_width = bytes.readInt();
            m_height = bytes.readInt();
        }
        
        public function write(bytes:IDataOutput, args:Object):void
        {
            var width:int = args.width;
            var height:int = args.height;
            bytes.writeByte(commandID);
            bytes.writeInt(width);
            bytes.writeInt(height);
            m_width = width;
            m_height = height;
        }
        
        public function execute(painter:Painter):void
        {
            painter.drawRect(m_width, m_height);
        }
        
        public function reset():void
        {
            m_width = 0;
            m_height = 0;
        }
        
        public function toString():String
        {
            return "[DrawRectangleCommand width="
                + m_width + " height=" + m_height + "]";
        }
        
        public function get commandID():uint
        {
            return ID;
        }
        
        private var m_width:int;
        private var m_height:int;
    }
}
