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
    public final class Recorder extends CanvasContext
    {
        /**
         * やり直し可能な回数の初期値
         * 
         */
        public static const DEFAULT_UNDO_MAX:uint = 16;
        
        public function Recorder(width:uint, height:uint, bytes:ByteArray, commands:CommandCollection)
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
        public static function create(width:int, height:int, undo:int):Recorder
        {
            var bytes:ByteArray = new ByteArray();
            var commands:CommandCollection = new CommandCollection();
            var version:uint = PAINTER_LOG_VERSION;
            commands.loadCommands();
            bytes.endian = Endian.BIG_ENDIAN;
            bytes.position = 0;
            var signature:String = "GUNYARA_PAINT:"
                + (version / 100)         + ":"
                + ((version % 100) / 10)  + ":"
                + (version % 10)          + ":"
            bytes.writeUTFBytes(signature);
            bytes.writeShort(width);
            bytes.writeShort(height);
            bytes.writeShort(undo);
            var recorder:Recorder = new Recorder(width, height, bytes, commands);
            recorder.setUndo(new UndoStack(recorder, undo));
            return recorder;
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
