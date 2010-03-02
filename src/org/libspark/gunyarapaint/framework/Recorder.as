package org.libspark.gunyarapaint.framework
{
    import flash.utils.ByteArray;
    
    import org.libspark.gunyarapaint.framework.commands.ICommand;

    public final class Recorder extends CanvasContext
    {
        public static const DEFAULT_UNDO_MAX:uint = 16;
        
        public function Recorder()
        {
            super();
            var bytes:ByteArray = new ByteArray();
            m_logger = new Logger(bytes);
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
            setWidth(width);
            setHeight(height);
            m_logger.writeHeader(PAINTER_LOG_VERSION, width, height, undo);
            m_logger.loadCommands();
            createPainter(width, height, undo);
            setUndo(new UndoStack(painter, undo));
        }
        
        /**
         * コマンドの書き出し及び実行を同時に行う
         * 
         * @param command コマンドオブジェクト
         * @param args コマンドに対する引数
         */
        public function commitCommand(id:uint, args:Object):void
        {
            var command:ICommand = m_logger.getCommand(id);
            command.write(m_logger.bytes, args);
            command.execute(this);
        }
        
        private var m_logger:Logger;
    }
}