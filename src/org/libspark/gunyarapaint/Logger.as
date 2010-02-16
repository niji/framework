package org.libspark.gunyarapaint
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import org.libspark.gunyarapaint.commands.ICommand;
    import org.libspark.gunyarapaint.commands.LineToCommand;
    import org.libspark.gunyarapaint.commands.MoveToCommand;

    public final class Logger extends CommandCollection
    {
        public function Logger(bytes:ByteArray)
        {
            super();
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            m_bytes = bytes;
        }
        
        public function writeHeader(version:uint, width:uint, height:uint, undo:uint):void
        {
            var signature:String = "GUNYARA_PAINT:"
                + (version / 100)         + ":"
                + ((version % 100) / 10)  + ":"
                + (version % 10)          + ":"
            m_bytes.writeUTFBytes(signature);
            m_bytes.writeShort(width);
            m_bytes.writeShort(height);
            m_bytes.writeShort(undo);
        }
        
        public function getCommand(id:uint):ICommand
        {
            if (id & 0x80 || id & 0x40) {
                throw new ArgumentError();
            }
            else {
                return m_commands[id];
            }
        }
        
        /**
         * ログデータそのものを返す
         * 
         * @return ログデータ
         */
        public function get bytes():ByteArray
        {
            return m_bytes;
        }
        
        private var m_bytes:ByteArray;
        private var m_version:uint;
    }
}