package org.libspark.gunyarapaint.framework
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.events.CommandEvent;

    public final class Recorder extends CanvasContext
    {
        public static const DEFAULT_UNDO_MAX:uint = 16;
        
        public function Recorder(bytes:ByteArray, commands:CommandCollection = null)
        {
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            m_bytes = bytes;
            m_command = commands ? commands : new CommandCollection();
            super();
        }
        
        /**
         * 画像の大きさを設定し、ヘッダーに書き込む
         * 
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param undo やり直しできる回数
         */
        public function prepare(width:int, height:int, undo:int):void
        {
            m_command.loadCommands();
            writeHeader(PAINTER_LOG_VERSION, width, height, undo);
            createPainter(width, height, undo);
            setUndo(new UndoStack(painter, undo));
        }
        
        /**
         * ログヘッダーを書き出す
         * 
         * @param version ログのバージョン番号
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param undo やり直しできる回数
         */
        private function writeHeader(version:uint, width:uint, height:uint, undo:uint):void
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
        
        /**
         * コマンドの書き出し及び実行を同時に行う
         * 
         * @param command コマンドオブジェクト
         * @param args コマンドに対する引数
         */
        public function commitCommand(id:uint, args:Object):void
        {
            var command:ICommand = m_command.getCommand(id);
            command.write(m_bytes, args);
            command.execute(this);
            if (hasEventListener(CommandEvent.COMMITTED))
                dispatchEvent(new CommandEvent(CommandEvent.COMMITTED, command));
        }
        
        private var m_command:CommandCollection;
        private var m_bytes:ByteArray;
    }
}
