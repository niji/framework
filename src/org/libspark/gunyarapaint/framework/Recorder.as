package org.libspark.gunyarapaint.framework
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;
    import org.libspark.gunyarapaint.framework.events.CommandEvent;
    
    /**
     * ログを記録する
     * 
     */
    public final class Recorder extends Painter
    {
        /**
         * やり直し可能な回数の初期値
         * 
         */
        public static const DEFAULT_UNDO_MAX:uint = 16;
        
        public function Recorder(bytes:ByteArray, width:uint, height:uint, commands:CommandContext)
        {
            m_bytes = bytes;
            m_command = commands;
            var version:uint = PAINTER_LOG_VERSION;
            super(width, height, version, createPaintEngine(version));
        }
        
        /**
         * 画像の大きさを設定し、ヘッダーに書き込む
         * 
         * @param width 画像の幅
         * @param height 画像の高さ
         * @param undo やり直しできる回数
         */
        public static function create(bytes:ByteArray, width:int, height:int, undo:int):Recorder
        {
            var commands:CommandContext = new CommandContext();
            var version:uint = PAINTER_LOG_VERSION;
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            var signature:String = "GUNYARA_PAINT:"
                + uint(version / 100)         + "."
                + uint((version % 100) / 10)  + "."
                + uint(version % 10)          + ":"
            bytes.writeUTFBytes(signature);
            bytes.writeShort(width);
            bytes.writeShort(height);
            bytes.writeShort(undo);
            var recorder:Recorder = new Recorder(bytes, width, height, commands);
            recorder.setUndoStack(new UndoStack(recorder.layers, undo));
            return recorder;
        }
        
        /**
         * コマンドの書き出し及び実行を同時に行う
         * 
         * @param command コマンドオブジェクト
         * @param args コマンドに対する引数
         * @eventType CommandEvent.COMMITTED
         */
        public function commitCommand(id:uint, args:Object):void
        {
            var command:ICommand = m_command.getCommand(id);
            command.write(m_bytes, args);
            command.execute(this);
            if (hasEventListener(CommandEvent.COMMITTED))
                dispatchEvent(new CommandEvent(CommandEvent.COMMITTED, command));
        }
        
        /**
         * 現在のログデータをコピーして返す
         */
        public function get bytes():ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            var pos:uint = m_bytes.position;
            bytes.writeBytes(m_bytes);
            bytes.compress();
            m_bytes.position = pos;
            return bytes;
        }
        
        private var m_command:CommandContext;
        private var m_bytes:ByteArray;
    }
}
